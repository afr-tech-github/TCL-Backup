public with sharing class PrintHAWBController {
    public String id {get; set;}
    public FTMSSO__c shipment {get; set;}
    public FTMSSO__c shipmentnew {get; set;}
    public CompanyInformation__c ComInfo {get; set;}
    public Integer count {get; set;}
    private static Set<String> fieldsQuery = new Set<String>();
    static {
        fieldsQuery.add('Id');
        fieldsQuery.add('MAWBNumber__c');
        fieldsQuery.add('ShipperDetailInformation__c');
        fieldsQuery.add('HAWBNumber__c');
        fieldsQuery.add('ConsigneeDetailInformation__c');
        fieldsQuery.add('CargoQuantity__c');
        fieldsQuery.add('CargoUnit__c');
        fieldsQuery.add('GrossWeight__c');
        fieldsQuery.add('ChargeableWeight__c');
        fieldsQuery.add('AgentDetailInformation__c');
        fieldsQuery.add('RateCharge__c');
        fieldsQuery.add('DescriptionofGoods__c');
        fieldsQuery.add('DimensionDetail__c');
        fieldsQuery.add('POLAOD__r.Name');
        fieldsQuery.add('Date_of_issue__c');
		fieldsQuery.add('Place_of_issue__c');

        fieldsQuery.add('POLAOD__r.CountryName__c');
        fieldsQuery.add('PODAOA__r.PortCode__c');
        fieldsQuery.add('PODAOA2nd__r.PortCode__c');
        fieldsQuery.add('PODAOA3rd__r.PortCode__c');

        fieldsQuery.add('FinalDestination__r.PortCode__c');
        fieldsQuery.add('Currency__c');
        fieldsQuery.add('PODAOA2nd__r.CountryCode__c');

        fieldsQuery.add('PODAOA3rd__r.CountryCode__c');
        fieldsQuery.add('VesselFlight__c');
        fieldsQuery.add('ETD__c');
        fieldsQuery.add('VesselFlight2nd__c');
        fieldsQuery.add('VesselFlight3rd__c');
        fieldsQuery.add('CargoDeliveryRemark__c');
        fieldsQuery.add('HouseFreightCollectPrepaid__c');
    }
    public PrintHAWBController() {
        id = ApexPages.currentPage().getParameters().get('id');
        System.debug('id: ' + id);
        shipment = getShipment(id);
        System.debug('shipment: ' + shipment);
        ComInfo = [SELECT CompanyLogo__c FROM CompanyInformation__c LIMIT 1];
        
        count = 0;
        //  list = new List<String>();
        if(shipment.DescriptionofGoods__c != null){
            List<String> list1 = shipment.DescriptionofGoods__c.split('\n');
            for(String str : list1){
                count++;
            }
            
        }
        if(shipment.DimensionDetail__c != null){
            List<String> list2 = shipment.DimensionDetail__c.split('\n');
           for(String str : list2){
               count++;
           }
            
        }
        System.debug('i: ' + count);
    }

    @AuraEnabled
    public static void createAttatchment(String recordId, String backGround){
        System.debug('recordId: '+recordId);
        FTMSSO__c SO = [SELECT Id, Name, JobRequestID__c, File_No1__c FROM FTMSSO__c WHERE Id =: recordId];
        PageReference pdf_file = backGround ==  'true' ? Page.page_HAWB3 : Page.page_HAWB2;
        pdf_file.getParameters().put('id', recordId);
        String namefile = 'TCL_HAWB_' + SO.JobRequestID__c;
        // for(PicklistEntry value: User.LanguageLocalekey.getDescribe().getPicklistValues()) {
        //     if(value.getValue().contains(language)) {
        //         languaName = value.getLabel();
        //         break;
        //     }
        // }
        String attachName = namefile + '_v';
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
        // Attachment attach = new Attachment();
        // Blob body;
        // attach.Name = attachName + '.pdf'; 
        // attach.IsPrivate = false;
        // attach.ParentId = recordId;
        // if(!Test.isRunningTest()){
        //     body = pdf_file.getContentAsPDF();
        //     attach.Body = body;
        //     insert(attach);
        // }
        ContentVersion cv = new ContentVersion();
        // Blob body;
        cv.PathOnClient = attachName + '.pdf';
        cv.Title = attachName + '.pdf';
        cv.Description = attachName + '.pdf';
        cv.FirstPublishLocationId = recordId;
        if(!Test.isRunningTest()){
            // body = pdf_file.getContentAsPDF();
            cv.VersionData = pdf_file.getContentAsPDF();
            // attach.Body = body;
            insert cv;
        }

    }

    private FTMSSO__c getShipment(String shipId){
        String strSelect = String.join(new List<String>(fieldsQuery), ',');
        String strQuery = 'SELECT ' + strSelect 
                    + ' FROM FTMSSO__c'
                    + ' WHERE Id = \'' + String.escapeSingleQuotes(shipId) + '\'';
        
        FTMSSO__c ship;
        try{
            ship = Database.query(strQuery);
            System.debug('get');
        } catch(QueryException e){
            ship = new FTMSSO__c();
        }
        return ship;
    }
}