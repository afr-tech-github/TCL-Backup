//public class AdvancedShipmentClass {
public without sharing class AdvancedShipmentClass {
    private static Set<String> setFieldSO = new Set<String>();
    static{
        setFieldSO.add('JobRequestID__c');
        setFieldSO.add('FileNo__c');
        // setFieldSO.add('GrossWeight__c');
        // // setFieldSO.add('Measurement__c');
        setFieldSO.add('MAgent__r.Name');
        setFieldSO.add('Agent2nd__r.Name');
        setFieldSO.add('MPOD__r.Name');
        setFieldSO.add('MPOL__r.Name');
        // setFieldSO.add('POD_Formul__c');
        // setFieldSO.add('POLformula__c');
        setFieldSO.add('VesselFlight__c');
        setFieldSO.add('Voyage__c');
        setFieldSO.add('MBLorMAWBNumber__c');
        // setFieldSO.add('MBLNumber__c');
        setFieldSO.add('Name');
        setFieldSO.add('Branch__c');
        setFieldSO.add('CargoType__c');
        setFieldSO.add('GrossWeight__c');
        setFieldSO.add('MeasurementCBM__c');
        setFieldSO.add('Shipment_Type__c');
        setFieldSO.add('RecordType.Name');

        setFieldSO.add('Container_Qnty_1__c');
        setFieldSO.add('Container_Qnty_2__c');
        setFieldSO.add('Container_Qnty_3__c');
        setFieldSO.add('Container_Type_1__c');
        setFieldSO.add('Container_Type_2__c');
        setFieldSO.add('Container_Type_3__c');
    }
	public static void isBeforeInsert(List<AdvancedShipment__c> lstAdShipNew){
        System.debug('12345');
        Set<Date> setAccountedDate = new Set<Date>();
        for (AdvancedShipment__c adShip : lstAdShipNew){
            if (adShip.isClone()){
                adShip.CheckClone__c = true;
            }
            
            // Accouted Date
            if (adShip.AccountedDate__c == null) {
                if (adShip.TypeofTrade__c == 'IMPORT') {
                    adShip.AccountedDate__c = adShip.ETA__c;
                } else if (adShip.TypeofTrade__c == 'EXPORT') {
                    adShip.AccountedDate__c = adShip.ETD__c;
                } else {
                    adShip.AccountedDate__c = Date.today();
                }
            }
            setAccountedDate.add(adShip.AccountedDate__c);
        }
        // File No
        System.debug('1234567');
        if (setAccountedDate.size() > 0) {
            String selectStr = 'SELECT MAX(NumberMonth__c),CALENDAR_MONTH(AccountedDate__c), CALENDAR_YEAR(AccountedDate__c) FROM AdvancedShipment__c ';
            String whereStr = 'WHERE ';
            String groupByStr = ' GROUP BY CALENDAR_MONTH(AccountedDate__c), CALENDAR_YEAR(AccountedDate__c) ';
            for (Date accDate : setAccountedDate) {
                whereStr += ' (CALENDAR_MONTH(AccountedDate__c) = '+ accDate.month() + ' AND CALENDAR_YEAR(AccountedDate__c) = '+ accDate.year() + ') AND';
            }
            whereStr = whereStr.removeEnd(' AND');
            List<AggregateResult> lstItem = new List<AggregateResult>();
            system.debug(selectStr + whereStr + groupByStr);
            try {
                system.debug(selectStr + whereStr + groupByStr);
                lstItem = Database.query(selectStr + whereStr + groupByStr);
            } catch (QueryException e) {
                
            }
            
            Map<String, Integer> mapCount = new Map<String, Integer>();
            for (AggregateResult item : lstItem) {
                String key = String.valueOf((Integer)item.get('expr1')) +'-' + String.valueOf((Integer)item.get('expr2'));
                Integer count = (Decimal) item.get('expr0') != null ? Integer.valueOf((Decimal) item.get('expr0')) : 0;
                mapCount.put(key,count);
            }
            for (AdvancedShipment__c adShip : lstAdShipNew) {
                if (adShip.FileNo__c == null) {
                    String key = String.valueOf(adShip.AccountedDate__c.month()) + '-' + String.valueOf(adShip.AccountedDate__c.year());
                    Integer count = 0;
                    if (mapCount.containsKey(key)) {
                        count = mapCount.get(key);
                    }
                    String typeOfTrade = '';
                    if (adShip.TypeofTrade__c == 'IMPORT') {
                        typeOfTrade = 'IM';
                    } else if (adShip.TypeofTrade__c == 'EXPORT') {
                        typeOfTrade = 'EX';
                    } else if (adShip.TypeofTrade__c == 'DOMESTIC') {
                        typeOfTrade = 'DO';
                    } else if (adShip.TypeofTrade__c == 'ENTREPOT') {
                        typeOfTrade = 'EN';
                    } else if (adShip.TypeofTrade__c == 'THIRD COUNTRY') {
                        typeOfTrade = 'TC';
                    }
                    String shipmentTerm = '';
                    if (adShip.ShipmentTerm__c == 'FCL') {
                        shipmentTerm = 'F';
                    } else if (adShip.ShipmentTerm__c == 'LCL') {
                        shipmentTerm = 'L';
                    } else if (adShip.ShipmentTerm__c == 'CONSOL') {
                        shipmentTerm = 'C';
                    } else if (adShip.ShipmentTerm__c == 'CHARTER') {
                        shipmentTerm = 'R';
                    }
                    String transWay = '';
                    if (adShip.TransportationWay__c == 'SEA') {
                        transWay = 'SEA';
                    } else if (adShip.TransportationWay__c == 'AIR') {
                        transWay = 'AIR';
                    } else if (adShip.TransportationWay__c == 'TRUCKING') {
                        transWay = 'TRU';
                    } else if (adShip.TransportationWay__c == 'RAIL') {
                        transWay = 'RAI';
                    } else if (adShip.TransportationWay__c == 'INLAND WATERWAY') {
                        transWay = 'INW';
                    }
                    count++;
                    String jobId = typeOfTrade + '-' + shipmentTerm + transWay + String.valueOf(adShip.AccountedDate__c.year()).subString(3,4) + String.valueOf(adShip.AccountedDate__c.month()).leftPad(2,'0') + String.valueOf(count).leftPad(3,'0');
                    adShip.FileNo__c = jobId;
                    adShip.NumberMonth__c = count;
                    mapCount.put(key,count);
                }
            }
         }
    }
    
    public static void isBeforeUpdate(List<AdvancedShipment__c> lstAdShipNew){
        System.debug('lstAdShipNew'+ lstAdShipNew);
        Set<Date> setAccountedDate = new Set<Date>();
        for (AdvancedShipment__c adShip : lstAdShipNew){
            // Accouted Date
            if (adShip.AccountedDate__c == null) {
                if (adShip.TypeofTrade__c == 'IMPORT') {
                    adShip.AccountedDate__c = adShip.ETA__c;
                } else if (adShip.TypeofTrade__c == 'EXPORT') {
                    adShip.AccountedDate__c = adShip.ETD__c;
                } else {
                    adShip.AccountedDate__c = Date.valueOf(adShip.CreatedDate);
                }
            }
            setAccountedDate.add(adShip.AccountedDate__c);
        }
        // File No
        if (setAccountedDate.size() > 0) {
            String selectStr = 'SELECT MAX(NumberMonth__c),CALENDAR_MONTH(AccountedDate__c), CALENDAR_YEAR(AccountedDate__c) FROM AdvancedShipment__c ';
            String whereStr = 'WHERE ';
            String groupByStr = ' GROUP BY CALENDAR_MONTH(AccountedDate__c), CALENDAR_YEAR(AccountedDate__c) ';
            for (Date accDate : setAccountedDate) {
                whereStr += ' (CALENDAR_MONTH(AccountedDate__c) = '+ accDate.month() + ' AND CALENDAR_YEAR(AccountedDate__c) = '+ accDate.year() + ') AND';
            }
            whereStr = whereStr.removeEnd(' AND');
            List<AggregateResult> lstItem = new List<AggregateResult>();
            system.debug(selectStr + whereStr + groupByStr);
            try {
                system.debug(selectStr + whereStr + groupByStr);
                lstItem = Database.query(selectStr + whereStr + groupByStr);
            } catch (QueryException e) {
                
            }
            
            Map<String, Integer> mapCount = new Map<String, Integer>();
            for (AggregateResult item : lstItem) {
                String key = String.valueOf((Integer)item.get('expr1')) +'-' + String.valueOf((Integer)item.get('expr2'));
                Integer count = (Decimal) item.get('expr0') != null ? Integer.valueOf((Decimal) item.get('expr0')) : 0;
                mapCount.put(key,count);
            }
            for (AdvancedShipment__c adShip : lstAdShipNew) {
                if (adShip.FileNo__c == null) {
                    String key = String.valueOf(adShip.AccountedDate__c.month()) + '-' + String.valueOf(adShip.AccountedDate__c.year());
                    Integer count = 0;
                    if (mapCount.containsKey(key)) {
                        count = mapCount.get(key);
                    }
                    String typeOfTrade = '';
                    if (adShip.TypeofTrade__c == 'IMPORT') {
                        typeOfTrade = 'IM';
                    } else if (adShip.TypeofTrade__c == 'EXPORT') {
                        typeOfTrade = 'EX';
                    } else if (adShip.TypeofTrade__c == 'DOMESTIC') {
                        typeOfTrade = 'DO';
                    } else if (adShip.TypeofTrade__c == 'ENTREPOT') {
                        typeOfTrade = 'EN';
                    } else if (adShip.TypeofTrade__c == 'THIRD COUNTRY') {
                        typeOfTrade = 'TC';
                    }
                    String shipmentTerm = '';
                    if (adShip.ShipmentTerm__c == 'FCL') {
                        shipmentTerm = 'F';
                    } else if (adShip.ShipmentTerm__c == 'LCL') {
                        shipmentTerm = 'L';
                    } else if (adShip.ShipmentTerm__c == 'CONSOL') {
                        shipmentTerm = 'C';
                    } else if (adShip.ShipmentTerm__c == 'CHARTER') {
                        shipmentTerm = 'R';
                    }
                    String transWay = '';
                    if (adShip.TransportationWay__c == 'SEA') {
                        transWay = 'SEA';
                    } else if (adShip.TransportationWay__c == 'AIR') {
                        transWay = 'AIR';
                    } else if (adShip.TransportationWay__c == 'TRUCKING') {
                        transWay = 'TRU';
                    } else if (adShip.TransportationWay__c == 'RAIL') {
                        transWay = 'RAI';
                    } else if (adShip.TransportationWay__c == 'INLAND WATERWAY') {
                        transWay = 'INW';
                    }
                    count++;
                    String jobId = typeOfTrade + '-' + shipmentTerm + transWay + String.valueOf(adShip.AccountedDate__c.year()).subString(3,4) + String.valueOf(adShip.AccountedDate__c.month()).leftPad(2,'0') + String.valueOf(count).leftPad(3,'0');
                    adShip.FileNo__c = jobId;
                    adShip.NumberMonth__c = count;
                    mapCount.put(key,count);
                    System.debug('jobID:' + adShip.FileNo__c);
                }
            }
         }
    }
    // @future (callout= true)
    // public static void generateAttachmentFile(String TargetObjectId){
    //     System.debug('loggg :');
    //     // String TargetObjectId = '';
    //     // for (AdvancedShipment__c adShip : lstAdShipNew){
    //     //     TargetObjectId = adShip.Id;

    //     // }
    //     // System.debug('TargetObjectId :'+TargetObjectId);
        
    //     PageReference pdf_file =Page.page_ProfitStatementForRequestV2;
    //     pdf_file.getParameters().put('Id', TargetObjectId);

    //     System.debug('shipmentID :'+TargetObjectId);
        
    //     AdvancedShipment__c item = new AdvancedShipment__c();
    //     String strSelect = 'SELECT ' + String.join(new List<String>(setFieldSO), ',');
    //     String strFrom = ' FROM AdvancedShipment__c ';
    //     String strWhere = 'WHERE Id = \'' + TargetObjectId + '\'' ;
    //     String strOrderBy = ' ORDER BY Name LIMIT 1';
    //     String data = strSelect + strFrom + strWhere + strOrderBy;
    //     item = Database.query(data);
    //     String namefile =item.Name +'_ProfitStatementRequest_' ;

       
    //     String attachName = namefile ;
    //     String attachNameSearch = attachName + '%';
    //     // get exist file Name
    //     List<Attachment> attachments = [SELECT Id, Name, ParentId 
    //                                     FROM Attachment 
    //                                     WHERE ParentId =: TargetObjectId 
    //                                     AND Name LIKE : attachNameSearch 
    //                                     ORDER BY CreatedDate DESC LIMIT 1];
                                        
    //     if(attachments.isEmpty()){
    //         attachName += '1.1';
    //     }else{
    //         String attachNameExist = attachments[0].Name;
    //         attachNameExist = attachNameExist.substringAfter(attachName);
    //         attachNameExist = attachNameExist.substringBefore('.pdf');
    //         Decimal versionNumber = Decimal.valueOf(attachNameExist);
    //         versionNumber += 0.1;
    //         attachName += String.valueOf(versionNumber);
    //     }
    //     // if(requiredAttachmentCreation != false){
    //         Attachment attach = new Attachment();
    //         Blob body;
    //         attach.Name = attachName + '.pdf'; 
    //         attach.IsPrivate = false;
    //         attach.ParentId = TargetObjectId;
    //         if(!Test.isRunningTest()){
    //         body = pdf_file.getContentAsPDF();
    //         System.debug('debuggg Thong :'+body);
    //         attach.Body = body;
    //         FlsService.doInsert(attach);
    //     }
    //     // }
        
        
    // }
}