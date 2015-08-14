trigger LeadTrigger on Lead (after insert) {

    // CHANGE THE NAME
    if(TriggerSetting__c.getInstance().Lead_Trigger__c == true) {
        return;
    }

    if(Trigger.isAfter && Trigger.isInsert) {
        CloneTriggerHandler.cloneLead(Trigger.new);
    }
}