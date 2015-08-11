trigger LeadTrigger on Lead (after insert) {

    // CHANGE THE NAME
    TriggerSetting__c disableTriggerInstance = TriggerSetting__c.getInstance();
    if(disableTriggerInstance.Lead_Trigger__c == true) {
        return;
    }

    if(Trigger.isAfter && Trigger.isInsert) {
        CloneTriggerHandler.cloneLead(Trigger.new);
    }
}