public with sharing class HospitalsAndDoctorsTriggerHandler {
    public static List<String> errorMessages;

    public static void validateNewContracts(List<Hospitals_Doctors__c> newContracts) {
        errorMessages = new List<String>();
        checkIfContractsStartDateIsBeforeEndDate(newContracts);
        checkIfNewContractsDoesntOverlapWithEachOther(newContracts);
        if (!errorMessages.isEmpty()) {
            newContracts.get(0).addError(getMessageForUser(), false);
            return;
        }
        for (Hospitals_Doctors__c newContract : newContracts) {
            List<Hospitals_Doctors__c> doctorContracts = getAllContracts(newContract.Doctor__c);
            for (Hospitals_Doctors__c doctorContract : doctorContracts) {
                checkIfNewContractDoesntOverLapOnValidContractThatIsAlreadyInSystem(
                        newContract.startDate__c, newContract.endDate__c, doctorContract);
            }
            if (errorMessages.size() != 0) {
                Long contractLength = newContract.startDate__c.daysBetween(newContract.endDate__c);
                getFirstAvailableTerm(contractLength, doctorContracts);
                newContract.addError(getMessageForUser(), false);
            }
            errorMessages.clear();
        }
    }
    private static List<Hospitals_Doctors__c> getAllContracts(Id doctorId) {
        return [
                SELECT startDate__c, endDate__c
                FROM Hospitals_Doctors__c
                WHERE Doctor__c = :doctorId
                ORDER BY startDate__c
        ];
    }
    private static void checkIfNewContractDoesntOverLapOnValidContractThatIsAlreadyInSystem(Date newContractStartDate,
            Date newContractendDate, Hospitals_Doctors__c contract) {
        if (contract.StartDate__c <= newContractendDate && contract.EndDate__c >= newContractStartDate) {
            errorMessages.add(
                    'Conflict, doctor has already signed a contract during that time (' + contract.startDate__c.format() + ' to '
                            + contract.endDate__c.format() + ') <br/>');
        }
    }
    private static void checkIfNewContractsDoesntOverlapWithEachOther(List<Hospitals_Doctors__c> newContracts) {
        for (Integer i = 0; i < newContracts.size(); i++) {
            Hospitals_Doctors__c contractToCheck = newContracts.get(i);
            for (Integer j = i + 1; j < newContracts.size(); j++) {
                Hospitals_Doctors__c counterContract = newContracts.get(j);
                if (contractToCheck.Doctor__c != counterContract.Doctor__c) continue;
                if (counterContract.StartDate__c <= contractToCheck.EndDate__c &&
                        counterContract.EndDate__c >= contractToCheck.StartDate__c) {
                    errorMessages.add(
                            'Conflict, new contracts dates overlap with each other (' +
                                    contractToCheck.startDate__c.format() + ' to '
                                    + contractToCheck.endDate__c.format() + 'overlaps with: ' +
                                    counterContract.startDate__c.format() + 'to ' +
                                    counterContract.endDate__c.format() + ' <br/>');
                }
            }
        }
    }
    private static void checkIfContractsStartDateIsBeforeEndDate(List<Hospitals_Doctors__c> newContracts) {
        for (Hospitals_Doctors__c newContract : newContracts) {
            if (newContract.startDate__c > newContract.endDate__c) {
                errorMessages.add('Conflict, new contract dates are invalid, start date is after end date...'
                        + newContract.startDate__c.format() + ' to ' + newContract.endDate__c.format() + ' <br/>');
            }
        }
    }
    private static void getFirstAvailableTerm(Long contractLength, List<Hospitals_Doctors__c> contracts) {
        Date endDate;
        for (Hospitals_Doctors__c contract : contracts) {
            if (endDate == null) {
                endDate = contract.endDate__c;
                continue;
            }
            Long doctorsBreakAfterTheContract = endDate.daysBetween(contract.startDate__c);
            if (doctorsBreakAfterTheContract >= contractLength) {
                errorMessages.add('You can sign this doctor between: ' + endDate.format() + ' and ' + contract.startDate__c.format());
                return;
            }
            endDate = contract.endDate__c;
        }
        errorMessages.add('You can sign this doctor after: ' + endDate);
    }
    private static String getMessageForUser() {
        String messageForUser = '';
        for (String s : errorMessages) {
            messageForUser += s;
        }
        return messageForUser;
    }
}