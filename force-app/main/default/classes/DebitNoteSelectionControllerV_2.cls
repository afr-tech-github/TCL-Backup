public with sharing class DebitNoteSelectionControllerV_2 {
    public String shipmentID {get; set;}
    public String selectedCustomerId {get; set;}
    public String openUrl {get; set;}
    public String agent {get; set;}
    public String errorMessage {get; private set;}
    public Boolean requiredAttachmentCreation {get; set;}
    public Date today {get; set;}

    public FTMSSO__c shipment {get; set;}

    public DebitNoteSelectionControllerV_2() {
        shipmentID = ApexPages.currentPage().getParameters().get('id');
        errorMessage = null;
        FTMSSO__c ship = [Select Agent__c From FTMSSO__c Where Id =: shipmentID];
        agent = ship.Agent__c;
        System.debug('111a :'+agent);
        today = Date.today();
    }
    public List<SelectOption> getCustomers() {
        List<FTMSBill__c> bills = [SELECT InvoiceTo__c, InvoiceTo__r.Name FROM FTMSBill__c WHERE FTMSSO__c =: shipmentId];
        List<SelectOption> options = new List<SelectOption>();
        Set<String> lstCus = new Set<String>();
        for (FTMSBill__c bill : bills){
            if (!lstCus.contains(bill.InvoiceTo__c) && bill.InvoiceTo__c != null){
                lstCus.add(bill.InvoiceTo__c);
                options.add(new SelectOption(bill.InvoiceTo__c, bill.InvoiceTo__r.Name));
            }
        }
        return options;
    }
    public void generateReport() {
        System.debug('222b :'+selectedCustomerId);
        errorMessage = null;
        if (StringUtils.isEmpty(selectedCustomerId)) {
            errorMessage = 'You have not selected any customer/partner or no customer/partner is applicable.';
        }  else {
            if (requiredAttachmentCreation) {
                String attachmentId = createAttachment(shipmentID,selectedCustomerId);
                openUrl = '/servlet/servlet.FileDownload?file=' + attachmentId;
            } else {
                if(selectedCustomerId == agent){
                    openUrl = '/apex/page_DebitNoteAgent?Id=' + shipmentID + '&customerValue=' + selectedCustomerId;
                }else {
                    openUrl = '/apex/page_DebitNoteForCustomer?Id=' + shipmentID + '&customerValue=' + selectedCustomerId;
                }

            }
        }  
        
        String strSelect = 'SELECT OutboundVATInvNo__c';
        String strFrom = ' FROM FTMSBill__c ';
        String strWhere = 'WHERE FTMSSO__c = \'' + shipmentID + '\'' ;
        String strOrderBy = ' ORDER BY Name';
        String query = strSelect + strFrom + strWhere +strOrderBy;  
        List<FTMSBill__c> lstBill = Database.query(query);
        List<String> numberPoint = new List<String>();
        for(FTMSBill__c bill : lstBill){
            if(bill.OutboundVATInvNo__c != null){
                String endPoint = bill.OutboundVATInvNo__c.substringAfterLast('-');
                System.debug('333c :'+endPoint);
                numberPoint.add(endPoint);
            }

            
        }
        System.debug('444d :'+numberPoint); 
        Integer max = 0;
        for(Integer i = 0; i < numberPoint.size(); i++){
            max = Integer.valueOf(numberPoint[0]);
            if(Integer.valueOf(numberPoint[i]) > max){
                max = Integer.valueOf(numberPoint[i]);
            }
        }
        System.debug('555b :'+max);
        for(FTMSBill__c bill : lstBill){
            System.debug('666b :'+max);
            if(bill.OutboundVATInvNo__c == null){
                bill.OutboundVATInvNo__c = 'ASAP-DN-' + String.valueOf(today.year()).substring(2) + String.valueOf(today.month()) +'-'+ (max+1);
            }
        }
        update lstBill;
    }
    private String createAttachment(String shipid, String customerId) {
        if (PermissionValidationUtil.isCreatableAttachment()) {
            PageReference pageRef = new PageReference('/apex/page_DebitNote');
            pageRef.getParameters().put('Id',shipid);
            pageRef.getParameters().put('customerValue',customerId);
            String attachName = 'Dedit Notes' + ' v';
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