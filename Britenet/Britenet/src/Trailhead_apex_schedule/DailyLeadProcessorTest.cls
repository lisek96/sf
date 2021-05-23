@IsTest
private class DailyLeadProcessorTest{

    @TestSetup
    private static void setup(){
        List<Lead> l= new List<Lead>();
        lead l1= new Lead();
        l1.LastName='surya';
        l1.Company='Company';
        l1.Status='Closed-Converted';
        l1.LeadSource='';
        l.add(l1);
        insert l;
    }

    @IsTest
    private static void shouldUpdateAllRecords(){
        DailyLeadProcessor dailyLeadProcessor = new DailyLeadProcessor();
        String sch = '20 30 8 10 2 ?';
        Test.startTest();
        String jobID = System.schedule('Remind Opp Owners', sch, dailyLeadProcessor);
        Test.stopTest();
    }
}