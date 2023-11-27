public with sharing class DebitNoteAgentController {
    public FTMSSO__c shipment {get; set;}

    public List<FTMSBill__c> lstBill {get; set;}
    
    public FTMSBill__c bill {get; set;}

    public FTMSBill__c billOut {get; set;}

    public Account cus {get; set;}

    public Contact contact {get; set;}

    public List<CntrinTrans__c> lstCont {get; set;}

    public CompanyInformation__c Company {get; set;}

    public String selectedCustomerId {get; set;}

    public String customerValue {get; set;}

    public String InvoiceValue {get; set;}

    private String shipId {get; set;}

    public Date today {get; set;}

    public String userName {get; set;}

    public String branchCompany {get; set;}

    public Decimal totalVND {get; set;}

    public Decimal totalUSD {get; set;}

    public Decimal AmountSellingFCY {get; set;}
    
    public Decimal AmountSellinglocal {get; set;}

    public Decimal AmountSellingInclFCY {get; set;}

    public Decimal AmountSellingInclLocal {get; set;}

    public Decimal AmountTaxSellingFCY {get; set;}

    public Decimal AmountTaxSellingLocal {get; set;}

    public String readTotalAmountVND {get; set;}

    public String readTotalAmountUSD {get; set;}

    public String outboundVATInvNo {get;set;}

    public String chargeUnit {get; set;}

    public String ankenIds {get; set;}

    public static List<String> lstAnken = new List<String>();

    private static Set<String> fieldsShipQuery = new Set<String>();

    static{
        fieldsShipQuery.add('Salesman__r.Name');
        fieldsShipQuery.add('Date_of_issue__c');
        fieldsShipQuery.add('ETD__c');
        fieldsShipQuery.add('HBLNumber__c');
        fieldsShipQuery.add('Branch__c');
        fieldsShipQuery.add('Id');
        fieldsShipQuery.add('Name');
        fieldsShipQuery.add('ConsigneeDetailInformation__c');
        fieldsShipQuery.add('InvoiceIssueDate__c');
        fieldsShipQuery.add('VesselFlight__c');
        fieldsShipQuery.add('Voyage__c');
        fieldsShipQuery.add('ETA__c');
        fieldsShipQuery.add('ETD__c');
        fieldsShipQuery.add('POLAOD__r.Name');
        fieldsShipQuery.add('PODAOA__r.Name');
        fieldsShipQuery.add('MBLNumber__c');
        fieldsShipQuery.add('MAWBNumber__c');
        // fieldsShipQuery.add('Branch__c');
        // fieldsShipQuery.add('HBLNumber__c');
        fieldsShipQuery.add('recordType.DeveloperName');
        fieldsShipQuery.add('JobRequestID__c');
        fieldsShipQuery.add('CargoType__c');
        fieldsShipQuery.add('Agent__c');
        fieldsShipQuery.add('Agent2nd__c');
        fieldsShipQuery.add('RecordType.Name');
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
        fieldsBillQuery.add('CurrencyBuying__c');
        fieldsBillQuery.add('TotalBuyingInclTaxFCY__c');
        fieldsBillQuery.add('TotalBuyingInclTaxLocal__c');
        fieldsBillQuery.add('ChargeUnit__c');
        fieldsBillQuery.add('UnitPriceofBuyingFCY__c');
        fieldsBillQuery.add('TaxRateBuying__c');
        fieldsBillQuery.add('TotalAmountofBuyingFCY__c');
        fieldsBillQuery.add('AmountTaxBuyingFCY__c');
        fieldsBillQuery.add('UnitPriceofBuyingLocal__c');
        fieldsBillQuery.add('TotalAmountofBuyingLocal__c');
        fieldsBillQuery.add('AmountTaxBuyingLocal__c');
        fieldsBillQuery.add('OutboundVATInvNo__c');
        fieldsBillQuery.add('CurrencySelling__c');
        fieldsBillQuery.add('ContainerType__c');
        fieldsBillQuery.add('MMYY_Debit__c');
        fieldsBillQuery.add('Debit_check__c');
    }
    private static Set<String> fieldsCompanyQuery = new Set<String>();
    static{
        fieldsCompanyQuery.add('Name');
        fieldsCompanyQuery.add('Address__c');
        fieldsCompanyQuery.add('Tel__c');
        fieldsCompanyQuery.add('Fax__c');
        fieldsCompanyQuery.add('CompanyLogo__c');
        fieldsCompanyQuery.add('Email__c');
        fieldsCompanyQuery.add('Website__c');
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
    public DebitNoteAgentController() {
        shipId = ApexPages.currentPage().getParameters().get('Id');
        customerValue = ApexPages.currentPage().getParameters().get('customerValue');
        InvoiceValue = ApexPages.currentPage().getParameters().get('Invoice');
        ankenIds = ApexPages.currentPage().getParameters().get('BillId');
        String Draft = ApexPages.currentPage().getParameters().get('Draft');
        String Official = ApexPages.currentPage().getParameters().get('Official');
        if(!String.isBlank(ankenIds)){
            lstAnken = ankenIds.split(',');
        }
        System.debug('Official :'+Official);
        AmountSellingFCY = 0;
        AmountSellinglocal = 0;
        AmountSellingInclFCY = 0;
        AmountSellingInclLocal = 0;
        AmountTaxSellingFCY = 0;
        AmountTaxSellingLocal = 0;
        readTotalAmountVND = '';
        outboundVATInvNo = '';
        branchCompany = '';
        today = Date.today();
        userName = UserInfo.getName();
        System.debug('customerValue123 :'+customerValue);
        shipment = getShipment(shipId);
        lstBill = getListBill(shipId,customerValue,InvoiceValue);
        bill = getBill(shipId,customerValue);
        billOut = getBillOut(shipId,customerValue);
        contact = getContact(customerValue);
        cus = getAccount(customerValue);
        lstCont = getListCont(shipId);
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
            if(InvoiceValue != null || InvoiceValue != ''){
                outboundVATInvNo = bill.OutboundVATInvNo__c;
            }
        }
        //if(Draft == 'true' || Official == 'true'){

            // String shipID = ApexPages.currentPage().getParameters().get('id');
            // String billIds = ApexPages.currentPage().getParameters().get('strAkens');
            // System.debug('111'+billIds);
            // // String customerValue = ApexPages.currentPage().getParameters().get('customerValue');
            // System.debug('customerValue :'+customerValue);
            // String official = ApexPages.currentPage().getParameters().get('checkOfficial');
            // System.debug('121: '+official);
            List<String> lstBillIds = new List<String>();
            if(!String.isBlank(ankenIds)){
                lstBillIds = ankenIds.split(',');         
            }
            String strSelect = 'SELECT ' + String.join(new List<String>(fieldsBillQuery), ',');
            String strFrom = ' FROM FTMSBill__c ';
            String strWhere = 'WHERE FTMSSO__c = \'' + shipId + '\'' +  ' AND Id IN : lstBillIds';
            String strOrderBy = ' ORDER BY Name';
            String query = strSelect + strFrom + strWhere +strOrderBy;  
    
            String strSelect1 = 'SELECT ' + String.join(new List<String>(fieldsBillQuery), ',');
            String strFrom1 = ' FROM FTMSBill__c ';
            // String strWhere = 'WHERE FTMSSO__c = \'' + shipmentId + '\'' +  ' AND Id IN : lstBillIds';
            String strOrderBy1 = ' ORDER BY Name';
            String query1 = strSelect1 + strFrom1 +strOrderBy1; 
    
            List<FTMSBill__c> lstBill = Database.query(query);
            List<FTMSBill__c> lstBill1 = Database.query(query1);
            List<String> numberPoint = new List<String>();
            String months = String.valueOf(today.month());
            if(Integer.valueOf(today.month()) < 10){
                months = '0' + months;
            }
            String yearMonth = String.valueOf(today.year()).substring(2) + months;
            System.debug('26: ' + yearMonth);
            for(FTMSBill__c bill1 : lstBill1){
                System.debug('27: ' + bill1.MMYY_Debit__c);
                if(bill1.OutboundVATInvNo__c != null && bill1.MMYY_Debit__c == yearMonth){
                    String endPoint = bill1.Debit_check__c;
                    System.debug('333c :'+endPoint);
                    numberPoint.add(endPoint);
                }    
            }
            System.debug('444d :'+numberPoint); 
            Integer max = 0;
            for(Integer i = 0; i < numberPoint.size(); i++){
                // max = Integer.valueOf(numberPoint[0]);
                if(Integer.valueOf(numberPoint[i]) > max){
                    max = Integer.valueOf(numberPoint[i]);
                }
            }
            System.debug('555b :'+max);
            String First = '';
            System.debug('42:' + lstBill.size());
            for(FTMSBill__c bill : lstBill){
                System.debug('666b :'+max);
                if(bill.InvoiceTo__c == shipment.Agent__c || bill.InvoiceTo__c == shipment.Agent2nd__c){
                    First = '-DN-';
                }
                else{
                    First = '-LDN-';
                }
                if(Integer.valueOf(today.month()) < 10){
                    months = '0' + months;
                }
                if(bill.OutboundVATInvNo__c == null){
                    if(max <10){
                        outboundVATInvNo = 'ASAP' + First + yearMonth +'-'+ '00' +(max+1);
                        bill.OutboundInvDate__c = today;
                    }
                    else if(max >= 10 && max < 100){
                        outboundVATInvNo = 'ASAP' + First + yearMonth +'-'+ '0' +(max+1);
                        bill.OutboundInvDate__c = today;
                    }
                    else {
                        outboundVATInvNo = 'ASAP' + First + yearMonth + '-' +(max+1);
                        bill.OutboundInvDate__c = today;
                    }
                    // bill.OutboundVATInvNo__c = 'ASAP' + First + yearMonth +'-'+ + '0'+ (max+1);
                    // bill.OutboundInvDate__c = today;
                }
            }
            // if(InvoiceValue != null || InvoiceValue != ''){
            //     outboundVATInvNo = ;
            // }
            // outboundVATInvNo = billOut.OutboundVATInvNo__c;
            System.debug('123: ' + outboundVATInvNo);
            System.debug('122: ' + Draft);
        //}


        totalVND = 0;
        totalUSD = 0;
        for (FTMSBill__c bill : lstBill){
            if (bill.CurrencySelling__c == 'VND'){
                if (bill.TotalSellingInclTaxLocal__c != null){
                    totalVND += bill.TotalSellingInclTaxLocal__c;
                }
            } else if (bill.CurrencySelling__c == 'USD'){
                if (bill.TotalSellingInclTaxFCY__c != null){
                    totalUSD += bill.TotalSellingInclTaxFCY__c;
                }
            }
            if(bill.ChargeUnit__c == 'Container'){
                chargeUnit = bill.ContainerType__c;
            }else {
                chargeUnit = bill.ChargeUnit__c;
            }

            
            // InvoiceNo = bill.InvNoonCreditfromCompany__c;
        }

        readTotalAmountVND = EnglishNumberToWords.convert(totalVND.setScale(2));
        readTotalAmountUSD = EnglishNumberToWords.convert(totalUSD.setScale(2));
    }

    // public PageReference updateDebitNo(){
    //     // String debitNo = ApexPages.currentPage().getParameters().get('debitNo');
    //     String billIds = ApexPages.currentPage().getParameters().get('BillId');
    //     String shipID = ApexPages.currentPage().getParameters().get('id');
    //     List<String> lstBillIds = new List<String>();
    //     if(!String.isBlank(billIds)){
    //         lstBillIds = billIds.split(',');
    //     }
    //     String strSelect = 'SELECT ' + String.join(new List<String>(fieldsBillQuery), ',');
    //     String strFrom = ' FROM FTMSBill__c ';
    //     String strWhere = 'WHERE FTMSSO__c = \'' + shipID + '\'';
    //     if(lstBillIds.size() > 0){
    //        strWhere += ' AND Id IN : lstBillIds';
    //     }
    //     // String strOrderBy = ' ORDER BY clofor_com_cfs__SeikyuBangou__c ';
    //     String query = strSelect + strFrom + strWhere;  
    //     List<FTMSBill__c> lstBill = Database.query(query);
    //     for (FTMSBill__c bill : lstBill){
    //         // if (debitNo != ''){
    //             bill.OutboundVATInvNo__c = 'debitNo';
    //         // }
    //     }
    //     update lstBill;
    //     return null;
    // }

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

    private List<FTMSBill__c> getListBill(String shipId, String cusId, String InvoiceValue){
        System.debug('11:'+ cusId);
        System.debug('12:'+ InvoiceValue);
        String strSelect = String.join(new List<String>(fieldsBillQuery), ',');
        String strQuery = 'SELECT ' + strSelect 
                    + ' FROM FTMSBill__c'
                    + ' WHERE FTMSSO__c = \'' + String.escapeSingleQuotes(shipId) + '\' AND InvoiceTo__c = \''+ String.escapeSingleQuotes(cusId) + '\'';
        String strWhere = '';
        if(lstAnken.size() > 0){
            strWhere += ' AND Id IN : lstAnken';
         } 
         else{
            strWhere += ' AND OutboundVATInvNo__c = \'' + String.escapeSingleQuotes(InvoiceValue) + '\'';
         }
         
        strQuery += strWhere;
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
    private FTMSBill__c getBillOut(String shipId, String cusId){
        String strSelect = String.join(new List<String>(fieldsBillQuery), ',');
        String strQuery = 'SELECT ' + strSelect 
                    + ' FROM FTMSBill__c'
                    + ' WHERE FTMSSO__c = \'' + String.escapeSingleQuotes(shipId) + '\' AND InvoiceTo__c = \''+ String.escapeSingleQuotes(cusId) + '\'';
        strQuery += ' ORDER BY OutboundVATInvNo__c DESC LIMIT 1';
        FTMSBill__c Bill;
        try{
            Bill = Database.query(strQuery);
        } catch(QueryException e){
            Bill = new FTMSBill__c();
        }
        return Bill;
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

    private Contact getContact(String customerValue){
       
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