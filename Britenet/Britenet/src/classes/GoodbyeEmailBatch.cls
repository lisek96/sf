public with sharing class GoodbyeEmailBatch implements Database.Batchable<Hospitals_Doctors__c> {

    public Iterable<Hospitals_Doctors__c> start(Database.BatchableContext param1) {
        List<Hospitals_Doctors__c> contractsStartingToday = [
                SELECT DoctorFirstName__c, DoctorLastName__c, HospitalName__c
                FROM Hospitals_Doctors__c
                WHERE endDate__c = :Date.today()
        ];
        return contractsStartingToday;
    }

    public void execute(Database.BatchableContext param1, List<Hospitals_Doctors__c> contractsStartingToday) {
        List<Messaging.SingleEmailMessage> goodbyeMessages = new List<Messaging.SingleEmailMessage>();
        EmailTemplate onboarding = [
                SELECT
                        Id,Subject,Description,HtmlValue,DeveloperName,Body
                FROM EmailTemplate
                WHERE name = :'Farewell'
        ];
        for (Hospitals_Doctors__c contract : contractsStartingToday) {
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setTargetObjectId(UserInfo.getUserId());
            email.setWhatId(contract.id);
            email.setTemplateId(onboarding.Id);
            email.setSaveAsActivity(false);
            email.toAddresses = new String[] { 'rafal.wojcik@britenet.com.pl'};
            goodbyeMessages.add(email);
        }
        Messaging.sendEmail(goodbyeMessages);
    }

    public void finish(Database.BatchableContext param1) {

    }
}