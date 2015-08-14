/**
 *  Title       : Handler class of createTaskTrigger
 *  Class       : createTaskHandler
 *  Author      : Dnyanesh Chandratre
 *  Created On  : 7/16/2015
 */

public with sharing class createTaskHandler {

    // CHANGE NAME OF PARAMETER [Done]
    public static void createTask(list<Account> accountList) {
        list<Task> taskList= new list<Task>();

        // CHANGE NAME OF ITERATOR [Done]
        for(Account accountIterator : accountList) {
            taskList.add(new Task(Subject='Meeting with ' + accountIterator.Name));
        }

        System.debug('Contents of taskList : ' + taskList);
        insert taskList;
    }
}