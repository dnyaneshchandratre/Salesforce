/**
 *  Title       : Class to perform SOQL Tasks [Assignment 10]
 *  Class       : SoqlTasks
 *  Author      : Dnyanesh Chandratre
 *  Created On  : 7/14/2015
 */

 // QUERY INDENT AND FORMATING
 // NO HARD CODING FOR ALL OCCURANCES

public with sharing class SoqlTasks {

    /* Set 1 */
    public void fetchContacts() {
        // FOLLOW THIS QUERY PATTERN
        List<Contact> contactList = [
            SELECT c.Phone,
                   c.Name,
                   c.MobilePhone,
                   c.Id,
                   c.FirstName
              FROM Contact c
        ];
        System.debug('-- contactList : ' + contactList);
    }

    public void fetchUsers() {
        // QUERY INDENT
        List<User> userList= [SELECT u.Id,
                                     u.IsActive,
                                     u.Email,
                                     u.Alias
                                FROM User u
                               WHERE u.IsActive = TRUE];

        Map<ID,User> userMap = new Map<ID,User>();
        for(User user : userList) {
            userMap.put(user.ID, user);
        }
        System.debug(userMap);
    }

    public void fetchAccounts() {
        // QUERY INDENT
        List<Account> accountList=[SELECT a.Name,
                                          a.Id,
                                          a.BillingState,
                                          a.BillingCountry,
                                          a.AccountNumber
                                     FROM Account a];

        Map<String, ID> nameMap = new Map<String,ID>();
        Map<ID, Account> idMap = new Map<ID,Account>();
        for(Account a: accountList) {
            nameMap.put(a.Name, a.ID);
            idMap.put(a.ID, a);
        }
        System.debug(nameMap);
        System.debug(idMap);
    }

    public void fetchAccountsByEnrollment() {
        // CHANGE NAME
        // QUERY INDENT
        // NO HARD CODING OF 2010
        List<Account> fetch2010  = [SELECT a.Name,
                                           a.Id,
                                           a.BillingCity,
                                           a.AccountNumber
                                      FROM Account a
                                     WHERE Enrollment_year__c INCLUDES ('2010')];

        // CHANGE NAME
        // QUERY INDENT
        // NO HARD CODING
        List<Account> fetch1314 = [SELECT a.Name,
                                          a.Id,
                                          a.BillingCity,
                                          a.AccountNumber
                                     FROM Account a
                                    WHERE Enrollment_year__c INCLUDES ('2013','2014')];
        System.debug(fetch2010);
        System.debug(fetch1314);
    }

    public void fetchAccountsByBillingState() {
        // CHANGE NAME
        // QUERY INDENT
        // NO HARD CODING
        List<Account> fetchRecords = [SELECT a.Rating,
                                             a.Name,
                                             a.Id,
                                             a.BillingState,
                                             a.AccountNumber
                                        FROM Account a
                                       WHERE a.BillingState NOT IN ('Maharashtra','Kerala')
                                    ORDER BY a.BillingState DESC
                                  NULLS LAST
                                       LIMIT 10000];
        for(Account a: fetchRecords) {
            System.debug(a);
        }
    }

    public void fetchOpportunity() {
        // CHANGE NAME
        // QUERY INDENT
        List<Opportunity> oppList= [SELECT o.Id,
                                           o.CreatedDate,
                                           o.Amount
                                      FROM Opportunity o
                                     WHERE o.Amount >10000
                                  ORDER BY o.CreatedDate
                                     LIMIT 100
                                    OFFSET 50
                                  ALL ROWS];
        for(Opportunity a: oppList) {
            System.debug(a);
        }
    }

    /*Set 2*/
    public void amountStats() {
        // CHANGE NAME
        // QUERY INDENT
        List<AggregateResult> ar = [SELECT SUM(o.Amount) s,
                                           CloseDate
                                      FROM Opportunity o
                                     WHERE IsClosed=FALSE AND
                                           CloseDate = THIS_FISCAL_YEAR
                                  GROUP BY CloseDate];
        Map<Integer,Double> mapYear = new Map<Integer,Double>();
        for(AggregateResult a : ar) {
            mapYear.put(
                Date.valueOf(a.get('CloseDate')).year(),
                Double.valueOf(a.get('s'))
            );
        }
        System.debug(mapYear);
    }

    public void leadSources() {
        // CHANGE NAME
        List<AggregateResult> ar = [SELECT count_distinct(Name) cd,
                                           LeadSource
                                      FROM lead
                                  GROUP BY LeadSource
                                    HAVING count_distinct(ID) > 10];
        for(AggregateResult a : ar) {
            System.debug('The count of distinct leads for ' + a.get('LeadSource') + ' is ' + a.get('cd'));
        }
    }

    public void leadStatus_Abbas() {
        Map<String, Map<String, Integer>> leadStatusMap = new Map<String, Map<String, Integer>>();
        for(AggregateResult result : [
            SELECT COUNT(Name) leadCount
                 , Status
                 , LeadSource
              FROM Lead
          GROUP BY LeadSource
                 , Status
        ]) {

            // Create new
            if(!leadStatusMap.containsKey(String.valueOf(result.get('status')))) {
                leadStatusMap.put(
                    String.valueOf(result.get('Status')),
                    new Map<String, Integer> {
                        String.valueOf(result.get('LeadSource')) => Integer.valueOf(result.get('leadCount'))
                    }
                );

            // Add existing
            } else {
                leadStatusMap.get(String.valueOf(result.get('Status'))).put(
                    String.valueOf(result.get('LeadSource')), Integer.valueOf(result.get('leadCount'))
                );
            }
        }
        system.debug('--- leadStatusMap : ' + leadStatusMap);
    }

    /*Set 3*/
    /*Set 3: Child to Parent*/
    public void fetchMedia() {
        List<Contact> conList=[SELECT c.Name,
                                      c.Account.Industry,
                                      c.Account.Name,
                                      c.Active__c,
                                      c.Account.Id,
                                      c.AccountId
                                 FROM Contact c
                                WHERE c.Account.Industry = 'media'
                                  AND c.Active__c = 'Yes'];
        for(Contact c : conList) {
            System.debug('Contact : ' + c.Name);
            System.debug('Account : ' + c.Account.Name);
        }
    }
    public void fetchJohnFromC() {
        List<C__c> cList=[SELECT c.Name__c,
                                 c.B__r.Name,
                                 c.A__r.Name
                          FROM C__c c
                          WHERE c.Name__c Like 'john%'];
        for(C__c c : cList) {
            System.debug('Child : ' + c.Name__c);
            System.debug('Parents : ' + c.A__r.Name + ',' + c.B__r.Name);
        }
    }
    /*Set 3: Parent to Child*/
    public void fetchJohn() {
        List<Account> accList=[SELECT Name,
                                      Id,
                                      Active__c,
                                      AccountNumber,
                                      (SELECT Id,
                                              Name,
                                              AccountId
                                         FROM Contacts
                                        WHERE Name LIKE 'John%')
                                 FROM Account
                                WHERE Id IN (SELECT AccountId
                                               FROM Contact
                                              WHERE Name LIKE 'John%')];
        Map<Account, List<Contact>> mapContacts = new Map<Account, List<Contact>>();

        for(Account accIterator : accList) {
            mapContacts.put(accIterator,accIterator.Contacts);
        }
        for(Account accIterator : mapContacts.keySet()) {
            System.debug('\nAccount record: \n' + accIterator + '\nRelaterd Contacts : \n' + mapContacts.get(accIterator));
        }
    }
    public void wonOpportunities() {
        List<Account> accList= [SELECT a.Name,
                                       a.Id,
                                       a.AccountNumber
                                   FROM Account a
                                  WHERE Id IN (SELECT AccountID
                                                 FROM Opportunity
                                                WHERE StageName='Closed Won')];

        for(Account accIterator : accList) {
            System.debug(accIterator);
        }
    }

    public void fetchJohnFromA() {
        List<A__c> aList= [SELECT a.Id,
                                  (SELECT A__c,
                                          Name__c
                                     FROM Cs__r
                                    WHERE Name__c Like 'john%')
                             FROM A__c a
                            WHERE a.Id IN (SELECT A__c
                                             FROM C__c c
                                            WHERE c.Name__c Like 'john%')];
        system.debug(alist.size());
        Map<A__c, List<C__c>> aToCMap = new Map<A__c, List<C__c>>();
        for(A__c aIterator : aList) {
            aToCMap.put(aIterator,aIterator.Cs__r);
        }
        for(A__c aIterator : aToCMap.keySet()) {
            System.debug('\nA record: \n' + aIterator + '\nRelaterd Cs : \n' + aToCMap.get(aIterator));
        }
    }
    // FIND ('*edge*') IN Website FIELD RETURNING Account
    /*Set 4*/
    public void testSearch() {
        List<List<SObject>> searchTest = [FIND 'Test*'
                                          IN NAME FIELDS
                                          RETURNING Contact,
                                                    Account,
                                                    Lead,
                                                    User];
        List<Contact> conList = ((List<Contact>)searchTest[0]);
        List<Account> accList = ((List<Account>)searchTest[1]);
        List<Lead> leadList = ((List<Lead>)searchTest[2]);
        List<User> userList = ((List<User>)searchTest[3]);
        System.debug(conList+'\n'+accList+'\n'+leadList+'\n'+userList);
    }
    /*Set 5*/
    public void logErrors() {
        List<Lead> leadList = new List<Lead>();
        List<Database.SaveResult> results = new List<Database.SaveResult>();
        for(Integer i=0;i<100;i++)
        {
            Lead temp = new Lead();
            if(math.mod(i,2)==0)
                temp = new Lead(
                    LastName='Test' + i,
                    Company='ABCD Pvt. Ltd.',
                    Status='Working - Contacted',
                    Role__c= 'Role' + i
                );
            else
                temp = new Lead(LastName='Test'+i, Company='ABCD Pvt. Ltd.', Status='Working - Contacted', Role__c= 'Role');
            leadList.add(temp);
        }
        results = Database.insert(leadList,false);
        List<Log__c> errorLog = new List<Log__c>();
        for(Database.SaveResult resIterator : results) {
            if(!resIterator.isSuccess()) {
                errorLog.add(new Log__c( Error_Description__c = String.valueOf(resIterator.getErrors())));
            }
        }
        insert errorLog;
    }

    public void deleteInactive() {
        Date referenceDate = Date.today().addDays(-90);
        list<Account> accList=[SELECT Id,
                                      CreatedDate
                                 FROM Account
                                WHERE Active__c = 'No'
                                  AND createdDate > :referenceDate
                             ORDER BY createdDate DESC];
        for(Account a : accList) {
            System.debug(a.createdDate);
        }
        delete accList;
    }
    public void upsertAsset() {
        Asset assetInstance = new Asset(
            Name = 'Test Asset',
            Line_Item_ID__c = 'LI001'
        );

        List<Asset> assets = new List<Asset> {
            assetInstance, new Asset(
                Name = 'Test Asset',
                Line_Item_ID__c = 'LI002'
            )
        };

        assetInstance.Name = 'Updated Test Asset';
        assets.add(assetInstance);
        upsert assets Line_Item_ID__c;
    }
}