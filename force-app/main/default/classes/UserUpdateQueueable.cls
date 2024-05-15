public class UserUpdateQueueable implements Queueable {
    private final List<User> usersToUpdate;

    public UserUpdateQueueable(List<User> users) {
        this.usersToUpdate = users;
    }

    public void execute(QueueableContext context) {
        update usersToUpdate;
    }
}