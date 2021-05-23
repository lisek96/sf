public with sharing class SoapDoctorService {
    private static DoctorsWebService.DoctorsSoapWebService doctorsSoapWebService;
    private static SessionWrapper sessionWrapper;
    public DoctorsWebService.DoctorsSoapWebService doctorsSoapWebServiceInstance;
    public SessionWrapper sessionWrapperInstance;
    @TestVisible private static Boolean isMock = false;

    public SoapDoctorService() {
        initServiceComponents();
        checkAndUpdateSessionId();
        this.doctorsSoapWebServiceInstance = doctorsSoapWebService;
        this.sessionWrapperInstance = sessionWrapper;
    }

    public List<SoapDoctor> retrieveDoctors(Map<String, Object> searchFieldsValues) {
        String fieldsValuesJson = JSON.serialize(searchFieldsValues);
        String doctorsJson = doctorsSoapWebServiceInstance.retrieveDoctors(fieldsValuesJson);
        return (List<SoapDoctor>) JSON.deserialize(doctorsJson, List<SoapDoctor>.class);
    }

    public SoapDoctor createDoctor(SoapDoctor dataModel) {
        String doctorJson = JSON.serialize(dataModel);
        String newDoctorId = doctorsSoapWebServiceInstance.createDoctor(doctorJson);
        dataModel.idSoapDoctor(newDoctorId);
        return dataModel;
    }

    public Boolean deleteDoctor(String id) {
        return doctorsSoapWebServiceInstance.deleteDoctor(id);
    }

    public Boolean updateDoctor(SoapDoctor dataModel) {
        String doctorJson = JSON.serialize(dataModel);
        return doctorsSoapWebServiceInstance.updateDoctor(dataModel.idSoapDoctor, doctorJson);
    }

    private void initServiceComponents() {
        if (doctorsSoapWebService == null) {
            doctorsSoapWebService = new DoctorsWebService.DoctorsSoapWebService();
            doctorsSoapWebService.SessionHeader = new DoctorsWebService.SessionHeader_element();
        }
        if (sessionWrapper == null) sessionWrapper = new SessionWrapper();
    }

    private void checkAndUpdateSessionId() {
        if (sessionWrapper.sessionId == null || sessionWrapper.expiration < Datetime.now()) {
            sessionWrapper.sessionId = obtainSessionId();
            sessionWrapper.expiration = Datetime.now().addHours(3);
        }
        doctorsSoapWebService.SessionHeader.sessionId = sessionWrapper.sessionId;
    }

    private String obtainSessionId() {
        partnerSoapSforceCom.LoginResult loginResult = new partnerSoapSforceCom.LoginResult();
        partnerSoapSforceCom.Soap loginTool = new partnerSoapSforceCom.Soap();
        if (!isMock) {
            loginResult = loginTool.login(
                    UsefulStrings.loginEmail, UsefulStrings.loginPassword
            );
        }
        return loginResult.sessionId;
    }
}