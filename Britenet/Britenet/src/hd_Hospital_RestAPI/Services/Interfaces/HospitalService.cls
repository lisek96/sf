/**
 * Created by BRITENET on 16.05.2021.
 */

public interface HospitalService {
    DoctorServiceResponse getHospital();
    DoctorServiceResponse deleteHospital();
    DoctorServiceResponse updateHospital();
    DoctorServiceResponse createHospital();
}