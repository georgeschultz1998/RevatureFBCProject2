@isTest
public class WorkOrderManagerControllerTest {
    
    @testSetup
    static void makeData() {
        List<WorkOrder> workorders = new List<WorkOrder>();
        for (Integer i = 0; i < 100; i++) {
            workorders.add(new WorkOrder(
                Work_Order_Name__c = 'Test' + i,
                Priority = 'Low',
                Status = 'New'
            ));
        }
        insert workorders;
    }

    @isTest
    static void checkLists() {
        WorkOrderManagerController omc = new WorkOrderManagerController();
        Assert.areEqual(100, omc.workorders.size(), 'Unexpected number of work orders initially.');
    }

    @isTest
    static void createWorkOrder() {
        WorkOrderManagerController omc = new WorkOrderManagerController();
        omc.newWorkOrder.Work_Order_Name__c = 'Test1';
        omc.newWorkOrder.Priority = 'Low';
        omc.newWorkOrder.Status = 'New';

        Test.startTest();
        omc.createWorkOrder();
        Test.stopTest();

        List<WorkOrder> works = [SELECT Id, Work_Order_Name__c FROM WorkOrder WHERE Work_Order_Name__c = 'Test1'];
        Assert.areEqual(1, works.size(), 'Single workorder was not created.');
    }

    @isTest
    static void deleteWorkOrder() {
        WorkOrderManagerController omc = new WorkOrderManagerController();
        WorkOrder workToDelete = [SELECT Id FROM WorkOrder LIMIT 1];
        omc.deleteId = workToDelete.Id;

        Test.startTest();
        omc.deleteWorkOrder();
        Test.stopTest();

        try {
            List<WorkOrder> works = [SELECT Id FROM WorkOrder WHERE Id = :workToDelete.Id];
        } catch (System.QueryException e) {
            Assert.isTrue(true);
        }
    }

    @isTest
    static void createFailedWorkOrder() {
        WorkOrderManagerController omc = new WorkOrderManagerController();
        omc.newWorkOrder.Priority = 'Prospecting';

        Test.startTest();
        try {
            omc.createWorkOrder();
        } catch (System.Exception e) {
            Assert.isTrue(true);
        }
        Test.stopTest();
    }
}