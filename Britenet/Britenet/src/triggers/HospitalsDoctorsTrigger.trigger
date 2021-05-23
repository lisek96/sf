trigger HospitalsDoctorsTrigger on Hospitals_Doctors__c (before insert, before update) {
    HospitalsAndDoctorsTriggerHandler.validateNewContracts(Trigger.new);
}