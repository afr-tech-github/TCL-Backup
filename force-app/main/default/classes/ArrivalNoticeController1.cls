public with sharing class ArrivalNoticeController1 {
    public Boolean requiredAttachment {get;set;}
    public String titlePdf {get;set;}
    public String shipId {get;set;}
    public FTMSSO__c shipment {get;set;}

    public ArrivalNoticeController1() {
        shipment =  new FTMSSO__c();
        titlePdf = '';

        shipId = ApexPages.currentPage().getParameters().get('Id');

        shipment = [SELECT Id,RecordTypeId,Name,HBLNumber__c,HAWBNumber__c FROM FTMSSO__c WHERE Id =: shipId];
        String RecordTypeId = shipment.RecordTypeId;
        String RecordType = [SELECT Id,Name FROM RecordType WHERE Id =:recordTypeId].Name;
        if(RecordType == 'Ocean Export' || RecordType == 'Ocean Import'){
            titlePdf = 'DO - ' + shipment.HBLNumber__c;
        }else if(RecordType == 'Air Export' || RecordType == 'Air Import'){
            titlePdf = 'DO - ' + shipment.HAWBNumber__c;
        }
    }

    public PageReference closePopupDialog() {
        PageReference page = new PageReference('/'+shipId);
        page.setRedirect(true);
        return page;
    }

    public void generateAttachmentFile(){
        // requiredAttachment = Boolean.valueOf(ApexPages.currentPage().getParameters().get('checkAttment'));
        System.debug('1234:'+ requiredAttachment);
        PageReference pageRef = new PageReference('/apex/page_ArrivalNotice');
        pageRef.getParameters().put('Id', shipId);
        // pageRef.getParameters().put('checkAtt', String.valueOf(requiredAttachment));
       
    }
}