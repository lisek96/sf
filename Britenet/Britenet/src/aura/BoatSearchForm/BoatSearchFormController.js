
({
    handleNew : function (component, event, helper){
        let createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "Boat__c",
            "defaultFieldValues": {
                "BoatType__c": component.find("selectBoatType").get("v.value")
            }
        });
        createRecordEvent.fire();
        let msg = component.find("selectBoatType").get("v.value");
        alert(msg);
    },

    doInit : function (component, event, helper){
        let isEnabled = $A.get("e.force:createRecord");
        if(isEnabled){
            component.set("v.isNewEnabled", true);
        }
        let action = component.get("c.getBoatTypes");
        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.boatTypes", response.getReturnValue());
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
    },

    search : function (component, event, helper){
        let action = component.get("c.getBoats");
        action.setParams({
            "boatTypeId": component.find("selectBoatType").get("v.value")
        })
        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.searchedBoats", response.getReturnValue());
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
    }
});