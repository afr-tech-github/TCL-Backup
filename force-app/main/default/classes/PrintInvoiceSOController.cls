public with sharing class PrintInvoiceSOController {
    public FTMSSO__c shipment {get; set;}

    public List<FTMSBill__c> lstBill {get; set;}
    
    public FTMSBill__c bill {get; set;}

    public FTMSBill__c billOut {get; set;}
    
    public List<BillWrapper> listBillWrapper {get; set;}

    public List<ShipmentWrapper> listShipWrapper {get; set;}

    public Account cus {get; set;}

    public Contact contact {get; set;}

    public List<CntrinTrans__c> lstCont {get; set;}

    public CompanyInformation__c Company {get; set;}

    public String selectedCustomerId {get; set;}

    public String customerValue {get; set;}

    public String InvoiceValue {get; set;}

    public String InvoiceNoDisplay {get; set;}

    private String shipId {get; set;}
    
    private String agentId {get; set;}

    public String title {get; set;}

    public Date today {get; set;}

    public String userName {get; set;}

    public String branchCompany {get; set;}

    public Decimal totalVND {get; set;}

    public Decimal totalUSD {get; set;}

    public Decimal totalDebitUSD {get; set;}

    public Decimal totalCreditUSD {get; set;}

    public Decimal totalDebitUSDchangeToVND {get; set;}

    public Decimal totalCreditUSDchangeToVND {get; set;}

    public Decimal totalDebitVND {get; set;}

    public Decimal totalCreditVND {get; set;}

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
        fieldsShipQuery.add('Id');
        fieldsShipQuery.add('Name');
        fieldsShipQuery.add('ConsigneeDetailInformation__c');
        fieldsShipQuery.add('InvoiceIssueDate__c');
        fieldsShipQuery.add('VesselFlight__c');
        fieldsShipQuery.add('Voyage__c');
        fieldsShipQuery.add('ETA__c');
        fieldsShipQuery.add('ETD__c');
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
        fieldsShipQuery.add('PlaceofDeliveryDetailInformation__c');
        fieldsShipQuery.add('POLAODsDetailInformation__c');
        fieldsShipQuery.add('JobRequestID__c');
        fieldsShipQuery.add('RecordType.Name');
        fieldsShipQuery.add('Agent__r.Name');
        fieldsShipQuery.add('Agent2nd__r.Name');
    }
    private static Set<String> fieldsBillQuery = new Set<String>();
    static{
        fieldsBillQuery.add('BillNameatPrintENG__c');
        fieldsBillQuery.add('ChargeQuantity__c');
        fieldsBillQuery.add('UnitPriceFCY__c');
        fieldsBillQuery.add('UnitPriceofSellingLocal__c');
        fieldsBillQuery.add('TotalAmountofSellingFCY__c');
        fieldsBillQuery.add('TotalAmountofSellingLocal__c');
        fieldsBillQuery.add('TaxRateSelling__c');
        fieldsBillQuery.add('TotalSellingInclTaxFCY__c');
        fieldsBillQuery.add('TotalSellingInclTaxLocal__c');
        fieldsBillQuery.add('ExchangeRateSelling__c');
        fieldsBillQuery.add('ExchangeRateBuying__c');
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
        fieldsBillQuery.add('Service__r.Name');
        fieldsBillQuery.add('FTMSSO__c');
        fieldsBillQuery.add('FTMSSO__r.HBLNumber__c');
        fieldsBillQuery.add('InvoiceTo__c');
        fieldsBillQuery.add('PaymentTo__c');
        fieldsBillQuery.add('InvNoonCreditfromCompany__c');
        fieldsBillQuery.add('Debit_check__c');
        fieldsBillQuery.add('MMYY_Credit__c');
        fieldsBillQuery.add('Credit_Check__c');
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
        fieldsContQuery.add('Seal_Number__c');
        fieldsContQuery.add('Container_Type__c');
    }
    public PrintInvoiceSOController() {
        shipId = ApexPages.currentPage().getParameters().get('Id');
        System.debug('1211: '+ shipId);
        agentId = ApexPages.currentPage().getParameters().get('agentId');
        // title = ApexPages.currentPage().getParameters().get('title');
        customerValue = ApexPages.currentPage().getParameters().get('customerValue');
        InvoiceValue = ApexPages.currentPage().getParameters().get('Invoice');
        ankenIds = ApexPages.currentPage().getParameters().get('BillId');
        String Draft = ApexPages.currentPage().getParameters().get('Draft');
        listBillWrapper = new List<BillWrapper>();
        // String Official = ApexPages.currentPage().getParameters().get('Official');
        if(!String.isBlank(ankenIds)){
            lstAnken = ankenIds.split(',');
        }
        // System.debug('Official :'+Official);
        AmountSellingFCY = 0;
        AmountSellinglocal = 0;
        AmountSellingInclFCY = 0;
        AmountSellingInclLocal = 0;
        AmountTaxSellingFCY = 0;
        AmountTaxSellingLocal = 0;
        totalVND =0;
        totalUSD =0;
        totalCreditUSD =0;
        totalDebitUSD =0;
        totalCreditVND = 0;
        totalDebitVND = 0;
        totalDebitUSDchangeToVND = 0;
        totalCreditUSDchangeToVND = 0;
        readTotalAmountVND = '';
        branchCompany = '';
        InvoiceNoDisplay = '';
        today = Date.today();
        userName = UserInfo.getName();
        // System.debug('customerValue123 :'+customerValue);
        shipment = getShipment(shipId);
        System.debug('1211: '+ shipment);
        lstBill = getListBill(customerValue,InvoiceValue);
        // bill = getBill(shipId,agentId);
        // billOut = getBillOut(shipId,agentId);
        contact = getContact(customerValue);
        cus = getAccount(customerValue);
        lstCont = getListCont(shipId);
        branchCompany = shipment.Branch__c;
        System.debug('1211: '+ branchCompany);
        Company = getListCompany(branchCompany);
        System.debug('lstCompany :'+Company);
        
        // if (title == 'invoice'){
        //     title = 'INVOICE';
        // }
        // if (title == 'debit'){
        //     title = 'DEBIT NOTE';
        // }
        // if (title == 'credit'){
        //     title = 'CREDIT NOTE';
        // }
        String invoiceNoDebit = '';
        String invoiceNoCredit = '';
        Map<String,ShipmentWrapper> mapShipment = new Map<String,ShipmentWrapper>();
        listShipWrapper = new List<ShipmentWrapper>();

        System.debug('lstBill :'+lstBill);
        Set<String> setShip = new Set<String>();
        for(FTMSBill__c bill : lstBill){
            if (!setShip.contains(bill.FTMSSO__c)){
                setShip.add(bill.FTMSSO__c);
                ShipmentWrapper ship = new ShipmentWrapper();
                mapShipment.put(bill.FTMSSO__c,ship);
            }
            // if (bill.InvoiceTo__c == agentId){
            //     invoiceNoDebit = bill.OutboundVATInvNo__c;
            // } else if (bill.PaymentTo__c == agentId){
            //     invoiceNoCredit = bill.InvNoonCreditfromCompany__c;
            // }
        }
        for(FTMSBill__c bill : lstBill){
            BillWrapper item = new BillWrapper();
            item.shipId = bill.FTMSSO__c;
            item.HBL = bill.FTMSSO__r.HBLNumber__c;
            item.serviceName = bill.Service__r.Name;
            if (bill.ChargeUnit__c != 'Container'){
                item.chargeUnit = bill.ChargeUnit__c =='Shipment'?'SHPT':bill.ChargeUnit__c;
            } else {
                bill.ChargeUnit__c = bill.ContainerType__c;
            }
            
            item.quantity = bill.ChargeQuantity__c != null? bill.ChargeQuantity__c :0;
            
            if (bill.InvoiceTo__c == customerValue){
                item.curr = bill.CurrencySelling__c;
                if (item.curr == 'VND'){
                    item.unitPrice = bill.UnitPriceofSellingLocal__c != null?bill.UnitPriceofSellingLocal__c:0;
                    item.amountDebitVND = item.unitPrice * item.quantity;
                    item.amountDebitUSD = 0;
                    item.amountCreditVND = 0;
                    item.amountCreditUSD = 0;
                } else {
                    item.unitPrice = bill.UnitPriceFCY__c != null?bill.UnitPriceFCY__c:0;
                    item.amountDebitUSD = item.unitPrice * item.quantity;
                    item.amountDebitVND = 0;
                    item.amountCreditVND = 0;
                    item.amountCreditUSD = 0;
                    item.amountDebitUSDchangeToVND = item.unitPrice * item.quantity * bill.ExchangeRateSelling__c;
                }
                
            } else if (bill.PaymentTo__c == customerValue){
                item.curr = bill.CurrencyBuying__c;
                if (item.curr == 'VND'){
                    item.unitPrice = bill.UnitPriceofBuyingLocal__c != null?bill.UnitPriceofBuyingLocal__c:0;
                    item.amountCreditVND = item.unitPrice * item.quantity;
                    item.amountDebitVND = 0;
                    item.amountDebitUSD = 0;
                    item.amountCreditUSD = 0;
                } else {
                    item.unitPrice = bill.UnitPriceofBuyingFCY__c != null?bill.UnitPriceofBuyingFCY__c:0;
                    item.amountCreditUSD = item.unitPrice * item.quantity;
                    item.amountDebitVND = 0;
                    item.amountDebitUSD = 0;
                    item.amountCreditVND = 0;
                    item.amountCreditUSDchangeToVND = item.unitPrice * item.quantity * bill.ExchangeRateBuying__c;
                }
            }
            listBillWrapper.add(item);
        }
        for (BillWrapper item : listBillWrapper){
            ShipmentWrapper ship = mapShipment.get(item.shipId);
            ship.shipId = item.shipId;
            ship.HBL = item.HBL;
            ship.listBill.add(item);
            ship.totalDebitVND += item.amountDebitVND;
            ship.totalDebitUSD += item.amountDebitUSD;
            ship.totalCreditVND += item.amountCreditVND;
            ship.totalCreditUSD += item.amountCreditUSD;
            ship.totalCreditUSDchangeToVND += item.amountCreditUSDchangeToVND;
            ship.totalDebitUSDchangeToVND += item.amountDebitUSDchangeToVND;
            mapShipment.put(item.shipId,ship);
        }
        for (ShipmentWrapper ship : mapShipment.values()){
            listShipWrapper.add(ship);
            totalVND += (ship.totalDebitVND-ship.totalCreditVND);
            totalUSD += (ship.totalDebitUSD-ship.totalCreditUSD);
            totalDebitUSD += ship.totalDebitUSD;
            totalCreditUSD += ship.totalCreditUSD;  
            totalDebitVND += ship.totalDebitVND;
            totalCreditVND += ship.totalCreditVND;
            totalCreditUSDchangeToVND += ship.totalCreditUSDchangeToVND;
            totalDebitUSDchangeToVND += ship.totalDebitUSDchangeToVND;
        }
        if (totalUSD < 0) {
            totalUSD = 0 - totalUSD;
        }
        if (totalVND < 0) {
            totalVND = 0 - totalVND;
        }
        readTotalAmountUSD = EnglishNumberToWords.convert(totalUSD.setScale(2));
        readTotalAmountVND = EnglishNumberToWords.convert(totalVND.setScale(2));
        // if (totalUSD >= 0){
        //     readTotalAmountUSD = EnglishNumberToWords.convert(totalUSD.setScale(2));
        // } else {
        //     readTotalAmountUSD = '- ' +EnglishNumberToWords.convert((0-totalUSD).setScale(2));
        // }
        // if (totalVND >= 0){
        //     readTotalAmountVND = EnglishNumberToWords.convert(totalVND.setScale(2));
        // } else {
        //     readTotalAmountVND = '- ' +EnglishNumberToWords.convert((0-totalVND).setScale(2));
        // }
        // readTotalAmountVND = EnglishNumberToWords.convert(totalVND.setScale(2));

        //get Invoice No
        String strSelect1 = 'SELECT ' + String.join(new List<String>(fieldsBillQuery), ',');
        String strFrom1 = ' FROM FTMSBill__c ';
        String strOrderBy1 = ' ORDER BY Name';
        String query1 = strSelect1 + strFrom1 +strOrderBy1; 

        List<FTMSBill__c> lstBill1 = Database.query(query1);
        List<String> numberPointDebit = new List<String>();
        List<String> numberPointCredit = new List<String>();
        Integer maxDebit = 0;
        Integer maxCredit = 0;
        String months = String.valueOf(today.month());
        if(Integer.valueOf(today.month()) < 10){
            months = '0' + months;
        }
        String yearMonth = String.valueOf(today.year()).substring(2) + months;
        for(FTMSBill__c bill1 : lstBill1){
            if(bill1.OutboundVATInvNo__c != null && bill1.MMYY_Debit__c == yearMonth){
                String endPointDebit = bill1.Debit_check__c;
                numberPointDebit.add(endPointDebit);
            } 
            if(bill1.InvNoonCreditfromCompany__c != null && bill1.MMYY_Credit__c == yearMonth){
                String endPointCredit = bill1.Credit_Check__c;
                numberPointCredit.add(endPointCredit);
            }  
        }        
        for(Integer i = 0; i < numberPointDebit.size(); i++){
            if(Integer.valueOf(numberPointDebit[i]) > maxDebit){
                maxDebit = Integer.valueOf(numberPointDebit[i]);
            }
        }
        for(Integer i = 0; i < numberPointCredit.size(); i++){
            if(Integer.valueOf(numberPointCredit[i]) > maxCredit){
                maxCredit = Integer.valueOf(numberPointCredit[i]);
            }
        }
        invoiceNoDebit = 'ASAP' + '-DN-' + yearMonth +'-'+String.valueOf((maxDebit+1)).leftPad(3, '0');
        invoiceNoCredit = 'ASAP' + '-CN-' + yearMonth +'-'+String.valueOf((maxCredit+1)).leftPad(3, '0');
        //if (totalDebitUSD >= totalCreditUSD){
        //    InvoiceNoDisplay = invoiceNoDebit;
        //    title = 'INVOICE';

        //} else {
        //    InvoiceNoDisplay = invoiceNoCredit;
        //    title = 'CREDIT';
        //}
        System.debug('123 :' + totalDebitUSDchangeToVND + totalDebitVND);
        System.debug('125 :' + totalCreditUSD);
        if((totalCreditUSD != 0 || totalDebitUSD != 0) && totalCreditVND == 0 && totalDebitVND == 0){
            if (totalDebitUSD >= totalCreditUSD){
                InvoiceNoDisplay = invoiceNoDebit;
                title = 'INVOICE';
    
            } else {
                InvoiceNoDisplay = invoiceNoCredit;
                title = 'CREDIT';
            }
        }
        if((totalCreditVND != 0 || totalDebitVND != 0) && totalCreditUSD == 0 && totalDebitUSD == 0 && totalCreditUSDchangeToVND == 0 && totalDebitUSDchangeToVND == 0){
            if (totalDebitVND >= totalCreditVND){
                InvoiceNoDisplay = invoiceNoDebit;
                title = 'INVOICE';
    
            } else {
                InvoiceNoDisplay = invoiceNoCredit;
                title = 'CREDIT';
            }
        }
        if((totalCreditVND != 0 || totalDebitVND != 0) && (totalCreditUSD != 0 || totalDebitUSD != 0)){
            if ((totalDebitUSDchangeToVND + totalDebitVND) >= (totalCreditUSDchangeToVND + totalCreditVND)){
                InvoiceNoDisplay = invoiceNoDebit;
                title = 'INVOICE';
    
            } else {
                InvoiceNoDisplay = invoiceNoCredit;
                title = 'CREDIT';
            }
        }
        if (InvoiceValue != 'none'){
            InvoiceNoDisplay = InvoiceValue;
        }
    }

    public PageReference saveOnchangeApex(){ 
        return null;  
    }

    public PageReference updateDebitNo(){
        // String debitNo = ApexPages.currentPage().getParameters().get('debitNo');
        String billIds = ApexPages.currentPage().getParameters().get('BillId');
        String shipID = ApexPages.currentPage().getParameters().get('id');
        List<String> lstBillIds = new List<String>();
        if(!String.isBlank(billIds)){
            lstBillIds = billIds.split(',');
        }
        String strSelect = 'SELECT ' + String.join(new List<String>(fieldsBillQuery), ',');
        String strFrom = ' FROM FTMSBill__c ';
        String strWhere = 'WHERE FTMSSO__c = \'' + shipID + '\'';
        if(lstBillIds.size() > 0){
           strWhere += ' AND Id IN : lstBillIds';
        }
        // String strOrderBy = ' ORDER BY clofor_com_cfs__SeikyuBangou__c ';
        String query = strSelect + strFrom + strWhere;  
        List<FTMSBill__c> lstBill = Database.query(query);
        for (FTMSBill__c bill : lstBill){
            // if (debitNo != ''){
                bill.OutboundVATInvNo__c = 'debitNo';
            // }
        }
        update lstBill;
        return null;
    }

    private FTMSSO__c getShipment(String shipId){
        String strSelect = String.join(new List<String>(fieldsShipQuery), ',');
        String strQuery = 'SELECT ' + strSelect 
                    + ' FROM FTMSSO__c'
                    + ' WHERE Id = \'' + String.escapeSingleQuotes(shipId) + '\'';
        System.debug('1123: ' + strQuery);
        FTMSSO__c ship;
        try{
            ship = Database.query(strQuery);
        } catch(QueryException e){
            ship = new FTMSSO__c();
        }
        return ship;
    }

    private List<FTMSBill__c> getListBill(String cusId, String InvoiceValue){
        String strSelect = String.join(new List<String>(fieldsBillQuery), ',');
        String strQuery = 'SELECT ' + strSelect 
                    + ' FROM FTMSBill__c'
                    + ' WHERE (InvoiceTo__c = \'' + cusId + '\' OR '+ 'PaymentTo__c = \'' + cusId + '\') ';

        String strWhere = '';
        if(lstAnken.size() > 0){
            strWhere += ' AND Id IN : lstAnken';
        } 
        else{
            // strWhere += ' AND OutboundVATInvNo__c = \'' + String.escapeSingleQuotes(InvoiceValue) + '\'';
            strWhere += ' AND (OutboundVATInvNo__c = \'' + String.escapeSingleQuotes(InvoiceValue) + '\' OR InvNoonCreditfromCompany__c = \''+String.escapeSingleQuotes(InvoiceValue)+'\')';

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

    public class BillWrapper {
        public String  serviceName{get;set;}
        public String  shipId{get;set;}
        public String  HBL{get;set;}
        public Decimal  quantity{get;set;}
        public Decimal  unitPrice{get;set;}
        public Decimal  amountDebitVND{get;set;}
        public Decimal  amountDebitUSD{get;set;}
        public Decimal  amountCreditVND{get;set;}
        public Decimal  amountCreditUSD{get;set;}
        public Decimal  amountCreditUSDchangeToVND{get;set;}
        public Decimal  amountDebitUSDchangeToVND{get;set;}
        public String  chargeUnit{get;set;}
        public String  curr{get;set;}
        public BillWrapper(){
            serviceName = '';
            shipId = '';
            quantity = 0;
            unitPrice = 0;
            amountDebitVND = 0;
            amountCreditVND = 0;
            amountDebitUSD = 0;
            amountCreditUSD = 0;
            amountCreditUSDchangeToVND = 0;
            amountDebitUSDchangeToVND = 0;
            chargeUnit = '';
            curr = '';
        }
    }

    public class ShipmentWrapper {
        // public RouterDataWapper(){}
        public String shipId{get;set;}
        public String HBL{get;set;}
        public Decimal totalDebitVND{get;set;}
        public Decimal totalDebitUSD{get;set;}
        public Decimal totalCreditVND{get;set;}
        public Decimal totalCreditUSD{get;set;}
        public Decimal totalCreditUSDchangeToVND{get;set;}
        public Decimal totalDebitUSDchangeToVND{get;set;}
        public List<BillWrapper> listBill {get;set;}
        public ShipmentWrapper() {
            shipId ='';
            HBL = '';
            totalDebitVND = 0;
            totalDebitUSD = 0;
            totalCreditVND = 0;
            totalCreditUSD = 0;
            totalCreditUSDchangeToVND = 0;
            totalDebitUSDchangeToVND = 0;
            listBill = new List<BillWrapper>();    
        }
    }
}