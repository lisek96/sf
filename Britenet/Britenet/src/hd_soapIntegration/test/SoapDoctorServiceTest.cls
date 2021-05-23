@IsTest
private class SoapDoctorServiceTest {

    @IsTest
    private static void shouldReturnIdSetByUser() {
        TestDataManager testDataManager = new TestDataManager();
        testDataManager.createSoapDoctor();
        setMock();

        Test.startTest();
        Boolean result = new SoapDoctorService().updateDoctor(testDataManager.soapDoctor);
        Test.stopTest();

        System.assert(result);
    }

    @IsTest
    private static void shouldThrowNullPointerExceptionWhenPassedNullArgumentToUpdateDoctor() {
        Exception thrownException;
        setMock();

        Test.startTest();
        try {
            new SoapDoctorService().updateDoctor(null);
        } catch (Exception e) {
            thrownException = e;
        }
        Test.stopTest();

        System.assertEquals(new System.NullPointerException().getTypeName(), thrownException.getTypeName());
    }

    @IsTest
    private static void shouldSetDataModelSoapDoctorIdToReturnedId() {
        TestDataManager testDataManager = new TestDataManager();
        testDataManager.createSoapDoctor();
        setMock();

        Test.startTest();
        String id = new SoapDoctorService().createDoctor(testDataManager.soapDoctor).idSoapDoctor;
        Test.stopTest();

        System.assertEquals(testDataManager.soapDoctor.idSoapDoctor, id);
    }

    @IsTest
    private static void shouldThrowNullPointerExceptionWhenPassedNullArgumentToCreateDoctor() {
        Exception thrownException;
        setMock();

        Test.startTest();
        try {
            new SoapDoctorService().createDoctor(null);
        } catch (Exception e) {
            thrownException = e;
        }
        Test.stopTest();

        System.assertEquals(new System.NullPointerException().getTypeName(), thrownException.getTypeName());
    }

    @IsTest
    private static void shouldDeleteDoctor() {
        TestDataManager testDataManager = new TestDataManager();
        testDataManager.createSoapDoctor();
        setMock();

        Test.startTest();
        Boolean result = new SoapDoctorService().deleteDoctor('test');
        Test.stopTest();

        System.assert(result);
    }
    @IsTest
    private static void shouldReturnNotNullList() {
        TestDataManager testDataManager = new TestDataManager();
        testDataManager.createSearchFieldsValues();
        testDataManager.createSoapDoctor();
        setMock();

        Test.startTest();
        List<SoapDoctor> doctorsList =
                new SoapDoctorService().retrieveDoctors(TestDataManager.searchFieldsValues);
        Test.stopTest();

        System.assert(doctorsList != null);
    }
    @IsTest
    private static void shouldInitServiceComponentsAndReturnNotNullSessionId() {
        setMock();
        SoapDoctorService.isMock = false;

        Test.startTest();
        SoapDoctorService soapDoctorService = new SoapDoctorService();
        Test.stopTest();

        System.assertNotEquals(soapDoctorService.sessionWrapperInstance.sessionId, null);
    }

    private static void setMock() {
        SoapDoctorService.isMock = true;
        Test.setMock(WebServiceMock.class, prepareMultiRequestMock());
    }

    private static SoapDoctorMultiRequestMockTest prepareMultiRequestMock() {
        SoapDoctorMultiRequestMockTest soapDoctorMultiRequestMockTest = new SoapDoctorMultiRequestMockTest(new Map<String, WebServiceMock>());
        soapDoctorMultiRequestMockTest.addMock('createDoctor', new SoapDoctorMultiRequestMockTest.CreateMock());
        soapDoctorMultiRequestMockTest.addMock('updateDoctor', new SoapDoctorMultiRequestMockTest.UpdateMock());
        soapDoctorMultiRequestMockTest.addMock('deleteDoctor', new SoapDoctorMultiRequestMockTest.DeleteMock());
        soapDoctorMultiRequestMockTest.addMock('retrieveDoctors', new SoapDoctorMultiRequestMockTest.RetrieveMock());
        soapDoctorMultiRequestMockTest.addMock('login', new SoapDoctorMultiRequestMockTest.loginMock());
        return soapDoctorMultiRequestMockTest;
    }

    private class TestDataManager {
        private SoapDoctor soapDoctor;
        private Map<String, Object> searchFieldsValues;
        private FieldsContainer searchFieldsContainer;

        public void createSoapDoctor() {
            this.soapDoctor = new SoapDoctor()
                    .IdSoapDoctor('5')
                    .FirstName('Test')
                    .LastName('Test')
                    .Email('Test@mail.com')
                    .City('Test');
        }
        public void createSearchFieldsValues() {
            this.searchFieldsValues = new Map<String, Object>();
            this.searchFieldsValues.put('First_name__c', 'Testname');
        }
    }
}