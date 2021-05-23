/**
 * Created by BRITENET on 17.05.2021.
 */
@IsTest
private class AnimalLocatorTest {

    @IsTest
    private static void shouldReturnName(){

        Test.setMock(HttpCalloutMock.class, new AnimalLocatorMock());

        String id = AnimalLocator.getAnimalNameById(1);

        System.assert(id!=null);
    }
}