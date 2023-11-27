public with sharing class CreditNoteSelectionController_V2 {
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

    static{

        setFields.add('Name');
        setFields.add('RecordTypeId');
        setFields.add('Agent__c');
        setFields.add('Agent__r.Name');
        setFields.add('Agent2nd__c');
        setFields.add('Agent2nd__r.Name');

    }

    static{
        setFieldsBill.add('Name');
        setFieldsBill.add('PaymentTo__r.Name');
        setFieldsBill.add('PaymentTo__r.Name');
        setFieldsBill.add('InvNoonCreditfromCompany__c');
        setFieldsBill.add('CompanyCreditDate__c');
        setFieldsBill.add('BillNameatPrintENG__c');
        setFieldsBill.add('ChargeQuantity__c');
        setFieldsBill.add('ChargeUnit__c');
        setFieldsBill.add('CurrencyBuying__c');
        setFieldsBill.add('TaxRateBuying__c');
        setFieldsBill.add('TotalAmountofBuyingFCY__c');
        setFieldsBill.add('TotalBuyingInclTaxFCY__c');
        setFieldsBill.add('TotalAmountofBuyingLocal__c');
        setFieldsBill.add('TotalBuyingInclTaxLocal__c');
        setFieldsBill.add('MMYY_Credit__c');
        setFieldsBill.add('Credit_Check__c');
        setFieldsBill.add('InvNoonCreditfromCompany__c');
        setFieldsBill.add('CompanyCreditDate__c');
    }
    public CreditNoteSelectionController_V2() {
        // System.debug('1DEBUG:' + UserInfo.getLanguage()) ;
        shipmentID = ApexPages.currentPage().getParameters().get('id');
        
        // System.debug('shipID :'+shipID);
        shipment = new FTMSSO__c();
        arrResult = new List<ResultWrapper>();
        arrResult2 = new List<FTMSBill__c>();
        arrResult3 = new List<ResultWrapper>();
        arrResult4 = new List<ResultWrapper2>();
        lstbill = new List<FTMSBill__c>();
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
        // String temp = String.valueOf([Select PaymentTo__c From FTMSBill__c where FTMSSO__c =: shipmentID ORDER By Name LIMIT 1]);
        List<FTMSBill__c> bills = [SELECT PaymentTo__c
                                        FROM FTMSBill__c
                                        WHERE FTMSSO__c =: shipmentID
                                        ORDER By Name LIMIT 1];
        for(FTMSBill__c bill : bills){
            temp = bill.PaymentTo__c;
        }
        List<FTMSBill__c> bills2 = [SELECT PaymentTo__c
                                        FROM FTMSBill__c
                                        WHERE FTMSSO__c =: shipmentID AND PaymentTo__c =: shipID
                                        ORDER By Name LIMIT 1];
        for(FTMSBill__c bill2 : bills2){
            temp2 = bill2.PaymentTo__c;
        }
        
        if(shipID == null){
            shipID = temp;
            if(temp == null){
                shipID = '';
            }
        }else
        {
            shipID =  temp2;
        }
    
        strQuery = stringQueryShipment(shipmentID);
        strQueryBill = stringQueryBill(shipmentID);
        strQueryBilling = stringQueryBilling(shipmentID);
        strQueryBill2 = stringQueryBill2(customerValue,InvoiceValue);
        String strQueryBilling2 = stringQueryBilling2(customerValue,InvoiceValue);
        System.debug('strQueryBilling2 :'+strQueryBilling2);
        strQueryBill3 = stringQueryBill3(customerValue, shipmentID);
        lstbill = Database.query(strQueryBill);
       
        
        shipment = Database.query(strQuery);
        Form = '';
        // if(customerValue == shipment.Agent__c){
        //     Form = 'agent';
        // }
        // else{
        //     Form = 'notAgent';
        // }
        // if(formno != null || formno != '' || formno != 'none'){
        //     billing = Database.query(strQueryBilling2);
        // }
        // billing2 = Database.query(stringQueryBilling3(customerValue, InvoiceValue));
        
        Integer a = 0;
        
        
        arrResult = getDataBill(strQueryBill);
        if (arrResult.size()<10){
            a = 10-arrResult.size();
            
        }
        for(Integer i = 0; i<=a;i++){
            ResultWrapper arr = new ResultWrapper();
            arrResult3.add(arr);
        }
        System.debug('Thong debug :'+arrResult3);

        // arrResult2 = getDataBill2(strQueryBill2);
        if(customerValue != null){

            arrResult2 = Database.query(strQueryBill2);
        }
        arrResult4 = getDataBill2(strQueryBill3);
        //arrResult1 = getDataShipment();
        for(ResultWrapper2 outbound : arrResult4){
            if(outbound.OutboundInvoiceNo2 != null){
                listOubound.add(outbound.OutboundInvoiceNo2);
            }
        }
        listOubound2.addAll(listOubound);
        System.debug('listOubound :'+listOubound);
        System.debug('listOubound2 :'+listOubound2);
        
        language = 'en';
        docType = 'debit';
        currencyType = 'Both';
        bankType = 'local1';
        templateType = 'official';
        fileType = 'pdf';
        InvoiceNo = '';
        
        strQueryCustomer = '';
        // InvoiceNo = getDataShipment();
        System.debug('gggggg :'+InvoiceNo);
        // requiredAttachmentCreation = true;
       
        

        if(ApexPages.currentPage().getParameters().get('Draft') != null){
            Draft = Boolean.valueOf(ApexPages.currentPage().getParameters().get('Draft'));
        }
        if(ApexPages.currentPage().getParameters().get('Official') != null){
            Official = Boolean.valueOf(ApexPages.currentPage().getParameters().get('Official'));
        }
        if(ApexPages.currentPage().getParameters().get('requiredAttachmentCreation') != null){
            requiredAttachmentCreation = Boolean.valueOf(ApexPages.currentPage().getParameters().get('requiredAttachmentCreation'));
        }
        ouboundValue = String.valueOf(ApexPages.currentPage().getParameters().get('ouboundValue'));
        System.debug('120'+Official);
        System.debug('ouboundValue :'+ouboundValue);
        // if(Draft == null){
        //     Draft =false;
        // }
        String filename =shipment.Name +'_請求書_';
        Apexpages.currentPage().getHeaders().put('Content-Type', 'text/html; charset="UTF-8"');

        Apexpages.currentPage().getHeaders().put('content-disposition', 'inline; filename=\"'+EncodingUtil.urlEncode(filename,'utf-8'));
        // EncodingUtil.urlEncode(filename,'uft-8');

        System.debug('show debug :'+requiredAttachmentCreation);
        Set<String> languagesAvailable = new Set<String>{'en','vi','ko','ja','zh'};
        for(String la : languagesAvailable){
            if(UserInfo.getLanguage().contains(la)){
                language = la;
            }
        }
        List<FTMSBill__c> lstBill = new List<FTMSBill__c>();
        lstBill = Database.query(strQueryBill);
        Integer count = 1;
        For (FTMSBill__c bill: lstBill){
            count++;
        }
        rowcount = 16-count;
        
        if(shipment.RecordType.Name =='Ocean Export' || shipment.RecordType.Name == 'Ocean Import'){
            reportType = 'sea';
        }
        if(shipment.RecordType.Name == 'Air Export' || shipment.RecordType.Name == 'Air Import'){
            reportType = 'air';
        }


        
        if(shipment.RecordType.Name =='Ocean Export' ||shipment.RecordType.Name == 'Air Export'){
            reportType = 'export';
        }
        if(shipment.RecordType.Name == 'Ocean Import' || shipment.RecordType.Name == 'Air Import'){
            reportType = 'import';
        }

        String customerIdSelect = ApexPages.currentPage().getParameters().get('customerId');
        System.debug('customerIdSelect :'+customerIdSelect);
        List<FTMSBill__c> bills9 = [SELECT Id, PaymentTo__c, PaymentTo__r.Name
                                        FROM FTMSBill__c
                                        WHERE FTMSSO__c =: shipmentID AND PaymentTo__c =:customerIdSelect
                                        ORDER BY Name LIMIT 1];

        for(FTMSBill__c bill: bills9){
            If(!String.isBlank(bill.PaymentTo__c)){
                IdCustomFirst = bill.PaymentTo__c;
                customerId = bill.PaymentTo__r.Name;
                // companyjapan = bill.PaymentTo__r.CompanyNoJapan__c;
                // System.debug('thong debugggg :'+companyjapan);
                System.debug('Idfirst:'+ IdCustomFirst);
                System.debug('customer:'+ customerId);
                break;
            }
        }

        
}

    

    public PageReference saveOnchangeApex(){
        
        return null;  
    }


    // public void test(){
    //     if(Draft = true){
    //         Official = true;
    //     }
 
    // }

    public void generateAttachmentFile(){
        System.debug('loggg :');
        String strAkens = '';
        strAkens = ApexPages.currentPage().getParameters().get('BillId');
        Boolean requiredAttachmentCreation = false;
        // if(ApexPages.currentPage().getParameters().get('value') != null){
        //     String InvoiceValue = ApexPages.currentPage().getParameters().get('value');
        // }
        // if(ApexPages.currentPage().getParameters().get('customerValue') != null){
        //     String customerValue = ApexPages.currentPage().getParameters().get('customerValue');
        // }
        // if(ApexPages.currentPage().getParameters().get('requiredAttachmentCreation') != null){
        //     requiredAttachmentCreation = Boolean.valueOf(ApexPages.currentPage().getParameters().get('requiredAttachmentCreation'));
        // }
        if(ApexPages.currentPage().getParameters().get('requiredAttachmentCreation') != null){
            requiredAttachmentCreation = Boolean.valueOf(ApexPages.currentPage().getParameters().get('requiredAttachmentCreation'));
        }

        System.debug('loggg :'+requiredAttachmentCreation);
        
        PageReference pdf_file =Page.page_PrintCreditNote;
        pdf_file.getParameters().put('Id', shipmentID);
        pdf_file.getParameters().put('Draft', 'false');
        pdf_file.getParameters().put('Official', 'false');
        pdf_file.getParameters().put('BillId', strAkens);
        pdf_file.getParameters().put('Invoice', InvoiceValue);
        pdf_file.getParameters().put('requiredAttachmentCreation', 'false');
        pdf_file.getParameters().put('customerValue', customerValue);

        System.debug('shipmentID :'+shipmentID);
        System.debug('strAkens :'+strAkens);
        System.debug('Invoice :'+InvoiceValue);
        System.debug('customerValue :'+customerValue);
        
        FTMSSO__c item = new FTMSSO__c();
        String strSelect = 'SELECT ' + String.join(new List<String>(setFields), ',');
        String strFrom = ' FROM FTMSSO__c ';
        String strWhere = 'WHERE Id = \'' + shipmentId + '\'' ;
        String strOrderBy = ' ORDER BY Name LIMIT 1';
        String data = strSelect + strFrom + strWhere + strOrderBy;
        item = Database.query(data);
        String namefile =item.Name +'_CreditNote_' ;

       
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
        String strWhere = 'WHERE FTMSSO__c = \'' + shipmentId + '\'' +  ' AND Id IN : lstBillIds';
        String strOrderBy = ' ORDER BY Name';
        String query = strSelect + strFrom + strWhere +strOrderBy;  

        String strSelect1 = 'SELECT ' + String.join(new List<String>(setFieldsBill), ',');
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
            System.debug('27: ' + bill1.MMYY_Credit__c);
            if(bill1.InvNoonCreditfromCompany__c != null && bill1.MMYY_Credit__c == yearMonth){
                String endPoint = bill1.Credit_Check__c;
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
            if(bill.PaymentTo__c == shipment.Agent__c || bill.PaymentTo__c == shipment.Agent2nd__c){
                First = '-CN-';
            }
            else{
                First = '-LCN-';
            }
            if(Integer.valueOf(today.month()) < 10){
                months = '0' + months;
            }
            if(bill.InvNoonCreditfromCompany__c == null){
                if(max <10){
                    bill.InvNoonCreditfromCompany__c = 'ASAP' + First + yearMonth +'-'+ '00' +(max+1);
                    bill.CompanyCreditDate__c = today;
                }
                if(max >= 10 && max < 100){
                    bill.InvNoonCreditfromCompany__c = 'ASAP' + First + yearMonth +'-'+ '0' +(max+1);
                    bill.CompanyCreditDate__c = today;
                }
                if(max >= 100){
                    bill.InvNoonCreditfromCompany__c = 'ASAP' + First + yearMonth +'-' +(max+1);
                    bill.CompanyCreditDate__c = today;
                }
                // bill.InvNoonCreditfromCompany__c = 'ASAP' + First + yearMonth +'-'+ + '0'+ (max+1);
                // bill.CompanyCreditDate__c = today;
            }
        }
        if(official == 'true'){
            update lstBill;  
        }
        // return null;
    }


    private List<ResultWrapper> getDataBill(String strQueryy){
        List<ResultWrapper> results = new List<ResultWrapper>();
        List<FTMSBill__c> lstBill = new List<FTMSBill__c>();
        lstBill = Database.query(strQueryy);
        
        Integer count = 1;
        For (FTMSBill__c bill: lstBill){
           
            ResultWrapper item = new ResultWrapper();
            item.Index = count;
            count++;
            
            results.add(item);
            
      
        }  
        System.debug('ccccccccc :'+results);
        return results;
        
    }

    private List<ResultWrapper2> getDataBill2(String strQuery){
        List<ResultWrapper2> results = new List<ResultWrapper2>();
        List<FTMSBill__c> lstBill = new List<FTMSBill__c>();
        lstBill = Database.query(strQuery);
        
        Integer count = 1;
        For (FTMSBill__c bill: lstBill){
            
            ResultWrapper2 item = new ResultWrapper2();
            item.Id = bill.Id;
            item.Index2 = count;
            item.OutboundInvoiceNo2 = bill.InvNoonCreditfromCompany__c;

            count++;
            
            results.add(item);
            
      
        }  
        System.debug('kkkkkk :'+count);
        return results;
        
    }


    private String getDataShipment(){
        FTMSSO__c item = new FTMSSO__c();
        String strSelect = 'SELECT ' + String.join(new List<String>(setFields), ',');
        String strFrom = ' FROM FTMSSO__c ';
        String strWhere = 'WHERE Id = \'' + shipmentId + '\'' ;
        String strOrderBy = ' ORDER BY Name LIMIT 1';
        String data = strSelect + strFrom + strWhere + strOrderBy;
        item = Database.query(data);

        List<FTMSBill__c> bill = new List<FTMSBill__c>();
        String strSelect2 = 'SELECT Id, Name,InvNoonCreditfromCompany__c';
        String strFrom2 = ' FROM FTMSBill__c ';
        String strWhere2 = 'WHERE FTMSSO__c = \'' + shipmentId + '\'' ;
        String strOrderBy2 = ' ORDER BY Name';
        String data2 = strSelect2 + strFrom2 + strWhere2 + strOrderBy2;
        bill = Database.query(data2);
        System.debug('billlll :'+bill);
        List<Decimal> billDecimal = new List<Decimal>();
        String test123 = '';
            for(FTMSBill__c e : bill){
                // billDecimal.add(Decimal.valueOf(e.InvNoonCreditfromCompany__c.substringAfter('-')));
                if(e.InvNoonCreditfromCompany__c != null){
                    billDecimal.add(Decimal.valueOf(e.InvNoonCreditfromCompany__c.substringAfter('-')));
                }else{
            
                    billDecimal.add(0);   
                }
            }

        System.debug('billDecimal :'+billDecimal);
        Decimal maxvalue = billDecimal[0];
        for(Integer i = 0; i < billDecimal.size(); i++){
            if(billDecimal[i] > maxvalue){
                maxvalue = billDecimal[i];
            }
        }

        System.debug('maxvalue :'+maxvalue);
        Decimal maxvaluemax = maxvalue+1;
        // String invoiceoutbound =item.Name +'_請求書_'+ item.clofor_com_cfs__HBL_Number_SEA_AIR__c ;
        String invoiceoutbound = 'IV'+item.Name+'-'+ maxvaluemax;
        System.debug('invoiceoutbound :'+invoiceoutbound.substringAfter('-'));
        return invoiceoutbound;
    }

    public PageReference closePopupDialog() {
        PageReference page = new PageReference('/'+shipmentID);
        page.setRedirect(true);
        return page;
    } 

    public List<SelectOption> getCustomerList(){
        
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('none', '-- select -- '));
        List<FTMSBill__c> bills = [SELECT Id, PaymentTo__c, PaymentTo__r.Name 
                                        FROM FTMSBill__c
                                        WHERE FTMSSO__c =: shipmentID
                                        ORDER BY Name];
        Set<Id> customerIds = new Set<Id>();

        for(FTMSBill__c bill: bills){
            If(!String.isBlank(bill.PaymentTo__c)){
                // IdCustomFirst = bill.PaymentTo__c;
                customerId = bill.PaymentTo__r.Name;
                if(!String.isBlank(customerValue)){
                    customerId = customerValue;      
                }

               
            }
        }

         for(FTMSBill__c bill: bills){

                 if(!String.isBlank(bill.PaymentTo__c) && !customerIds.contains(bill.PaymentTo__c)){
                    options.add(new SelectOption(bill.PaymentTo__c, bill.PaymentTo__r.Name));
                    
                 }
                 customerIds.add(bill.PaymentTo__c);
         }
        System.debug('Debugggg :'+customerIds);
        return options;
    }
    public List<SelectOption> getOuboundList(){
        List<FTMSBill__c> bills = [SELECT Id, InvNoonCreditfromCompany__c 
        FROM FTMSBill__c
        WHERE FTMSSO__c =: shipmentID
        ORDER BY Name];
        System.debug('1123: ' + bills);
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('none', '-- None -- '));

        Set<Id> ouboundIds = new Set<Id>();

        for(FTMSBill__c bill: bills){
            if(!String.isBlank(bill.InvNoonCreditfromCompany__c)){
                if(!String.isBlank(InvoiceValue)){
                    ouboundId = InvoiceValue;      
                }  
            }
        }
         for(String outbound : listOubound2){
            
                options.add(new SelectOption(outbound,outbound)); 
          
            // ouboundIds.add(outbound);
        }

        return options;
    }
   

    private String stringQueryShipment(String shipmentId){
        String strSelect = 'SELECT RecordType.Name,' + String.join(new List<String>(setFields), ',');
        String strFrom = ' FROM FTMSSO__c ';
        String strWhere = 'WHERE Id = \'' + shipmentId + '\'' ;
        String strOrderBy = ' ORDER BY Name LIMIT 1';
        return strSelect + strFrom + strWhere + strOrderBy;
    }

    private String stringQueryBill(String shipmentId){
         String strSelect = 'SELECT ' + String.join(new List<String>(setFieldsBill), ',');
         String strFrom = ' FROM FTMSBill__c ';
         String strWhere = 'WHERE FTMSSO__c = \'' + shipmentId + '\'';
        //  String strOrderBy = ' ORDER BY clofor_com_cfs__SeikyuBangou__c ';
         return strSelect + strFrom + strWhere ; 
     }
     private String stringQueryBilling(String shipmentId){
        String strSelect = 'SELECT ' + String.join(new List<String>(setFieldsBill), ',');
        String strFrom = ' FROM FTMSBill__c ';
        String strWhere = 'WHERE FTMSSO__c = \'' + shipmentId ;
        String strOrderBy = ' ORDER BY Name LIMIT 1';
        return strSelect + strFrom + strWhere + strOrderBy; 
    }
    private String stringQueryBill2(String customerValue, String InvoiceValue){
        shipmentID = ApexPages.currentPage().getParameters().get('id');
        String strSelect = 'SELECT ' + String.join(new List<String>(setFieldsBill), ',');
        String strFrom = ' FROM FTMSBill__c ';
        String strWhere;
        if(InvoiceValue != null && customerValue != null){
            strWhere = 'WHERE PaymentTo__c = \'' + customerValue + '\''+' AND FTMSSO__c = \'' + shipmentId + '\''+' AND InvNoonCreditfromCompany__c = \'' + InvoiceValue + '\''; 
        }
        if(InvoiceValue == null || InvoiceValue == '' && customerValue != null){
            strWhere = 'WHERE PaymentTo__c = \'' + customerValue + '\''+' AND FTMSSO__c = \'' + shipmentId + '\'';
        }
        if(InvoiceValue == 'none' && customerValue != null){
            strWhere = 'WHERE PaymentTo__c = \'' + customerValue + '\''+' AND FTMSSO__c = \'' + shipmentId + '\'';
        }
        if(InvoiceValue != null && customerValue == null){
            strWhere = 'WHERE FTMSSO__c = \'' + shipmentId + '\''+' AND InvNoonCreditfromCompany__c = \'' + InvoiceValue + '\'';
        }
        if(InvoiceValue == null && customerValue == null){
            strWhere = 'WHERE FTMSSO__c = \'' + shipmentId + '\'';
        }
        if(InvoiceValue == null && customerValue == 'none'){
            strWhere = 'WHERE FTMSSO__c = \'' + shipmentId + '\'';
        }
        if(InvoiceValue != null && customerValue == 'none'){
            strWhere = 'WHERE FTMSSO__c = \'' + shipmentId + '\''+' AND InvNoonCreditfromCompany__c = \'' + InvoiceValue + '\'';
        }
        if(InvoiceValue == 'none' && customerValue == 'none'){
            strWhere = 'WHERE FTMSSO__c = \'' + shipmentId + '\'';
        }
        // String strOrderBy = ' ORDER BY clofor_com_cfs__SeikyuBangou__c';
        return strSelect + strFrom + strWhere ; 
    }
    private String stringQueryBilling3(String customerValue, String InvoiceValue){
        shipmentID = ApexPages.currentPage().getParameters().get('id');
        String strSelect = 'SELECT ' + String.join(new List<String>(setFieldsBill), ',');
        String strFrom = ' FROM FTMSBill__c ';
        String strWhere;
        if(InvoiceValue != null && customerValue != null){
            strWhere = 'WHERE PaymentTo__c = \'' + customerValue + '\''+' AND FTMSSO__c = \'' + shipmentId + '\''+' AND InvNoonCreditfromCompany__c = \'' + InvoiceValue + '\''; 
        }
        if(InvoiceValue == null || InvoiceValue == '' && customerValue != null){
            strWhere = 'WHERE PaymentTo__c = \'' + customerValue + '\''+' AND FTMSSO__c = \'' + shipmentId + '\'';
        }
        if(InvoiceValue == 'none' && customerValue != null){
            strWhere = 'WHERE PaymentTo__c = \'' + customerValue + '\''+' AND FTMSSO__c = \'' + shipmentId + '\'';
        }
        if(InvoiceValue != null && customerValue == null){
            strWhere = 'WHERE FTMSSO__c = \'' + shipmentId + '\'' + ' AND InvNoonCreditfromCompany__c = \'' + InvoiceValue + '\'';
        }
        if(InvoiceValue == null && customerValue == null){
            strWhere = 'WHERE FTMSSO__c = \'' + shipmentId + '\'';
        }
        if(InvoiceValue == null && customerValue == 'none'){
            strWhere = 'WHERE FTMSSO__c = \'' + shipmentId + '\'';
        }
        if(InvoiceValue != null && customerValue == 'none'){
            strWhere = 'WHERE FTMSSO__c = \'' + shipmentId + '\''+' AND InvNoonCreditfromCompany__c = \'' + InvoiceValue + '\'';
        }
        if(InvoiceValue == 'none' && customerValue == 'none'){
            strWhere = 'WHERE FTMSSO__c = \'' + shipmentId + '\'';
        }
        // String strOrderBy = ' ORDER BY clofor_com_cfs__SeikyuBangou__c LIMIT 1';
        return strSelect + strFrom + strWhere + ' LIMIT 1'; 
    }
    private String stringQueryBilling2(String customerValue, String InvoiceValue){
        shipmentID = ApexPages.currentPage().getParameters().get('id');
        
        String strSelect = 'SELECT ' + String.join(new List<String>(setFieldsBill), ',');
        String strFrom = ' FROM FTMSBill__c ';
        String strWhere;
        if(invoiceno != null && customerValue != null){
            strWhere = 'WHERE PaymentTo__c = \'' + customerValue + '\'' + 'AND FTMSSO__c = \'' + shipmentId + '\'' + ' AND InvNoonCreditfromCompany__c = \'' + invoiceno + '\''; 
        }
        if(invoiceno == null || invoiceno == 'none' && customerValue != null){
            strWhere = 'WHERE PaymentTo__c = \'' + customerValue + '\''+ ' AND FTMSSO__c = \'' + shipmentId + '\'';
        }
        if(invoiceno == null || invoiceno == 'none' && customerValue != null){
            strWhere = 'WHERE PaymentTo__c = \'' + customerValue + '\''+ ' AND FTMSSO__c = \'' + shipmentId + '\'';
        }
        if(invoiceno != null && customerValue == null){
            strWhere = 'WHERE FTMSSO__c = \'' + shipmentId + '\''+ '  AND InvNoonCreditfromCompany__c = \'' + invoiceno + '\'';
        }
        if(invoiceno == null && customerValue == null){
            strWhere = 'WHERE FTMSSO__c = \'' + shipmentId + '\'';
        }
        if(invoiceno == null && customerValue == 'none'){
            strWhere = 'WHERE FTMSSO__c = \'' + shipmentId + '\'';
        }
        if(invoiceno != null && customerValue == 'none'){
            strWhere = 'WHERE FTMSSO__c = \'' + shipmentId + '\''+ '  AND InvNoonCreditfromCompany__c = \'' + invoiceno + '\'';
        }
        // String strOrderBy = ' ORDER BY clofor_com_cfs__SeikyuBangou__c LIMIT 1';
        System.debug('342: ' + strSelect + strFrom + strWhere + ' LIMIT 1');
        return strSelect + strFrom + strWhere + 'LIMIT 1'; 
    }
    private String stringQueryBill3(String customerValue, String shipmentId){
        shipmentID = ApexPages.currentPage().getParameters().get('id');
        String strSelect = 'SELECT ' + String.join(new List<String>(setFieldsBill), ',');
        String strFrom = ' FROM FTMSBill__c ';
        String strWhere ;
        if(customerValue != null){
            strWhere = 'WHERE FTMSSO__c = \'' + shipmentId + '\''+' AND PaymentTo__c = \'' + customerValue + '\'';
        }
        if(customerValue != 'none'){
            strWhere = 'WHERE FTMSSO__c = \'' + shipmentId + '\''+' AND PaymentTo__c = \'' + customerValue + '\'';
        }
        if(customerValue == 'none') {
            strWhere = 'WHERE FTMSSO__c = \'' + shipmentId + '\'';
        }
        if(customerValue == null) {
            strWhere = 'WHERE FTMSSO__c = \'' + shipmentId + '\'';
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
}