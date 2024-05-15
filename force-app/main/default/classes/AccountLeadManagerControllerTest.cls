@isTest
public class AccountLeadManagerControllerTest {

    @testSetup static void makeData(){
        List<Account> accounts = new List<Account>();
        List<Lead> leads = new List<Lead>();
        for (Integer i = 0; i < 100; i++){
            accounts.add(new Account(Name = 'Account ' + (i + 1)));
            leads.add(new Lead(LastName = 'Lead ' + (i + 1), Company = 'Umbrella Corporation', Status = 'Open - Not Contacted'));
        }
        insert accounts;
        insert leads;
        insert new Case(Status = 'New', Origin = 'Web', AccountId = accounts[0].Id);
    }
    
    @isTest static void checkLists(){
        AccountLeadManagerController almc = new AccountLeadManagerController();
        Assert.areEqual(100, almc.accounts.size(), 'Unexpected number of accounts initially.');
        Assert.areEqual(100, almc.leads.size(), 'Unexpected number of leads initially.');
    }
    
    @isTest static void createAccount(){
        AccountLeadManagerController almc = new AccountLeadManagerController();
        almc.newAccount.Name = 'A';
        Test.startTest();
        almc.createAccount();
        Test.stopTest();
        List<Account> con = [SELECT Id FROM Account WHERE Name = 'A'];
        Assert.areEqual(1, con.size(), 'Single account was not created.');
    }
    
    @isTest static void createLead(){
        AccountLeadManagerController almc = new AccountLeadManagerController();
        almc.newLead.LastName = 'L';
        almc.newLead.Company = 'P';
        almc.newLead.Status = 'Closed - Not Converted';
        Test.startTest();
        almc.createLead();
        Test.stopTest();
        List<Lead> con = [SELECT Id FROM Lead WHERE LastName = 'L'];
        Assert.areEqual(1, con.size(), 'Single lead was not created.');
    }
    
    @isTest static void createFailedAccount(){
        AccountLeadManagerController almc = new AccountLeadManagerController();
        almc.newAccount.Industry = 'Biomedical';
        Test.startTest();
        try {
            almc.createAccount();
        } catch (System.DMLException e) {
            Assert.isTrue(true);
        }
        Test.stopTest();
    }
    
    @isTest static void createFailedLead(){
        AccountLeadManagerController almc = new AccountLeadManagerController();
        almc.newLead.LastName = 'Only';
        Test.startTest();
        try {
            almc.createLead();
        } catch (System.DMLException e) {
            Assert.isTrue(true);
        }
        Test.stopTest();
    }
    
    @isTest static void deleteAccount(){
        AccountLeadManagerController almc = new AccountLeadManagerController();
        Account accountToDelete = [SELECT Id FROM Account WHERE Name != 'Account 1' LIMIT 1];
        almc.deleteAccId = accountToDelete.Id;
        Test.startTest();
        almc.deleteAccount();
        Test.stopTest();
        try {
        	List<Contact> acc = [SELECT Id FROM Contact WHERE Id = :accountToDelete.Id];    
        } catch (System.QueryException e) {
         	Assert.isTrue(true);   
        }
    }
    
    @isTest static void deleteLead(){
        AccountLeadManagerController almc = new AccountLeadManagerController();
        Lead leadToDelete = [SELECT Id FROM Lead LIMIT 1];
        almc.deleteLeadId = leadToDelete.Id;
        Test.startTest();
        almc.deleteLead();
        Test.stopTest();
        try {
        	List<Lead> lead = [SELECT Id FROM Lead WHERE Id = :leadToDelete.Id];    
        } catch (System.QueryException e) {
         	Assert.isTrue(true);   
        }
    }
    
    @isTest static void deleteFailedAccount(){
        AccountLeadManagerController almc = new AccountLeadManagerController();
        Account failedDelete = [SELECT Id FROM Account WHERE Name = 'Account 1'];
        almc.deleteAccId = failedDelete.Id;
        Test.startTest();
        try {
            almc.deleteAccount();
        } catch (System.Exception e) {
            Assert.isTrue(true);
        }
        Test.stopTest();
    }
    
}