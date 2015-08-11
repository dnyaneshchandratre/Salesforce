trigger caseUpdateTrigger on Case (before insert, before update) {

    // CHANGE THE NAME disableTriggerInstance
    TriggerSetting__c disableTriggerInstance = TriggerSetting__c.getInstance();

    // CHECK SETTING FOR TRUE VALUE AND RETURN
    if(disableTriggerInstance.Case_Update_Trigger__c == false) {

        // NO NEED TO CHECK FOR TWO DIFFERENT CONDITIONS
        // AS SAME METHOD FROM HANDLER IS BEING CALLED
        // IF(TRIGGER.ISBEFORE && (TRIGGER.ISINSERT || TRIGGER.ISUPDATE))
        if(Trigger.isBefore) {
            if(Trigger.isInsert) {
                System.debug('*/*/*/*//*/*/*/*/*/ IN TRIGGER */*/*/*/*/*/*/*/*/*/');
                caseUpdateHandler.updateCase(Trigger.new);
            }
            if(Trigger.isUpdate) {
                caseUpdateHandler.updateCase(Trigger.new);
            }
        }
    }
}