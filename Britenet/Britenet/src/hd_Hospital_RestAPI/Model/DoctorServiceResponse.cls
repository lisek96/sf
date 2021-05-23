global class DoctorServiceResponse {
    webService Integer statusCode { get; set; }
    webService String message { get; set; }
    webService String obj { get; set; }

    public DoctorServiceResponse setStatusCode(Integer returnCode) {
        this.statusCode = returnCode;
        return this;
    }
    public DoctorServiceResponse setObj(Object obj) {
        this.obj = JSON.serialize(obj);
        return this;
    }
    public DoctorServiceResponse setMessage(String message) {
        this.message = message;
        return this;
    }
}