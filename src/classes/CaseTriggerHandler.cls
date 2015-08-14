/**
 *  Title   : Handler class for CaseUpdateTrigger
 *  Class   : caseUpdateHandler
 *  Author  : Dnyanesh Chandratre
 *  Created On: 7/16/2015
 */

public with sharing class CaseTriggerHandler {

    static final String seperator = '&&';

    public static void updateCase(list<Case> caseList) {

        // CHANGE NAME OF LIST [Done]
        List<String> suppliedEmailList = new List<String>();
        for(Case caseInstance : caseList) {
            System.debug('>>>>>>>>>>>>>>> CASE MAIL : ' + caseInstance.Supplied_Mail__c);
            suppliedEmailList.add(caseInstance.Supplied_Mail__c);
        }
        List<Contact> contactList = [
            SELECT Email,
                   Account.PersonEmail__c,
                   Account.Email_Address__c,
                   Account.Id,
                   AccountId
              FROM Contact c
             WHERE Account.PersonEmail__c IN :suppliedEmailList
                OR Account.Email_Address__c IN :suppliedEmailList
          ORDER BY CreatedDate DESC
             LIMIT 1
        ];

        // CHANGE NAME OF conList [Done]
        // NULL CHECK SHOULD BE THERE BEFORE ISEMPTY() [Done]
        // IF LIST IS NULL OR EMPTY, RETURN [Done]
        if(contactList == NULL || contactList.isEmpty()) {
            return;
        }

        else {

            // ADD COLLECTION NAME AS WELL [Done]
            Map<String,String> personEmailToIdMap = new Map<String,String>();
            Map<String,String> emailAddressToIdMap = new Map<String,String>();

            // CHANGE NAME OF conInstance [Done]
            for(Contact contactInstance : contactList) {
                personEmailToIdMap .put(contactInstance.Account.PersonEmail__c,
                                    contactInstance.Id + seperator + contactInstance.AccountId);

                emailAddressToIdMap.put(contactInstance.Account.Email_Address__c,
                                     contactInstance.Id + seperator + contactInstance.AccountId);
            }

            for(Case caseInstance : caseList) {
                // IF.. ELSE WOULD BE MORE APPROPRIATE HERE
                // TAKE A NOTE, AND DISCUSS THIS WITH ME
                // [Noted, communicated. Discussion remaining]
                if(personEmailToIdMap .containsKey(caseInstance.Supplied_Mail__c)) {
                    // CHECK INDENTATION HERE AND UPDATE AT NEXT OCCURANCE [Done]
                    caseInstance.ContactId = personEmailToIdMap .get(caseInstance.Supplied_Mail__c)
                                                                .substringBefore(seperator);

                    // PROPER INDENTATION [Done]
                    caseInstance.AccountId = personEmailToIdMap .get(caseInstance.Supplied_Mail__c)
                                                                .substringAfter(seperator);
                }

                // KEEP ONE LINE GAP AFTER "}"

                if(emailAddressToIdMap.containsKey(caseInstance.Supplied_Mail__c)) {
                    // INDENTATION [Done]
                    caseInstance.ContactId = emailAddressToIdMap.get(caseInstance.Supplied_Mail__c)
                                                                .substringBefore(seperator);
                    // INDENTATON [Done]
                    caseInstance.AccountId = emailAddressToIdMap.get(caseInstance.Supplied_Mail__c)
                                                                .substringAfter(seperator);
                }

            }

        }

    }

}