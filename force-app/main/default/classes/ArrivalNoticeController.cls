public with sharing class ArrivalNoticeController {
    public FTMSSO__c shipment {get; set;}
    public List<FTMSBill__c> lstBill {get; set;}
    private String shipId {get; set;}
    public CompanyInformation__c ComInf {get; set;}
    public CompanyInformation__c DOinfo {get; set;}
    public Decimal totalVND {get; set;}
    public Decimal totalUSD {get; set;}
    public Boolean requiredPackage {get;set;}

    private static Set<String> fieldsShipQuery = new Set<String>();
    private static Set<String> fieldsBillQuery = new Set<String>();
    private static Set<String> fieldsComInQuery = new Set<String>();
    private static Set<String> fieldsDOinfoQuery = new Set<String>();
    static{
        fieldsShipQuery.add('Id');
        fieldsShipQuery.add('Name');
        fieldsShipQuery.add('JobRequestID__c');
        fieldsShipQuery.add('ETA__c');
        fieldsShipQuery.add('ConsigneeDetailInformation__c');
        fieldsShipQuery.add('agentnamefor__c');
        fieldsShipQuery.add('VesselFlight__c');
        fieldsShipQuery.add('Warehouse__c');
        fieldsShipQuery.add('HAWBNumber__c');
        fieldsShipQuery.add('MAWBNumber__c');
        fieldsShipQuery.add('CargoQuantity__c');
        fieldsShipQuery.add('CargoUnit__c');
        fieldsShipQuery.add('GrossWeight__c');
        fieldsShipQuery.add('Shippernamefor__c');
        fieldsShipQuery.add('DescriptionofGoods__c');
        fieldsShipQuery.add('Branch__c');
        fieldsShipQuery.add('ChargeableWeight__c');
        fieldsShipQuery.add('ConsigneeDetailInformation_text__c');
        fieldsShipQuery.add('Consignee__c');
        fieldsShipQuery.add('HouseNotifyParty__c');
        fieldsShipQuery.add('HouseNotifyParty__r.Name');
        fieldsShipQuery.add('PackageUnitCode__c');
        fieldsShipQuery.add('BranchpickupDO__c');
        fieldsShipQuery.add('Plural_Cargo_Unit__c');
    }

    static{
        fieldsBillQuery.add('Id');
        fieldsBillQuery.add('Name');
        fieldsBillQuery.add('BillNameatPrintLocal__c');
        fieldsBillQuery.add('BillNameatPrintENG__c');
        fieldsBillQuery.add('TaxRateSelling__c');
        fieldsBillQuery.add('TotalSellingInclTaxFCY__c');
        fieldsBillQuery.add('TotalSellingInclTaxLocal__c');
        fieldsBillQuery.add('CurrencySelling__c');
        fieldsBillQuery.add('InvoiceTo__c');
    }

    static {
        fieldsComInQuery.add('Id');
        fieldsComInQuery.add('Name');
        fieldsComInQuery.add('Address__c');
        fieldsComInQuery.add('Tel__c');
        fieldsComInQuery.add('Fax__c');
        fieldsComInQuery.add('Taxcode__c');
        fieldsComInQuery.add('Branch__c');
        fieldsComInQuery.add('CompanyLogo__c');
        fieldsComInQuery.add('Email__c');
        fieldsComInQuery.add('Website__c');
    }

    static {
        fieldsDOinfoQuery.add('Name');
        fieldsDOinfoQuery.add('Address__c');
        fieldsDOinfoQuery.add('Tel__c');
        fieldsDOinfoQuery.add('Fax__c');
    }
    public ArrivalNoticeController() {
        totalVND = 0;
        totalUSD = 0;
        DOinfo = new CompanyInformation__c();
        shipId = ApexPages.currentPage().getParameters().get('Id');
        requiredPackage = Boolean.valueOf(ApexPages.currentPage().getParameters().get('checkPackage'));
        shipment = getShipment(shipId);
        
        if(shipment.CargoQuantity__c > 1){
            shipment.CargoUnit__c = shipment.CargoUnit__c + 's';
        }

        // String consignee = (shipment.HouseNotifyParty__c == null || shipment.HouseNotifyParty__r.Name == 'SAME AS CONSIGNEE')?shipment.Consignee__c: shipment.HouseNotifyParty__c;
        // lstBill = getListBill(shipId,consignee);
        lstBill = getListBill(shipId,shipment.Consignee__c,shipment.HouseNotifyParty__c);
        ComInf = getComIn(shipment.Branch__c);
        if(shipment.BranchpickupDO__c != null){
            DOinfo = getDOin(shipment.BranchpickupDO__c);
            System.debug('1133: ' + DOinfo);
        }
        
        for (FTMSBill__c bill : lstBill) {
            if (bill.CurrencySelling__c == 'USD'){
                if (bill.TotalSellingInclTaxFCY__c != null) {
                    totalUSD += bill.TotalSellingInclTaxFCY__c;
                }
            }
            
            if (bill.CurrencySelling__c == 'VND'){
                if (bill.TotalSellingInclTaxLocal__c != null) {
                    totalVND += bill.TotalSellingInclTaxLocal__c;
                }
            }
        }

    }

    
    private FTMSSO__c getShipment(String shipId){
        String strSelect = String.join(new List<String>(fieldsShipQuery), ',');
        String strQuery = 'SELECT ' + strSelect 
                    + ' FROM FTMSSO__c'
                    + ' WHERE Id = \'' + String.escapeSingleQuotes(shipId) + '\'';
        FTMSSO__c ship;
        try{
            ship = Database.query(strQuery);
        } catch(QueryException e){
            ship = new FTMSSO__c();
        }
        return ship;
    }
    private List<FTMSBill__c> getListBill(String shipId, String consignee, String notifyparty){
        system.debug('123: ' + consignee);
        List<FTMSBill__c> listBill;
        String strSelect = String.join(new List<String>(fieldsBillQuery), ',');
        String strQuery = 'SELECT ' + strSelect 
                    + ' FROM FTMSBill__c'
                    + ' WHERE FTMSSO__c = \'' + String.escapeSingleQuotes(shipId) + '\' AND Print__c = true';
        if (consignee != null && notifyparty == null){
            strQuery += ' AND InvoiceTo__c = \'' + String.escapeSingleQuotes(consignee)+'\'';
        } else if (consignee == null && notifyparty != null) {
            strQuery += ' AND InvoiceTo__c = \'' + String.escapeSingleQuotes(notifyparty)+'\'';
        } else if (consignee != null && notifyparty != null) {
            strQuery += ' AND (InvoiceTo__c = \'' + String.escapeSingleQuotes(consignee)+'\' OR InvoiceTo__c = \'' + String.escapeSingleQuotes(notifyparty) +'\')';
        } else {
            listBill = new List<FTMSBill__c>();
            return listBill;
        }
        strQuery += ' ORDER BY Name ASC';
        try{
            listBill = Database.query(strQuery);         
        } catch(QueryException e){
            listBill = new List<FTMSBill__c>();
        }
        return listBill;
    }
    private CompanyInformation__c getComIn(String branch){
        String strSelect = String.join(new List<String>(fieldsComInQuery), ',');
        String strQuery = 'SELECT ' + strSelect 
                    + ' FROM CompanyInformation__c'
                    + ' WHERE Branch__c = \'' + String.escapeSingleQuotes(branch) + '\'';
        strQuery += ' ORDER BY Name ASC Limit 1';        
        CompanyInformation__c ComIn;
        try{
            ComIn = Database.query(strQuery);
        } catch(QueryException e){
            ComIn = new CompanyInformation__c();
        }
        return ComIn;
    }

    private CompanyInformation__c getDOin(String branch){
        String strSelect = String.join(new List<String>(fieldsDOinfoQuery), ',');
        String strQuery = 'SELECT ' + strSelect 
                    + ' FROM CompanyInformation__c'
                    + ' WHERE Branch__c = \'' + String.escapeSingleQuotes(branch) + '\'';
        strQuery += ' ORDER BY Name ASC Limit 1';        
        CompanyInformation__c DOIn;
        try{
            DOIn = Database.query(strQuery);
        } catch(QueryException e){
            DOIn = new CompanyInformation__c();
        }
        return DOIn;
    }
}