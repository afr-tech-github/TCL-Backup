public class DeliveryRecordController_V2 {
	public FTMSSO__c shipment {get;set;}
    public Date today {get; set;}
    public String myDateString {get; set;}
    public String accountName {get; set;}
    public List <CompanyInformation__c> companyInfor {get; set;}
    public CompanyInformation__c companyInforHCM {get; set;}
    public CompanyInformation__c companyInforDN {get; set;}
    public CompanyInformation__c companyInforHPH {get; set;}
   
    private String shipId {get; set;}

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
        fieldsFTMSQuery.add('Shipper__r.Name');
        fieldsFTMSQuery.add('MBLNumber__c');
        fieldsFTMSQuery.add('HBLNumber__c');
    	fieldsFTMSQuery.add('PlaceofDeliveryDetailInformation__c');
        fieldsFTMSQuery.add('CargoQuantity__c');    
        fieldsFTMSQuery.add('CargoUnit__c');    
        fieldsFTMSQuery.add('Plural_Cargo_Unit__c');
        fieldsFTMSQuery.add('GrossWeight__c');    
        fieldsFTMSQuery.add('NetWeightKg__c');
        fieldsFTMSQuery.add('FinalDestinationsDetailInformation__c');
        
            
    }

    public DeliveryRecordController_V2(){
        companyInfor = new List<CompanyInformation__c>();
        companyInfor = getComInfor();
        companyInforHCM = new CompanyInformation__c();
        companyInforDN = new CompanyInformation__c();
        companyInforHPH = new CompanyInformation__c();
        
        companyInforHCM = getComInforHCM();
        companyInforDN = getComInforDN();
        companyInforHPH = getComInforHPH();
            
        
		today = Date.today();
        myDateString = Datetime.now().format('dd MMM, yyyy h:mm:ssa');
        accountName = UserInfo.getName();
        shipId = ApexPages.currentPage().getParameters().get('Id');
        shipment = getShipment(shipId); 
    }

    private List<CompanyInformation__c> getComInfor (){
        List<CompanyInformation__c> infor = new List<CompanyInformation__c>();
        String strSelect = String.join(new List<String>(fieldsComInfoQuery), ','); 
        String strQuery  =  'SELECT ' + strSelect 
                            + ' FROM CompanyInformation__c'
                            + ' WHERE ShowAddressonHeader__c = true';
        try{
            infor = Database.query(strQuery); 
            for(CompanyInformation__c com : infor){
                if(com.Name != null){
                    com.Name = com.Name.replace('TIMES CARGO LOGISTIC CO.,LTD - ', '');
                }
            }
        } catch(QueryException e){
            infor = new List<CompanyInformation__c>();
        }
        return infor;
    }
    private CompanyInformation__c getComInforHCM(){
		CompanyInformation__c infor = new CompanyInformation__c();
        String strSelect = String.join(new List<String>(fieldsComInfoQuery), ','); 
        String strQuery = 'SELECT ' + strSelect +
                  ' FROM CompanyInformation__c' +
                  ' WHERE Branch1__c = \'Hồ Chí Minh\'';
        try{
            infor = Database.query(strQuery); 
           
                if(infor.Name != null){
                    infor.Name = infor.Name.replace('TIMES CARGO LOGISTIC CO.,LTD - ', '');
                }
            
        } catch(QueryException e){
            infor = new CompanyInformation__c();
        }
        return infor;
       
    }
    private CompanyInformation__c getComInforDN(){
		CompanyInformation__c infor = new CompanyInformation__c();
        String strSelect = String.join(new List<String>(fieldsComInfoQuery), ','); 
        String strQuery = 'SELECT ' + strSelect +
                  ' FROM CompanyInformation__c' +
                  ' WHERE Branch1__c = \'Đà Nẵng\'';
        try{
            infor = Database.query(strQuery); 
           
                if(infor.Name != null){
                    infor.Name = infor.Name.replace('TIMES CARGO LOGISTIC CO.,LTD - ', '');
                }
            
        } catch(QueryException e){
            infor = new CompanyInformation__c();
        }
        return infor;
    }
    private CompanyInformation__c getComInforHPH(){
		CompanyInformation__c infor = new CompanyInformation__c();
        String strSelect = String.join(new List<String>(fieldsComInfoQuery), ','); 
        String strQuery = 'SELECT ' + strSelect +
                  ' FROM CompanyInformation__c' +
                  ' WHERE Branch1__c = \'Hải Phòng\'';
        try{
            infor = Database.query(strQuery); 
           
                if(infor.Name != null){
                    infor.Name = infor.Name.replace('TIMES CARGO LOGISTIC CO.,LTD - ', '');
                }
            
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
        pdf_file = Page.page_DeliveryRecord_V2;
       
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
        String namefile ='ProofOfDelivery_v' ;

       
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