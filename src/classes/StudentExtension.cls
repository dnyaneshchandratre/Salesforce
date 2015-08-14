public with sharing class StudentExtension {

    public String selectedLang {get;set;}
    public List<selectOption> langList = new List<selectOption>();
    ApexPages.StandardController sc = new ApexPages.StandardController(new Student__c()); 
    Student__c studentInstance;

    public StudentExtension(ApexPages.StandardController sc) {
        studentInstance = (Student__c)sc.getRecord();
    }

    public List<selectOption> getLangList() {
        langList.add(new selectOption('en_US', 'English'));
        langList.add(new selectOption('fr', 'French'));
        langList.add(new selectOption('es', 'Spanish'));
        return langList;
    }

    public void save() {
        ApexPages.addMessage(
            new apexPages.Message(
                ApexPages.Severity.INFO,
                System.Label.Success_Message
            )
        );
        insert studentInstance;
        studentInstance.Name = '';
        studentInstance.Roll_Number__c = NULL;
        studentInstance.Gender__c = '';
        studentInstance.SSC__c = NULL;
        studentInstance.HSC__c = NULL;
        studentInstance.Course_Applied_For__c = '';
        studentInstance.City__c = '';
        studentInstance.State__c = '';
        studentInstance.Country__c = '';
    }
}