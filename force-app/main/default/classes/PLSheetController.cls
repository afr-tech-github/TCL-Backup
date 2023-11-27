public with sharing class PLSheetController {
    public AdvancedShipment__c ADshipment{get;set;}
    public List<FTMSSO__c> shipment {get; set;}
    public CompanyInformation__c CompanyInfo {get; set;}
    public ConsolCNTR__c CNTR {get;set;}
    public List<ConsolBill__c> lstAllBill {get; set;}
    public List<ConsolBill__c> lstBillSelling {get;set;}
    public List<ConsolBill__c> lstBillBuying {get;set;}
    public List<ConsolBill__c> REVENUEshipnull {get;set;}
    public List<ConsolBill__c> COSTshipnull {get;set;}
    public String JobID {get;set;}
    public static Set<String> setShipment {get;set;}
    public List<String> HBLshipment {get;set;}
    public List<ConsolCNTR__c> lstConsolCNTR {get;set;}
    public Decimal TotalSelling {get;set;}
    public Decimal TotalBuying {get;set;}
    public String userName {get;set;}
    public Decimal TotalProfit {get;set;}
    public Datetime now {get;set;}
    public List<String> lstShipment {get;set;}

    public String MAWB_MBL {get;set;}
    public String testCok {get;set;}
    public List<string> lstIDshipment {get;set;}

    private static Set<String> setFieldSO = new Set<String>();
    private static Set<String> setFieldBillingg = new Set<String>();
    private static Set<String> setFieldCNTR = new Set<String>();

    public List<ResultWrapperShipment> REVENUE {get; set;}
    public List<ResultWrapperShipment> COST {get; set;}

    static{
        setFieldSO.add('TypeofTrade__c');
        setFieldSO.add('FileNo__c');
        // setFieldSO.add('GrossWeight__c');
        // // setFieldSO.add('Measurement__c');
        setFieldSO.add('TransportationWay__c');
        setFieldSO.add('ShipmentTerm__c');
        setFieldSO.add('MAgent__r.Name');
        setFieldSO.add('VesselFlight__c');
        // setFieldSO.add('POD_Formul__c');
        // setFieldSO.add('POLformula__c');
        setFieldSO.add('Voyage__c');
        setFieldSO.add('MPOL__r.Name');
        setFieldSO.add('MPOD__r.Name');
        // setFieldSO.add('MBLNumber__c');
        setFieldSO.add('Name');
        setFieldSO.add('Master_Consolidator_Carrier__r.Name');
        setFieldSO.add('ETD__c');
        setFieldSO.add('ETA__c');
        setFieldSO.add('MeasurementCBM__c');
        setFieldSO.add('MShipper__r.AccountNameENG__c');
        setFieldSO.add('RecordType.Name');

        setFieldSO.add('Container_Qnty_1__c');
        setFieldSO.add('Container_Qnty_2__c');
        setFieldSO.add('Container_Qnty_3__c');
        setFieldSO.add('Container_Type_1__c');
        setFieldSO.add('Container_Type_2__c');
        setFieldSO.add('Container_Type_3__c');

        setFieldSO.add('MConsignee__r.AccountNameENG__c');
        setFieldSO.add('MBLorMAWBNumber__c');
        setFieldSO.add('SalesmanforPLApprovement__r.Name');
        setFieldSO.add('Commodity__r.Name');
        ////////////////////////////////////////////////
        setFieldCNTR.add('Container_Number__c');
        setFieldCNTR.add('Seal_Number__c');
        setFieldCNTR.add('Container_Type__c');

        ////////////////////////////////////////////////
        setFieldBillingg.add('Name');
        setFieldBillingg.add('BillNameatPrintENG__c');
        setFieldBillingg.add('Currency__c');
        setFieldBillingg.add('Currency_Selling__c');
        setFieldBillingg.add('TotalAmountofBuyingFCY__c');
        setFieldBillingg.add('TotalAmountofBuyingLocal__c');
        setFieldBillingg.add('ExchangeRateBuying__c');
        setFieldBillingg.add('ChargeUnit__c');
        setFieldBillingg.add('Container_Type__c');
        setFieldBillingg.add('AmountBuyingIncludingTaxLocal__c');
        setFieldBillingg.add('PaymentTo__r.Name');
        setFieldBillingg.add('Invoiceto__r.Name');
        setFieldBillingg.add('Credit_No_from_Agent__c');
        setFieldBillingg.add('InboundVATINVNo__c');
        setFieldBillingg.add('TotalAmountofSellingFCY__c');
        setFieldBillingg.add('TotalAmountofSellingLocal__c');
        setFieldBillingg.add('ExchangeRateSelling__c');
        setFieldBillingg.add('PaymentTo__c');
        setFieldBillingg.add('Invoiceto__c');
        setFieldBillingg.add('FTMSSO__c');
        setFieldBillingg.add('FTMSSO__r.HBLNumber__c');
        setFieldBillingg.add('FTMSSO__r.Shipper__r.AccountNameENG__c');
        setFieldBillingg.add('FTMSSO__r.Consignee__r.AccountNameENG__c');
		setFieldBillingg.add('CurrencyBuying__c');
        setFieldBillingg.add('CurrencySelling__c');
		setFieldBillingg.add('Profit_incl_tax_local__c');
        setFieldBillingg.add('Allocated__c');
        setFieldBillingg.add('Quantity__c');
        setFieldBillingg.add('UnitPriceofSellingFCY__c');
        setFieldBillingg.add('Total_Selling_Incl_Tax_FCY__c');
        setFieldBillingg.add('RemarkForSelling__c');
        setFieldBillingg.add('UnitPriceofBuyingFCY__c');
        setFieldBillingg.add('TotalBuyingInclTaxFCY__c');
        setFieldBillingg.add('RemarkforBuying__c');
        
    }
    public PLSheetController() {
        JobID = ApexPages.currentPage().getParameters().get('id');
        lstAllBill = getBilling(JobID);
        lstConsolCNTR = getConsolCNTR(JobID);
        ADshipment = getJob(JobID);
        userName = UserInfo.getName();
        lstBillBuying = new List<ConsolBill__c>();
        lstBillSelling = new List<ConsolBill__c>();
        REVENUE = new List<ResultWrapperShipment>();
        COST = new List<ResultWrapperShipment>();
        REVENUEshipnull = new List<ConsolBill__c>();
        COSTshipnull = new List<ConsolBill__c>();
        HBLshipment = new  List<String>();
        TotalSelling = 0;
        TotalBuying = 0;
        TotalProfit = 0;
        now = Datetime.now();
        now.addHours(7);
        for(ConsolBill__c bill : lstAllBill){
            if(!String.isEmpty(bill.Invoiceto__c)){
                lstBillSelling.add(bill);
            }
            if(!String.isEmpty(bill.PaymentTo__c)){
                lstBillBuying.add(bill);
            }
        }
        lstShipment = new List<String>();
        setShipment = new Set<String>();

        for(ConsolBill__c bill : lstAllBill){
            if(!setShipment.contains(bill.FTMSSO__c) && !String.isEmpty(bill.FTMSSO__c)){
                lstShipment.add(bill.FTMSSO__c);
                setShipment.add(bill.FTMSSO__c);
            }
        }
        if(lstShipment.size() > 0){
            for(String ship : lstShipment){
                ResultWrapperShipment shipment = new ResultWrapperShipment();
                ResultWrapperShipment shipment2 = new ResultWrapperShipment();
                for(ConsolBill__c bill : lstBillSelling){
                    if(bill.FTMSSO__c == ship && !String.isEmpty(bill.FTMSSO__c) && bill.Allocated__c == false){
                        shipment.HBLnumber = bill.FTMSSO__r.HBLNumber__c;
                        shipment.Shipper = bill.FTMSSO__r.Shipper__r.AccountNameENG__c;
                        shipment.Consignee = bill.FTMSSO__r.Consignee__r.AccountNameENG__c;
                        shipment.lstBillOfShipment.add(bill);
                    }
                }
                for(ConsolBill__c bill : lstBillBuying){
                    if(bill.FTMSSO__c == ship && !String.isEmpty(bill.FTMSSO__c) && bill.Allocated__c == false){
                        shipment2.HBLnumber = bill.FTMSSO__r.HBLNumber__c;
                        shipment2.Shipper = bill.FTMSSO__r.Shipper__r.AccountNameENG__c;
                        shipment2.Consignee = bill.FTMSSO__r.Consignee__r.AccountNameENG__c;
                        shipment2.lstBillOfShipment.add(bill);
                    }
                }
                COST.add(shipment2);
                REVENUE.add(shipment);
            }
        }
        for(ConsolBill__c bill : lstBillSelling){
            TotalSelling += bill.Total_Selling_Incl_Tax_FCY__c;
        }
        for(ConsolBill__c bill : lstBillBuying){
            TotalBuying += bill.TotalBuyingInclTaxFCY__c;
        }
        TotalProfit = TotalSelling - TotalBuying;
        System.debug('REVENUE: '+REVENUE);
        System.debug('COST: '+COST);
        // for(String ship : lstShipment){
        //     ResultWrapperShipment shipment = new ResultWrapperShipment();
        //     for(ConsolBill__c bill : lstBillBuying){
        //         if(bill.FTMSSO__c == ship && !String.isEmpty(bill.FTMSSO__c) && bill.Allocated__c == false){
        //             shipment.HBLnumber = bill.FTMSSO__r.HBLNumber__c;
        //             shipment.Shipper = bill.FTMSSO__r.Shipper__r.Name;
        //             shipment.Consignee = bill.FTMSSO__r.Consignee__r.Name;
        //             shipment.lstBillOfShipment.add(bill);
        //         }
        //     }
        //     COST.add(shipment);
        // }
        for(ConsolBill__c bill : lstBillBuying){
            if(String.isEmpty(bill.FTMSSO__c) && bill.Allocated__c == false){
                COSTshipnull.add(bill);
            }
        }
        for(ConsolBill__c bill : lstBillSelling){
            if(String.isEmpty(bill.FTMSSO__c) && bill.Allocated__c == false){
                REVENUEshipnull.add(bill);
            }
        }

        if(lstShipment.size() > 1){
            List<FTMSSO__c> lstSO = [SELECT Id, Name, HBLHAWB__c FROM FTMSSO__c WHERE Id IN :lstShipment];
            for(FTMSSO__c so : lstSO){
                if(!String.isEmpty(so.HBLHAWB__c)){
                    HBLshipment.add(so.HBLHAWB__c);
                }
            }
            System.debug('tesst ' + lstShipment);
        }
        System.debug('HBLshipment: '+HBLshipment);
        TotalProfit = TotalSelling - TotalBuying;
        System.debug('lstAllBill: '+lstAllBill);
    }

    private AdvancedShipment__c getJob(String JobID){
        String strSelect = 'SELECT ' + String.join(new List<String>(setFieldSO), ',');
        String strFrom = ' FROM AdvancedShipment__c ';
        String strWhere = ' WHERE Id = \'' + JobID + '\'' ;
        String strOrderBy = ' ORDER BY Name LIMIT 1';
        String strQuery = strSelect + strFrom + strWhere + strOrderBy;

        AdvancedShipment__c job;
        try{
            job = Database.query(strQuery); 
        } catch(QueryException e){
            job = new AdvancedShipment__c();
        }
        return job;
    }

    private List<ConsolBill__c> getBilling(String JobID){
        String strSelect = 'SELECT ' + String.join(new List<String>(setFieldBillingg), ',');
        String strFrom = ' FROM ConsolBill__c ';
        String strWhere = ' WHERE ConsolidationShipmentName__c = \'' + JobID + '\'';
        String strQuery = strSelect + strFrom + strWhere;
        List<ConsolBill__c> lstBill;
        try{
            lstBill = Database.query(strQuery); 
        } catch(QueryException e){
            lstBill = new List<ConsolBill__c>();
        }
        return lstBill;
    }

    private List<ConsolCNTR__c> getConsolCNTR(String JobID){
        String strSelect = 'SELECT ' + String.join(new List<String>(setFieldCNTR), ',');
        String strFrom = ' FROM ConsolCNTR__c ';
        String strWhere = ' WHERE AdvancedShipment__c = \'' + JobID + '\'' ;
        String strQuery = strSelect + strFrom + strWhere;
        List<ConsolCNTR__c> lstCNTR;
        try{
            lstCNTR = Database.query(strQuery); 
        } catch(QueryException e){
            lstCNTR = new List<ConsolCNTR__c>();
        }
        return lstCNTR;
    }

    public class ResultWrapperShipment {
        public String HBLnumber {get;set;}
        public String Shipper {get;set;}
        public String Consignee {get;set;}
        public List<ConsolBill__c> lstBillOfShipment {get; set;}
        public ResultWrapperShipment(){
            this.HBLnumber = '';
            this.Shipper = '';
            this.Consignee = '';
            lstBillOfShipment = new List<ConsolBill__c>();
        }
    }
}