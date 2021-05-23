public with sharing class CreateUpdateDeleteDoctorServiceImp implements CreateUpdateDeleteService{

    public void deleteExternalOnlyDoctor(List<DoctorDto> doctor) {
        ExternalDoctorsService.DeleteDoctorRequestSender deleteRequestSender = new ExternalDoctorsService.DeleteDoctorRequestSender
                (JSON.serialize(doctor));
        System.enqueueJob(deleteRequestSender);
    }

    public void updateExternalOnlyDoctor(List<DoctorDto> doctor) {
        ExternalDoctorsService.UpdateDoctorRequestSender updateRequestSender = new ExternalDoctorsService.UpdateDoctorRequestSender
                (JSON.serialize(doctor));
        System.enqueueJob(updateRequestSender);
    }
}