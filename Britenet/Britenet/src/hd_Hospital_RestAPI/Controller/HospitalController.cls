@RestResource(UrlMapping='/hospitals/*')
global with sharing class HospitalController {

    private static HospitalService hospitalService = new HospitalServiceImp();

    @HttpGet
    global static DoctorServiceResponse doGet() {
        return hospitalService.getHospital();
    }
    @HttpDelete
    global static DoctorServiceResponse doDelete() {
        return hospitalService.deleteHospital();
    }

    @HttpPost
    global static DoctorServiceResponse doCreate() {
        return hospitalService.createHospital();
    }

    @HttpPut
    global static DoctorServiceResponse doUpdate() {
        return hospitalService.updateHospital();
    }
}