public with sharing class MassUpdateConsolBillControllerV2 {
    private static Set<String> docQr = new Set<String>();
    // private static Set<String> docDtQr = new Set<String>();
    // public List<docListWapper> listItem {get;set;}
    public String searchValue {get;set;}
    public Integer pagination {get;set;}
    // public class DeleteResult {
    //     public Boolean isSuccess;
    //     public String message;
   
    //     public DeleteResult(Boolean isSuccess, String message) {
    //         this.isSuccess = isSuccess;
    //         this.message = message;
    //     }
    // }
    // public class docListWapper{
    //     public Document__c Doc;
    //     public List<Documentsdetails__c> DocDT;
    //     public docListWapper(){
    //         DocDT = new List<Documentsdetails__c>();
    //     }
    // }
    static{
        docQr.add('Id');
        docQr.add('Name');
        docQr.add('PricingName__c');
        docQr.add('PricingName__r.Name');
        docQr.add('MasterBilling__c');
        docQr.add('MasterBilling__r.Name');
        docQr.add('FTMSSO__c');
        docQr.add('FTMSSO__r.Name');
        docQr.add('ChargeUnit__c');
        docQr.add('Quantity__c');
        docQr.add('Container_Type__c');
        docQr.add('Invoiceto__c');
        docQr.add('Invoiceto__r.Name');
        docQr.add('CurrencySelling__c');
        docQr.add('UnitPriceofSellingActual__c');
        docQr.add('TaxRatioSelling__c');
        docQr.add('Tax_Included_Selling__c');
        docQr.add('PaymentTo__c');
        docQr.add('PaymentTo__r.Name');
        docQr.add('UnitPriceofBuyingActual__c');
        docQr.add('TaxRatioBuying__c');
        docQr.add('Tax_Included__c');

        // docDtQr.add('Id');//
        // docDtQr.add('Name');//
        // docDtQr.add('Document__c');//
        // docDtQr.add('ConsolBill__r.Name');//
        // docDtQr.add('Total_Buying_Incl_Tax_Local__c');
        // docDtQr.add('Total_Buying_Incl_Tax_FCY__c');
        // docDtQr.add('Total_Selling_Incl_Tax_Local__c');//
        // docDtQr.add('Total_Selling_Incl_Tax_FCY__c');//


    }
    @AuraEnabled
    public static  Map<String, Object> getListWapper(String ShipID,Integer pagination){
        Map<String, Object> result = new Map<String, Object>();
        List<ConsolBill__c> lisdt= new List<ConsolBill__c>();
        List<ConsolBill__c> lisdoc=getDoc(ShipID,pagination);
       

        List<Id> unique = new List<Id>();
        for (ConsolBill__c lisdocItem : lisdoc) {
            if (lisdocItem.Id != null && !unique.contains(lisdocItem.Id)) {
                unique.add(lisdocItem.Id);
            }
        } 
        System.debug('Unique ID :'+unique);
        system.debug('Fu doc list:'+lisdoc);
        if(lisdoc.size()>0){
           lisdt = getDocDt(ShipID,unique);
            
        }
        System.debug('lisdt :'+lisdt);
        result.put('DocList', lisdoc);
        result.put('DocListDT', lisdt);
        return result;
          
        
    }
    @AuraEnabled
    public static List<ConsolBill__c> getDoc(String ShipID,Integer pagination){
        String strSelect = String.join(new List<String>(docQr), ',');
        String strQuery = 'SELECT ' + strSelect 
                    + ' FROM ConsolBill__c'
                    + ' WHERE ConsolidationShipmentName__c = \'' + ShipID + '\'';
                   
                    strQuery  += 'LIMIT  ' + pagination*10;
                    List<ConsolBill__c>  ListDoc;
        try{
            ListDoc = Database.query(strQuery);
        } catch(QueryException e){
            ListDoc = new List<ConsolBill__c>();
        }
        return ListDoc;
    }
    @AuraEnabled
    public static List<ConsolBill__c> getDocDt(String DocId, List<id> Lid){
        
        List<ConsolBill__c> ListDoc;
        try{
             ListDoc = [    
                SELECT  Id,Name,MasterBilling__c,MasterBilling__r.Name,PricingName__c,PricingName__r.Name,FTMSSO__c,FTMSSO__r.Name,ChargeUnit__c,Quantity__c,Container_Type__c,Invoiceto__c,Invoiceto__r.Name,CurrencySelling__c,UnitPriceofSellingActual__c,TaxRatioSelling__c,Tax_Included_Selling__c,PaymentTo__c,PaymentTo__r.Name,UnitPriceofBuyingActual__c,TaxRatioBuying__c,Tax_Included__c
                FROM ConsolBill__c    
                WHERE MasterBilling__c IN :Lid  ];
   
        } catch(QueryException e){
            ListDoc = new List<ConsolBill__c>();
        }
        return ListDoc;
    }
    @AuraEnabled
    public static String getDescribeSobjectResult(){
		DescribeSobjectResult objResult = Schema.SObjectType.FTMSBill__c;
        return objResult.isCreateable() + '_' + objResult.isUpdateable() + '_' + objResult.isAccessible() + '_' + objResult.isDeletable();
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