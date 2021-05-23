public interface CreateUpdateDeleteService{
    void updateExternalOnlyDoctor(List<DoctorDto> doctor);
    void deleteExternalOnlyDoctor(List<DoctorDto> doctor);
}