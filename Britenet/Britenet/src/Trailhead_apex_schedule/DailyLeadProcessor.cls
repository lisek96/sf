public with sharing class DailyLeadProcessor implements Schedulable{

    public void execute(SchedulableContext param1) {
        List<Lead> leads = [SELECT Id FROM Lead WHERE LeadSource =: '' LIMIT 200];
        for(Lead lead : leads){
            lead.LeadSource = 'Dreamforce';
        }
        update leads;
    }
}