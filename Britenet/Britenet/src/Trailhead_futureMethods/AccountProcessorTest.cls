@IsTest
private class AccountProcessorTest{

    @IsTest
    private static void shouldReturnNotNull(){
        Id id = createAccount();
        Integer numberOfContacts = [SELECT COUNT() FROM Contact WHERE Account.Id=:id];
        List<Id> ids = new List<Id>();
        ids.add(id);
        Test.startTest();
        AccountProcessor.countContacts(ids);
        Test.stopTest();
        Account acc = [SELECT Number_Of_Contacts__c FROM Account WHERE Account.Id=:id];
        System.assert(numberOfContacts==acc.Number_Of_Contacts__c);
    }

    private static Id createAccount(){
        Account acc = new Account(Name='xx');
        insert acc;
        return acc.id;
    }


}
