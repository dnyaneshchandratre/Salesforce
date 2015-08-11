@isTest
private class AccountListControllerTest {
    static testMethod List<Account> createAccountRecords(){
        List<Account> accList = new List<Account>();  
        Account accObj1 = new Account(Name='tudip');
        Account accObj2 = new Account(Name='pascal');
        accList.add(accObj1);
        accList.add(accObj2);
        return accList;
    }

    /*static testMethod List<Contact> createContactRecords() { 
        List<Contact> conList = new List<Contact>();  
        Contact conObj1 = new Contact(LastName='tudipcon');
        Contact conObj2 = new Contact(LastName='pascalcon');
        conList.add(conObj1);
        conList.add(conObj2);
        return conList;
    }*/

    static testMethod void displayingAccounts() {
        List<Account> accList = AccountListControllerTest.createAccountRecords();
        insert accList;

        Contact contactObject1 = new Contact(LastName='Contact1',
                                             AccountId=accList[0].Id);
        insert contactObject1;

        Contact contactObject2 = new Contact(LastName='Contact2', 
                                             AccountId=accList[1].Id);
        insert contactObject2;

        Case testCase = new Case(Status='Working',Origin ='Phone',ContactId = contactObject2.id);
        insert testCase;

        pagereference pageAcc = page.AccountList;
        test.setCurrentPage(pageAcc);

        AccountListController controllerInstance = new AccountListController();
        List<Account> pageAccList = new List<Account>(); 
        pageAccList=AccountListController.getListAccount();
        system.assertequals(2,pageAccList.size());
  
        AccountListController.searchKey ='pas';
        AccountListController.searchAccounts();
        system.assert(AccountListController.searchFlag == true);
   
        List<Account> getterAccList = new List<Account>();
        getterAccList = AccountListController.getListAccount();
        system.assertequals(1,getterAccList.size());

        AccountListController.searchKey = 'tu';
        AccountListController.searchFlag= false;
        AccountListController.searchAccounts();
        system.assert(AccountListController.searchFlag == False);     
        pageAcc.getParameters().put('aid',accList[0].id);
        pageAcc.getParameters().put('an',accList[0].Name);
        PageReference testRedirect = controllerInstance.RedirectToContacts();
     
        test.setCurrentPage(testRedirect);
     
        system.assertEquals(
            '/apex/relatedcontacts?aid='+accList[0].id+'&an='+accList[0].Name,
            testRedirect.getUrl()
        );
     
     
     
        List<Contact> conList = new List<Contact>(); 
        conList=controllerInstance.getRelatedContacts();
        //system.assertEquals(1,controllerInstance.countOfRecords);
        system.assertequals(1,conList.size());
  
  
        AccountListController.deleteRelatedContact(contactObject1.id);
        system.assertEquals(1,[SELECT id FROM Contact WHERE LastName Like 'Contact1'].size());  
     
        system.assert(ApexPages.currentPage().getParameters().get('aid') == accList[0].id); 
        AccountListController.deleteRelatedContact(contactobject2.id); 
        system.assertEquals(0,[SELECT id FROM Contact WHERE LastName LIKE 'Contact2'].Size());

        controllerInstance.alphaSearch();
        system.assertEquals(true,controllerInstance.alphaFlag);
        pageReference returnToAccount = controllerInstance.returnToAccount();
        system.assertEquals(returnToAccount.getUrl(), controllerInstance.returnToAccount().getUrl());
    }
}