public with sharing class MassUpdateConsolBillControllerV3 {
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
    public static List<ConsolBill__c> getAllBillings(String shipmentId, Boolean isSelling){        
        List<ConsolBill__c> getBilling = new List<ConsolBill__c>();
        // if(isSelling){
            getBilling =  [Select id FROM ConsolBill__c 
            WHERE ConsolidationShipmentName__c = :shipmentId 
            ORDER BY Name];
            System.debug('Thongdebug2 :'+getBilling.get(0).Consol_Bills__r.size());
            System.debug('Thongdebug3 :'+getBilling);
        // } 
        // else {
        //     getBilling =  [Select id FROM ConsolBill__c 
        //         WHERE ConsolidationShipmentName__c = :shipmentId 
        //         ORDER BY Name];
        // }
        return getBilling;
    }

    @AuraEnabled
    public static List<ConsolBill__c> getNewBillings(String shipmentId, Boolean isSelling, List<String> ids){        
        List<ConsolBill__c> getBilling = new List<ConsolBill__c>();
        // if(isSelling){
            getBilling =  [Select Id FROM ConsolBill__c 
            WHERE ConsolidationShipmentName__c = :shipmentId 
            AND Id NOT IN :ids 
            
            ORDER BY Name];
            System.debug('Thong debug :'+getBilling);
        // } else {
        //     getBilling =  [Select Id FROM ConsolBill__c 
        //         WHERE ConsolidationShipmentName__c = :shipmentId 
        //         AND Id NOT IN :ids 
                
        //         ORDER BY Name];
        // }
        
        return getBilling;
    }
    @AuraEnabled
    public static List<ConsolBill__c> getSubBillings(String shipmentId, Boolean isSelling){        
        List<ConsolBill__c> getBilling = new List<ConsolBill__c>();

        System.debug('shipmentId :'+shipmentId);
        System.debug('isSelling :'+isSelling);
        if(isSelling){
            getBilling =  [Select Id,Name FROM ConsolBill__c 
            WHERE MasterBilling__c = :shipmentId
            ORDER BY Name];
            System.debug('Thong debug 2 :'+getBilling);
        } else {
            getBilling =  [Select Id,Name FROM ConsolBill__c 
                WHERE MasterBilling__c = :shipmentId
                ORDER BY Name];
        }
        
        return getBilling;
    }

	@AuraEnabled
    public static Boolean deleteBilling(String id){
        try {
            List<ConsolBill__c> billings = [Select Id FROM ConsolBill__c WHERE Id = :id];
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
		List<ConsolBill__c> records = (List<ConsolBill__c>) JSON.deserialize(jsonRecords, List<ConsolBill__c>.class);
        System.debug('debug1 :'+records);
        Set<Id> ids = (new Map<Id,SObject>(records)).keySet();
        System.debug('Idd :'+ids);
        List<ConsolBill__c>  billings = [SELECT Id,Name,MasterBilling__c,PricingName__c,FTMSSO__c,ChargeUnit__c,Quantity__c,Container_Type__c,Invoiceto__c,CurrencySelling__c,UnitPriceofSellingActual__c,TaxRatioSelling__c,Tax_Included_Selling__c,PaymentTo__c,UnitPriceofBuyingActual__c,TaxRatioBuying__c,Tax_Included__c
        FROM ConsolBill__c 
        WHERE Id in :ids
        ORDER BY Name];
        System.debug('debug2 :'+billings);

        
        List<ConsolBill__c> itemsIdsToRemove = new List<ConsolBill__c>();
        
        for(Integer i  = 0; i < records.size(); i++){
            ConsolBill__c r = records[i];
            
    
                if(billings[i].Id == r.Id){
                    if(billings[i].PricingName__c != r.PricingName__c ||
                    billings[i].MasterBilling__c != r.MasterBilling__c ||
                    billings[i].FTMSSO__c != r.FTMSSO__c ||
                    billings[i].ChargeUnit__c != r.ChargeUnit__c ||
                    billings[i].Quantity__c != r.Quantity__c ||
                    billings[i].Container_Type__c != r.Container_Type__c ||
                    billings[i].Invoiceto__c != r.Invoiceto__c ||
                    billings[i].CurrencySelling__c != r.CurrencySelling__c ||
                    billings[i].UnitPriceofSellingActual__c != r.UnitPriceofSellingActual__c ||
                    billings[i].TaxRatioSelling__c != r.TaxRatioSelling__c ||
                    billings[i].Tax_Included_Selling__c != r.Tax_Included_Selling__c ||
                    billings[i].PaymentTo__c != r.PaymentTo__c ||
                    billings[i].UnitPriceofBuyingActual__c != r.UnitPriceofBuyingActual__c ||
                    billings[i].TaxRatioBuying__c != r.TaxRatioBuying__c ||
                    billings[i].Tax_Included__c != r.Tax_Included__c 
                    ){
                        itemsIdsToRemove.add(r);
                    }
                    
                
            }
           
           
        }
        for (ConsolBill__c bill : itemsIdsToRemove) {
            System.debug('debug 4 :'+bill.ExchangeRateSelling__c);
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