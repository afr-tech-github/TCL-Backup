public with sharing class InvoiceSOSelectionController {
    public FTMSSO__c shipment {get; set;}
    public FTMSBill__c billing {get; set;}
    public FTMSBill__c billing2 {get; set;}
    public FTMSBill__c customer {get; set;}
    public List<FTMSBill__c> lstbill {get; set;}
    public List<ResultWrapper> arrResult {get; set;}
    public List<FTMSBill__c> arrResult2 {get; set;}
    public List<ResultWrapper> arrResult3 {get; set;}
    public List<ResultWrapper2> arrResult4 {get; set;}
    public ResultWrapper arrResult1 {get; set;}
    public Set<String> listOubound {get; set;}
    public List<String> listOubound2 {get; set;}
    public Date today {get; set;}

    public String strQuery {get; set;}
    public String strQueryBill {get; set;}
    public String strQueryBilling {get; set;}
    public String strQueryBill2 {get; set;}
    public String strQueryBill3 {get; set;}
    public String reportType{get;set;}
    public String ContainerDetail {get;set;}
    

    //AgentID
    public String agentID {get; set;}
    public List<FTMSSO__c> listShip {get; set;}
    public List<String> lstIDship {get;set;}

    public String shipmentID {get; set;}
    public String shipID {get; set;}
    public String InvoiceValue {get; set;}
    public String customerValue {get; set;}
    public Date printDate {get; set;}
    public Decimal rowcount {get;set;}
    public String foreignCur {get; set;}
    public String localCur {get; set;}
    public String IdCustomFirst {get;set;}
    public String Form {get;set;}
    
    public String strQueryCustomer {get;set;}
    

    private static Set<String> setFields = new Set<String>();
    private static Set<String> setFieldsBill = new Set<String>();


    public Map<String, String> translations{get; set;}
    public String language{get; set;}
    public String docType{get; set;}
    public Boolean requiredAttachmentCreation{get; set;}
    public String ouboundValue{get; set;}
    public String currencyType{get; set;}
    public String customerId{get;set;}
    public String ouboundId{get;set;}
    public String companyjapan{get;set;}
    public String bankType{get;set;}
    public String templateType{get;set;}
    public String fileType{get;set;}
    public String attachName{get;set;}
    public Boolean Draft{get; set;}
    public Boolean Official{get; set;}
    public String InvoiceNo {get;set;}
    public String formno {get;set;}

    public String title {get;set;}
    public String agentName {get;set;}
 

    static{

        setFields.add('Name');
        setFields.add('RecordTypeId');
        setFields.add('Id');
        // setFields.add('MAgent__r.AccountNameENG__c');
        // setFields.add('MAgent__r.EnglishAddress__c');
        // setFields.add('FileNo__c');
        // setFields.add('VesselFlight__c');
        // setFields.add('Voyage__c');
        // setFields.add('ETD__c');
        // setFields.add('MPOL__r.Name');
        // setFields.add('MPOD__r.Name');
        // setFields.add('MBLorMAWBNumber__c');
    }

    static{
        setFieldsBill.add('Name');
        setFieldsBill.add('InvoiceTo__r.Name');
        setFieldsBill.add('PaymentTo__r.Name');
        setFieldsBill.add('OutboundVATInvNo__c');
        setFieldsBill.add('OutboundInvDate__c');
        setFieldsBill.add('BillNameatPrintENG__c');
        setFieldsBill.add('ChargeQuantity__c');
        setFieldsBill.add('ChargeUnit__c');
        setFieldsBill.add('CurrencySelling__c');
        setFieldsBill.add('TaxRateSelling__c');
        setFieldsBill.add('TotalAmountofSellingFCY__c');
        setFieldsBill.add('TotalSellingInclTaxFCY__c');
        setFieldsBill.add('TotalAmountofSellingLocal__c');
        setFieldsBill.add('TotalSellingInclTaxLocal__c');
        setFieldsBill.add('MMYY_Debit__c');
        setFieldsBill.add('Debit_check__c');
        setFieldsBill.add('CompanyCreditDate__c');
        setFieldsBill.add('InvNoonCreditfromCompany__c');
        setFieldsBill.add('Credit_Check__c');
        setFieldsBill.add('MMYY_Credit__c');
        setFieldsBill.add('InvoiceTo__c');
        setFieldsBill.add('PaymentTo__c');
        setFieldsBill.add('TotalBuyingInclTaxFCY__c');
        setFieldsBill.add('TotalAmountofBuyingFCY__c');
        setFieldsBill.add('CurrencyBuying__c');
        setFieldsBill.add('FTMSSO__c');
        setFieldsBill.add('FTMSSO__r.HBLNumber__c');
        setFieldsBill.add('Service__r.Name');
        setFieldsBill.add('UnitPriceofSellingLocal__c');
        setFieldsBill.add('UnitPriceofBuyingLocal__c');
        setFieldsBill.add('UnitPriceFCY__c');
        setFieldsBill.add('UnitPriceofBuyingFCY__c');
        setFieldsBill.add('ExchangeRateSelling__c');
        setFieldsBill.add('ExchangeRateBuying__c');
        setFieldsBill.add('ContainerType__c');
    }
    public InvoiceSOSelectionController() {
        // System.debug('1DEBUG:' + UserInfo.getLanguage()) ;
        shipmentID = ApexPages.currentPage().getParameters().get('id');
        agentID = ApexPages.currentPage().getParameters().get('agentId');
        // System.debug('shipID :'+shipID);
        shipment = new FTMSSO__c();
        arrResult = new List<ResultWrapper>();
        arrResult2 = new List<FTMSBill__c>();
        arrResult3 = new List<ResultWrapper>();
        arrResult4 = new List<ResultWrapper2>();
        lstbill = new List<FTMSBill__c>();
        listShip = new List<FTMSSO__c>();
        billing = new FTMSBill__c();
        billing2 = new FTMSBill__c();
        strQuery = '';
        strQueryBill = '';
        strQueryBilling = '';
        strQueryBill2 = '';
        strQueryBill3 = '';
        ContainerDetail = '';
        ouboundValue = '';
        InvoiceValue = '';
        formno = '';
        // Draft = true;
        listOubound = new Set<String>();
        listOubound2 = new List<String>();
        rowcount = 0;
        // printDate = System.today();
        today = Date.today();
        String temp;
        String temp2;
        InvoiceValue = ApexPages.currentPage().getParameters().get('Invoice');
        System.debug('InvoiceValue :'+InvoiceValue);
        customerValue = ApexPages.currentPage().getParameters().get('customerValue');
        // System.debug('customerValue :'+customerValue);
        formno = ApexPages.currentPage().getParameters().get('InvoiceNo');
        // String temp = String.valueOf([Select InvoiceTo__c From FTMSBill__c where FTMSSO__c =: shipmentID ORDER By Name LIMIT 1]);
        // lstIDship = new List<String>();
        // listShip = [SELECT Id, Name FROM FTMSSO__c WHERE ConsolidationID__c =: shipmentID];
        // for (FTMSSO__c ship : listShip){
        //     lstIDship.add('\''+ship.Id+'\'');
        // }
        String queryShip = stringQueryShipment(shipmentID);
        shipment = Database.query(queryShip);
        // agentName = shipment.MAgent__r.AccountNameENG__c;
        strQueryBill = stringQueryBill(shipmentID,customerValue);
        System.debug('queryBill: '+ strQueryBill);
        List<FTMSBill__c> bills = new List<FTMSBill__c>();
        try {
            bills = Database.query(strQueryBill);
        } catch (QueryException e) {
            bills = new List<FTMSBill__c>();
        }
        // List<FTMSBill__c> bills = Database.query(strQueryBill);
        arrResult2 = bills;
        System.debug('lstBill: '+ arrResult2);
    }

    
    public void updateDebitNo(){
        
        String shipID = ApexPages.currentPage().getParameters().get('id');
        String billIds = ApexPages.currentPage().getParameters().get('strAkens');
        System.debug('111'+billIds);
        String customerValue = ApexPages.currentPage().getParameters().get('customerValue');
        System.debug('customerValue :'+customerValue);
        String official = ApexPages.currentPage().getParameters().get('checkOfficial');
        System.debug('121: '+official);
        List<String> lstBillIds = new List<String>();
        if(!String.isBlank(billIds)){
            lstBillIds = billIds.split(',');         
        }

        String strSelect = 'SELECT ' + String.join(new List<String>(setFieldsBill), ',');
        String strFrom = ' FROM FTMSBill__c ';
        String strWhere = 'WHERE FTMSSO__c = \'' + shipID  +  '\' AND Id IN : lstBillIds';
        String strOrderBy = ' ORDER BY Name';
        String query = strSelect + strFrom + strWhere +strOrderBy;  

        String strSelect1 = 'SELECT ' + String.join(new List<String>(setFieldsBill), ',');
        String strFrom1 = ' FROM FTMSBill__c ';
        // String strWhere = 'WHERE FTMSSO__c = \'' + shipmentId + '\'' +  ' AND Id IN : lstBillIds';
        String strOrderBy1 = ' ORDER BY Name';
        String query1 = strSelect1 + strFrom1 +strOrderBy1; 

        List<FTMSBill__c> lstBill = Database.query(query);
        List<FTMSBill__c> lstBill1 = Database.query(query1);
        List<BillWrapper> listBillWrapper = new List<BillWrapper>();
        List<ShipmentWrapper> listShipWrapper = new List<ShipmentWrapper>();
        Decimal AmountSellingFCY = 0;
        Decimal AmountSellinglocal = 0;
        Decimal AmountSellingInclFCY = 0;
        Decimal AmountSellingInclLocal = 0;
        Decimal AmountTaxSellingFCY = 0;
        Decimal AmountTaxSellingLocal = 0;
        Decimal totalVND =0;
        Decimal totalUSD =0;
        Decimal totalCreditUSD =0;
        Decimal totalDebitUSD =0;
        Decimal totalCreditVND =0;
        Decimal totalDebitVND =0;
        Decimal totalDebitUSDchangeToVND = 0;
        Decimal totalCreditUSDchangeToVND = 0;
        String InvoiceNoDisplay = '';

        List<FTMSBill__c> lstBillUpdate = new List<FTMSBill__c>();
        
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

       
        // List<FTMSBill__c> lstBillUpdate = new List<FTMSBill__c>();
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
        System.debug('123 :' + totalDebitUSD);
        System.debug('125 :' + totalCreditUSD);
        
        if((totalCreditUSD != 0 || totalDebitUSD != 0) && totalCreditVND == 0 && totalDebitVND == 0){
            if (totalDebitUSD >= totalCreditUSD){
                InvoiceNoDisplay = invoiceNoDebit;
                // title = 'INVOICE';
    
            } else {
                InvoiceNoDisplay = invoiceNoCredit;
                // title = 'CREDIT';
            }
        }
        if((totalCreditVND != 0 || totalDebitVND != 0) && totalCreditUSD == 0 && totalDebitUSD == 0 && totalCreditUSDchangeToVND == 0 && totalDebitUSDchangeToVND == 0){
            if (totalDebitVND >= totalCreditVND){
                InvoiceNoDisplay = invoiceNoDebit;
                // title = 'INVOICE';
    
            } else {
                InvoiceNoDisplay = invoiceNoCredit;
                // title = 'CREDIT';
            }
        }
        if((totalCreditVND != 0 || totalDebitVND != 0) && (totalCreditUSD != 0 || totalDebitUSD != 0)){
            if ((totalDebitUSDchangeToVND + totalDebitVND) >= (totalCreditUSDchangeToVND + totalCreditVND)){
                InvoiceNoDisplay = invoiceNoDebit;
                // title = 'INVOICE';
    
            } else {
                InvoiceNoDisplay = invoiceNoCredit;
                // title = 'CREDIT';
            }
        }
        //if (totalDebitUSD >= totalCreditUSD){
        //    InvoiceNoDisplay = invoiceNoDebit;
            // title = 'INVOICE';

        //} else {
        //    InvoiceNoDisplay = invoiceNoCredit;
            // title = 'CREDIT';
        //}
        // if (InvoiceValue != 'none'){
        //     InvoiceNoDisplay = InvoiceValue;
        // }
        for(FTMSBill__c bill : lstBill){
            if(bill.InvoiceTo__c == customerValue && bill.OutboundVATInvNo__c == null && InvoiceNoDisplay != InvoiceValue){
                bill.OutboundVATInvNo__c = InvoiceNoDisplay;
                bill.OutboundInvDate__c = today;
                lstBillUpdate.add(bill);
                System.debug('11 :' + InvoiceNoDisplay);
            }
            if(bill.PaymentTo__c == customerValue && bill.InvNoonCreditfromCompany__c == null && InvoiceNoDisplay != InvoiceValue){
                bill.InvNoonCreditfromCompany__c = InvoiceNoDisplay;
                bill.CompanyCreditDate__c = today;
                lstBillUpdate.add(bill);
                System.debug('12 :' + InvoiceNoDisplay);
            }
        }
        // String First = '';
        // for(FTMSBill__c bill : lstBill){
        //     // if(bill.InvoiceTo__c == shipment.MAgent__c){
        //     //     First = '-DN-';
        //     // }
        //     // else{
        //     //     First = '-CN-';
        //     // }
        //     // if(Integer.valueOf(today.month()) < 10){
        //     //     months = '0' + months;
        //     // }
        //     // if(bill.OutboundVATInvNo__c == null){ASAP-CN-2305-006
        //     //     if(max <10){
        //     //         bill.OutboundVATInvNo__c = 'ASAP' + First + yearMonth +'-'+ '00' +(max+1);
        //     //         bill.OutboundInvDate__c = today;
        //     //     }
        //     //     else{
        //     //         bill.OutboundVATInvNo__c = 'ASAP' + First + yearMonth +'-'+ '0' +(max+1);
        //     //         bill.OutboundInvDate__c = today;
        //     //     }
        //     // }
        //     if(bill.InvoiceTo__c == customerValue){
        //         First = '-DN-';
        //         if(bill.OutboundVATInvNo__c == null){
        //             bill.OutboundVATInvNo__c = 'ASAP' + First + yearMonth +'-'+String.valueOf((maxDebit+1)).leftPad(3, '0');
        //             bill.OutboundInvDate__c = today;
        //             lstBillUpdate.add(bill);
        //         }
        //     } else if(bill.PaymentTo__c == customerValue){
        //         First = '-CN-';
        //         if(bill.InvNoonCreditfromCompany__c == null){
        //             bill.InvNoonCreditfromCompany__c = 'ASAP' + First + yearMonth +'-'+String.valueOf((maxCredit+1)).leftPad(3, '0');
        //             bill.CompanyCreditDate__c = today;
        //             lstBillUpdate.add(bill);
        //         }
        //     }
            
        // }
        if(official == 'true' && lstBillUpdate.size()>0){

            update lstBillUpdate;  
        }
        // return null;
    }


    public PageReference closePopupDialog() {
        PageReference page = new PageReference('/'+shipmentID);
        page.setRedirect(true);
        return page;
    } 

    public List<SelectOption> getTitleList(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('none', '-- None --'));
        options.add(new SelectOption('invoice', 'Invoice'));
        options.add(new SelectOption('debit', 'Debit Note'));
        // options.add(new SelectOption('credit', 'Credit Note'));
        return options;
    }

    public List<SelectOption> getOuboundList(){
        // String customerValue = ApexPages.currentPage().getParameters().get('customerValue');
        String strQueryBill = stringQueryBillforInvoiceNo(shipmentID,customerValue);
        List<FTMSBill__c> bills = new List<FTMSBill__c>();
        try {
            bills = Database.query(strQueryBill);
        } catch (QueryException e) {
            bills = new List<FTMSBill__c>();
        }
        // List<FTMSBill__c> bills = Database.query(strQueryBill);
        System.debug('1123: ' + bills);
        List<SelectOption> options = new List<SelectOption>();
        if(!String.isBlank(InvoiceValue)){
            ouboundId = InvoiceValue;      
        }    
        options.add(new SelectOption('none', '-- None -- '));

        Set<String> ouboundNo = new Set<String>();
        arrResult2 = bills;
        for(FTMSBill__c bill: bills){
            if (customerValue != null && customerValue != 'none'){
                if (bill.InvoiceTo__c == customerValue){
                    if(!String.isBlank(bill.OutboundVATInvNo__c)){
                        if(!ouboundNo.contains(bill.OutboundVATInvNo__c)) {
                            ouboundNo.add(bill.OutboundVATInvNo__c);
                            options.add(new SelectOption(bill.OutboundVATInvNo__c,bill.OutboundVATInvNo__c));
                        }
                    }
                }
                if (bill.PaymentTo__c == customerValue){
                    if(!String.isBlank(bill.InvNoonCreditfromCompany__c)){
                        if(!ouboundNo.contains(bill.InvNoonCreditfromCompany__c)) {
                            ouboundNo.add(bill.InvNoonCreditfromCompany__c);
                            options.add(new SelectOption(bill.InvNoonCreditfromCompany__c,bill.InvNoonCreditfromCompany__c));
                        }
                    }
                }
            } else {
                if(!String.isBlank(bill.OutboundVATInvNo__c)){
                    if(!ouboundNo.contains(bill.OutboundVATInvNo__c)) {
                        ouboundNo.add(bill.OutboundVATInvNo__c);
                        options.add(new SelectOption(bill.OutboundVATInvNo__c,bill.OutboundVATInvNo__c));
                    }
                }
                if(!String.isBlank(bill.InvNoonCreditfromCompany__c)){
                    if(!ouboundNo.contains(bill.InvNoonCreditfromCompany__c)) {
                        ouboundNo.add(bill.InvNoonCreditfromCompany__c);
                        options.add(new SelectOption(bill.InvNoonCreditfromCompany__c,bill.InvNoonCreditfromCompany__c));
                    }
                }
            }           
        }
        return options;
    }

    public List<SelectOption> getCustomerList(){
        
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('none', '-- select -- '));
        List<FTMSBill__c> bills = [SELECT Id, InvoiceTo__c, InvoiceTo__r.Name, PaymentTo__c, PaymentTo__r.Name
                                        FROM FTMSBill__c
                                        WHERE FTMSSO__c =: shipmentID
                                        ORDER BY Name];
        Set<Id> customerIds = new Set<Id>();

        for(FTMSBill__c bill: bills){
            If(!String.isBlank(bill.InvoiceTo__c)){
                // IdCustomFirst = bill.InvoiceTo__c;
                customerId = bill.InvoiceTo__r.Name;
                if(!String.isBlank(customerValue)){
                    customerId = customerValue;      
                }   
            }
            If(!String.isBlank(bill.PaymentTo__c)){
                // IdCustomFirst = bill.InvoiceTo__c;
                customerId = bill.PaymentTo__r.Name;
                if(!String.isBlank(customerValue)){
                    customerId = customerValue;      
                }   
            }
        }
         for(FTMSBill__c bill: bills){
            if(!String.isBlank(bill.InvoiceTo__c) && !customerIds.contains(bill.InvoiceTo__c)){
                options.add(new SelectOption(bill.InvoiceTo__c, bill.InvoiceTo__r.Name));  
                customerIds.add(bill.InvoiceTo__c);  
            }
            if(!String.isBlank(bill.PaymentTo__c) && !customerIds.contains(bill.PaymentTo__c)){
                options.add(new SelectOption(bill.PaymentTo__c, bill.PaymentTo__r.Name));  
                customerIds.add(bill.PaymentTo__c);  
            }
         }
        System.debug('Debugggg :'+customerIds);
        return options;
    }
   

    private String stringQueryShipment(String shipmentId){
        String strSelect = 'SELECT RecordType.Name,' + String.join(new List<String>(setFields), ',');
        String strFrom = ' FROM FTMSSO__c ';
        String strWhere = 'WHERE Id = \'' + shipmentId + '\'' ;
        String strOrderBy = ' ORDER BY Name LIMIT 1';
        return strSelect + strFrom + strWhere + strOrderBy;
    }
    private String stringQueryBill(String shipmentId,String customerValue){
        String strSelect = 'SELECT ' + String.join(new List<String>(setFieldsBill), ',');
        String strFrom = ' FROM FTMSBill__c ';
        String strWhere;
        strWhere = 'WHERE FTMSSO__c = \'' + shipmentId + '\'';
        if (customerValue != null && customerValue != 'none'){
            strWhere += ' AND (InvoiceTo__c = \'' + customerValue + '\' OR PaymentTo__c = \''+customerValue+'\')';
        }
        if (InvoiceValue != null && InvoiceValue != 'none'){
            strWhere += ' AND (OutboundVATInvNo__c = \'' + InvoiceValue + '\' OR InvNoonCreditfromCompany__c = \''+InvoiceValue+'\')';
        }
        // String strOrderBy = ' ORDER BY clofor_com_cfs__SeikyuBangou__c';
        return strSelect + strFrom + strWhere ; 
    }
    private String stringQueryBillforInvoiceNo(String shipmentId,String customerValue){
        String strSelect = 'SELECT ' + String.join(new List<String>(setFieldsBill), ',');
        String strFrom = ' FROM FTMSBill__c ';
        String strWhere;
        strWhere = 'WHERE FTMSSO__c = \'' + shipmentId + '\'';
        if (customerValue != null && customerValue != 'none'){
            strWhere += ' AND (InvoiceTo__c = \'' + customerValue + '\' OR PaymentTo__c = \''+customerValue+'\')';
        }
        // String strOrderBy = ' ORDER BY clofor_com_cfs__SeikyuBangou__c';
        return strSelect + strFrom + strWhere ; 
    }

    public class ResultWrapper{
        public FTMSBill__c bill {get; set;}
        public Integer Index {get; set;}
        public String ServiceName {get;set;}
        public String ChargeUnit {get;set;}
        public String Curr {get;set;}
        public Decimal TaxInitial {get;set;}
        public Decimal SellInTaxAmount {get;set;}
        public String OutboundInvoiceNo {get;set;}
        public Decimal SellTankaJPY {get; set;}
        public Decimal SellTankaUSD {get; set;}
        public Decimal SellAmountJPN {get; set;}
        public Decimal Quantity {get; set;}
        public ResultWrapper(){
            this.bill = new FTMSBill__c();
            this.Index = 0;
            this.ServiceName = '';
            this.ChargeUnit = '';
            this.Curr = '';
            this.TaxInitial = 0;
            this.SellInTaxAmount = 0;
            this.OutboundInvoiceNo = '';
            SellTankaUSD = 0;
            SellTankaJPY = 0;
            SellAmountJPN = 0;
            Quantity = 0;
        }
    }

    public class ResultWrapper2{
        // public FTMSBill__c bill2 {get; set;} {}
        public String Id {get;set;}
        public Integer Index2 {get; set;}
        public String ServiceName2 {get;set;}
        public String ChargeUnit2 {get;set;}
        public String Curr2 {get;set;}
        public Decimal TaxInitial2 {get;set;}
        public Decimal SellInTaxAmount2 {get;set;}
        public String OutboundInvoiceNo2 {get;set;}
        public Decimal SellTankaJPY2 {get; set;}
        public Decimal SellTankaUSD2 {get; set;}
        public Decimal SellAmountJPN2 {get; set;}
        public Decimal Quantity2 {get; set;}
        public ResultWrapper2(){
            // this.bill2 = new FTMSBill__c();
            this.Id = '';
            this.Index2 = 0;
            this.ServiceName2 = '';
            this.ChargeUnit2 = '';
            this.Curr2 = '';
            this.TaxInitial2 = 0;
            this.SellInTaxAmount2 = 0;
            SellTankaUSD2 = 0;
            SellTankaJPY2 = 0;
            SellAmountJPN2 = 0;
            Quantity2 = 0;
            this.OutboundInvoiceNo2 = '';
        }
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