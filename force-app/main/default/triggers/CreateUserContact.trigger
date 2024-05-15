trigger CreateUserContact on User (before insert, before update) {
    Map<Id, Contact> contactsToInsert = new Map<Id, Contact>();
    List<Contact> contactsToDelete = new List<Contact>();
    List<Id> userIdsToCheck = new List<Id>();

    // Query the Profile ID for "Service Technician"
    Profile techProfile;
    try {
        techProfile = [SELECT Id FROM Profile WHERE Name = 'Service Technician' LIMIT 1];
    } catch (QueryException e) {
        System.debug('Error fetching Service Technician profile: ' + e.getMessage());
        // Optionally, add error handling or terminate further execution
        return;
    }

    // Ensure the profile was found
    if (techProfile == null) {
        System.debug('No Service Technician profile found.');
        return;
    }
    String techProfileId = techProfile.Id;

    for (User user : Trigger.new) {
        // Handling users being inserted or users whose profile is being updated to the technician profile
        if ((Trigger.isInsert && user.ProfileId == techProfileId) ||
            (Trigger.isUpdate && user.ProfileId == techProfileId && Trigger.oldMap.get(user.Id).ProfileId != techProfileId)) {
            // Create new contact for new technician user or user who changed to technician profile
            Contact newContact = new Contact(
                FirstName = user.FirstName,
                LastName = user.LastName,
                RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Service Technician').getRecordTypeId()
                // Assuming you have a custom field on User to hold AccountId
                // AccountId = user.AccountId
            );
            contactsToInsert.put(user.Id, newContact);
        }
        // Handling users whose profile is being updated from the technician profile to another profile
        if (Trigger.isUpdate && user.ProfileId != techProfileId && Trigger.oldMap.get(user.Id).ProfileId == techProfileId) {
            // Add old technician contact for deletion if profile changes
            userIdsToCheck.add(user.Id);
        }
    }

    // Deleting contacts if the user profile has changed from technician to something else
    if (!userIdsToCheck.isEmpty()) {
        for (Contact con : [SELECT Id FROM Contact WHERE Id IN :userIdsToCheck]) {
            contactsToDelete.add(con);
        }
    }

    // Performing DML operations
    //if (!contactsToInsert.isEmpty()) {
    //    insert contactsToInsert.values();
    //}
 	if (!contactsToInsert.isEmpty()) {
    System.enqueueJob(new ContactInsertQueueable(contactsToInsert.values()));
	}
   
	//if (!contactsToInsert.isEmpty()) {
    //AsyncOperations.insertContacts(new Set<Id>(contactsToInsert.keySet()));
	//}

    if (!contactsToDelete.isEmpty()) {
        delete contactsToDelete;
    }
}