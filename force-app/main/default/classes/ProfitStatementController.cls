public with sharing class ProfitStatementController {
    public FTMSSO__c shipment {get; set;}
    public CompanyInformation__c CompanyInfo {get; set;}
    public CntrinTrans__c CNTR {get;set;}
    public List<FTMSBill__c> lstBill {get; set;}
    // public List<FTMSBill__c > lstBillVendor {get; set;}
    // public List<FTMSBill__c> lstBillPartner {get; set;}
    // public List<FTMSBill__c> lstBillCustomer {get; set;}
    // public List<FTMSBill__c> lstBillVendor1 {get; set;}
    // public List<FTMSBill__c> lstBillPartner1 {get; set;}
    // public List<FTMSBill__c> lstBillCustomer1 {get; set;}

    public String strQuerySO {get;set;}
    public String strQueryCompanyInfo {get;set;}
    public String strQueryBill {get;set;}
    public String strQueryCNTR {get;set;}
    public String shipmentId {get; set;}
    public String MAWB_MBL {get;set;}
    // public String strQueryBillVendor {get;set;}
    // public String strQueryBillPartner {get;set;}
    // public String strQueryBillCustomer {get;set;}
    // public String strQueryBillVendor1 {get;set;}
    // public String strQueryBillPartner1 {get;set;}
    // public String strQueryBillCustomer1 {get;set;}

    public List<ResultWrapper> lstBillInvoice {get; set;}
    public List<ResultWrapper> lstBillPayment {get; set;}
    public List<ResultWrapper> lstBillBoth {get; set;}

    public List<ResultWrapper> lstInvoice {get; set;}
    public List<ResultWrapper> lstPayment {get; set;}
    public List<ResultWrapper> lstBoth1 {get; set;}
    public List<ResultWrapper> lstBoth2 {get; set;}
    // public List<ResultWrapper> lstBillVendor {get; set;}
    // public List<ResultWrapper> lstBillPartner {get; set;}
    // public List<ResultWrapper> lstBillCustomer {get; set;}

    public Decimal TotalCosting {get;set;}
    public Decimal TotalBilling {get;set;}
    public Decimal Profit {get;set;}
    public String TextSum {get;set;}
    public String UserName {get;set;}

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
        // setFieldBill.add('InvoiceTo__c');
        // setFieldBill.add('PaymentTo__c');
        
        ////////////////////////////////////////////////
        setFieldCNTR.add('Container_Number__c');
        setFieldCNTR.add('Container_Type__c');
        setFieldBill.add('PaymentTo__r.Name');
    }
    public ProfitStatementController() {
        shipmentId = ApexPages.currentPage().getParameters().get('id');
        System.debug('shipmentID : ' + shipmentId);
        shipment = new FTMSSO__c();
        CompanyInfo = new CompanyInformation__c();
        CNTR = new CntrinTrans__c();
        lstBill = new List<FTMSBill__c>();
        // lstBillCustomer = new List<FTMSBill__c>();
        // lstBillVendor = new List<FTMSBill__c>();
        // lstBillPartner = new List<FTMSBill__c>();
        // lstBillCustomer1 = new List<FTMSBill__c>();
        // lstBillPartner1 = new List<FTMSBill__c>();
        // lstBillVendor1 = new List<FTMSBill__c>();
        lstBillInvoice = new List<ResultWrapper>();
        lstBillPayment = new List<ResultWrapper>();
        lstBillBoth = new List<ResultWrapper>();

        List<String> CompanyName = new List<String>();
        List<String> InvoiceName = new List<String>();
        List<String> PaymentName = new List<String>();

        List<FTMSBill__c> lstCompany = new List<FTMSBill__c>();
        lstInvoice = new List<ResultWrapper>();
        lstPayment = new List<ResultWrapper>();
        lstBoth1 = new List<ResultWrapper>();
        lstBoth2 = new List<ResultWrapper>();

        strQuerySO = '';
        strQueryBill = '';
        strQueryCompanyInfo = '';
        strQueryCNTR = '';
        // strQueryBillVendor = '';
        // strQueryBillPartner = '';
        // strQueryBillCustomer = '';
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
        CNTR = Database.query(strQueryCNTR);
        System.debug('CNTR ne :' + shipment);
        lstBill  = Database.query(strQueryBill);
        System.debug('lstBill ne: ' + lstBill);

        // strQueryBillVendor = stringQueryBillVendor(shipmentId);
        // strQueryBillPartner = stringQueryBillPartner(shipmentId);
        // strQueryBillCustomer = stringQueryBillCustomer(shipmentId);

        // strQueryBillVendor1 = stringQueryBillVendor1(shipmentId);
        // strQueryBillPartner1 = stringQueryBillPartner1(shipmentId);
        // strQueryBillCustomer1 = stringQueryBillCustomer1(shipmentId);

        // System.debug('BillVendor :' + strQueryBillVendor);
        // lstBillVendor = Database.query(strQueryBillVendor);
        // System.debug('lstBillVendor :' + lstBillVendor);
        // lstBillCustomer = Database.query(strQueryBillCustomer);
        // lstBillPartner = Database.query(strQueryBillPartner);

        // lstBillVendor1 = Database.query(strQueryBillVendor1);
        // System.debug('lstBillVendor :' + lstBillVendor);
        // lstBillCustomer1 = Database.query(strQueryBillCustomer1);
        // lstBillPartner1 = Database.query(strQueryBillPartner1);

        lstBillInvoice = getBillInvoice(strQueryBill);
        System.debug('BillInvoice: ' + lstBillInvoice);
        lstBillPayment = getBillPayment(strQueryBill);
        System.debug('BillPayment: ' + lstBillPayment);
        lstBillBoth = getBillBoth(strQueryBill);
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
        for(FTMSBill__c bill : lstBill){
            String Company1 = '';
            String Company2 = '';
            if(bill.InvoiceTo__r.Name != null){
                Company1 = bill.InvoiceTo__r.Name;
                CompanyName.add(Company1);
            }
            if(bill.PaymentTo__r.Name != null){
                Company2 = bill.PaymentTo__r.Name;
                CompanyName.add(Company2);
            }
        }

        for(integer i=0; i < CompanyName.size(); i++) {
            for(integer j=0; j < CompanyName.size(); j++) {                                         
                if(CompanyName[i] == CompanyName[j] && i != j) {
                    CompanyName.remove(j); 
                    }
                }              
        }

        System.debug('Company Name : ' + CompanyName);
        
        integer i =0;
        for(ResultWrapper bill: lstBillInvoice){
            ResultWrapper item = new ResultWrapper();
            if(!PaymentName.contains(bill.Companies)){

                // item.BillName = bill.BillName;
                lstInvoice.add(bill);

                i++;   
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
        }

        integer k = 0;
        for(String Company: CompanyName){
            for(ResultWrapper bill: lstBillPayment){
                for(ResultWrapper bill1: lstBillInvoice){
                    if(bill.Companies == Company && bill.Companies == bill1.Companies){
                        lstBoth1.add(bill);
                        lstBoth2.add(bill1);
                        k++;
                        System.debug('Count2: ' + lstBoth1 + lstBoth2);

                    }
                }    
            }
        }
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

        TextSum =  ReadNumberToWords.convert(Profit.setScale(2, System.RoundingMode.HALF_UP));
        UserName = UserInfo.getName();
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

    // private String stringQueryBillVendor(String shipmentId){
    //     String strSelect = 'SELECT ' + String.join(new List<String>(setFieldBill), ',');
    //     String strFrom = ' FROM FTMSBill__c ';
    //     String strWhere = ' WHERE FTMSSO__c = \'' + shipmentId + '\'' + ' AND InvoiceTo__r.RecordType.Name = \''  + 'Vendor' + '\'' ;
    //     String strOrderBy = ' ORDER BY Name';
    //     return strSelect + strFrom + strWhere + strOrderBy;
    // }

    // private String stringQueryBillPartner(String shipmentId){
    //     String strSelect = 'SELECT ' + String.join(new List<String>(setFieldBill), ',');
    //     String strFrom = ' FROM FTMSBill__c ';
    //     String strWhere = ' WHERE FTMSSO__c = \'' + shipmentId + '\'' + ' AND InvoiceTo__r.RecordType.Name = \''  + 'Partner' + '\'' ;
    //     String strOrderBy = ' ORDER BY Name';
    //     return strSelect + strFrom + strWhere + strOrderBy;
    // }
    // private String stringQueryBillCustomer(String shipmentId){
    //     String strSelect = 'SELECT ' + String.join(new List<String>(setFieldBill), ',');
    //     String strFrom = ' FROM FTMSBill__c ';
    //     String strWhere = ' WHERE FTMSSO__c = \'' + shipmentId + '\'' + ' AND InvoiceTo__r.RecordType.Name = \''  + 'Customer' + '\'' ;
    //     String strOrderBy = ' ORDER BY Name';
    //     return strSelect + strFrom + strWhere + strOrderBy;
    // }

    // private String stringQueryBillVendor1(String shipmentId){
    //     String strSelect = 'SELECT ' + String.join(new List<String>(setFieldBill), ',');
    //     String strFrom = ' FROM FTMSBill__c ';
    //     String strWhere = ' WHERE FTMSSO__c = \'' + shipmentId + '\'' + ' AND PaymentTo__r.RecordType.Name = \''  + 'Vendor' + '\'' ;
    //     String strOrderBy = ' ORDER BY Name';
    //     return strSelect + strFrom + strWhere + strOrderBy;
    // }

    // private String stringQueryBillPartner1(String shipmentId){
    //     String strSelect = 'SELECT ' + String.join(new List<String>(setFieldBill), ',');
    //     String strFrom = ' FROM FTMSBill__c ';
    //     String strWhere = ' WHERE FTMSSO__c = \'' + shipmentId + '\'' + ' AND PaymentTo__r.RecordType.Name = \''  + 'Partner' + '\'' ;
    //     String strOrderBy = ' ORDER BY Name';
    //     return strSelect + strFrom + strWhere + strOrderBy;
    // }
    // private String stringQueryBillCustomer1(String shipmentId){
    //     String strSelect = 'SELECT ' + String.join(new List<String>(setFieldBill), ',');
    //     String strFrom = ' FROM FTMSBill__c ';
    //     String strWhere = ' WHERE FTMSSO__c = \'' + shipmentId + '\'' + ' AND PaymentTo__r.RecordType.Name = \''  + 'Customer' + '\'' ;
    //     String strOrderBy = ' ORDER BY Name';
    //     return strSelect + strFrom + strWhere + strOrderBy;
    // }

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
}