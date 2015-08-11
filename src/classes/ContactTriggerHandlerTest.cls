/**
 *  Title       : Test class for handler class of ContactTrigger
 *  Class       : ContactTriggerHandlerTest
 *  Author      : Dnyanesh Chandratre
 *  Created On  : 7/29/2015
 */


@isTest
private class ContactTriggerHandlerTest {

    static testMethod void testValid() {
        Contact conInstance = new Contact();
        Account accInstance = new Account();
        conInstance.LastName ='foo';
        conInstance.email = 'foo@abc.com';

        accInstance.Name = 'ABC Containers';
        accInstance.website = 'www.abc.com';

        insert accInstance;
        test.startTest();
        insert conInstance;
        test.stopTest();

        conInstance = [SELECT AccountId FROM Contact];
        System.assertEquals(accInstance.Id,conInstance.AccountId);
    }

    static testMethod void testDifferentDomain() {
        Contact conInstance = new Contact();
        Account accInstance = new Account();
        conInstance.LastName ='foo';
        conInstance.email = 'foo@xyz.com';

        accInstance.Name = 'ABC Containers';
        accInstance.website = 'www.abc.com';

        insert accInstance;
        test.startTest();
        insert conInstance;
        test.stopTest();

        conInstance = [SELECT AccountId FROM Contact];
        System.assertEquals(NULL,conInstance.AccountId);
    }

    static testMethod void testBlankEmail() {
        Contact conInstance = new Contact();
        Account accInstance = new Account();
        conInstance.LastName ='foo';
        conInstance.email = '';

        accInstance.Name = 'ABC Containers';
        accInstance.website = 'www.abc.com';

        insert accInstance;
        test.startTest();
        insert conInstance;
        test.stopTest();

        conInstance = [SELECT AccountId FROM Contact];
        System.assertEquals(NULL,conInstance.AccountId);
    }

    static testMethod void testBlankWebsite() {
        Contact conInstance = new Contact();
        Account accInstance = new Account();
        conInstance.LastName ='foo';
        conInstance.email = 'foo@xyz.com';

        accInstance.Name = 'ABC Containers';
        accInstance.website = '';

        insert accInstance;
        test.startTest();
        insert conInstance;
        test.stopTest();

        conInstance = [SELECT AccountId FROM Contact];
        System.assertEquals(NULL,conInstance.AccountId);
    }

}