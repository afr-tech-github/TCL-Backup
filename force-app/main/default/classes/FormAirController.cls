public with sharing class FormAirController {
    public FTMSSO__c shipment {get; set;}

    public CompanyInformation__c ComInf {get; set;}

    private String shipId {get; set;}

    public Date PrintDate {get; set;}

    public String ComName {get;set;}

    private static Set<String> fieldsShipQuery = new Set<String>();

    static{ 
        fieldsShipQuery.add('Terminal__r.Name');
        fieldsShipQuery.add('JobRequestID__c');
        fieldsShipQuery.add('Consignee__r.Name');
        fieldsShipQuery.add('Consignee__r.EnglishAddress__c');
        fieldsShipQuery.add('MAWBNumber__c');
        fieldsShipQuery.add('HAWBNumber__c');
        fieldsShipQuery.add('FlightNumber__c');
        fieldsShipQuery.add('CargoQuantity__c');
        fieldsShipQuery.add('GrossWeight__c');
        fieldsShipQuery.add('DescriptionofGoods__c');
        fieldsShipQuery.add('Branch__c');
        fieldsShipQuery.add('ETA__c');
        fieldsShipQuery.add('VesselFlight__c');
        fieldsShipQuery.add('PlaceofDeliveryDetailInformation__c');
        fieldsShipQuery.add('AirWarehouse__c');
    }
    private static Set<String> fieldsComInQuery = new Set<String>();
    static {
        fieldsComInQuery.add('Id');
        fieldsComInQuery.add('Name');
        fieldsComInQuery.add('Address__c');
        fieldsComInQuery.add('Tel__c');
        fieldsComInQuery.add('Fax__c');
        fieldsComInQuery.add('Taxcode__c');
        fieldsComInQuery.add('CompanyLogo__c');
        fieldsComInQuery.add('Email__c');
        fieldsComInQuery.add('Website__c');
    }
    public FormAirController() {
        shipId = ApexPages.currentPage().getParameters().get('id');
        System.debug('shipId :'+shipId);
        shipment = getShipment(shipId);
        System.debug('shipment :'+shipment);
        String city = shipment.Branch__c;
        System.debug('city :'+city);
        ComInf = getComIn(city);
        PrintDate = Date.today();
        // ComName = '';
        if(shipment.AirWarehouse__c != null){
            ComName = shipment.AirWarehouse__c.subStringAfter(':');
            System.debug('1122: ' + ComName);
        }
    }
    private FTMSSO__c getShipment(String shipId){
        String strSelect = String.join(new List<String>(fieldsShipQuery), ',');
        String strQuery = 'SELECT ' + strSelect 
                    + ' FROM FTMSSO__c'
                    + ' WHERE Id = \'' + String.escapeSingleQuotes(shipId) + '\'';
        FTMSSO__c ship;
        try{
            ship = Database.query(strQuery);
        } catch(QueryException e){
            ship = new FTMSSO__c();
        }
        return ship;
    }
    private CompanyInformation__c getComIn(String branch){
        String strSelect = String.join(new List<String>(fieldsComInQuery), ',');
        String strQuery = 'SELECT ' + strSelect 
                    + ' FROM CompanyInformation__c'
                    + ' WHERE Branch__c = \'' + String.escapeSingleQuotes(branch) + '\'';
        strQuery += ' ORDER BY Name ASC Limit 1';        
        CompanyInformation__c ComIn;
        try{
            ComIn = Database.query(strQuery);
            System.debug('ComIn :'+ComIn);
        } catch(QueryException e){
            ComIn = new CompanyInformation__c();
        }
        return ComIn;
    }
}