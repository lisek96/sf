@IsTest
private class LeadProcessorTest {

    @testSetup
    static void setup() {
        List<Lead> l= new List<Lead>();
        lead l1= new Lead();
        l1.LastName='surya';
        l1.Company='Company';
        l1.Status='Closed-Converted';
        l1.LeadSource='Dreamforce';
        l.add(l1);
        insert l;


    }
    @isTest static void test() {
        Test.startTest();
        LeadProcessor leadProcessor = new LeadProcessor();
        Id batchId = Database.executeBatch(leadProcessor);
        Test.stopTest();

        System.assertEquals(1, [select count() from lead where lead.LeadSource =: 'Dreamforce']);
    }
}