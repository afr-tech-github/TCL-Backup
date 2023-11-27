public with sharing class PrintInvoiceController {
    public FTMSSO__c shipment {get; set;}
    public List<FTMSBill__c> lstBill {get; set;}
    public CompanyInformation__c ComInf {get; set;}
    public Account cus {get; set;}
    public List<CntrinTrans__c> lstCont {get; set;}
    public Decimal totalAmount {get; set;}
    public String curr {get; set;}
    public String readTotalAmount {get; set;}
    public String today {get; set;}
    public String userName {get; set;}
    private String shipId {get; set;}
    public String customerValue {get; set;}
    public String InvoiceNo {get; set;}
    public String recordType {get; set;}
    public Decimal totalVND {get; set;}
    public Decimal totalUSD {get; set;}
    public String readTotalAmountVND {get; set;}
    public String readTotalAmountUSD {get; set;}
    

    private static Set<String> fieldsShipQuery = new Set<String>();
    // private static Set<String> fieldsBillQuery = new Set<String>();
    static {
        fieldsShipQuery.add('Id');
        fieldsShipQuery.add('Name');
        fieldsShipQuery.add('ConsigneeDetailInformation__c');
        fieldsShipQuery.add('InvoiceIssueDate__c');
        fieldsShipQuery.add('VesselFlight__c');
        fieldsShipQuery.add('Voyage__c');
        fieldsShipQuery.add('ETA__c');
        fieldsShipQuery.add('POLAOD__r.Name');
        fieldsShipQuery.add('FinalDestination__r.Name');
        fieldsShipQuery.add('MBLNumber__c');
        fieldsShipQuery.add('MAWBNumber__c');
        fieldsShipQuery.add('ContainerNo__c');
        fieldsShipQuery.add('HBLNumber__c');
        fieldsShipQuery.add('Branch__c');
        fieldsShipQuery.add('ReferenceNumber__c');
        fieldsShipQuery.add('recordType.DeveloperName');
        fieldsShipQuery.add('CargoType__c');
    }
    private static Set<String> fieldsBillQuery = new Set<String>();
    static {
        fieldsBillQuery.add('Id');
        fieldsBillQuery.add('BillNameatPrintENG__c');
        fieldsBillQuery.add('UnitPriceFCY__c');
        fieldsBillQuery.add('ChargeQuantity__c');
        fieldsBillQuery.add('ChargeUnit__c');
        fieldsBillQuery.add('CurrencySelling__c');
        fieldsBillQuery.add('TotalAmountofSellingFCY__c');
        fieldsBillQuery.add('TotalAmountofBuyingFCY__c');
        fieldsBillQuery.add('CurrencySelling__c');
        fieldsBillQuery.add('TotalBuyingInclTaxFCY__c');
        fieldsBillQuery.add('UnitPriceofBuyingFCY__c');
        fieldsBillQuery.add('TotalAmountofBuyingLocal__c');
        fieldsBillQuery.add('UnitPriceofBuyingLocal__c');
    }
    private static Set<String> fieldsComInQuery = new Set<String>();
    static {
        fieldsComInQuery.add('Id');
        fieldsComInQuery.add('Name');
        fieldsComInQuery.add('Address__c');
        fieldsComInQuery.add('Tel__c');
        fieldsComInQuery.add('Fax__c');
        fieldsComInQuery.add('Taxcode__c');
        fieldsComInQuery.add('Email__c');
        fieldsComInQuery.add('Website__c');
        fieldsComInQuery.add('Branch__c');
        fieldsComInQuery.add('CompanyLogo__c');
    }
    private static Set<String> fieldsAccQuery = new Set<String>();
    static {
        fieldsAccQuery.add('Id');
        fieldsAccQuery.add('Name');
        fieldsAccQuery.add('EnglishAddress__c');
        fieldsAccQuery.add('Phone');
        fieldsAccQuery.add('Fax');
        fieldsAccQuery.add('Bank1__c');
        fieldsAccQuery.add('Bank2__c');
    }
    private static Set<String> fieldsContQuery = new Set<String>();
    static {
        fieldsContQuery.add('Id');
        fieldsContQuery.add('Name');
        fieldsContQuery.add('Container_Number__c');
    }

    public PrintInvoiceController() {
        shipId = ApexPages.currentPage().getParameters().get('Id');
        customerValue = ApexPages.currentPage().getParameters().get('customerValue');
        shipment = getShipment(shipId);
        lstBill = getListBill(shipId,customerValue);
        cus = getAccount(customerValue);
        ComInf = getComIn(shipment.Branch__c);
        lstCont = getListCont(shipId);
        System.debug('lstBill :'+lstBill);
        totalAmount = 0;
        for (FTMSBill__c bill : lstBill){
            if (bill.TotalAmountofSellingFCY__c != null){
                totalAmount += bill.TotalAmountofSellingFCY__c;
            }
            if (bill.CurrencySelling__c != null){
                curr = bill.CurrencySelling__c;
            }
        }

        totalVND = 0;
        totalUSD = 0;
        for (FTMSBill__c bill : lstBill){
            if (bill.CurrencySelling__c == 'VND'){
                if (bill.TotalAmountofBuyingLocal__c != null){
                    totalVND += bill.TotalAmountofBuyingLocal__c;
                }
            } else if (bill.CurrencySelling__c == 'USD'){
                if (bill.TotalAmountofBuyingFCY__c != null){
                    totalUSD += bill.TotalAmountofBuyingFCY__c;
                }
            }
            // InvoiceNo = bill.InvNoonCreditfromCompany__c;
        }

        readTotalAmountVND = EnglishNumberToWords.convert(totalVND.setScale(2));
        readTotalAmountUSD = EnglishNumberToWords.convert(totalUSD.setScale(2));

        String strQuery = 
        'SELECT OutboundVATInvNo__c' 
        + ' FROM FTMSBill__c'
        + ' WHERE FTMSSO__c = \'' + String.escapeSingleQuotes(shipId) + '\' AND InvoiceTo__c = \''+ String.escapeSingleQuotes(customerValue) + '\'';
        strQuery += ' ORDER BY Name LIMIT 1';
        FTMSBill__c data = Database.query(strQuery);
        InvoiceNo = data.OutboundVATInvNo__c;
        System.debug('InvoiceNo :'+InvoiceNo);

        readTotalAmount = EnglishNumberToWords.convert(totalAmount);
        today = String.valueOf(Date.today());
        userName = UserInfo.getName();
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

    private List<FTMSBill__c> getListBill(String shipId, String cusId){
        String strSelect = String.join(new List<String>(fieldsBillQuery), ',');
        String strQuery = 'SELECT ' + strSelect 
                    + ' FROM FTMSBill__c'
                    + ' WHERE FTMSSO__c = \'' + String.escapeSingleQuotes(shipId) + '\' AND InvoiceTo__c = \''+ String.escapeSingleQuotes(cusId) + '\'';
        strQuery += ' ORDER BY Name ASC';
        List<FTMSBill__c> listBill;
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
    private Account getAccount(String cusId){
        String strSelect = String.join(new List<String>(fieldsAccQuery), ',');
        String strQuery = 'SELECT ' + strSelect 
                    + ' FROM Account'
                    + ' WHERE Id = \'' + String.escapeSingleQuotes(cusId) + '\'';
        Account acc;
        try{
            acc = Database.query(strQuery);
        } catch(QueryException e){
            acc = new Account();
        }
        return acc;
    }
    private List<CntrinTrans__c> getListCont(String shipId){
        String strSelect = String.join(new List<String>(fieldsContQuery), ',');
        String strQuery = 'SELECT ' + strSelect 
                    + ' FROM CntrinTrans__c'
                    + ' WHERE F_TMS_S_O__c = \'' + String.escapeSingleQuotes(shipId) + '\' ';
        strQuery += ' ORDER BY Name ASC';
        List<CntrinTrans__c> listCont;
        try{
            listCont = Database.query(strQuery);
        } catch(QueryException e){
            listCont = new List<CntrinTrans__c>();
        }
        return listCont;
    }
}