public class IntegratedOrgsDoctorsViewServiceImp implements IntegratedOrgsDoctorsViewService {

    public List<StatusDoctorWrapper> getDoctors(DoctorDto params) {
        List<StatusDoctorWrapper> externalDoctors = getDoctorsFromExternalOrg(params);
        List<StatusDoctorWrapper> internalDoctors = getDoctorsFromThisOrg(params);
        List<StatusDoctorWrapper> allDoctors = new List<StatusDoctorWrapper>();
        allDoctors.addAll(internalDoctors);
        allDoctors.addAll(getExternalOnlyDoctors(externalDoctors));
        return allDoctors;
    }

    public List<StatusDoctorWrapper> getDoctorsFromExternalOrg(DoctorDto params) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:Integration2/services/apexrest/doctors' + prepareUrlSearchParameters(params));
        request.setMethod('GET');
        request.setHeader('Content-Type', 'application/json');
        HttpResponse response = http.send(request);
        List<StatusDoctorWrapper> wrappedDoctorsWithStatus = (List<StatusDoctorWrapper>) JSON.deserialize(response.getBody(), List<StatusDoctorWrapper>.class);
        return wrappedDoctorsWithStatus;
    }


    public String prepareUrlSearchParameters(DoctorDto params) {
        String parameters = '?';
        if (String.isNotBlank(params.FirstName)) {
            parameters += 'firstName=' + params.firstName + '&';
        }
        if (String.isNotBlank(params.LastName)) {
            parameters += 'lastName=' + params.LastName + '&';
        }
        if (String.isNotBlank(params.Email)) {
            parameters += 'email=' + params.Email + '&';
        }
        if (String.isNotBlank(params.City)) {
            parameters += 'city=' + params.City + '&';
        }
        return parameters;
    }


    public List<StatusDoctorWrapper> wrapDoctorsIntoStatusDoctorWrapper(List<Doctor__c> doctors) {
        List<StatusDoctorWrapper> wrappedDoctorsWithStatus = new List<StatusDoctorWrapper>();
        for (Doctor__c doctor : doctors) {
            StatusDoctorWrapper statusDoctorWrapper = new StatusDoctorWrapper();
            statusDoctorWrapper
                    .setEmail(doctor.Email__c)
                    .setExternalId(doctor.ExternalDoctorId__c)
                    .setIdDoctor(doctor.Id)
                    .setCity(doctor.City__c)
                    .setFirstName(doctor.First_name__c)
                    .setLastName(doctor.Last_name__c);

            if (String.isNotBlank(doctor.ExternalDoctorId__c)) {
                statusDoctorWrapper.status = Utils.INTEGRATED_STATUS;
            } else {
                statusDoctorWrapper.status = Utils.INTERNAL_STATUS;
            }
            wrappedDoctorsWithStatus.add(statusDoctorWrapper);
        }
        return wrappedDoctorsWithStatus;
    }

    public List<StatusDoctorWrapper> getDoctorsFromThisOrg(DoctorDto params) {
        Map<String, String> paramKey_doctorField = prepareFieldValueMap(params);
        QueryBuilder queryBuilder = new QueryBuilder('SELECT Id, First_Name__c, Last_name__c, Email__c, City__c, ExternalDoctorId__c FROM Doctor__c');
        if (paramKey_doctorField.size() == 0) {
            return wrapDoctorsIntoStatusDoctorWrapper(queryBuilder.executeQuery());
        }
        Integer i = 0;
        queryBuilder.withWhere();
        for (String key : paramKey_doctorField.keySet()) {
            queryBuilder.withLikeStartsWith(key, paramKey_doctorField.get(key));
            i++;
            if (i != paramKey_doctorField.size()) queryBuilder.withAnd();
        }
        return wrapDoctorsIntoStatusDoctorWrapper(queryBuilder.executeQuery());
    }

    public Map<String, String> prepareFieldValueMap(DoctorDto params) {
        Map<String, String> field_value = new Map<String, String>();
        if (!String.isBlank(params.FirstName)) {
            field_value.put(Utils.FirstName, params.FirstName);
        }
        if (!String.isBlank(params.LastName)) {
            field_value.put(Utils.LastName, params.LastName);
        }
        if (!String.isBlank(params.Email)) {
            field_value.put(Utils.Email, params.Email);
        }
        if (!String.isBlank(params.City)) {
            field_value.put(Utils.City, params.City);
        }
        return field_value;
    }

    public List<StatusDoctorWrapper> getExternalOnlyDoctors(List<StatusDoctorWrapper> external) {
        List<StatusDoctorWrapper> externalOnly = new List<StatusDoctorWrapper>();
        for (StatusDoctorWrapper externalDoctor : external) {
            if (String.isBlank(externalDoctor.externalId)) {
                externalOnly.add(externalDoctor);
            }
        }
        return externalOnly;
    }
}