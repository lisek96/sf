
({
    search : function (component, event, helper){
        let action = component.get("c.getAccounts");
        action.setParams({
            "name": component.find("nameInput").get("v.value"),
            "country": component.find("countryInput").get("v.value")
        })
        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.accounts", response.getReturnValue());
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
    },

    clear : function (component, event, helper){
        component.find("nameInput").set("v.value", "");
        component.find("countryInput").set("v.value", "");
    }
});