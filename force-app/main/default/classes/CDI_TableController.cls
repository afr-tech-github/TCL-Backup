public with sharing class CDI_TableController {
    private static Set<String> docQr = new Set<String>();
    private static Set<String> docDtQr = new Set<String>();
    public List<docListWapper> listItem {get;set;}
    public String searchValue {get;set;}
    public Integer pagination {get;set;}
    public class DeleteResult {
        public Boolean isSuccess;
        public String message;
   
        public DeleteResult(Boolean isSuccess, String message) {
            this.isSuccess = isSuccess;
            this.message = message;
        }
    }
    public class docListWapper{
        public Document__c Doc;
        public List<Documentsdetails__c> DocDT;
        public docListWapper(){
            DocDT = new List<Documentsdetails__c>();
        }
    }
    static{
        docQr.add('Id');
        docQr.add('Name');
        docQr.add('Billto__r.Name');
        docQr.add('TotalSellingInclTaxLocal__c');
        docQr.add('TotalSellingInclTaxFCY__c');
        docQr.add('TotalBuyingInclTaxLocal__c');
        docQr.add('TotalBuyingInclTaxFCY__c');
        docQr.add('Status__c');
        


        



    }
    // public static CDI_TableController() {
    //     String ShipID = ApexPages.currentPage().getParameters().get('id');
    //     pagination=1;
    //     listItem = new List<docListWapper>();
    //     listItem=getListWapper(ShipID,pagination);
    //     r
    // }
    @AuraEnabled
    public static  Map<String, Object> getListWapper(String ShipID,Integer pagination,String searchValue,String recordType){
        Map<String, Object> result = new Map<String, Object>();
        List<Documentsdetails__c> lisdt= new List<Documentsdetails__c>();
        System.debug('devRecordTypeId-getListWapper:'+recordType);

        List<Document__c> lisdoc=getDoc(ShipID,pagination,searchValue,recordType);
       

        List<Id> unique = new List<Id>();
        for (Document__c lisdocItem : lisdoc) {
            if (lisdocItem.Id != null && !unique.contains(lisdocItem.Id)) {
                unique.add(lisdocItem.Id);
            }
        } 

        system.debug('Fu doc list:'+lisdoc);
        if(lisdoc.size()>0){
           lisdt = getDocDt(ShipID,unique);
            
        }
        List<Object> obj = new List<Object>();
   
        result.put('DocList', lisdoc);
        result.put('DocListDT', lisdt);
        result.put('total', obj);
        return result;
          
        
    }
    @AuraEnabled
    public static List<Document__c> getDoc(String ShipID,Integer pagination,String searchValue,String recordType){
        String strSelect = String.join(new List<String>(docQr), ',');
        System.debug('devRecordTypeId:'+recordType);

        Id devRecordTypeId = Schema.SObjectType.Document__c.getRecordTypeInfosByName().get(recordType).getRecordTypeId();

        String strQuery = 'SELECT ' + strSelect 
                    + ' FROM Document__c'
                    + ' WHERE AdvancedShipment__c = \'' + ShipID + '\''
                    + ' AND RecordTypeId = \'' + devRecordTypeId + '\'';
                    
        if(searchValue != null && searchValue.length() >0){
            strQuery += ' AND Name LIKE \'%' + searchValue + '%\'';
        }
                    // strQuery  += 'LIMIT  ' + pagination*10;
                    List<Document__c>  ListDoc;
        try{
            ListDoc = Database.query(strQuery);
        } catch(QueryException e){
            ListDoc = new List<Document__c>();
        }
        return ListDoc;
    }
    @AuraEnabled
    public static List<Documentsdetails__c> getDocDt(String DocId, List<id> Lid){
        
        List<Documentsdetails__c> ListDoc;
        try{
            ListDoc = [    
                SELECT  Name,Id,Billto__r.Name,Document__c,
                Quantity__c,ChargeUnit__c,CurrencySelling__c,TaxRatioSelling__c,
                UnitPriceofSellingLocal__c,Total_Selling_Incl_Tax_Local__c,UnitPriceofSellingFCY__c,
                Total_Selling_Incl_Tax_FCY__c,CurrencyBuying__c,TaxRatioBuying__c,UnitPriceofBuyingLocal__c,
                TotalBuyingInclTaxLocal__c, UnitPriceofBuyingFCY__c,TotalBuyingInclTaxFCY__c,PricingNamePrinted__c
                FROM Documentsdetails__c    
                WHERE Document__c IN :Lid  ];
   
        } catch(QueryException e){
            ListDoc = new List<Documentsdetails__c>();
        }
        return ListDoc;
    }
    @AuraEnabled
    public static String deletePKD(List<Id> ListPKID) {
        List<Documentsdetails__c> packagesToDelete = new List<Documentsdetails__c>();
        
        // Query for Packages_detail__c records with IDs from ListPKID
        List<Documentsdetails__c> packages = [SELECT Id FROM Documentsdetails__c WHERE Id IN :ListPKID];
       

            packagesToDelete.addAll(packages);
            
        // Delete the records
        if (!packagesToDelete.isEmpty()) {
            try {
                delete packagesToDelete;
                System.debug('Deleted ' + packagesToDelete.size() + ' Documentsdetails__c records.');
                
                return  JSON.serialize(new DeleteResult(true, '')); 
            } catch (DmlException e) {
                System.debug('An error occurred while deleting Documentsdetails__c records: ' + e.getMessage());
                return  JSON.serialize(new DeleteResult(false, 'An error occurred while deleting Packages_detail__c records: ' + e.getMessage())); 
                
            }
        } else {
            System.debug('No Documentsdetails__c records found to delete.');
            return  JSON.serialize(new DeleteResult(false, '')); 
            
            
        }
   
    }
}