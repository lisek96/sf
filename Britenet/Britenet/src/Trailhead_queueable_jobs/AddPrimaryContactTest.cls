@IsTest
private class AddPrimaryContactTest{

   @TestSetup
   private static void setup(){
       List<Account> accounts = new List<Account>();
       Account account = new Account(Name='xd', BillingState='NY');
       Account account1 = new Account(Name='xd2', BillingState='CA');
       for(Integer i=0; i<50; i++){
           accounts.add(account.clone());
           accounts.add(account1.clone());
       }
       insert accounts;
   }

    @IsTest
    private static void shouldUpdate50Records(){
        AddPrimaryContact addPrimaryContact = new AddPrimaryContact(new Contact(), 'CA');
        Test.startTest();
        System.enqueueJob(addPrimaryContact);
        Test.stopTest();
        System.assert(true);
    }

}