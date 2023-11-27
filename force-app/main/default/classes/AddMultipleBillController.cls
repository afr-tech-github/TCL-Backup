public with sharing class AddMultipleBillController {
    @AuraEnabled
    public static String saveBillList(List<FTMSBill__c> billList,Id shipmentId) 
	{   
        SiteCustomSettings__c custom = [SELECT FCYCurrency__c,LocalCurrency__c FROM SiteCustomSettings__c ];
        for(FTMSBill__c bill: billList){
            bill.FTMSSO__c = shipmentId;
            if(bill.CurrencySelling__c == custom.FCYCurrency__c){
                bill.UnitPriceFCY__c = bill.UnitPriceFCY__c;
                bill.UnitPriceofSellingLocal__c = null;
                // bill.clofor_com_cfs__AmountSellingUSDAdjustment__c = bill.clofor_com_cfs__AmountSellingLocalAdjustment__c;
                // bill.clofor_com_cfs__AmountSellingLocalAdjustment__c = null;
            }else if(bill.CurrencySelling__c == custom.LocalCurrency__c){
                bill.UnitPriceofSellingLocal__c = bill.UnitPriceFCY__c;
                System.debug('123: ' + bill.UnitPriceofSellingLocal__c);
                System.debug('456: ' + bill.UnitPriceFCY__c);
                // bill.clofor_com_cfs__AmountSellingLocalAdjustment__c = bill.clofor_com_cfs__AmountSellingLocalAdjustment__c;
            }else {
                // bill.clofor_com_cfs__UnitPriceofSelling3rdCurrency__c = bill.UnitPriceofSellingLocal__c; =======================
                bill.UnitPriceofSellingLocal__c = null;
                // bill.clofor_com_cfs__AmountSellingInclTax3rdCurrencyAdjust__c = bill.clofor_com_cfs__AmountSellingLocalAdjustment__c;
                // bill.clofor_com_cfs__AmountSellingLocalAdjustment__c = null;
            }

            if(bill.CurrencyBuying__c == custom.FCYCurrency__c){
                bill.UnitPriceofBuyingFCY__c = bill.UnitPriceofBuyingFCY__c;
                bill.UnitPriceofBuyingLocal__c = null;
                // bill.clofor_com_cfs__AmountBuyingUSDAdjustment__c = bill.clofor_com_cfs__AmountBuyingLocalAdjustment__c;
                // bill.clofor_com_cfs__AmountBuyingLocalAdjustment__c = null;
            }else if(bill.CurrencyBuying__c == custom.LocalCurrency__c){
                bill.UnitPriceofBuyingLocal__c = bill.UnitPriceofBuyingFCY__c;
                // bill.clofor_com_cfs__AmountBuyingLocalAdjustment__c = bill.clofor_com_cfs__AmountBuyingLocalAdjustment__c;
            }else {
                // bill.UnitPriceofSelling3rdCurrency__c = bill.UnitPriceofSellingLocal__c;
                bill.UnitPriceofBuyingLocal__c = null;
                // bill.clofor_com_cfs__AmountBuyingInclTax3rdCurrencyAdjust__c = bill.clofor_com_cfs__AmountBuyingLocalAdjustment__c;
                // bill.clofor_com_cfs__AmountBuyingLocalAdjustment__c = null;

            }    
            // if(bill.TaxRateSelling__c != null){
            //     bill.Included_in_tax_invoice_selling__c = true; 
            // }
            // if(bill.TaxRateBuying__c != null){
            //     bill.Included_in_tax_invoice_buying__c = true; 

            // }       
        }
        
        System.debug('accList1:' + billList);     
        try{
            insert billList;
        }
        catch (Exception e) {
            return e.getMessage();
        }
        return null;
        // System.debug('accList2:' + accList);
    }
    
}