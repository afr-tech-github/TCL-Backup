public with sharing class PrintCreditNoteController {
    public FTMSSO__c shipment {get; set;}
    public List<FTMSBill__c> lstBill {get; set;}
    public Account cus {get; set;}
    public CompanyInformation__c ComInf {get; set;}
    public List<CntrinTrans__c> lstCont {get; set;}
    public String recordType {get; set;}
    public Decimal totalVND {get; set;}
    public Decimal totalUSD {get; set;}
    public String curr {get; set;}
    public String readTotalAmountVND {get; set;}
    public String readTotalAmountUSD {get; set;}
    public Date today {get; set;}
    public String userName {get; set;}
    public String InvoiceNo {get; set;}
    private String shipId {get; set;}
    private String cusId {get; set;}
    public String ankenIds {get; set;}
    public String customerValue {get; set;}
    public String InvoiceValue {get; set;}
    private static Set<String> fieldsShipQuery = new Set<String>();
    public static List<String> lstAnken = new List<String>();
    // private static Set<String> fieldsBillQuery = new Set<String>();
    static {
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
        fieldsShipQuery.add('Branch__c');
        fieldsShipQuery.add('HBLNumber__c');
        fieldsShipQuery.add('recordType.DeveloperName');
        fieldsShipQuery.add('JobRequestID__c');
        fieldsShipQuery.add('CargoType__c');
        fieldsShipQuery.add('AgentsdebitcreditNo__c');
        fieldsShipQuery.add('Agent__c');
        fieldsShipQuery.add('RecordType.Name');
        fieldsShipQuery.add('Agent2nd__c');
    }
    private static Set<String> fieldsBillQuery = new Set<String>();
    static {
        fieldsBillQuery.add('Id');
        fieldsBillQuery.add('BillNameatPrintENG__c');
        // fieldsBillQuery.add('POD__c');
        fieldsBillQuery.add('UnitPriceofBuyingFCY__c');
        fieldsBillQuery.add('UnitPriceofBuyingLocal__c');
        fieldsBillQuery.add('ChargeQuantity__c');
        fieldsBillQuery.add('ChargeUnit__c');
        fieldsBillQuery.add('TaxRateBuying__c');
        fieldsBillQuery.add('TotalAmountofBuyingFCY__c');
        fieldsBillQuery.add('TotalAmountofBuyingLocal__c');
        fieldsBillQuery.add('AmountTaxBuyingLocal__c');
        fieldsBillQuery.add('AmountTaxBuyingFCY__c');
        fieldsBillQuery.add('TotalBuyingInclTaxLocal__c');
        fieldsBillQuery.add('TotalBuyingInclTaxFCY__c');
        fieldsBillQuery.add('CurrencyBuying__c');
        fieldsBillQuery.add('PaymentTo__c');
        fieldsBillQuery.add('InvNoonCreditfromCompany__c');
        fieldsBillQuery.add('CompanyCreditDate__c');
        fieldsBillQuery.add('MMYY_Credit__c');
        fieldsBillQuery.add('Credit_Check__c');
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
    private static Set<String> fieldsContQuery = new Set<String>();
    static {
        fieldsContQuery.add('Id');
        fieldsContQuery.add('Name');
        fieldsContQuery.add('Container_Number__c');
    }

    public PrintCreditNoteController() {
        shipId = ApexPages.currentPage().getParameters().get('Id');
        cusId = ApexPages.currentPage().getParameters().get('cusId');
        customerValue = ApexPages.currentPage().getParameters().get('customerValue');
        InvoiceValue = ApexPages.currentPage().getParameters().get('Invoice');
        ankenIds = ApexPages.currentPage().getParameters().get('BillId');
        String Draft = ApexPages.currentPage().getParameters().get('Draft');
        String Official = ApexPages.currentPage().getParameters().get('Official');
        if(!String.isBlank(ankenIds)){
            lstAnken = ankenIds.split(',');
        }
        today = Date.today();
        shipment = getShipment(shipId);
        lstBill = getListBill(shipId,customerValue,InvoiceValue);
        System.debug('lstBill :'+lstAnken);
        cus = getAccount(customerValue);
        ComInf = getComIn(shipment.Branch__c);
        lstCont = getListCont(shipId);
        if (shipment.recordType.DeveloperName == 'AirExport'|| shipment.recordType.DeveloperName == 'OceanExport') {
            recordType = 'EXPORT';
        } else {
            recordType = 'IMPORT';
        }
        totalVND = 0;
        totalUSD = 0;
        InvoiceNo = '';
        for (FTMSBill__c bill : lstBill){
            if (bill.CurrencyBuying__c == 'VND'){
                if (bill.TotalBuyingInclTaxLocal__c != null){
                    totalVND += bill.TotalBuyingInclTaxLocal__c;
                }
            } else if (bill.CurrencyBuying__c == 'USD'){
                if (bill.TotalBuyingInclTaxFCY__c != null){
                    totalUSD += bill.TotalBuyingInclTaxFCY__c;
                }
            }
            InvoiceNo = bill.InvNoonCreditfromCompany__c;
        }

        String strQuery = 
        'SELECT InvNoonCreditfromCompany__c' 
        + ' FROM FTMSBill__c'
        + ' WHERE FTMSSO__c = \'' + String.escapeSingleQuotes(shipId) + '\' AND PaymentTo__c = \''+ String.escapeSingleQuotes(customerValue) + '\'';
        strQuery += ' ORDER BY Name LIMIT 1';
        FTMSBill__c data = Database.query(strQuery);
        // if (customerValue != shipment.Agent__c){
        //     InvoiceNo = data.InvNoonCreditfromCompany__c;
        // } else {
        //     InvoiceNo = shipment.AgentsdebitcreditNo__c;
        // }

        //if((Draft == 'true') || (Official == 'true')){

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
                        InvoiceNo = 'ASAP' + First + yearMonth +'-'+ '00' +(max+1);
                        bill.CompanyCreditDate__c = today;
                    }
                    if(max >= 10 && max < 100){
                        InvoiceNo = 'ASAP' + First + yearMonth +'-'+ '0' +(max+1);
                        bill.CompanyCreditDate__c = today;
                    }
                    if(max >= 100){
                        InvoiceNo = 'ASAP' + First + yearMonth +'-' +(max+1);
                        bill.CompanyCreditDate__c = today;
                    }
                    // bill.InvoiceNo__c = 'ASAP' + First + yearMonth +'-'+ + '0'+ (max+1);
                    // bill.CompanyCreditDate__c = today;
                }
                // if(customerValue == shipment.Agent__c){
                //     InvoiceNo = shipment.AgentsdebitcreditNo__c;
                // }
                // if(bill.InvNoonCreditfromCompany__c != null ){
                //     InvoiceNo = bill.InvNoonCreditfromCompany__c;
                // }
                System.debug('64: '+ InvoiceNo);
            }
        //}
        
        System.debug('InvoiceNo :'+InvoiceNo);

        readTotalAmountVND = EnglishNumberToWords.convert(totalVND.setScale(2));
        readTotalAmountUSD = EnglishNumberToWords.convert(totalUSD.setScale(2));
        
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

    private List<FTMSBill__c> getListBill(String shipId, String customerValue, String InvoiceValue){
        String strSelect = String.join(new List<String>(fieldsBillQuery), ',');
        String strQuery = 'SELECT ' + strSelect 
                    + ' FROM FTMSBill__c'
                    + ' WHERE FTMSSO__c = \'' + String.escapeSingleQuotes(shipId) + '\' AND PaymentTo__c = \''+ String.escapeSingleQuotes(customerValue) + '\'';
        String strWhere = '';
        if(lstAnken.size() > 0){
            strWhere += ' AND Id IN : lstAnken' ;
         } 
         else{
            strWhere += ' AND InvNoonCreditfromCompany__c = \'' + String.escapeSingleQuotes(InvoiceValue) + '\'';
         }
         
         strQuery += strWhere;
         strQuery += ' ORDER BY Name ASC';
         System.debug('626: '+ strQuery);
        List<FTMSBill__c> listBill;
        try{
            listBill = Database.query(strQuery);
        } catch(QueryException e){
            listBill = new List<FTMSBill__c>();
        }
        return listBill;
    }

    private Account getAccount(String customerValue){
        String strSelect = String.join(new List<String>(fieldsAccQuery), ',');
        String strQuery = 'SELECT ' + strSelect 
                    + ' FROM Account'
                    + ' WHERE Id = \'' + String.escapeSingleQuotes(customerValue) + '\'';
        Account acc;
        try{
            acc = Database.query(strQuery);
        } catch(QueryException e){
            acc = new Account();
        }
        return acc;
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