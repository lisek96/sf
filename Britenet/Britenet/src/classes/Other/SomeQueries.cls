/**
 * Created by Rafal on 21.04.2021.
 */

public with sharing class SomeQueries {
    List<Contact> getContactsWithNameThatContains_a_letter() {
        return [
                SELECT Name
                FROM Contact
                WHERE Name LIKE '%a%'
        ];
    }



    List<SObject> innerJoinAccountAndContact() {
        return [
                SELECT Id
                FROM Account
                WHERE Id IN (
                        SELECT AccountId
                        FROM Contact
                )
        ];
    }

    public static void createRandomAccounts(Integer n) {
        List<Account> accountsToAdd = new List<Account>();
        for (Integer i = 0; i < n; i++) {
            accountsToAdd.add(new Account(
                    Name = 'test' + i));
        }
    }

    private void createRandomContacts(Integer numberOfLoops) {
        List<Contact> contactsToAdd = new List<Contact>();
        for (Integer i = 0; i < numberOfLoops; i++) {
            contactsToAdd.add(new Contact(LastName = 'test' + i));
        }
        insert contactsToAdd;
    }

    public static List<Contact> searchForContacts(String lastname, String postalcode) {
        return [
                SELECT Id, Name
                FROM Contact
                WHERE MailingPostalCode = :postalcode AND LastName = :lastname
                LIMIT 10
        ];
    }

    @Future
    public static void doNothing() {
        doNothing();
    }
    @Future
    public static void doNothing2() {
        doNothing();
    }


}

