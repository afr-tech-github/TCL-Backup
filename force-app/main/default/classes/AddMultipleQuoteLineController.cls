public with sharing class AddMultipleQuoteLineController {
    @AuraEnabled
    public static String saveQuoteLineList(List<Quoteline__c> quoteLineList,Id quoteId) 
	{  
        AggregateResult numberQuote = [SELECT MAX(QuoteLineNumber__c) FROM Quoteline__c where QuoteID__c =:quoteId];
        Integer numMax = Integer.valueOf(numberQuote.get('expr0'));
        System.debug('1234:' + numMax);
        if(String.isBlank(String.valueOf(numMax))){
            numMax = 0;
        }
        for(Quoteline__c quoLine: quoteLineList){
            System.debug('1234:'+numberQuote);
            quoLine.QuoteID__c = quoteId;
            if(quoLine.ChargeUnit__c != null){
                quoLine.ChargeUnit__c = quoLine.ChargeUnit__c;
                System.debug('1234:' + quoLine.ChargeUnit__c);
            }
            System.debug('1234:'+numMax);
            quoLine.QuoteLineNumber__c = Integer.valueOf(Integer.valueOf(numMax)+1);
            quoLine.PrintingSection__c = '2nd Section';
            numMax++;
        }
        
        System.debug('1234:' + quoteLineList);
        try{
            Insert quoteLineList;
        }
        catch (Exception e) {
            return e.getMessage();
        }
        return null;
    }
}