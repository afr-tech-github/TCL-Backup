public class MassUpdateBillingController {
    @AuraEnabled
    public static String getRecordTypeId(){
        //TODO: Need to clarify which spefic developer name record here
        return [SELECT Id,SobjectType FROM RecordType WHERE SobjectType = 'FTMSBill__c' AND DeveloperName = 'Selling_Buyging_Standard'].Id;
    }
    
	@AuraEnabled
    public static String getDescribeSobjectResult(){
		DescribeSobjectResult objResult = Schema.SObjectType.FTMSBill__c;
        return objResult.isCreateable() + '_' + objResult.isUpdateable() + '_' + objResult.isAccessible() + '_' + objResult.isDeletable();
    }
	@AuraEnabled
    public static List<FTMSBill__c> getAllBillings(String shipmentId, Boolean isSelling){        
        List<FTMSBill__c> getBilling = new List<FTMSBill__c>();
        if(isSelling){
            getBilling =  [Select id FROM FTMSBill__c 
            WHERE FTMSSO__c = :shipmentId 
            // AND ((UnitPriceFCY__c != 0 AND UnitPriceFCY__c != null)
            // OR (UnitPriceofSellingLocal__c != 0 AND UnitPriceofSellingLocal__c != null))
            ORDER BY Name];
        } else {
            getBilling =  [Select id FROM FTMSBill__c 
                WHERE FTMSSO__c = :shipmentId 
                // AND ((UnitPriceofBuyingFCY__c != 0 AND UnitPriceofBuyingFCY__c != null)
                // OR (UnitPriceofBuyingLocal__c != 0 AND UnitPriceofBuyingLocal__c != null))
                ORDER BY Name];
        }
        // List<FTMSBill__c> getBilling1 = new List<FTMSBill__c>();
        // if(isSelling){
        //     getBilling1 =  [Select id FROM FTMSBill__c 
        //     WHERE FTMSSO__c = :shipmentId 
        //     AND ((UnitPriceFCY__c = 0)
        //     AND (UnitPriceofSellingLocal__c = 0))
        //     ORDER BY Name];
        // } else{
        //     getBilling1 =  [Select id FROM FTMSBill__c 
        //     WHERE FTMSSO__c = :shipmentId 
        //     AND ((UnitPriceofBuyingFCY__c = 0)
        //     AND (UnitPriceofBuyingLocal__c = 0))
        //     ORDER BY Name];
        // }
        // List<FTMSBill__c> getBilling2 = new List<FTMSBill__c>();
        // if(isSelling){
        //     getBilling2 =  [Select id FROM FTMSBill__c 
        //     WHERE FTMSSO__c = :shipmentId 
        //     AND ((UnitPriceFCY__c = 0)
        //     AND (UnitPriceofSellingLocal__c = null))
        //     ORDER BY Name];
        // } else{
        //     getBilling2 =  [Select id FROM FTMSBill__c 
        //     WHERE FTMSSO__c = :shipmentId 
        //     AND ((UnitPriceofBuyingFCY__c = 0)
        //     AND (UnitPriceofBuyingLocal__c = null))
        //     ORDER BY Name];
        // }
        // List<FTMSBill__c> getBilling3 = new List<FTMSBill__c>();
        // if(isSelling){
        //     getBilling3 =  [Select id FROM FTMSBill__c 
        //     WHERE FTMSSO__c = :shipmentId 
        //     AND ((UnitPriceFCY__c = null)
        //     AND (UnitPriceofSellingLocal__c = 0))
        //     ORDER BY Name];
        // } else{
        //     getBilling3 =  [Select id FROM FTMSBill__c 
        //     WHERE FTMSSO__c = :shipmentId 
        //     AND ((UnitPriceofBuyingFCY__c = null)
        //     AND (UnitPriceofBuyingLocal__c = 0))
        //     ORDER BY Name];
        // }
        // List<FTMSBill__c> getBilling4 = new List<FTMSBill__c>();
        // if(isSelling){
        //     getBilling4 =  [Select id FROM FTMSBill__c 
        //     WHERE FTMSSO__c = :shipmentId 
        //     AND ((UnitPriceFCY__c = null)
        //     AND (UnitPriceofSellingLocal__c = null))
        //     ORDER BY Name];
        // } else{
        //     getBilling4 =  [Select id FROM FTMSBill__c 
        //     WHERE FTMSSO__c = :shipmentId 
        //     AND ((UnitPriceofBuyingFCY__c = null)
        //     AND (UnitPriceofBuyingLocal__c = null))
        //     ORDER BY Name];
        // }
        // System.debug('123:' +shipmentId );
        // getBilling.addAll(getBilling1);
        // getBilling.addAll(getBilling2);
        // getBilling.addAll(getBilling3);
        // getBilling.addAll(getBilling4);
        return getBilling;
    }

	@AuraEnabled
    public static Boolean deleteBilling(String id){
        try {
            List<FTMSBill__c> billings = [Select Id FROM FTMSBill__c WHERE Id = :id];
            if(billings.size() == 0)
                return false;
            delete billings;
            return true;
        } catch (DmlException e) {
            throw e;
        }
    }

	@AuraEnabled
    public static String updateBillings(String jsonRecords, Boolean isSelling, Boolean isBuying, Boolean isVATRateSelling, Boolean isExchangeRateIDDebitCredit, Boolean isCurrencyConversionForSelling, Boolean isExchangeRateSellingDebit, Boolean isVATRateBuying, Boolean isExchangeRateBuyingCredit, Boolean isCurrencyConversionForBuying, Boolean isAdvancePaymentonbehalfofOurCompany ){
		List<FTMSBill__c> records = (List<FTMSBill__c>) JSON.deserialize(jsonRecords, List<FTMSBill__c>.class);
        System.debug('debug1 :'+records);
        Set<Id> ids = (new Map<Id,SObject>(records)).keySet();
        System.debug('Idd :'+ids);
        List<FTMSBill__c>  billings = [SELECT Id,Name,InvoiceSBDisplayNo__c,Service__c,InvoiceTo__c,PaymentTo__c,
        ChargeQuantity__c,ChargeUnitinPrint__c,ChargeUnit__c,Print__c,CurrencySelling__c,AdvancePaymentonbehalfofCustomer__c,
        UnitPriceofSellingLocal__c,UnitPriceFCY__c,UnitPriceofSelling3rdCurrency__c,TaxRateSelling__c,VATrateselling__c,
        FxRateID__c,ExchangeRateSelling__c,CurrencyConversionforSelling__c,CurrencyBuying__c,ContainerType__c,
        BillNameatPrintENG__c,UnitPriceofBuyingLocal__c,UnitPriceofBuyingFCY__c,UnitPriceofBuying3rdCurrency__c,TaxRateBuying__c,VATratebuying__c,AdvancePaymentonbehalfofOurCompany__c,
        ExchangeRateBuying__c,CurrencyConversionforBuying__c
        FROM FTMSBill__c 
        WHERE Id in :ids
        ORDER BY Name];
        System.debug('debug2 :'+billings);

        
        List<FTMSBill__c> itemsIdsToRemove = new List<FTMSBill__c>();
        
        for(Integer i  = 0; i < records.size(); i++){
            FTMSBill__c r = records[i];
            
    
                if(billings[i].Id == r.Id){
                    if(billings[i].InvoiceSBDisplayNo__c != r.InvoiceSBDisplayNo__c ||
                    billings[i].Service__c != r.Service__c ||
                    billings[i].BillNameatPrintENG__c != r.BillNameatPrintENG__c ||
                    billings[i].InvoiceTo__c != r.InvoiceTo__c ||
                    billings[i].PaymentTo__c != r.PaymentTo__c ||
                    billings[i].ChargeQuantity__c != r.ChargeQuantity__c ||
                    billings[i].ChargeUnitinPrint__c != r.ChargeUnitinPrint__c ||
                    billings[i].ChargeUnit__c != r.ChargeUnit__c ||
                    billings[i].ContainerType__c != r.ContainerType__c ||
                    billings[i].Print__c != r.Print__c ||
                    billings[i].CurrencySelling__c != r.CurrencySelling__c ||
                    billings[i].AdvancePaymentonbehalfofCustomer__c != r.AdvancePaymentonbehalfofCustomer__c ||
                    billings[i].UnitPriceofSellingLocal__c != r.UnitPriceofSellingLocal__c ||
                    billings[i].UnitPriceFCY__c != r.UnitPriceFCY__c ||
                    billings[i].UnitPriceofBuying3rdCurrency__c != r.UnitPriceofBuying3rdCurrency__c ||
                    billings[i].TaxRateSelling__c != r.TaxRateSelling__c ||
                    billings[i].FxRateID__c != r.FxRateID__c ||
                    billings[i].ExchangeRateSelling__c != r.ExchangeRateSelling__c ||
                    billings[i].CurrencyConversionforSelling__c != r.CurrencyConversionforSelling__c ||
                    billings[i].VATrateselling__c != r.VATrateselling__c ||
                    billings[i].CurrencyBuying__c != r.CurrencyBuying__c ||
                        billings[i].AdvancePaymentonbehalfofOurCompany__c != r.AdvancePaymentonbehalfofOurCompany__c ||
                        billings[i].UnitPriceofBuyingLocal__c != r.UnitPriceofBuyingLocal__c ||
                        billings[i].UnitPriceofBuyingFCY__c != r.UnitPriceofBuyingFCY__c ||
                        billings[i].UnitPriceofBuying3rdCurrency__c != r.UnitPriceofBuying3rdCurrency__c ||
                        billings[i].TaxRateBuying__c != r.TaxRateBuying__c ||
                        billings[i].ExchangeRateBuying__c != r.ExchangeRateBuying__c ||
                        billings[i].CurrencyConversionforBuying__c != r.CurrencyConversionforBuying__c ||
                        billings[i].VATratebuying__c != r.VATratebuying__c
                    ){
                        itemsIdsToRemove.add(r);
                    }
                    
                
            }
           
           
        }
        
        System.debug('debug3  :'+itemsIdsToRemove.size());
        try {
        	update itemsIdsToRemove;
        	return JSON.serialize(itemsIdsToRemove);
        }
        catch (Exception e) {
            throw new DmlException(e.getMessage());
        }
    }
}