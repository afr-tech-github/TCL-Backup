public with sharing class ANSelectionController {
    public Boolean requiredAttachment {get;set;}
    public Boolean checkPackage {get;set;}
    public String titlePdf {get;set;}
    public String shipId {get;set;}
    public FTMSSO__c shipment {get;set;}

    public ANSelectionController() {
        shipment =  new FTMSSO__c();
        titlePdf = '';

        shipId = ApexPages.currentPage().getParameters().get('Id');

        shipment = [SELECT Id,RecordTypeId,Name,HBLNumber__c,HAWBNumber__c FROM FTMSSO__c WHERE Id =: shipId];
        String RecordTypeId = shipment.RecordTypeId;
        String RecordType = [SELECT Id,Name FROM RecordType WHERE Id =:recordTypeId].Name;
        if( shipment.HBLNumber__c != null){

            if(RecordType == 'Ocean Export' || RecordType == 'Ocean Import'){
                titlePdf = 'AN - ' + shipment.HBLNumber__c+'.pdf';
            }else if(RecordType == 'Air Export' || RecordType == 'Air Import'){
                titlePdf = 'AN - ' + shipment.HAWBNumber__c+'.pdf';
            }
        }
    }

    public PageReference closePopupDialog() {
        PageReference page = new PageReference('/'+shipId);
        page.setRedirect(true);
        return page;
    }

    public void generateAttachmentFile(){
        requiredAttachment = Boolean.valueOf(ApexPages.currentPage().getParameters().get('checkAttment'));
        checkPackage = Boolean.valueOf(ApexPages.currentPage().getParameters().get('checkPack'));
        System.debug('1234:'+ requiredAttachment);
        PageReference pageRef = new PageReference('/apex/page_PrintAN');
        pageRef.getParameters().put('Id', shipId);
        pageRef.getParameters().put('checkPackage', String.valueOf(checkPackage));
        System.debug('1234:' + pageRef);
        String namefile = titlePdf + '_v';

        String attachNameSearch = namefile + '%';
        // get exist file Name
        List<Attachment> attachments = [SELECT Id, Name, ParentId 
                                        FROM Attachment 
                                        WHERE ParentId =: shipId 
                                        AND Name LIKE : attachNameSearch 
                                        ORDER BY CreatedDate DESC LIMIT 1];
                                        
        if(attachments.isEmpty()){
            namefile += '1.1';
        }else{
            String attachNameExist = attachments[0].Name;
            attachNameExist = attachNameExist.substringAfter(namefile);
            attachNameExist = attachNameExist.substringBefore('.pdf');
            Decimal versionNumber = Decimal.valueOf(attachNameExist);
            versionNumber += 0.1;
            namefile += String.valueOf(versionNumber);
        }
        if(requiredAttachment != false){
            Attachment attach = new Attachment();
            Blob body;
            attach.Name = namefile + '.pdf'; 
            attach.IsPrivate = false;
            attach.ParentId = shipId;
            if(!Test.isRunningTest()){
            body = pageRef.getContentAsPDF();
            System.debug('1234:'+body);
            attach.Body = body;
            FlsService.doInsert(attach);
        }
        }
        
        
    }
}