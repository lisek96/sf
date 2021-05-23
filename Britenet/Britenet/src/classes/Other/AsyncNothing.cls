public class AsyncNothing implements Queueable{
    public void execute(QueueableContext context) {
        for(;;){}
    }
}