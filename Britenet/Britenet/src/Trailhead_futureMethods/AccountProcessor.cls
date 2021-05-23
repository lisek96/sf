/**
 * Created by BRITENET on 18.05.2021.
 */

public with sharing class AccountProcessor {

    @Future
    public static void countContacts(List<Id> accounts){
        for(Id id : accounts){
            Account acc = new Account(Id=id);
            Integer contactsNumber = [select COUNT() FROM Contact WHERE Account.Id = '0010900000MKOIAAA5'];
            acc.Number_Of_Contacts__c = contactsNumber;
            update acc;
        }
    }
}