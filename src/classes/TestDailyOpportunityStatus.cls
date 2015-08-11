@isTest
private class TestDailyOpportunityStatus {

    static testMethod void testOpportunityMail() {

        List<Account> accList = new List<Account>();
        List<Opportunity> oppList = new List<Opportunity>();
        for(Integer i=0;i<5;i++ ) {
            accList.add(
                new Account(
                    Primary_Contact__c = 'dnyanesh'+i+'@eternussolutions.com',
                    Name = 'dnyaneshchandratre'+i,
                    Email_Address__c='dnyanesh'+i+'chandratre@eternussolutions.com'
                )
            );
        }

        insert accList;
        for(Integer i=0;i<5;i++ ) {  
            oppList.add(
                new Opportunity(
                    Amount = 12 * i,
                    StageName  = 'Closed Won',
                    Name = 'Closed Opportunity '+i ,
                    CloseDate = (Date)Date.today(),
                    AccountId = accList[i].Id
                )
            ); 
        }
        oppList.add(
            new Opportunity(
                Amount = 12,
                StageName  = 'Closed Won',
                Name = 'TestOpportunity' ,
                CloseDate = (Date)Date.today() ,
                AccountId = accList[0].Id
            )
        );
        
        insert oppList; 
        Test.startTest();
        DailyOpportunityStatus dos = new DailyOpportunityStatus();
        Database.executeBatch(dos);
        Test.stopTest();
        system.assertequals(5,Limits.getEmailInvocations());
    }
}