public class ContactInsertQueueable implements Queueable {
    private List<Contact> contactsToInsert;

    public ContactInsertQueueable(List<Contact> contacts) {
        this.contactsToInsert = contacts;
    }

    public void execute(QueueableContext context) {
        insert contactsToInsert;
    }
}