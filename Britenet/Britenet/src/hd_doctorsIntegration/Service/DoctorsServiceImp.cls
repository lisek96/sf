public with sharing class DoctorsServiceImp implements DoctorsService {
    private static final Integer SUCCESS_CODE = 200;
    private static final Integer ERROR_CODE = 500;
    private final OPERATION CREATE_DOCTOR_OPERATION = OPERATION.createDoctor;
    private final OPERATION UPDATE_DOCTOR_OPERATION = OPERATION.updateDoctor;
    private final OPERATION DELETE_DOCTOR_OPERATION = OPERATION.deleteDoctor;

    public DoctorServiceResponse doCreateAckUpdate() {
        List<DoctorDto> dtoDoctors = prepareDoctorsDtoFromRequestBody();
        dtoDoctors = swapDoctorsDtoIdAndExternalId(dtoDoctors, UPDATE_DOCTOR_OPERATION);
        List<Doctor__c> doctors = createDoctorsFromDoctorsDto(dtoDoctors);
        update doctors;
        return handleSuccess(UPDATE_SUCCESS, dtoDoctors);
    }

    public DoctorServiceResponse createDoctors() {
        List<DoctorDto> dtoDoctors = prepareDoctorsDtoFromRequestBody();
        dtoDoctors = swapDoctorsDtoIdAndExternalId(dtoDoctors, CREATE_DOCTOR_OPERATION);
        List<Doctor__c> doctors = createDoctorsFromDoctorsDto(dtoDoctors);
        insert doctors;
        return handleSuccess(CREATE_SUCCESS, dtoDoctors);
    }

    public DoctorServiceResponse updateDoctors() {
        List<DoctorDto> dtoDoctors = prepareDoctorsDtoFromRequestBody();
        dtoDoctors = swapDoctorsDtoIdAndExternalId(dtoDoctors, UPDATE_DOCTOR_OPERATION);
        dtoDoctors = getDoctorsQualifiedForUpdate(dtoDoctors);
        List<Doctor__c> doctors = createDoctorsFromDoctorsDto(dtoDoctors);
        update doctors;
        return handleSuccess(UPDATE_SUCCESS, dtoDoctors);
    }

    public DoctorServiceResponse deleteDoctors() {
        List<DoctorDto> dtoDoctors = prepareDoctorsDtoFromRequestBody();
        dtoDoctors = swapDoctorsDtoIdAndExternalId(dtoDoctors, DELETE_DOCTOR_OPERATION);
        System.debug(dtoDoctors);
        List<Doctor__c> doctors = getDoctorsQualifiedForDelete(dtoDoctors);
        delete doctors;
        return handleSuccess(DELETE_SUCCESS, prepareDoctorsDtoFromDoctors(doctors));
    }

    public List<Doctor__c> getDoctorsQualifiedForDelete(List<DoctorDto> dtoDoctors) {
        return getRequestedDoctorsForOperation(dtoDoctors);
    }


    public List<DoctorDto> getDoctorsQualifiedForUpdate(List<DoctorDto> dtoDoctors) {
        List<Doctor__c> requestedDoctors = getRequestedDoctorsForOperation(dtoDoctors);
        List<DoctorDto> doctorsToUpdate = getDoctorsThatRequireUpdate(dtoDoctors, requestedDoctors);
        return doctorsToUpdate;
    }

    public List<Doctor__c> getRequestedDoctorsForOperation(List<DoctorDto> dtoDoctors) {
        QueryBuilder queryBuilder = new QueryBuilder('SELECT Id, First_Name__c, Last_name__c, Email__c, City__c, ExternalDoctorId__c FROM Doctor__c WHERE');
        for (Integer i = 0; i < dtoDoctors.size(); i++) {
            queryBuilder.withEquals('Id', dtoDoctors[i].IdDoctor);
            if (i != dtoDoctors.size() - 1) queryBuilder.withOr();
        }
        return (List<Doctor__c>) queryBuilder.executeQuery();
    }

    public List<DoctorDto> getDoctorsThatRequireUpdate(List<DoctorDto> dtoDoctors, List<Doctor__c> doctors) {
        List<DoctorDto> doctorsToUpdate = new List<DoctorDto>();
        for (DoctorDto doctorDto : dtoDoctors) {
            for (Doctor__c doctor : doctors) {
                if (doctorDto.IdDoctor == doctor.Id) {
                    if (checkIfDoctorNeedsAnUpdate(doctorDto, doctor)) {
                        doctorsToUpdate.add(doctorDto);
                    }
                }
            }
        }
        return doctorsToUpdate;
    }
    private Boolean checkIfDoctorNeedsAnUpdate(DoctorDto doctorDto, Doctor__c doctor) {
        if(String.isBlank(doctorDto.FirstName)) doctorDto.FirstName = null;
        if(String.isBlank(doctorDto.LastName)) doctorDto.LastName = null;
        if(String.isBlank(doctorDto.Email)) doctorDto.Email = null;
        if(String.isBlank(doctorDto.City)) doctorDto.City = null;
        return doctorDto.FirstName != doctor.First_name__c || doctorDto.LastName != doctor.Last_name__c
                || doctorDto.City != doctor.City__c || doctorDto.Email != doctor.Email__c;
    }

    private List<Doctor__c> createDoctorsFromDoctorsDto(List<DoctorDto> dtoDoctors) {
        List<Doctor__c> doctors = new List<Doctor__c>();
        for (DoctorDto doctorDto : dtoDoctors) {
            doctors.add(createDoctorFromDoctorDto(doctorDto));
        }
        return doctors;
    }
    private List<DoctorDto> swapDoctorsDtoIdAndExternalId(List<DoctorDto> doctorsDto, OPERATION operation) {
        for (DoctorDto doctorDto : doctorsDto) {
            doctorDto = swapIdAndExternalId(doctorDto, operation);
        }
        return doctorsDto;
    }

    public DoctorDto swapIdAndExternalId(DoctorDto doctorDto, OPERATION operation) {
        if (operation.equals(CREATE_DOCTOR_OPERATION) && String.isBlank(doctorDto.IdDoctor)) {
            return doctorDto;
        }
        if ((operation.equals(UPDATE_DOCTOR_OPERATION) || operation.equals(DELETE_DOCTOR_OPERATION))
                && String.isBlank(doctorDto.externalId)) {
            return doctorDto;
        }
        String tmp = doctorDto.IdDoctor;
        doctorDto.IdDoctor = doctorDto.externalId;
        doctorDto.externalId = tmp;
        return doctorDto;
    }

    private Doctor__c createDoctorFromDoctorDto(DoctorDto doctorDto) {
        Doctor__c doctor = new Doctor__c();
        if (String.isNotBlank(doctorDto.externalId)) {
            doctor.ExternalDoctorId__c = doctorDto.externalId;
        }
        if (String.isNotBlank(doctorDto.LastName)) {
            doctor.Last_name__c = doctorDto.LastName;
        }
        if (String.isNotBlank(doctorDto.FirstName)) {
            doctor.First_name__c = doctorDto.FirstName;
        }
        if (String.isNotBlank(doctorDto.Email)) {
            doctor.Email__c = doctorDto.Email;
        }
        if (String.isNotBlank(doctorDto.City)) {
            doctor.City__c = doctorDto.City;
        }
        if (String.isNotBlank(doctorDto.IdDoctor)) {
            doctor.Id = doctorDto.IdDoctor;
        }
        return doctor;
    }
//


    private List<DoctorDto> prepareDoctorsDtoFromRequestBody() {
        RestRequest req = RestContext.request;
        return (List<DoctorDto>) JSON.deserialize(req.requestBody.toString(), List<DoctorDto>.class);
    }

    private DoctorDto prepareDoctorDtoFromRequestBody() {
        RestRequest req = RestContext.request;
        return (DoctorDto) JSON.deserialize(req.requestBody.toString(), DoctorDto.class);
    }

    public static List<DoctorDto> prepareDoctorsDtoFromDoctors(List<Doctor__c> doctors) {
        List<DoctorDto> dtoDoctors = new List<DoctorDto>();
        for (Doctor__c doctor : doctors) {
            dtoDoctors.add(prepareDoctorDtoFromDoctor(doctor));
        }
        return dtoDoctors;
    }


    public static DoctorDto prepareDoctorDtoFromDoctor(Doctor__c doctor) {
        return new DoctorDto()
                .setIdDoctor(doctor.Id)
                .setExternalId(doctor.ExternalDoctorId__c)
                .setFirstName(doctor.First_name__c)
                .setLastName(doctor.Last_name__c)
                .setCity(doctor.City__c)
                .setEmail(doctor.Email__c);
    }

    private static List<Doctor__c> getDoctor(Id idDoctor) {
        return [
                SELECT City__c, Email__c, ExternalDoctorId__c, First_name__c, Last_name__c
                FROM Doctor__c
                WHERE Id = :idDoctor
                LIMIT 1
        ];
    }

    private static DoctorServiceResponse handleSuccess(String msg, List<DoctorDto> doctorDto) {
        RestContext.response.statusCode = SUCCESS_CODE;
        return new DoctorServiceResponse()
                .setStatusCode(SUCCESS_CODE)
                .setMessage(msg)
                .setDoctorDto(doctorDto);
    }

    private static DoctorServiceResponse handleError(Exception e) {
        RestResponse response = RestContext.response;
        response.statusCode = ERROR_CODE;
        return new DoctorServiceResponse()
                .setMessage(e.getMessage())
                .setStatusCode(response.statusCode);
    }

    private static final String RETRIEVE_SUCCESS = 'Doctor successfully retrieved';
    private static final String DELETE_SUCCESS = 'Doctor successfully deleted';
    private static final String UPDATE_SUCCESS = 'Doctor successfully updated';
    private static final String CREATE_SUCCESS = 'Doctor successfully created';

    enum OPERATION {
        createDoctor, updateDoctor, deleteDoctor
    }

}