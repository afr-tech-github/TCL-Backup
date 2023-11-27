public with sharing class printSeaManifestController {
    private static Set<String> SoQuery = new Set<String>();
    private static Set<String> CNTRQuery = new Set<String>();

    public Transportation__c trains {get;set;}
    public CompanyInformation__c Company {get;set;}
    public String formattedDateTime { get; set; }
    public List<CntrinTrans__c> CNTRList {get;set;}
    public FTMSSO__c So {get;set;}

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
        SoQuery.add('CWDimension__c');
        SoQuery.add('ContainerNo__c');
        SoQuery.add('ContainerNoSealNo__c');
        SoQuery.add('SecondNotifyParty__c');
        SoQuery.add('TransitPortCode__c');
        SoQuery.add('FinalDestination__r.PortCode__c');
        SoQuery.add('POLAOD__r.PortCode__c');
        SoQuery.add('PODAOA__r.PortCode__c');
        SoQuery.add('PlaceofDelivery__r.Name');
        SoQuery.add('CargoType__c');
        SoQuery.add('HBLNumber__c');
        SoQuery.add('DateofHouseBLIssued__c');
        SoQuery.add('MBLNumber__c');
        SoQuery.add('DateofMasterBLIssued__c');
        SoQuery.add('PackageUnitCode__c');
        SoQuery.add('GrossWeightUnit__c');
        SoQuery.add('RemarkonManifest__c');
        SoQuery.add('MAWBNumber__c');
        SoQuery.add('POLAOD__r.Name');
        SoQuery.add('FlightNumber__c');
        SoQuery.add('HAWBNumber__c');
        SoQuery.add('NumberofContainersPackages__c');
        SoQuery.add('Plural_Cargo_Unit__c');
        SoQuery.add('FinalDestination__r.Standard_Port_Code__c');
        SoQuery.add('VesselFlight__c');
        SoQuery.add('HSCode__c');
        SoQuery.add('HouseNotifyPartyDetail_Information__c');
        SoQuery.add('SecondNotifyPartyDetailInformation__c');
        SoQuery.add('FinalDestination__r.Standard_Port_Code__c');
        SoQuery.add('POLAOD__r.Standard_Port_Code__c');
        SoQuery.add('PODAOA__r.Standard_Port_Code__c');
        

        CNTRQuery.add('Gross_Weight_Kg__c');
         CNTRQuery.add('Description_of_Goods__c');
         CNTRQuery.add('Measurement_CBM__c');
         CNTRQuery.add('Container_Number__c');
         CNTRQuery.add('Seal_Number__c');

        
    }
    public printSeaManifestController() {
        String OderID = ApexPages.currentPage().getParameters().get('id');
        So = getSo(OderID);
        CNTRList = getCNTR(OderID);

        Company= [SELECT Name,Name__c,
         Id,CompanyLogo__c,
         TaxCode__c,Tel__c,Website__c
         ,Email__c ,Address__c,Fax__c
          FROM CompanyInformation__c  WHERE Branch1__c = 'Hồ Chí Minh' limit 1];
          Datetime currentDateTime = Datetime.now();
          formattedDateTime = formatDatetime(currentDateTime);

    }
    public String formatDatetime(Datetime dt) {
        // Format the datetime in the desired format
        return dt.format('dd MMM, yyyy  h:mm:ssa');
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

    private List<CntrinTrans__c> getCNTR(String scheduleID){
        String strSelect = String.join(new List<String>(CNTRQuery), ',');
        String strQuery = 'SELECT ' + strSelect 
                    + ' FROM CntrinTrans__c'
                    + ' WHERE F_TMS_S_O__c = \'' + scheduleID + '\'';
                    List<CntrinTrans__c> donhang;
        try{
            donhang = Database.query(strQuery);
        } catch(QueryException e){
            donhang = new List<CntrinTrans__c>();
        }
        return donhang;
    }

}