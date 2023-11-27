public with sharing class ProfitStatementForRequest {
    public String shipId{get; set;}
    public String ProcessInstanceId{get; set;}
    public String TargetObjectId{get; set;}
    public String processInstancecheckId {get;set;}
    public AdvancedShipment__c ADshipment{get;set;}
    public List<FTMSSO__c> shipment {get; set;}
    public CompanyInformation__c CompanyInfo {get; set;}
    public ConsolCNTR__c CNTR {get;set;}
    public List<FTMSBill__c> lstBill {get; set;}
    public List<FTMSBill__c> lstBill1 {get; set;}
    public List<ConsolBill__c> lstBillConsol {get;set;}
    public List<ConsolBill__c> lstBillConsolInvoiceToAgent {get;set;}
    public List<ConsolBill__c> lstBillConsolInvoiceToAgent2 {get;set;}
    public List<ConsolBill__c> lstBillConsolInvoiceToNotAgent {get;set;}
    public List<ConsolBill__c> lstBillConsolPaymentToAgent {get;set;}
    public List<ConsolBill__c> lstBillConsolPaymentToAgent2 {get;set;}
    public List<ConsolBill__c> lstBillConsolPaymentToNotAgent {get;set;}

    public String strQuerySO {get;set;}
    public String strQueryCompanyInfo {get;set;}
    public String strQueryBill {get;set;}
    public String strQueryBillConsol {get;set;}
    public String strQueryCNTR {get;set;}
    public String shipmentId {get; set;}
    public String MAWB_MBL {get;set;}
    public String testCok {get;set;}
    public List<string> lstIDshipment {get;set;}

    public List<ResultWrapperConsol> ResultWrapperConsol {get; set;}


    public List<ResultWrapper> lstBillInvoice {get; set;}
    public List<ResultWrapper> lstBillPayment {get; set;}
    public List<ResultWrapper> lstBillBoth {get; set;}

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

    public List<ResultWrapperSO> ListSO {get;set;}

    public Set<String> listIdChartInvoice {get; set;}
    public Set<String> listIdChartPayment {get; set;}
    public Set<String> listIdChartBoth {get; set;}

    public Decimal TotalCosting {get;set;}
    public Decimal TotalBilling {get;set;}
    public Decimal Profit {get;set;}
    public String TextSum {get;set;}
    public String UserName {get;set;}

    private static Set<String> setFieldSO = new Set<String>();
    private static Set<String> setFieldCompanyInfo = new Set<String>();
    private static Set<String> setFieldBill = new Set<String>();
    private static Set<String> setFieldBillConsol = new Set<String>();
    private static Set<String> setFieldCNTR = new Set<String>();

    static{
        setFieldSO.add('JobRequestID__c');
        setFieldSO.add('FileNo__c');
        // setFieldSO.add('GrossWeight__c');
        // // setFieldSO.add('Measurement__c');
        setFieldSO.add('MAgent__r.Name');
        setFieldSO.add('Agent2nd__r.Name');
        setFieldSO.add('MPOD__r.Name');
        setFieldSO.add('MPOL__r.Name');
        // setFieldSO.add('POD_Formul__c');
        // setFieldSO.add('POLformula__c');
        setFieldSO.add('VesselFlight__c');
        setFieldSO.add('Voyage__c');
        setFieldSO.add('MBLorMAWBNumber__c');
        // setFieldSO.add('MBLNumber__c');
        setFieldSO.add('Name');
        setFieldSO.add('Branch1__c');
        setFieldSO.add('CargoType__c');
        setFieldSO.add('GrossWeight__c');
        setFieldSO.add('MeasurementCBM__c');
        setFieldSO.add('Shipment_Type__c');
        setFieldSO.add('RecordType.Name');

        setFieldSO.add('Container_Qnty_1__c');
        setFieldSO.add('Container_Qnty_2__c');
        setFieldSO.add('Container_Qnty_3__c');
        setFieldSO.add('Container_Type_1__c');
        setFieldSO.add('Container_Type_2__c');
        setFieldSO.add('Container_Type_3__c');

        // setFieldSO.add('HBLNumber__c');
        // setFieldSO.add('HAWBNumber__c');
        // setFieldSO.add('Customer__r.Name');
        // setFieldSO.add('Agent__r.Name');
        // setFieldSO.add('AgentsdebitcreditNo__c');
        // setFieldSO.add('RecordType.Name');
        /////////////////////////////////////////////////
        setFieldCompanyInfo.add('Name');
        setFieldCompanyInfo.add('Address__c');
        setFieldCompanyInfo.add('CompanyLogo__c');
        setFieldCompanyInfo.add('Fax__c');
        setFieldCompanyInfo.add('Tel__c');
        setFieldCompanyInfo.add('Email__c');
        setFieldCompanyInfo.add('Website__c');
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
        setFieldBill.add('FTMSSO__c');
        setFieldBill.add('InboundVATINVNo__c');
        setFieldBill.add('OutboundVATInvNo__c');
        setFieldBill.add('InvoiceTo__r.Name');
        setFieldBill.add('PaymentTo__r.Name');
        ////////////////////////////////////////////////
        setFieldCNTR.add('Container_Number__c');
        setFieldCNTR.add('Container_Type__c');
        

        ////////////////////////////////////////////////
        setFieldBillConsol.add('BillNameatPrintENG__c');
        setFieldBillConsol.add('Currency__c');
        setFieldBillConsol.add('Currency_Selling__c');
        setFieldBillConsol.add('TotalAmountofBuyingFCY__c');
        setFieldBillConsol.add('TotalAmountofBuyingLocal__c');
        setFieldBillConsol.add('ExchangeRateBuying__c');
        setFieldBillConsol.add('ChargeUnit__c');
        setFieldBillConsol.add('Container_Type__c');
        setFieldBillConsol.add('AmountBuyingIncludingTaxLocal__c');
        setFieldBillConsol.add('PaymentTo__r.Name');
        setFieldBillConsol.add('Invoiceto__r.Name');
        setFieldBillConsol.add('Credit_No_from_Agent__c');
        setFieldBillConsol.add('InboundVATINVNo__c');
        setFieldBillConsol.add('TotalAmountofSellingFCY__c');
        setFieldBillConsol.add('TotalAmountofSellingLocal__c');
        setFieldBillConsol.add('ExchangeRateSelling__c');
        setFieldBillConsol.add('PaymentTo__c');
        setFieldBillConsol.add('Invoiceto__c');
        setFieldBillConsol.add('FTMSSO__c');
        setFieldBillConsol.add('FTMSSO__r.HBLNumber__c');
		setFieldBillConsol.add('CurrencyBuying__c');
        setFieldBillConsol.add('CurrencySelling__c');
		setFieldBillConsol.add('Profit_incl_tax_local__c');

        

        
    }
    public ProfitStatementForRequest() {
        shipmentId = ApexPages.currentPage().getParameters().get('id');
        System.debug('TargetObjectId : ' + TargetObjectId);
        shipment = new List<FTMSSO__c>();
        ADshipment = new AdvancedShipment__c();
        CompanyInfo = new CompanyInformation__c();
        CNTR = new ConsolCNTR__c();
        ResultWrapperConsol= new List<ResultWrapperConsol>();
        // lstBill = new List<FTMSBill__c>();
        lstBill1 = new List<FTMSBill__c>();
        lstBillConsol = new List<ConsolBill__c>();
        lstBillConsolPaymentToAgent = new List<ConsolBill__c>();
        lstBillConsolPaymentToAgent2 = new List<ConsolBill__c>();
        lstBillConsolPaymentToNotAgent = new List<ConsolBill__c>();
        lstBillConsolInvoiceToAgent = new List<ConsolBill__c>();
        lstBillConsolInvoiceToAgent2 = new List<ConsolBill__c>();
        lstBillConsolInvoiceToNotAgent = new List<ConsolBill__c>();
        ListSO = new List<ResultWrapperSO>();

        strQuerySO = '';
        strQueryBill = '';
        strQueryBillConsol = '';
        strQueryCompanyInfo = '';
        strQueryCNTR = '';

        TotalBilling = 0;
        TotalCosting = 0;
        Profit = 0;
        TextSum = '';
        UserName = '';
        String ProcessDefinitionId = '';
        try {
            ProcessInstanceId = [SELECT ProcessInstanceId from ProcessInstanceStep WHERE Id =: shipmentId].ProcessInstanceId;
           
            System.debug('ProcessInstanceId :'+ProcessInstanceId);
            
        } catch (QueryException e) {
            ProcessInstanceId = null;
        }
        try {
            TargetObjectId = [SELECT TargetObjectId from ProcessInstance WHERE Id =: ProcessInstanceId].TargetObjectId;
            ProcessDefinitionId = [SELECT ProcessDefinitionId from ProcessInstance WHERE Id =: ProcessInstanceId].ProcessDefinitionId;
            System.debug('TargetObjectId :'+TargetObjectId);
            System.debug('ProcessDefinitionId :'+ProcessDefinitionId);
        } catch (QueryException e) {
            TargetObjectId = null;
        }
        processInstancecheckId = ProcessDefinitionId;
        if(processInstancecheckId == '04a8d000000tBI7AAM'){
            System.debug('ProcessInstanceId 1 :'+ProcessInstanceId);
            System.debug('TargetObjectId 1 :'+TargetObjectId);
    
            strQueryCNTR = stringQueryCNTR(TargetObjectId);
            strQuerySO = stringQuerySO(TargetObjectId);
            System.debug('strQuerySO :'+strQuerySO);
            
            strQueryBillConsol = stringQueryBillConsol(TargetObjectId);
            lstBillConsol = Database.query(strQueryBillConsol);
    
            List<String> tmpOnShip= new List<String>();
            List<String> hblNo= new List<String>();
    
    
            for (Integer i = 0; i < lstBillConsol.size(); i++) {
                if (lstBillConsol[i].FTMSSO__c == null) {
                    lstBillConsolInvoiceToNotAgent.add(lstBillConsol[i]);
                }else{
                    if(tmpOnShip.contains(lstBillConsol[i].FTMSSO__c) == false){
                        
                        tmpOnShip.add(lstBillConsol[i].FTMSSO__c);
                        hblNo.add(lstBillConsol[i].FTMSSO__r.HBLNumber__c);
                    }
                    // lstBillConsolPaymentToAgent.add(lstBillConsol[i]);
                }
            }
            for (Integer i = 0; i < tmpOnShip.size(); i++) {
                ResultWrapperConsol tmp = new ResultWrapperConsol();
                tmp.HBL=tmpOnShip[i];
                tmp.HBLNo=hblNo[i];
    
                for(Integer j = 0; j < lstBillConsol.size(); j++){
                    if (lstBillConsol[j].FTMSSO__c == tmpOnShip[i]) {
                        tmp.lstBillConsol.add(lstBillConsol[j]);
                    }
                }
                ResultWrapperConsol.add(tmp);
                    
            }
    
    
            System.debug('Consol Bill : ' + lstBillConsol);
            ADshipment = Database.query(strQuerySO);
            System.debug('shipment ne :' + ADshipment);
            shipment = [SELECT Name, id FROM FTMSSO__c WHERE ConsolidationID__c =: TargetObjectId];
            List<String> lstIDshipment = new List<String>();
            for(FTMSSO__c ship : shipment){
                lstIDshipment.add(ship.id);
            }
            System.debug('shipment AD :' + lstIDshipment);
            strQueryBill = stringQueryBill(lstIDshipment);
    
            System.debug('hihih ' + strQueryBill);
    
            lstBill1 = Database.query(strQueryBill);
            // System.debug('lstBill ne: ' + lstBill);
            String branchName = '';
            branchName = ADshipment.Branch1__c;
            strQueryCompanyInfo = stringQueryCompanyInfo(TargetObjectId, branchName);
    
            try {
                CompanyInfo = Database.query(strQueryCompanyInfo);
            } catch (QueryException e) {
                CompanyInfo= new  CompanyInformation__c();
            }
            
    
            System.debug('CompanyInfo ne :' + shipment);
            // CNTR = Database.query(strQueryCNTR);
            ConsolCNTR__c lstCon;
            try{
                lstCon = Database.query(strQueryCNTR);
            } catch(QueryException e){
                lstCon = new ConsolCNTR__c();
            }
            CNTR = lstCon;
    
    
            for(FTMSBill__c bill : lstBill1){
                if(bill.InvoiceTo__r.RecordType.Name != null || bill.InvoiceTo__r.RecordType.Name != ''){
                    TotalBilling += bill.TotalAmountofSellingLocal__c;
                }
                if(bill.PaymentTo__r.RecordType.Name != null || bill.PaymentTo__r.RecordType.Name != ''){
                    TotalCosting += bill.TotalAmountofBuyingLocal__c;
                }
            }
            for(ConsolBill__c bill : lstBillConsol){
                if(bill.PaymentTo__c != null){
                    TotalCosting += bill.TotalAmountofBuyingLocal__c;
                }
                if(bill.Invoiceto__c != null){
                    TotalBilling += bill.TotalAmountofSellingLocal__c;
                }
            }
            Profit = TotalBilling - TotalCosting;
    
            System.debug('Profit :' + Profit);
    
            if(Profit < 0){
                Decimal Profit1 = 0;
                Profit1 = math.abs(Profit);
                TextSum =  ReadNumberToWords.convert(Profit1.setScale(2, System.RoundingMode.HALF_UP));
            }
            else {
                TextSum =  ReadNumberToWords.convert(Profit.setScale(2, System.RoundingMode.HALF_UP));
            }
            
            UserName = UserInfo.getName();
            for(String shipID : lstIDshipment){
                lstBill = new List<FTMSBill__c>();
                // lstBill1 = new List<FTMSBill__c>();
                // lstBillConsol = new List<ConsolBill__c>();
                lstBillInvoice = new List<ResultWrapper>();
                lstBillPayment = new List<ResultWrapper>();
                lstBillBoth = new List<ResultWrapper>();
        
                listIdChartInvoice = new Set<String>();
                listIdChartPayment = new Set<String>();
                listIdChartBoth = new Set<String>();
        
                lstComInvoice = new List<ResultWrapperCompany>();
                lstComPayment = new List<ResultWrapperCompany>();
                lstComBoth = new List<ResultWrapperCompany>();
                // ListSO = new List<ResultWrapperSO>();
                List<String> CompanyName = new List<String>();
                List<String> InvoiceName = new List<String>();
                List<String> PaymentName = new List<String>();
                Set<String> setCompanyName = new Set<String>();
        
                List<FTMSBill__c> lstCompany = new List<FTMSBill__c>();
                lstInvoice = new List<ResultWrapper>();
                lstPayment = new List<ResultWrapper>();
                lstBoth1 = new List<ResultWrapper>();
                lstBoth2 = new List<ResultWrapper>();
                FTMSSO__c shipment1 = new FTMSSO__c();
                shipment1 = [SELECT Agent__r.Name, Customer__r.Name, HAWBNumber__c, HBLNumber__c, AgentsdebitcreditNo__c, RecordType.Name, CargoQuantity__c, CargoUnit__c, MeasurementTotalCBM__c FROM FTMSSO__c WHERE id =: shipID LIMIT 1];
    
                lstBill = [SELECT BillNameatPrintENG__c,
                                CurrencyBuying__c,
                                CurrencySelling__c,
                                TotalAmountofBuyingFCY__c,
                                TotalAmountofBuyingLocal__c,
                                TotalAmountofSellingFCY__c,
                                TotalAmountofSellingLocal__c,
                                ExchangeRateBuying__c,
                                ExchangeRateSelling__c,
                                AmountBuyingInclTaxLocal__c,
                                AmountSellingInclTaxLocal__c,
                                ChargeUnit__c,
                                ContainerType__c,
                                InvoiceTo__r.RecordType.Name,
                                PaymentTo__r.RecordType.Name,
                                InvoiceTo__r.Name,
                                PaymentTo__r.Name,
                                FTMSSO__c 
                                FROM FTMSBill__c 
                                WHERE FTMSSO__c =: shipID];
                System.debug('13245: ' + lstBill);
    
            lstBillInvoice = getBillInvoice();
            System.debug('BillInvoice: ' + lstBillInvoice);
            lstBillPayment = getBillPayment();
            System.debug('BillPayment: ' + lstBillPayment);
            lstBillBoth = getBillBoth();
            System.debug('BillBoth: ' + lstBillBoth);
    
            
            
    
            for(ResultWrapper bill: lstBillInvoice){
                String invoice = bill.Companies;
                InvoiceName.add(invoice);
            }
            
            for(ResultWrapper bill: lstBillPayment){
                String payment = bill.Companies;
                PaymentName.add(payment);
            }
            System.debug('InvoiceName: ' + InvoiceName);
            System.debug('PaymentName: ' + PaymentName);
            for(FTMSBill__c bill : lstBill){
                String Company1 = '';
                String Company2 = '';
                if(bill.InvoiceTo__r.Name != null){
                    Company1 = bill.InvoiceTo__r.Name;
                    if(!setCompanyName.contains(Company1)){
                        CompanyName.add(Company1);
                        setCompanyName.add(Company1);
                    }
                    // Company1 = bill.InvoiceTo__r.Name;
                    // CompanyName.add(Company1);
                }
                if(bill.PaymentTo__r.Name != null){
                    Company2 = bill.PaymentTo__r.Name;
                    if(!setCompanyName.contains(Company2)){
                        CompanyName.add(Company2);
                        setCompanyName.add(Company2);
                    }
                }
            }
    
            System.debug('Company Name : ' + CompanyName);
            
            integer i =0;
            for(ResultWrapper bill: lstBillInvoice){
                ResultWrapper item = new ResultWrapper();
                if(!PaymentName.contains(bill.Companies)){
    
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
    
            System.debug('Count21: ' + lstBoth1);
            System.debug('Count22: ' + lstBoth2);
    
            ResultWrapperSO SO1 = new ResultWrapperSO();
            String HBL_HAWBnumber = '';
            SO1.agentName = shipment1.Agent__r.Name;
            SO1.customerName = shipment1.Customer__r.Name;
            System.debug('1144: '+ shipment1.Customer__r.Name);
    
            if(shipment1.RecordType.Name == 'Ocean Export' || shipment1.RecordType.Name == 'Ocean Import'){
                HBL_HAWBnumber = shipment1.HBLNumber__c;
            }
            if(shipment1.RecordType.Name == 'Air Export' || shipment1.RecordType.Name == 'Air Import'){
                HBL_HAWBnumber = shipment1.HAWBNumber__c;
            }
            SO1.HBL_HAWB = HBL_HAWBnumber;
            System.debug('1122:' + HBL_HAWBnumber);
            SO1.debitCreditNo = shipment1.AgentsdebitcreditNo__c;
            SO1.quantity = shipment1.CargoQuantity__c;
            SO1.unit = shipment1.CargoUnit__c;
            SO1.CBM = shipment1.MeasurementTotalCBM__c;
            // ListSO.add(SO1);
             
            
            for(ResultWrapper inv : lstInvoice){
                listIdChartInvoice.add(inv.Companies);
            }
            System.debug('2234: ' + listIdChartInvoice);
        // }
        // ResultWrapperSO SO2 = new ResultWrapperSO();
        // InvoiceTo
                for(String invv : listIdChartInvoice){
                    ResultWrapperCompany invvv= new ResultWrapperCompany();
                    // ResultWrapperSO SO = new ResultWrapperSO();
                    invvv.CompanyName = invv;
                    if(invvv.CompanyName == shipment1.Customer__r.Name){
                        if(shipment1.RecordType.Name == 'Ocean Export' || shipment1.RecordType.Name == 'Ocean Import'){
                            invvv.Numbers = shipment1.HBLNumber__c;
                        }
                        if(shipment1.RecordType.Name == 'Air Export' || shipment1.RecordType.Name == 'Air Import'){
                            invvv.Numbers = shipment1.HAWBNumber__c;
                        }
                    }
                    
                    System.debug('1133: ' + invvv.CompanyName);
                    for(FTMSBill__c bill :lstBill){
                        if(invvv.CompanyName == bill.InvoiceTo__r.Name){
                            invvv.lstBillOfCompany.add(bill);
                        }
                    }
                    lstComInvoice.add(invvv);
                    SO1.invoiceBill = lstComInvoice;
                    
                }
                // ListSO.add(SO2);
             
    
                System.debug('lstComInvoice :'+lstComInvoice);
                
            // PaymentTo
            for(ResultWrapper inv : lstPayment){
                listIdChartPayment.add(inv.Companies);
            }
            System.debug('listIdChartPayment :'+listIdChartPayment);
            // ResultWrapperSO SO3 = new ResultWrapperSO();
            for(String invv : listIdChartPayment){
                ResultWrapperCompany invvv= new ResultWrapperCompany();
                // ResultWrapperSO SO = new ResultWrapperSO();
                invvv.CompanyName = invv;
                if(invvv.CompanyName == shipment1.Agent__r.Name){
                    invvv.debitCredit = shipment1.AgentsdebitcreditNo__c;
                }
                for(FTMSBill__c bill :lstBill){
                    if(invvv.CompanyName == bill.PaymentTo__r.Name){
                        invvv.lstBillOfCompany.add(bill);
                    }
                }
                lstComPayment.add(invvv);
                SO1.paymentBill = lstComPayment;
                
            }
            // ListSO.add(SO3);
            System.debug('lstComPayment :'+lstComPayment);
            // Both
            for(ResultWrapper inv : lstBoth1){
                listIdChartBoth.add(inv.Companies);
            }
            for(ResultWrapper inv : lstBoth2){
                listIdChartBoth.add(inv.Companies);
            }
            // ResultWrapperSO SO4 = new ResultWrapperSO();
            for(String invv : listIdChartBoth){
                ResultWrapperCompany invvv= new ResultWrapperCompany();
                // ResultWrapperSO SO = new ResultWrapperSO();
                invvv.CompanyName = invv;
                for(FTMSBill__c bill :lstBill){
                    if(invvv.CompanyName == bill.PaymentTo__r.Name){
                        invvv.lstBillOfCompany.add(bill);
                    }
                    if(invvv.CompanyName == bill.InvoiceTo__r.Name){
                        invvv.lstBillOfCompany.add(bill);
                    }
                    
                }
                lstComBoth.add(invvv);
                SO1.bothBill = lstComBoth;
                
            }
            ListSO.add(SO1);
            System.debug('lstComBoth :'+lstComBoth);
            System.debug('ListSO :'+ListSO);
    
            // generateAttachmentFile();
        }
        }
        
        
    }
    @Future(callout=true)
    public static void generateAttachmentFile( String TargetObjectId){
        System.debug('loggg :');
        
        PageReference pdf_file =Page.page_ProfitStatementForRequestV2;
        pdf_file.getParameters().put('Id', TargetObjectId);

        System.debug('shipmentID :'+TargetObjectId);
        
        AdvancedShipment__c item = new AdvancedShipment__c();
        String strSelect = 'SELECT ' + String.join(new List<String>(setFieldSO), ',');
        String strFrom = ' FROM AdvancedShipment__c ';
        String strWhere = 'WHERE Id = \'' + TargetObjectId + '\'' ;
        String strOrderBy = ' ORDER BY Name LIMIT 1';
        String data = strSelect + strFrom + strWhere + strOrderBy;
        item = Database.query(data);
        String namefile =item.Name +'_ProfitStatementRequest_' ;

       
        String attachName = namefile ;
        String attachNameSearch = attachName + '%';
        // get exist file Name
        List<Attachment> attachments = [SELECT Id, Name, ParentId 
                                        FROM Attachment 
                                        WHERE ParentId =: TargetObjectId 
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
        // if(requiredAttachmentCreation != false){
            Attachment attach = new Attachment();
            Blob body;
            attach.Name = attachName + '.pdf'; 
            attach.IsPrivate = false;
            attach.ParentId = TargetObjectId;
            if(!Test.isRunningTest()){
            body = pdf_file.getContentAsPDF();
            System.debug('debuggg Thong :'+body);
            attach.Body = body;
            FlsService.doInsert(attach);
        }
        // }
        
        
    }

   
    private List<ResultWrapper> getBillInvoice(){
        List<ResultWrapper> results = new List<ResultWrapper>();

        for (FTMSBill__c bill: lstBill){
           
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

    private List<ResultWrapper> getBillPayment(){
        List<ResultWrapper> results = new List<ResultWrapper>();
        // List<FTMSBill__c> lstBill = new List<FTMSBill__c>();
        // lstBill = Database.query(strQueryBill);

        for (FTMSBill__c bill: lstBill){
           
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

    private List<ResultWrapper> getBillBoth(){
        List<ResultWrapper> results = new List<ResultWrapper>();
        // List<FTMSBill__c> lstBill = new List<FTMSBill__c>();
        // lstBill = Database.query(strQueryBill);

        for (FTMSBill__c bill: lstBill){
           
            ResultWrapper item = new ResultWrapper();

           if(bill.InvoiceTo__r.RecordType.Name != null && bill.InvoiceTo__r.RecordType.Name != ''  && bill.PaymentTo__r.RecordType.Name != null && bill.PaymentTo__r.RecordType.Name != ''){
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


    private String stringQuerySO(String TargetObjectId){
        String strSelect = 'SELECT ' + String.join(new List<String>(setFieldSO), ',');
        String strFrom = ' FROM AdvancedShipment__c ';
        String strWhere = ' WHERE Id = \'' + TargetObjectId + '\'' ;
        String strOrderBy = ' ORDER BY Name LIMIT 1';
        return strSelect + strFrom + strWhere + strOrderBy;
    }

    private String stringQueryCompanyInfo(String TargetObjectId, String branchName){
        String strSelect = 'SELECT ' + String.join(new List<String>(setFieldCompanyInfo), ',');
        String strFrom = ' FROM CompanyInformation__c ';
        String strWhere = ' WHERE Branch1__c = \'' + branchName + '\'' ;
        String strOrderBy = ' ORDER BY Name LIMIT 1';
        return strSelect + strFrom + strWhere + strOrderBy;
    }

    private String stringQueryCNTR(String TargetObjectId){
        String strSelect = 'SELECT ' + String.join(new List<String>(setFieldCNTR), ',');
        String strFrom = ' FROM ConsolCNTR__c ';
        String strWhere = ' WHERE AdvancedShipment__c = \'' + TargetObjectId + '\'' ;
        String strOrderBy = ' ORDER BY Name LIMIT 1';
        return strSelect + strFrom + strWhere + strOrderBy;
    }

    private String stringQueryBill(List<String> lstIDshipment){
        String strSelect = 'SELECT ' + String.join(new List<String>(setFieldBill), ',');
        String strFrom = ' FROM FTMSBill__c ';
        String strWhere = ' WHERE FTMSSO__c IN :lstIDshipment';
        // String strOrderBy = ' ORDER Name';
        return strSelect + strFrom + strWhere ;
    }

    private String stringQueryBillConsol(String TargetObjectId){
        String strSelect = 'SELECT ' + String.join(new List<String>(setFieldBillConsol), ',');
        String strFrom = ' FROM ConsolBill__c ';
        String strWhere = ' WHERE ConsolidationShipmentName__c = \'' + TargetObjectId + '\'' ;
        // String strOrderBy = ' ORDER Name';
        return strSelect + strFrom + strWhere ;
    }


    public class ResultWrapperConsol {
        public String HBL  {get; set;}
        public String HBLNo  {get; set;}

        // public List<FTMSSO__c> shipment ;
        public List<ConsolBill__c> lstBillConsol {get; set;}
        public ResultWrapperConsol(){
            // Index = 0;
            HBL = '';
            HBLNo = '';
            lstBillConsol=new List<ConsolBill__c>();

        }

    }
    public class ResultWrapper {
        public FTMSBill__c bill {get; set;}
        // public Decimal Index {get; set;}
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
            // Index = 0;
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
        public String Numbers {get;set;}
        public String debitCredit {get;set;}
        public List<FTMSBill__c> lstBillOfCompany {get; set;}
        public ResultWrapperCompany(){
            this.CompanyName = '';
            this.Numbers = '';
            this.debitCredit = '';
            lstBillOfCompany = new List<FTMSBill__c>();
        }
    }

    public class ResultWrapperSO {
        public String agentName {get;set;}
        public String customerName {get;set;}
        public String HBL_HAWB {get;set;}
        // public String HAWB {get;set;}
        public String debitCreditNo {get;set;}
        public Decimal quantity {get;set;}
        public String unit {get;set;}
        public Decimal CBM {get;set;}
        public List<ResultWrapperCompany> invoiceBill {get; set;}
        public List<ResultWrapperCompany> paymentBill {get; set;}
        public List<ResultWrapperCompany> bothBill {get; set;}
        // public List<ResultWrapperCompany> lstBillOfCompany {get;set;}
        public ResultWrapperSO(){
            this.agentName = '';
            this.customerName= '';
            this.HBL_HAWB = '';
            // this.HAWB = '';
            this.debitCreditNo = '';
            this.quantity = 0;
            this.unit = '';
            this.CBM = 0;
            invoiceBill = new List<ResultWrapperCompany>();
            paymentBill = new List<ResultWrapperCompany>();
            bothBill = new List<ResultWrapperCompany>();
            // lstBillOfCompany = new List<ResultWrapperCompany>();
        }
    }
}