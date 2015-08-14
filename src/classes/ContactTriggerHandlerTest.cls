/**
 *  Title       : Test class for handler class of ContactTrigger
 *  Class       : ContactTriggerHandlerTest
 *  Author      : Dnyanesh Chandratre
 *  Created On  : 7/29/2015
 */


@isTest
private class ContactTriggerHandlerTest {

    static testMethod void testValid() {

        Contact contactInstance = new Contact();
        Account accountInstance = new Account();

        contactInstance.LastName ='foo';
        contactInstance.email = 'foo@abc.com';

        accountInstance.Name = 'ABC Containers';
        accountInstance.website = 'www.abc.com';

        insert accountInstance;

        test.startTest();
            insert contactInstance;
        test.stopTest();

        contactInstance = [SELECT AccountId 
                             FROM Contact];
        System.assertEquals(accountInstance.Id,contactInstance.AccountId);
    }

    static testMethod void testDifferentDomain() {
        Contact contactInstance = new Contact();
        Account AccountInstance = new Account();

        contactInstance.LastName ='foo';
        contactInstance.email = 'foo@xyz.com';

        AccountInstance.Name = 'ABC Containers';
        AccountInstance.website = 'www.abc.com';

        insert AccountInstance;

        test.startTest();
            insert contactInstance;
        test.stopTest();

        contactInstance = [SELECT AccountId FROM Contact];
        System.assertEquals(NULL,contactInstance.AccountId);
    }

    static testMethod void testBlankEmail() {
        Contact contactInstance = new Contact();
        Account AccountInstance = new Account();
        contactInstance.LastName ='foo';
        contactInstance.email = '';

        AccountInstance.Name = 'ABC Containers';
        AccountInstance.website = 'www.abc.com';

        insert AccountInstance;

        test.startTest();
            insert contactInstance;
        test.stopTest();

        contactInstance = [SELECT AccountId FROM Contact];
        System.assertEquals(NULL,contactInstance.AccountId);
    }

    static testMethod void testBlankWebsite() {
        Contact contactInstance = new Contact();
        Account AccountInstance = new Account();
        contactInstance.LastName ='foo';
        contactInstance.email = 'foo@xyz.com';

        AccountInstance.Name = 'ABC Containers';
        AccountInstance.website = '';

        insert AccountInstance;

        test.startTest();
            insert contactInstance;
        test.stopTest();

        contactInstance = [SELECT AccountId FROM Contact];
        System.assertEquals(NULL,contactInstance.AccountId);
    }

}