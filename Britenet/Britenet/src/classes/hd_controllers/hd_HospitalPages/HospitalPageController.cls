public with sharing class HospitalPageController {
    public Hospital__c hospital { get; set; }
    public String hospitalDoctorId { get; set; }
    private final String newHospitalAndDoctorPageURL = System.label.newHospitalAndDoctorPageURL;
    private final String hospitalViewPageURL = System.label.hospitalViewPageURL;
    public HospitalPageController(ApexPages.StandardController stdController) {
        hospital = (Hospital__c) stdController.getRecord();
    }
    public PageReference createNewHospitalAndDoctor() {
        return new PageReference(newHospitalAndDoctorPageURL);
    }
    public PageReference deleteHospitalsDoctorsChildRecord() {
        List<Hospitals_Doctors__c> recordToDelete = [
                SELECT Id
                FROM Hospitals_Doctors__c
                WHERE Id = :hospitalDoctorId
        ];
        delete recordToDelete;
        PageReference pageRef = new PageReference(hospitalViewPageUrl + 'id=' + hospital.Id);
        pageRef.setRedirect(true);
        return pageRef;
    }
}