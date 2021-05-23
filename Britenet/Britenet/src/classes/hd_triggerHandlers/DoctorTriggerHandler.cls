public class DoctorTriggerHandler {
    public static List<String> contractConflicts {get; set;}
    public static void setNextBirthdayFor(List<Doctor__c> doctors) {
        for (Doctor__c doctor : doctors) {
            doctor.NextBirthDay__c = getNextBirthday(doctor.Birth_Date__c);
        }
    }
    private static Date getNextBirthday(Date birthDate) {
        Integer birthMonth = birthDate.month();
        Integer birthDay = birthDate.day();
        Integer thisYear = Date.today().year();
        Date dateToCheckIfTodayIsAfterOrBeforeBirthday = Date.newInstance(thisYear, birthMonth, birthDay);
        if (isPast(dateToCheckIfTodayIsAfterOrBeforeBirthday)) {
            return Date.newInstance(thisYear + 1, birthMonth, birthDay);
        } else {
            return Date.newInstance(thisYear, birthMonth, birthDay);
        }
    }
    private static boolean isPast(Date birthDate) {
        return birthDate < Date.today();
    }
}


