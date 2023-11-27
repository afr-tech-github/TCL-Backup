public with sharing class SOAController {
    public String reportType {get;set;}
    public String language  {get;set;}
    public String searchCondition {get;set;}
    public Date fromDate {get;set;}
    public Date toDate {get;set;}
    public String sFromDate { get; set; }
    public String sToDate { get; set; }
    public String currencyType{ get; set;}
    public String accountType{get; set;}
    public String businessRelationship{get; set;}
    public String accountId{get; set;}
    public List<String> getAccountFirst{get; set;}
    public List<SelectOption> accountList{get; set;}
    public String message{get; set;}
    public ReportWrapper report{get; set;}
    public Boolean displayReportTable{get; set;}
    public String advancePaymentType{get; set;}
    public String docType{get; set;}
    public String isPrint{get; set;}
    public String period{get;set;}
    public Boolean isDisplayDetail{get;set;}
    public static List<String> ankenIdList = new List<String>();
    public String ankenIds{get;set;}
    public String bankType{get;set;}
	private static SiteCustomSettings__c siteCustomSetting = SiteCustomSettings__c.getInstance ();
    private static Set<String> selectFields = new Set<String>();
    private static Set<String> excludeAnKenRecordTypes = new Set<String>();
    private static Set<String> excludeStatuses = new Set<String>();
    private static Map<String, String> reportTypeBusinessRelationship = new Map<String, String>();
    private static Map<String, List<FTMSBill__c>> billingByClientMap = new Map<String, List<FTMSBill__c>>();
    public Boolean showJobId{get;set;}
    public Boolean showWKID{get;set;}
    public Boolean isInvoicing {get;set;}
    public String stringDebitNo {get;set;}
    public String inboundVAT {get;set;}
    public String outboundVAT {get;set;}

    static {
        // selectFields.add('FTMSSO__r.Customer__r.Name');
        // selectFields.add('FTMSSO__r.Customer__r.PaidDay__c');
        // selectFields.add('FTMSSO__r.Customer__r.PaidDayAdvance__c');
        selectFields.add('FTMSSO__r.Name');
        // selectFields.add('FTMSSO__r.ID__c');
        selectFields.add('FTMSSO__r.JobRequestID__c');
        // selectFields.add('FTMSSO__r.WkInitial__c');
        // selectFields.add('FTMSSO__r.QuotationVer__c');
        selectFields.add('FTMSSO__c');
        selectFields.add('FTMSSO__r.HBLNumber__c');
        selectFields.add('FTMSSO__r.MBLNumber__c');
        selectFields.add('FTMSSO__r.ETD__c');
        selectFields.add('FTMSSO__r.ETA__c');
        // selectFields.add('FTMSSO__r.Ship_number__c');
        // selectFields.add('FTMSSO__r.DeadlineForPaymentOfInvoices__c');
        // selectFields.add('FTMSSO__r.DeadlineForPaymentOfExpense__c');
        // selectFields.add('FTMSSO__r.DeliveryDate__c');
        selectFields.add('FTMSSO__r.CargoQuantity__c');
        selectFields.add('FTMSSO__r.CargoStatus__c');
        selectFields.add('UnpaidBalanceofBuyingFCY__c');
        selectFields.add('UnpaidBalanceofBuyingLocal__c');
        selectFields.add('UnreceivedBalanceofSellingLocal__c');
        selectFields.add('UnreceivedBalanceofSellingFCY__c');
        selectFields.add('CurrencySelling__c');
        selectFields.add('CurrencyBuying__c');
        // selectFields.add('ProductTax__c');
        // selectFields.add('SellInTaxAmountJPY__c'); // AMMOUNT SELLING INCLUDING TAX
        selectFields.add('Id');
        selectFields.add('InvoiceTo__r.Name');
        selectFields.add('InvoiceTo__r.AccountNameENG__c');
        // selectFields.add('PartnerDebitJPN__c');
        // selectFields.add('PartnerCreditJPN__c');
        // selectFields.add('PartnerSeisanJPY__c');
        // selectFields.add('FTMSSO__r.SeikyusyoRemark__c');
        selectFields.add('ChargeQuantity__c');
        selectFields.add('UnitPriceofSellingLocal__c');
        selectFields.add('TaxRateSelling__c');
        // selectFields.add('TAX_ADJUSTMENTSELL__c');
        selectFields.add('AmountReceivedfromCustomerLocal__c');
        // selectFields.add('Siharaigaku__c');
        // selectFields.add('AccountedDate__c');
        selectFields.add('AccountedDate__c');
        selectFields.add('UnitPriceofBuyingLocal__c');
        // selectFields.add('BuyTaxRateSelling__c');
        // selectFields.add('Cost_Allocation_Margin__c');
        selectFields.add('UnitPriceofBuyingFCY__c');
        selectFields.add('UnitPriceFCY__c');
        selectFields.add('AmountReceivedfromCustomer__c');
        // selectFields.add('PartnerCredit__c');
        // selectFields.add('PartnerDebit__c');
        // selectFields.add('PartnerSeisanUSD__c');
        selectFields.add('BillNameatPrintLocal__c');
        // selectFields.add('PaymentTo__r.Name');
        selectFields.add('Description__c');
        selectFields.add('Name');
        selectFields.add('TotalAmountofBuyingFCY__c');
        selectFields.add('TotalAmountofSellingFCY__c');
        // selectFields.add('SellInTaxAmount_USD__c');
        // selectFields.add('BuyInTaxAmountJPY__c');
        // selectFields.add('BuyInTaxAmountUSD__c');

        selectFields.add('PaymentConfirmedSelling__c');
        selectFields.add('PaymentConfirmedBuying__c');
        // selectFields.add('PaymentTo__r.BusinessRelationship__c');
        selectFields.add('InvoiceTo__r.BusinessRelationship__c');
        // selectFields.add('PaymentTo__r.AccountNameENG__c');
        selectFields.add('InvoiceTo__r.AccountNameENG__c');
        selectFields.add('BillNameatPrintENG__c');
        selectFields.add('FTMSSO__r.AccountedDate__c');
        selectFields.add('FTMSSO__r.HBLNumber__c');
        selectFields.add('FTMSSO__r.MBLNumber__c');
        selectFields.add('FTMSSO__r.HAWBNumber__c ');
        selectFields.add('FTMSSO__r.MAWBNumber__c');
        selectFields.add('FTMSSO__r.MAWBNumber__c');
        selectFields.add('FTMSSO__r.RecordType.Name');
        // selectFields.add('FTMSSO__r.DeadlineForPaymentOfInvoices__c');
        // selectFields.add('FTMSSO__r.InvoiceIssueCargoStatus__c');
        // selectFields.add('FTMSSO__r.DebitIssueCargoStatus__c');
        selectFields.add('OutboundVATInvNo__c');
        selectFields.add('InboundVATINVNo__c');
        selectFields.add('AdvancePaymentonbehalfofOurCompany__c');
        selectFields.add('AdvancePaymentonbehalfofCustomer__c');
        selectFields.add('DebitNo__c');
        selectFields.add('PaymentTo__r.Name');
        selectFields.add('PaymentTo__r.BusinessRelationship__c');
        selectFields.add('PaymentTo__r.AccountNameENG__c');
        
        selectFields.add('PaymentTo__c');
         
    }
    public SOAController() {
        advancePaymentType = 'All';
        //language = UserInfo.getLanguage();
        language = 'en_US';
        reportType = 'customer_credit_debit_report_type';
        accountType = 'customer';
        bankType = 'local1';
        isDisplayDetail = false;
        System.debug('213 :');
        businessRelationship = 'Customer';
        System.debug('213 :');
        showJobId = false;
        showWKID = false;
        isInvoicing = false;
        getAccountFirst = new List<String>();
       System.debug('213 :');
        accountList = getAccountList();
        System.debug('213 :');
        reportTypeBusinessRelationship.put('partner_report_type', 'Partner');
        reportTypeBusinessRelationship.put('custommer_report_type', 'Customer');
        reportTypeBusinessRelationship.put('customer_credit_debit_report_type', 'Customer');
        reportTypeBusinessRelationship.put('vender_report_type', '3rd Vendor');
        //AccountList();
        System.debug('reportTypeBusinessRelationship :'+reportTypeBusinessRelationship);
        reset();

        // print report
        accountId = ApexPages.currentPage().getParameters().get('clientId');
        System.debug('accountId :'+accountId);
        period = '';
        if(!String.isBlank(accountId)){
            advancePaymentType = ApexPages.currentPage().getParameters().get('advancePaymentType');
            sFromDate = ApexPages.currentPage().getParameters().get('fromDate');
            sToDate = ApexPages.currentPage().getParameters().get('toDate');
            reportType = ApexPages.currentPage().getParameters().get('reportType');
            currencyType = ApexPages.currentPage().getParameters().get('currency');
            bankType = ApexPages.currentPage().getParameters().get('bank');
            searchCondition = ApexPages.currentPage().getParameters().get('condition');
            language = ApexPages.currentPage().getParameters().get('language');
            showWKID = Boolean.valueOf(ApexPages.currentPage().getParameters().get('showWKID'));
            showJobId = Boolean.valueOf(ApexPages.currentPage().getParameters().get('showJobId'));
            String ankenIds = ApexPages.currentPage().getParameters().get('ankenIds');
            if(!String.isBlank(ankenIds)){
                isDisplayDetail = true;
                ankenIdList = ankenIds.split(',');
            }
            report = new ReportWrapper();
            onChangeDateFrom();
            onChangeDateTo();
            generateReport();
        }
        inboundVAT = SObjectType.FTMSBill__c.fields.InboundVATINVNo__c.getLabel();
        outboundVAT = SObjectType.FTMSBill__c.fields.OutboundVATInvNo__c.getLabel();
    }
    private void reset(){
        language = 'en_US';
        message = '';
        sFromDate = '';
        sToDate = '';
        fromDate = null;
        toDate = null;
        searchCondition = 'ETD';
        currencyType = 'All Both';
        bankType = 'local1';
        report = new ReportWrapper();
        if(getAccountFirst.size() > 0){
            accountId = getAccountFirst.get(0);
        }
        
        displayReportTable = false;
        if(reportType == 'partner_report_type'){
            report.clientType = 'Partner Name';
        }
        if(reportType == 'vender_report_type'){
            report.clientType = 'Vender Name';
        }
        if(reportType == 'customer_report_type' || reportType == 'customer_credit_debit_report_type'){
            report.clientType = 'Customer Name';
        }
        
    }

    public Map<String, String > getTranslations(){

        Map<String, Object> translate = TranslationService.getByLanguage(language);
        Map<String, String> translateMapResult = new Map<String, String>();
        for(String key : translate.keySet()){
            if(key.contains('soa')){
                translateMapResult.put(key.substringAfter('.'), (String)translate.get(key));
            }
            
        }
        return translateMapResult; 
    }
    
    public List<SelectOption> getBankOptions(){
        SiteCustomSettings__c	 banks = [Select LocalCurrencyBankAccountShortName1__c,
        LocalCurrencyBankAccountShortName2__c,
        LocalCurrencyBankAccountShortName3__c,
        LocalCurrencyBankAccountShortName4__c,
        LocalCurrencyBankAccountShortName5__c,
        FCYBankAccountShortName1__c,
        FCYBankAccountShortName2__c
        From SiteCustomSettings__c limit 1];
        List<SelectOption> bankOptions = new List<SelectOption>();
        // value, title
        if(banks.LocalCurrencyBankAccountShortName1__c != null && banks.LocalCurrencyBankAccountShortName1__c != ''){
            bankOptions.add(new SelectOption('local1', banks.LocalCurrencyBankAccountShortName1__c));
        }
        if(banks.LocalCurrencyBankAccountShortName2__c != null && banks.LocalCurrencyBankAccountShortName2__c != ''){
            bankOptions.add(new SelectOption('local2', banks.LocalCurrencyBankAccountShortName2__c));
        }
        if(banks.LocalCurrencyBankAccountShortName3__c != null && banks.LocalCurrencyBankAccountShortName3__c != ''){
            bankOptions.add(new SelectOption('local3', banks.LocalCurrencyBankAccountShortName3__c));
        }
        if(banks.LocalCurrencyBankAccountShortName4__c != null && banks.LocalCurrencyBankAccountShortName4__c != ''){
            bankOptions.add(new SelectOption('local4', banks.LocalCurrencyBankAccountShortName4__c));
        }
        if(banks.LocalCurrencyBankAccountShortName5__c != null && banks.LocalCurrencyBankAccountShortName5__c != ''){
            bankOptions.add(new SelectOption('local5', banks.LocalCurrencyBankAccountShortName5__c));
        }
        if(banks.FCYBankAccountShortName1__c != null && banks.FCYBankAccountShortName1__c != ''){
            bankOptions.add(new SelectOption('foreign1', banks.FCYBankAccountShortName1__c));
        }        
        if(banks.FCYBankAccountShortName2__c != null && banks.FCYBankAccountShortName2__c != ''){
            bankOptions.add(new SelectOption('foreign2', banks.FCYBankAccountShortName2__c));
        }
        return bankOptions;
    } 

    public List<SelectOption> getLanguages() {
        List<SelectOption> languages = new List<SelectOption>();
        languages.add(new SelectOption('en_US', 'English'));
        languages.add(new SelectOption('ja', '日本語'));
        languages.add(new SelectOption('vi', 'Tiếng Việt'));
        languages.add(new SelectOption('ko', '한국어'));

        return languages;
    }

    public List<SelectOption> getReportTypes() {
        List<SelectOption> reportTypes = new List<SelectOption>();
        reportTypes.add(new SelectOption('partner_report_type', 'PARTNER/AGENT OUTSTANDING STATEMENT REPORT'));
        reportTypes.add(new SelectOption('vender_report_type', 'VENDOR OUTSTANDING STATEMENT REPORT'));
        //reportTypes.add(new SelectOption('custommer_report_type', 'CUSTOMER INVOICE SUMMARY REPORT'));
        reportTypes.add(new SelectOption('customer_credit_debit_report_type', 'CUSTOMER DEBIT & CREDIT SUMMARY REPORT'));

        return reportTypes;
    }
    
    public List<SelectOption> getSearchConditions(){
        List<SelectOption> searchConditions = new List<SelectOption>();
        searchConditions.add(new SelectOption('ETD', 'ETD'));
        searchConditions.add(new SelectOption('ETA', 'ETA'));
        searchConditions.add(new SelectOption('SHIPMENTORDER', 'SALES ACCOUNTED DATE (SHIPMENT ORDER)'));
        searchConditions.add(new SelectOption('INVOICING', 'INVOICING DATE'));
        
        return searchConditions;
    }
    public List<SelectOption> getCurrencies(){
        List<SelectOption> currencies = new List<SelectOption>();
        currencies.add(new SelectOption('USD', 'USD currency'));
        currencies.add(new SelectOption('VND', 'Local currency'));
        currencies.add(new SelectOption('Both', 'Both currency'));
        currencies.add(new SelectOption('All USD', 'USD All'));
        currencies.add(new SelectOption('All VND', 'Local All'));
        currencies.add(new SelectOption('All Both', 'Both All'));  
        return currencies;
    }
    public List<SelectOption> getAdvancePaymentTypes(){
        List<SelectOption> types = new List<SelectOption>();
        types.add(new SelectOption('All', 'All'));
        types.add(new SelectOption('No', 'No'));
        types.add(new SelectOption('Both', 'Both'));
        types.add(new SelectOption('Customer', 'On-behalf-of Customer'));
        types.add(new SelectOption('OurCompany', 'On-behalf-of Our Company'));
        return types;
    }

    public List<SelectOption> getAccountList(){
        //excludeAnKenRecordTypes = getExcludeAnKenRecordTypes();
        List<SelectOption> accounts = new List<SelectOption>();
        List<FTMSBill__c> listBillings = new List<FTMSBill__c>();
        String strQuery = buildQueryClient(null);
		System.debug('THAO query ' + strQuery);
        listBillings = Database.query(strQuery);
        System.debug('THAO listBillings ' + listBillings.size() + ' ' + reportType + ' ' + businessRelationship);

        Set<Id> accountIds = new Set<Id>();
        if(listBillings.size() > 0){
            for(FTMSBill__c result : listBillings){
                if(!String.isBlank(result.InvoiceTo__c)
                   && !accountIds.contains(result.InvoiceTo__c)
                   && !result.PaymentConfirmedSelling__c
                   && result.InvoiceTo__r.BusinessRelationship__c == businessRelationship){
                        getAccountFirst.add(result.InvoiceTo__c);
                       accounts.add(new SelectOption(result.InvoiceTo__c, result.InvoiceTo__r.AccountNameENG__c != null ? result.InvoiceTo__r.AccountNameENG__c : ''));
                       accountIds.add(result.InvoiceTo__c);
                   }
                else if(!String.isBlank(result.PaymentTo__c)
                        && !accountIds.contains(result.PaymentTo__c)
                        && !result.PaymentConfirmedBuying__c
                        && result.PaymentTo__r.BusinessRelationship__c == businessRelationship){
                            getAccountFirst.add(result.InvoiceTo__c);
                            accounts.add(new SelectOption(result.PaymentTo__c, result.PaymentTo__r.AccountNameENG__c != null ? result.PaymentTo__r.AccountNameENG__c : ''));
                            accountIds.add(result.PaymentTo__c);
                        }
            }
        }
        message = '';
        if(accounts.size() == 0){
            message = 'There is no result';
        }

        return accounts;
    }

    public void generateReport(){
        displayReportTable = true;
        report = new ReportWrapper();
        System.debug('check1 :');
        onChangeDateFrom();
        System.debug('check2 :');
        onChangeDateTo();
        System.debug('check3 :');
        String strQuery = buildQueryClient(accountId);
        System.debug('strQuery :'+strQuery);
        Account client = [Select Id, Name, AccountNameENG__c, BusinessRelationship__c, TaxCode__c, EnglishAddress__c,
                          BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry FROM Account WHERE Id =: accountId];
        stringDebitNo = '';
        report.clientId = accountId;
        report.clientName = client.Name;
        report.taxCode = client.TaxCode__c;
        if(language == 'en_US'){
            report.address = client.EnglishAddress__c;
        }
        else if(language == 'vi'){
            if(!String.isBlank(client.BillingStreet)){
                report.address += client.BillingStreet + ' ,';
            }
            if(!String.isBlank(client.BillingCity)){
                report.address += client.BillingCity + ' ,';
            }
            if(!String.isBlank(client.BillingState)){
                report.address += client.BillingState + ' ,';
            }
            if(!String.isBlank(client.BillingPostalCode)){
                report.address += client.BillingPostalCode + ' ,';
            }
            if(!String.isBlank(client.BillingCountry)){
                report.address += client.BillingCountry + ' ,';
            }
            if(!String.isBlank(report.address)){
                report.address = report.address.removeEnd(' ,');
            }
        }

        if(reportType == 'partner_report_type'){
            report.clientType = 'Partner Name';
        }
        if(reportType == 'vender_report_type'){
            report.clientType = 'Vender Name';
        }
        if(reportType == 'customer_report_type' || reportType == 'customer_credit_debit_report_type'){
            report.clientType = 'Customer Name';
        }
        List<FTMSBill__c> billings = Database.query(strQuery);
        System.debug('billings :'+billings);
        Set<String>  ankenIdSet = new Set<String>();
        ReportShipmentItemWrapper shipmentItem = new ReportShipmentItemWrapper();
        Integer counter = 0;
        for(FTMSBill__c billing : billings){
            // stringDebitNo = new List<String>();
            if(advancePaymentType == 'No'){
                if(billing.AdvancePaymentonbehalfofCustomer__c || billing.AdvancePaymentonbehalfofOurCompany__c){
                    continue;
                }
            }
            if(advancePaymentType == 'Customer'){
                if(!billing.AdvancePaymentonbehalfofCustomer__c){
                    continue;
                }
            }
            if(advancePaymentType == 'OurCompany'){
                if(!billing.AdvancePaymentonbehalfofOurCompany__c){
                    continue;
                }
            }
            if(advancePaymentType == 'Both'){
                if(!billing.AdvancePaymentonbehalfofCustomer__c || !billing.AdvancePaymentonbehalfofOurCompany__c){
                    continue;
                }
            }
            /*if(reportType <> 'vender_report_type'){
                if(!checkDisplayWhenNull(accountId, billing)){
                    continue;
                }
            }*/
            if(!checkDisplayWhenNull(accountId, billing, siteCustomSetting, currencyType)){
               continue;
            }
            
            ReportBillingItemWrapper billingItem = new ReportBillingItemWrapper(billing, accountId, language, currencyType);
            if(!ankenIdSet.contains(billing.FTMSSO__c)){

                ankenIdSet.add(billing.FTMSSO__c);
                if(counter > 0){
                    // stringDebitNo += shipmentItem.debitNo;
                    report.debit += shipmentItem.debit;
                    report.credit += shipmentItem.credit;
                    report.debitUSD += shipmentItem.debitUSD;
                    report.creditUSD += shipmentItem.creditUSD;
                    report.billingTotal += shipmentItem.quantity;
                    if (shipmentItem.dueDateOfPayment <> null){
                        report.dueDateOfPaymentText += shipmentItem.dueDateOfPayment;
                    }
                    // report.dueDateOfPaymentText += shipmentItem.dueDateOfPayment;
                    report.listShipment.add(shipmentItem);
                    if(report.dueDateOfPayment == null || report.dueDateOfPayment < shipmentItem.dueDateOfPayment){
                        report.dueDateOfPayment = shipmentItem.dueDateOfPayment;
                    }
                }
                counter ++;
                shipmentItem = new ReportShipmentItemWrapper();
                shipmentItem.wkId = billing.FTMSSO__r.Name;
                shipmentItem.shipmentId = billing.FTMSSO__c;
                shipmentItem.shipmentNo = billing.FTMSSO__r.Name;
                shipmentItem.jobID = billing.FTMSSO__r.JobRequestID__c;
                isInvoicing = searchCondition.equals('INVOICING');
                if (searchCondition.equals('INVOICING')) {
                    shipmentItem.saleAccountedDate = billing.AccountedDate__c;
                } else {
                    shipmentItem.saleAccountedDate = billing.FTMSSO__r.AccountedDate__c;
                }
                // shipmentItem.saleAccountedDate = billing.FTMSSO__r.AccountedDate__c;
                if(billing.FTMSSO__r.RecordType.Name == 'Ocean Import' || billing.FTMSSO__r.RecordType.Name == 'Ocean Export'){
                    shipmentItem.noHBL = billing.FTMSSO__r.HBLNumber__c;
                    shipmentItem.noMBL = billing.FTMSSO__r.MBLNumber__c;
                }
                if(billing.FTMSSO__r.RecordType.Name == 'Air Import' || billing.FTMSSO__r.RecordType.Name == 'Air Export'){
                    shipmentItem.noHBL = billing.FTMSSO__r.HAWBNumber__c;
                    shipmentItem.noMBL = billing.FTMSSO__r.MAWBNumber__c ;
                }
                shipmentItem.dateETD = billing.FTMSSO__r.ETD__c;
                shipmentItem.dateETA = billing.FTMSSO__r.ETA__c;
                // shipmentItem.dueDateOfPayment = billing.FTMSSO__r.DeadlineForPaymentOfInvoices__c;
                // shipmentItem.invoiceIssueStatus = billing.FTMSSO__r.InvoiceIssueCargoStatus__c;
                // shipmentItem.debitIssueStatus = billing.FTMSSO__r.DebitIssueCargoStatus__c;
                // if (billing.DebitNo__c != null && billing.DebitNo__c != ''){
                    // if (!stringDebitNo.equals(billing.DebitNo__c)){
                        // stringDebitNo.add(billing.DebitNo__c);
                        // shipmentItem.debitNo += billing.DebitNo__c + ' ';
                        // system.debug('stringDebitNo'+ stringDebitNo);
                    // }
                // }
            }
            // if (billing.DebitNo__c != null && billing.DebitNo__c != ''){
                // if (!shipmentItem.debitNo.contains(billing.DebitNo__c)){
                    // shipmentItem.debitNo += billing.DebitNo__c + ', ';
                    // stringDebitNo += billing.DebitNo__c;
                // }
            // }
            if(ankenIdSet.contains(billing.FTMSSO__c)){
                shipmentItem.quantity += 1;
                shipmentItem.listBilling.add(billingItem);
                if (billingItem.debitNo != null && billingItem.debitNo != ''){
                    if (!shipmentItem.debitNo.contains(billing.DebitNo__c)){
                        shipmentItem.debitNo += billingItem.debitNo + ', ';
                    }
                }
                shipmentItem.debit += billingItem.debit;
                shipmentItem.credit += billingItem.credit;
                shipmentItem.debitUSD += billingItem.debitUSD;
                shipmentItem.creditUSD += billingItem.creditUSD;
                shipmentItem.balance += billingItem.balance;
                shipmentItem.balanceUSD += billingItem.balanceUSD;
                //shipmentItem.dueDateOfPaymentText += billingItem.dueDateOfPayment;
                
            }
        }
        // if (shipmentItem.debitNo.length()>0){
            // shipmentItem.debitNo = shipmentItem.debitNo.leftPad(shipmentItem.debitNo.length()-2);
        // }
        report.debit += shipmentItem.debit;
        report.credit += shipmentItem.credit;
        report.debitUSD += shipmentItem.debitUSD;
        report.creditUSD += shipmentItem.creditUSD;
        report.billingTotal += shipmentItem.quantity;
        report.dueDateOfPaymentText += shipmentItem.dueDateOfPayment;

        report.listShipment.add(shipmentItem);
        report.balance = report.debit - report.credit;
        report.balanceUSD = report.debitUSD - report.creditUSD;
        system.debug('stringDebitNo :'+ stringDebitNo);
        for (ReportShipmentItemWrapper ship : report.listShipment){
            stringDebitNo += ship.debitNo;
            ship.debitNo = ship.debitNo.removeEnd(', ');
        }
    }
    
    private Boolean checkDisplayWhenNull(String customerId, FTMSBill__c bill, SiteCustomSettings__c siteCustomSetting, String currencyType){
        Decimal debit = 0;
        Decimal debitUSD = 0;
        Decimal credit = 0;
        Decimal creditUSD = 0;
        Boolean isDisplay = true;
        if(customerId == bill.InvoiceTo__c){   
            if(siteCustomSetting.LocalCurrency__c == bill.CurrencySelling__c && bill.CurrencySelling__c <> 'USD' && (currencyType == 'VND' || currencyType == 'Both')){
                //debit = (bill.UnreceivedBalanceofSellingLocal__c == null ? 0 : bill.UnreceivedBalanceofSellingLocal__c.setScale(2, System.RoundingMode.HALF_UP));
                debit = bill.UnreceivedBalanceofSellingLocal__c == null ? 0 : bill.UnreceivedBalanceofSellingLocal__c.setScale(2, System.RoundingMode.HALF_UP);
            } else
            if(currencyType == 'All VND' || currencyType == 'All Both' || currencyType == 'All USD'){
                //debit = (bill.UnreceivedBalanceofSellingLocal__c == null ? 0 : bill.UnreceivedBalanceofSellingLocal__c.setScale(2, System.RoundingMode.HALF_UP));
                debit = bill.UnreceivedBalanceofSellingLocal__c == null ? 0 : bill.UnreceivedBalanceofSellingLocal__c.setScale(2, System.RoundingMode.HALF_UP);
            }
            //debitUSD = (bill.UnreceivedBalanceofSellingFCY__c == null ? 0 : bill.UnreceivedBalanceofSellingFCY__c.setScale(2, System.RoundingMode.HALF_UP));
            if(bill.CurrencySelling__c == 'USD' && (currencyType == 'USD' || currencyType == 'Both')){
                debitUSD = bill.UnreceivedBalanceofSellingFCY__c == null ? 0 : bill.UnreceivedBalanceofSellingFCY__c.setScale(2, System.RoundingMode.HALF_UP);
        	} else
            if(currencyType == 'All USD' || currencyType == 'All Both'|| currencyType == 'All VND'){
                debitUSD = bill.UnreceivedBalanceofSellingFCY__c == null ? 0 : bill.UnreceivedBalanceofSellingFCY__c.setScale(2, System.RoundingMode.HALF_UP);
            }
        }
        if(customerId == bill.PaymentTo__c){
            if(siteCustomSetting.LocalCurrency__c == bill.CurrencyBuying__c && bill.CurrencyBuying__c <> 'USD' && (currencyType == 'VND' || currencyType == 'Both')){
                //credit = (bill.UnpaidBalanceofBuyingLocal__c == null ? 0 : bill.UnpaidBalanceofBuyingLocal__c.setScale(2, System.RoundingMode.HALF_UP));
                credit = bill.UnpaidBalanceofBuyingLocal__c == null ? 0 : bill.UnpaidBalanceofBuyingLocal__c.setScale(2, System.RoundingMode.HALF_UP);
            } else
            if(currencyType == 'All VND' || currencyType == 'All Both' || currencyType == 'All USD'){
                //credit = (bill.UnpaidBalanceofBuyingLocal__c == null ? 0 : bill.UnpaidBalanceofBuyingLocal__c.setScale(2, System.RoundingMode.HALF_UP));
                credit = bill.UnpaidBalanceofBuyingLocal__c == null ? 0 : bill.UnpaidBalanceofBuyingLocal__c.setScale(2, System.RoundingMode.HALF_UP);
            }
            //creditUSD = (bill.UnpaidBalanceofBuyingFCY__c == null ? 0 : bill.UnpaidBalanceofBuyingFCY__c.setScale(2, System.RoundingMode.HALF_UP));
            if(bill.CurrencyBuying__c == 'USD' && (currencyType == 'USD' || currencyType == 'Both')){
                creditUSD = bill.UnpaidBalanceofBuyingFCY__c == null ? 0 : bill.UnpaidBalanceofBuyingFCY__c.setScale(2, System.RoundingMode.HALF_UP);
        	} else
            if(currencyType == 'All USD' || currencyType == 'All Both'|| currencyType == 'All VND'){
                creditUSD = bill.UnpaidBalanceofBuyingFCY__c == null ? 0 : bill.UnpaidBalanceofBuyingFCY__c.setScale(2, System.RoundingMode.HALF_UP);
            }
        }
        /*if(currencyType == 'VND'){
        if(siteCustomSetting.LocalCurrency__c == bill.CurrencySelling__c){
            if(customerId == bill.InvoiceTo__c){   
                debit = (bill.UnreceivedBalanceofSellingLocal__c == null ? 0 : bill.UnreceivedBalanceofSellingLocal__c.setScale(2, System.RoundingMode.HALF_UP));
                debitUSD = (bill.UnreceivedBalanceofSellingFCY__c == null ? 0 : bill.UnreceivedBalanceofSellingFCY__c.setScale(2, System.RoundingMode.HALF_UP));
            }
            if(customerId == bill.PaymentTo__c){
                credit = (bill.UnpaidBalanceofBuyingLocal__c == null ? 0 : bill.UnpaidBalanceofBuyingLocal__c.setScale(2, System.RoundingMode.HALF_UP));
                creditUSD = (bill.UnpaidBalanceofBuyingFCY__c == null ? 0 : bill.UnpaidBalanceofBuyingFCY__c.setScale(2, System.RoundingMode.HALF_UP));
            }
        } 
        }
        else{
            if(customerId == bill.InvoiceTo__c){   
                if(bill.CurrencySelling__c == 'VND' || String.isBlank(bill.CurrencySelling__c)){
                    debit = (bill.UnreceivedBalanceofSellingLocal__c == null ? 0 : bill.UnreceivedBalanceofSellingLocal__c.setScale(2, System.RoundingMode.HALF_UP));
                }else{
                    debitUSD = (bill.UnreceivedBalanceofSellingFCY__c == null ? 0 : bill.UnreceivedBalanceofSellingFCY__c.setScale(2, System.RoundingMode.HALF_UP));
                }
            }
            if(customerId == bill.PaymentTo__c){
                if(bill.CurrencyBuying__c == 'VND' || String.isBlank(bill.CurrencyBuying__c)){
                    credit = (bill.UnpaidBalanceofBuyingLocal__c == null ? 0 : bill.UnpaidBalanceofBuyingLocal__c.setScale(2, System.RoundingMode.HALF_UP));
                }else{
                    creditUSD = (bill.UnpaidBalanceofBuyingFCY__c == null ? 0 : bill.UnpaidBalanceofBuyingFCY__c.setScale(2, System.RoundingMode.HALF_UP)); 
                }
            }
        }
        
        if(customerId == bill.InvoiceTo__c){   
            if(bill.CurrencySelling__c == 'VND' || String.isBlank(bill.CurrencySelling__c)){
                debit = (bill.UnreceivedBalanceofSellingLocal__c == null ? 0 : bill.UnreceivedBalanceofSellingLocal__c.setScale(2, System.RoundingMode.HALF_UP));
            }else{
                debitUSD = (bill.UnreceivedBalanceofSellingFCY__c == null ? 0 : bill.UnreceivedBalanceofSellingFCY__c.setScale(2, System.RoundingMode.HALF_UP));
            }
        }
        if(customerId == bill.PaymentTo__c){
            if(bill.CurrencyBuying__c == 'VND' || String.isBlank(bill.CurrencyBuying__c)){
                credit = (bill.UnpaidBalanceofBuyingLocal__c == null ? 0 : bill.UnpaidBalanceofBuyingLocal__c.setScale(2, System.RoundingMode.HALF_UP));
            }else{
                creditUSD = (bill.UnpaidBalanceofBuyingFCY__c == null ? 0 : bill.UnpaidBalanceofBuyingFCY__c.setScale(2, System.RoundingMode.HALF_UP)); 
            }
        }*/
        
        if(debit == debitUSD && credit == creditUSD && debit == 0){
            isDisplay = false;
        }
        return isDisplay;
    }

    public void onChangeType(){
        if(reportType == 'partner_report_type'){
            accountType = 'partner';
            businessRelationship = 'Partner';
        }
        if(reportType == 'vender_report_type'){
            accountType = 'vender';
            businessRelationship = '3rd Vendor';
        }
        if(reportType == 'custommer_report_type'){
            accountType = 'customer';
            businessRelationship = 'Customer';
        }
        if(reportType == 'customer_credit_debit_report_type'){
            accountType = 'customer';
            businessRelationship = 'Customer';
        }
        reset();
        accountList = getAccountList();
        
    }
    public void onChangeDateFrom(){
        if(!String.isBlank(sFromDate)){
            fromDate = DateTimeUtils.parseDate(sFromDate, '/');
        }
        else{
            fromDate = null;
        }
        System.debug('fromDate :'+fromDate);
        accountList = getAccountList();

    }
    public void onChangeDateTo(){
        if(!String.isBlank(sToDate)){
            toDate = DateTimeUtils.parseDate(sToDate, '/');
        }
        else{
            toDate = null;
        }
        System.debug('toDate :'+toDate);
        accountList = getAccountList();
    }

    private String buildQueryClient(String customerId){
        excludeAnKenRecordTypes = getExcludeAnKenRecordTypes();
        excludeStatuses = getExcludeStatuses();
        String selectStr = 'SELECT ' + String.join(new List<String>(selectFields), ',');
        String fromStr = ' FROM FTMSBill__c';
        String whereStr = ' AND FTMSSO__r.RecordType.DeveloperName NOT IN: excludeAnKenRecordTypes';
        
        whereStr += ' AND FTMSSO__r.CargoStatus__c NOT IN: excludeStatuses';
        
        String filter = '';
        if (fromDate != null && toDate != null) {
            if (fromDate <= toDate) {
                if(searchCondition.equals('ETD')){
                    filter = ' AND (FTMSSO__r.ETD__c >= ' + String.valueOf(fromDate) + ' AND FTMSSO__r.ETD__c <= ' + String.valueOf(toDate) + ')';
                }
                else if(searchCondition.equals('ETA')){
                    filter = ' AND (FTMSSO__r.ETA__c >= ' + String.valueOf(fromDate) + ' AND FTMSSO__r.ETA__c <= ' + String.valueOf(toDate) + ')';
                }
                else if(searchCondition.equals('SHIPMENTORDER')){
                    filter = ' AND (FTMSSO__r.AccountedDate__c >= ' + String.valueOf(fromDate) + ' AND FTMSSO__r.AccountedDate__c <= ' + String.valueOf(toDate) + ')';
                }
                else if(searchCondition.equals('INVOICING')){
                    filter = ' AND (AccountedDate__c >= ' + String.valueOf(fromDate) + ' AND AccountedDate__c <= ' + String.valueOf(toDate) + ')';
                }
                
            }
            period = 'From ' + fromDate + ' To ' + toDate;
        } else if (fromDate != null && toDate == null) {
            //filter = ' AND FTMSSO__r.ETD__c >= ' + String.valueOf(fromDate);
            if(searchCondition.equals('ETD')){
                filter = ' AND FTMSSO__r.ETD__c >= ' + String.valueOf(fromDate);
            }
            else if(searchCondition.equals('ETA')){
                filter = ' AND FTMSSO__r.ETA__c >= ' + String.valueOf(fromDate);
            }
            else if(searchCondition.equals('SHIPMENTORDER')){
                filter = ' AND FTMSSO__r.AccountedDate__c >= ' + String.valueOf(fromDate);
            }
            else if(searchCondition.equals('INVOICING')){
                filter = ' AND AccountedDate__c >= ' + String.valueOf(fromDate);
            }
            period = 'From ' + fromDate;
        } else if (fromDate == null && toDate != null) {
            //filter = ' AND FTMSSO__r.ETD__c <= ' + String.valueOf(toDate);
            if(searchCondition.equals('ETD')){
                filter = ' AND FTMSSO__r.ETD__c <= ' + String.valueOf(toDate);
            }
            else if(searchCondition.equals('ETA')){
                filter = ' AND FTMSSO__r.ETA__c <= ' + String.valueOf(toDate);
            }
            else if(searchCondition.equals('SHIPMENTORDER')){
                filter = ' AND FTMSSO__r.AccountedDate__c <= ' + String.valueOf(toDate);
            }
            else if(searchCondition.equals('INVOICING')){
                filter = ' AND AccountedDate__c <= ' + String.valueOf(toDate);
            }
            period = 'To ' + toDate;
        }
        whereStr += filter;
        if(!String.isBlank(customerId)){
            whereStr += ' AND ( InvoiceTo__c =\'' + String.escapeSingleQuotes(customerId) + '\' OR PaymentTo__c =\'' + String.escapeSingleQuotes(customerId) + '\') ';
            if(reportType == 'partner_report_type' || reportType == 'customer_credit_debit_report_type' || reportType == 'vender_report_type'){
                whereStr += ' AND ( (( UnreceivedBalanceofSellingLocal__c > 0 OR UnreceivedBalanceofSellingFCY__c > 0) AND PaymentConfirmedSelling__c = false AND InvoiceTo__c =\'' + String.escapeSingleQuotes(customerId) + '\')';
                whereStr += ' OR (( UnpaidBalanceofBuyingLocal__c > 0 OR UnpaidBalanceofBuyingFCY__c > 0) AND PaymentConfirmedBuying__c = false AND PaymentTo__c =\'' + String.escapeSingleQuotes(customerId) + '\'))';
                //whereStr += ' AND ( (( UnreceivedBalanceofSellingLocal__c > 0 OR UnreceivedBalanceofSellingFCY__c > 0) AND PaymentConfirmedSelling__c = false AND InvoiceTo__c =\'' + String.escapeSingleQuotes(customerId) + '\')';
                //whereStr += ' OR ( ( UnpaidBalanceofBuyingLocal__c > 0 OR UnpaidBalanceofBuyingFCY__c > 0) AND PaymentConfirmedBuying__c = false AND PaymentTo__c =\'' + String.escapeSingleQuotes(customerId) + '\') )';
            }
            /*if(reportType == 'vender_report_type'){
                whereStr += ' AND ( (UnpaidBalanceofBuyingLocal__c > 0 OR UnpaidBalanceofBuyingFCY__c > 0) AND PaymentConfirmedBuying__c = false ) ';
            }*/
            if(reportType == 'custommer_report_type'){
                whereStr += ' AND ( ( UnreceivedBalanceofSellingLocal__c > 0 OR UnreceivedBalanceofSellingFCY__c > 0) AND PaymentConfirmedSelling__c = false )';
                //whereStr += ' AND ( ( UnreceivedBalanceofSellingLocal__c > 0 OR UnreceivedBalanceofSellingFCY__c > 0) AND PaymentConfirmedSelling__c = false AND InvoiceTo__c =\'' + String.escapeSingleQuotes(customerId) + '\')';
                ////whereStr += ' OR ( PaymentConfirmedBuying__c = false AND PaymentTo__c =\'' + customerId + '\') )';
            }
        }else{
            whereStr += ' AND ( InvoiceTo__r.BusinessRelationship__c =\'' + String.escapeSingleQuotes(businessRelationship) + '\' OR PaymentTo__r.BusinessRelationship__c =\'' + String.escapeSingleQuotes(businessRelationship) + '\') ';
            whereStr += ' AND ( (( UnreceivedBalanceofSellingLocal__c > 0 OR UnreceivedBalanceofSellingFCY__c > 0) AND PaymentConfirmedSelling__c = false)';
            whereStr += ' OR (( UnpaidBalanceofBuyingLocal__c > 0 OR UnpaidBalanceofBuyingFCY__c > 0) AND PaymentConfirmedBuying__c = false))';
            //whereStr += ' AND ( (( UnreceivedBalanceofSellingLocal__c > 0 OR UnreceivedBalanceofSellingFCY__c > 0) AND PaymentConfirmedSelling__c = false AND InvoiceTo__r.BusinessRelationship__c =\'' + String.escapeSingleQuotes(businessRelationship) + '\')';
            //whereStr += ' OR ( (UnpaidBalanceofBuyingLocal__c > 0 OR UnpaidBalanceofBuyingFCY__c > 0) AND PaymentConfirmedBuying__c = false AND PaymentTo__r.BusinessRelationship__c =\'' + String.escapeSingleQuotes(businessRelationship) + '\') )';
        }
        if(ankenIdList.size() > 0){
            whereStr += ' AND FTMSSO__c IN : ankenIdList';
        }
        whereStr = whereStr.replaceFirst('AND', 'WHERE');
        System.debug('THAO where ' + whereStr);
        return selectStr + fromStr + whereStr + ' ORDER BY FTMSSO__c,InvoiceTo__c  LIMIT 10000';
    }

    private Set<String> getExcludeAnKenRecordTypes(){
        Set<String> recordTypeNames = new Set<String>();
        recordTypeNames.add('QUOTATION');
        recordTypeNames.add('oceanexport_lock');
        recordTypeNames.add('OutAir_lock');
        recordTypeNames.add('airimportlock');
        recordTypeNames.add('oceanimport_lock');
        return recordTypeNames;
    }

    private Set<String> getExcludeStatuses(){
        Set<String> statuses = new Set<String>();
        statuses.add(PicklistReference.CANCELLED_ST);
        statuses.add(PicklistReference.COMPLETED_ST);
        statuses.add(PicklistReference.TEMPORARY_UNLOCK_FOR_ACCOUNTING_PURPOSE_ST);
        System.debug('statuses :'+statuses);
        return statuses;
    }
    
    public Class ReportWrapper{
        public String clientType{get; set;}
        public String clientId{get; set;}
        public String clientName{get; set;}
        public String taxCode {get; set;}
        public String address {get; set;}
        public String dueDateOfPaymentText {get; set;}
        public Date dueDateOfPayment{get; set;}
        public Decimal debit{get; set;}
        public Decimal debitUSD{get; set;}
        public Decimal credit{get; set;}
        public Decimal creditUSD{get; set;}
        public Decimal balance{get; set;}
        public Decimal balanceUSD{get; set;}
        public Integer billingTotal{get; set;}
        public List<ReportShipmentItemWrapper> listShipment{get; set;}
        public ReportWrapper(){
            dueDateOfPayment = null;
            dueDateOfPaymentText = '';
            clientType = '';
            clientId = '';
            clientName = '';
            taxCode = '';
            address = '';
            debit = 0; 
            debitUSD = 0;
            credit = 0;
            creditUSD = 0;
            balance = 0;
            balanceUSD = 0;
            billingTotal = 0;
            listShipment = new List<ReportShipmentItemWrapper>();
        }
    }
    public Class ReportShipmentItemWrapper{
        public String shipmentNo{get; set;}
        public String jobID{get; set;}
        public String  wkId{get; set;}
        public String shipmentId{get; set;}
        public Date saleAccountedDate{get;set;}
        public String noHBL{get; set;}
        public String noMBL{get; set;}
        public Date dateETD{get; set;}
        public Date dateETA{get; set;}
        public Integer quantity{get; set;}
        public Date dueDateOfPayment{get; set;}
        public String dueDateOfPaymentText{get; set;}
        public Decimal debit{get; set;}
        public Decimal debitUSD{get; set;}
        public Decimal credit{get; set;}
        public Decimal creditUSD{get; set;}
        public Decimal balance{get; set;}
        public Decimal balanceUSD{get; set;}
        public String invoiceIssueStatus{get; set;}
        public String debitIssueStatus{get; set;}
        public String debitNo {get;set;}
        public List<ReportBillingItemWrapper> listBilling{get; set;}
        public ReportShipmentItemWrapper(){
            invoiceIssueStatus ='';
            debitIssueStatus = '';
            debitNo = '';
            wkId = '';
            shipmentNo ='';
            jobID = '';
            shipmentId ='';
            saleAccountedDate = null;
            noHBL = '';
            noMBL = '';
            dateETD = null;
            dateETA = null;
            dueDateOfPayment = null;
            dueDateOfPaymentText = '';
            quantity = 0;
            debit = 0; 
            debitUSD = 0;
            credit = 0;
            creditUSD = 0;
            balance = 0;
            balanceUSD = 0;
            listBilling = new List<ReportBillingItemWrapper>();
        }
        
    }
    
    public Class ReportBillingItemWrapper{
        public String noBill{get;set;}
        public String billingId{get;set;}
        public Date saleAccountedDateInvoicing{get; set;}
        public String debitNo{get;set;}
        public String pricingName{get;set;}
        public String invoiceToName{get; set;}
        public String invoiceToId{get; set;}
        public String paymentToName{get; set;}
        public String paymentToId{get; set;}
        public String description{get;set;}
        public Decimal chargeUnitTotal{get;set;}

        public String shipmentOrderId{get; set;}
        public Decimal debit{get; set;}
        public Decimal debitUSD{get; set;}
        public Decimal credit{get; set;}
        public Decimal creditUSD{get; set;}
        public Decimal balance{get; set;}
        public Decimal balanceUSD{get; set;}
        public Date dueDateOfPayment{get; set;}
        public String dueDateOfPaymentText{get; set;}
        public String advancePayment{get;set;}
        public String outboundInvoiceNo{get; set;}
        public String inboundInvoiceNo{get; set;}
        public ReportBillingItemWrapper(){
            debit = 0; 
            debitUSD = 0;
            credit = 0;
            creditUSD = 0;
            balance = 0;
            balanceUSD = 0;
            shipmentOrderId ='';
            billingId = '';
            dueDateOfPayment = null;
            dueDateOfPaymentText ='';
        }
        public ReportBillingItemWrapper(FTMSBill__c bill, String customerId, String arglanguage, String currencyType){
            List<String> advancePaymentTypes = new List<String>();
            if(bill.AdvancePaymentonbehalfofCustomer__c){
                advancePaymentTypes.add('On-behalf-of Customer');
            }
            if(bill.AdvancePaymentonbehalfofOurCompany__c){
                advancePaymentTypes.add('On-behalf-of Our Company');
            }
            if(!bill.AdvancePaymentonbehalfofCustomer__c && !bill.AdvancePaymentonbehalfofOurCompany__c){
                advancePaymentTypes.add('No');
            }
            advancePayment = String.join(advancePaymentTypes, ', ');
            debit = 0; 
            debitUSD = 0;
            credit = 0;
            creditUSD = 0;
            balance = 0;
            balanceUSD = 0;
            noBill = bill.Name;
            billingId = bill.Id;
            saleAccountedDateInvoicing = bill.AccountedDate__c;
            if (bill.DebitNo__c != null && bill.DebitNo__c != '')
            debitNo = bill.DebitNo__c;
            pricingName = arglanguage == 'vi'? bill.BillNameatPrintLocal__c : bill.BillNameatPrintENG__c;
            invoiceToName = bill.InvoiceTo__r.Name;
            invoiceToId = bill.InvoiceTo__c;
            paymentToName = bill.PaymentTo__r.Name;
            paymentToId = bill.PaymentTo__c;
            description = bill.Description__c;
            chargeUnitTotal = bill.ChargeQuantity__c;
            shipmentOrderId = bill.FTMSSO__c;
            outboundInvoiceNo = bill.OutboundVATInvNo__c;
            inboundInvoiceNo = bill.InboundVATINVNo__c;
            credit = 0;
            creditUSD = 0;
            debit = 0;
            debitUSD = 0;
            dueDateOfPayment =null;
            // dueDateOfPayment = bill.FTMSSO__r.DeadlineForPaymentOfInvoices__c;
            
            if(customerId == bill.InvoiceTo__c){
                //if(bill.CurrencySelling__c == 'VND' || String.isBlank(bill.CurrencySelling__c)){
                if(siteCustomSetting.LocalCurrency__c == bill.CurrencySelling__c && bill.CurrencySelling__c <> 'USD' && (currencyType == 'Both' || currencyType == 'VND')){
                    //debit = (bill.UnreceivedBalanceofSellingLocal__c == null ? 0 : bill.UnreceivedBalanceofSellingLocal__c.setScale(2, System.RoundingMode.HALF_UP));
                    debit = bill.UnreceivedBalanceofSellingLocal__c == null ? 0 : bill.UnreceivedBalanceofSellingLocal__c.setScale(2, System.RoundingMode.HALF_UP);
                    //debitUSD = bill.UnreceivedBalanceofSellingFCY__c == null ? 0 : bill.UnreceivedBalanceofSellingFCY__c;
                } else
                if(currencyType == 'All Both' || currencyType == 'All VND' || currencyType == 'All USD'){
                    //debit = (bill.UnreceivedBalanceofSellingLocal__c == null ? 0 : bill.UnreceivedBalanceofSellingLocal__c.setScale(2, System.RoundingMode.HALF_UP));
                    debit = bill.UnreceivedBalanceofSellingLocal__c == null ? 0 : bill.UnreceivedBalanceofSellingLocal__c.setScale(2, System.RoundingMode.HALF_UP);
                    //debitUSD = bill.UnreceivedBalanceofSellingFCY__c == null ? 0 : bill.UnreceivedBalanceofSellingFCY__c;
                }
                //debitUSD = (bill.UnreceivedBalanceofSellingFCY__c == null ? 0 : bill.UnreceivedBalanceofSellingFCY__c.setScale(2, System.RoundingMode.HALF_UP));
                if(bill.CurrencySelling__c == 'USD' && (currencyType == 'Both' || currencyType == 'USD')){
                    debitUSD = bill.UnreceivedBalanceofSellingFCY__c == null ? 0 : bill.UnreceivedBalanceofSellingFCY__c.setScale(2, System.RoundingMode.HALF_UP);
                } else
                if(currencyType == 'All Both' || currencyType == 'All USD' || currencyType == 'All VND'){
                    debitUSD = bill.UnreceivedBalanceofSellingFCY__c == null ? 0 : bill.UnreceivedBalanceofSellingFCY__c.setScale(2, System.RoundingMode.HALF_UP);
                }
            }
            if(customerId == bill.PaymentTo__c){
                //if(bill.CurrencyBuying__c == 'VND' || String.isBlank(bill.CurrencyBuying__c)){
                if(siteCustomSetting.LocalCurrency__c == bill.CurrencyBuying__c && bill.CurrencyBuying__c <> 'USD' && (currencyType == 'Both' || currencyType == 'VND')){
                    //credit = (bill.UnpaidBalanceofBuyingLocal__c == null ? 0 : bill.UnpaidBalanceofBuyingLocal__c.setScale(2, System.RoundingMode.HALF_UP));
                    credit = bill.UnpaidBalanceofBuyingLocal__c == null ? 0 : bill.UnpaidBalanceofBuyingLocal__c.setScale(2, System.RoundingMode.HALF_UP);
                    //creditUSD = bill.UnpaidBalanceofBuyingFCY__c == null ? 0 : bill.UnpaidBalanceofBuyingFCY__c;
                } else
                if(currencyType == 'All Both' || currencyType == 'All VND' || currencyType == 'All USD'){
                    //credit = (bill.UnpaidBalanceofBuyingLocal__c == null ? 0 : bill.UnpaidBalanceofBuyingLocal__c.setScale(2, System.RoundingMode.HALF_UP));
                    credit = bill.UnpaidBalanceofBuyingLocal__c == null ? 0 : bill.UnpaidBalanceofBuyingLocal__c.setScale(2, System.RoundingMode.HALF_UP);
                    //creditUSD = bill.UnpaidBalanceofBuyingFCY__c == null ? 0 : bill.UnpaidBalanceofBuyingFCY__c;
                }
                //creditUSD = (bill.UnpaidBalanceofBuyingFCY__c == null ? 0 : bill.UnpaidBalanceofBuyingFCY__c.setScale(2, System.RoundingMode.HALF_UP)); 
                if(bill.CurrencyBuying__c == 'USD' && (currencyType == 'Both' || currencyType == 'USD')){
                    creditUSD = bill.UnpaidBalanceofBuyingFCY__c == null ? 0 : bill.UnpaidBalanceofBuyingFCY__c.setScale(2, System.RoundingMode.HALF_UP);
                } else
                if(currencyType == 'All Both' || currencyType == 'All USD' || currencyType == 'All VND'){
                    creditUSD = bill.UnpaidBalanceofBuyingFCY__c == null ? 0 : bill.UnpaidBalanceofBuyingFCY__c.setScale(2, System.RoundingMode.HALF_UP);
                }
            }

            balance = debit - credit;
            balanceUSD = debitUSD - creditUSD;
        }
    }
}