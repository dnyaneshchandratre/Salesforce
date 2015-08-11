/**
 *  Title       : Class to perform SOQL Operations [Assignment 9]
 *  Class       : SoqlOperations
 *  Author      : Dnyanesh Chandratre
 *  Created On  : 7/12/2015
 */

public class SoqlOperations {

    // METHOD NAME
    public void operateAccount() {

        // QUERY INDENT AND FORMAT
        // CHANGE NAME
        List<Account> accList= [select ID from Account where Type__c='Person'];

        // CHNAE "i"
        // NO SINGLE LINER FOR
        for(INteger i=0;i<accList.size();i++)
            System.debug(accList[i]);
        System.debug('*********************************');
        for(Account accInstance : accList)
            System.debug(accInstance);
    }

    // METHOD NAME
    public void operateOpportunity() {
        // CHANGE NAME AND QUERY INDENT
        List<Opportunity> oppList= [SELECT Id,
                                           AccountID
                                    FROM Opportunity
                                    WHERE
                                    AccountID!=NULL AND
                                    StageName LIKE 'Closed%'];
        List<ID> IdList= new List<ID>();
        Set<ID> IdSet= new Set<ID>();

        // CHANGE NAME
        Map<ID,ID> oppMap= new Map<ID,ID>();

        // { ON SAME LINE
        // CHANGE i
        for(Integer i=0;i<oppList.size();i++)
        {
            IdList.add(oppList[i].ID);
            IdSet.add(oppList[i].AccountID);
            oppMap.put(oppList[i].ID,oppList[i].AccountID);
        }
        System.debug(IdList+'\n'+IdSet+'\n'+oppMap);
    }

    public void updateAccount() {

        // CHANGE NAME
        // QUEYR INDENT
        List<Account> accUpdateName = [SELECT Name
                                       FROM Account
                                       WHERE Name LIKE 'A%'];
        System.debug(accUpdateName.size());

        // CHANGE a
        // SPACE BEFORE AND AFTER :
        for(Account a: accUpdateName)
        {
            // MAKE A STATIC FINAL STRING
            a.Name='Updated via update DML operation';
        }
        update accUpdateName;
    }

    public void sortCampaign() {

        // CHANGE NAME
        // QUERY INDENT
        List<Campaign> camList=[SELECT ID,
                                       name,
                                       BudgetedCost
                                FROM Campaign
                                LIMIT 10];

        // CHANGE NAME
        List<Campaign> camAscList=camList;
        List<Campaign> camDescList=camList;
        Campaign temp;
        /***Ascending order by Budgeted Cost***/

        // HAVE YOU TRIED COMPARABLE INTERFACE ?
        for(Integer i=0;i<camAscList.size();i++)
            for(Integer j=i+1;j<camAscList.size();j++)
                if(camAscList[i].BudgetedCost > camAscList[j].BudgetedCost)
                {
                    temp=camAscList[i];
                    camAscList[i]=camAscList[j];
                    camAscList[j]=temp;
                }
        System.debug(camAscList);
        /***Descending order by Budgeted Cost***/
        for(Integer i=0;i<camDescList.size();i++)
            for(Integer j=i+1;j<camDescList.size();j++)
                if(camDescList[i].BudgetedCost < camDescList[j].BudgetedCost)
                {
                    temp=camDescList[i];
                    camDescList[i]=camDescList[j];
                    camDescList[j]=temp;
                }
        System.debug(camDescList);
    }

    // fetchModifiedContacts -> NAME
    public void modifiedContacts() {

        // QUERY INDENT
        List<Contact> conList=[SELECT ID,
                                      name
                               FROM Contact
                               WHERE LastModifiedDate =: System.Date.Today()];
        System.debug('\n\R'+conList);
    }

    // CHNAGE NAME
    public void mapAccToOpp() {

        // CHANGE NAME
        // QUERY INDENT
        List<Account> accList = [SELECT a.Name,
                                        a.Id,
                                        (SELECT Id,
                                                Name
                                         FROM Opportunities)
                                  FROM Account a];
        // CHANGE NAME
        Map<Id, List<Opportunity>> mapAcc= new Map<Id, List<Opportunity>>();
        for(Account accInstance : accList) {
            mapAcc.put(accInstance.Id, accInstance.Opportunities);
        }
        // CHANGE i
        for(ID i : mapAcc.keySet()) {
            System.debug(mapAcc.get(i));
        }
    }
}