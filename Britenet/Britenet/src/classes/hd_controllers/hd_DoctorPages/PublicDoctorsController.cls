global class PublicDoctorsController {
    public List<Doctor__c> doctors { get; set; }
    public List<Doctor__c> doctorsToShow {get; set;}

    public PublicDoctorsController() {
        Integer doctorsCount = [SELECT COUNT() FROM Doctor__c];
        Integer offsetNumber = 0;
        if(doctorsCount>5)
            offsetNumber = Integer.valueof((Math.random() * (doctorsCount-5)));
        doctors = [
                SELECT First_Name__c,
                        Last_Name__c,
                        Birth_Date__c,
                        Specialization__c,
                        Country__c
                FROM Doctor__c
                LIMIT 5
                OFFSET : offsetNumber
        ];
    }
}