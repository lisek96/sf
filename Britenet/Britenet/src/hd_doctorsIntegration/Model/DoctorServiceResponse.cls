global class DoctorServiceResponse {
    webService Integer statusCode { get; set; }
    webService String message { get; set; }
    webService String doctorDto { get; set; }

    public DoctorServiceResponse setStatusCode(Integer returnCode) {
        this.statusCode = returnCode;
        return this;
    }
    public DoctorServiceResponse setDoctorDto(List<DoctorDto> dtoDoctors) {
        this.doctorDto = JSON.serialize(dtoDoctors);
        return this;
    }
    public DoctorServiceResponse setMessage(String message) {
        this.message = message;
        return this;
    }
}