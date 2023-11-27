public with sharing class PrintDOController {
    public FTMSSO__c shipment {get; set;}
    public CompanyInformation__c ComInf {get; set;}
    public Date today {get; set;}

    public String shipId {get; set;}
    public String recordType {get;set;}
    public String titlePdf {get;set;}
    public Boolean requiredAttachment {get;set;}

    private static Set<String> fieldsShipQuery = new Set<String>();
    static {
        fieldsShipQuery.add('Id');
        fieldsShipQuery.add('Name');
        // fieldsShipQuery.add('ShipperDetailInformation__c');
        fieldsShipQuery.add('Shipper__r.Name');
        fieldsShipQuery.add('VesselFlight__c');
        fieldsShipQuery.add('Voyage__c');
        fieldsShipQuery.add('POLAOD__r.Name');
        fieldsShipQuery.add('POLAOD__r.Country_Name__c');
        fieldsShipQuery.add('ETA__c');
        fieldsShipQuery.add('CargoType__c');
        fieldsShipQuery.add('NumberofContainersPackages__c');
        fieldsShipQuery.add('GrossWeight__c');
        fieldsShipQuery.add('HBLNumber__c');
        fieldsShipQuery.add('MBLNumber__c');
        fieldsShipQuery.add('HBLIssueStatus__c');
        fieldsShipQuery.add('PlaceofDelivery__r.Name');
        fieldsShipQuery.add('HBLType__c');
        fieldsShipQuery.add('Consignee__r.AccountNameENG__c');
        fieldsShipQuery.add('Consignee__r.Name');
        fieldsShipQuery.add('Consignee__r.EnglishAddress__c');
        fieldsShipQuery.add('JobRequestID__c');
        fieldsShipQuery.add('Owner.Name');
        fieldsShipQuery.add('Owner.Email');
        fieldsShipQuery.add('ContainerNo__c');
        fieldsShipQuery.add('SealNo__c');
        fieldsShipQuery.add('ContainerType1__c');
        fieldsShipQuery.add('ContainerType2__c');
        fieldsShipQuery.add('CargoQuantity__c');
        fieldsShipQuery.add('Measurement__c');
        fieldsShipQuery.add('DescriptionofGoods__c');
        fieldsShipQuery.add('Branch__c');
        fieldsShipQuery.add('CargoUnit__c');
        fieldsShipQuery.add('Warehouse__c');
        fieldsShipQuery.add('ContainerNo__c');
        fieldsShipQuery.add('RecordTypeId');
        fieldsShipQuery.add('HAWBNumber__c');
        fieldsShipQuery.add('Terminal__r.PortCode__c');
        fieldsShipQuery.add('ContainerDetailonBL__c');
        fieldsShipQuery.add('MeasurementTotalCBM__c');
        fieldsShipQuery.add('PlaceofDeliveryDetailInformation__c');
		fieldsShipQuery.add('POLAODsDetailInformation__c');
		fieldsShipQuery.add('Shipment_Type__c');
        fieldsShipQuery.add('ConsigneeDetailInformation_text__c');
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

    public PrintDOController() {
        shipId = ApexPages.currentPage().getParameters().get('Id');
        System.debug('1234:' + shipId);
        shipment = getShipment(shipId);
        if( shipment.PlaceofDeliveryDetailInformation__c != null){

            shipment.PlaceofDeliveryDetailInformation__c=shipment.PlaceofDeliveryDetailInformation__c.toUppercase();
        }
        if(shipment.POLAOD__r.Name != null) shipment.POLAOD__r.Name= shipment.POLAOD__r.Name.toUppercase();
        if(shipment.POLAOD__r.Country_Name__c != null) shipment.POLAOD__r.Country_Name__c= shipment.POLAOD__r.Country_Name__c.toUppercase();

        System.debug('1234:'+shipment);
        
        String RecordTypeId = shipment.RecordTypeId;
        System.debug('1234:' + RecordTypeId);
        RecordType = [SELECT Id,Name from RecordType WHERE Id =:recordTypeId].Name;
        if(recordType == 'Ocean Export' || recordType == 'Ocean Import'){
            titlePdf = 'DO - ' + shipment.HBLNumber__c;
        }else if(recordType == 'Air Export' || recordType == 'Air Import'){
            titlePdf = 'DO - ' + shipment.HAWBNumber__c;
        }
        Apexpages.currentPage().getHeaders().put('content-disposition', 'inline; filename=\"'+titlePdf+'.pdf'+'\"');
        
        ComInf = getComIn(shipment.Branch__c);
        today = Date.today();

    }

    public PageReference closePopupDialog() {
        PageReference page = new PageReference('/'+shipId);
        page.setRedirect(true);
        return page;
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