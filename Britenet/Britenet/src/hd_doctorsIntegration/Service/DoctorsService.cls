public interface DoctorsService {

    DoctorServiceResponse deleteDoctors();
    DoctorServiceResponse createDoctors();
    DoctorServiceResponse updateDoctors();
    DoctorServiceResponse doCreateAckUpdate();

}