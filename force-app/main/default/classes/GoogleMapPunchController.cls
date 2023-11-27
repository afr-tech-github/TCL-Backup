public with sharing class GoogleMapPunchController {

    public Punch_In_Out__c event{get; set;}

    public String id {get;set;}

    private static Set<String> setFields = new Set<String>();

    static{
        setFields.add('Latitude__c');
        setFields.add('Longitude__c');
        setFields.add('Type__c');
    }

    public GoogleMapPunchController() {
        id = ApexPages.currentPage().getParameters().get('id');
        
        event = Database.query(queryEvent(id));
        System.debug('checkin: ');
    }

    private String queryEvent(String id){
        String strSelect = 'SELECT ' + String.join(new List<String>(setFields), ',');
        String strFrom = ' FROM Punch_In_Out__c ';
        String strWhere = ' WHERE Id = \'' + id+'\'';
        return strSelect + strFrom + strWhere;
    }

    @AuraEnabled
    public static void savePosition(String recordId, String latitude, String longitude){
        Punch_In_Out__c model = [SELECT Id, 
            Latitude__c, 
            Longitude__c,
            Type__c
            FROM Punch_In_Out__c WHERE Id = :recordId];
        model.Latitude__c = latitude;
        model.Longitude__c = longitude;
        
        update model;
    }
}