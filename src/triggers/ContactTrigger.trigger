trigger ContactTrigger on Contact (before insert, before update, after insert) {

    // CHANGE THE NAME disableTriggerInstance [Done]
    // CHECK TRUE AND RETURN [Done]
    if(TriggerSetting__c.getInstance().Contact_Trigger__c == true) {
        return;
    }

    if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {

        // NO NEED TO CHECK FOR TWO DIFFERENT CONDITIONS
        // AS SAME METHOD FROM HANDLER IS BEING CALLED
        // IF(TRIGGER.ISBEFORE && (TRIGGER.ISINSERT || TRIGGER.ISUPDATE))
        // ContactTriggerHandler.updateAccountLookup(Trigger.new);
    }

    if(Trigger.isAfter && Trigger.isInsert) {
            ContactTriggerHandler.populatePrimaryContact(Trigger.new);
    }
}