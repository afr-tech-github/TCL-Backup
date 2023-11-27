public with sharing class EDOController {
    public String id {get; set;}
    public FTMSSO__c shipment {get; set;}
    public CompanyInformation__c comp {get; set;}
    
    private static Set<String> setFields = new Set<String>();
    static{
        setFields.add('CreatedDate');
        setFields.add('VesselFlight__c');
        setFields.add('ETA__c');
        setFields.add('POLAOD__r.Standard_Port_Code__c');
        setFields.add('PODAOA__r.Standard_Port_Code__c');
        setFields.add('MAWBNumber__c');
        setFields.add('HAWBNumber__c');
        setFields.add('CargoQuantity__c');
        setFields.add('GrossWeight__c');
        setFields.add('DescriptionofGoods__c');
        setFields.add('Consignee__r.Name');
        setFields.add('Consignee__r.Company_Address__c');
        setFields.add('Consignee__r.Name');
        setFields.add('Branch__c');
        setFields.add('Branch1__c');
    }
    public EDOController() {
        id = ApexPages.currentPage().getParameters().get('id');
        String strQuery = stringQueryShipment(id);
        shipment = Database.query(strQuery);
        String branch = '';
        if(shipment.Branch1__c == 'Ho Chi Minh'){
            branch = 'Hồ Chí Minh';
        }
        if(shipment.Branch1__c == 'Hai Phong'){
            branch = 'Hải Phòng';
        }
        if(shipment.Branch1__c == 'Da Nang'){
            branch = 'Đà Nẵng';
        }else {
            branch = shipment.Branch1__c;
        }
        
        System.debug('branch :'+shipment.Branch1__c);
        String strQueryComp = stringQueryCompany(branch);
        System.debug('strQueryComp :'+strQueryComp);
        comp = Database.query(strQueryComp);
    }
    private String stringQueryShipment(String shipmentId){
        String strSelect = 'SELECT RecordType.Name,' + String.join(new List<String>(setFields), ',');
        String strFrom = ' FROM FTMSSO__c ';
        String strWhere = 'WHERE Id = \'' + shipmentId + '\'' ;
        String strOrderBy = ' ORDER BY Name LIMIT 1';
        return strSelect + strFrom + strWhere + strOrderBy;
    }
    private String stringQueryCompany(String branch){
        String strSelect = 'SELECT Branch1__c, Name, Address__c, Email__c';
        String strFrom = ' FROM CompanyInformation__c ';
        String strWhere = 'WHERE Branch1__c = \'' + branch + '\'' ;
        String strOrderBy = ' ORDER BY Name LIMIT 1';
        return strSelect + strFrom + strWhere + strOrderBy;
    }
}