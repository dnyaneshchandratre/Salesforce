/**
 *
 */

// VERY GOOD.. !! :)

@isTest
public class DataFactoryCase {

    public static List<Case> createCases(Integer countOfRecords, Boolean isInsert) {
        List<Case> caseList = new List<Case>();
        for(Integer i = 0; i < countOfRecords; i++) {
            caseList.add(
                new Case(
                    Status = 'New',
                    Origin = 'Phone'
                )
            );
        }

        if(isInsert == true) {
            insert caseList;
        }
        return caseList;

    }
}