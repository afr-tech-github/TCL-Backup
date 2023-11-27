public with sharing class BookingNoteController {
    public FTMSSO__c shipment {get;set;}
    public String shipmentId {get;set;}
    public String strQueryShipment {get;set;}
    private static Set<String> setFieldShipment = new Set<String>();

    public CompanyInformation__c companyInf {get;set;}
    public String strQueryCompany {get;set;}
    private static Set<String> setFieldCompany = new Set<String>();

    public List<CntrWrapper> lstCntr {get;set;}
    public String strQueryCntr {get;set;}
    private static Set<String> setFieldsCntr = new Set<String>();
    public List<String> lstContainer {get;set;}


    static {
        setFieldShipment.add('HouseBookingNo__c');
        setFieldShipment.add('ShipperDetailInformation_text__c');
        setFieldShipment.add('Shipper__r.Name');
        setFieldShipment.add('POLAOD__r.Name');
        setFieldShipment.add('POLAOD__r.Country_Code__c');
        setFieldShipment.add('POLAODsDetailInformation__c');
        setFieldShipment.add('PODAOAsDetailInformation__c');
        setFieldShipment.add('PlaceofStuffing__c');
        setFieldShipment.add('StuffingContact__c');
        setFieldShipment.add('PODAOA__r.Name');
        setFieldShipment.add('MotherVesselFlight__c');

        setFieldShipment.add('VesselFlight__c');
        setFieldShipment.add('Voyage__c');
        setFieldShipment.add('ETA__c');
        setFieldShipment.add('ETD__c');

        setFieldShipment.add('ETD__c');
        setFieldShipment.add('TransitVoyageFlight__c');
        setFieldShipment.add('NotesforCustomer__c');
        setFieldShipment.add('MeasurementTotalCBM__c');
        setFieldShipment.add('PlaceofDeliveryDetailInformation__c');
        setFieldShipment.add('PlaceofReceiptDetailInformation__c');
        setFieldShipment.add('FinalDestinationsDetailInformation__c');
        setFieldShipment.add('FinalDestinationDetail__c');
        setFieldShipment.add('CargoClosingTime__c');
        setFieldShipment.add('Date_of_issue__c');
        setFieldShipment.add('Salesman__r.Name');
        setFieldShipment.add('Salesman__r.Phone');
        setFieldShipment.add('PrepaidAt__c');
        setFieldShipment.add('CollectAt__c');
        setFieldShipment.add('HouseFreightCollectPrepaid__c');
        setFieldShipment.add('Branch__c');
        setFieldShipment.add('CargoQuantity__c');
        setFieldShipment.add('CargoUnit__c');
        setFieldShipment.add('Precarriagevoyage__c');
        setFieldShipment.add('Shipment_Type__c');


        setFieldCompany.add('Name');
        setFieldCompany.add('Address__c');
        setFieldCompany.add('Tel__c');
        setFieldCompany.add('Fax__c');

        setFieldsCntr.add('Container_Type__c');
    }

    public BookingNoteController() {
        shipment = new FTMSSO__c();
        companyInf = new CompanyInformation__c();
        lstCntr = new List<CntrWrapper>();
        lstContainer = new list<String>();
        strQueryShipment = '';
        strQueryCntr = '';
        shipmentId = '';

        shipmentId = ApexPages.currentPage().getParameters().get('Id');

        strQueryShipment = stringQueryShipment(shipmentId);
        shipment = getDataShipment(strQueryShipment);

        if(shipment.CargoQuantity__c > 1 && shipment.CargoUnit__c != null && shipment.CargoUnit__c != ''){
            shipment.CargoUnit__c = shipment.CargoUnit__c + 's';
        }
        
        strQueryCompany = stringQueryCompany(shipment.Branch__c);
        companyInf = getDataCompany(strQueryCompany);

        strQueryCntr = stringQueryCntr(shipmentId);
        List<CntrinTrans__c> lstCntr = new List<CntrinTrans__c>();
        lstCntr = Database.query(strQueryCntr);
        Map<String, Integer> mapNameToCount = new Map<String, Integer>();

        for(CntrinTrans__c objCon : lstCntr)
        {
            if(mapNameToCount.containsKey(objCon.Container_Type__c))
            {
                mapNameToCount.put(objCon.Container_Type__c, mapNameToCount.get(objCon.Container_Type__c));
            }
            else
            {
                mapNameToCount.put(objCon.Container_Type__c, 1);
            }
        }

        System.debug('1234:' + mapNameToCount);
        String stringCon = '';
        for (String name: mapNameToCount.keySet()) {
            Integer value = mapNameToCount.get(name);
            stringCon = value + 'X' + name + ' ';
            lstContainer.add(stringCon);
        }
        System.debug('1234:' + lstContainer);

    }

    private FTMSSO__c getDataShipment (String strQueryShipment){
        FTMSSO__c ship = new FTMSSO__c();
        ship = Database.query(strQueryShipment);
        return ship;
    }

    private CompanyInformation__c getDataCompany(String strQueryCompany){
        CompanyInformation__c com = new CompanyInformation__c();
        com = Database.query(strQueryCompany);
        return com;
    }

    private String stringQueryShipment (String shipmentId){
        String strSelect = 'SELECT ' + String.join(new List<String>(setFieldShipment),',');
        String strFrom = ' FROM FTMSSO__c ';
        String strWhere = ' WHERE Id = \'' + shipmentId + '\'';
        String strOrderBy = ' ORDER BY Name';
        return strSelect + strFrom + strWhere + strOrderBy;
    }

    private String stringQueryCompany (String branch){
        String strSelect = 'SELECT ' + String.join(new List<String>(setFieldCompany),',');
        String strFrom = ' FROM CompanyInformation__c ';
        String strWhere = ' WHERE Branch__c = \'' + branch + '\'';
        String strOrderBy = ' ORDER BY Name LIMIT 1';
        return strSelect + strFrom + strWhere + strOrderBy;
    }

    private String stringQueryCntr (String shipmentId){
        String strSelect = 'SELECT ' + String.join(new List<String>(setFieldsCntr),',');
        String strFrom = ' FROM CntrinTrans__c ';
        String strWhere = ' WHERE 	F_TMS_S_O__c = \'' + shipmentId + '\'';
        String strOrderBy = ' ORDER BY Name ';
        return strSelect + strFrom + strWhere + strOrderBy;
    }
    
    public class CntrWrapper{
        public String ContainerName {get;set;}
        public Decimal CountCon {get;set;}
        public CntrWrapper(){
            ContainerName = '';
            CountCon = 0;
        }
    }
}