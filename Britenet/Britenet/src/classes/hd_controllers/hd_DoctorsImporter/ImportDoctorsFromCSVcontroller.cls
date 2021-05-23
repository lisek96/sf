public with sharing class ImportDoctorsFromCSVcontroller {
    public String doctorsFile { get; set; }
    public List<DoctorImportWrapper> wrappedDoctors { get; set; }
    public Boolean enableButtons {get;set;}
    private String doctorViewPageUrlWithIdParameter = System.Label.doctorViewPageUrl;
    public String viewedDoctorId {get; set;}

    public ImportDoctorsFromCSVcontroller() {
        enableButtons=false;
        wrappedDoctors = new List<DoctorImportWrapper>();
    }

    public PageReference processDoctorsFile() {
        if(doctorsFile=='') {
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,
                    'Upload file first'));
            return null;
        }
        wrappedDoctors.clear();
        List<String> doctors = doctorsFile.split('\n');
        String[] columns = doctors.get(0).split(',');
        doctors.remove(0);
        for (String s : doctors) {
            String[] doctorString = s.split(',');
            Doctor__c doctor = new Doctor__c();
            for (Integer i = 0; i < columns.size(); i++) {
                doctor.put(columns[i].trim(), doctorString[i].trim());
            }
            wrappedDoctors.add(new DoctorImportWrapper(doctor, false, 'Loaded'));
        }
        if(!wrappedDoctors.isEmpty()) enableButtons=true;
        doctorsFile = '';
        return null;
    }

    public PageReference view(){
        return new PageReference(doctorViewPageUrlWithIdParameter+viewedDoctorId);
    }

    public PageReference all(){
        for(DoctorImportWrapper wrappedDoctor : wrappedDoctors){
            wrappedDoctor.selected = true;
        }
        return null;
    }
    public PageReference None(){
        for(DoctorImportWrapper wrappedDoctor : wrappedDoctors){
            wrappedDoctor.selected = false;
        }
        return null;
    }
    public PageReference Reverse(){
        for(DoctorImportWrapper wrappedDoctor : wrappedDoctors){
            if(!wrappedDoctor.selected) wrappedDoctor.selected= true;
            else wrappedDoctor.selected=false;
        }
        return null;
    }
    public PageReference Clear(){
        wrappedDoctors = new List<DoctorImportWrapper>();
        enableButtons=false;
        return null;
    }

    public PageReference ImportDoctors(){
        List<Doctor__c> doctorsToImport = new List<Doctor__c>();
        List<DoctorImportWrapper> usedWrappedDoctors = new List<DoctorImportWrapper>();
        for(DoctorImportWrapper wrappedDoctor : wrappedDoctors){
            wrappedDoctor.status = 'Loaded';
            if(wrappedDoctor.selected){
                doctorsToImport.add(wrappedDoctor.doctor);
                usedWrappedDoctors.add(wrappedDoctor);
            }
        }
        try {
            List<Database.UpsertResult> saveResults = Database.upsert(doctorsToImport, false);
            for (Integer i = 0; i < saveResults.size(); i++) {
                usedWrappedDoctors[i].status = saveResults[i].isSuccess() ? 'Success' : 'Fail' + ' ' + saveResults[i].getErrors()[0].getMessage();
            }
        } catch (Exception e) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Info, e.getMessage());
            ApexPages.addMessage(msg);
        }
        return null;
    }

    public class DoctorImportWrapper {
        public Doctor__c doctor { get; set; }
        public Boolean selected { get; set; }
        public String status { get; set; }

        DoctorImportWrapper(Doctor__c doctor, Boolean selected, String status) {
            this.doctor=doctor;
            this.selected=selected;
            this.status=status;
        }
    }

}