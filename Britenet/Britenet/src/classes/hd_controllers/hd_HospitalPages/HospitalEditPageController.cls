public with sharing class HospitalEditPageController {
    public Hospital__c hospital { get; set; }
    private final String newHospitalPageURL = System.Label.newHospitalPageURL;
    private final String orgPage = System.Label.OrgURL;
    public ApexPages.StandardController standardController { get; set; }
    public HospitalEditPageController(ApexPages.StandardController stdController) {
        hospital = (Hospital__c) stdController.getRecord();
        hospital = [
                SELECT Name, City__c, Country__c, Public__c, Street_name__c, Id, Street_number__c, Type__c
                FROM Hospital__c
                WHERE Id = :hospital.id
        ];
    }

    public PageReference save() {
        update hospital;
        return new PageReference(orgPage + hospital.Id);
    }

    public PageReference saveAndNew() {
        update hospital;
        return new PageReference(newHospitalPageURL);
    }
}