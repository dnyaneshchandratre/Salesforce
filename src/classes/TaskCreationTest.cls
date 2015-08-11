/**
 *  Title       : Test class for createTaskHandler
 *  Class       : TaskCreationTest
 *  Author      : Dnyanesh Chandratre
 *  Created On  : 7/20/2015
 */

@isTest

public class TaskCreationTest {
    static testMethod void testCreateTask() {
        Account objAccount = new Account();
        objAccount.Name = 'Foo';

        test.startTest();
        insert objAccount;
        test.stopTest();

        List<Task> taskList= [SELECT Subject FROM Task WHERE Subject = 'Meeting with Foo'];
        System.assertEquals(1,taskList.size());
    }
}