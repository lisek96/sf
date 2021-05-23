/**
 * Created by BRITENET on 18.05.2021.
 */

trigger OrderEventTrigger on Order_Event__e (after insert) {
    for(Order_Event__e event : Trigger.new){
        if(event.Has_Shipped__c == true){
            insert new Task(Priority='Medium',
                    Subject='Follow up on shipped order ' + event.Order_Number__c,
                    OwnerId= event.CreatedById);
        }
    }
}