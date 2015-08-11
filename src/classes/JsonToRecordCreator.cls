public with sharing class JsonToRecordCreator implements Database.Batchable<sObject>, Database.Stateful, Schedulable{

    // IS STATEFUL AND SCHEDULABLE NEEDED ???

    // INDENT QUERY AS IN DailyOpportunityStatus CALSS
    public final static string query = 'SELECT Name, JSON__c, Processed__c FROM Event__c where Processed__c = false';
    public List<sObject> listRecords = new List<sObject>();
    Map<String, Object> recordCreator = new Map<String, Object>();
    SObject newRecord;

    // PARAMETER NAME
    public Iterable<sObject> start(Database.BatchableContext bc) {
        System.debug('<<<<<<<<< IN START >>>>>>>>>>');
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext bc, List<Event__c> events) {
        System.debug('<<<<<<<<< IN EXECUTE >>>>>>>>>>');

        // ITERATOR SHOULD BE SIMPLE NAME OF OBJECT -> event
        for(Event__c iterator : events) {

            // DIFFERENCE BETWEEN deserializeUntyped AND deserialize
            recordCreator = (Map<String, Object>)Json.deserializeUntyped(iterator.JSON__c);
            newRecord = Schema.getGlobalDescribe().get(iterator.Name).newSObject();
            for(String fieldName : recordCreator.keySet()) {
                newRecord.put( fieldName,
                               recordCreator.get(fieldName) );
            }
            listRecords.add(newRecord);
            iterator.Processed__c = true;
        }
        if(!listRecords.isEmpty()) {
            update events;
            insert listRecords;
        }
    }
    public void execute(SchedulableContext sc) {}
    public void finish(Database.BatchableContext bc) {
        System.debug('<<<<<<<<< IN FINISH >>>>>>>>>>');
    }
}