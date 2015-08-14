public with sharing class MapAccountsContactsOpportunities {
    /*public void getMap() {
        Map<Account, Map<Contact, List<Opportunity>>> aSmallMap = 
            new Map<Account, Map<Contact, List<Opportunity>>>();
        List<Account> accList = [SELECT Name,
                                        (SELECT Name,
                                                StageName,
                                                Amount
                                           FROM Opportunities),
                                        (SELECT Name
                                           FROM Contacts
                                          LIMIT 1)
                                   FROM Account];

        for(Account accIterator : accList) {
            if(!aSmallMap.containsKey(accIterator.Name)) {
                aSmallMap.put(
                    accIterator.Name,
                    new Map<String, List<Opportunity>>
                    {
                        accIterator.Contacts => accIterator.Opportunities
                    }
                );
            } else {
                aSmallMap.get(accIterator).put(
                    accIterator.Contacts.Name,
                    accIterator.Opportunities
                );
            }
        }
        for(String key : aSmallMap.keySet()) {
            System.debug('********* MAP IS : ' + Key + '\n' + aSmallMapt.get(key));
        }
    }*/
}