public with sharing class HospitalServiceImp implements HospitalService {
    private static final Integer SUCCESS_CODE = 200;
    private static final Integer ERROR_CODE = 500;

    public DoctorServiceResponse getHospital() {
        RestRequest req = RestContext.request;
        String hospitalId = req.requestURI.substring(req.requestURI.lastIndexOf('/') + 1);

        try {
            Hospital__c hospital = getHospital(hospitalId);
            return handleSuccess(RETRIEVE_SUCCESS, hospital);
        } catch (Exception e) {
            return handleError(e);
        }
    }

    public DoctorServiceResponse deleteHospital() {
        RestRequest req = RestContext.request;
        String hospitalId = req.requestURI.substring(req.requestURI.lastIndexOf('/') + 1);

        try {
            Database.delete(hospitalId);
            return handleSuccess(DELETE_SUCCESS, null);
        } catch (Exception e) {
            return handleError(e);
        }
    }

    public DoctorServiceResponse updateHospital() {
        HospitalRequestDto hospitalRequestDto = prepareHospitalRequestDtoFromRequestBody();
        RestRequest req = RestContext.request;
        String hospitalId = req.requestURI.substring(req.requestURI.lastIndexOf('/') + 1);
        hospitalRequestDto.setHospitalId(hospitalId);

        try {
            Hospital__c hospital = createHospitalFromRequestDto(hospitalRequestDto);
            update hospital;
            hospital = getHospital(hospitalId);
            return handleSuccess(UPDATE_SUCCESS, hospital);
        } catch (Exception e) {
            return handleError(e);
        }
    }

    public DoctorServiceResponse createHospital() {
        HospitalRequestDto hospitalRequestDto = prepareHospitalRequestDtoFromRequestBody();

        try {
            Hospital__c hospital = createHospitalFromRequestDto(hospitalRequestDto);
            Database.insert(hospital);
            return handleSuccess(CREATE_SUCCESS, hospital);
        } catch (Exception e) {
            return handleError(e);
        }
    }

    private Hospital__c createHospitalFromRequestDto(HospitalRequestDto hospitalRequestDto) {
        Hospital__c hospital = new Hospital__c();
        if (String.isNotBlank(hospitalRequestDto.hospitalName)) {
            hospital.Name = hospitalRequestDto.hospitalName;
        }
        if (String.isNotBlank(hospitalRequestDto.city)) {
            hospital.City__c = hospitalRequestDto.city;
        }
        if (hospitalRequestDto.publicHospital != null) {
            hospital.Public__c = hospitalRequestDto.publicHospital;
        }
        if (String.isNotBlank(hospitalRequestDto.hospitalId)) {
            hospital.Id = hospitalRequestDto.hospitalId;
        }
        return hospital;
    }

    private HospitalRequestDto prepareHospitalRequestDtoFromRequestBody() {
        RestRequest req = RestContext.request;
        return (HospitalRequestDto) JSON.deserialize(req.requestBody.toString(), HospitalRequestDto.class);
    }

    private static Hospital__c getHospital(Id hospitalId) {
        return [
                SELECT Cost_of_hiring_doctors__c, Number_Of_Doctors__c, City__c, Public__c, Name, Id, Country__c
                FROM Hospital__c
                WHERE Id = :hospitalId
                LIMIT 1
        ];
    }

    private static DoctorServiceResponse handleSuccess(String msg, Object obj) {
        RestContext.response.statusCode = SUCCESS_CODE;
        return new DoctorServiceResponse()
                .setStatusCode(SUCCESS_CODE)
                .setMessage(msg)
                .setObj(obj);
    }

    private static DoctorServiceResponse handleError(Exception e) {
        RestResponse response = RestContext.response;
        response.statusCode = ERROR_CODE;
        return new DoctorServiceResponse()
                .setMessage(e.getMessage())
                .setStatusCode(response.statusCode);
    }

    private static final String RETRIEVE_SUCCESS = 'Hospital successfully retrieved';
    private static final String DELETE_SUCCESS = 'Hospital successfully deleted';
    private static final String UPDATE_SUCCESS = 'Hospital successfully updated';
    private static final String CREATE_SUCCESS = 'Hospital successfully created';

}