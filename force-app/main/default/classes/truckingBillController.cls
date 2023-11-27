public with sharing class truckingBillController {
    public CompanyInformation__c Company {get;set;}
    public Transportation__c trains {get;set;}
    public FTMSSO__c So {get;set;}


    private static Set<String> SoQuery = new Set<String>();
    private static Set<String> trainQuery = new Set<String>();

    static{
        SoQuery.add('ShipperDetailInformation__c');
        SoQuery.add('ConsigneeDetailInformation__c');
        SoQuery.add('HouseNotifyPartyDetail_Information__c');
        SoQuery.add('PlaceofReceipt__r.City_Name__c');
        SoQuery.add('PlaceofReceipt__r.CountryName__c');
        SoQuery.add('POLAOD__r.City_Name__c');
        SoQuery.add('POLAOD__r.CountryName__c');
        SoQuery.add('PODAOA__r.City_Name__c');
        SoQuery.add('PODAOA__r.CountryName__c');
        SoQuery.add('PlaceofDelivery__r.City_Name__c');
        SoQuery.add('PlaceofDelivery__r.CountryName__c');
        SoQuery.add('FinalDestination__r.City_Name__c');
        SoQuery.add('FinalDestination__r.CountryName__c');
        SoQuery.add('MarksNumbersAttachment__c');
        SoQuery.add('CargoQuantity__c');
        SoQuery.add('CargoUnit__c');
        SoQuery.add('DescriptionofGoods__c');
        SoQuery.add('GrossWeight__c');
        SoQuery.add('MeasurementTotalCBM__c');
        SoQuery.add('ETD__c');
        SoQuery.add('HouseFreightCollectPrepaid__c');
        SoQuery.add('AgentDetailInformation__c');
        SoQuery.add('PrepaidAt__c');
        SoQuery.add('Payable_At_HBL__c');
        SoQuery.add('NumberofOriginalHBLIssued__c');
        SoQuery.add('Place_of_issue__c');
        SoQuery.add('Date_of_issue__c');
        SoQuery.add('PODAOA__r.City_Name__c');
        SoQuery.add('Plural_Cargo_Unit__c');

        
        
        
        trainQuery.add('Cargo_Delivery_Remarks__c');
        trainQuery.add('TruckingBillNo__c');



    }
    public truckingBillController() {
        String scheduleID = ApexPages.currentPage().getParameters().get('id');
        String OderID = ApexPages.currentPage().getParameters().get('orderId');
     
        trains = getDonHang(scheduleID);
        So = getSo(OderID);
        Company= [SELECT Name, Id,CompanyLogo__c,Address__c,TaxCode__c,Tel__c,Website__c,Email__c  FROM CompanyInformation__c  WHERE Branch1__c = 'Hồ Chí Minh' limit 1];

    }

    private Transportation__c getDonHang(String scheduleID){
        String strSelect = String.join(new List<String>(trainQuery), ',');
        String strQuery = 'SELECT ' + strSelect 
                    + ' FROM Transportation__c'
                    + ' WHERE Id = \'' + scheduleID + '\'';
        Transportation__c donhang;
        try{
            donhang = Database.query(strQuery);
        } catch(QueryException e){
            donhang = new Transportation__c();
        }
        return donhang;
    }

    private FTMSSO__c getSo(String scheduleID){
        String strSelect = String.join(new List<String>(SoQuery), ',');
        String strQuery = 'SELECT ' + strSelect 
                    + ' FROM FTMSSO__c'
                    + ' WHERE Id = \'' + scheduleID + '\'';
                    FTMSSO__c donhang;
        try{
            donhang = Database.query(strQuery);
        } catch(QueryException e){
            donhang = new FTMSSO__c();
        }
        return donhang;
    }

  
}