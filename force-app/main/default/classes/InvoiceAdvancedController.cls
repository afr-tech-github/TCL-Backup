public with sharing class InvoiceAdvancedController {
    public AdvancedShipment__c shipment {get; set;}
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
    public List<ResultWrapperSO> ListSO {get;set;}

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
    public List<String> lstIDship2 {get;set;}

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
    private static Set<String> setFieldsConsolBill = new Set<String>();


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
        setFields.add('MAgent__c');
        setFields.add('Agent2nd__c');
        setFields.add('MAgent__r.AccountNameENG__c');
        setFields.add('MAgent__r.EnglishAddress__c');
        setFields.add('FileNo__c');
        setFields.add('VesselFlight__c');
        setFields.add('Voyage__c');
        setFields.add('ETD__c');
        setFields.add('MPOL__r.Name');
        setFields.add('MPOD__r.Name');
        setFields.add('MBLorMAWBNumber__c');
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
    }

    static{
        setFieldsConsolBill.add('Name');
        setFieldsConsolBill.add('Invoiceto__r.Name');
        setFieldsConsolBill.add('PaymentTo__r.Name');
        // setFieldsConsolBill.add('OutboundVATInvNo__c');
        // setFieldsConsolBill.add('OutboundInvDate__c');
        setFieldsConsolBill.add('Debit_No__c');
        setFieldsConsolBill.add('InvNoonCreditfromCompany__c');
        setFieldsConsolBill.add('BillNameatPrintENG__c');
        setFieldsConsolBill.add('Quantity__c');
        setFieldsConsolBill.add('ChargeUnit__c');
        setFieldsConsolBill.add('Currency_Selling__c');
        setFieldsConsolBill.add('TotalAmountofSellingFCY__c');
        setFieldsConsolBill.add('Total_Selling_Incl_Tax_FCY__c');
        setFieldsConsolBill.add('Currency__c');
        setFieldsConsolBill.add('TotalAmountofBuyingFCY__c');
        setFieldsConsolBill.add('AmountBuyingIncludingTaxFCY__c');

        setFieldsConsolBill.add('CompanyCreditDate__c');
        setFieldsConsolBill.add('Date_on_Debit_note__c');
        setFieldsConsolBill.add('MMYY_Debit__c');
        setFieldsConsolBill.add('Debit_check__c');
        setFieldsConsolBill.add('MMYY_Credit__c');
        setFieldsConsolBill.add('Credit_Check__c');
        setFieldsConsolBill.add('PricingName__r.Name');
        // setFieldsConsolBill.add('Quantity__c');
        // setFieldsConsolBill.add('ChargeQuantity__c');
        // setFieldsConsolBill.add('ChargeUnit__c');
        // setFieldsConsolBill.add('CurrencySelling__c');
        // setFieldsConsolBill.add('TaxRateSelling__c');
        // setFieldsConsolBill.add('TotalAmountofSellingFCY__c');
        // setFieldsConsolBill.add('TotalSellingInclTaxFCY__c');
        // setFieldsConsolBill.add('TotalAmountofSellingLocal__c');
        // setFieldsConsolBill.add('TotalSellingInclTaxLocal__c');
        // setFieldsConsolBill.add('MMYY_Debit__c');
        // setFieldsConsolBill.add('Debit_check__c');
        // setFieldsConsolBill.add('CompanyCreditDate__c');
        // setFieldsConsolBill.add('InvNoonCreditfromCompany__c');
        // setFieldsConsolBill.add('Credit_Check__c');
        // setFieldsConsolBill.add('MMYY_Credit__c');
        // setFieldsConsolBill.add('InvoiceTo__c');
        // setFieldsConsolBill.add('PaymentTo__c');
        // setFieldsConsolBill.add('TotalBuyingInclTaxFCY__c');
        // setFieldsConsolBill.add('TotalAmountofBuyingFCY__c');
        // setFieldsConsolBill.add('CurrencyBuying__c');
    }
    public InvoiceAdvancedController() {
        // System.debug('1DEBUG:' + UserInfo.getLanguage()) ;
        shipmentID = ApexPages.currentPage().getParameters().get('id');
        agentID = ApexPages.currentPage().getParameters().get('customerValue');
        // System.debug('shipID :'+shipID);
        shipment = new AdvancedShipment__c();
        arrResult = new List<ResultWrapper>();
        arrResult2 = new List<FTMSBill__c>();
        arrResult3 = new List<ResultWrapper>();
        arrResult4 = new List<ResultWrapper2>();
        lstbill = new List<FTMSBill__c>();
        listShip = new List<FTMSSO__c>();
        billing = new FTMSBill__c();
        billing2 = new FTMSBill__c();
        ListSO = new List<ResultWrapperSO>();
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
        System.debug('customerValue :'+customerValue);
        formno = ApexPages.currentPage().getParameters().get('InvoiceNo');
        // String temp = String.valueOf([Select InvoiceTo__c From FTMSBill__c where FTMSSO__c =: shipmentID ORDER By Name LIMIT 1]);
        lstIDship = new List<String>();
        lstIDship2 = new List<String>();
        listShip = [SELECT Id, Name FROM FTMSSO__c WHERE ConsolidationID__c =: shipmentID];
        for (FTMSSO__c ship : listShip){
            lstIDship.add('\''+ship.Id+'\'');
            lstIDship2.add(ship.Id);
        }
        String queryShip = stringQueryShipment(shipmentID);
        shipment = Database.query(queryShip);
        agentName = shipment.MAgent__r.AccountNameENG__c;
        strQueryBill = stringQueryBill(lstIDship,customerValue);
        System.debug('queryBill: '+ lstIDship);
        List<FTMSBill__c> bills = new List<FTMSBill__c>();
        try {
            bills = Database.query(strQueryBill);
        } catch (QueryException e) {
            bills = new List<FTMSBill__c>();
        }
        // List<FTMSBill__c> bills = Database.query(strQueryBill);
        for(String IDship: lstIDship2){
            System.debug('queryBill1: '+ IDship);
            ResultWrapperSO SO = new ResultWrapperSO();
            FTMSSO__c shipment1 = new FTMSSO__c();
            shipment1 = [SELECT Agent__r.Name, Customer__r.Name, HAWBNumber__c, HBLNumber__c, AgentsdebitcreditNo__c, RecordType.Name FROM FTMSSO__c WHERE id =: IDship LIMIT 1];
            if(shipment1.RecordType.Name == 'Ocean Export' || shipment1.RecordType.Name == 'Ocean Import'){
                SO.HBLnumber = shipment1.HBLNumber__c;
            }
            if(shipment1.RecordType.Name == 'Air Export' || shipment1.RecordType.Name == 'Air Import'){
                SO.HBLnumber = shipment1.HAWBNumber__c;
            }
            String query = '';
            String strSelect = 'SELECT ' + String.join(new List<String>(setFieldsBill), ',');
            String strFrom = ' FROM FTMSBill__c ';
            String strWhere;
            if(customerValue != null && customerValue != 'none'){
                strWhere = 'WHERE (InvoiceTo__c = \'' + customerValue + '\' OR '+ 'PaymentTo__c = \'' + customerValue + '\') '+' AND FTMSSO__c = \'' + IDship + '\'';
            }
            else{
                strWhere = 'WHERE (InvoiceTo__c = \'' + shipment.MAgent__c + '\' OR '+ 'PaymentTo__c = \'' + shipment.MAgent__c + '\' OR '+ 'InvoiceTo__c = \'' + shipment.Agent2nd__c + '\' OR '+ 'PaymentTo__c = \'' + shipment.Agent2nd__c + '\') '+' AND FTMSSO__c = \'' + IDship + '\'';
            }
            if (InvoiceValue != null && InvoiceValue != 'none'){
                strWhere += ' AND (OutboundVATInvNo__c = \'' + InvoiceValue + '\' OR InvNoonCreditfromCompany__c = \''+InvoiceValue+'\')';
            }
            query = strSelect + strFrom + strWhere;
            System.debug('listSO: '+ query);
            try {
                bills = Database.query(query);
            } catch (QueryException e) {
                bills = new List<FTMSBill__c>();
            }

            arrResult2 = bills;
            System.debug('lstBill: '+ arrResult2);
            SO.listBillSO = arrResult2;
            ListSO.add(SO);
        }
        List<ConsolBill__c> billsConsol = new List<ConsolBill__c>();
        ResultWrapperSO SO1 = new ResultWrapperSO();
        String query1 = '';
        String strSelect1 = 'SELECT ' + String.join(new List<String>(setFieldsConsolBill), ',');
        String strFrom1 = ' FROM ConsolBill__c ';
        String strWhere1;
        if(customerValue != null && customerValue != 'none'){
            strWhere1 = 'WHERE (Invoiceto__c = \'' + customerValue + '\' OR '+ 'PaymentTo__c = \'' + customerValue + '\') '+' AND ConsolidationShipmentName__c = \'' + shipmentID + '\'';
        }
        // else{
        //     strWhere = 'WHERE (InvoiceTo__c = \'' + shipment.MAgent__c + '\' OR '+ 'PaymentTo__c = \'' + shipment.MAgent__c + '\' OR '+ 'InvoiceTo__c = \'' + shipment.Agent2nd__c + '\' OR '+ 'PaymentTo__c = \'' + shipment.Agent2nd__c + '\') '+' AND ConsolidationShipmentName__c = \'' + shipmentID + '\'';
        // }
        // if (InvoiceValue != null && InvoiceValue != 'none'){
        //     strWhere1 += ' AND (OutboundVATInvNo__c = \'' + InvoiceValue + '\' OR InvNoonCreditfromCompany__c = \''+InvoiceValue+'\')';
        // }
        query1 = strSelect1 + strFrom1 + strWhere1;
        // System.debug('listSO: '+ query);
        try {
            billsConsol = Database.query(query1);
        } catch (QueryException e) {
            billsConsol = new List<ConsolBill__c>();
        }
        System.debug('1223:' + query1);
        System.debug('123:' + billsConsol);

        SO1.listBillConsol = billsConsol;
        ListSO.add(SO1);
        System.debug('1223:' + ListSO);
        // arrResult2 = bills;
        // System.debug('lstBill: '+ arrResult2);
    }

    public void generateAttachmentFile(){
        System.debug('loggg :');
        if(ApexPages.currentPage().getParameters().get('requiredAttachmentCreation') != null){
            requiredAttachmentCreation = Boolean.valueOf(ApexPages.currentPage().getParameters().get('requiredAttachmentCreation'));
        }

        System.debug('loggg :'+requiredAttachmentCreation);
        PageReference pdf_file =Page.DebitNoteSelection_V4;
        pdf_file.getParameters().put('Id', shipmentID);
        pdf_file.getParameters().put('agentId', agentID);
        // pdf_file.getParameters().put('Draft', 'false');
        // pdf_file.getParameters().put('Official', 'false');
        pdf_file.getParameters().put('requiredAttachmentCreation', 'false');
        pdf_file.getParameters().put('customerId', customerId);
        
        AdvancedShipment__c item = new AdvancedShipment__c();
        String strSelect = 'SELECT ' + String.join(new List<String>(setFields), ',');
        String strFrom = ' FROM AdvancedShipment__c ';
        String strWhere = 'WHERE Id = \'' + shipmentId + '\'' ;
        String strOrderBy = ' ORDER BY Name LIMIT 1';
        String data = strSelect + strFrom + strWhere + strOrderBy;
        item = Database.query(data);
        String namefile =item.Name +'_請求書_' ;

       
        String attachName = namefile ;
        String attachNameSearch = attachName + '%';
        // get exist file Name
        List<Attachment> attachments = [SELECT Id, Name, ParentId 
                                        FROM Attachment 
                                        WHERE ParentId =: shipmentID 
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
        if(requiredAttachmentCreation != false){
            Attachment attach = new Attachment();
            Blob body;
            attach.Name = attachName + '.pdf'; 
            attach.IsPrivate = false;
            attach.ParentId = shipmentID;
            if(!Test.isRunningTest()){
            body = pdf_file.getContentAsPDF();
            System.debug('debuggg Thong :'+body);
            attach.Body = body;
            FlsService.doInsert(attach);
        }
        }
        
        
    }
    public void updateDebitNo(){
        
        String shipID = ApexPages.currentPage().getParameters().get('id');
        String billIds = ApexPages.currentPage().getParameters().get('strAkens');
        System.debug('111'+billIds);
        // String customerValue = ApexPages.currentPage().getParameters().get('customerValue');
        // System.debug('customerValue :'+customerValue);
        String official = ApexPages.currentPage().getParameters().get('checkOfficial');
        System.debug('121: '+official);
        List<String> lstBillIds = new List<String>();
        if(!String.isBlank(billIds)){
            lstBillIds = billIds.split(',');         
        }
        String strSelect = 'SELECT ' + String.join(new List<String>(setFieldsBill), ',');
        String strFrom = ' FROM FTMSBill__c ';
        String strWhere = 'WHERE FTMSSO__c IN ' + lstIDship  +  ' AND Id IN : lstBillIds';
        String strOrderBy = ' ORDER BY Name';
        String query = strSelect + strFrom + strWhere +strOrderBy;  

        String strSelect1 = 'SELECT ' + String.join(new List<String>(setFieldsBill), ',');
        String strFrom1 = ' FROM FTMSBill__c ';
        // String strWhere = 'WHERE FTMSSO__c = \'' + shipmentId + '\'' +  ' AND Id IN : lstBillIds';
        String strOrderBy1 = ' ORDER BY Name';
        String query1 = strSelect1 + strFrom1 +strOrderBy1; 

        String strSelect2 = 'SELECT ' + String.join(new List<String>(setFieldsConsolBill), ',');
        String strFrom2 = ' FROM ConsolBill__c ';
        String strWhere2 = 'WHERE ConsolidationShipmentName__c = \'' + shipmentId + '\'' +  ' AND Id IN : lstBillIds';
        String strOrderBy2 = ' ORDER BY Name';
        String query2 = strSelect2 + strFrom2 + strWhere2 +strOrderBy2;  

        String strSelect3 = 'SELECT ' + String.join(new List<String>(setFieldsConsolBill), ',');
        String strFrom3 = ' FROM ConsolBill__c ';
        // String strWhere = 'WHERE FTMSSO__c = \'' + shipmentId + '\'' +  ' AND Id IN : lstBillIds';
        String strOrderBy3 = ' ORDER BY Name';
        String query3 = strSelect3 + strFrom3 +strOrderBy3; 

        List<FTMSBill__c> lstBill = Database.query(query);
        List<FTMSBill__c> lstBill1 = Database.query(query1);
        List<ConsolBill__c> lstBill2 = Database.query(query2);
        List<ConsolBill__c> lstBill3 = Database.query(query3);
        List<FTMSBill__c> lstBillUpdate = new List<FTMSBill__c>();
        List<ConsolBill__c> lstConsolBillUpdate = new List<ConsolBill__c>();
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
        
        for(ConsolBill__c bill3 : lstBill3){
            if(bill3.Debit_No__c != null && bill3.MMYY_Debit__c == yearMonth){
                String endPointDebit = bill3.Debit_check__c;
                numberPointDebit.add(endPointDebit);
            } 
            if(bill3.InvNoonCreditfromCompany__c != null && bill3.MMYY_Credit__c == yearMonth){
                String endPointCredit = bill3.Credit_Check__c;
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
        String First = '';
        for(FTMSBill__c bill : lstBill){
            // if(bill.InvoiceTo__c == shipment.MAgent__c){
            //     First = '-DN-';
            // }
            // else{
            //     First = '-CN-';
            // }
            // if(Integer.valueOf(today.month()) < 10){
            //     months = '0' + months;
            // }
            // if(bill.OutboundVATInvNo__c == null){ASAP-CN-2305-006
            //     if(max <10){
            //         bill.OutboundVATInvNo__c = 'ASAP' + First + yearMonth +'-'+ '00' +(max+1);
            //         bill.OutboundInvDate__c = today;
            //     }
            //     else{
            //         bill.OutboundVATInvNo__c = 'ASAP' + First + yearMonth +'-'+ '0' +(max+1);
            //         bill.OutboundInvDate__c = today;
            //     }
            // }
            if(agentID == shipment.MAgent__c || agentID == shipment.Agent2nd__c){
                if(bill.InvoiceTo__c == agentID){
                    First = '-DN-';
                    if(bill.OutboundVATInvNo__c == null){
                        bill.OutboundVATInvNo__c = 'ASAP' + First + yearMonth +'-'+String.valueOf((maxDebit+1)).leftPad(3, '0');
                        bill.OutboundInvDate__c = today;
                        lstBillUpdate.add(bill);
                    }
                } else if(bill.PaymentTo__c == agentID){
                    First = '-CN-';
                    if(bill.InvNoonCreditfromCompany__c == null){
                        bill.InvNoonCreditfromCompany__c = 'ASAP' + First + yearMonth +'-'+String.valueOf((maxCredit+1)).leftPad(3, '0');
                        bill.CompanyCreditDate__c = today;
                        lstBillUpdate.add(bill);
                    }
                }
            }
            else{
                if(bill.InvoiceTo__c == agentID){
                    First = '-LDN-';
                    if(bill.OutboundVATInvNo__c == null){
                        bill.OutboundVATInvNo__c = 'ASAP' + First + yearMonth +'-'+String.valueOf((maxDebit+1)).leftPad(3, '0');
                        bill.OutboundInvDate__c = today;
                        lstBillUpdate.add(bill);
                    }
                } else if(bill.PaymentTo__c == agentID){
                    First = '-LCN-';
                    if(bill.InvNoonCreditfromCompany__c == null){
                        bill.InvNoonCreditfromCompany__c = 'ASAP' + First + yearMonth +'-'+String.valueOf((maxCredit+1)).leftPad(3, '0');
                        bill.CompanyCreditDate__c = today;
                        lstBillUpdate.add(bill);
                    }
                }
            }
            
        }

        for(ConsolBill__c bill : lstBill2){

            if(bill.InvoiceTo__c == agentID){
                First = '-DN-';
                if(bill.Debit_No__c == null){
                    bill.Debit_No__c = 'ASAP' + First + yearMonth +'-'+String.valueOf((maxDebit+1)).leftPad(3, '0');
                    bill.Date_on_Debit_note__c = today;
                    lstConsolBillUpdate.add(bill);
                }
            } else if(bill.PaymentTo__c == agentID){
                First = '-CN-';
                if(bill.InvNoonCreditfromCompany__c == null){
                    bill.InvNoonCreditfromCompany__c = 'ASAP' + First + yearMonth +'-'+String.valueOf((maxCredit+1)).leftPad(3, '0');
                    bill.CompanyCreditDate__c = today;
                    lstConsolBillUpdate.add(bill);
                }
            }
            
        }

        if(official == 'true' && lstBillUpdate.size()>0){

            update lstBillUpdate;  
        }
        if(official == 'true' && lstConsolBillUpdate.size()>0){

            update lstConsolBillUpdate;  
        }
        // return null;
    }
    public List<SelectOption> getCustomerList(){
        
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('none', '-- select -- '));
        // List<FTMSBill__c> bills = [SELECT Id, InvoiceTo__c, InvoiceTo__r.Name 
        //                                 FROM FTMSBill__c
        //                                 WHERE FTMSSO__c IN : lstIDship2
        //                                 ORDER BY Name];
        List<AdvancedShipment__c> bills = [SELECT MAgent__c, MAgent__r.Name, Agent2nd__c, Agent2nd__r.Name 
                                            FROM AdvancedShipment__c
                                            WHERE id =: shipmentID];
        List<ConsolBill__c> bills2 = [SELECT Id, InvoiceTo__c, InvoiceTo__r.Name, PaymentTo__c, PaymentTo__r.Name
                                        FROM ConsolBill__c
                                        WHERE ConsolidationShipmentName__c =: shipmentID
                                        ORDER BY Name];
        Set<Id> customerIds = new Set<Id>();

        for(AdvancedShipment__c bill: bills){
            If(!String.isBlank(bill.MAgent__c)){
                // IdCustomFirst = bill.InvoiceTo__c;
                customerId = bill.MAgent__r.Name;
                if(!String.isBlank(customerValue)){
                    customerId = customerValue;      
                }         
            }
        }

        for(ConsolBill__c bill2: bills2){
            If(!String.isBlank(bill2.InvoiceTo__c)){
                // IdCustomFirst = bill.InvoiceTo__c;
                customerId = bill2.InvoiceTo__r.Name;
                if(!String.isBlank(customerValue)){
                    customerId = customerValue;      
                }   
            }
            If(!String.isBlank(bill2.PaymentTo__c)){
                // IdCustomFirst = bill.InvoiceTo__c;
                customerId = bill2.PaymentTo__r.Name;
                if(!String.isBlank(customerValue)){
                    customerId = customerValue;      
                }   
            }
        }

         for(AdvancedShipment__c bill: bills){

                 if(!String.isBlank(bill.MAgent__c) && !customerIds.contains(bill.MAgent__c)){
                    options.add(new SelectOption(bill.MAgent__c, bill.MAgent__r.Name));           
                 }
                 if(!String.isBlank(bill.Agent2nd__c) && !customerIds.contains(bill.Agent2nd__c)){
                    options.add(new SelectOption(bill.Agent2nd__c, bill.Agent2nd__r.Name));           
                 }
                 customerIds.add(bill.MAgent__c);
                 customerIds.add(bill.Agent2nd__c);
         }

         for(ConsolBill__c bill: bills2){
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
        String strQueryBill = stringQueryBillforInvoiceNo(lstIDship,customerValue);
        String strQueryBill1 = stringQueryConsolBillforInvoiceNo(shipmentID,customerValue);
        List<FTMSBill__c> bills = new List<FTMSBill__c>();
        List<ConsolBill__c> billsConsol = new List<ConsolBill__c>();
        try {
            bills = Database.query(strQueryBill);
        } catch (QueryException e) {
            bills = new List<FTMSBill__c>();
        }

        try {
            billsConsol = Database.query(strQueryBill1);
        } catch (QueryException e) {
            billsConsol = new List<ConsolBill__c>();
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
                
        }

        for(ConsolBill__c bill: billsConsol){
            if (bill.InvoiceTo__c == customerValue){
                if(!String.isBlank(bill.Debit_No__c)){
                    if(!ouboundNo.contains(bill.Debit_No__c)) {
                        ouboundNo.add(bill.Debit_No__c);
                        options.add(new SelectOption(bill.Debit_No__c,bill.Debit_No__c));
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
                
        }
        return options;
    }
   

    private String stringQueryShipment(String shipmentId){
        String strSelect = 'SELECT RecordType.Name,' + String.join(new List<String>(setFields), ',');
        String strFrom = ' FROM AdvancedShipment__c ';
        String strWhere = 'WHERE Id = \'' + shipmentId + '\'' ;
        String strOrderBy = ' ORDER BY Name LIMIT 1';
        return strSelect + strFrom + strWhere + strOrderBy;
    }
    private String stringQueryBill(List<String> listShipmentId,String customerValue){
        String strSelect = 'SELECT ' + String.join(new List<String>(setFieldsBill), ',');
        String strFrom = ' FROM FTMSBill__c ';
        String strWhere;
        strWhere = 'WHERE (InvoiceTo__c = \'' + customerValue + '\' OR '+ 'PaymentTo__c = \'' + customerValue + '\') '+' AND FTMSSO__c IN ' + listShipmentId;
        if (InvoiceValue != null && InvoiceValue != 'none'){
            strWhere += ' AND (OutboundVATInvNo__c = \'' + InvoiceValue + '\' OR InvNoonCreditfromCompany__c = \''+InvoiceValue+'\')';
        }
        // String strOrderBy = ' ORDER BY clofor_com_cfs__SeikyuBangou__c';
        return strSelect + strFrom + strWhere ; 
    }
    private String stringQueryBillforInvoiceNo(List<String> listShipmentId,String customerValue){
        String strSelect = 'SELECT ' + String.join(new List<String>(setFieldsBill), ',');
        String strFrom = ' FROM FTMSBill__c ';
        String strWhere;
        strWhere = 'WHERE (InvoiceTo__c = \'' + customerValue + '\' OR '+ 'PaymentTo__c = \'' + customerValue + '\') '+' AND FTMSSO__c IN ' + listShipmentId;
        // String strOrderBy = ' ORDER BY clofor_com_cfs__SeikyuBangou__c';
        return strSelect + strFrom + strWhere ; 
    }

    private String stringQueryConsolBillforInvoiceNo(String shipmentID,String customerValue){
        String strSelect = 'SELECT ' + String.join(new List<String>(setFieldsConsolBill), ',');
        String strFrom = ' FROM ConsolBill__c ';
        String strWhere;
        strWhere = 'WHERE (InvoiceTo__c = \'' + customerValue + '\' OR '+ 'PaymentTo__c = \'' + customerValue + '\') '+' AND ConsolidationShipmentName__c = \'' + shipmentID + '\'';
        // String strOrderBy = ' ORDER BY clofor_com_cfs__SeikyuBangou__c';
        System.debug('1235: ' + strSelect + strFrom + strWhere);
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

    public class ResultWrapperSO{
        // public FTMSBill__c bill2 {get; set;} {}
        public String HBLnumber {get;set;}
        public List<FTMSBill__c> listBillSO {get;set;}
        public List<ConsolBill__c> listBillConsol {get;set;}
        public ResultWrapperSO(){
            this.HBLnumber = '';
            this.listBillSO = new List<FTMSBill__c>();
            this.listBillConsol = new List<ConsolBill__c>();
        }
    }
}