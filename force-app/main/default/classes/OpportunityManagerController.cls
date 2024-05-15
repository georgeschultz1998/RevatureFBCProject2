public with sharing class OpportunityManagerController {
    public List<Opportunity> opportunities { get; set; }
    public Opportunity newOpportunity { get; set; }
    public String deleteId { get; set; }
    
    public OpportunityManagerController() {
        opportunities = [SELECT Id, Name, CloseDate, StageName FROM Opportunity LIMIT 100];
        newOpportunity = new Opportunity();
    }
    
    public PageReference createOpportunity() {
        try {
            insert newOpportunity;
            opportunities.add(newOpportunity);
            newOpportunity = new Opportunity();
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Opportunity created successfully!'));
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: ' + e.getMessage()));
        }
        return null;
    }
    
    public PageReference deleteOpportunity() {
        try {
            Opportunity oppToDelete = [SELECT Id, Name, CloseDate, StageName FROM Opportunity WHERE Id = :deleteId LIMIT 1];
            delete oppToDelete;
            opportunities.remove(opportunities.indexOf(oppToDelete));

            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Opportunity deleted successfully!'));
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: ' + e.getMessage()));
        }
        return null;
    }
}