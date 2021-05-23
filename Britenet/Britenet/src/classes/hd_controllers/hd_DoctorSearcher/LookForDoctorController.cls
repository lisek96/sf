public class LookForDoctorController {
    public String firstName { get; set; }
    public String lastName { get; set; }
    public String countryName { get; set; }
    public Doctor__c doctor { get; set; }
    public Boolean showInfo { get; set; }
    public String info { get; set; }
    public List<Doctor__c> foundDoctors { get; set; }
    public ApexPages.StandardSetController setCon { get; set; }
    public Integer numberOfShowedDoctors {get; set;}

    public LookForDoctorController() {
        init();
    }

    private void init() {
        info = 'Fill the fields to search for a doctor. Country is required.';
        foundDoctors = new List<Doctor__c>();
        doctor = new Doctor__c();
        doctor.Country__c = 'Poland';
        showInfo = true;
    }

    public void save() {
        clear();
        if (doctor.Country__c == null) {
            info = 'You need to enter country to search for doctors';
            return;
        }
        QueryBuilder getDoctorsQuery = prepareQuery();
        foundDoctors = getDoctorsQuery.executeQuery();
        updateInfoWithAmoutOfRetreivedRecords(foundDoctors.size());
        cacheDataInSession();
        setCon = new ApexPages.StandardSetController(foundDoctors);
        setCon.setPageSize(1);
        if (setCon.getRecords().size() == 0) {
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'No matching Doctors found'));
        }
    }
    private void updateInfoWithAmoutOfRetreivedRecords(Integer amountOfRetreivedRecords) {
        info += ' ' + amountOfRetreivedRecords + ' records.';
    }

    private void cacheDataInSession() {
        Cache.Session.put('foundDoctors', foundDoctors);
        cacheCSVdataAboutDoctors();
    }

    private void cacheCSVdataAboutDoctors() {
        String csvFileWithDoctorsData = '';
        for (Doctor__c doctor : foundDoctors) {
            csvFileWithDoctorsData += doctor.First_Name__c + ';' + doctor.Last_Name__c + ';' + doctor.Birth_Date__c + ';'
                    + doctor.Specialization__c + ';' + doctor.Country__c + '\n';
        }
        Cache.Session.put('CsvDoctors', csvFileWithDoctorsData);
    }
    public QueryBuilder prepareQuery() {
        QueryBuilder getDoctors = new QueryBuilder('SELECT Id, First_Name__c, Last_Name__c, Birth_Date__c, Specialization__c, Country__c\n' +
                '                               FROM Doctor__c');
        getDoctors.withWhere();
        URL.getCurrentRequestUrl();
        info = 'Looking by Country. Retreived';
        if (!firstName.equals('') || !lastName.equals('')) {
            if (!firstName.equals('') && !lastName.equals('')) {
                getDoctors.withLeftParentheses().withLike('First_Name__c', firstName).withOr().withLike('Last_name__c', lastName).withRightParentheses();
                info = 'Looking by First name, Last name and Country. Retreived';
            } else if (!lastName.equals('')) {
                getDoctors.withLike('Last_name__c', lastName);
                info = 'Looking by Last name and Country. Retreived ';
            } else if (!firstName.equals('')) {
                getDoctors.withLike('First_name__c', firstName);
                info = 'Looking by First name and Country. Retreived ';
            }
            getDoctors.withAnd();
        }
        getDoctors.withEquals('Country__c', doctor.Country__c);
        return getDoctors;
    }

    public List<Doctor__c> getDoctors() {
        return setCon.getRecords();
    }

    public void clear() {
        Cache.Session.remove('foundDoctors');
        init();
    }

    public PageReference exportToXls() {
        PageReference pr = new PageReference('https://britenet81-dev-ed--c.visualforce.com/apex/ImportXLSdoctors');
        pr.setRedirect(false);
        return pr;
    }
    public PageReference exportToCsv() {
        PageReference pr = new PageReference('https://britenet81-dev-ed--c.visualforce.com/apex/ImportCSVdoctors');
        pr.setRedirect(false);
        return pr;
    }
}