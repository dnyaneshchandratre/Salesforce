/**
 *  Title       : Handler class for ContactTrigger
 *  Class       : ContactTriggerHandler
 *  Author      : Dnyanesh Chandratre
 *  Created On  : 7/23/2015
 */

public with sharing class ContactTriggerHandler {

    /*public static void updateAccountLookup(List<Contact> newContacts) {

        // SPACE IN ONE LINER COMMENT
        // CHANGE THE NAME accList
        // QUERY INDENTATION AND CAPITALIZATION
        //Fetch accounts with not null domain
        List<Account> accList = [SELECT a.Website,
                                        a.Id
                                 FROM Account a
                                 WHERE a.Website <> NULL
                                 ORDER BY a.Name];

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
        }
    }*/

    // UPDATE METHOD NAME TO HAVE VERB FORM [Done]
    public static void populatePrimaryContact(List<Contact> contactList) {

        // CHANGE NAME [Done]
        Account accountInstance;
        List<Account> accountList = new List<Account>();

        for(Contact contactIterator : contactList) {
            // WHILE DEALING WITH STRINGS, USE isBlank OR isNotBlank METHODS [Done]
            // THEY CHECK FOR NULL AS WELL AS BLANK VALUES [Done]
            // HERE BLANK VALUES ARE NOT HANDLED [Done]
            if(
                contactIterator.Primary__c <> true &&
                String.isNotBlank(contactIterator.AccountId) && 
                String.isNotBlank(contactIterator.Email)
            ) {
                System.debug('IN HANDLER IF PART************* : ' + contactIterator.Email);
                accountInstance = new Account(Id = contactIterator.AccountId);
                accountInstance.Primary_Contact__c = contactIterator.Email;
                accountList.add(accountInstance);
            }
        }

        if(accountList.isEmpty() <> true) {
            update accountList;
        }

    }
}