/**
 *  Title       : Handler class for LeadTrigger
 *  Class       : caseUpdationTest
 *  Author      : Dnyanesh Chandratre
 *  Created On  : 7/16/2015
 */

public with sharing class CloneTriggerHandler {

    public static boolean isExecuted = false;

    public static void cloneLead(list<Lead> leadList) {
        Lead leadInstance;
        list<Lead> leadsToInsertList = new list<Lead>();

        for(Lead leadIterator:leadList) {
            leadInstance = leadIterator.clone();
            // leadInstance.LastName += ' -Duplicate';
            leadsToInsertList.add(leadInstance);
        }

        if(isExecuted == false) {
            isExecuted = true;
            insert leadsToInsertList;
        }

    }
}