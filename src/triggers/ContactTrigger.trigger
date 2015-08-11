trigger ContactTrigger on Contact (before insert, before update, after insert) {

    // CHANGE THE NAME disableTriggerInstance
    TriggerSetting__c disableTriggerInstance = TriggerSetting__c.getInstance();

    // CHECK TRUE AND RETURN
    if(disableTriggerInstance.Contact_Trigger__c == false) {
        if(Trigger.isBefore) {

            // NO NEED TO CHECK FOR TWO DIFFERENT CONDITIONS
            // AS SAME METHOD FROM HANDLER IS BEING CALLED
            // IF(TRIGGER.ISBEFORE && (TRIGGER.ISINSERT || TRIGGER.ISUPDATE))
            if(Trigger.isInsert) {
                ContactTriggerHandler.updateAccountLookup(Trigger.new);
            }
            if(Trigger.isUpdate) {
                ContactTriggerHandler.updateAccountLookup(Trigger.new);
            }
        }
        if(Trigger.isAfter) {
            if(Trigger.isInsert) {
                ContactTriggerHandler.SettingPrimaryContact(Trigger.new);
            }
        }
    }
}