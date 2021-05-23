/**
 * Created by BRITENET on 18.05.2021.
 */

public with sharing class AddPrimaryContact implements Queueable{
    public Contact contact;
    public String state_abbreviation;

    public AddPrimaryContact(Contact contact, String state_abbreviation){
        this.contact=contact;
        this.state_abbreviation=state_abbreviation;
    }

    public void execute(QueueableContext context){
        List<Account> accs = [SELECT Id FROM Account WHERE BillingState =: state_abbreviation LIMIT 200];
        for(Account acc : accs){
            acc.Contacts.add(contact);
        }
        update accs;
    }
}