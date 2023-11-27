public with sharing class ProfitStatementController_V2 {
    public FTMSSO__c shipment {get; set;}
    public CompanyInformation__c CompanyInfo {get; set;}
    public CntrinTrans__c CNTR {get;set;}
    public List<FTMSBill__c> lstBill {get; set;}

    public String strQuerySO {get;set;}
    public String strQueryCompanyInfo {get;set;}
    public String strQueryBill {get;set;}
    public String strQueryCNTR {get;set;}
    public String shipmentId {get; set;}
    public String MAWB_MBL {get;set;}
    public String testCok {get;set;}

    public List<ResultWrapper> lstBillInvoice {get; set;}
    public List<ResultWrapper> lstBillPayment {get; set;}
    public List<ResultWrapper> lstBillBoth {get; set;}

    public List<ResultWrapperAgent> lstBillAgent {get; set;}

    public List<ResultWrapper> lstBillInvoice2 {get; set;}
    public List<ResultWrapper> lstBillPayment2 {get; set;}
    public List<ResultWrapper> lstBillBoth2 {get; set;}

    public List<ResultWrapper> lstInvoice {get; set;}
    public List<ResultWrapper> lstPayment {get; set;}
    public List<ResultWrapper> lstBoth1 {get; set;}
    public List<ResultWrapper> lstBoth2 {get; set;}

    public List<ResultWrapperCompany> lstComInvoice {get; set;}
    public List<ResultWrapperCompany> lstComPayment {get; set;}
    public List<ResultWrapperCompany> lstComBoth {get; set;}

    public Set<String> listIdChartInvoice {get; set;}
    public Set<String> listIdChartPayment {get; set;}
    public Set<String> listIdChartBoth {get; set;}

    public Decimal TotalCosting {get;set;}
    public Decimal TotalBilling {get;set;}
    public Decimal Profit {get;set;}
    public String TextSum {get;set;}
    public String UserName {get;set;}
    public String HBLnumber {get;set;}
    public String CustomerName {get;set;}

    private static Set<String> setFieldSO = new Set<String>();
    private static Set<String> setFieldCompanyInfo = new Set<String>();
    private static Set<String> setFieldBill = new Set<String>();
    private static Set<String> setFieldCNTR = new Set<String>();

    static{
        setFieldSO.add('JobRequestID__c');
        setFieldSO.add('CargoType__c');
        setFieldSO.add('GrossWeight__c');
        setFieldSO.add('Measurement__c');
        setFieldSO.add('agentnamefor__c');
        setFieldSO.add('POLAOD__r.Name');
        setFieldSO.add('PODAOA__r.Name');
        setFieldSO.add('POD_Formul__c');
        setFieldSO.add('POLformula__c');
        setFieldSO.add('VesselFlight__c');
        setFieldSO.add('Voyage__c');
        setFieldSO.add('MAWBNumber__c');
        setFieldSO.add('MBLNumber__c');
        setFieldSO.add('Name');
        setFieldSO.add('Branch__c');
        setFieldSO.add('CargoType__c');
        setFieldSO.add('GrossWeight__c');
        setFieldSO.add('MeasurementTotalCBM__c');
        setFieldSO.add('RecordType.Name');
        setFieldSO.add('TotalSellingInclTaxLocal__c');
        setFieldSO.add('TotalBuyingInclTaxLocal__c');
        setFieldSO.add('ProfitINCLTaxLocal__c');
        setFieldSO.add('HBLNumber__c');
        setFieldSO.add('HAWBNumber__c');
        setFieldSO.add('Customer__r.Name');
        setFieldSO.add('Agent__r.Name');
        setFieldSO.add('Agent2nd__r.Name');
        setFieldSO.add('AgentsdebitcreditNo__c');
        setFieldSO.add('TotalAmountofSellingLocal__c');
        setFieldSO.add('TotalAmountofBuyingLocal__c');
        setFieldSO.add('ProfitNICTaxLocal__c');
        setFieldSO.add('ContainerType1__c');
        setFieldSO.add('ContainerType2__c');
        setFieldSO.add('ContainerType3__c');
        setFieldSO.add('ContainerQuantity1__c');
        setFieldSO.add('ContainerQuantity2__c');
        setFieldSO.add('ContainerQuantity3__c');
        setFieldSO.add('Shipment_Type__c');
        setFieldSO.add('CarrierAirlinerVendor__r.Name');
        
        /////////////////////////////////////////////////
        setFieldCompanyInfo.add('Name');
        setFieldCompanyInfo.add('Address__c');
        setFieldCompanyInfo.add('Tel__c');
        setFieldCompanyInfo.add('Fax__c');
        ////////////////////////////////////////////////
        setFieldBill.add('BillNameatPrintENG__c');
        setFieldBill.add('CurrencyBuying__c');
        setFieldBill.add('CurrencySelling__c');
        setFieldBill.add('TotalAmountofBuyingFCY__c');
        setFieldBill.add('TotalAmountofBuyingLocal__c');
        setFieldBill.add('TotalAmountofSellingFCY__c');
        setFieldBill.add('TotalAmountofSellingLocal__c');
        setFieldBill.add('ExchangeRateBuying__c');
        setFieldBill.add('ExchangeRateSelling__c');
        setFieldBill.add('AmountBuyingInclTaxLocal__c');
        setFieldBill.add('AmountSellingInclTaxLocal__c');
        setFieldBill.add('ChargeUnit__c');
        setFieldBill.add('ContainerType__c');
        setFieldBill.add('InvoiceTo__r.RecordType.Name');
        setFieldBill.add('PaymentTo__r.RecordType.Name');
        setFieldBill.add('InvoiceTo__r.Name');
        setFieldBill.add('PaymentTo__r.Name');
        setFieldBill.add('InvoiceTo__c');
        setFieldBill.add('PaymentTo__c');
        setFieldBill.add('InboundVATINVNo__c');
        setFieldBill.add('OutboundVATInvNo__c');
        setFieldBill.add('InvNoonCreditfromCompany__c');
        setFieldBill.add('CreditNofromAgent__c');
        
        ////////////////////////////////////////////////
        setFieldCNTR.add('Container_Number__c');
        setFieldCNTR.add('Container_Type__c');
        setFieldBill.add('PaymentTo__r.Name');
    }
    public ProfitStatementController_V2() {
        shipmentId = ApexPages.currentPage().getParameters().get('id');
        System.debug('shipmentID : ' + shipmentId);
        shipment = new FTMSSO__c();
        CompanyInfo = new CompanyInformation__c();
        CNTR = new CntrinTrans__c();
        lstBill = new List<FTMSBill__c>();
        lstBillInvoice = new List<ResultWrapper>();
        lstBillPayment = new List<ResultWrapper>();
        lstBillBoth = new List<ResultWrapper>();

        lstBillAgent = new List<ResultWrapperAgent>();

        lstBillInvoice2 = new List<ResultWrapper>();
        lstBillPayment2 = new List<ResultWrapper>();
        lstBillBoth2 = new List<ResultWrapper>();

        listIdChartInvoice = new Set<String>();
        listIdChartPayment = new Set<String>();
        listIdChartBoth = new Set<String>();

        lstComInvoice = new List<ResultWrapperCompany>();
        lstComPayment = new List<ResultWrapperCompany>();
        lstComBoth = new List<ResultWrapperCompany>();
        List<String> CompanyName = new List<String>();
        List<String> listDNCNnumber = new List<String>();
        Set<String> setCompanyName = new Set<String>();
        Set<String> setDNCNnumber = new Set<String>();
        List<String> InvoiceName = new List<String>();
        List<String> PaymentName = new List<String>();

        List<FTMSBill__c> lstCompany = new List<FTMSBill__c>();
        lstInvoice = new List<ResultWrapper>();
        lstPayment = new List<ResultWrapper>();
        lstBoth1 = new List<ResultWrapper>();
        lstBoth2 = new List<ResultWrapper>();

        HBLnumber = '';
        CustomerName = '';
        strQuerySO = '';
        strQueryBill = '';
        strQueryCompanyInfo = '';
        strQueryCNTR = '';

        TotalBilling = 0;
        TotalCosting = 0;
        Profit = 0;
        TextSum = '';
        UserName = '';

        strQueryCNTR = stringQueryCNTR(shipmentId);
        strQuerySO = stringQuerySO(shipmentId);
        strQueryBill = stringQueryBill(shipmentId);

        shipment = Database.query(strQuerySO);
        System.debug('shipment ne :' + shipment);
        
        String branchName = '';
        branchName = shipment.Branch__c;
        strQueryCompanyInfo = stringQueryCompanyInfo(shipmentId, branchName);

        CompanyInfo = Database.query(strQueryCompanyInfo);
        System.debug('CompanyInfo ne :' + shipment);
        // CNTR = Database.query(strQueryCNTR);
        CntrinTrans__c lstCon;
        try{
            lstCon = Database.query(strQueryCNTR);
        } catch(QueryException e){
            lstCon = new CntrinTrans__c();
        }
        CNTR = lstCon;
        System.debug('CNTR ne :' + shipment);
        lstBill  = Database.query(strQueryBill);
        System.debug('lstBill ne: ' + lstBill);

        lstBillInvoice = getBillInvoice(strQueryBill);
        System.debug('BillInvoice: ' + lstBillInvoice);
        lstBillPayment = getBillPayment(strQueryBill);
        System.debug('BillPayment: ' + lstBillPayment);
        lstBillBoth = getBillBoth(strQueryBill);
        System.debug('BillBoth: ' + lstBillBoth);


        // HBLnumber = shipment.HBLNumber__c;
        if(shipment.RecordType.Name == 'Ocean Export' || shipment.RecordType.Name == 'Ocean Import'){
            HBLnumber = shipment.HBLNumber__c;
        }
        if(shipment.RecordType.Name == 'Air Export' || shipment.RecordType.Name == 'Air Import'){
            HBLnumber = shipment.HAWBNumber__c;
        }

        CustomerName = shipment.Customer__r.Name;

        System.debug('CusName : ' + CustomerName);
        

        for(ResultWrapper bill: lstBillInvoice){
            String invoice = bill.Companies;
            InvoiceName.add(invoice);
        }
        
        for(ResultWrapper bill: lstBillPayment){
            String payment = bill.Companies;
            PaymentName.add(payment);
        }
        System.debug('InvoiceName: ' + InvoiceName);
        for(FTMSBill__c bill : lstBill){
            String Company1 = '';
            String Company2 = '';
            if(bill.InvoiceTo__r.Name != null){
                
                Company1 = bill.InvoiceTo__r.Name;
                if(!setCompanyName.contains(Company1)){
                    CompanyName.add(Company1);
                    setCompanyName.add(Company1);
                }
                // CompanyName.add(Company1);
            }
            if(bill.PaymentTo__r.Name != null){
                Company2 = bill.PaymentTo__r.Name;
                if(!setCompanyName.contains(Company2)){
                    CompanyName.add(Company2);
                    setCompanyName.add(Company2);
                }
                // CompanyName.add(Company2);
            }
        }

        // for(integer i=0; i < CompanyName.size(); i++) {
        //     for(integer j=0; j < CompanyName.size(); j++) {                                         
        //         if(CompanyName[i] == CompanyName[j] && i != j) {
        //             CompanyName.remove(j); 
        //             }
        //         }              
        // }

        System.debug('Company Name : ' + CompanyName);
        
        integer i =0;
        for(ResultWrapper bill: lstBillInvoice){
            ResultWrapper item = new ResultWrapper();
            if(!PaymentName.contains(bill.Companies)){

                // item.BillName = bill.BillName;
                lstInvoice.add(bill);

                i++;   
            }
            else {
                lstBoth2.add(bill);
            }
        }
        System.debug('Count: ' + lstInvoice);
        integer j = 0;
        for(ResultWrapper bill: lstBillPayment){
            if(!InvoiceName.contains(bill.Companies)){
                lstPayment.add(bill);
                j++;
                System.debug('Count1: ' + j + bill.Companies);
            }
            else{
                lstBoth1.add(bill);
            }
        }
        System.debug('lstPayment: ' + lstPayment);
        integer k = 0;

        System.debug('Count21: ' + lstBoth1);
        System.debug('Count22: ' + lstBoth2);
        if(shipment.RecordType.Name == 'Ocean Export' || shipment.RecordType.Name == 'Ocean Import'){
            MAWB_MBL = shipment.MBLNumber__c;
        }
        if(shipment.RecordType.Name == 'Air Export' || shipment.RecordType.Name == 'Air Import'){
            MAWB_MBL = shipment.MAWBNumber__c;
        }

        for(FTMSBill__c bill : lstBill){
            if(bill.InvoiceTo__r.RecordType.Name == 'Vendor' || bill.InvoiceTo__r.RecordType.Name == 'Partner' || bill.InvoiceTo__r.RecordType.Name == 'Customer'){
                TotalBilling += bill.TotalAmountofSellingLocal__c;
            }
            if(bill.PaymentTo__r.RecordType.Name == 'Vendor' || bill.PaymentTo__r.RecordType.Name == 'Partner' || bill.PaymentTo__r.RecordType.Name == 'Customer'){
                TotalCosting += bill.TotalAmountofBuyingLocal__c;
            }
        }
        Profit = TotalBilling - TotalCosting;

        TextSum =  ReadNumberToWords.convert(math.abs(shipment.ProfitNICTaxLocal__c).setScale(2, System.RoundingMode.HALF_UP));
        UserName = UserInfo.getName();

        // InvoiceTo////////////////
        for(ResultWrapper inv : lstInvoice){
            listIdChartInvoice.add(inv.Companies);
        }

            for(String invv : listIdChartInvoice){
                ResultWrapperCompany invvv= new ResultWrapperCompany();
                invvv.CompanyName = invv;
                // String OutboundNo = '';
                for(FTMSBill__c bill :lstBill){      
                    if(invvv.CompanyName == bill.InvoiceTo__r.Name){
                        invvv.lstBillOfCompany.add(bill);
                        if(bill.InvoiceTo__r.Name == shipment.Agent__r.Name || bill.InvoiceTo__r.Name == shipment.Agent2nd__r.Name){
                            if(!setDNCNnumber.contains(bill.InboundVATINVNo__c)){
                                listDNCNnumber.add(bill.InboundVATINVNo__c);
                                setDNCNnumber.add(bill.InboundVATINVNo__c);
                            }
                            if(!setDNCNnumber.contains(bill.OutboundVATInvNo__c)){
                                listDNCNnumber.add(bill.OutboundVATInvNo__c);
                                setDNCNnumber.add(bill.OutboundVATInvNo__c);
                            }
                            if(!setDNCNnumber.contains(bill.InvNoonCreditfromCompany__c)){
                                listDNCNnumber.add(bill.InvNoonCreditfromCompany__c);
                                setDNCNnumber.add(bill.InvNoonCreditfromCompany__c);
                            }
                            if(!setDNCNnumber.contains(bill.CreditNofromAgent__c)){
                                listDNCNnumber.add(bill.CreditNofromAgent__c);
                                setDNCNnumber.add(bill.CreditNofromAgent__c);
                            }
                        }
                    }
                }
                lstComInvoice.add(invvv);
            }
            System.debug('lstComInvoice12 :'+lstComInvoice);
            
        // PaymentTo
        for(ResultWrapper inv : lstPayment){
            listIdChartPayment.add(inv.Companies);
        }
        System.debug('listIdChartPayment :'+listIdChartPayment);
        for(String invv : listIdChartPayment){
            ResultWrapperCompany invvv= new ResultWrapperCompany();
            invvv.CompanyName = invv;
            for(FTMSBill__c bill :lstBill){
                if(invvv.CompanyName == bill.PaymentTo__r.Name){
                    invvv.lstBillOfCompany.add(bill);

                    if(bill.PaymentTo__r.Name == shipment.Agent__r.Name || bill.PaymentTo__r.Name == shipment.Agent2nd__r.Name){
                        // OutboundNo = ;
                        // invvv.Inbound = bill.InboundVATINVNo__c;
                        if(!setDNCNnumber.contains(bill.InboundVATINVNo__c)){
                            listDNCNnumber.add(bill.InboundVATINVNo__c);
                            setDNCNnumber.add(bill.InboundVATINVNo__c);
                        }
                        if(!setDNCNnumber.contains(bill.OutboundVATInvNo__c)){
                            listDNCNnumber.add(bill.OutboundVATInvNo__c);
                            setDNCNnumber.add(bill.OutboundVATInvNo__c);
                        }
                        if(!setDNCNnumber.contains(bill.InvNoonCreditfromCompany__c)){
                            listDNCNnumber.add(bill.InvNoonCreditfromCompany__c);
                            setDNCNnumber.add(bill.InvNoonCreditfromCompany__c);
                        }
                        if(!setDNCNnumber.contains(bill.CreditNofromAgent__c)){
                            listDNCNnumber.add(bill.CreditNofromAgent__c);
                            setDNCNnumber.add(bill.CreditNofromAgent__c);
                        }
                    }
                }
                
            }
            lstComPayment.add(invvv);
        }
        System.debug('lstComPayment :'+lstComPayment);
        // Both
        for(ResultWrapper inv : lstBoth1){
            listIdChartBoth.add(inv.Companies);
        }
        for(ResultWrapper inv : lstBoth2){
            listIdChartBoth.add(inv.Companies);
        }
        
        for(String invv : listIdChartBoth){
            ResultWrapperCompany invvv= new ResultWrapperCompany();
            invvv.CompanyName = invv;
            for(FTMSBill__c bill :lstBill){
                if(invvv.CompanyName == bill.PaymentTo__r.Name){
                    invvv.lstBillOfCompany.add(bill);
                    if(bill.PaymentTo__r.Name == shipment.Agent__r.Name || bill.PaymentTo__r.Name == shipment.Agent2nd__r.Name){
                        // OutboundNo = ;
                        // invvv.Inbound = bill.InboundVATINVNo__c;
                        if(!setDNCNnumber.contains(bill.InboundVATINVNo__c)){
                            listDNCNnumber.add(bill.InboundVATINVNo__c);
                            setDNCNnumber.add(bill.InboundVATINVNo__c);
                        }
                        if(!setDNCNnumber.contains(bill.OutboundVATInvNo__c)){
                            listDNCNnumber.add(bill.OutboundVATInvNo__c);
                            setDNCNnumber.add(bill.OutboundVATInvNo__c);
                        }
                        if(!setDNCNnumber.contains(bill.InvNoonCreditfromCompany__c)){
                            listDNCNnumber.add(bill.InvNoonCreditfromCompany__c);
                            setDNCNnumber.add(bill.InvNoonCreditfromCompany__c);
                        }
                        if(!setDNCNnumber.contains(bill.CreditNofromAgent__c)){
                            listDNCNnumber.add(bill.CreditNofromAgent__c);
                            setDNCNnumber.add(bill.CreditNofromAgent__c);
                        }
                    }
                }
                if(invvv.CompanyName == bill.InvoiceTo__r.Name){
                    invvv.lstBillOfCompany.add(bill);
                    if(bill.InvoiceTo__r.Name == shipment.Agent__r.Name || bill.InvoiceTo__r.Name == shipment.Agent2nd__r.Name){
                        // OutboundNo = ;
                        // invvv.Outbound = bill.OutboundVATInvNo__c;
                        if(!setDNCNnumber.contains(bill.InboundVATINVNo__c)){
                            listDNCNnumber.add(bill.InboundVATINVNo__c);
                            setDNCNnumber.add(bill.InboundVATINVNo__c);
                        }
                        if(!setDNCNnumber.contains(bill.OutboundVATInvNo__c)){
                            listDNCNnumber.add(bill.OutboundVATInvNo__c);
                            setDNCNnumber.add(bill.OutboundVATInvNo__c);
                        }
                        if(!setDNCNnumber.contains(bill.InvNoonCreditfromCompany__c)){
                            listDNCNnumber.add(bill.InvNoonCreditfromCompany__c);
                            setDNCNnumber.add(bill.InvNoonCreditfromCompany__c);
                        }
                        if(!setDNCNnumber.contains(bill.CreditNofromAgent__c)){
                            listDNCNnumber.add(bill.CreditNofromAgent__c);
                            setDNCNnumber.add(bill.CreditNofromAgent__c);
                        }
                    }
                }
                
            }
            lstComBoth.add(invvv);
        }
        System.debug('lstComBoth :'+lstComBoth);
        System.debug('1226 :'+listDNCNnumber);
        System.debug('1236 :'+setDNCNnumber);

        for(String DNCNnumber : listDNCNnumber){
            if(DNCNnumber != null){
                ResultWrapperAgent agents = new ResultWrapperAgent();
                agents.DebitCredit = DNCNnumber;
                for(FTMSBill__c bill :lstBill){
                    if(bill.PaymentTo__r.Name == shipment.Agent__r.Name || bill.PaymentTo__r.Name == shipment.Agent2nd__r.Name){
                        if(bill.InboundVATINVNo__c == DNCNnumber|| bill.InvNoonCreditfromCompany__c == DNCNnumber ){
                            agents.lstBillOfAgent_PaymentTo.add(bill);
                        }
                    }
                    if(bill.InvoiceTo__r.Name == shipment.Agent__r.Name || bill.InvoiceTo__r.Name == shipment.Agent2nd__r.Name){
                        if(bill.OutboundVATInvNo__c == DNCNnumber|| bill.CreditNofromAgent__c == DNCNnumber ){
                            agents.lstBillOfAgent_InvoiceTo.add(bill);
                        }
                    }
                }
                lstBillAgent.add(agents);
            }
            else{
                ResultWrapperAgent agents = new ResultWrapperAgent();
                agents.DebitCredit = DNCNnumber;
                for(FTMSBill__c bill :lstBill){
                    if((bill.PaymentTo__c == shipment.Agent__c || bill.PaymentTo__c == shipment.Agent2nd__c) && bill.PaymentTo__c != null){
                        if(bill.InboundVATINVNo__c == null && bill.InvNoonCreditfromCompany__c == null ){
                            agents.lstBillOfAgent_PaymentTo_Null.add(bill);
                            System.debug('11 :' + bill);
                            
                        }
                    }
                    if((bill.InvoiceTo__c == shipment.Agent__c || bill.InvoiceTo__c == shipment.Agent2nd__c) && bill.InvoiceTo__c != null){
                        if(bill.OutboundVATInvNo__c == null && bill.CreditNofromAgent__c == null ){
                            agents.lstBillOfAgent_InvoiceTo_Null.add(bill);
                            System.debug('12 :' + bill  + ' ' + bill.InvoiceTo__r.Name);
                        }
                    }
                }
                lstBillAgent.add(agents);
            }
        }
        System.debug('1237 :'+lstBillAgent);
    }

   
    private List<ResultWrapper> getBillInvoice(String strQueryBill){
        List<ResultWrapper> results = new List<ResultWrapper>();
        List<FTMSBill__c> lstBill = new List<FTMSBill__c>();
        lstBill = Database.query(strQueryBill);

        For (FTMSBill__c bill: lstBill){
           
            ResultWrapper item = new ResultWrapper();

           if(bill.InvoiceTo__r.Name != null && bill.InvoiceTo__r.Name != ''){
            item.BillName = bill.BillNameatPrintENG__c;
            item.Companies = bill.InvoiceTo__r.Name;
            item.ChargeUint = bill.ChargeUnit__c;
            item.ContainerType = bill.ContainerType__c;
            item.AmountBuyingFCY = bill.TotalAmountofBuyingFCY__c;
            item.AmountBuyingLocal = bill.TotalAmountofBuyingLocal__c;
            item.CurrBuying = bill.CurrencyBuying__c;
            item.CurrSelling = bill.CurrencySelling__c;
            item.AmountSellingFCY = bill.TotalAmountofSellingFCY__c;
            item.AmountSellingLocal =bill.TotalAmountofSellingLocal__c;
            item.ExRateBuying = bill.ExchangeRateBuying__c;
            item.ExRateSelling = bill.ExchangeRateSelling__c;
            item.AmountBuyingInclTaxLocal = bill.AmountBuyingInclTaxLocal__c;
            item.AmountSellingInclTaxLocal = bill.AmountSellingInclTaxLocal__c;
            results.add(item);
           }
           
        }  
        System.debug('c :'+results);
        return results;
        
    }

    private List<ResultWrapper> getBillPayment(String strQueryBill){
        List<ResultWrapper> results = new List<ResultWrapper>();
        List<FTMSBill__c> lstBill = new List<FTMSBill__c>();
        lstBill = Database.query(strQueryBill);

        For (FTMSBill__c bill: lstBill){
           
            ResultWrapper item = new ResultWrapper();

           if(bill.PaymentTo__r.Name != null && bill.PaymentTo__r.Name != ''){
            item.BillName = bill.BillNameatPrintENG__c;
            item.Companies = bill.PaymentTo__r.Name;
            item.ChargeUint = bill.ChargeUnit__c;
            item.ContainerType = bill.ContainerType__c;
            item.AmountBuyingFCY = bill.TotalAmountofBuyingFCY__c;
            item.AmountBuyingLocal = bill.TotalAmountofBuyingLocal__c;
            item.CurrBuying = bill.CurrencyBuying__c;
            item.CurrSelling = bill.CurrencySelling__c;
            item.AmountSellingFCY = bill.TotalAmountofSellingFCY__c;
            item.AmountSellingLocal =bill.TotalAmountofSellingLocal__c;
            item.ExRateBuying = bill.ExchangeRateBuying__c;
            item.ExRateSelling = bill.ExchangeRateSelling__c;
            item.AmountBuyingInclTaxLocal = bill.AmountBuyingInclTaxLocal__c;
            item.AmountSellingInclTaxLocal = bill.AmountSellingInclTaxLocal__c;
            results.add(item);
           }
        }  
        System.debug('c :'+results);
        return results;
        
    }

    private List<ResultWrapper> getBillBoth(String strQueryBill){
        List<ResultWrapper> results = new List<ResultWrapper>();
        List<FTMSBill__c> lstBill = new List<FTMSBill__c>();
        lstBill = Database.query(strQueryBill);

        For (FTMSBill__c bill: lstBill){
           
            ResultWrapper item = new ResultWrapper();

           if(bill.InvoiceTo__r.Name != null && bill.InvoiceTo__r.Name != ''  && bill.PaymentTo__r.Name != null && bill.PaymentTo__r.Name != ''){
            item.BillName = bill.BillNameatPrintENG__c;
            item.ChargeUint = bill.ChargeUnit__c;
            item.ContainerType = bill.ContainerType__c;
            item.AmountBuyingFCY = bill.TotalAmountofBuyingFCY__c;
            item.AmountBuyingLocal = bill.TotalAmountofBuyingLocal__c;
            item.CurrBuying = bill.CurrencyBuying__c;
            item.CurrSelling = bill.CurrencySelling__c;
            item.AmountSellingFCY = bill.TotalAmountofSellingFCY__c;
            item.AmountSellingLocal =bill.TotalAmountofSellingLocal__c;
            item.ExRateBuying = bill.ExchangeRateBuying__c;
            item.ExRateSelling = bill.ExchangeRateSelling__c;
            item.AmountBuyingInclTaxLocal = bill.AmountBuyingInclTaxLocal__c;
            item.AmountSellingInclTaxLocal = bill.AmountSellingInclTaxLocal__c;
            results.add(item);
           }
           
        }  
        System.debug('c :'+results);
        return results;
        
    }


    private String stringQuerySO(String shipmentId){
        String strSelect = 'SELECT ' + String.join(new List<String>(setFieldSO), ',');
        String strFrom = ' FROM FTMSSO__c ';
        String strWhere = ' WHERE Id = \'' + shipmentId + '\'' ;
        String strOrderBy = ' ORDER BY Name LIMIT 1';
        return strSelect + strFrom + strWhere + strOrderBy;
    }

    private String stringQueryCompanyInfo(String shipmentId, String branchName){
        String strSelect = 'SELECT ' + String.join(new List<String>(setFieldCompanyInfo), ',');
        String strFrom = ' FROM CompanyInformation__c ';
        String strWhere = ' WHERE Branch__c = \'' + branchName + '\'' ;
        String strOrderBy = ' ORDER BY Name LIMIT 1';
        return strSelect + strFrom + strWhere + strOrderBy;
    }

    private String stringQueryCNTR(String shipmentId){
        String strSelect = 'SELECT ' + String.join(new List<String>(setFieldCNTR), ',');
        String strFrom = ' FROM CntrinTrans__c ';
        String strWhere = ' WHERE F_TMS_S_O__c = \'' + shipmentId + '\'' ;
        String strOrderBy = ' ORDER BY Name LIMIT 1';
        return strSelect + strFrom + strWhere + strOrderBy;
    }

    private String stringQueryBill(String shipmentId){
        String strSelect = 'SELECT ' + String.join(new List<String>(setFieldBill), ',');
        String strFrom = ' FROM FTMSBill__c ';
        String strWhere = ' WHERE FTMSSO__c = \'' + shipmentId + '\'' ;
        String strOrderBy = ' ORDER BY PaymentTo__r.Name';
        return strSelect + strFrom + strWhere + strOrderBy;
    }

    public class ResultWrapper {
        public FTMSBill__c bill {get; set;}
        public Decimal Index {get; set;}
        public String Id {get; set;}
        public String BillName {get;set;}
        public String ChargeUint {get;set;}
        public String Companies {get;set;}
        public String ContainerType {get;set;}
        public Decimal AmountBuyingFCY {get;set;}
        public Decimal AmountBuyingLocal {get;set;}
        public String CurrBuying {get;set;}
        public String CurrSelling {get;set;}
        public Decimal AmountSellingFCY {get;set;}
        public Decimal AmountSellingLocal {get;set;}
        public Decimal ExRateBuying {get;set;}
        public Decimal ExRateSelling {get;set;}
        public Decimal AmountBuyingInclTaxLocal {get;set;}
        public Decimal AmountSellingInclTaxLocal {get;set;}
        public ResultWrapper(){
            Index = 0;
            BillName = '';
            Companies = '';
            ChargeUint = '';
            ContainerType = '';
            AmountBuyingFCY = 0;
            AmountBuyingLocal = 0;
            CurrBuying = '';
            CurrSelling = '';
            AmountSellingFCY = 0;
            AmountSellingLocal = 0;
            ExRateBuying = 0;
            ExRateSelling = 0;
            AmountBuyingInclTaxLocal = 0;
            AmountSellingInclTaxLocal = 0;

        }
    }

    public class ResultWrapperCompany {
        public String CompanyName {get;set;}
        public String Outbound {get;set;}
        public String Inbound {get;set;}
        public List<FTMSBill__c> lstBillOfCompany {get; set;}
        public ResultWrapperCompany(){
            this.CompanyName = '';
            this.Outbound = '';
            this.Inbound = '';
            lstBillOfCompany = new List<FTMSBill__c>();
        }
    }
    public class ResultWrapperAgent {
        public String DebitCredit {get;set;}
        public List<FTMSBill__c> lstBillOfAgent_PaymentTo{get; set;}
        public List<FTMSBill__c> lstBillOfAgent_InvoiceTo{get; set;}
        public List<FTMSBill__c> lstBillOfAgent_PaymentTo_Null{get; set;}
        public List<FTMSBill__c> lstBillOfAgent_InvoiceTo_Null{get; set;}
        public ResultWrapperAgent(){
            this.DebitCredit = '';
            lstBillOfAgent_PaymentTo = new List<FTMSBill__c>();
            lstBillOfAgent_InvoiceTo = new List<FTMSBill__c>();
            lstBillOfAgent_PaymentTo_Null = new List<FTMSBill__c>();
            lstBillOfAgent_InvoiceTo_Null = new List<FTMSBill__c>();
        }
    }
}