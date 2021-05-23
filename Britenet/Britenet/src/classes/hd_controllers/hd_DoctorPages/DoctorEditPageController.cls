public with sharing class DoctorEditPageController {
    public Doctor__c doctor { get; set; }
    private final String newDoctorPage = System.label.newDoctorPageURL;
    private final String orgPage = System.label.orgURL;
    public ApexPages.StandardController standardController { get; set; }
    public DoctorEditPageController(ApexPages.StandardController stdController) {
        doctor = (Doctor__c) stdController.getRecord();
        doctor = [
                SELECT First_Name__c, Last_Name__c, Birth_Date__c, Country__c, English__c, Specialization__c, Id
                FROM Doctor__c
                WHERE Id = :doctor.Id
        ];
    }
    public PageReference save() {
        update doctor;
        return new PageReference(orgPage + doctor.Id);
    }

    public PageReference saveAndNew() {
        update doctor;
        return new PageReference(newDoctorPage);
    }
}