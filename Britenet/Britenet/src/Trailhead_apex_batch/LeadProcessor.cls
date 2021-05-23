/**
 * Created by BRITENET on 18.05.2021.
 */

public with sharing class LeadProcessor implements Database.batchable<sObject> {

    public Database.QueryLocator start(Database.BatchableContext param1) {
        return Database.getQueryLocator(
                'SELECT Id FROM Lead'
        );
    }
    public void execute(Database.BatchableContext bc, List<Lead> scope) {
        For (Lead lead : scope) {
            lead.LeadSource = 'Dreamforce';
        }
    }

    public void finish(Database.BatchableContext param1) {
    }

}