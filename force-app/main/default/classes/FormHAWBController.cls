public with sharing class FormHAWBController {

    public FTMSSO__c shipment {get; set;}

    private static Set<String> fieldsQuery = new Set<String>();

    static{
        // fieldsQuery.add('');
        fieldsQuery.add('Id');
        fieldsQuery.add('ShipperDetailInformation_text__c');
        fieldsQuery.add('ConsigneeDetailInformation_text__c');
        fieldsQuery.add('HouseNotifyDetailInformation_text__c');
        fieldsQuery.add('HBLNumber__c');
        fieldsQuery.add('POLAODsDetailInformation__c');
        fieldsQuery.add('PODAOAsDetailInformation__c');
        fieldsQuery.add('VesselFlight__c');
        fieldsQuery.add('ETD__c');
        fieldsQuery.add('PODAOA__r.PortCode__c');
        fieldsQuery.add('MAWBNumber__c');
        fieldsQuery.add('HouseFreightCollectPrepaid__c');
        fieldsQuery.add('AgentDetailInformation_text__c');
        fieldsQuery.add('CargoQuantity__c');
        fieldsQuery.add('GrossWeight__c');
        fieldsQuery.add('ChargeableWeight__c');
        fieldsQuery.add('DescriptionofGoods__c');
        fieldsQuery.add('InvoiceNumber__c');
        fieldsQuery.add('Dimension__c');
        fieldsQuery.add('DateofHouseBLIssued__c');
    }

    public FormHAWBController() {
        String id = ApexPages.currentPage().getParameters().get('Id');
        shipment = Database.query(querySO(id));
    }

    private String querySO(String id){
        String strSelect = String.join(new List<String>(fieldsQuery), ',');
        String strQuery = 'SELECT ' + strSelect 
                    + ' FROM FTMSSO__c'
                    + ' WHERE Id = \'' + id + '\'';
        return strQuery;
    }
}