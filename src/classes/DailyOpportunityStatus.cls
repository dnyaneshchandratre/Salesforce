public with sharing class DailyOpportunityStatus implements Database.Batchable<sObject>, Database.Stateful, Schedulable {

    // WRAPPER CLASS SHOULD BE AT THE END OF CLASS
    // IT'S A CLASS, FOLLOW NAMING CONVENTION AND PROPER NAME (OpportunityDetails)
    public class oppDetails {
        List<Opportunity> oppList;
        Decimal totalOppAmount;

        public oppDetails() {
            oppList = new List<Opportunity>();
            totalOppAmount = 0;
        }
    }

    // string -> String
    public final static string query = 'SELECT Name, Amount, AccountId, Account.Primary_Contact__c FROM Opportunity WHERE Account.Primary_Contact__c <> NULL AND StageName = \'Closed Won\'';

    // SHOULD BE INDENTED LIKE
    // public final static string query = ' SELECT Name, '
    //                                  + '        Amount,'
    //                                  + '        AccountId,'
    //                                  + '        Account.Primary_Contact__c'
    //                                  + '   FROM Opportunity'
    //                                  + '  WHERE Account.Primary_Contact__c <> NULL'
    //                                  + '    AND StageName = \'Closed Won\'';

    // ADD COLLECTION TYPE WITH NAME
    Map<String, oppDetails> emailToOpportunity = new Map<String, oppDetails>();
    // CHANGE NAME
    oppDetails detail = new oppDetails();

    // PARAMETER NAME
    public Iterable<sObject> start(Database.BatchableContext bc) {
        System.debug(query);
        return Database.getQueryLocator(query);
    }

    // PARAMETER NAMES
    public void execute(Database.BatchableContext bc, List<Opportunity> oppList) {
        System.debug('******* IN EXECUTE ***********');
        System.debug(oppList);

        // ITERATOR NAME
        // { IN SAME LINE
        for(Opportunity oppIterator : oppList)
        {
            // WHY IS IT SINGLE LINED IF WITHOUT BODY ??
            if(oppIterator.Account.Primary_Contact__c <> Null)
            if(emailToOpportunity.containsKey(oppIterator.Account.Primary_Contact__c))
            {
                emailToOpportunity.get(oppIterator.Account.Primary_Contact__c).oppList.add(oppIterator);
                detail = emailToOpportunity.get(oppIterator.Account.Primary_Contact__c);
                detail.totalOppAmount += oppIterator.Amount;
            }
            else
            {
                detail = new oppDetails();
                detail.oppList.add(oppIterator);
                detail.totalOppAmount = oppIterator.Amount;
                emailToOpportunity.put(oppIterator.Account.Primary_Contact__c,detail);
            }
        }

        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

        List<String> sendTo = new List<String>();
        sendTo.addAll(emailToOpportunity.keySet());
        system.debug('******************************SEND TO'+emailToOpportunity.keySet());
        mail.setToAddresses(sendTo);

        for(String email : emailToOpportunity.keySet()) {

            mail.setReplyTo('dnyanesh.chandratre@eternussolutions.com');
            mail.setSenderDisplayName('Eternus Solutions Org.');

            mail.setSubject('Daily Opportunity Status');
            String body = 'Hello,';
            body += 'Following is the list of opportunities that were closed won today:';

            body += 'Opportunities : ' + emailToOpportunity.get(email).oppList;
            body += '<br />Total Amount for all opportunities : ' + emailToOpportunity.get(email).totalOppAmount;

            mail.setHtmlBody(body);
            System.debug('******* MAIL CONTENT **********' + mail);
            mails.add(mail);
        }
        Messaging.sendEmail(mails);
    }

    public void execute(SchedulableContext sc) {}
    public void finish(Database.BatchableContext bc) {}
}