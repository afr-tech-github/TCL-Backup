public with sharing class CreditNoteSelectionController {
    public String shipmentID {get; set;}
    public String selectedCustomerId {get; set;}
    public String openUrl {get; set;}
    public String errorMessage {get; private set;}
    public Boolean requiredAttachmentCreation {get; set;}
    public CreditNoteSelectionController() {
        shipmentID = ApexPages.currentPage().getParameters().get('id');
        errorMessage = null;
    }
    public List<SelectOption> getCustomers() {
        List<FTMSBill__c> bills = [SELECT PaymentTo__c, PaymentTo__r.Name FROM FTMSBill__c WHERE FTMSSO__c =: shipmentId];
        List<SelectOption> options = new List<SelectOption>();
        Set<String> lstCus = new Set<String>();
        for (FTMSBill__c bill : bills){
            if (!lstCus.contains(bill.PaymentTo__c) && bill.PaymentTo__c != null){
                lstCus.add(bill.PaymentTo__c);
                options.add(new SelectOption(bill.PaymentTo__c, bill.PaymentTo__r.Name));
            }
        }
        return options;
    }
    public void generateReport() {
        errorMessage = null;
        if (StringUtils.isEmpty(selectedCustomerId)) {
            errorMessage = 'You have not selected any customer/partner or no customer/partner is applicable.';
        }  else {
            // openUrl = '/apex/page_PrintCreditNote?Id=' + shipmentID+ '&cusId=' + selectedCustomerId;
            // System.debug('hello' + openUrl);
            if (requiredAttachmentCreation) {
                String attachmentId = createAttachment(shipmentID,selectedCustomerId);
                openUrl = '/servlet/servlet.FileDownload?file=' + attachmentId;
            } else {
                openUrl = '/apex/page_PrintCreditNote?Id=' + shipmentID+ '&cusId=' + selectedCustomerId;

            }
        }  
            // if (requiredAttachmentCreation) {
            //     String attachmentId = createAttachment(shipmentID,selectedCustomerId);
            //     openUrl = '/servlet/servlet.FileDownload?file=' + attachmentId;
            // } else {
            //     openUrl = '/apex/page_PrintCreditNote?Id=' + shipmentID+ '&cusId=' + selectedCustomerId;

            // }
        
    }
    private String createAttachment(String shipid, String customerId) {
        if (PermissionValidationUtil.isCreatableAttachment()) {
            PageReference pageRef = new PageReference('/apex/page_PrintCreditNote');
            pageRef.getParameters().put('Id',shipid);
            pageRef.getParameters().put('customerValue',customerId);
            String attachName = 'Credit Notes' + ' v';
	        String attachNameSearch = attachName + '%';
	        // get exist file Name
	        List<Attachment> attachments = [SELECT Id, Name, ParentId 
	                                        FROM Attachment 
	                                        WHERE Name LIKE : attachNameSearch 
	                                        ORDER BY CreatedDate DESC LIMIT 1];
	        if(attachments.isEmpty()){
	            attachName += '1.1';
	        }else{
	            String attachNameExist = attachments[0].Name;
	            attachNameExist = attachNameExist.substringAfter(attachName);
	            attachNameExist = attachNameExist.substringBefore('.pdf');
	            Decimal versionNumber = Decimal.valueOf(attachNameExist);
	            versionNumber += 0.1;
	            attachName += String.valueOf(versionNumber);
	        }
	        Attachment attach = new Attachment();
	        Blob body;
	        attach.Name = attachName + '.pdf'; 
	        attach.IsPrivate = false;
            attach.ParentId = shipid;
	        if(!Test.isRunningTest()){
	            body = pageRef.getContentAsPDF();
	            attach.Body = body;
	            FlsService.doInsert(attach);
	        }
            return attach.Id;
        }
        return null;
    }
}