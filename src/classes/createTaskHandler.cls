/**
 *  Title       : Handler class of createTaskTrigger
 *  Class       : createTaskHandler
 *  Author      : Dnyanesh Chandratre
 *  Created On  : 7/16/2015
 */

public with sharing class createTaskHandler {

    // CHANGE NAME OF PARAMETER
    public static void createTask(list<Account> accList) {
        list<Task> taskList= new list<Task>();

        // CHANGE NAME OF ITERATOR
        for(Account a: accList) {
            taskList.add(new Task(Subject='Meeting with ' + a.Name));
        }
        System.debug('Contents of taskList : ' + taskList);
        insert taskList;
    }
}