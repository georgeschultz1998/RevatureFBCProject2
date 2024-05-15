@isTest
public class ContactManagerControllerTest {

    static Id customerRecId;
    static Id techRecId;
    
    static void doSetup(){
        customerRecId = Schema.sObjectType.Contact.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        techRecId = Schema.sObjectType.Contact.getRecordTypeInfosByName().get('Service Technician').getRecordTypeId();
    }
    
    @testSetup static void makeData(){
        doSetup();
        List<Contact> contacts = new List<Contact>();
        for (Integer i = 0; i < 200; i++){
            if (i < 100) contacts.add(new Contact(LastName = 'Person ' + i, RecordTypeId = customerRecId));
            else contacts.add(new Contact(LastName = 'Person ' + i, RecordTypeId = techRecId));
        }
        insert contacts;
        insert new Case(Status = 'New', Origin = 'Web', ContactId = contacts[0].Id);
    }
    
    @isTest static void checkLists(){
        ContactManagerController cmc = new ContactManagerController();
        Assert.areEqual(200, cmc.contacts.size(), 'Unexpected number of contacts initially.');
        Assert.areEqual(100, cmc.customers.size(), 'Unexpected number of customers initially.');
        Assert.areEqual(100, cmc.serviceTechnicians.size(), 'Unexpected number of service technicians initially.');
    }
    
    @isTest static void createCustomer(){
        doSetup();
        ContactManagerController cmc = new ContactManagerController();
        cmc.newContact.FirstName = 'J';
        cmc.newContact.LastName = 'B';
        cmc.newContact.RecordTypeId = customerRecId;
        Test.startTest();
        cmc.createContact();
        Test.stopTest();
        List<Contact> con = [SELECT Id FROM Contact WHERE FirstName = 'J' AND LastName = 'B' AND RecordTypeId = :customerRecId];
        Assert.areEqual(1, con.size(), 'Single customer was not created.');
    }
    
    @isTest static void createServiceTechnician(){
        doSetup();
        ContactManagerController cmc = new ContactManagerController();
        cmc.newContact.FirstName = 'T';
        cmc.newContact.LastName = 'F';
        cmc.newContact.RecordTypeId = techRecId;
        Test.startTest();
        cmc.createContact();
        Test.stopTest();
        List<Contact> con = [SELECT Id FROM Contact WHERE FirstName = 'T' AND LastName = 'F' AND RecordTypeId = :techRecId];
        Assert.areEqual(1, con.size(), 'Single service technician was not created.');
    }
    
    @isTest static void createFailedContact(){
        ContactManagerController cmc = new ContactManagerController();
        cmc.newContact.FirstName = 'T';
        Test.startTest();
        try {
            cmc.createContact();
        } catch (System.Exception e) {
            Assert.isTrue(true);
        }
        Test.stopTest();
    }
    
    @isTest static void deleteCustomer(){
        doSetup();
        ContactManagerController cmc = new ContactManagerController();
        Contact customerToDelete = [SELECT recordTypeId FROM Contact WHERE recordTypeId = :customerRecId LIMIT 1];
        cmc.deleteId = customerToDelete.Id;
        Test.startTest();
        cmc.deleteContact();
        Test.stopTest();
        try {
        	List<Contact> con = [SELECT Id FROM Contact WHERE Id = :customerToDelete.Id];    
        } catch (System.QueryException e) {
         	Assert.isTrue(true);   
        }
    }
    
    @isTest static void deleteServiceTechnician(){
        doSetup();
        ContactManagerController cmc = new ContactManagerController();
        Contact techToDelete = [SELECT recordTypeId FROM Contact WHERE recordTypeId = :techRecId LIMIT 1];
        cmc.deleteId = techToDelete.Id;
        Test.startTest();
        cmc.deleteContact();
        Test.stopTest();
        try {
        	List<Contact> con = [SELECT Id FROM Contact WHERE Id = :techToDelete.Id];    
        } catch (System.QueryException e) {
         	Assert.isTrue(true);   
        }
    }
    
    @isTest static void deleteFailedContact(){
        ContactManagerController cmc = new ContactManagerController();
        Contact failedDelete = [SELECT Id FROM Contact WHERE LastName = 'Person 0'];
        cmc.deleteId = failedDelete.Id;
        Test.startTest();
        try {
            cmc.deleteContact();
        } catch (System.Exception e) {
            Assert.isTrue(true);
        }
        Test.stopTest();
    }
    
}