public with sharing class WorkOrderManagerController {
    public List<WorkOrder> workorders { get; set; }
    public WorkOrder newWorkOrder { get; set; }
    public String deleteId { get; set; }
    
    public WorkOrderManagerController() {
        workorders  = [SELECT Id, WorkOrderNumber, Priority, Status FROM WorkOrder LIMIT 100];
        newWorkOrder = new WorkOrder();
    }
    
    public PageReference createWorkOrder() {
        try {
            insert newWorkOrder;
            workorders.add(newWorkOrder);
            newWorkOrder = new WorkOrder();
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Work Order created successfully!'));
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: ' + e.getMessage()));
        }
        return null;
    }
    
    public PageReference deleteWorkOrder() {
        try {
            // Query the workorder to delete
            WorkOrder workToDelete = [SELECT Id FROM WorkOrder WHERE Id = :deleteId LIMIT 1];
            delete workToDelete; 
            
            // Create a new list to hold the remaining work orders
            List<WorkOrder> updatedWorkOrders = new List<WorkOrder>();
            for (WorkOrder work : workorders) {
                if (work.Id != deleteId) {
                    updatedWorkOrders.add(work);
                }
            }
            // Assign the updated list back to the work orders list
            workorders = updatedWorkOrders;
            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Work Order deleted successfully!'));
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: ' + e.getMessage()));
        }
        return null;
    }
    
}