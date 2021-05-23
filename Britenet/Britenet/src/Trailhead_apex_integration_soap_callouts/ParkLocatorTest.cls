@IsTest
private class ParkLocatorTest {

    @IsTest
    private static void shouldReturnArrayOfStrings(){
        Test.setMock(WebServiceMock.class, new ParkServiceMock());
        String[] xx = ParkLocator.country('Poland');
        System.assert(xx!=null);
    }
}