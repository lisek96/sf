public class DoctorsExporterController {
    public ApexPages.StandardSetController ssc { get; set; }
    public List<Doctor__c> foundDoctors { get; set; }
    public String doctorsCSV {get; set;}

    public DoctorsExporterController(){
        foundDoctors = (List<Doctor__c>) Cache.Session.get('foundDoctors');
        doctorsCSV = (String) Cache.Session.get('CsvDoctors');
        ssc = new ApexPages.StandardSetController(foundDoctors);
    }
}