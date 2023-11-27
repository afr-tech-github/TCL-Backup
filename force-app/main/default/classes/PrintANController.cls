public with sharing class PrintANController {
    public FTMSSO__c shipment {get; set;}
    public List<FTMSBill__c> lstBill {get; set;}
    public CompanyInformation__c ComInf {get; set;}
    public CompanyInformation__c ComInfDO {get; set;}
    public Decimal totalAmount {get; set;}
    public String curr {get; set;}
    public String readTotalAmount {get; set;}
    public Date today {get; set;}
    public String userName {get; set;}
    public Decimal TotalVND {get; set;}
    public Decimal TotalUSD {get; set;}
    public Decimal TotalVNDVat {get; set;}
    public Decimal TotalUSDVat {get; set;}
    private String shipId {get; set;}
    public String recordType {get;set;}
    public String titlePdf {get;set;}
    public Boolean requiredPackage {get;set;}

    private static Set<String> fieldsShipQuery = new Set<String>();
    static {
        fieldsShipQuery.add('Id');
        fieldsShipQuery.add('Name');
        // fieldsShipQuery.add('ShipperDetailInformation__c');
        fieldsShipQuery.add('Shipper__r.Name');
        fieldsShipQuery.add('VesselFlight__c');
        fieldsShipQuery.add('Voyage__c');
        fieldsShipQuery.add('POLAOD__r.Name');
        fieldsShipQuery.add('PODAOA__r.Name');
        fieldsShipQuery.add('ETA__c');
        fieldsShipQuery.add('CargoType__c');
        fieldsShipQuery.add('NumberofContainersPackages__c');
        fieldsShipQuery.add('GrossWeight__c');
        fieldsShipQuery.add('HBLNumber__c');
        fieldsShipQuery.add('HBLIssueStatus__c');
        fieldsShipQuery.add('PlaceofDelivery__r.Name');
        fieldsShipQuery.add('HBLType__c');
        fieldsShipQuery.add('Consignee__r.Name');
        fieldsShipQuery.add('JobRequestID__c');
        fieldsShipQuery.add('Owner.Name');
        fieldsShipQuery.add('Owner.Email');
        fieldsShipQuery.add('ContainerNo__c');
        fieldsShipQuery.add('SealNo__c');
        fieldsShipQuery.add('ContainerType1__c');
        fieldsShipQuery.add('ContainerType2__c');
        fieldsShipQuery.add('CargoQuantity__c');
        fieldsShipQuery.add('Measurement__c');
        fieldsShipQuery.add('DescriptionofGoods__c');
        fieldsShipQuery.add('Branch__c');
        fieldsShipQuery.add('HAWBNumber__c');
        fieldsShipQuery.add('ConsigneeDetailInformation_text__c');
        fieldsShipQuery.add('ContainerDetailonBL__c');
        fieldsShipQuery.add('MeasurementTotalCBM__c');
        fieldsShipQuery.add('CargoUnit__c');
        fieldsShipQuery.add('BranchpickupDO__c');
        fieldsShipQuery.add('Consignee__c');
        fieldsShipQuery.add('HouseNotifyParty__r.Name');
        fieldsShipQuery.add('POLAODsDetailInformation__c');
        fieldsShipQuery.add('PODAOAsDetailInformation__c');
        fieldsShipQuery.add('FinalDestinationsDetailInformation__c');
        fieldsShipQuery.add('PlaceofDeliveryDetailInformation__c');
        fieldsShipQuery.add('MBLNumber__c');
        fieldsShipQuery.add('PackageUnitCode__c');
        fieldsShipQuery.add('Plural_Cargo_Unit__c');
        fieldsShipQuery.add('Shipment_Type__c');
        fieldsShipQuery.add('Shipper__r.AccountNameENG__c');
    }

    private static Set<String> fieldsBillQuery = new Set<String>();
    static {
        fieldsBillQuery.add('Id');
        fieldsBillQuery.add('Service__r.Name');
        fieldsBillQuery.add('CurrencySelling__c');
        fieldsBillQuery.add('ExchangeRateBuying__c');
        fieldsBillQuery.add('ExchangeRateSelling__c');
        fieldsBillQuery.add('ChargeQuantity__c');
        fieldsBillQuery.add('CurrencySelling__c');
        fieldsBillQuery.add('UnitPriceFCY__c');
        fieldsBillQuery.add('UnitPriceofSellingLocal__c');
        fieldsBillQuery.add('TaxRateSelling__c');
        fieldsBillQuery.add('TotalAmountofSellingFCY__c');
        fieldsBillQuery.add('AmountTaxSellingFCY__c');
        fieldsBillQuery.add('TotalSellingInclTaxLocal__c');
        fieldsBillQuery.add('TotalSellingInclTaxFCY__c');
        fieldsBillQuery.add('TotalAmountofSellingLocal__c');
        fieldsBillQuery.add('AmountTaxSellingLocal__c');
        fieldsBillQuery.add('InvoiceTo__c');
		fieldsBillQuery.add('ChargeUnit__c');
        fieldsBillQuery.add('ContainerType__c');
    }

    private static Set<String> fieldsComInQuery = new Set<String>();
    static {
        fieldsComInQuery.add('Id');
        fieldsComInQuery.add('Name');
        fieldsComInQuery.add('Address__c');
        fieldsComInQuery.add('Tel__c');
        fieldsComInQuery.add('Fax__c');
        fieldsComInQuery.add('Taxcode__c');
        fieldsComInQuery.add('Branch__c');
        fieldsComInQuery.add('CompanyLogo__c');
    }

    public PrintANController() {
        ComInfDO = new CompanyInformation__c();
        ComInf = new CompanyInformation__c();
        lstBill = new List<FTMSBill__c>();
        shipId = ApexPages.currentPage().getParameters().get('Id');
        shipment = getShipment(shipId);
		
        if(shipment.POLAODsDetailInformation__c != null) shipment.POLAODsDetailInformation__c= shipment.POLAODsDetailInformation__c.toUppercase();
        if(shipment.PODAOAsDetailInformation__c != null) shipment.PODAOAsDetailInformation__c= shipment.PODAOAsDetailInformation__c.toUppercase();
        if(shipment.PlaceofDeliveryDetailInformation__c != null) shipment.PlaceofDeliveryDetailInformation__c= shipment.PlaceofDeliveryDetailInformation__c.toUppercase();



        requiredPackage = Boolean.valueOf(ApexPages.currentPage().getParameters().get('checkPackage'));
        System.debug('1123: ' + requiredPackage);
        if(shipment.CargoQuantity__c > 1){
            shipment.CargoUnit__c = shipment.CargoUnit__c + 's';
        }
        
        // String consignee = (shipment.HouseNotifyParty__c == null || shipment.HouseNotifyParty__r.Name == 'SAME AS CONSIGNEE')?shipment.Consignee__c: shipment.HouseNotifyParty__c;
        // if(consignee != null){
        //     lstBill = getListBill(shipId,consignee);
        // }

        lstBill = getListBill(shipId,shipment.Consignee__c,shipment.HouseNotifyParty__c);
        if(shipment.Branch__c != null && shipment.Branch__c != ''){
            ComInf = getComIn(shipment.Branch__c);
        }
        totalAmount = 0;
        TotalVND = 0;
        TotalUSD = 0;
        TotalVNDVat = 0;
        TotalUSDVat = 0;

        String RecordTypeId = shipment.RecordTypeId;
        System.debug('1234:' + RecordTypeId);
        RecordType = [SELECT Id,Name from RecordType WHERE Id =:recordTypeId].Name;
        if(recordType == 'Ocean Export' || recordType == 'Ocean Import'){
            titlePdf = 'AN - ' + shipment.HBLNumber__c+'.pdf';
        }else if(recordType == 'Air Export' || recordType == 'Air Import'){
            titlePdf = 'AN - ' + shipment.HAWBNumber__c+'.pdf';
        }
        Apexpages.currentPage().getHeaders().put('content-disposition', 'inline; filename=\"'+titlePdf+'\"');
        
        if(!String.isBlank(shipment.BranchpickupDO__c)){
            try{
                ComInfDO = [SELECT Id, Name, Address__c, Tel__c, Fax__c, Taxcode__c, Branch__c, CompanyLogo__c FROM CompanyInformation__c WHERE Branch__c =: shipment.BranchpickupDO__c LIMIT 1];
            } catch(QueryException e){
                ComInfDO = null ;
            }
        }
        System.debug('1234:' + ComInfDO );

        for (FTMSBill__c bill : lstBill){
            // if (bill.CurrencySelling__c == 'VND'){
            //     if (bill.TotalSellingInclTaxLocal__c != null){
            //         TotalVNDVat += bill.TotalSellingInclTaxLocal__c;
            //     }
            //     if (bill.TotalAmountofSellingLocal__c != null){
            //         TotalVND += bill.TotalAmountofSellingLocal__c;
            //     }
            // } else if (bill.CurrencySelling__c == 'USD'){
            //     if (bill.TotalSellingInclTaxFCY__c != null){
            //         TotalUSDVat += bill.TotalSellingInclTaxFCY__c;
            //     }
            //     if (bill.TotalAmountofSellingFCY__c != null){
            //         TotalUSD += bill.TotalAmountofSellingFCY__c;
            //     }
            // }
            if (bill.TotalSellingInclTaxLocal__c != null){
                TotalVNDVat += bill.TotalSellingInclTaxLocal__c;
            }
            if (bill.TotalAmountofSellingLocal__c != null){
                TotalVND += bill.TotalAmountofSellingLocal__c;
            }
            if (bill.TotalSellingInclTaxFCY__c != null){
                TotalUSDVat += bill.TotalSellingInclTaxFCY__c;
            }
            if (bill.TotalAmountofSellingFCY__c != null){
                TotalUSD += bill.TotalAmountofSellingFCY__c;
            }
        }
        readTotalAmount = EnglishNumberToWords.convert(totalAmount);
        today = Date.today();
        userName = UserInfo.getName();
    }

    private FTMSSO__c getShipment(String shipId){
        String strSelect = String.join(new List<String>(fieldsShipQuery), ',');
        String strQuery = 'SELECT ' + strSelect 
                    + ' FROM FTMSSO__c'
                    + ' WHERE Id = \'' + String.escapeSingleQuotes(shipId) + '\'';
        System.debug('queryShip: '+strQuery);
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
        System.debug('1234:' + strQuery);
        try{
            ComIn = Database.query(strQuery);
        } catch(QueryException e){
            ComIn = new CompanyInformation__c();
        }
        return ComIn;
    }
}