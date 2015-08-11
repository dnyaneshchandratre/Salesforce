/**
 *  Title   : Handler class for CaseUpdateTrigger
 *  Class   : caseUpdateHandler
 *  Author  : Dnyanesh Chandratre
 *  Created On: 7/16/2015
 */

public with sharing class caseUpdateHandler {

    static final String seperator = '&&';

    public static void updateCase(list<Case> caseList) {

        // CHANGE NAME OF LIST
        List<String> emails = new List<String>();
        for(Case caseInstance : caseList) {
            System.debug('>>>>>>>>>>>>>>> CASE MAIL : ' + caseInstance.Supplied_Mail__c);
            emails.add(caseInstance.Supplied_Mail__c);
        }
        List<Contact> conList = [
            SELECT Email,
                   Account.PersonEmail__c,
                   Account.Email_Address__c,
                   Account.Id,
                   AccountId
              FROM Contact c
             WHERE Account.PersonEmail__c IN :emails
                OR Account.Email_Address__c IN :emails
          ORDER BY CreatedDate DESC
             LIMIT 1
        ];

        // CHANGE NAME OF conList
        // NULL CHECK SHOULD BE THERE BEFORE ISEMPTY()
        // IF LIST IS NULL OR EMPTY, RETURN
        if(!conList.isEmpty()) {

            // ADD COLLECTION NAME AS WELL
            Map<String,String> personEmailToId = new Map<String,String>();
            Map<String,String> emailAddressToId = new Map<String,String>();

            // CHANGE NAME OF conInstance
            for(Contact conInstance : conList) {
                personEmailToId.put(conInstance.Account.PersonEmail__c,
                                    conInstance.Id + seperator + conInstance.AccountId);

                emailAddressToId.put(conInstance.Account.Email_Address__c,
                                     conInstance.Id + seperator + conInstance.AccountId);
            }
            System.debug('>>>>>>>>>>>> MAP PERSON MAIL :' + personEmailToId + '\n>>>>>>>>>>>> MAP EMAIL :' + emailAddressToId);

            for(Case caseInstance : caseList) {
                System.debug('********** FOR CaseInstance : ' + caseInstance);

                // IF.. ELSE WOULD BE MORE APPROPRIATE HERE
                // TAKE A NOTE, AND DISCUSS THIS WITH ME
                if(personEmailToId.containsKey(caseInstance.Supplied_Mail__c)) {
                    System.debug('******** IN IF *** Email = ' + caseInstance.Supplied_Mail__c);

                    // CHECK INDENTATION HERE AND UPDATE AT NEXT OCCURANCE
                    caseInstance.ContactId = personEmailToId.get(caseInstance.Supplied_Mail__c)
                                                            .substringBefore(seperator);

                    // PROPER INDENTATION
                    caseInstance.AccountId = personEmailToId.get(
                                                caseInstance.Supplied_Mail__c).substringAfter(
                                                                                    seperator);
                }

                // KEEP ONE LINE GAP AFTER "}"

                if(emailAddressToId.containsKey(caseInstance.Supplied_Mail__c)) {
                    System.debug('******** IN IF *** Email = ' + caseInstance.Supplied_Mail__c);

                    // INDENTATION
                    caseInstance.ContactId = emailAddressToId.get(
                                                caseInstance.Supplied_Mail__c).substringBefore(
                                                                                   seperator);
                    // INDENTATON
                    caseInstance.AccountId = emailAddressToId.get(
                                                caseInstance.Supplied_Mail__c).substringAfter(
                                                                                    seperator);
                }
            }
        }
    }
}