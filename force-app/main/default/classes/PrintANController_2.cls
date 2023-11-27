public with sharing class PrintANController_2{
    public FTMSSO__c shipment {get;set;}
    public List <CompanyInformation__c> companyInfor {get; set;}
    private String shipId {get; set;}
    public Date today {get; set;}
    public Datetime myDatetime {get; set;}
    public String myDateString {get; set;}
    public String accountName {get; set;}
    public List <CntrinTrans__c> cntrinTrans {get; set;}
    
    private static Set<String> fieldsCNTRQuery = new Set<String>();
    static{
        fieldsCNTRQuery.add('ContainerDetailedInformation__c');
        fieldsCNTRQuery.add('CargoUnit__c');
        fieldsCNTRQuery.add('Cargo_Quantity__c');
        fieldsCNTRQuery.add('PluralCargoUnit__c');
        fieldsCNTRQuery.add('Description_of_Goods__c');
        fieldsCNTRQuery.add('Gross_Weight_Kg__c');
        fieldsCNTRQuery.add('HSCode__c');
        fieldsCNTRQuery.add('Measurement_CBM__c');
    }

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
        fieldsFTMSQuery.add('ShipperDetailInformation__c');
        fieldsFTMSQuery.add('Voyage__c');
        fieldsFTMSQuery.add('VesselFlight__c');
        fieldsFTMSQuery.add('JobRequestID__c');
        fieldsFTMSQuery.add('HBLNumber__c');
        fieldsFTMSQuery.add('MBLNumber__c');
        fieldsFTMSQuery.add('MeasurementTotalCBM__c');
        fieldsFTMSQuery.add('ETA__c');
        fieldsFTMSQuery.add('NotesforCustomer__c');
        fieldsFTMSQuery.add('GrossWeight__c');
        fieldsFTMSQuery.add('CargoQuantity__c');
        fieldsFTMSQuery.add('CargoUnit__c');
        fieldsFTMSQuery.add('Plural_Cargo_Unit__c');
        fieldsFTMSQuery.add('DescriptionofGoods__c');
        fieldsFTMSQuery.add('POLAOD__r.City_Name__c');
        fieldsFTMSQuery.add('PODAOA__r.City_Name__c');
        fieldsFTMSQuery.add('PODAOA__r.Name');
        fieldsFTMSQuery.add('PODAOA__r.CountryName__c');
        fieldsFTMSQuery.add('HSCode__c');
    }

    public PrintANController_2(){
        companyInfor = new List<CompanyInformation__c>();
        companyInfor = getComInfor();

        shipId = ApexPages.currentPage().getParameters().get('Id');
        shipment = getShipment(shipId); 
        cntrinTrans = getCntrinTrans(shipId);

        today = Date.today();
        myDateString = Datetime.now().format('dd MMM, yyyy h:mm:ssa');
        accountName = UserInfo.getName();
        
        // if(shipment.PortofDischargeDetailPrint__c!= null) shipment.PortofDischargeDetailPrint__c = shipment.PortofDischargeDetailPrint__c.toUppercase();
        if (shipment.POLAOD__r.City_Name__c != null) shipment.POLAOD__r.City_Name__c = shipment.POLAOD__r.City_Name__c.toUppercase();
        if (shipment.PODAOA__r.City_Name__c != null) shipment.PODAOA__r.City_Name__c = shipment.PODAOA__r.City_Name__c.toUppercase();
        if (shipment.PODAOA__r.Name != null) shipment.PODAOA__r.Name = shipment.PODAOA__r.Name.toUppercase();
        for(CntrinTrans__c cntr: cntrinTrans){
            if (cntr.Cargo_Quantity__c == null) cntr.Cargo_Quantity__c = -1;
        }
        
    }

    private List<CompanyInformation__c> getComInfor (){
        List<CompanyInformation__c> infor = new List<CompanyInformation__c>();
        List<String> city_name = new List<String>{'Hồ Chí Minh','Hải Phòng','Đà Nẵng'};

        String strSelect = String.join(new List<String>(fieldsComInfoQuery), ','); 

        for (String city: city_name){
            CompanyInformation__c comInfor = new CompanyInformation__c();
            String strQuery  =  'SELECT ' + strSelect 
            + ' FROM CompanyInformation__c'
            + ' WHERE ShowAddressonHeader__c = true AND Branch1__c = \'' + String.escapeSingleQuotes(city) + '\'';
            try{
                comInfor = Database.query(strQuery); 
                infor.add(comInfor);
            } catch(QueryException e){
                comInfor = new CompanyInformation__c();
            }
        }
        for(CompanyInformation__c com : infor){
            if(com.Name != null){
                com.Name = com.Name.replace('TIMES CARGO LOGISTIC CO.,LTD - ', '');
            }
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

    private List<CntrinTrans__c> getCntrinTrans(String shipId){
        List<CntrinTrans__c> cntrinTrans = new List<CntrinTrans__c>();
        String strSelect = String.join(new List<String>(fieldsCNTRQuery), ','); 
        String strQuery  =  'SELECT ' + strSelect 
                            + ' FROM CntrinTrans__c'
                            + ' WHERE F_TMS_S_O__c = \'' + String.escapeSingleQuotes(shipId) + '\'';
        try{
            cntrinTrans = Database.query(strQuery); 
        } catch(QueryException e){
            cntrinTrans = new List<CntrinTrans__c>();
        }
        return cntrinTrans;
    }

    @AuraEnabled
    public static void generateAttachmentFile(String recordId,Boolean requiredAttachmentCreation){
        PageReference pdf_file;
        pdf_file = Page.page_PrintAN_2_Attachment;
        System.debug('recordId :'+recordId);

        pdf_file.getParameters().put('Id', recordId);
        pdf_file.getParameters().put('requiredAttachmentCreation', 'false');
        
        String namefile ='TCL_AN_' ;

       
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
                System.debug('debuggg Thong :'+body);
                attach.Body = body;
                FlsService.doInsert(attach);
            }
        }   
    }
}