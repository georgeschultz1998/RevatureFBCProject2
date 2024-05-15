@isTest
private class TestCreateUserContact {
    @isTest static void testInsertUserWithServiceTechnicianProfile() {
        // Arrange
        // Fetch the profile ID for "Service Technician"
        Profile techProfile = [SELECT Id FROM Profile WHERE Name = 'Service Technician' LIMIT 1];

        // Create a test user
         User newUser = new User(
            Alias = 'ttest',
            Email = 'test@example.com',
            EmailEncodingKey = 'UTF-8',
            FirstName = 'Test',
            LastName = 'Technician',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = techProfile.Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            Username = 'testtech' + System.currentTimeMillis() + '@example.com'
           // IsActive = true
        );

        // Act
        Test.startTest();
        insert newUser;
        Test.stopTest();

        // Assert
        // Verify that a contact has been created and linked to the user
        Contact[] contacts = [SELECT Id, FirstName, LastName FROM Contact WHERE FirstName = 'Test'];
        System.assert(!contacts.isEmpty(), 'Contact should be created for new Service Technician user');
    }
    
    @isTest static void testDeleteContactOnProfileChange() {
        // Arrange
        // Fetch the profile IDs
        Profile techProfile = [SELECT Id FROM Profile WHERE Name = 'Service Technician' LIMIT 1];
        Profile otherProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];

        // Create a test user with the Service Technician profile
        User techUser = new User(
            Alias = 'ttech',
            Email = 'techuser@example.com',
            EmailEncodingKey = 'UTF-8',
            FirstName = 'Tech',
            LastName = 'User',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = techProfile.Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            Username = 'techuser' + System.currentTimeMillis() + '@example.com'
        );

        insert techUser;

        // Create a contact linked to the technician user (simulate the trigger behavior)
        Contact techContact = new Contact(
            FirstName = techUser.FirstName,
            LastName = techUser.LastName,
            RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Service Technician').getRecordTypeId()
        );

        insert techContact;

        // Act
        Test.startTest();
        // Update the user's profile to a non-technician profile using Queueable to avoid MIXED_DML_OPERATION
        techUser.ProfileId = otherProfile.Id;
        System.enqueueJob(new UserUpdateQueueable(new List<User>{ techUser }));
        Test.stopTest();

        // Assert
        // Verify that the contact has been deleted
        Contact[] remainingContacts = [SELECT Id, FirstName, LastName FROM Contact WHERE FirstName = 'Test'];
        System.assert(remainingContacts.isEmpty(), 'Contact should be deleted when user profile changes from Service Technician');
    }
}