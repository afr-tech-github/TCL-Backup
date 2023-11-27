public with sharing class TT_HT_CheckAttmentController {
    public Boolean selected { get; set; }
    public String OderID { get; set; }

    public TT_HT_CheckAttmentController() {
        selected = false;
        OderID = ApexPages.currentPage().getParameters().get('id');

    }
    public void generateAttachmentFile(){
          
        String recordID = String.valueOf(ApexPages.currentPage().getParameters().get('id'));

        // checkPackage = Boolean.valueOf(ApexPages.currentPage().getParameters().get('checkPack'));
        // System.debug('1234:'+ requiredAttachment);
        PageReference pageRef = new PageReference('/apex/page_TT_HT_NoiBo');
        pageRef.getParameters().put('Id', recordID);
        // pageRef.getParameters().put('checkPackage', String.valueOf(checkPackage));
        System.debug('1234:xxxxx' + pageRef);
        String namefile = 'Contract' + '_v';

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
    @AuraEnabled
    public static void generateAttachmentFileForSeaManifest(String id){
          
        

        // checkPackage = Boolean.valueOf(ApexPages.currentPage().getParameters().get('checkPack'));
        // System.debug('1234:'+ requiredAttachment);
        PageReference pageRef = new PageReference('/apex/page_printAirManifest');
        pageRef.getParameters().put('id', id);

        // pageRef.getParameters().put('checkPackage', String.valueOf(checkPackage));
        System.debug('1234:xxxxx' + pageRef);
        String namefile = 'AirManifest' + '_v';

        String attachNameSearch = namefile + '%';
        // get exist file Name
        List<Attachment> attachments = [SELECT Id, Name, ParentId 
                                        FROM Attachment 
                                        WHERE ParentId =: id 
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
            attach.ParentId = id;
            if(!Test.isRunningTest()){
            body = pageRef.getContentAsPDF();
            System.debug('1234:'+body);
            attach.Body = body;
            FlsService.doInsert(attach);
        }
        }
        
        
    }

    @AuraEnabled
    public static void generateAttachmentFileForDocument(String id,String cur){
          
        

        // checkPackage = Boolean.valueOf(ApexPages.currentPage().getParameters().get('checkPack'));
        // System.debug('1234:'+ requiredAttachment);
        PageReference pageRef = new PageReference('/apex/print_Document');
        pageRef.getParameters().put('id', id);
        pageRef.getParameters().put('cur', cur);

        // pageRef.getParameters().put('checkPackage', String.valueOf(checkPackage));
        System.debug('1234:xxxxx' + pageRef);
        String namefile = 'Doccument' + '_v';

        String attachNameSearch = namefile + '%';
        // get exist file Name
        List<Attachment> attachments = [SELECT Id, Name, ParentId 
                                        FROM Attachment 
                                        WHERE ParentId =: id 
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
            attach.ParentId = id;
            if(!Test.isRunningTest()){
            body = pageRef.getContentAsPDF();
            System.debug('1234:'+body);
            attach.Body = body;
            FlsService.doInsert(attach);
        }
        }
        
        
    }
    public void redirectToPrintPage() {
           
        if(selected){
            generateAttachmentFile();

        }
        
  
   
}

}