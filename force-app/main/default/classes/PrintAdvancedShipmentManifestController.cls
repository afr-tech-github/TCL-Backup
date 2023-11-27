public with sharing class PrintAdvancedShipmentManifestController {
    public AdvancedShipment__c advancedShipment {get; set;}
    public List<FTMSSO__c> lstShipment {get; set;}
    public List<ConsolCNTR__c> lstConsolCont {get; set;}
    public CompanyInformation__c ComInf {get; set;}
    public Date today {get; set;}
    public String userName {get; set;}
    public Integer totalShip {get; set;}
    public Decimal totalPackage {get; set;}
    public Decimal totalGrossWeight {get; set;}
    public Decimal totalMeasurement {get; set;}
    // public List<String> lstType {get; set;}
    public String type {get; set;}
    private String advancedShipId {get; set;}


    private static Set<String> fieldsAdvancedShipQuery = new Set<String>();
    static {
        fieldsAdvancedShipQuery.add('Id');
        fieldsAdvancedShipQuery.add('Name');
        fieldsAdvancedShipQuery.add('VesselFlight__c');
        fieldsAdvancedShipQuery.add('Voyage__c');
        fieldsAdvancedShipQuery.add('FileNo__c');
        fieldsAdvancedShipQuery.add('MPOL__r.Name');
        fieldsAdvancedShipQuery.add('MPOD__r.Name');
        fieldsAdvancedShipQuery.add('ETD__c');
        fieldsAdvancedShipQuery.add('ETA__c');
        fieldsAdvancedShipQuery.add('MBLorMAWBNumber__c');
        fieldsAdvancedShipQuery.add('Branch__c');
        fieldsAdvancedShipQuery.add('MAgent__r.Name');
    }

    private static Set<String> fieldConsolCont = new Set<String>();
    static {
        fieldConsolCont.add('Id');
        fieldConsolCont.add('Name');
        fieldConsolCont.add('AdvancedShipment__c');
        fieldConsolCont.add('Container_Number__c');
        fieldConsolCont.add('Seal_Number__c');
        fieldConsolCont.add('Container_Type__c');
    }

    private static Set<String> fieldsShipQuery = new Set<String>();
    static {
        fieldsShipQuery.add('Id');
        fieldsShipQuery.add('Name');
        fieldsShipQuery.add('PlaceofDelivery__r.Name');
        fieldsShipQuery.add('HBLNumber__c');
        fieldsShipQuery.add('ConsigneeDetailInformation_text__c');
        fieldsShipQuery.add('HouseNotifyDetailInformation_text__c');
        fieldsShipQuery.add('MarksNumbersAttachment__c'); 
        fieldsShipQuery.add('CargoQuantity__c');
        fieldsShipQuery.add('CargoUnit__c');
        fieldsShipQuery.add('DescriptionofGoods__c');
        fieldsShipQuery.add('GrossWeight__c');
        fieldsShipQuery.add('MeasurementTotalCBM__c');
        fieldsShipQuery.add('HouseFreightCollectPrepaid__c');
        fieldsShipQuery.add('HBLType__c');
        fieldsShipQuery.add('ConsolidationID__c');
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

    public PrintAdvancedShipmentManifestController() {
        advancedShipId = ApexPages.currentPage().getParameters().get('Id');
        advancedShipment = getAdvancedShipment(advancedShipId);
        lstConsolCont = getListConsolContainer(advancedShipId);
        lstShipment = getListShipment(advancedShipId);
        ComInf = getComIn(advancedShipment.Branch__c);
        today = Date.today();
        userName = UserInfo.getName();
        totalShip = 0;
        totalPackage = 0;
        totalGrossWeight = 0;
        totalMeasurement = 0;
        totalShip = lstShipment.size();
        type = '';
        Set<String> lstType = new Set<String>();
        for (FTMSSO__c so : lstShipment){
            totalPackage += so.CargoQuantity__c != null?so.CargoQuantity__c:0;
            totalGrossWeight += so.GrossWeight__c != null?so.GrossWeight__c:0;
            totalMeasurement += so.MeasurementTotalCBM__c != null?so.MeasurementTotalCBM__c:0;
            if (so.CargoUnit__c != null){
                type = so.CargoUnit__c;
                lstType.add(so.CargoUnit__c);
            }
        }
        if(lstType.size()>1){
            type = 'PKGS';
        }
    }

    private AdvancedShipment__c getAdvancedShipment(String advancedShipId){
        String strSelect = String.join(new List<String>(fieldsAdvancedShipQuery), ',');
        String strQuery = 'SELECT ' + strSelect 
                    + ' FROM AdvancedShipment__c'
                    + ' WHERE Id = \'' + String.escapeSingleQuotes(advancedShipId) + '\'';
        System.debug('queryAdvancedShip: '+strQuery);
        AdvancedShipment__c advancedShip;
        try{
            advancedShip = Database.query(strQuery);
        } catch(QueryException e){
            advancedShip = new AdvancedShipment__c();
        }
        return advancedShip;
    }
    
    private List<ConsolCNTR__c> getListConsolContainer(String advancedShipId){
        String strSelect = String.join(new List<String>(fieldConsolCont), ',');
        String strQuery = 'SELECT ' + strSelect 
                    + ' FROM ConsolCNTR__c'
                    + ' WHERE AdvancedShipment__c = \'' + String.escapeSingleQuotes(advancedShipId) + '\'';
        System.debug('queryShip: '+strQuery);
        List<ConsolCNTR__c> lstConsolCont;
        try{
            lstConsolCont = Database.query(strQuery);
        } catch(QueryException e){
            lstConsolCont = new  List<ConsolCNTR__c>();
        }
        return lstConsolCont;
    }

    private List<FTMSSO__c> getListShipment(String advancedShipId){
        String strSelect = String.join(new List<String>(fieldsShipQuery), ',');
        String strQuery = 'SELECT ' + strSelect 
                    + ' FROM FTMSSO__c'
                    + ' WHERE ConsolidationID__c = \'' + String.escapeSingleQuotes(advancedShipId) + '\'';
        System.debug('queryShip: '+strQuery);
        List<FTMSSO__c> lstShip;
        try{
            lstShip = Database.query(strQuery);
        } catch(QueryException e){
            lstShip = new  List<FTMSSO__c>();
        }
        return lstShip;
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