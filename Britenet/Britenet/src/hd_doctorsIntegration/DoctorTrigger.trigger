trigger DoctorTrigger on Doctor__c (after insert, after update, after delete) {
    List<Doctor__c> doctorsToOperateOnInExternalOrg = new List<Doctor__c>();
    List<Doctor__c> ackDoctorsWhichAreNeededToSendBackToFirstOrgToMapExternalIdWIthNewIdFromThisOrg
            = new List<Doctor__c>();

    if (Trigger.isInsert) {
        for (Doctor__c doctor : Trigger.new) {
            if (String.isBlank(doctor.ExternalDoctorId__c)) {
                doctorsToOperateOnInExternalOrg.add(doctor);
            } else {
                ackDoctorsWhichAreNeededToSendBackToFirstOrgToMapExternalIdWIthNewIdFromThisOrg.add(doctor);
            }
        }
        if (doctorsToOperateOnInExternalOrg.size() != 0) {
            ExternalDoctorsService.sendCreateDoctorsRequest(JSON.serialize(DoctorsServiceImp.prepareDoctorsDtoFromDoctors(doctorsToOperateOnInExternalOrg)));
        }
        if (ackDoctorsWhichAreNeededToSendBackToFirstOrgToMapExternalIdWIthNewIdFromThisOrg.size() != 0) {
            ExternalDoctorsService.CreateAckSender ackSender = new ExternalDoctorsService.CreateAckSender(JSON.serialize(DoctorsServiceImp.prepareDoctorsDtoFromDoctors(
                    ackDoctorsWhichAreNeededToSendBackToFirstOrgToMapExternalIdWIthNewIdFromThisOrg)));
            System.enqueueJob(ackSender);
        }
    } else if (Trigger.isUpdate) {
        for (Doctor__c doctor : Trigger.new) {
            if (String.isNotBlank(doctor.ExternalDoctorId__c)) {
                doctorsToOperateOnInExternalOrg.add(doctor);
            }
        }
        if (doctorsToOperateOnInExternalOrg.size() != 0) {
            ExternalDoctorsService.UpdateDoctorRequestSender updateRequestSender = new ExternalDoctorsService.UpdateDoctorRequestSender
                    (JSON.serialize(DoctorsServiceImp.prepareDoctorsDtoFromDoctors(
                            doctorsToOperateOnInExternalOrg)));
            System.enqueueJob(updateRequestSender);
        }
    } else if (Trigger.isDelete) {
        for (Doctor__c doctor : Trigger.old) {
            if (String.isNotBlank(doctor.ExternalDoctorId__c)) {
                doctorsToOperateOnInExternalOrg.add(doctor);
            }
        }
        if (doctorsToOperateOnInExternalOrg.size() != 0) {
            ExternalDoctorsService.DeleteDoctorRequestSender deleteRequestSender = new ExternalDoctorsService.DeleteDoctorRequestSender
                    (JSON.serialize(DoctorsServiceImp.prepareDoctorsDtoFromDoctors(
                            doctorsToOperateOnInExternalOrg)));
            System.enqueueJob(deleteRequestSender);
        }
    }
}