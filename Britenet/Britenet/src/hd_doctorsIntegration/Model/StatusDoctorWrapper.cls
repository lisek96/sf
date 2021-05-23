global class StatusDoctorWrapper {
    webService String status { get; set; }
    webService String IdDoctor { get; set; }
    webService String FirstName { get; set; }
    webService String LastName { get; set; }
    webService String Email { get; set; }
    webService String City { get; set; }
    webService String externalId { get; set; }

    public StatusDoctorWrapper setStatus(String status) {
        if (status == null) {
            this.status = '';
        } else {
            this.status = status;
        }
        return this;
    }
    public StatusDoctorWrapper setIdDoctor(String idDoctor) {
        if (idDoctor == null) {
            this.IdDoctor = '';
        } else {
            this.idDoctor = idDoctor;
        }
        return this;
    }
    public StatusDoctorWrapper setFirstName(String firstName) {
        if (firstName == null) {
            this.FirstName = '';
        } else {
            this.firstName = firstName;
        }
        return this;
    }
    public StatusDoctorWrapper setLastName(String lastName) {
        if (lastName == null) {
            this.LastName = '';
        } else {
            this.lastName = lastName;
        }
        return this;
    }
    public StatusDoctorWrapper setEmail(String email) {
        if (email == null) {
            this.email = '';
        } else {
            this.email = email;
        }
        return this;
    }
    public StatusDoctorWrapper setCity(String city) {
        if (city == null) {
            this.city = '';
        } else {
            this.city = city;
        }
        return this;
    }
    public StatusDoctorWrapper setExternalId(String externalId) {
        if (externalId == null) {
            this.externalId = '';
        } else {
            this.externalId = externalId;
        }
        return this;
    }
}