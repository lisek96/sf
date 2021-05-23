/**
 * Created by BRITENET on 18.05.2021.
 */

global class ParkServiceMock implements WebServiceMock{

    public void doInvoke(Object stub,
            Object request,
            Map<String, Object> response,
            String endpoint,
            String soapAction,
            String requestName,
            String responseNS,
            String responseName,
            String responseType) {

        ParkService.byCountryResponse response_x = new ParkService.byCountryResponse();
        response_x.return_x = new String[5];
        response.put('response_x', response_x);
    }
}