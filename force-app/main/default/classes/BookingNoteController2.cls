public with sharing class BookingNoteController2{
    public FTMSSO__c shipment {get;set;}
    public CompanyInformation__c companyInfor {get; set;}
    private String shipId {get; set;}
    public String bookingNo {get; set;}

    private static Set<String> fieldsComInfoQuery = new Set<String>();
    static{
        fieldsComInfoQuery.add('Name');
        fieldsComInfoQuery.add('Address__c');
        fieldsComInfoQuery.add('Branch1__c');
        fieldsComInfoQuery.add('Fax__c');
        fieldsComInfoQuery.add('Tel__c');
        fieldsComInfoQuery.add('Website__c');
        fieldsComInfoQuery.add('ShowAddressonHeader__c');
    }

    private static Set<String> fieldsFTMSQuery = new Set<String>();
    static{
        fieldsFTMSQuery.add('ConsigneeDetailInformation__c');
        fieldsFTMSQuery.add('Consignee__r.name');
        fieldsFTMSQuery.add('BookingNo__c');
        fieldsFTMSQuery.add('ShipperDetailInformation__c');
        fieldsFTMSQuery.add('PlaceofReceipt__r.Name');
        fieldsFTMSQuery.add('PlaceofDelivery__r.Name');
        fieldsFTMSQuery.add('PlaceofStuffing__c');
        fieldsFTMSQuery.add('ETD__c');
       	fieldsFTMSQuery.add('FinalDestination__r.CountryName__c');
        fieldsFTMSQuery.add('DescriptionofGoods__c');
        fieldsFTMSQuery.add('MeasurementTotalCBM__c');
        fieldsFTMSQuery.add('NotesforCustomer__c');
        fieldsFTMSQuery.add('ETD__c');
        fieldsFTMSQuery.add('HouseBookingNo__c');
        
       
        
    }

    public BookingNoteController2(){
        companyInfor = new CompanyInformation__c();
        companyInfor = getComInfor();
        shipId = ApexPages.currentPage().getParameters().get('Id');
        
        shipment = getShipment(shipId);
    }

    private CompanyInformation__c getComInfor (){
        CompanyInformation__c infor = new CompanyInformation__c();
        String strSelect = String.join(new List<String>(fieldsComInfoQuery), ','); 
        String strQuery = 'SELECT ' + strSelect +
                  ' FROM CompanyInformation__c' +
                  ' WHERE Branch1__c = \'Hồ Chí Minh\'';
        try{
            infor = Database.query(strQuery); 
            
        } catch(QueryException e){
            infor = new CompanyInformation__c();
        }
        return infor;
    }

    private FTMSSO__c getShipment(String shipId){
        FTMSSO__c shipment = new FTMSSO__c();
        String strSelect = String.join(new List<String>(fieldsFTMSQuery), ','); 
        String strQuery  =  'SELECT ' + strSelect 
                            + ' FROM FTMSSO__c'
                            + ' WHERE Id = \'' + String.escapeSingleQuotes(shipId) + '\'';
        try{
            shipment = Database.query(strQuery); 
        } catch(QueryException e){
            shipment = new FTMSSO__c();
        }
        return shipment;
    }
    @AuraEnabled
    public static void generateAttachmentFile(String recordId,Boolean requiredAttachmentCreation,Boolean isBackground){
        PageReference pdf_file ;
        pdf_file = Page.page_BookingNote2_PDF;
       
        System.debug('recordId :'+recordId);

        pdf_file.getParameters().put('Id', recordId);
        pdf_file.getParameters().put('requiredAttachmentCreation', 'false');
        pdf_file.getParameters().put('isBackground', 'false');
        
        FTMSSO__c item = new FTMSSO__c();
        String strSelect ='SELECT Id,ShipperDetailInformation_text__c,HBLNumber__c,ConsigneeDetailInformation_text__c,HouseNotifyDetailInformation_text__c,PlaceofReceiptDetailInformation__c,POLAODsDetailInformation__c,PODAOAsDetailInformation__c,VesselFlight__c ,Voyage__c,PlaceofDeliveryDetailInformation__c,NumberofOriginalHBLIssued__c,CargoQuantity__c,DescriptionofGoods__c,GrossWeight__c,MeasurementTotalCBM__c,MarksNumbersAttachment__c,CargoUnit__c,HouseFreightCollectPrepaid__c,AgentDetailInformation_text__c,Date_of_issue__c';
        String strFrom = ' FROM FTMSSO__c ';
        String strWhere = 'WHERE Id = \'' + recordId + '\'' ;
        String strOrderBy = ' ORDER BY Name LIMIT 1';
        String data = strSelect + strFrom + strWhere + strOrderBy;
        System.debug('data :'+data);
        item = Database.query(data);
        String namefile ='BookingNote_v' ;

       
        String attachName = namefile ;
        String attachNameSearch = attachName + '%';
        // get exist file Name
        List<Attachment> attachments = [SELECT Id, Name, ParentId 
                                        FROM Attachment 
                                        WHERE ParentId =: recordId 
                                        AND Name LIKE : attachNameSearch 
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
        if(requiredAttachmentCreation != false){
            Attachment attach = new Attachment();
            Blob body;
            attach.Name = attachName + '.pdf'; 
            attach.IsPrivate = false;
            attach.ParentId = recordId;
            if(!Test.isRunningTest()){
                System.debug('checkk');
                body = pdf_file.getContentAsPDF();
            
                attach.Body = body;
                FlsService.doInsert(attach);
            }
        }   
    }

}