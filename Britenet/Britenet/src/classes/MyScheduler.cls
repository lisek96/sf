public with sharing class MyScheduler implements Schedulable{

    public void execute(SchedulableContext sc) {
        OnboardingEmailBatch b = new OnboardingEmailBatch();
        Id batchIdb = Database.executeBatch(b);
        GoodbyeEmailBatch c = new GoodbyeEmailBatch();
        Id batchIdc = Database.executeBatch(c);
    }
}