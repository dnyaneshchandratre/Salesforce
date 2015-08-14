trigger AccountTrigger on Account (before insert,
                                   before update,
                                   before delete,
                                   after insert,
                                   after update,
                                   after delete,
                                   after undelete) {

    // CHANGE THE NAME disableTriggerInstance [Done]
    TriggerSetting__c disableTriggerSetting = TriggerSetting__c.getInstance();

    // CHECK SETTING FOR TRUE VALUE AND RETURN [Done]
    if(disableTriggerSetting.Account_Trigger__c == true) {
        return;
    }

    else {
        if(Trigger.isBefore) {
            if(Trigger.isInsert) {
                AccountTriggerHandler.debugTriggerNew(Trigger.new);
            }
            if(Trigger.isUpdate) {
                AccountTriggerHandler.debugTriggerNew(Trigger.new);
                AccountTriggerHandler.debugTriggerNewMap(Trigger.newMap);
                AccountTriggerHandler.debugTriggerNew(Trigger.old);
                AccountTriggerHandler.debugTriggerNewMap(Trigger.oldMap);
            }
            if(Trigger.isDelete) {
                AccountTriggerHandler.debugTriggerNew(Trigger.old);
                AccountTriggerHandler.debugTriggerNewMap(Trigger.oldMap);
            }
        }

        // TRIGGER EVENTS HERE, ARE ONLY BEFORE INSERT AND BEFORE UPDATE
        // HOW THIS PART WAS TESTED?? [Done]
        if(Trigger.isAfter) {
            if(Trigger.isInsert) {
                AccountTriggerHandler.debugTriggerNew(Trigger.new);
                AccountTriggerHandler.debugTriggerNewMap(Trigger.newMap);
            }
            if(Trigger.isUpdate) {
                AccountTriggerHandler.debugTriggerNew(Trigger.new);
                AccountTriggerHandler.debugTriggerNewMap(Trigger.newMap);
                AccountTriggerHandler.debugTriggerNew(Trigger.old);
                AccountTriggerHandler.debugTriggerNewMap(Trigger.oldMap);
            }
            if(Trigger.isDelete) {
                AccountTriggerHandler.debugTriggerNew(Trigger.old);
                AccountTriggerHandler.debugTriggerNewMap(Trigger.oldMap);
            }
            if(Trigger.isUndelete) {
                AccountTriggerHandler.debugTriggerNew(Trigger.new);
                AccountTriggerHandler.debugTriggerNewMap(Trigger.newMap);
            }
        }
    }
}