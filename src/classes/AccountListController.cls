/**
 *  Title   : Controller class for AccountList.page and RelatedContacts.page
 *  Class   : AccountListController
 *  Author  : Dnyanesh Chandratre
 *  Created On: 7/22/2015
 */

// WHY THIS CLASS IS GLOBAL?
global with sharing class AccountListController {
    /*
    public static Boolean searchFlag = false;
    global static List<Account> listAccount;
    public Boolean alphaFlag = false;
    PUBLIC List<Contact> relatedContacts;

    public static String searchKey    {get;set;}
    public Integer countOfRecords     {get;set;}
    public Id idOfAccount             {get;set;}
    public String nameOfAccount       {get;set;}
    public List<String> alphabetList  {get;set;}
    public String selectedAlphabet    {get;set;}
    */

    // INDENT AND SORT THESE
    public static Boolean searchFlag = false;
    global static List<Account> accountList;
    public Boolean alphaFlag = false;
    public List<Contact> relatedContactList;

    public Integer countOfRecords    {get;set;}
    public String searchKey          {get;set;}    // STATIC??
    public Id AccountId              {get;set;}    // NAME -> accountId
    public String AccountName        {get;set;}
    public List<String> alphabetList {get;set;}
    public String selectedAlphabet   {get;set;}

    public AccountListController() {
        alphabetList = new List<String> {
                 'A',
                 'B',
                 'C',
                 'D',
                 'E',
                 'F',
                 'G',
                 'H',
                 'I',
                 'J',
                 'K',
                 'L',
                 'M',
                 'N',
                 'O',
                 'P',
                 'Q',
                 'R',
                 'S',
                 'T',
                 'U',
                 'V',
                 'W',
                 'X',
                 'Y',
                 'Z'
            };
    }

    public List<Account> getAccountList() {
        if(searchFlag == false) {
            System.debug('****** IN IF KEY : ' + searchKey);

            // QUERY INDENTATION
            AccountList = [SELECT Id,
                                  Name,
                                  Email_Address__c,
                                  Phone,
                                  Website
                             FROM Account
                         ORDER BY Name
                            LIMIT 1000];

        } else {
            System.debug('****** IN ELSE KEY : ' + searchKey);

            // STRING NAMELIKE = like : '%' + searchKey.trim() + '%';
            // USE THIS IN QUERY
            // QUERY INDENTATION
            String searchKeyWithWildCardCharacters = '%' + searchKey.trim() + '%';
            AccountList = [SELECT Id,
                                  Name,
                                  Email_Address__c,
                                  Phone,
                                  Website
                             FROM Account
                            WHERE Name LIKE : searchKeyWithWildCardCharacters
                         ORDER BY Name
                            LIMIT 1000];
        }

        return AccountList;
    }

    /* CHANGE PARAMETER NAME
    @RemoteAction
    global static List<Account> searchAccountRemote(String sKey) {

        searchKey = sKey;
        System.debug('>>>>>>>>>>>>>> ' + searchKey);
        if(String.isEmpty(searchKey)) {
            // MESSAGED SHOULD COME FROM LABEL OR SHOULD BE DECLARED AS STATIC FINAL STRING
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,
                                                       'Please enter at least 3 characters to perform search'));
            searchFlag = false;
            return NULL;
        } else {
            searchFlag = true;
            return getListAccount();
        }
    }*/

    public void searchAccounts() {
        if(searchKey.length() < 3) {
            // MESSAGE SHOULD COME FROM LABEL OR SHOULD BE DECLARED AS STATIC FINAL STRING
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,
                                                       System.Label.Search_Key_Error_Message));
            searchFlag = false;
        } else {
            searchFlag = true;
            getAccountList();
        }
    }

    public Integer getcountOfRecords(List<Object> objList) {
        return objList.size();
    }

    public PageReference RedirectToContacts() {
        // NAME OF 'AID' AND 'AN'
        AccountId = ApexPages.currentPage().getParameters().get('aid');
        AccountName = ApexPages.currentPage().getParameters().get('an');
        PageReference pageRef = Page.RelatedContacts;
        pageRef.getParameters().put('aid', AccountId);
        pageRef.getParameters().put('an', AccountName);
        pageRef.setRedirect(true);
        return pageRef;
    }

    public List<Contact> getrelatedContactList() {
        AccountId = ApexPages.currentPage().getParameters().get('aid');
        AccountName = ApexPages.currentPage().getParameters().get('an');

        // EXPLICITLY CHECK FOR TRUE OR FALSE
        if(!alphaFlag) {

            // QUERY INDENTATION
            relatedContactList = [SELECT Id,
                                         Name,
                                         Phone,
                                         MobilePhone
                                    FROM Contact
                                   WHERE AccountId =: AccountId];
        } else {
            System.debug('*****************/*/*/*/*/*/*/*/*/ IN ELSE ' + selectedAlphabet);

            // QUERY INDENTATION
            String selectedAlphabetWithWildCardCharacter = selectedAlphabet + '%';
            relatedContactList = [SELECT Id,
                                         Name,
                                         Phone,
                                         MobilePhone
                                    FROM Contact
                                   WHERE AccountId = :AccountId
                                     AND Name LIKE :selectedAlphabetWithWildCardCharacter];
        }
        countOfRecords = getcountOfRecords(relatedContactList);
        if(!relatedContactList.isEmpty()) {
            return relatedContactList;
        }
        else {
            return NULL;
        }
    }

    public PageReference returnToAccount() {
        return Page.AccountList;
    }

    public void clearList() {
        searchKey = '';
        searchFlag = false;
    }

    // CHANGE NAME
    public void searchByAlphabet() {
        alphaFlag = true;
    }

    @RemoteAction
    global static void deleteRelatedContact(Id contactId) {
        Contact conInstance = new Contact(Id = contactId);

        // THIS SHOULD BE HANDLED DIFFERENTLY
        if([SELECT Id 
              FROM Contact 
             WHERE Id 
            NOT IN (SELECT ContactId
                      FROM Case
                     WHERE ContactId = :conInstance.Id)].size() == 0) {
            delete conInstance;
        }
    }
}