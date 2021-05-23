/**
 * Created by BRITENET on 06.05.2021.
 */

public with sharing class LookForHospitalController {
    public String hospitalName { get; set; }
    public Hospital__c hospital { get; set; }
    public List<Hospital__c> foundHospitals { get; set; }
    public String informationForUser { get; set; }
    public ApexPages.StandardSetController setCon { get; set; }
    public Boolean showTable { get; set; }
    public Doctor__c doctor { get; set; }
    public String selectedHospitalId { get; set; }
    public Hospitals_Doctors__c newContract { get; set; }
    public Boolean datesFilled { get; set; }
    public String selectedHospitalName { get; set; }
    public Boolean show {get; set;}
    public Integer shownHospitalsNumber {get; set;}

    public LookForHospitalController() {
        init();
    }
    public void init() {
        shownHospitalsNumber=5;
        selectedHospitalId = '';
        hospital = new Hospital__c();
        foundHospitals = new List<Hospital__c>();
        doctor = getDoctor();
        showTable = false;
        newContract = new Hospitals_Doctors__c();
        datesFilled = false;
        show=true;
    }

    private Doctor__c getDoctor() {
        String hireProcessDoctorID = ApexPages.currentPage().getParameters().get('id');
        Doctor__c doctor = [SELECT First_Name__c, Last_Name__c FROM Doctor__c WHERE Id = :hireProcessDoctorID];
        return doctor;
    }

    public void getFirstFreeDatesForDoctorContract() {
        List<Hospitals_Doctors__c> contracts = getDoctorContracts();
        datesFilled = true;
        if (contracts.size() == 0 || contracts.get(0).StartDate__c > Date.today()) {
            newContract.startDate__c = date.today();
            newContract.endDate__c = contracts.size() == 0 ? Date.newInstance(
                    date.today().year() + 1,
                    date.today().month() + 1,
                    date.today().day() + 1
            ) : contracts.get(0).StartDate__c.addDays(-1);
            return;
        }
        for (Integer i = 0; i < contracts.size() - 1; i++) {
            Integer timeBetweenContracts = contracts.get(i).endDate__c.daysBetween(contracts.get(i + 1).startDate__c);
            if (timeBetweenContracts > 1) {
                newContract.startDate__c = contracts.get(i).endDate__c.addDays(1);
                newContract.endDate__c = contracts.get(i + 1).startDate__c.addDays(-1);
                return;
            }
        }
        newContract.startDate__c = contracts.get(contracts.size() - 1).endDate__c.addDays(1);
        newContract.endDate__c = contracts.get(contracts.size() - 1).endDate__c.addYears(2);
        return;
    }
    public List<Hospitals_Doctors__c> getDoctorContracts() {
        return [
                SELECT StartDate__c, EndDate__c
                FROM Hospitals_Doctors__c
                WHERE Doctor__c = :doctor.Id AND EndDate__c > :Date.today()
                ORDER BY StartDate__c
        ];
    }

    public void search() {
        System.debug(hospital.Country__c);
        System.debug(hospitalName);
        clear();
        QueryBuilder searchQuery = new QueryBuilder('SELECT Name, City__c, Country__c, Number_Of_Doctors__c, Min_salary__c FROM Hospital__c');
        if (hospital.Country__c == null && !String.isNotBlank(hospitalName)) {
            informationForUser = 'You have not specified Country and Hospital name by which you want to look for hospitals, so we retrieved all Hospitals';
        } else {
            searchQuery.withWhere();
            if (hospital.Country__c == null && String.isNotBlank(hospitalName)) {
                informationForUser = 'You have specified Hospital name, so we retrieved all Hospitals which names start with your input Hospital name';
                searchQuery.withLike('Name', hospitalName);
            } else if (hospital.Country__c != null && !String.isNotBlank(hospitalName)) {
                informationForUser = 'You have specified Country name, so we retrieved all Hospitals placed in such country';
                searchQuery.withEquals('Country__c', hospital.Country__c);
            } else if (hospital.Country__c != null && String.isNotBlank(hospitalName)) {
                informationForUser = 'You have specified Country name and Hospital name, ' +
                        'so we retrieved all Hospitals placed in such country which names start with your input Hospital name';
                searchQuery.withLike('Name', hospitalName).withAnd().withEquals('Country__c', hospital.Country__c);
            }
        }
        foundHospitals = (List<Hospital__c>) searchQuery.executeQuery();
        showTable = foundHospitals.size() != 0;
        ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO, informationForUser));
        setCon = new ApexPages.StandardSetController(foundHospitals);
        setCon.setPageSize(0);
        if (setCon.getRecords().size() == 0) {
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'No matching Hospitals found'));
        }
    }
    public void clear() {
        showTable = false;
        selectedHospitalId = '';
        datesFilled = false;
    }
    public PageReference hire() {
        newContract.Doctor__c = doctor.Id;
        newContract.Salary__c = 5000;
        newContract.Hospital__c = selectedHospitalId;
        insert newContract;
        clear();
        init();
        return new PageReference(Url.getCurrentRequestUrl().getPath()+'?id='+doctor.Id);
    }
    public PageReference showAllDoctors(){
        shownHospitalsNumber=foundHospitals.size();
        return null;
    }
    public PageReference showLessDoctors(){
        shownHospitalsNumber=5;
        return null;
    }
}
