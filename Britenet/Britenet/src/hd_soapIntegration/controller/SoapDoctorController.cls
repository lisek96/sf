public with sharing class SoapDoctorController {
    public FieldsContainer searchFieldsContainer { get; set; }
    public SoapDoctorService soapDoctorServiceInstance { get; set; }
    public List<SoapDoctor> retrieved { get; set; }
    public SoapDoctor createUpdateDataModel { get; set; }
    public String doctorToDelete { get; set; }
    public String doctorToEdit { get; set; }
    public SoapDoctor updateAssigner { get; set; }
    public String userInfo { get; set; }
    public Integer shownDoctorsNumber { get; set; }

    public void showAllDoctors() {
        shownDoctorsNumber = retrieved.size();
    }
    public void show5Doctors() {
        shownDoctorsNumber = 5;
    }

    public SoapDoctorController() {
        soapDoctorServiceInstance = new SoapDoctorService();
        initDataContainers();
        prepareSearchFieldsContainer();

    }
    public void prepareSearchFieldsContainer() {
        FieldWrapper firstName = new FieldWrapper(DoctorFieldsNames.firstName, UsefulStrings.blank);
        FieldWrapper lastName = new FieldWrapper(DoctorFieldsNames.lastName, UsefulStrings.blank);
        FieldWrapper city = new FieldWrapper(DoctorFieldsNames.Email, UsefulStrings.blank);
        FieldWrapper email = new FieldWrapper(DoctorFieldsNames.City, UsefulStrings.blank);
        FieldWrapper[] fields = new FieldWrapper[]{
                firstName, lastName, city, email
        };
        searchFieldsContainer = new FieldsContainer(fields);
    }
    public void initDataContainers() {
        retrieved = new List<SoapDoctor>();
        createUpdateDataModel = new SoapDoctor();
        updateAssigner = new SoapDoctor();
    }

    public PageReference assignDoctorToSoapDoctor() {
        createUpdateDataModel
                .firstName(updateAssigner.FirstName)
                .lastName(updateAssigner.lastName)
                .city(updateAssigner.city)
                .email(updateAssigner.email);
        return null;
    }
    private void resetNewDoctorDialog() {
        createUpdateDataModel = new SoapDoctor();
    }

    public PageReference getDoctors() {
        retrieved = new List<SoapDoctor>();
        Map<String, Object> fieldsValues = prepareSearchCriteriaForSoapRetrievalRequest();
        if (fieldsValues.size() == 0) {
            userInfo = UserMessages.searchFailInfo;
            return null;
        }
        System.debug(soapDoctorServiceInstance);
        retrieved = soapDoctorServiceInstance.retrieveDoctors(fieldsValues);
        if (retrieved.isEmpty()) userInfo = UserMessages.noRecordsRetrieved;
        return null;
    }

    private Map<String, Object> prepareSearchCriteriaForSoapRetrievalRequest() {
        Map<String, Object> fieldsValues = new Map<String, Object>();
        for (FieldWrapper f : searchFieldsContainer.fields) {
            if (f.value != UsefulStrings.blank) fieldsValues.put(f.name, f.value);
        }
        return fieldsValues;
    }
    public PageReference createDoctor() {
        if (!(createUpdateDataModel.FirstName != UsefulStrings.blank
                && createUpdateDataModel.LastName != UsefulStrings.blank
                && createUpdateDataModel.Email != UsefulStrings.blank)) {
            userInfo = UserMessages.createFormError;
            return null;
        }
        SoapDoctor createdDoctor = soapDoctorServiceInstance.createDoctor(createUpdateDataModel);
        userInfo = UserMessages.saveSuccess + createdDoctor;
        return null;
    }

    public void updateDoctor() {
        createUpdateDataModel.idSoapDoctor = doctorToEdit;
        boolean result = soapDoctorServiceInstance.updateDoctor(createUpdateDataModel);
        if (result) {
            UserInfo = UserMessages.updateSuccess;
            return;
        }
        userInfo = UserMessages.operationFailed;
    }

    public PageReference cancel() {
        createUpdateDataModel = new SoapDoctor();
        return null;
    }
    public PageReference clear() {
        createUpdateDataModel = new SoapDoctor();
        return null;
    }

    public void deleteDoctor() {
        removeDoctorToDeleteFromView();
        boolean result = soapDoctorServiceInstance.deleteDoctor(doctorToDelete);
        if (result) {
            userInfo = UserMessages.doctorDeleted;
            return;
        }
        userInfo = UserMessages.operationFailed;
    }

    private void removeDoctorToDeleteFromView() {
        for (Integer i = 0; i < retrieved.size(); i++) {
            if (retrieved[i].IdSoapDoctor == doctorToDelete) {
                retrieved.remove(i);
                break;
            }
        }
    }
}