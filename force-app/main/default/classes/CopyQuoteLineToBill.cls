public with sharing class CopyQuoteLineToBill {
	public List<QuoteLine__c> lineItems{get; set;}
	public String  msgError {get; set;}
    public String shipmentId{get; set;}
    public Decimal checkcur3rd{get; set;}
    public FTMSSO__c invoiceToSo {get;set;}
	private static Set<String> fieldsQuery = new Set<String>();
	private static List<String> quoteLineIdList = new List<String>();
    static{
        fieldsQuery.add('Id');
        fieldsQuery.add('LineItemNameEng__c');
        fieldsQuery.add('LineItemNameLocal__c');
        fieldsQuery.add('QuoteLineNumber__c');
        fieldsQuery.add('ChargeUnit__c');
        fieldsQuery.add('ChargeQuantity__c');
        fieldsQuery.add('SellingListPriceLocal__c');
        fieldsQuery.add('SellingListPriceFCY__c');
        fieldsQuery.add('CurrencySelling__c');
        fieldsQuery.add('CarrierAirlinerVendor__c');
        fieldsQuery.add('CarrierAirlinerVendor__r.Name');
        fieldsQuery.add('ContainerType__c');
        fieldsQuery.add('Remarks__c');
        fieldsQuery.add('Name');
        //fieldsQuery.add('Anken__r.Customer__c');
        fieldsQuery.add('TaxRateSelling__c');
        fieldsQuery.add('TaxRateBuying__c');
        fieldsQuery.add('CurrencyBuying__c');
        fieldsQuery.add('FXRateID__c');
        fieldsQuery.add('ExchangeRateSelling__c');
        fieldsQuery.add('ExchangeRateBuying__c');
        fieldsQuery.add('CurrencyConversionforSelling__c');
        fieldsQuery.add('CurrencyConversionforBuying__c');
        fieldsQuery.add('BuyingListPriceLocal__c');
        fieldsQuery.add('BuyingListPriceFCY__c');
        fieldsQuery.add('QuoteID__c');
        fieldsQuery.add('LineItemDescription__c');
        fieldsQuery.add('Invoiceto__r.Name');
        fieldsQuery.add('ServiceID__c');
        
        
    }
	public CopyQuoteLineToBill() {
		lineItems = new List<QuoteLine__c>();
		msgError ='';
        checkcur3rd = 0;
        shipmentId = ApexPages.currentPage().getParameters().get('shipmentId');
		String quoteId = ApexPages.currentPage().getParameters().get('quoteId');
        invoiceToSo = [SELECT Customer__c, Customer__r.Name FROM FTMSSO__c WHERE id = :shipmentId];
		if(String.isBlank(quoteId)){
			msgError = 'Please enter Quote Id field.';
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,msgError));
			return;
		}
		msgError = '';
		lineItems = getListQuoteLine(quoteId);
	}
	private List<QuoteLine__c> getListQuoteLine(String quoteId){
        String strSelect = String.join(new List<String>(fieldsQuery), ',');
        String strQuery = 'SELECT ' + strSelect 
                    + ' FROM QuoteLine__c'
                    + ' WHERE QuoteID__c = \'' + String.escapeSingleQuotes(quoteId) + '\'';
        strQuery += ' ORDER BY Name ASC';
        List<QuoteLine__c> quoteLines = Database.query(strQuery);
        return quoteLines;
    }
    private List<QuoteLine__c> getListQuoteLineByIds(){
        String strSelect = String.join(new List<String>(fieldsQuery), ',');
        String strQuery = 'SELECT Invoiceto__c,' + strSelect 
                    + ' FROM QuoteLine__c'
                    + ' WHERE Id IN: quoteLineIdList';
        strQuery += ' ORDER BY Name ASC';
        List<QuoteLine__c> quoteLines = Database.query(strQuery);
        return quoteLines;
    }
    private FTMSSO__c getShipmentOrder(String shipmentId){

    	List<FTMSSO__c> shipmentOrders = [SELECT Id, Customer__c FROM FTMSSO__c WHERE Id=: shipmentId];
    	if(!shipmentOrders.isEmpty()){
    		return shipmentOrders[0];
    	}
    	return new FTMSSO__c();
    }
    
    public void createFMSBill(){
    	msgError ='';
    	String quoteLineIds = ApexPages.currentPage().getParameters().get('quoteLineIds');
    	FTMSSO__c so = getShipmentOrder(shipmentId);
        //QuoteLine__c quo = getquoteOrder(quoteId);
    	if(String.isBlank(quoteLineIds)){
    		msgError = 'Please Select Quote Line.';
    		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,msgError));
    		return;
    		//a2i0K000000BDfu
    	}
    	quoteLineIdList = quoteLineIds.split(',');
    	List<QuoteLine__c> listQuoteLine = getListQuoteLineByIds();
    	List<FTMSBill__c> listNewBill = new List<FTMSBill__c>();
    	// Id recordTypeId = Schema.SObjectType.FTMSBill__c.getRecordTypeInfosByDeveloperName().get('Selling_Buyging_Standard').getRecordTypeId();
    	for(QuoteLine__c line : listQuoteLine){
    		FTMSBill__c newBill = new FTMSBill__c();
           
    		// newBill.RecordTypeId = recordTypeId;
            newBill.PaymentTo__c = line.CarrierAirlinerVendor__c;
            newBill.ChargeQuantity__c = line.ChargeQuantity__c;
            newBill.FTMSSO__c = shipmentId;
            if(line.SellingListPriceFCY__c == null &&
                line.SellingListPriceLocal__c == null){
                    newBill.InvoiceTo__c = null;
                }else{
                    if(line.Invoiceto__c != null){
                        newBill.InvoiceTo__c = line.Invoiceto__c;
                    }else{
                        newBill.InvoiceTo__c = so.Customer__c;
                    }
                }
    		//newBill.InvoiceNo__c = so.Customer__c;
            
			newBill.InvoiceSBDisplayNo__c = line.QuoteLineNumber__c;
			newBill.Service__c = line.ServiceID__c;
			newBill.BillNameatPrintLocal__c = line.LineItemNameLocal__c;
            newBill.BillNameatPrintENG__c = line.LineItemNameEng__c;
            newBill.QuoteLine__c = line.Id;
            newBill.ChargeUnit__c = line.ChargeUnit__c;
            newBill.ContainerType__c = line.ContainerType__c;
			newBill.TaxRateBuying__c = line.TaxRateBuying__c;
			newBill.TaxRateSelling__c = line.TaxRateSelling__c;
			newBill.CurrencySelling__c = line.CurrencySelling__c;
			newBill.CurrencyBuying__c = line.CurrencyBuying__c;
			newBill.FxRateID__c = line.FXRateID__c;
			newBill.ExchangeRateSelling__c = line.ExchangeRateSelling__c;
			newBill.ExchangeRateBuying__c = line.ExchangeRateBuying__c;
			newBill.CurrencyConversionforSelling__c = line.CurrencyConversionforSelling__c;
			newBill.CurrencyConversionforBuying__c = line.CurrencyConversionforBuying__c;
			newBill.UnitPriceofSellingLocal__c = line.SellingListPriceLocal__c;
			newBill.UnitPriceFCY__c = line.SellingListPriceFCY__c;
			newBill.UnitPriceofBuyingLocal__c = line.BuyingListPriceLocal__c;
			newBill.UnitPriceofBuyingFCY__c = line.BuyingListPriceFCY__c;
    		listNewBill.add(newBill);
    	}
    	try{
            msgError = '';
    		FlsService.doInsert(listNewBill);
			//ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL, msgError));
    	}catch(Exception ex){
    		msgError = ex.getMessage();
    		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL, msgError));
    	}
    	
    	
    }
}