public without sharing class MassEditQuoteLineController{
    @AuraEnabled
    public static void saveQuoteLineList(List<Quoteline__c> quoteLineList, Id quoteId){
        System.debug('12345:' + quoteLineList);
        for (Quoteline__c quoLine : quoteLineList){
            quoLine.QuoteID__c = quoteId;
        }
        try{
            Insert quoteLineList;
        } catch (DmlException e){
            throw e;
        }
    }

    @AuraEnabled
    public static List<Quoteline__c> getAllQuoteLine(String QuoteId){
        List<AggregateResult> lstQuoteRoute = [SELECT Route__r.Route__c
                                               FROM Quote_route__c
                                               WHERE Quote__c = :QuoteId
                                               GROUP BY Route__r.Route__c];
        Set<String> Ids = new Set<String>();
        for (AggregateResult agg : lstQuoteRoute){
            Ids.add((String) agg.get('Route__c'));
        }
        List<Quoteline__c> lstQuoteLine = Security.stripInaccessible(AccessType.READABLE, [Select Name, Id, ReferencePrice__c, PrintingSection__c, ChargeQuantity__c, CurrencySelling__c, TaxRateSelling__c, SellingListPriceActual__c, Remarks__c, Section__c
                                                                                           From Quoteline__c
                                                                                           WHERE QuoteID__c = :QuoteId AND ReferencePrice__r.Route__c IN:Ids
                                                                                           ORDER BY NAME]).getRecords();
        return lstQuoteLine;
    }

    @AuraEnabled
    public static Boolean deleteQuoteLine(List<String> lstQuoteLineId){
        try{
            Set<String> Ids = new Set<String>();
            for (Integer i = 0; i < lstQuoteLineId.size(); i++){
                Ids.add((String) lstQuoteLineId[i]);
            }
            List<Quoteline__c> quoteLines = [Select Id
                                             FROM Quoteline__c
                                             WHERE Id IN:Ids];
            if (quoteLines.size() == 0)
                return false;
            delete quoteLines;
            return true;
        } catch (Exception e){
            throw e;
        }
    }

    @AuraEnabled
    public static void updateQuoteLine(List<String> lstIdQuoteLine, List<Quoteline__c> lstQuoteLine){
        upsert lstQuoteLine;
    }

    @AuraEnabled
    public static List<Quoteline__c> getInfoQuoteLine(String QuoteLineId){
        return [Select Id, Name, ReferencePrice__c, PrintingSection__c, ChargeQuantity__c, CurrencySelling__c, TaxRateSelling__c, SellingListPriceActual__c, Remarks__c, Section__c
                FROM Quoteline__c
                where Id = :QuoteLineId];
    }

    @AuraEnabled
    public static List<contact> getContacts(){
        return [SELECT Id, name, phone
                FROM contact
                ORDER BY createdDate ASC];
    }

    @AuraEnabled
    public static List<Quote_route__c> getRoute(String QuoteId){
        return [SELECT Route__r.Route__c
                FROM Quote_route__c
                WHERE Quote__c = :QuoteId];
    }

}