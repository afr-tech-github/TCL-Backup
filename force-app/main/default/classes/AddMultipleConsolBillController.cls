public with sharing class AddMultipleConsolBillController {
    @AuraEnabled
    public static String saveBillList(List<ConsolBill__c> billList,Id shipmentId) 
	{   
        SiteCustomSettings__c custom = [SELECT FCYCurrency__c,LocalCurrency__c FROM SiteCustomSettings__c ];
        for(ConsolBill__c bill: billList){
            bill.ConsolidationShipmentName__c = shipmentId;
            bill.PricingName__c = bill.PricingName__c != null? bill.PricingName__c : '';
            System.debug('123 :'+bill.PricingName__r.Extra_cost__c);
            System.debug('1234:'+bill.PricingName__c);
            Service__c ser = [SELECT Extra_cost__c FROM Service__c WHERE Id =: bill.PricingName__c LIMIT 1];
            System.debug(' 555 :'+ser.Extra_cost__c);
            bill.Billing_status__c = ser.Extra_cost__c == true? 'Required approval':'Approved';
            // if(bill.PricingName__r.Extra_cost__c == true){
            //     bill.Billing_status__c = 'Required approval';
            // }
            // else {
            //     bill.Billing_status__c = 'Approved';
            // }
            bill.FTMSSO__c = bill.FTMSSO__c != null? bill.FTMSSO__c : '';
            System.debug('Thong debug :'+bill.FTMSSO__c);
            bill.ChargeUnit__c = bill.ChargeUnit__c != null? bill.ChargeUnit__c : '';
            bill.Quantity__c = bill.Quantity__c != null? bill.Quantity__c : 0;
            bill.Container_Type__c = bill.Container_Type__c != null? bill.Container_Type__c : '';
            bill.Invoiceto__c = bill.Invoiceto__c != null? bill.Invoiceto__c : '';	
            bill.CurrencySelling__c = bill.CurrencySelling__c != null? bill.CurrencySelling__c : '';
            bill.CurrencyBuying__c = bill.CurrencyBuying__c != null? bill.CurrencyBuying__c : '';
            bill.UnitPriceofSellingActual__c = bill.UnitPriceofSellingActual__c != null? bill.UnitPriceofSellingActual__c : 0;
            bill.TaxRatioSelling__c = bill.TaxRatioSelling__c != null? bill.TaxRatioSelling__c : 0;
            bill.Tax_Included_Selling__c = bill.Tax_Included_Selling__c != null? bill.Tax_Included_Selling__c : false;
            bill.PaymentTo__c = bill.PaymentTo__c != null? bill.PaymentTo__c : '';
            bill.UnitPriceofBuyingActual__c = bill.UnitPriceofBuyingActual__c != null? bill.UnitPriceofBuyingActual__c : 0;
            bill.TaxRatioBuying__c = bill.TaxRatioBuying__c != null? bill.TaxRatioBuying__c : 0;
            bill.Tax_Included__c = bill.Tax_Included__c != null? bill.Tax_Included__c : false;
        }
        try{
            insert billList;
        }
        catch (Exception e) {
            return e.getMessage();
        }
        return null;
        
        
    } 
}