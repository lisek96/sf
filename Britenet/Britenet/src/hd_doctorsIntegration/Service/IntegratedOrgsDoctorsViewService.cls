public interface IntegratedOrgsDoctorsViewService {
    String prepareUrlSearchParameters(DoctorDto params);
    List<StatusDoctorWrapper> getDoctorsFromExternalOrg(DoctorDto params);
    List<StatusDoctorWrapper> getDoctorsFromThisOrg(DoctorDto params);
    Map<String, String> prepareFieldValueMap(DoctorDto params);
    List<StatusDoctorWrapper> wrapDoctorsIntoStatusDoctorWrapper(List<Doctor__c> doctors);
    List<StatusDoctorWrapper> getDoctors(DoctorDto params);
    List<StatusDoctorWrapper> getExternalOnlyDoctors(List<StatusDoctorWrapper> external);
}