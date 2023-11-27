public with sharing class selectTrainsController {
    @AuraEnabled
    public static List<Transportation__c> getPackagesForOrder(Id orderId) {
        // Query the packages related to the current order
        return [SELECT Id, Name,TruckingBillNo__c,Departure__r.Name,Destination__r.Name,Pick_up_date__c FROM Transportation__c WHERE F_TMS_S_O__c = :orderId];
    }
    @AuraEnabled
    public static void GetgenerateAttachmentFile(String id,String recordID){
          
        

        // checkPackage = Boolean.valueOf(ApexPages.currentPage().getParameters().get('checkPack'));
        // System.debug('1234:'+ requiredAttachment);
        PageReference pageRef = new PageReference('/apex/page_TruckingBillForm');
        pageRef.getParameters().put('id', id);
        pageRef.getParameters().put('orderId', recordID);


        // pageRef.getParameters().put('checkPackage', String.valueOf(checkPackage));
        System.debug('1234:xxxxx' + pageRef);
        String namefile = 'TruckingBillForm' + '_v';

        String attachNameSearch = namefile + '%';
        // get exist file Name
        List<Attachment> attachments = [SELECT Id, Name, ParentId 
                                        FROM Attachment 
                                        WHERE ParentId =: recordID 
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
        if(true){
            Attachment attach = new Attachment();
            Blob body;
            attach.Name = namefile + '.pdf'; 
            attach.IsPrivate = false;
            attach.ParentId = recordID;
            if(!Test.isRunningTest()){
            body = pageRef.getContentAsPDF();
            System.debug('1234:'+body);
            attach.Body = body;
            FlsService.doInsert(attach);
        }
        }
        
        
    }
}