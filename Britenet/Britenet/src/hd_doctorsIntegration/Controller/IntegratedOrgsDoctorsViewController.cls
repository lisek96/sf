global class IntegratedOrgsDoctorsViewController {

    public List<StatusDoctorWrapper> retrievedDoctors { get; set; }
    public IntegratedOrgsDoctorsViewService retrieveService = new IntegratedOrgsDoctorsViewServiceImp();
    public CreateUpdateDeleteService cudService = new CreateUpdateDeleteDoctorServiceImp();
    public DoctorDto searchParams { get; set; }
    public Integer shownDoctorsNumber { get; set; }
    private final Integer fixedNumberOfShownDoctors = 5;
    public String doctorToOperateOnId { get; set; }
    public String doctorToOperateOnStatus { get; set; }
    public DoctorDto doctorToEdit { get; set; }
    public DoctorDto doctorToCreate { get; set; }

    public IntegratedOrgsDoctorsViewController() {
        showFixedNumberOfDoctors();
        doctorToEdit = new DoctorDto();
        doctorToCreate = new DoctorDto();
        searchParams = new DoctorDto();
        retrievedDoctors = new List<StatusDoctorWrapper>();
    }
    public void showAllDoctors() {
        shownDoctorsNumber = retrievedDoctors.size();
    }

    public void showFixedNumberOfDoctors() {
        shownDoctorsNumber = fixedNumberOfShownDoctors;
    }

    public PageReference assign() {
        return null;
    }

    public PageReference updateDoctor() {
        if (doctorToOperateOnStatus .equals(Utils.EXTERNAL_STATUS)) {
            List<DoctorDto> doctor = new List<DoctorDto>();
            doctor.add(doctorToEdit);
            cudService.updateExternalOnlyDoctor(doctor);
        } else {
            update new Doctor__c(Id = doctorToEdit.IdDoctor,
                    First_Name__c = doctorToEdit.FirstName,
                    Last_Name__c = doctorToEdit.LastName,
                    City__c = doctorToEdit.City,
                    Email__c = doctorToEdit.Email,
                    ExternalDoctorId__c = doctorToEdit.externalId);
        }

        return null;
    }

    public void createDoctor(){
        Doctor__c doctor = new Doctor__c(
                First_Name__c=doctorToCreate.FirstName,
                Last_Name__c=doctorToCreate.LastName,
                City__c=doctorToCreate.City,
                Email__c=doctorToCreate.Email
                );
        insert doctor;
    }

    public void getDoctors() {
        List<StatusDoctorWrapper> wrappedDoctorsWithStatus = retrieveService.getDoctors(searchParams);
        retrievedDoctors = wrappedDoctorsWithStatus;
    }

    public void deleteDoctor() {
        if (doctorToOperateOnStatus .equals(Utils.EXTERNAL_STATUS)) {
            List<DoctorDto> doctor = new List<DoctorDto>();
            doctor.add(new DoctorDto().setIdDoctor(doctorToOperateOnId));
            cudService.deleteExternalOnlyDoctor(doctor);
        } else {
            delete new Doctor__c(Id = doctorToOperateOnId);
        }
        for(Integer i=0; i<retrievedDoctors.size(); i++){
            if(retrievedDoctors[i].IdDoctor == doctorToOperateOnId){
                retrievedDoctors.remove(i);
                return;
            }
        }

    }
}