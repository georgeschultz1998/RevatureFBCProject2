@isTest
public class ContactHelper_Test {
	@isTest
    public static void myTestMethod(){
        // Create Account
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Contact con1 = new Contact(AccountId = testAccount.Id, Email = 'test@example.com');
        Contact con2 = new Contact(AccountId = testAccount.Id, Email = 'test2@example.net');
        Contact con3 = new Contact(AccountId = testAccount.Id, Email = 'test3@example.com');
        Contact con4 = new Contact(AccountId = testAccount.Id);
        insert new List<Contact>{con1, con2, con3, con4};

        Test.startTest();
        List<Contact> conList = [SELECT Id, AccountId, Email FROM Contact WHERE AccountId =:testAccount.Id];
        ContactHelper.checkEmail(conList);
        Test.stopTest();

        List<Contact> verifyCon = new List<Contact>();
        for (Contact con : conList){
            if(con.hasErrors()){
                verifyCon.add(con);
            }
        }

        System.assertEquals(1, verifyCon.size(), '1 contact should have error');
        System.assertEquals('Must be the same Domain as Account', verifyCon[0].getErrors().get(0).getMessage(), 'Incorrect error message');
    }
    /*
    @isTest
    public static void updateTest(){
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Contact con1 = new Contact(AccountId = testAccount.Id, Email = 'test@example.com');
        Contact con2 = new Contact(AccountId = testAccount.Id, Email = 'test2@example.net');
        Contact con3 = new Contact(AccountId = testAccount.Id, Email = 'test3@example.com');

        insert new List<Contact>{con1, con2, con3};
            
        con1.Email = 'test@example.net';
        con2.Email = 'test2@example.net';
        con3.Email = 'test3@example.net';
        
        Test.startTest();
        update new List<Contact>{con1, con2, con3};
        Test.stopTest();

        List<Contact> updatedContacts = [SELECT Id, AccountId, Email FROM Contact WHERE Id IN :new List<Id>{con1.Id, con2.Id, con3.Id}];

        for (Contact con : updatedContacts) {
            System.assertEquals(0, con.getErrors().size(), 'No errors should be present after update');

    }
    */
}