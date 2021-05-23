@RestResource(UrlMapping='/doctors/*')
global with sharing class DoctorsAPIController {

    private static DoctorsService doctorsService = new DoctorsServiceImp();

    @HttpDelete
    global static DoctorServiceResponse doDelete() {
        return doctorsService.deleteDoctors();
    }

    @HttpPost
    global static DoctorServiceResponse doCreate() {
        return doctorsService.createDoctors();
    }

    @HttpPut
    global static DoctorServiceResponse doUpdate() {
        return doctorsService.updateDoctors();
    }
    @HttpPatch
    global static DoctorServiceResponse doCreateAckUpdate(){
        return doctorsService.doCreateAckUpdate();
    }
}