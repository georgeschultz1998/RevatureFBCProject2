public with sharing class ContactManagerController {
    public List<Contact> contacts { get; set; }
    public List<Contact> customers { get; set; }
    public List<Contact> serviceTechnicians { get; set; }
    private transient Map<String, Schema.RecordTypeInfo> recordTypes { get; set; }
    public Id customerRecType { get; set; }
    public Id techRecType { get; set; }
    public Contact newContact { get; set; }
    public String deleteId { get; set; }

    public ContactManagerController() {
        contacts = [SELECT firstName, lastName, phone, email, accountId, recordTypeId FROM Contact];
        recordTypes = Schema.sObjectType.Contact.getRecordTypeInfosByName();
        customerRecType = recordTypes.get('Customer').getRecordTypeId();
        techRecType = recordTypes.get('Service Technician').getRecordTypeId();
        customers = new List<Contact>();
        serviceTechnicians = new List<Contact>();
        for(Contact con : contacts){
            if(con.RecordTypeId == customerRecType) customers.add(con);
            else if (con.RecordTypeId == techRecType) serviceTechnicians.add(con);
            
            /* switch on con.RecordTypeId { cannot switch on Id
                when customerRecType {
                     customers.add(con);
                }
                when techRecType {
                 	 serviceTechnicians.add(con);   
                }
            } */
        }
        newContact = new Contact();
    }

    public PageReference createContact() {
        try {
            insert newContact;
            if (newContact.RecordTypeId == customerRecType) customers.add(newContact);
            else if (newContact.RecordTypeId == techRecType) serviceTechnicians.add(newContact);
            newContact = new Contact();
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Contact created successfully!'));
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: ' + e.getMessage()));
        }
        return null;
    }

    public PageReference deleteContact() {
        try {
            Contact conToDelete = [SELECT firstName, lastName, phone, email, accountId, recordTypeId FROM Contact 
                                   WHERE Id = :deleteId LIMIT 1];
            delete conToDelete;
            if (conToDelete.RecordTypeId == customerRecType) customers.remove(customers.indexOf(conToDelete));
            else if (conToDelete.RecordTypeId == techRecType) serviceTechnicians.remove(serviceTechnicians.indexOf(conToDelete));
    
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Contact deleted successfully!'));
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: ' + e.getMessage()));
        }
        return null;
    }

}