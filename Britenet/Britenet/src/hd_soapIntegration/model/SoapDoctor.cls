public with sharing class SoapDoctor {
    public String idSoapDoctor { get; set; }
    public String firstName { get; set; }
    public String lastName { get; set; }
    public String email { get; set; }
    public String city { get; set; }


    public SoapDoctor idSoapDoctor(String idSoapDoctor){
        this.idSoapDoctor=idSoapDoctor;
        return this;
    }
    public SoapDoctor firstName(String firstName){
        this.firstName=firstName;
        return this;
    }
    public SoapDoctor lastName(String lastName){
        this.lastName=lastName;
        return this;
    }
    public SoapDoctor email(String email){
        this.email=email;
        return this;
    }
    public SoapDoctor city(String city){
        this.city=city;
        return this;
    }
}