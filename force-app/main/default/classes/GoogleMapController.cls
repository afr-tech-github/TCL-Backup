public with sharing class GoogleMapController {

    public Task event{get; set;}

    public String id {get;set;}

    public String lat {get;set;}
    public String lng {get;set;}
    public Boolean isCkIn {get;set;}

    private static Set<String> setFields = new Set<String>();

    static{
        setFields.add('Latitude__c');
        setFields.add('Longitude__c');
        setFields.add('Location__c');
        setFields.add('Latitude_Out__c');
        setFields.add('Longitude_Out__c');
        setFields.add('Location_Out__c');
    }

    public GoogleMapController() {
        id = ApexPages.currentPage().getParameters().get('id');
        lat = ApexPages.currentPage().getParameters().get('lat');
        lng = ApexPages.currentPage().getParameters().get('lng');
        isCkIn = ApexPages.currentPage().getParameters().get('isCheckIn')!=null ? Boolean.valueOf(ApexPages.currentPage().getParameters().get('isCheckIn')) : null;
        event = Database.query(queryEvent(id));
        System.debug('checkin: ');
        System.debug(isCkIn);
    }

    private String queryEvent(String id){
        String strSelect = 'SELECT ' + String.join(new List<String>(setFields), ',');
        String strFrom = ' FROM Task ';
        String strWhere = ' WHERE Id = \'' + id+'\'';
        return strSelect + strFrom + strWhere;
    }
    
    public PageReference updateLocation(){
        String location = ApexPages.currentPage().getParameters().get('address');
        Task model = Database.query(queryEvent(id));
        if(isCkIn == true){
            model.Location__c = location;
        } else {
            model.Location_Out__c = location;
        }
        
        update model;
        return null;
    }

    @AuraEnabled
    public static void savePosition(String recordId, String latitude, String longitude, Boolean isCheckIn){
        Task model = [SELECT Id, 
            Latitude__c, 
            Longitude__c,
            Latitude_Out__c,
            Longitude_Out__c 
            FROM Task WHERE Id = :recordId];
        if(isCheckIn == true){
            model.Latitude__c = latitude;
            model.Longitude__c = longitude;
        } else {
            model.Latitude_Out__c = latitude;
            model.Longitude_Out__c = longitude;
        }
        
        update model;
    }
}