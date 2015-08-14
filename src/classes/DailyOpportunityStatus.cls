public with sharing class DailyOpportunityStatus implements Database.Batchable<sObject>, Database.Stateful, Schedulable {

    // WRAPPER CLASS SHOULD BE AT THE END OF CLASS [Done]
    // IT'S A CLASS, FOLLOW NAMING CONVENTION AND PROPER NAME (OpportunityDetails) [Done]

    // string -> String [Done]
    public final static String query = 'SELECT Name,'
                                     + '       Amount,' 
                                     + '       AccountId,' 
                                     + '       Account.Primary_Contact__c'
                                     + '  FROM Opportunity'
                                     + ' WHERE Account.Primary_Contact__c <> NULL' 
                                     + '   AND StageName = \'Closed Won\''
                                     + ' LIMIT 10';

    // SHOULD BE INDENTED LIKE [Done]
    // public final static string query = ' SELECT Name, '
    //                                  + '        Amount,'
    //                                  + '        AccountId,'
    //                                  + '        Account.Primary_Contact__c'
    //                                  + '   FROM Opportunity'
    //                                  + '  WHERE Account.Primary_Contact__c <> NULL'
    //                                  + '    AND StageName = \'Closed Won\'';

    // ADD COLLECTION TYPE WITH NAME [Done]
    Map<String, opportunityDetails> emailToOpportunityMap = new Map<String, opportunityDetails>();
    // CHANGE NAME
    opportunityDetails opportunityDetailInstance = new opportunityDetails();

    // PARAMETER NAME [Done]
    public Database.QueryLocator start(Database.BatchableContext batchableContextInstance) {
        System.debug(query);
        return Database.getQueryLocator(query);
    }

    // PARAMETER NAMES [Done]
    public void execute(Database.BatchableContext batchableContextInstance, List<Opportunity> opportunityList) {
        System.debug('******* IN EXECUTE ***********');
        System.debug(opportunityList);

        // ITERATOR NAME  [Done]
        // { IN SAME LINE [Done]
        for(Opportunity opportunityIterator : opportunityList) {
            // WHY IS IT SINGLE LINED IF WITHOUT BODY ??
            if(String.isNotBlank(opportunityIterator.Account.Primary_Contact__c)) {
                if(emailToOpportunityMap.containsKey(opportunityIterator.Account.Primary_Contact__c))
                {
                    emailToOpportunityMap.get(
                        opportunityIterator.Account.Primary_Contact__c).oppList.add(opportunityIterator);
                    opportunityDetailInstance = emailToOpportunityMap.get(
                        opportunityIterator.Account.Primary_Contact__c);
                    opportunityDetailInstance.totalOppAmount += opportunityIterator.Amount;
                }

                else {
                    opportunityDetailInstance = new opportunityDetails();
                    opportunityDetailInstance.oppList.add(opportunityIterator);
                    opportunityDetailInstance.totalOppAmount = opportunityIterator.Amount;
                    emailToOpportunityMap.put(opportunityIterator.Account.Primary_Contact__c,opportunityDetailInstance);
                }
            }
        }

    }

    public void execute(SchedulableContext sc) {}
    public void finish(Database.BatchableContext bc) {
        List<Messaging.SingleEmailMessage> mailsList = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

        List<String> sendToList = new List<String>();
        sendToList.addAll(emailToOpportunityMap.keySet());
        system.debug('******************************SEND TO  :\n'+emailToOpportunityMap.keySet());
        mail.setToAddresses(sendToList);

        for(String email : emailToOpportunityMap.keySet()) {

            mail.setReplyTo('dnyanesh.chandratre@eternussolutions.com');
            mail.setSenderDisplayName('Eternus Solutions Org.');

            mail.setSubject('Daily Opportunity Status');
            String body = 'Hello,';
            body += 'Following is the list of opportunities that were closed won today:';

            body += 'Opportunities : ' + emailToOpportunityMap.get(email).oppList;
            body += '<br />Total Amount for all opportunities : <br />' + emailToOpportunityMap.get(email).totalOppAmount;

            mail.setHtmlBody(body);
            System.debug('******* MAIL CONTENT **********' + mail);
            mailsList.add(mail);
        }

        Messaging.sendEmail(mailsList);
    }

    public class opportunityDetails {
        List<Opportunity> oppList;
        Decimal totalOppAmount;

        public opportunityDetails() {
            oppList = new List<Opportunity>();
            totalOppAmount = 0;
        }
    }

}