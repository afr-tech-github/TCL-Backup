public with sharing class HBLController {
    public String id {get; set;}
    public FTMSSO__c shipment {get; set;}
    public List<CntrinTrans__c> trans {get;set;}
    public Boolean checkLine {get; set;}
    public Boolean checkLineMas {get; set;}

    private static Set<String> setFields = new Set<String>();
    private static Set<String> setTransFields = new Set<String>();

    static{
        setFields.add('ShipperDetailInformation__c');
        setFields.add('ConsigneeDetailInformation__c');
        setFields.add('HouseNotifyPartyDetail_Information__c');
        setFields.add('PlaceofReceiptDetailInformation__c');
        setFields.add('POLAODsDetailInformation__c');
        setFields.add('VesselFlight__c');
        setFields.add('Voyage__c');
        setFields.add('PODAOAsDetailInformation__c');
        setFields.add('PlaceofDeliveryDetailInformation__c');
        setFields.add('FinalDestinationsDetailInformation__c');
        setFields.add('MarksNumbersAttachment__c');
        setFields.add('CargoQuantity__c');
        setFields.add('CargoUnit__c');
        setFields.add('DescriptionofGoods__c');
        setFields.add('GrossWeight__c');
        setFields.add('MeasurementTotalCBM__c');
        setFields.add('HouseFreightCollectPrepaid__c');
        setFields.add('AgentDetailInformation__c');
        setFields.add('NumberofOriginalHBLIssued__c');
        setFields.add('Place_of_issue__c');
        setFields.add('Date_of_issue__c');
        setFields.add('HBLNumber__c');
        setFields.add('ReadContainers__c');
        setFields.add('ReadCargoes__c');
        setFields.add('HBLType__c');
        setFields.add('ShipmentTerm__c');
        setFields.add('ServiceType__c');
        setFields.add('TransportationWay__c');
    }
    static{
        setTransFields.add('Container_Number__c');
        setTransFields.add('Container_Type__c');
        setTransFields.add('Seal_Number__c');
        setTransFields.add('Gross_Weight_Kg__c');
        setTransFields.add('Measurement_CBM__c');
        setTransFields.add('Cargo_Quantity__c');
        setTransFields.add('CargoUnit__c');
    }
    public HBLController() {
        id = ApexPages.currentPage().getParameters().get('id');
        checkLine = false;
        checkLineMas = false;
        String strQuery = stringQueryShipment(id);
        String strQueryTrans = stringQueryTrans(id);
        System.debug('strQueryTrans :'+strQueryTrans);
        System.debug('ThongDebug strQuery :'+strQuery);
        shipment = Database.query(strQuery);
        trans = Database.query(strQueryTrans);
        System.debug('trans :'+trans);
        System.debug('ThongDebug :'+shipment);
        if(shipment.DescriptionofGoods__c != null){
            String descrip = String.valueOf(shipment.DescriptionofGoods__c);
            System.debug('111 :'+descrip);
            List<String> lstDes = new List<String>();
            lstDes = descrip.split('\n');
            System.debug('222 :'+lstDes);
            System.debug('Thong222 :'+lstDes.size());
            Decimal countDes = 0;
            for(String lineDes : lstDes){
                Integer lenghtDes = lineDes.length();
                Decimal block = lenghtDes/40;
                Decimal Des = block.setScale(0,RoundingMode.HALF_UP) +1;
                countDes += Des;
                System.debug('333 :'+Des);
            }
            if(countDes > 17){
                checkLine = true;
            }
            System.debug('checkLine :'+checkLine);
        }
        if(shipment.MarksNumbersAttachment__c != null){
            String mark = String.valueOf(shipment.MarksNumbersAttachment__c);
            System.debug('111 :'+mark);
            List<String> lstDesMark = new List<String>();
            lstDesMark = mark.split('\n');
            System.debug('222 :'+lstDesMark);
            System.debug('Thong222 :'+lstDesMark.size());
            Decimal countDes = 0;
            for(String lineDes : lstDesMark){
                Integer lenghtDes = lineDes.length();
                Decimal block = lenghtDes/35;
                Decimal Des = block.setScale(0,RoundingMode.HALF_UP) +1;
                countDes += Des;
                System.debug('333 :'+Des);
            }
            if(countDes > 10){
                checkLineMas = true;
            }
            System.debug('checkLine :'+checkLine);
        }
    }

    @AuraEnabled
    public static void generateAttachmentFile(String recordId,Boolean requiredAttachmentCreation,Boolean isBackground){
        PageReference pdf_file ;
        if(isBackground == true){
            pdf_file =Page.page_HBL;
        }else{
            pdf_file =Page.page_HBL_Nobackground;
        }
        System.debug('recordId :'+recordId);

        pdf_file.getParameters().put('Id', recordId);
        pdf_file.getParameters().put('requiredAttachmentCreation', 'false');
        pdf_file.getParameters().put('isBackground', 'false');
        
        FTMSSO__c item = new FTMSSO__c();
        String strSelect ='SELECT Id,ShipperDetailInformation_text__c,HBLNumber__c,ConsigneeDetailInformation_text__c,HouseNotifyDetailInformation_text__c,PlaceofReceiptDetailInformation__c,POLAODsDetailInformation__c,PODAOAsDetailInformation__c,VesselFlight__c ,Voyage__c,PlaceofDeliveryDetailInformation__c,NumberofOriginalHBLIssued__c,CargoQuantity__c,DescriptionofGoods__c,GrossWeight__c,MeasurementTotalCBM__c,MarksNumbersAttachment__c,CargoUnit__c,HouseFreightCollectPrepaid__c,AgentDetailInformation_text__c,Date_of_issue__c,File_No1__c';
        String strFrom = ' FROM FTMSSO__c ';
        String strWhere = 'WHERE Id = \'' + recordId + '\'' ;
        String strOrderBy = ' ORDER BY Name LIMIT 1';
        String data = strSelect + strFrom + strWhere + strOrderBy;
        System.debug('data :'+data);
        item = Database.query(data);
        String namefile ='HBL_'+item.HBLNumber__c+'_'+item.File_No1__c+'_v' ;

       
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

    private String stringQueryShipment(String shipmentId){
        String strSelect = 'SELECT RecordType.Name,' + String.join(new List<String>(setFields), ',');
        String strFrom = ' FROM FTMSSO__c ';
        String strWhere = 'WHERE Id = \'' + shipmentId + '\'' ;
        String strOrderBy = ' ORDER BY Name LIMIT 1';
        return strSelect + strFrom + strWhere + strOrderBy;
    }
    private String stringQueryTrans(String shipmentId){
        String strSelect = 'SELECT ' + String.join(new List<String>(setTransFields), ',');
        String strFrom = ' FROM CntrinTrans__c ';
        String strWhere = 'WHERE F_TMS_S_O__c = \'' + shipmentId + '\'' ;
        return strSelect + strFrom + strWhere;
    }
}