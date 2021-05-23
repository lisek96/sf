/**
 * Created by BRITENET on 18.05.2021.
 */

public with sharing class ParkLocator {
    public static String[] country(String country){
        ParkService.ParksImplPort parksImplPort = new ParkService.ParksImplPort();
        return parksImplPort.byCountry(country);
    }
}