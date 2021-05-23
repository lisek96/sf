public with sharing class OnboardingEmailBatch implements Database.Batchable<Hospitals_Doctors__c> {

    public Iterable<Hospitals_Doctors__c> start(Database.BatchableContext param1) {
        List<Hospitals_Doctors__c> contractsStartingToday = [
                SELECT DoctorFirstName__c, DoctorLastName__c, HospitalName__c
                FROM Hospitals_Doctors__c
                WHERE startDate__c = :Date.today()
        ];
        return contractsStartingToday;
    }

    public void execute(Database.BatchableContext param1, List<Hospitals_Doctors__c> contractsStartingToday) {
        List<Messaging.SingleEmailMessage> welcomeMessages = new List<Messaging.SingleEmailMessage>();
        EmailTemplate onboarding = [
                SELECT
                        Id,Subject,Description,HtmlValue,DeveloperName,Body
                FROM EmailTemplate
                WHERE name = :'Onboarding'
        ];
        for (Hospitals_Doctors__c contract : contractsStartingToday) {
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setTargetObjectId(UserInfo.getUserId());
            email.setWhatId(contract.id);
            email.setTemplateId(onboarding.Id);
            email.setSaveAsActivity(false);
            email.toAddresses = new String[] { 'rafal.wojcik@britenet.com.pl'};
            welcomeMessages.add(email);
        }
        Messaging.sendEmail(welcomeMessages);
    }

    public void finish(Database.BatchableContext param1) {

    }
}