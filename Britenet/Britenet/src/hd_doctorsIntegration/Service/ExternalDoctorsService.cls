public with sharing class ExternalDoctorsService {

    @Future(Callout=true)
    public static void sendCreateDoctorsRequest(String doctorsDtoJson) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:Integration2/services/apexrest/doctors/');
        request.setMethod('POST');
        request.setBody(doctorsDtoJson);
        request.setHeader('Content-Type', 'application/json');
        http.send(request);
    }

    public class UpdateDoctorRequestSender implements Queueable, Database.AllowsCallouts {
        private String doctorsDtoJson;

        public UpdateDoctorRequestSender(String doctorsDtoJson) {
            this.doctorsDtoJson = doctorsDtoJson;
        }
        public void execute(QueueableContext ctx) {
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('callout:Integration2/services/apexrest/doctors/');
            request.setMethod('PUT');
            request.setBody(doctorsDtoJson);
            request.setHeader('Content-Type', 'application/json');
            http.send(request);
        }
    }

    public class DeleteDoctorRequestSender implements Queueable, Database.AllowsCallouts {
        private String doctorsDtoJson;

        public DeleteDoctorRequestSender(String doctorsDtoJson) {
            this.doctorsDtoJson = doctorsDtoJson;
        }
        public void execute(QueueableContext ctx) {
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('callout:Integration2/services/apexrest/doctors/');
            request.setMethod('DELETE');
            request.setBody(doctorsDtoJson);
            request.setHeader('Content-Type', 'application/json');
            http.send(request);
        }
    }

    public class CreateAckSender implements Queueable, Database.AllowsCallouts {
        private String doctorsDtoJson;

        public CreateAckSender(String doctorsDtoJson) {
            this.doctorsDtoJson = doctorsDtoJson;
        }

        public void execute(QueueableContext ctx) {
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('callout:Integration2/services/apexrest/doctors/');
            request.setMethod('PATCH');
            request.setBody(doctorsDtoJson);
            request.setHeader('Content-Type', 'application/json');
            http.send(request);
        }
    }

}