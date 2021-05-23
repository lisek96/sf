global class HospitalRequestDto {
    webService String hospitalName { get; set;}
    webService String city { get; set; }
    webService Boolean publicHospital { get;  set;}
    webService String hospitalId {get; set;}

    public HospitalRequestDto setHospitalId(String hospitalId) {
        this.hospitalId = hospitalId;
        return this;
    }

    public HospitalRequestDto setHospitalName(String hospitalName) {
        this.hospitalName = hospitalName;
        return this;
    }
    public HospitalRequestDto setCity(String city) {
        this.city = city;
        return this;
    }
    public HospitalRequestDto setPublicHospital(Boolean publicHospital) {
        this.publicHospital = publicHospital;
        return this;
    }
}