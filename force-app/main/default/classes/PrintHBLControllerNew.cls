public with sharing class PrintHBLControllerNew {
    public String id {get; set;}
    public String billing {get; set;}
    public String customer {get; set;}
    public String customer1 {get; set;}
    public Boolean isCreateAttachment {get; set;}
    public Boolean isCreateNumber {get;set;}
    public FTMSSO__c shipment {get; set;}
    public FTMSSO__c shipmentnew {get; set;}
    public String notiFy {get; set;}


    public PrintHBLControllerNew() {
        id = ApexPages.currentPage().getParameters().get('id');
        billing = 'hawb';
        customer = ApexPages.currentPage().getParameters().get('customer');
        // isCreateAttachment = ApexPages.currentPage().getParameters().get('isCreateAttachment') == 'true';
        // isCreateNumber = ApexPages.currentPage().getParameters().get('isNumber') == 'true';
        System.debug('id: ' + id + ' isCreateAttachment: ' + isCreateAttachment + ' customer: ' + customer);
        shipment = getData(id);

        if(customer == 'FOR SHIPPER'){
            customer1 = 'ORIGINAL 3' + ' ' + '(' + customer + ')';
        }
        else{

            customer1 = 'ORIGINAL 5' + ' ' + '(' + customer + ')';
        }
        
        if(shipment.MeasurementTotalCBM__c != null){
            shipment.MeasurementTotalCBM__c = shipment.MeasurementTotalCBM__c.setScale(3, RoundingMode.HALF_UP);
        }else {
            shipment.MeasurementTotalCBM__c = 0;
        }
        if(shipment.CWDimension__c != null){
            shipment.CWDimension__c = shipment.CWDimension__c.setScale(3, RoundingMode.HALF_UP);
        }else {
            shipment.CWDimension__c = 0;
        }
        System.debug('shipment: ' + shipment);
        
        Apexpages.currentPage().getHeaders().put('content-disposition', billing == 'hbl' ? 'inline;filename=HBL.pdf' : 'inline; filename=HAWB.pdf');
        notiFy=SetNotify();
    }

    public FTMSSO__c getData(String id){
        List<FTMSSO__c> shipments = [SELECT Id, 
        ShippersAddressonBL__c, 
        ConsigneeDetailInformation1__c,
         DeliveryAgentInfoonBL__c,
         PortofLoadingDetail__c,
         PortofDischargeDetailPrint__c,
         MarksAndNumbers__c,
         DescriptionofGoods__c,
         GrossWeight__c,
         MeasurementTotalCBM__c,
         Measurement__c,
         HouseFreightCollectPrepaid__c,
         GoodsAttachment__c,
         HAWBNumber__c,
         MAWBNumberonAWB__c,
         FlightNumber__c,
         ChargeableWeight__c,
         ETD__c,
         CWDimension__c,
         CargoQuantity__c,
         MasterCarrierConsolidator__c,
         PODAOA__c,
         PODAOA__r.Port_Code_Short__c,
         DimensionDetail__c,
         ShipperDetailInformation_text__c,
         ConsigneeDetailInformation_text__c,
         HouseNotifyDetailInformation_text__c,
         POLAODsDetailInformation__c,
         MAWBNumber__c,
         PODAOA__r.PortCode__c,
         VesselFlight__c,
         PODAOAsDetailInformation__c,
         AgentDetailInformation_text__c,
         InvoiceNumber__c,
         Dimension__c,
         DateofHouseBLIssued__c,
         HBLNumber__c,
         FinalDestinationsDetailInformation__c,
         HouseNotifyParty__c,
         Consignee__c,
         PODAOA2nd__r.PortCode__c,
         PODAOA3rd__r.PortCode__c,
         VesselFlight2nd__c,
         ETD2nd__c,
         ETD3rd__c,
         VesselFlight3rd__c,


         (SELECT TransitVesselFlight__c, ETAatTransitPort__c,
         TransitPort__r.Port_Code_Short__c FROM Transits__r
         WHERE InOrderofTransit__c = 1 LIMIT 1) 
         FROM FTMSSO__c WHERE Id = :id];

        return shipments.size() > 0 ? shipments.get(0) : null;
    }

    @AuraEnabled
    public static Boolean isAutoCheckedCreateAttachment(String id){
        try {
            FTMSSO__c shipment = [SELECT GoodsAttachment__c, TransitPort__c FROM FTMSSO__c WHERE Id = :id];
            return (shipment.GoodsAttachment__c != null || shipment.TransitPort__c != null) ? true : false;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public String SetNotify(){
        if(shipment.HouseNotifyParty__c == shipment.Consignee__c){
            return 'SAME AS CONSIGNEE';
        }else return shipment.HouseNotifyDetailInformation_text__c;
    }
    // public void generateAttachmentFile(){
    //     PageReference pageTo = Page.PrintHBL;
    //     // if(fileType == 'pdf'){
    //     //    pageTo = Page.page_InvoicePrint_V1; 
    //     // }else{ 
    //     //     pageTo = Page.page_InvoicePrintExcel_V1; 
    //     // }
    //     // pageTo.getParameters().put('shipmentId', shipmentId);
    //     // pageTo.getParameters().put('customerId', customerId);
    //     // pageTo.getParameters().put('curr', currencyType);
    //     // pageTo.getParameters().put('companyTo', companyTo);
    //     // pageTo.getParameters().put('bankType', bankType);
    //     // pageTo.getParameters().put('showContainer', 'false');
    //     // pageTo.getParameters().put('templateType', templateType);
        
    //     pageTo.setRedirect(true);
    //     attachName = 'DebitNote v';
    //     String attachNameSearch = attachName + '%';
    //     // get exist file Name
    //     List<Attachment> attachments = [SELECT Id, Name, ParentId 
    //                                     FROM Attachment 
    //                                     WHERE ParentId =: id 
    //                                     AND Name LIKE : attachNameSearch 
    //                                     ORDER BY CreatedDate DESC LIMIT 1];
    //     if(attachments.isEmpty()){
    //         attachName += '1';
    //     }else{
    //         String attachNameExist = attachments[0].Name;
    //         attachNameExist = attachNameExist.substringAfter(attachName);
    //         attachNameExist = attachNameExist.substringBefore('.pdf');
    //         attachNameExist = attachNameExist.substringBefore('.xls');
    //         Decimal versionNumber = Decimal.valueOf(attachNameExist);
    //         versionNumber += 1;
    //         attachName += String.valueOf(versionNumber);
    //     }
    //     if(fileType != 'pdf'){
    //         pageTo.getParameters().put('contentType', 'application/vnd.ms-excel#' + attachName + '.xls'); 
    //     }
    //     System.debug('12345:'+ pageTo);
    //     if(requiredAttachmentCreation ){
 
    //         Attachment attach = new Attachment();
    //         Blob body;
    //         attach.Name = fileType == 'pdf'? attachName + '.pdf' : attachName + '.xls'; 
    //         attach.IsPrivate = false;
    //         attach.ParentId = shipmentId;
    //          if(!Test.isRunningTest()){
    //             System.debug('12345:'+ pageTo);
    //             body = fileType == 'pdf'? pageTo.getContentAsPDF() : pageTo.getContent();
    //             System.debug('12345:'+ body);
    //             attach.Body = body;
    //             FlsService.doInsert(attach);
    //          }
    //     }

    // }
}