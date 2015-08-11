trigger createTaskTrigger on Account (after insert) {

    // MERGE THIS TRIGGER WITH ACCOUNT TRIGGER
    TriggerSetting__c disableTriggerInstance = TriggerSetting__c.getInstance();
    if(disableTriggerInstance.Create_Task_Trigger__c == false) {
        if(Trigger.isAfter) {
            if(Trigger.isInsert)
                createTaskHandler.createTask(Trigger.new);
        }
    }
}