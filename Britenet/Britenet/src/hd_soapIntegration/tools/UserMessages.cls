/**
 * Created by BRITENET on 15.05.2021.
 */

public with sharing class UserMessages {
    public final static String searchFailInfo = 'You have to specify at least one field.';
    public final static String noRecordsRetrieved = 'No records retrieved, try again with different data.';
    public final static String createFormError = 'Last name, First name, Email are required.';
    public final static String saveSuccess = 'Doctor has been created\n';
    public final static String operationFailed = 'Operation failed';
    public final static String doctorDeleted = 'Doctor has been deleted';
    public final static String updateSuccess = 'Doctor has been updated';
}