/**
 *  Title       : Handler class for ContactTrigger
 *  Class       : ContactTriggerHandler
 *  Author      : Dnyanesh Chandratre
 *  Created On  : 7/23/2015
 */

public with sharing class ContactTriggerHandler {

    public static void updateAccountLookup(List<Contact> newContacts) {

        // SPACE IN ONE LINER COMMENT
        // CHANGE THE NAME accList
        // QUERY INDENTATION AND CAPITALIZATION
        //Fetch accounts with not null domain
        List<Account> accList = [Select a.Website,
                                        a.Id
                                 From Account a
                                 where a.Website <> NULL
                                 order by a.Name];

        // VARIABLES NOT BEING USED SHOULD BE COMMENTED/REMOVED
        //Create map of websites and Ids
        Map<String, Id> mapWebsites = new Map<String,Id>();
        Map<String, Id> mapDomainsContact = new Map<String, Id>();
        String hostName;

        //[^w{3}\.]([a-zA-Z0-9]([a-zA-Z0-9\-]{0,65}[a-zA-Z0-9])?)+[a-zA-Z]{2,6}

        /*for(Account accInstance : accList) {
            mapWebsites.put(accInstance.Website,accInstance.Id);
            System.debug('++++++++++++++++ >> ' + accInstance.Website.split('/[^w{3}\\.]([a-zA-Z0-9$]([a-zA-Z0-9$\\-]{0,65}[a-zA-Z0-9$])?)+[a-zA-Z]{2,6}/g'));
        }

        for(Contact contact : newContacts) {
            String domain = contact.Email.substringBetween('@', '.');
        }

        /*map website to email address
        for(String website : mapWebsites.keyset()) {
            for(Contact conInstance : newContacts) {
                if(conInstance.Email <> NULL) {
                    if(website.containsIgnoreCase(conInstance.Email.substringBetween('@','.'))) {
                        conInstance.AccountId = mapWebsites.get(website);
                    }
                }
            }
        }*/
    }

    // UPDATE METHOD NAME TO HAVE VERB FORM
    public static void SettingPrimaryContact(List<Contact> contacts) {

        // CHANGE NAME
        Account accInstance;
        List<Account> accList = new List<Account>();

        for(Contact conIterator : contacts) {

            // WHILE DEALING WITH STRINGS, USE isBlank OR isNotBlank METHODS
            // THEY CHECK FOR NULL AS WELL AS BLANK VALUES
            // HERE BLANK VALUES ARE NOT HANDLED
            if(conIterator.Primary__c <> true && conIterator.AccountId <> NULL && conIterator.Email <> NULL) {
                System.debug('IN HANDLER IF PART************* : ' + conIterator.Email);
                accInstance = new Account(Id = conIterator.AccountId);
                accInstance.Primary_Contact__c = conIterator.Email;
                accList.add(accInstance);
            }
        }
        if(!accList.isEmpty()) {
            update accList;
        }
    }
}