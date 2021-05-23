@IsTest
public class SoapDoctorMultiRequestMockTest implements WebServiceMock {
    Map<String, WebServiceMock> mocks = new Map<String, WebServiceMock>();

    public SoapDoctorMultiRequestMockTest(Map<String, WebServiceMock> mocks) {
        this.mocks = mocks;
    }
    public void doInvoke(Object stub,
            Object request,
            Map<String, Object> response,
            String endpoint,
            String soapAction,
            String requestName,
            String responseNS,
            String responseName,
            String responseType) {
        System.debug(requestName);
        WebServiceMock mock = mocks.get(requestName);
        mock.doInvoke(
                stub, request, response, endpoint, soapAction, requestName, responseNS, responseName, responseType
        );
    }

    public void addMock(String name, WebServiceMock mock) {
        mocks.put(name, mock);
    }

    public class UpdateMock implements WebServiceMock {
        public void doInvoke(Object stub,
                Object request,
                Map<String, Object> response,
                String endpoint,
                String soapAction,
                String requestName,
                String responseNS,
                String responseName,
                String responseType) {
            DoctorsWebService.updateDoctorResponse_element responseElement =
                    new DoctorsWebService.updateDoctorResponse_element();
            responseElement.result = true;
            response.put('response_x', responseElement);
        }
    }
    public class CreateMock implements WebServiceMock {
        public void doInvoke(Object stub,
                Object request,
                Map<String, Object> response,
                String endpoint,
                String soapAction,
                String requestName,
                String responseNS,
                String responseName,
                String responseType) {
            DoctorsWebService.createDoctorResponse_element responseElement =
                    new DoctorsWebService.createDoctorResponse_element();
            responseElement.result = 'testID';
            response.put('response_x', responseElement);
        }
    }
    public class DeleteMock implements WebServiceMock {
        public void doInvoke(Object stub,
                Object request,
                Map<String, Object> response,
                String endpoint,
                String soapAction,
                String requestName,
                String responseNS,
                String responseName,
                String responseType) {
            DoctorsWebService.deleteDoctorResponse_element responseElement =
                    new DoctorsWebService.deleteDoctorResponse_element();
            responseElement.result = true;
            response.put('response_x', responseElement);
        }
    }
    public class RetrieveMock implements WebServiceMock {
        public void doInvoke(Object stub,
                Object request,
                Map<String, Object> response,
                String endpoint,
                String soapAction,
                String requestName,
                String responseNS,
                String responseName,
                String responseType) {
            DoctorsWebService.retrieveDoctorsResponse_element responseElement =
                    new DoctorsWebService.retrieveDoctorsResponse_element();
            List<SoapDoctor> doctors = new List<SoapDoctor>();
            doctors.add(new SoapDoctor());
            responseElement.result = JSON.serialize(doctors);
            response.put('response_x', responseElement);
        }
    }
    public class loginMock implements WebServiceMock {
        public void doInvoke(Object stub,
                Object request,
                Map<String, Object> response,
                String endpoint,
                String soapAction,
                String requestName,
                String responseNS,
                String responseName,
                String responseType) {
            partnerSoapSforceCom.loginResponse_element loginResponseElement = new partnerSoapSforceCom.loginResponse_element();
            loginResponseElement.result = new partnerSoapSforceCom.LoginResult();
            loginResponseElement.result.sessionId='testSessionId';
            response.put('response_x', loginResponseElement);
        }
    }
}
