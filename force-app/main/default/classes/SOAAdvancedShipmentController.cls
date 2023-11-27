public with sharing class SOAAdvancedShipmentController {
    public List<ReportResult> listReport {get; set;}
    public String message {get; set;}
    public String branch {get; set;}
    public String sFromDate {get; set;}
    public String sToDate {get; set;}
    public Date fromDate {get; set;}
    public Date toDate {get; set;}
    public String period {get; set;}
    public Boolean isDisplayDetail {get; set;}
    public Boolean displayReportTable {get; set;}
    public String recordType {get; set;}
    public String TypeOfTrade {get; set;}
    public String TransportationWay {get; set;}
    public String ShipmentTerm {get; set;}
    public String recordTypeAdvanceShip {get; set;}
    public String recordTypeShip {get; set;}

    // pass param
    public String salManId {get; set;}
    public String salSupId {get; set;}
    public List<String> listIDsSelected {get; set;}

    private static Set<String> selectFieldsAdvanSO = new Set<String>();
    private static Set<String> selectFieldsSO = new Set<String>();

    static {
        selectFieldsAdvanSO.add('Id');
        selectFieldsAdvanSO.add('Name');
        selectFieldsAdvanSO.add('Branch1__c');   
        selectFieldsAdvanSO.add('Master_Record_Type__c');
        selectFieldsAdvanSO.add('JobRequestID__c');
        selectFieldsAdvanSO.add('FileNo__c');
        selectFieldsAdvanSO.add('MAgent__c');   
        selectFieldsAdvanSO.add('MAgent__r.Name');
        selectFieldsAdvanSO.add('MShipper__c');   
        selectFieldsAdvanSO.add('MShipper__r.Name');
        selectFieldsAdvanSO.add('MConsignee__c');   
        selectFieldsAdvanSO.add('MConsignee__r.Name');
        selectFieldsAdvanSO.add('MBLorMAWBNumber__c');
        selectFieldsAdvanSO.add('PlaceofDelivery__c');   
        selectFieldsAdvanSO.add('PlaceofDelivery__r.Name');
        selectFieldsAdvanSO.add('CreatedDate'); 
        selectFieldsAdvanSO.add('ETD__c'); 
        selectFieldsAdvanSO.add('ETA__c');   
        selectFieldsAdvanSO.add('Shipment_Type__c');
        selectFieldsAdvanSO.add('Container_Qnty_1__c');
        selectFieldsAdvanSO.add('Container_Type_1__c');
        selectFieldsAdvanSO.add('ConsealReportOnly__c');
        selectFieldsAdvanSO.add('Number_of_House_BL__c');
        selectFieldsAdvanSO.add('MPOL__r.Name');
        selectFieldsAdvanSO.add('MPOD__r.Name');  
        selectFieldsAdvanSO.add('GrossWeight__c');
        selectFieldsAdvanSO.add('MeasurementCBM__c');
        selectFieldsAdvanSO.add('Description_of_Goods__c');
        selectFieldsAdvanSO.add('Customer__r.Name');
        // selectFieldsAdvanSO.add('TotalAmountofSellingLocal__c');
        // selectFieldsAdvanSO.add('TotalAmountofBuyingLocal__c');
        // selectFieldsAdvanSO.add('Salesman__r.Name');
        // selectFieldsAdvanSO.add('SalesSupport__r.Name');
    }

    static {
        selectFieldsSO.add('Id');
        selectFieldsSO.add('Name');
        selectFieldsSO.add('Branch1__c');
        selectFieldsSO.add('RecordType.Name');
        selectFieldsSO.add('JobRequestID__c');  
        selectFieldsSO.add('Agent__c');
        selectFieldsSO.add('Agent__r.Name');
        selectFieldsSO.add('Shipper__c');
        selectFieldsSO.add('Shipper__r.Name');
        selectFieldsSO.add('Consignee__c');
        selectFieldsSO.add('Consignee__r.Name');
        selectFieldsSO.add('HBLNumber__c');
        selectFieldsSO.add('HAWBNumber__c');
        selectFieldsSO.add('TransportationWay__c');
        selectFieldsSO.add('PlaceofDelivery__c'); 
        selectFieldsSO.add('PlaceofDelivery__r.Name');
        selectFieldsSO.add('CreatedDate');
        selectFieldsSO.add('ETD__c');
        selectFieldsSO.add('ETA__c');
        selectFieldsSO.add('Shipment_Type__c');
        selectFieldsSO.add('ContainerQuantity1__c');
        selectFieldsSO.add('ContainerType1__c');
        selectFieldsSO.add('ConsealReportOnly__c');  
        selectFieldsSO.add('POLAOD__r.Name');  
        selectFieldsSO.add('PODAOA__r.Name');  
        selectFieldsSO.add('GrossWeight__c');  
        selectFieldsSO.add('MeasurementTotalCBM__c');  
        selectFieldsSO.add('DescriptionofGoods__c');  
        // selectFieldsSO.add('TotalAmountofSellingLocal__c');
        // selectFieldsSO.add('TotalAmountofBuyingLocal__c');
        selectFieldsSO.add('ProfitNICTaxLocal__c');
        // selectFieldsSO.add('Salesman__r.Name');
        // selectFieldsSO.add('Sales_Support__r.Name');
    }
    public SOAAdvancedShipmentController() {
        
        reset();
        branch = ApexPages.currentPage().getParameters().get('branch');
        if(!String.isBlank(branch)){
            salManId = ApexPages.currentPage().getParameters().get('salManId');
            salSupId = ApexPages.currentPage().getParameters().get('salSupId');
            sFromDate = ApexPages.currentPage().getParameters().get('fromDate');
            sToDate = ApexPages.currentPage().getParameters().get('toDate');
            recordType = ApexPages.currentPage().getParameters().get('recordType');
            TypeOfTrade = ApexPages.currentPage().getParameters().get('TypeOfTrade');
            TransportationWay = ApexPages.currentPage().getParameters().get('TransportationWay');
            ShipmentTerm = ApexPages.currentPage().getParameters().get('ShipmentTerm');
            System.debug('branch:' + branch);
            System.debug('salManId:' + salManId);
            System.debug('salSupId:' + salSupId);
            System.debug('sFromDate:' + sFromDate);
            System.debug('sToDate:' + sToDate);
            System.debug('recordType:' + recordType);
            System.debug('TypeOfTrade:' + TypeOfTrade);
            System.debug('TransportationWay:' + TransportationWay);
            System.debug('ShipmentTerm:' + ShipmentTerm);
            String listIds = ApexPages.currentPage().getParameters().get('ankenIds');
            if(!String.isBlank(listIds)){
                isDisplayDetail = true;
                listIDsSelected = listIds.split(',');
            }
            listReport = new List<ReportResult>();
            onChangeDateFrom();
            onChangeDateTo();
            generateReport();
        }
    }

    public List<SelectOption> getCustomers(){
        List<SelectOption> listAcc = new List<SelectOption>();
        // List<Profile> lstProfile= [SELECT Id,Name FROM Profile WHERE Name IN ('ASAP - BOD','System Administrator') AND Id =: UserInfo.getProfileId()];
        List<Account> lstAccount = [SELECT Id,Active__c,Name FROM Account WHERE Active__c = true AND RecordTypeId = '0128d0000006EtAAAU' ORDER BY Name];
        if (lstAccount.size() > 0) {
            listAcc.add(new SelectOption('all', 'ALL'));
            for (Account acc : lstAccount) {
                listAcc.add(new SelectOption(acc.Id, acc.Name));
            }
        } else {
            listAcc.add(new SelectOption('all', '-- None --'));
            // listAcc.add(new SelectOption(UserInfo.getUserId(), UserInfo.getName()));
        }
        return listAcc;
    }

    public List<SelectOption> getBranchs(){
        List<SelectOption> listBrachs = new List<SelectOption>();
        listBrachs.add(new SelectOption('all', 'ALL'));
        // listBrachs.add(new SelectOption('Ha Noi', 'Hà Nội'));
        listBrachs.add(new SelectOption('Hải Phòng', 'Hải Phòng'));
        listBrachs.add(new SelectOption('Hồ Chí Minh', 'Hồ Chí Minh'));
        listBrachs.add(new SelectOption('Cambodia', 'Cambodia'));
        listBrachs.add(new SelectOption('Đà Nẵng', 'Đà Nẵng'));
        listBrachs.add(new SelectOption('Taiwan', 'Taiwan'));

        return listBrachs;
    }

    public List<SelectOption> getRecordTypes(){
        List<SelectOption> listRecordTypes = new List<SelectOption>();

        listRecordTypes.add(new SelectOption('all', 'ALL'));
        listRecordTypes.add(new SelectOption('DOMESTIC', 'DOMESTIC'));
        listRecordTypes.add(new SelectOption('IMPORT', 'IMPORT'));
        listRecordTypes.add(new SelectOption('EXPORT', 'EXPORT'));
        listRecordTypes.add(new SelectOption('ENTREPOT', 'ENTREPOT'));
        listRecordTypes.add(new SelectOption('THIRD COUNTRY', 'THIRD COUNTRY'));
        return listRecordTypes;
    }
    public List<SelectOption> getTypeOfTrades(){
        List<SelectOption> listTypeOfTrades = new List<SelectOption>();

        listTypeOfTrades.add(new SelectOption('all', 'ALL'));
        listTypeOfTrades.add(new SelectOption('DOMESTIC', 'DOMESTIC'));
        listTypeOfTrades.add(new SelectOption('IMPORT', 'IMPORT'));
        listTypeOfTrades.add(new SelectOption('EXPORT', 'EXPORT'));
        listTypeOfTrades.add(new SelectOption('ENTREPOT', 'ENTREPOT'));
        listTypeOfTrades.add(new SelectOption('THIRD COUNTRY', 'THIRD COUNTRY'));
        return listTypeOfTrades;
    }
    public List<SelectOption> getTransportationWays(){
        List<SelectOption> listTransportationWays = new List<SelectOption>();

        listTransportationWays.add(new SelectOption('all', 'ALL'));
        listTransportationWays.add(new SelectOption('SEA', 'SEA'));
        listTransportationWays.add(new SelectOption('AIR', 'AIR'));
        listTransportationWays.add(new SelectOption('TRUCKING', 'TRUCKING'));
        listTransportationWays.add(new SelectOption('RAIL', 'RAIL'));
        listTransportationWays.add(new SelectOption('INLAND WATERWAY', 'INLAND WATERWAY'));
        listTransportationWays.add(new SelectOption('MULTIMODAL', 'MULTIMODAL'));
        return listTransportationWays;
    }
    public List<SelectOption> getShipmentTerms(){
        List<SelectOption> listShipmentTerm = new List<SelectOption>();

        listShipmentTerm.add(new SelectOption('all', 'ALL'));
        listShipmentTerm.add(new SelectOption('FCL', 'FCL'));
        listShipmentTerm.add(new SelectOption('LCL', 'LCL'));
        listShipmentTerm.add(new SelectOption('CONSOL', 'CONSOL'));
        listShipmentTerm.add(new SelectOption('CHARTER', 'CHARTER'));
        return listShipmentTerm;
    }
    

    public void generateReport(){
        System.debug('run function');
        listReport = new List<ReportResult>();
        displayReportTable = true;
        onChangeDateFrom();
        onChangeDateTo();
        
        Map<String,ReportResult> mapReport = new Map<String, ReportResult>();
        Set<String> setIdReport = new Set<String>();
        // get list advanced shipment
        String strQueryAdvanShip = getAdvancedShipments(salManId,salSupId);
        System.debug('strQueryAdvanShip :'+strQueryAdvanShip);
        List<AdvancedShipment__c> lstAdvanSO = new List<AdvancedShipment__c>();
        try {
            lstAdvanSO = Database.query(strQueryAdvanShip);
        } catch (Exception e) {
            System.debug('have error');
        }

        for (AdvancedShipment__c adShip : lstAdvanSO) {
            ReportResult repo = new ReportResult(adShip);
            for (FTMSSO__c ship : adShip.F_TMS_S_O__r) {
                ReportItemResult item = new ReportItemResult(ship);
                // repo.totalSelling += item.totalSelling;
                // repo.totalBuying += item.totalBuying;
                // repo.totalAmount = repo.totalSelling - repo.totalBuying;
                repo.lstItem.add(item);
            }
            listReport.add(repo);
        }

        // get list shipment
        String strQueryShip = getShipments(salManId,salSupId);
        System.debug('strQueryShip :'+strQueryShip);
        List<FTMSSO__c> lstSO = new List<FTMSSO__c>();
        try {
            lstSO = Database.query(strQueryShip);
        } catch (Exception e) {
            System.debug('have error');
        }
        for (FTMSSO__c ship : lstSO) {
            ReportResult repo = new ReportResult(ship);
            listReport.add(repo);
        }
    }

    private void reset(){
        isDisplayDetail = false;
        listIDsSelected = new List<String>();
        listReport = new List<ReportResult>();
        message = '';
        DateTime dateFrom = DateTime.newInstance(System.today().year(),System.today().month(),1);
        DateTime dateTo = DateTime.newInstance(System.today().year(),System.today().month(),1).addMonths(1).addDays(-1);
        sFromDate = dateFrom.format('dd/MM/yyyy');
        sToDate = dateTo.format('dd/MM/yyyy');
        branch = '';
        period = '';
        salManId = '';
        salSupId = '';
        recordType = '';
        TypeOfTrade = '';
        TransportationWay = '';
        ShipmentTerm = '';
        //      
        fromDate = null;
        toDate = null;
    }

    private String getAdvancedShipments(String saleManId, String saleSupportId){
        //add where advancedshipment and shipmentString
        String whereStr = '';
        String whereStrShip = '';
        String filter = '';
        String filterShip = '';
        if (fromDate != null && toDate != null) {
            if (fromDate <= toDate) {
                filter = ' AND (AccountedDate__c >= ' + String.valueOf(fromDate) + ' AND AccountedDate__c <= ' + String.valueOf(toDate) + ')';
                filterShip = ' AND (AccountedDate__c >= ' + String.valueOf(fromDate) + ' AND AccountedDate__c <= ' + String.valueOf(toDate) + ')';
            }
            period = 'TỪ ' + sFromDate + ' ĐẾN ' + sToDate;
        } else if (fromDate != null && toDate == null) {
            filter = ' AND AccountedDate__c >= ' + String.valueOf(fromDate);
            filterShip = ' AND AccountedDate__c >= ' + String.valueOf(fromDate);
            period = 'ĐẾN ' + sFromDate;
        } else if (fromDate == null && toDate != null) {
            filter = ' AND AccountedDate__c <= ' + String.valueOf(toDate);
            filterShip = ' AND AccountedDate__c <= ' + String.valueOf(toDate);
            period = 'TỪ ' + sToDate;
        }
        whereStr += filter;
        whereStrShip += filterShip;
        if(saleManId != 'all'){
            whereStr += ' AND Customer__c =\'' + String.escapeSingleQuotes(saleManId) + '\' ';
            whereStrShip += ' AND Customer__c	 =\'' + String.escapeSingleQuotes(saleManId) + '\' ';
        }
        // if(saleSupportId != 'all'){
        //     whereStr += ' AND SalesSupport__c =\'' + String.escapeSingleQuotes(saleSupportId) + '\' ';
        //     whereStrShip += ' AND Sales_Support__c	 =\'' + String.escapeSingleQuotes(saleSupportId) + '\' ';
        // }
        if (branch != 'all') {
            whereStr += ' AND Branch1__c =\'' + String.escapeSingleQuotes(branch) + '\' ';
            whereStrShip += ' AND Branch1__c	 =\'' + String.escapeSingleQuotes(branch) + '\' ';
        }
        // if (recordType != 'all') {
        //     if (recordType == 'oceEx') {
        //         recordTypeAdvanceShip = 'Ocean Export';
        //         recordTypeShip = [SELECT DeveloperName,Id,Name,SobjectType FROM RecordType WHERE SobjectType = 'FTMSSO__c' AND DeveloperName = 'OceanExport'].Id;
        //     } else if (recordType == 'oceIm') {
        //         recordTypeAdvanceShip = 'Ocean Import';
        //         recordTypeShip = [SELECT DeveloperName,Id,Name,SobjectType FROM RecordType WHERE SobjectType = 'FTMSSO__c' AND DeveloperName = 'OceanImport'].Id;
        //     } else if (recordType == 'airEx') {
        //         recordTypeAdvanceShip = 'Air Export';
        //         recordTypeShip = [SELECT DeveloperName,Id,Name,SobjectType FROM RecordType WHERE SobjectType = 'FTMSSO__c' AND DeveloperName = 'AirExport'].Id;
        //     } else if (recordType == 'airIm') {
        //         recordTypeAdvanceShip = 'Air Import';
        //         recordTypeShip = [SELECT DeveloperName,Id,Name,SobjectType FROM RecordType WHERE SobjectType = 'FTMSSO__c' AND DeveloperName = 'AirImport'].Id;
        //     }
        if(TypeOfTrade != 'all'){
            whereStr += ' AND TypeofTrade__c =\'' + String.escapeSingleQuotes(TypeOfTrade) + '\' ';
            whereStrShip += ' AND TypeofTrade__c =\'' + String.escapeSingleQuotes(TypeOfTrade) + '\' ';
        }
        if(TransportationWay != 'all'){
            whereStr += ' AND TransportationWay__c =\'' + String.escapeSingleQuotes(TransportationWay) + '\' ';
            whereStrShip += ' AND TransportationWay__c =\'' + String.escapeSingleQuotes(TransportationWay) + '\' ';
        }
        if(ShipmentTerm != 'all'){
            whereStr += ' AND ShipmentTerm__c =\'' + String.escapeSingleQuotes(ShipmentTerm) + '\' ';
            whereStrShip += ' AND ShipmentTerm__c =\'' + String.escapeSingleQuotes(ShipmentTerm) + '\' ';
        }
            // whereStr += ' AND Master_Record_Type__c =\'' + String.escapeSingleQuotes(recordTypeAdvanceShip) + '\' ';
            // whereStrShip += ' AND RecordTypeId =\'' + String.escapeSingleQuotes(recordTypeShip) + '\' ';
        // }
        if(listIDsSelected.size() > 0){
            whereStr += ' AND Id IN : listIDsSelected';
        }
        whereStr = whereStr.replaceFirst('AND', 'WHERE');
        whereStrShip = whereStrShip.replaceFirst('AND', 'WHERE');

        // Select
        // String selectStrShip = ' (SELECT '+ String.join(new List<String>(selectFieldsSO), ',') +' FROM F_TMS_S_O__r ' + whereStrShip + ' ) ';
        String selectStrShip = ' (SELECT '+ String.join(new List<String>(selectFieldsSO), ',') +' FROM F_TMS_S_O__r ) ';
        String selectStr = 'SELECT ' + String.join(new List<String>(selectFieldsAdvanSO), ',') +', ' + selectStrShip;
        String fromStr = ' FROM AdvancedShipment__c ' + whereStr;
        // String whereStr = '';
        // String whereStrShip = '';
        // String filter = '';
        // String filterShip = '';
        // if (fromDate != null && toDate != null) {
        //     if (fromDate <= toDate) {
        //         filter = ' AND (AccountedDate__c >= ' + String.valueOf(fromDate) + ' AND AccountedDate__c <= ' + String.valueOf(toDate) + ')';
        //         filterShip = ' AND (AccountedDate__c >= ' + String.valueOf(fromDate) + ' AND AccountedDate__c <= ' + String.valueOf(toDate) + ')';
        //     }
        //     period = 'From ' + fromDate + ' To ' + toDate;
        // } else if (fromDate != null && toDate == null) {
        //     filter = ' AND AccountedDate__c >= ' + String.valueOf(fromDate);
        //     filterShip = ' AND AccountedDate__c >= ' + String.valueOf(fromDate);
        //     period = 'From ' + fromDate;
        // } else if (fromDate == null && toDate != null) {
        //     filter = ' AND AccountedDate__c <= ' + String.valueOf(toDate);
        //     filterShip = ' AND AccountedDate__c <= ' + String.valueOf(toDate);
        //     period = 'To ' + toDate;
        // }
        // whereStr += filter;
        // whereStrShip += filterShip;
        // if(!String.isBlank(saleManId)){
        //     whereStr += ' AND Salesman__c =\'' + String.escapeSingleQuotes(saleManId) + '\' ';
        //     whereStrShip += ' AND Salesman__c	 =\'' + String.escapeSingleQuotes(saleManId) + '\' ';
        // }else{
            
        // }
        // if(!String.isBlank(saleSupportId)){
        //     whereStr += ' AND SalesSupport__c =\'' + String.escapeSingleQuotes(saleSupportId) + '\' ';
        //     whereStrShip += ' AND Sales_Support__c	 =\'' + String.escapeSingleQuotes(saleSupportId) + '\' ';
        // }else{
            
        // }
        // if(ankenIdList.size() > 0){
        //     whereStr += ' AND Id IN : listIDsSelected';
        // }
        // whereStr = whereStr.replaceFirst('AND', 'WHERE');
        // whereStrShip = whereStrShip.replaceFirst('AND', 'WHERE');
        System.debug('whereStr : ' + whereStr);
        System.debug('whereStrShip : ' + whereStrShip);
        System.debug('resul:' +selectStr + fromStr + whereStr + ' ORDER BY FileNo__c,Name  LIMIT 10000');

        return selectStr + fromStr + ' ORDER BY FileNo__c,Name  LIMIT 10000';
    }

    private String getShipments(String saleManId, String saleSupportId){
        //add where advancedshipment and shipment
        String whereStrShip = ' AND ConsolidationID__c = null';
        String filterShip = '';
        if (fromDate != null && toDate != null) {
            if (fromDate <= toDate) {
                filterShip = ' AND (AccountedDate__c >= ' + String.valueOf(fromDate) + ' AND AccountedDate__c <= ' + String.valueOf(toDate) + ')';
            }
            period = 'TỪ ' + sFromDate + ' ĐẾN ' + sToDate;
        } else if (fromDate != null && toDate == null) {
            filterShip = ' AND AccountedDate__c >= ' + String.valueOf(fromDate);
            period = 'TỪ ' + sFromDate;
        } else if (fromDate == null && toDate != null) {
            filterShip = ' AND AccountedDate__c <= ' + String.valueOf(toDate);
            period = ' ĐẾN ' + sToDate;
        }
        whereStrShip += filterShip;
        if(saleManId != 'all'){
            whereStrShip += ' AND Customer__c	 =\'' + String.escapeSingleQuotes(saleManId) + '\' ';
        }
        // if(saleSupportId != 'all'){
        //     whereStrShip += ' AND Sales_Support__c	 =\'' + String.escapeSingleQuotes(saleSupportId) + '\' ';
        // }
        if (branch != 'all') {
            whereStrShip += ' AND Branch1__c	 =\'' + String.escapeSingleQuotes(branch) + '\' ';
        }
        // if (recordType != 'all') {
        //     if (recordType == 'oceEx') {
        //         recordTypeShip = [SELECT DeveloperName,Id,Name,SobjectType FROM RecordType WHERE SobjectType = 'FTMSSO__c' AND DeveloperName = 'OceanExport'].Id;
        //     } else if (recordType == 'oceIm') {
        //         recordTypeShip = [SELECT DeveloperName,Id,Name,SobjectType FROM RecordType WHERE SobjectType = 'FTMSSO__c' AND DeveloperName = 'OceanImport'].Id;
        //     } else if (recordType == 'airEx') {
        //         recordTypeShip = [SELECT DeveloperName,Id,Name,SobjectType FROM RecordType WHERE SobjectType = 'FTMSSO__c' AND DeveloperName = 'AirExport'].Id;
        //     } else if (recordType == 'airIm') {
        //         recordTypeShip = [SELECT DeveloperName,Id,Name,SobjectType FROM RecordType WHERE SobjectType = 'FTMSSO__c' AND DeveloperName = 'AirImport'].Id;
        //     }
        //     whereStrShip += ' AND RecordTypeId =\'' + String.escapeSingleQuotes(recordTypeShip) + '\' ';
        // }
        if(TypeOfTrade != 'all'){
            // whereStr += ' AND TypeofTrade__c =\'' + String.escapeSingleQuotes(TypeOfTrade) + '\' ';
            whereStrShip += ' AND TypeofTrade__c =\'' + String.escapeSingleQuotes(TypeOfTrade) + '\' ';
        }
        if(TransportationWay != 'all'){
            // whereStr += ' AND TransportationWay__c =\'' + String.escapeSingleQuotes(TransportationWay) + '\' ';
            whereStrShip += ' AND TransportationWay__c =\'' + String.escapeSingleQuotes(TransportationWay) + '\' ';
        }
        if(ShipmentTerm != 'all'){
            // whereStr += ' AND ShipmentTerm__c =\'' + String.escapeSingleQuotes(ShipmentTerm) + '\' ';
            whereStrShip += ' AND ShipmentTerm__c =\'' + String.escapeSingleQuotes(ShipmentTerm) + '\' ';
        }
        if(listIDsSelected.size() > 0){
            whereStrShip += ' AND Id IN : listIDsSelected';
        }
        whereStrShip = whereStrShip.replaceFirst('AND', 'WHERE');

        // Select
        String selectStr = 'SELECT ' + String.join(new List<String>(selectFieldsSO), ',');
        String fromStr = ' FROM FTMSSO__c ' + whereStrShip;
        System.debug('whereStrShip : ' + whereStrShip);

        return selectStr + fromStr + ' ORDER BY JobRequestID__c,Name  LIMIT 10000';
    }

    public void onChangeDateFrom(){
        if(!String.isBlank(sFromDate)){
            fromDate = DateTimeUtils.parseDateddmmyyyy(sFromDate, '/');
        }
        else{
            fromDate = null;
        }
        System.debug('fromDate :'+fromDate);
        //accountList = getAccountList();

    }
    public void onChangeDateTo(){
        if(!String.isBlank(sToDate)){
            toDate = DateTimeUtils.parseDateddmmyyyy(sToDate, '/');
        }
        else{
            toDate = null;
        }
        System.debug('toDate :'+toDate);
        //accountList = getAccountList();
    }

    public class ReportItemResult {
        public String id {get; set;}
        public String name {get; set;}
        public String branch {get; set;}
        public String department {get; set;}
        public String fileNo {get; set;}
        public String agent {get; set;}
        public String shipper {get; set;}
        public String consignee {get; set;}
        public String mbl {get; set;}
        public String delivery {get; set;}
        public Date createDate {get; set;}
        public Date eTD {get; set;}
        public Date eTA {get; set;}
        public String shipmentType {get; set;}
        public Decimal contQuan {get; set;}
        public String contType {get; set;}
        public String conSeal {get; set;}
        public Decimal totalSelling {get; set;}
        public Decimal totalBuying {get; set;}
        public Decimal totalAmount {get; set;}
        public String salesMan {get; set;}
        public String salesSupport {get; set;}
        public String POLAOD {get;set;}
        public String PODAOA {get;set;}
        public Decimal GrossWeight {get;set;}
        public Decimal MeasurementCBM {get;set;}
        public String description  {get;set;}


        public ReportItemResult () {
            id = '';
            name = '';
            branch = '';
            department = '';
            fileNo = '';
            agent = '';
            shipper = '';
            consignee = '';
            mbl = '';
            delivery = '';
            createDate = null;
            eTD = null;
            eTA = null;
            shipmentType = '';
            contQuan = 0;
            contType = '';
            conSeal = '';
            totalSelling = 0;
            totalBuying = 0;
            totalAmount = 0;
            salesMan = '';
            salesSupport ='';
            POLAOD = '';
            PODAOA = '';
            GrossWeight = 0; 
            MeasurementCBM = 0;
            description  =  '';
        }
        public ReportItemResult (FTMSSO__c so) {
            id = so.Id;
            name = so.Name;
            branch = so.Branch1__c != null? so.Branch1__c : '';
            department = so.RecordType.Name != null? so.RecordType.Name : '';
            fileNo = so.JobRequestID__c !=null? so.JobRequestID__c : '';
            agent = so.Agent__r.Name != null? so.Agent__r.Name : '';
            shipper = so.Shipper__r.Name != null? so.Shipper__r.Name : '';
            consignee = so.Consignee__r.Name != null? so.Consignee__r.Name : '';
            mbl = so.TransportationWay__c != 'Air' ? so.HBLNumber__c : so.HAWBNumber__c;
            delivery = so.PlaceofDelivery__r.Name != null? so.PlaceofDelivery__r.Name : '';
            createDate = Date.valueOf(so.CreatedDate);
            eTD = so.ETD__c != null? so.ETD__c: null;
            eTA = so.ETA__c != null? so.ETA__c: null;
            shipmentType = so.Shipment_Type__c !=null? so.Shipment_Type__c: '';
            contQuan = so.ContainerQuantity1__c !=null? so.ContainerQuantity1__c: 0;
            contType = so.ContainerType1__c !=null? so.ContainerType1__c: '';
            conSeal = so.ConsealReportOnly__c !=null? so.ConsealReportOnly__c: '';
            POLAOD = so.POLAOD__r.Name !=null? so.POLAOD__r.Name: '';
            PODAOA = so.PODAOA__r.Name !=null? so.PODAOA__r.Name: '';
            GrossWeight = so.GrossWeight__c !=null? so.GrossWeight__c: 0;
            MeasurementCBM = so.MeasurementTotalCBM__c !=null? so.MeasurementTotalCBM__c: 0;
            description  = so.DescriptionofGoods__c !=null? so.DescriptionofGoods__c: '';
            // totalSelling = so.TotalAmountofSellingLocal__c !=null? so.TotalAmountofSellingLocal__c: 0;
            // totalBuying = so.TotalAmountofBuyingLocal__c !=null? so.TotalAmountofBuyingLocal__c: 0;
            // totalAmount = so.ProfitNICTaxLocal__c !=null? so.ProfitNICTaxLocal__c: 0;
            // salesMan = so.Salesman__r.Name !=null? so.Salesman__r.Name: '';
            // salesSupport = so.Sales_Support__r.Name !=null? so.Sales_Support__r.Name: '';
        }
    }
    public class ReportResult {
        public String id {get; set;}
        public String name {get; set;}
        public String branch {get; set;}
        public String department {get; set;}
        public String fileNo {get; set;}
        public String agent {get; set;}
        public String shipper {get; set;}
        public String consignee {get; set;}
        public String mbl {get; set;}
        public String delivery {get; set;}
        public Date createDate {get; set;}
        public Date eTD {get; set;}
        public Date eTA {get; set;}
        public String shipmentType {get; set;}
        public Decimal contQuan {get; set;}
        public String contType {get; set;}
        public String conSeal {get; set;}
        public Decimal totalSelling {get; set;}
        public Decimal totalBuying {get; set;}
        public Decimal totalAmount {get; set;}
        public String salesMan {get; set;}
        public String salesSupport {get; set;}
        public Decimal NumOfHouseBill {get;set;}
        public String MPOL {get;set;}
        public String MPOD {get;set;}
        public Decimal GrossWeight {get;set;}
        public Decimal MeasurementCBM {get;set;}
        public String description  {get;set;}
        public String customer {get;set;}

        public List<ReportItemResult> lstItem {get; set;}

        public ReportResult() {
            id = '';
            name = '';
            branch = '';
            department = '';
            fileNo = '';
            agent = '';
            shipper = '';
            consignee = '';
            mbl = '';
            delivery = '';
            createDate = null;
            eTD = null;
            eTA = null;
            shipmentType = '';
            contQuan = 0;
            contType = '';
            conSeal = '';
            totalSelling = 0;
            totalBuying = 0;
            totalAmount = 0;
            salesMan = '';
            salesSupport ='';
            NumOfHouseBill = 0;
            MPOL = '';
            MPOD = '';
            GrossWeight = 0;
            MeasurementCBM = 0;
            description = '';
            customer = '';
            lstItem = new List<ReportItemResult>();
        } 

        public ReportResult(AdvancedShipment__c adSo) {
            // id = so.Id;
            // name = so.Name;
            // branch = so.Branch__c != null? so.Branch__c : '';
            // department = so.RecordType.Name != null? so.RecordType.Name : '';
            // fileNo = so.JobRequestID__c !=null? so.JobRequestID__c : '';
            // agent = so.Agent__r.Name != null? so.Agent__r.Name : '';
            // shipper = so.Shipper__r.Name != null? so.Shipper__r.Name : '';
            // consignee = so.Consignee__r.Name != null? so.Consignee__r.Name : '';
            // mbl = so.MBLorMAWBNumber__c != null? so.MBLorMAWBNumber__c : '';
            // delivery = so.PlaceofDelivery__r.Name != null? so.PlaceofDelivery__r.Name : '';
            // createDate = Date.valueOf(so.CreatedDate);
            // eTD = so.ETD__c != null? so.ETD__c: null;
            // eTA = so.ETA__c != null? so.ETA__c: null;
            // shipmentType = so.Shipment_Type__c !=null? so.Shipment_Type__c: '';
            // contQuan = so.ContainerQuantity1__c !=null? so.ContainerQuantity1__c: '';
            // contType = so.ContainerType1__c !=null? so.ContainerType1__c: '';
            // conSeal = so.ConsealReportOnly__c !=null? so.ConsealReportOnly__c: '';
            // totalSelling = so.TotalAmountofSellingLocal__c !=null? so.TotalAmountofSellingLocal__c: 0;
            // totalBuying = so.TotalAmountofBuyingLocal__c !=null? so.TotalAmountofBuyingLocal__c: 0;
            // totalAmount = so.ProfitNICTaxLocal__c !=null? so.ProfitNICTaxLocal__c: 0;
            // salesMan = so.Salesman__r.Name !=null? so.Salesman__r.Name: '';
            // salesSupport = so.Sales_Support__r.Name !=null? so.Sales_Support__r.Name: '';

            //
            id = adSo.Id;
            name = adSo.Name;
            branch = adSo.Branch1__c != null? adSo.Branch1__c : '';
            NumOfHouseBill = adSo.Number_of_House_BL__c !=null? adSo.Number_of_House_BL__c : 0;
            MPOL = adSo.MPOL__r.Name !=null? adSo.MPOL__r.Name : '';
            MPOD = adSo.MPOD__r.Name !=null? adSo.MPOD__r.Name : '';
            GrossWeight = adSo.GrossWeight__c !=null? adSo.GrossWeight__c : 0;
            MeasurementCBM = adSo.MeasurementCBM__c !=null? adSo.MeasurementCBM__c : 0;
            description = adSo.Description_of_Goods__c !=null? adSo.Description_of_Goods__c : '';
            customer = adSo.Customer__r.Name !=null? adSo.Customer__r.Name : '';
            // department = adSo.Master_Record_Type__c != null? adSo.Master_Record_Type__c : '';
            fileNo = adSo.FileNo__c !=null? adSo.FileNo__c : '';
            agent = adSo.MAgent__r.Name != null? adSo.MAgent__r.Name : '';
            shipper = adSo.MShipper__r.Name != null? adSo.MShipper__r.Name : '';
            consignee = adSo.MConsignee__r.Name != null? adSo.MConsignee__r.Name : '';
            mbl = adSo.MBLorMAWBNumber__c != null? adSo.MBLorMAWBNumber__c : '';
            delivery = adSo.PlaceofDelivery__r.Name != null? adSo.PlaceofDelivery__r.Name : '';
            createDate = Date.valueOf(adSo.CreatedDate);
            eTD = adSo.ETD__c != null? adSo.ETD__c: null;
            eTA = adSo.ETA__c != null? adSo.ETA__c: null;
            shipmentType = adSo.Shipment_Type__c !=null? adSo.Shipment_Type__c: '';
            contQuan = adSo.Container_Qnty_1__c !=null? adSo.Container_Qnty_1__c: 0;
            contType = adSo.Container_Type_1__c !=null? adSo.Container_Type_1__c: '';
            conSeal = adSo.ConsealReportOnly__c !=null? adSo.ConsealReportOnly__c: '';
            // totalSelling = adSo.TotalAmountofSellingLocal__c !=null? adSo.TotalAmountofSellingLocal__c: 0;
            // totalBuying = adSo.TotalAmountofBuyingLocal__c !=null? adSo.TotalAmountofBuyingLocal__c: 0;
            // totalAmount = totalSelling - totalBuying;
            // salesMan = adSo.Salesman__r.Name !=null? adSo.Salesman__r.Name: '';
            // salesSupport = adSo.SalesSupport__r.Name !=null? adSo.SalesSupport__r.Name: '';
            lstItem = new List<ReportItemResult>();   
        }

        public ReportResult(FTMSSO__c so) {
            id = so.Id;
            name = so.Name;
            branch = so.Branch1__c != null? so.Branch1__c : '';
            department = so.RecordType.Name != null? so.RecordType.Name : '';
            fileNo = so.JobRequestID__c !=null? so.JobRequestID__c : '';
            agent = so.Agent__r.Name != null? so.Agent__r.Name : '';
            shipper = so.Shipper__r.Name != null? so.Shipper__r.Name : '';
            consignee = so.Consignee__r.Name != null? so.Consignee__r.Name : '';
            // mbl = so.MBLorMAWBNumber__c != null? so.MBLorMAWBNumber__c : '';
            delivery = so.PlaceofDelivery__r.Name != null? so.PlaceofDelivery__r.Name : '';
            createDate = Date.valueOf(so.CreatedDate);
            eTD = so.ETD__c != null? so.ETD__c: null;
            eTA = so.ETA__c != null? so.ETA__c: null;
            shipmentType = so.Shipment_Type__c !=null? so.Shipment_Type__c: '';
            contQuan = so.ContainerQuantity1__c !=null? so.ContainerQuantity1__c: 0;
            contType = so.ContainerType1__c !=null? so.ContainerType1__c: '';
            conSeal = so.ConsealReportOnly__c !=null? so.ConsealReportOnly__c: '';
            // totalSelling = so.TotalAmountofSellingLocal__c !=null? so.TotalAmountofSellingLocal__c: 0;
            // totalBuying = so.TotalAmountofBuyingLocal__c !=null? so.TotalAmountofBuyingLocal__c: 0;
            // totalAmount = so.ProfitNICTaxLocal__c !=null? so.ProfitNICTaxLocal__c: 0;
            // salesMan = so.Salesman__r.Name !=null? so.Salesman__r.Name: '';
            // salesSupport = so.Sales_Support__r.Name !=null? so.Sales_Support__r.Name: '';
            lstItem = new List<ReportItemResult>();
        }
    }
}