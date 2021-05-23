public class DoctorDto {
    public String IdDoctor {get; set; }
    public String FirstName { get; set; }
    public String LastName { get; set; }
    public String Email { get; set; }
    public String City { get; set; }
    public String externalId {get; set;}

    public DoctorDto setIdDoctor(String idDoctor){
        if(idDoctor==null) {
            this.IdDoctor = '';
        }
        else{
            this.idDoctor=idDoctor;
        }
        return this;
    }
    public DoctorDto setFirstName(String firstName){
        if(firstName==null){
            this.FirstName='';
        }
        else{
            this.firstName=firstName;
        }
        return this;
    }
    public DoctorDto setLastName(String lastName){
        if(lastName==null){
            this.LastName='';
        }
        else{
            this.lastName=lastName;
        }
        return this;
    }
    public DoctorDto setEmail(String email){
        if(email==null){
            this.email='';
        }
        else{
            this.email=email;
        }
        return this;
    }
    public DoctorDto setCity(String city){
        if(city==null){
            this.city='';
        }
        else{
            this.city=city;
        }
        return this;
    }
    public DoctorDto setExternalId(String externalId){
        if(externalId==null){
            this.externalId='';
        }
        else{
            this.externalId = externalId;
        }
        return this;
    }
}