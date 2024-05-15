public class AccountLeadManagerController {
 	public List<Account> accounts { get; set; }
    public Account newAccount { get; set; }
    public String deleteAccId { get; set; }
    
    public List<Lead> leads { get; set; }
    public Lead newLead { get; set; }
    public String deleteLeadId { get; set; }
    
    public AccountLeadManagerController() {
        accounts = [SELECT Name, Phone, Industry FROM Account LIMIT 100];
        leads = [SELECT FirstName, LastName, Status, Company, Email, Phone FROM Lead LIMIT 100];
        newAccount = new Account();
        newLead = new Lead();
    }
    
    public PageReference createAccount() {
        try {
            insert newAccount;
            accounts.add(newAccount);
            newAccount = new Account();
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Account created successfully!'));
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: ' + e.getMessage()));
        }
        return null;
    }
    
    public PageReference deleteAccount() {
        try {
            Account accToDelete = [SELECT Name, Phone, Industry FROM Account WHERE Id = :deleteAccId LIMIT 1];
            delete accToDelete;
            accounts.remove(accounts.indexOf(accToDelete));

            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Account deleted successfully!'));
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: ' + e.getMessage()));
        }
        return null;
    }
    
    public PageReference createLead() {
        try {
            insert newLead;
            leads.add(newLead);
            newLead = new Lead();
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Lead created successfully!'));
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: ' + e.getMessage()));
        }
        return null;
    }
    
    public PageReference deleteLead() {
        try {
            Lead leadToDelete = [SELECT FirstName, LastName, Status, Company, Email, Phone FROM Lead WHERE Id = :deleteLeadId LIMIT 1];
            delete leadToDelete;
            leads.remove(leads.indexOf(leadToDelete));

            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Lead deleted successfully!'));
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: ' + e.getMessage()));
        }
        return null;
    }
}