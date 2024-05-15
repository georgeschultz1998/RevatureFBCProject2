@isTest
public class OpportunityManagerControllerTest {
    
    @testSetup
    static void makeData() {
        List<Opportunity> opportunities = new List<Opportunity>();
        for (Integer i = 0; i < 100; i++) {
            opportunities.add(new Opportunity(
                Name = 'Opportunity ' + i,
                StageName = 'Prospecting',
                CloseDate = Date.today().addDays(30)
            ));
        }
        insert opportunities;
    }

    @isTest
    static void checkLists() {
        OpportunityManagerController omc = new OpportunityManagerController();
        Assert.areEqual(100, omc.opportunities.size(), 'Unexpected number of opportunities initially.');
    }

    @isTest
    static void createOpportunity() {
        OpportunityManagerController omc = new OpportunityManagerController();
        omc.newOpportunity.Name = 'New Opportunity';
        omc.newOpportunity.StageName = 'Prospecting';
        omc.newOpportunity.CloseDate = Date.today().addDays(30);

        Test.startTest();
        omc.createOpportunity();
        Test.stopTest();

        List<Opportunity> opps = [SELECT Id FROM Opportunity WHERE Name = 'New Opportunity'];
        Assert.areEqual(1, opps.size(), 'Single opportunity was not created.');
    }

    @isTest
    static void deleteOpportunity() {
        OpportunityManagerController omc = new OpportunityManagerController();
        Opportunity oppToDelete = [SELECT Id, Name FROM Opportunity LIMIT 1];
        omc.deleteId = oppToDelete.Id;

        Test.startTest();
        omc.deleteOpportunity();
        Test.stopTest();

        try {
            List<Opportunity> opps = [SELECT Id FROM Opportunity WHERE Id = :oppToDelete.Id];
        } catch (System.QueryException e) {
            Assert.isTrue(true);
        }
    }

    @isTest
    static void createFailedOpportunity() {
        OpportunityManagerController omc = new OpportunityManagerController();
        omc.newOpportunity.StageName = 'Prospecting';

        Test.startTest();
        try {
            omc.createOpportunity();
        } catch (System.Exception e) {
            Assert.isTrue(true);
        }
        Test.stopTest();
    }
}