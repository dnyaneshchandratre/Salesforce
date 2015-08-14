public with sharing class InvoiceListController {

    public list<Line_Item__c> listOfLineItems;
    public Id idOfInvoice {get;set;}
    public Boolean clickFlag = false;

    public list<Line_Item__c> getlistOfLineItems() {
        if(clickFlag) {
            return [SELECT Merchandise_Name__r.Name,
                           Merchandise_Name__c,
                           Invoice_Statement__r.Email_Address__c,
                           Invoice_Statement__r.Phone__c,
                           Invoice_Statement__r.State__c,
                           Invoice_Statement__r.Zip__c,
                           Invoice_Statement__r.City__c,
                           Invoice_Statement__r.Street_Address__c,
                           Invoice_Statement__r.Company_Name__c,
                           Invoice_Statement__r.Description__c,
                           Invoice_Statement__r.Name__c,
                           Invoice_Statement__r.CreatedDate,
                           Invoice_Statement__r.Name,
                           Invoice_Statement__c
                      FROM Line_Item__c 
                     WHERE Invoice_Statement__c =: idOfInvoice];
        } else {
            return [SELECT Invoice_Statement__r.Zip__c,
                           Invoice_Statement__r.City__c,
                           Invoice_Statement__r.Name__c,
                           Invoice_Statement__r.Name,
                           Invoice_Statement__c
                      FROM Line_Item__c l];
        }
    }

    public pageReference generate() {
        idOfInvoice = ApexPages.currentPage().getParameters().get('id');
        PageReference pageRef = Page.GeneratedInvoice;
        clickFlag = true;
        getlistOfLineItems();
        return pageRef;
    }

    
}