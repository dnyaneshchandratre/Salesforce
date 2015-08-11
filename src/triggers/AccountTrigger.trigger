trigger AccountTrigger on Account (before insert, before update) {

    // CHANGE THE NAME disableTriggerInstance
    TriggerSetting__c disableTriggerInstance = TriggerSetting__c.getInstance();

    // CHECK SETTING FOR TRUE VALUE AND RETURN
    if(disableTriggerInstance.Account_Trigger__c == false) {
        if(Trigger.isBefore) {
            if(Trigger.isInsert) {
                AccountTriggerHandler.triggerNew(Trigger.new);
            }
            if(Trigger.isUpdate) {
                AccountTriggerHandler.triggerNew(Trigger.new);
                AccountTriggerHandler.triggerNewMap(Trigger.newMap);
                AccountTriggerHandler.triggerNew(Trigger.old);
                AccountTriggerHandler.triggerNewMap(Trigger.oldMap);
            }
            if(Trigger.isDelete) {
                AccountTriggerHandler.triggerNew(Trigger.old);
                AccountTriggerHandler.triggerNewMap(Trigger.oldMap);
            }
        }

        // TRIGGER EVENTS HERE, ARE ONLY BEFORE INSERT AND BEFORE UPDATE
        // HOW THIS PART WAS TESTED??
        if(Trigger.isAfter) {
            if(Trigger.isInsert) {
                AccountTriggerHandler.triggerNew(Trigger.new);
                AccountTriggerHandler.triggerNewMap(Trigger.newMap);
            }
            if(Trigger.isUpdate) {
                AccountTriggerHandler.triggerNew(Trigger.new);
                AccountTriggerHandler.triggerNewMap(Trigger.newMap);
                AccountTriggerHandler.triggerNew(Trigger.old);
                AccountTriggerHandler.triggerNewMap(Trigger.oldMap);
            }
            if(Trigger.isDelete) {
                AccountTriggerHandler.triggerNew(Trigger.old);
                AccountTriggerHandler.triggerNewMap(Trigger.oldMap);
            }
            if(Trigger.isUndelete) {
                AccountTriggerHandler.triggerNew(Trigger.new);
                AccountTriggerHandler.triggerNewMap(Trigger.newMap);
            }
        }
    }
}