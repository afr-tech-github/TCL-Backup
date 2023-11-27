public with sharing class PrintConsolManifestController {
    public FTMSSO__c shipment {get; set;}
    public CompanyInformation__c ComInf {get; set;}
    public Date today {get; set;}
    public String userName {get; set;}
    private String shipId {get; set;}

    private static Set<String> fieldsShipQuery = new Set<String>();
    static {
        fieldsShipQuery.add('Id');
        fieldsShipQuery.add('Name');
        fieldsShipQuery.add('ShipperDetailInformation_Text__c');
        fieldsShipQuery.add('MAWBNumber__c');
        fieldsShipQuery.add('FlightNumber__c');
        fieldsShipQuery.add('ETD__c');
        fieldsShipQuery.add('ETA__c'); 
        fieldsShipQuery.add('PODAOA__r.Name');
        fieldsShipQuery.add('PODAOA__r.Country_Code__c');
        fieldsShipQuery.add('POLAOD__r.PortCode__c');
        fieldsShipQuery.add('PODAOA__r.PortCode__c');
        fieldsShipQuery.add('AgentDetailInformation_Text__c');
        fieldsShipQuery.add('HAWBNumber__c');
        fieldsShipQuery.add('CargoQuantity__c');
        fieldsShipQuery.add('GrossWeight__c');
        fieldsShipQuery.add('DescriptionofGoods__c');
        fieldsShipQuery.add('InvoiceNumber__c');
        fieldsShipQuery.add('CWDimension__c');
        fieldsShipQuery.add('ConsigneeDetailInformation_Text__c');
        fieldsShipQuery.add('HouseFreightCollectPrepaid__c');
        fieldsShipQuery.add('Owner.Name');
        fieldsShipQuery.add('VesselFlight__c');
        fieldsShipQuery.add('Branch__c');
        fieldsShipQuery.add('Dimension__c');
        fieldsShipQuery.add('POLAODsDetailInformation__c');
        fieldsShipQuery.add('PODAOAsDetailInformation__c');
    }


    private static Set<String> fieldsComInQuery = new Set<String>();
    static {
        fieldsComInQuery.add('Id');
        fieldsComInQuery.add('Name');
        fieldsComInQuery.add('Address__c');
        fieldsComInQuery.add('Tel__c');
        fieldsComInQuery.add('Fax__c');
        fieldsComInQuery.add('Taxcode__c');
        fieldsComInQuery.add('Email__c');
        fieldsComInQuery.add('Website__c');
        fieldsComInQuery.add('Branch__c');
        fieldsComInQuery.add('CompanyLogo__c');
    }

    public PrintConsolManifestController() {
        shipId = ApexPages.currentPage().getParameters().get('Id');
        shipment = getShipment(shipId);
        ComInf = getComIn(shipment.Branch__c);
        today = Date.today();
        userName = UserInfo.getName();
    }

    private FTMSSO__c getShipment(String shipId){
        String strSelect = String.join(new List<String>(fieldsShipQuery), ',');
        String strQuery = 'SELECT ' + strSelect 
                    + ' FROM FTMSSO__c'
                    + ' WHERE Id = \'' + String.escapeSingleQuotes(shipId) + '\'';
        System.debug('queryShip: '+strQuery);
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
        } catch(QueryException e){
            ComIn = new CompanyInformation__c();
        }
        return ComIn;
    }
}