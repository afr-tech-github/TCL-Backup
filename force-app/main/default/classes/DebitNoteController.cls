public with sharing class DebitNoteController {
    public FTMSSO__c shipment {get; set;}

    public List<FTMSBill__c> lstBill {get; set;}
    
    public FTMSBill__c bill {get; set;}

    public Contact contact {get; set;}

    public CompanyInformation__c Company {get; set;}

    public String selectedCustomerId {get; set;}

    public String customerValue {get; set;}

    private String shipId {get; set;}

    public String branchCompany {get; set;}

    public Decimal AmountSellingFCY {get; set;}
    
    public Decimal AmountSellinglocal {get; set;}

    public Decimal AmountSellingInclFCY {get; set;}

    public Decimal AmountSellingInclLocal {get; set;}

    public Decimal AmountTaxSellingFCY {get; set;}

    public Decimal AmountTaxSellingLocal {get; set;}

    public String readTotalAmountVND {get; set;}

    private static Set<String> fieldsShipQuery = new Set<String>();

    static{
        fieldsShipQuery.add('Salesman__r.Name');
        fieldsShipQuery.add('Date_of_issue__c');
        fieldsShipQuery.add('ETD__c');
        fieldsShipQuery.add('HBLNumber__c');
        fieldsShipQuery.add('Branch__c');
    }
    private static Set<String> fieldsBillQuery = new Set<String>();
    static{
        fieldsBillQuery.add('BillNameatPrintENG__c');
        fieldsBillQuery.add('ChargeQuantity__c	');
        fieldsBillQuery.add('UnitPriceFCY__c');
        fieldsBillQuery.add('UnitPriceofSellingLocal__c');
        fieldsBillQuery.add('TotalAmountofSellingFCY__c');
        fieldsBillQuery.add('TotalAmountofSellingLocal__c');
        fieldsBillQuery.add('TaxRateSelling__c');
        fieldsBillQuery.add('TotalSellingInclTaxFCY__c');
        fieldsBillQuery.add('TotalSellingInclTaxLocal__c');
        fieldsBillQuery.add('ExchangeRateSelling__c');
        fieldsBillQuery.add('AmountTaxSellingFCY__c');
        fieldsBillQuery.add('AmountTaxSellingLocal__c');
        fieldsBillQuery.add('InvoiceTo__r.Name');
    }
    private static Set<String> fieldsCompanyQuery = new Set<String>();
    static{
        fieldsCompanyQuery.add('Name');
        fieldsCompanyQuery.add('Address__c');
        fieldsCompanyQuery.add('Tel__c');
        fieldsCompanyQuery.add('Fax__c');
    }
    public DebitNoteController() {
        shipId = ApexPages.currentPage().getParameters().get('Id');
        customerValue = ApexPages.currentPage().getParameters().get('customerValue');
        AmountSellingFCY = 0;
        AmountSellinglocal = 0;
        AmountSellingInclFCY = 0;
        AmountSellingInclLocal = 0;
        AmountTaxSellingFCY = 0;
        AmountTaxSellingLocal = 0;
        readTotalAmountVND = '';
        branchCompany = '';
        System.debug('customerValue123 :'+customerValue);
        shipment = getShipment(shipId);
        lstBill = getListBill(shipId,customerValue);
        bill = getBill(shipId,customerValue);
        contact = getContact(customerValue);
        branchCompany = shipment.Branch__c;
        Company = getListCompany(branchCompany);
        System.debug('lstCompany :'+Company);
        
        System.debug('lstBill :'+lstBill);

        for(FTMSBill__c bill : lstBill){
            AmountSellingFCY += bill.TotalAmountofSellingFCY__c;
            AmountSellinglocal += bill.TotalAmountofSellingLocal__c;
            AmountSellingInclFCY += bill.TotalSellingInclTaxFCY__c;
            AmountSellingInclLocal += bill.TotalSellingInclTaxLocal__c;
            AmountTaxSellingFCY += bill.AmountTaxSellingFCY__c;
            AmountTaxSellingLocal += bill.AmountTaxSellingLocal__c;
        }

        readTotalAmountVND = EnglishNumberToWords.convert(AmountSellingInclLocal.setScale(2));

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
        List<FTMSBill__c> lstBill;
        try{
            lstBill = Database.query(strQuery);
        } catch(QueryException e){
            lstBill = new List<FTMSBill__c>();
        }
        return lstBill;
    }

    private FTMSBill__c getBill(String shipId, String cusId){
        String strSelect = String.join(new List<String>(fieldsBillQuery), ',');
        String strQuery = 'SELECT ' + strSelect 
                    + ' FROM FTMSBill__c'
                    + ' WHERE FTMSSO__c = \'' + String.escapeSingleQuotes(shipId) + '\' AND InvoiceTo__c = \''+ String.escapeSingleQuotes(cusId) + '\'';
        strQuery += ' ORDER BY Name LIMIT 1';
        FTMSBill__c Bill;
        try{
            Bill = Database.query(strQuery);
        } catch(QueryException e){
            Bill = new FTMSBill__c();
        }
        return Bill;
    }

    private Contact getContact(String customerValue){
        // String strSelect = String.join(new List<String>(fieldsBillQuery), ',');
        String strQuery = 'SELECT Name'
                    + ' FROM Contact'
                    + ' WHERE AccountId = \'' + String.escapeSingleQuotes(customerValue) + '\'';
        strQuery += ' ORDER BY Name LIMIT 1';
        Contact cont;
        try{
            cont = Database.query(strQuery);
        } catch(QueryException e){
            cont = new Contact();
        }
        return cont;
    }

    private CompanyInformation__c getListCompany(String branchCompany){
        String strSelect = String.join(new List<String>(fieldsCompanyQuery), ',');
        String strQuery = 'SELECT ' + strSelect 
                    + ' FROM CompanyInformation__c'
                    + ' WHERE Branch__c = \'' + String.escapeSingleQuotes(branchCompany) + '\'';
        strQuery += ' ORDER BY Name LIMIT 1';
        CompanyInformation__c lstCompany;
        try{
            lstCompany = Database.query(strQuery);
        } catch(QueryException e){
            lstCompany = new CompanyInformation__c();
        }
        return lstCompany;
    }
}