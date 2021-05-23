@IsTest
private class AccountManagerTest{

    @IsTest static void shouldReturnNotNullAccount(){
        Id recordId = createAccount();
        // Set up a test request
        RestRequest request = new RestRequest();
        request.requestUri =
                'https://britenet81-dev-ed.my.salesforce.com/services/apexrest/Accounts/'
                        + recordId +'/contacts';
        request.httpMethod = 'GET';
        RestContext.request = request;
        // Call the method to test
        Account thisCase = AccountManager.getAccount();
        // Verify results
        System.assert(thisCase != null);
    }

    private static Id createAccount(){
        Account acc = new Account(Name='xx');
        insert acc;
        return acc.id;
    }



}