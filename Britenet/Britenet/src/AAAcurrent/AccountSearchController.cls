public with sharing class AccountSearchController {
    @AuraEnabled
    public static List<Account> getAccounts(String name, String country){
        return [SELECT Website, ShippingCountry, ShippingCity, Name FROM Account WHERE Name LIKE : name+'%' AND ShippingCountry =: country];
    }
}