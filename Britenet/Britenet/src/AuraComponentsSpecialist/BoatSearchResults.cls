public with sharing class BoatSearchResults {
    @AuraEnabled
    public static List<BoatType__c> getBoatTypes() {
        return [
                SELECT Name
                FROM BoatType__c
        ];
    }
    @AuraEnabled
    public static List<Boat__c> getBoats(String boatTypeId) {
        System.debug(boatTypeId);
        return [
                SELECT Name, Picture__c, BoatType__c
                FROM Boat__c
                WHERE BoatType__c = :boatTypeId
        ];
    }

}