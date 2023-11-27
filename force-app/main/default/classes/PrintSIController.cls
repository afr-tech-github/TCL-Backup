public with sharing class PrintSIController {
    public String id {get; set;}
    public FTMSSO__c shipment {get; set;}
    public FTMSSO__c shipmentnew {get; set;}
    public String readUnit {get; set;}
    public List<CntrinTrans__c> lstCon {get; set;}
    public List<WrapperCon> lstConOutput {get; set;}
    public String typeMarks {get; set;}
    public String typeDescrip {get; set;}
    public String typeMarksBlank {get; set;}
    public String typeDescripBlank {get; set;}
    public String readCon{get; set;}
    public String readConFull{get; set;}
    public Decimal totalQuantity{get; set;}
    public Decimal totalGrossWeight{get; set;}
    public Decimal totalMeasurement{get; set;}
    public Integer finalTop {get;set;}
    public Integer finalTopBlank {get;set;}
    public String type {get; set;}
    public Boolean isCreateAttachment {get; set;}
    public Boolean isShowCont {get; set;}
    public String backGround {get;set;}
    public String cargoUnit {get; set;}


    public PrintSIController() {
        id = ApexPages.currentPage().getParameters().get('id');
        type = ApexPages.currentPage().getParameters().get('type');
        System.debug('type :'+type);
        backGround = ApexPages.currentPage().getParameters().get('backGround');
        isCreateAttachment = ApexPages.currentPage().getParameters().get('isCreateAttachment') == 'true';
        isShowCont = ApexPages.currentPage().getParameters().get('isShowCont') == 'true';
        System.debug('isCreateAttachment :'+isCreateAttachment);
        System.debug('backGround :'+backGround);
        cargoUnit = '';
        shipment = getData(id);
        String descrip = shipment.DescriptionofGoods__c;
        System.debug('111 :'+descrip);
        Decimal quantityCargo = 0;
        if (shipment.CargoQuantity__c != null){
            quantityCargo = shipment.CargoQuantity__c;
        }
        String quantity =  ReadNumberToWords.convert(quantityCargo.setScale(2, System.RoundingMode.HALF_UP));
        String addS =  shipment.CargoQuantity__c==1?''+ ' ONLY':'(S)' + ' ONLY';
        readUnit = quantity + ' (' + String.valueOf(quantityCargo) + ') ' + shipment.CargoUnit__c + addS;
        lstCon = getDataCon(id);
        lstConOutput = new List<WrapperCon>();
        Integer top = 107;
        Integer topDes = 103;
        Integer topBlank = 116;
        Integer topDesBlank = 112;
        String read = '';
        totalQuantity = 0;
        totalMeasurement =0;
        totalGrossWeight = 0;
        finalTop = 0;
        finalTopBlank = 0;
        Integer count = 0;
        for (CntrinTrans__c con : lstCon) {
            WrapperCon conOutput = new WrapperCon(); 
            String output = 'position:absolute; left: 11mm; top:' + top + 'mm; width:50mm; text-align: left';
            String outputBlank = 'position:absolute; left: 15mm; top:' + topBlank + 'mm; width:50mm; text-align: left';
            conOutput.conNo = con.Container_Number__c;
            conOutput.conType = con.Container_Type__c;
            conOutput.sealNo = con.Seal_Number__c;
            if(con.Cargo_Unit__c != null && con.Cargo_Quantity__c == 1){
                conOutput.unit = con.Cargo_Unit__c;
            }
            if(con.Cargo_Unit__c != null && con.Cargo_Quantity__c > 1){
                conOutput.unit = con.Cargo_Unit__c +'S';
            }
            if(con.Cargo_Unit__c == null){
                conOutput.unit = '';
            }
            
            conOutput.type = output;
            conOutput.typeBlank = outputBlank;
            conOutput.typeReadCon = 'position:absolute; left: 81mm; top:' + topDes + 'mm; width:60mm; text-align: left;';
            conOutput.typeReadConBlank = 'position:absolute; left: 67mm; top:' + topDesBlank + 'mm; width:60mm; text-align: left;';
            conOutput.readCon = 'A PART OF '+ReadNumberToWords.convert(con.Container_Quantity__c.setScale(2, System.RoundingMode.HALF_UP)) + ' ('  + con.Container_Quantity__c + ')X' + con.Container_Type__c + ' CONTAINER(S)' ; 
            if (count > 0) {
                read += ' AND ' + ReadNumberToWords.convert(con.Container_Quantity__c.setScale(2, System.RoundingMode.HALF_UP)) + ' ('  + con.Container_Quantity__c + ')X' + con.Container_Type__c;
            } else {
                read += ReadNumberToWords.convert(con.Container_Quantity__c.setScale(2, System.RoundingMode.HALF_UP)) + ' ('  + con.Container_Quantity__c + ')X' + con.Container_Type__c;
            }
            conOutput.top = top;
            conOutput.topBlank = topBlank;
            conOutput.quantity = con.Cargo_Quantity__c != null?con.Cargo_Quantity__c:0;
            conOutput.grossWeight = con.Gross_Weight_Kg__c != null?con.Gross_Weight_Kg__c:0;
            conOutput.measurement = con.Measurement_CBM__c != null?con.Measurement_CBM__c:0;
            totalQuantity += conOutput.quantity;
            totalGrossWeight += conOutput.grossWeight;
            totalMeasurement += conOutput.measurement;
            count ++;
            topDes += 4;
            top += 4;
            topDesBlank += 4;
            topBlank += 4;
            lstConOutput.add(conOutput);
        }
        if (lstCon.size() == 0){
            topDes += 4;
            topDesBlank += 4;
        }
        finalTop = top;
        finalTopBlank = topBlank;
        readCon = 'A PART OF '+ read + ' CONTAINER(S)';
        readConFull = read + ' CONTAINER(S)';
        typeMarks = 'position:absolute; left: 11mm; top:' + (top+4) + 'mm; width:65mm; text-align: left';
        typeDescrip = 'position:absolute; left: 81mm; top:' + topDes + 'mm; width:60mm; text-align: left;';
        typeMarksBlank = 'position:absolute; left: 15mm; top:' + (topBlank+4) + 'mm; width:65mm; text-align: left';
        typeDescripBlank = 'position:absolute; left: 67mm; top:' + topDesBlank + 'mm; width:60mm; text-align: left;';

        if(shipment.CargoUnit__c != null && totalQuantity == 1){
            cargoUnit = shipment.CargoUnit__c;
        }
        if(shipment.CargoUnit__c != null && totalQuantity > 1){
            cargoUnit = shipment.CargoUnit__c + 'S';
        }
        if(shipment.CargoUnit__c == null){
            cargoUnit = '';
        }
        
    }

    public FTMSSO__c getData(String id){
        List<FTMSSO__c> shipments = [SELECT 
        Id,
        ShipperDetailInformation_text__c,
        HBLNumber__c,
        ConsigneeDetailInformation_text__c,
        HouseNotifyDetailInformation_text__c,
        PlaceofReceiptDetailInformation__c,
        POLAODsDetailInformation__c,
        PODAOAsDetailInformation__c,
        VesselFlight__c ,
        Voyage__c,
        PlaceofDeliveryDetailInformation__c,
        NumberofOriginalHBLIssued__c,
        CargoType__c,
        CargoQuantity__c,
        DescriptionofGoods__c,
        GrossWeight__c,
        Measurement__c,
        MarksNumbersAttachment__c,
        CargoUnit__c,
        PlaceofHouseBLIssued__c,
        DateofHouseBLIssued__c,
        MeasurementTotalCBM__c,
        HouseFreightCollectPrepaid__c,
        AgentDetailInformation_text__c,
        Date_of_issue__c,
        DeliveryPartysDetails_text__c,
        HBLType__c,
        Precarriagevoyage__c,
        MasterShippersDetailInformation__c,
        MasterNotifyPartysDetailInformation__c,
        MasterConsigneesDetailInformation__c
         FROM FTMSSO__c WHERE Id = :id];

        shipments.get(0).CargoQuantity__c = shipments.get(0).CargoQuantity__c == null?0:shipments.get(0).CargoQuantity__c;

        return shipments.size() > 0 ? shipments.get(0) : null;
    }

    public List<CntrinTrans__c> getDataCon(String shipId){
        List<CntrinTrans__c> cntrs = [SELECT 
        Id,
        Container_Number__c,
        Container_Type__c,
        Seal_Number__c,
        Container_Quantity__c,
        Cargo_Quantity__c,
        Gross_Weight_Kg__c,
        Measurement_CBM__c,
        Cargo_Unit__c
        FROM CntrinTrans__c WHERE F_TMS_S_O__c = :shipId];

        return cntrs.size() > 0 ? cntrs : new List<CntrinTrans__c>();
    }
    @AuraEnabled
    public static String checkTypeHBL(String recordId){       
        FTMSSO__c item = new FTMSSO__c();
        String strSelect ='SELECT Id,Shipment_Type__c';
        String strFrom = ' FROM FTMSSO__c ';
        String strWhere = 'WHERE Id = \'' + recordId + '\'' ;
        String strOrderBy = ' ORDER BY Name LIMIT 1';
        String data = strSelect + strFrom + strWhere + strOrderBy;
        item = Database.query(data);
        if (item.Shipment_Type__c == 'FCL'){
            return 'FCL';
        } else {
            return 'LCL';
        }   
    }
    @AuraEnabled
    public static void generateAttachmentFile(String recordId,Boolean requiredAttachmentCreation, String type, String backGround){
        PageReference pdf_file =Page.page_PrintHBLFull;
        if(type == 'fcl' && backGround == 'true'){
             pdf_file =Page.page_PrintHBLFull;
        }
        if(type == 'fcl' && backGround == 'false'){
             pdf_file =Page.page_PrintHBLFullBlank;
        }
        if(type == 'lcl' && backGround == 'true'){
             pdf_file =Page.page_PrintHBL;
        }
        if(type == 'lcl' && backGround == 'false'){
             pdf_file =Page.page_PrintHBLBlank;
        }
        
        pdf_file.getParameters().put('Id', recordId);
        pdf_file.getParameters().put('requiredAttachmentCreation', 'false');
        
        FTMSSO__c item = new FTMSSO__c();
        String strSelect ='SELECT Id,ShipperDetailInformation_text__c,HBLNumber__c,ConsigneeDetailInformation_text__c,HouseNotifyDetailInformation_text__c,PlaceofReceiptDetailInformation__c,POLAODsDetailInformation__c,PODAOAsDetailInformation__c,VesselFlight__c ,Voyage__c,PlaceofDeliveryDetailInformation__c,NumberofOriginalHBLIssued__c,CargoType__c,CargoQuantity__c,DescriptionofGoods__c,GrossWeight__c,Measurement__c,MarksNumbersAttachment__c,CargoUnit__c,PlaceofHouseBLIssued__c,DateofHouseBLIssued__c,MeasurementTotalCBM__c,HouseFreightCollectPrepaid__c,AgentDetailInformation_text__c,Date_of_issue__c,DeliveryPartysDetails_text__c,HBLType__c';
        String strFrom = ' FROM FTMSSO__c ';
        String strWhere = 'WHERE Id = \'' + recordId + '\'' ;
        String strOrderBy = ' ORDER BY Name LIMIT 1';
        String data = strSelect + strFrom + strWhere + strOrderBy;
        item = Database.query(data);
        String namefile ='HBL_v' ;

       
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
                body = pdf_file.getContentAsPDF();
                System.debug('debuggg Thong :'+body);
                attach.Body = body;
                FlsService.doInsert(attach);
            }
        }   
    }

    public class WrapperCon {
        public String conNo {get; set;}
        public String conType {get; set;}
        public String sealNo {get; set;}
        public String type {get; set;}
        public String typeBlank {get; set;}
        public String typeReadCon {get; set;}
        public String typeReadConBlank {get; set;}
        public Decimal quantity {get; set;}
        public Decimal grossWeight {get; set;}
        public Decimal measurement {get; set;}
        public String readCon {get; set;}
        public String unit {get; set;}
        public Integer top {get; set;}
        public Integer topBlank {get; set;}
        public WrapperCon() {
            conNo = '';
            conType = '';
            sealNo = '';
            type = '';
            typeBlank = '';
            typeReadCon = '';
            typeReadConBlank = '';
            readCon = '';
            unit = '';
            quantity = 0;
            grossWeight = 0;
            measurement = 0;
        } 
    }
}