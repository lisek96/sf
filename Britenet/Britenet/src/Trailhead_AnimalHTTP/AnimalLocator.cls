/**
 * Created by BRITENET on 17.05.2021.
 */
global class AnimalLocator {
    public static String getAnimalNameById(Integer id) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://th-apex-http-callout.herokuapp.com/animals/'+id);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        animal animal = (animal) JSON.deserialize(JSON.serialize(results.get('animal')), animal.class);
        return animal.name;
    }

   global class animal{
        webservice String id;
        webservice String name;
        webservice String eats;
        webservice String says;
    }
}