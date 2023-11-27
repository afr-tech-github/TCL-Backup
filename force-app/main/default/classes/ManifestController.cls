public with sharing class ManifestController {

    public FTMSSO__c objSearch {get; set;}
    public String message {get; set;}
    public Boolean displayReportTable {get; set;}
    public List<ResultWrapper> arrResult {get; set;}

    public String strQuery {get; set;}
    private static Set<String> setFields = new Set<String>();
    public String jobRequestId {get; set;}
    public String hbl {get; set;}

    static{
        setFields.add('Id');
        setFields.add('Shipper__r.TaxCode__c');
        setFields.add('Shipper__c');
        setFields.add('Shipper__r.AccountNameENG__c');
        setFields.add('Shipper__r.EnglishAddress__c');
        setFields.add('Consignee__r.TaxCode__c');
        setFields.add('Consignee__c');
        setFields.add('Consignee__r.AccountNameENG__c');
        setFields.add('Consignee__r.EnglishAddress__c');
        setFields.add('HouseNotifyParty__c');
        setFields.add('HouseNotifyParty__r.AccountNameENG__c');
        setFields.add('HouseNotifyParty__r.TaxCode__c');
        setFields.add('HouseNotifyParty__r.EnglishAddress__c');
        setFields.add('SecondNotifyParty__c');
        setFields.add('SecondNotifyParty__r.AccountNameENG__c');
        setFields.add('SecondNotifyParty__r.TaxCode__c');
        setFields.add('SecondNotifyParty__r.EnglishAddress__c');
        setFields.add('X2ndNotifyPartyNew__c');
        setFields.add('X2ndNotifyPartyNew__r.AccountNameENG__c');
        setFields.add('X2ndNotifyPartyNew__r.TaxCode__c');
        setFields.add('X2ndNotifyPartyNew__r.EnglishAddress__c');
        setFields.add('TransitPortCode__c');
        setFields.add('FinalDestination__c');
        setFields.add('FinalDestination__r.PortCode__c');
        setFields.add('POLAOD__c');
        setFields.add('POLAOD__r.PortCode__c');
        setFields.add('PODAOA__c');
        setFields.add('PODAOA__r.PortCode__c');
        setFields.add('PlaceofDelivery__c');
        setFields.add('PlaceofDelivery__r.Name');
        setFields.add('CargoType__c');
        setFields.add('HBLNumber__c');
        setFields.add('DateofHouseBLIssued__c');
        setFields.add('MBLNumber__c');
        setFields.add('DateofMasterBLIssued__c');
        setFields.add('ETD__c');
        setFields.add('CargoQuantity__c');
        setFields.add('CargoUnit__c');
        setFields.add('GrossWeight__c');
        setFields.add('RemarksforOfficialDocument__c');
        setFields.add('ShipperDetailInformation_Text__c');
        setFields.add('ConsigneeDetailInformation_Text__c');
        setFields.add('HouseNotifyDetailInformation_Text__c');
        setFields.add('PackageUnitCode__c');
        setFields.add('JobRequestID__c');
        setFields.add('RemarkonManifest__c');
        setFields.add('HSCode__c');
        setFields.add('DescriptionofGoods__c');
        setFields.add('GoodsAttachment__c');
    }

    public ManifestController(){
        arrResult = new List<ResultWrapper>();
        objSearch = new FTMSSO__c();
        message = '';
        strQuery = '';
        jobRequestId = 'JobID';
        hbl = 'HBL';
        displayReportTable = false;
        String reportType = ApexPages.currentPage().getParameters().get('reportType');
        if(reportType == 'excel'){
            displayReportTable = true;
            String ankenIds = ApexPages.currentPage().getParameters().get('ankenIds');
            Set<String> setShipId = new Set<String>();
            String prmID = '';
            String prmJobRequestID = '';
            String prmMasterBL = '';
            String prmHBL = '';
            if(!String.isBlank(ankenIds)){
                setShipId.addAll(ankenIds.split(','));
            }
            else{
                prmID = ApexPages.currentPage().getParameters().get('ID');
                prmJobRequestID = ApexPages.currentPage().getParameters().get('JobRequestID');
                prmMasterBL = ApexPages.currentPage().getParameters().get('MasterBL');
                prmHBL = ApexPages.currentPage().getParameters().get('HBL');
            }
            strQuery = stringQueryShipment(prmID, prmJobRequestID, prmMasterBL, prmHBL, setShipId);
            arrResult = getData(strQuery);
            if(arrResult.size() > 0){
                if(!String.isBlank(String.valueOf(arrResult.get(0).shipment.JobRequestID__c))){
                    jobRequestId = String.valueOf(arrResult.get(0).shipment.JobRequestID__c);
                }
                if(!String.isBlank(String.valueOf(arrResult.get(0).shipment.HBLNumber__c))){
                    hbl = String.valueOf(arrResult.get(0).shipment.HBLNumber__c);
                }
            }
        }
    }

    public void reset(){
        arrResult = new List<ResultWrapper>();
        objSearch = new FTMSSO__c();
        message = '';
        displayReportTable = false;
    }

    public void generateReport(){
        strQuery = stringQueryShipment(objSearch.Name, objSearch.JobRequestID__c, objSearch.MBLNumber__c, objSearch.HBLNumber__c, new Set<String>());
        arrResult = getData(strQuery);
        if(arrResult.size() == 0){
            message = 'No record.';
            displayReportTable = false;
        }
        else displayReportTable = true;
    }

    private List<ResultWrapper> getData(String strQuery){
        List<ResultWrapper> results = new List<ResultWrapper>();
        List<FTMSSO__c> shipments = new List<FTMSSO__c>();
        Set<String> setShipId = new Set<String>();
        shipments = Database.query(strQuery);
        for(FTMSSO__c ship : shipments){
            setShipId.add(ship.Id);
            ResultWrapper item = new ResultWrapper();
            item.shipmentId = String.valueOf(ship.Id);
            item.shipment = ship;
            if(ship.HouseNotifyParty__c == ship.Consignee__c){
                item.notifyPart1 = 'SAME AS CONSIGNEE';
            }
            else if(!String.isBlank(ship.HouseNotifyParty__c)){
                // item.notifyPart1 = ship.HouseNotifyParty__r.TaxCode__c +'#'+ship.HouseNotifyParty__r.AccountNameENG__c.replaceAll('\n', '<br/>')+'#'+ship.HouseNotifyParty__r.EnglishAddress__c;
                item.notifyPart1 = '';
            }

            if(ship.X2ndNotifyPartyNew__c == ship.Consignee__c){
                item.notifyPart2 = 'SAME AS CONSIGNEE';
            }
            else if(!String.isBlank(ship.X2ndNotifyPartyNew__r.AccountNameENG__c)){
                // item.notifyPart2 = ship.X2ndNotifyPartyNew__r.TaxCode__c +'#'+ship.X2ndNotifyPartyNew__r.EnglishCompanyName__c.replaceAll('\n', '<br/>')+'#'+ship.X2ndNotifyPartyNew__r.EnglishAddress__c;
                item.notifyPart2 = '';
            }

            // if(!String.isBlank(ship.ShipperDetailInformation__c)){
            //     item.shipment.ShipperDetailInformation__c = ship.ShipperDetailInformation__c.replaceAll('\n', '<br/>');
            // }
            
            // if(!String.isBlank(ship.ConsigneeDetailInformation__c)){
            //     item.shipment.ConsigneeDetailInformation__c = ship.ConsigneeDetailInformation__c.replaceAll('\n', '<br/>');
            // }

            if(!String.isBlank(ship.RemarksforOfficialDocument__c)){
                item.shipment.RemarksforOfficialDocument__c = ship.RemarksforOfficialDocument__c.replaceAll('\n', '<br/>');
            }
            if(!String.isBlank(ship.RemarkonManifest__c)){
                item.shipment.RemarkonManifest__c = ship.RemarkonManifest__c.replaceAll('\n', '<br/>');
            }
            if(!String.isBlank(ship.DescriptionofGoods__c)){
                if(!String.isBlank(ship.GoodsAttachment__c)){
                    item.shipment.DescriptionofGoods__c += '<br/>';
                }
                item.shipment.DescriptionofGoods__c = ship.DescriptionofGoods__c.replaceAll('\n', '<br/>');
            }
            if(!String.isBlank(ship.GoodsAttachment__c)){
                item.shipment.GoodsAttachment__c = ship.GoodsAttachment__c.replaceAll('\n', '<br/>');
            }
            
            results.add(item);
        }

        Map<String, List<CntrinTrans__c>> mapConInfo = getContainerInfo(setShipId);
        for(ResultWrapper item : results){
            if(mapConInfo.containsKey(item.shipmentId)){
                item.arrConInfo = mapConInfo.get(item.shipmentId);
            }
        }

        return results;
    }

    private Map<String, List<CntrinTrans__c>> getContainerInfo(Set<String> setShipId){
        Map<String, List<CntrinTrans__c>> mapConInfo = new Map<String, List<CntrinTrans__c>>();
        List<CntrinTrans__c> conInfos = new List<CntrinTrans__c>();
        conInfos = [ SELECT F_TMS_S_O__c, 
                            Description_of_Goods__c, 
                            Gross_Weight_Kg__c, 
                            Measurement_CBM__c, 
                            Container_Number__c, 
                            Seal_Number__c 
                    FROM CntrinTrans__c 
                    WHERE F_TMS_S_O__c IN :setShipId ];
        for(CntrinTrans__c con : conInfos){
            if(!mapConInfo.containsKey(con.F_TMS_S_O__c)){
                mapConInfo.put(con.F_TMS_S_O__c, new List<CntrinTrans__c>());
            }
            if(!String.isBlank(con.Description_of_Goods__c)){
                con.Description_of_Goods__c = con.Description_of_Goods__c.replaceAll('\n', '<br/>');
            } 
            mapConInfo.get(con.F_TMS_S_O__c).add(con);
        }
        return  mapConInfo;
    }

    private String stringQueryShipment(String prmID, String prmJobRequestID, String prmMasterBL, String prmHBL, Set<String> setIds){
        String strSelect = 'SELECT ' + String.join(new List<String>(setFields), ',');
        String strFrom = ' FROM FTMSSO__c ';
        String strWhere = '';
        String strOrderBy = ' ORDER BY Name';

        if(setIds.size() > 0){
            String condIds = '';
            for(String shipId : setIds){
                condIds += '\'' + shipId + '\',';
            }
            condIds = '(' + condIds.removeEnd(',') + ')';
            strWhere += 'AND Id IN ' + condIds;
        }

        if(!String.isBlank(prmID)){
            strWhere += returnWhereCondition('Name', String.escapeSingleQuotes(prmID));
        }

        if(!String.isBlank(prmJobRequestID)){
            strWhere += returnWhereCondition('JobRequestID__c', String.escapeSingleQuotes(prmJobRequestID));
        }

        if(!String.isBlank(prmMasterBL)){
            strWhere += returnWhereCondition('MBLNumber__c', String.escapeSingleQuotes(prmMasterBL));
        }

        if(!String.isBlank(prmHBL)){
            strWhere += returnWhereCondition('HBLNumber__c', String.escapeSingleQuotes(prmHBL));
        }

        if(!String.isBlank(strWhere)) {
            strWhere = strWhere.replaceFirst('AND', 'WHERE');
        }
        return strSelect + strFrom + strWhere + strOrderBy;
    }

    private String returnWhereCondition(String fieldSearch, String valueSearch){
        String whereStr = '';
        List<String> listValue = valueSearch.split(',');
        for(String item : listValue){
            whereStr += fieldSearch + ' LIKE \'%' + String.escapeSingleQuotes(item.trim()) + '%\' OR ';
        }
        if(!String.isBlank(whereStr)){
            whereStr = ' AND (' + whereStr.removeEnd('OR ') + ')';
        }
        return whereStr;
    }

    public class ResultWrapper{
        public String shipmentId {get; set;}
        public FTMSSO__c shipment {get; set;}
        public String notifyPart1 {get; set;}
        public String notifyPart2 {get; set;}
        public List<CntrinTrans__c> arrConInfo {get; set;}

        public ResultWrapper(){
            this.shipmentId = '';
            this.shipment = new FTMSSO__c();
            this.notifyPart1 = '';
            this.notifyPart2 = '';
            this.arrConInfo = new List<CntrinTrans__c>();
        }
    }

}