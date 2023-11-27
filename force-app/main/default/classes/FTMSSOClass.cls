//public class FTMSSOClass {
public without sharing class FTMSSOClass {
    private static Map<String, Id> mapRecordTypes = retrieveRecordTypeIdsByNames();
    private static Integer year = Date.today().year();
    private static Integer month = Date.today().month();
    private static String polPordCode = '';
    private static String podPordCode = '';
    private static String lastNumerOfYearStr = String.valueof(year).right(1);
    private static String monthStr = String.valueof(month).leftPad(2, '0');
    private static Datetime firstDayOfMonth = Datetime.newInstanceGmt(year, month, 1);
    private static Datetime firstDayOfNextMonth = firstDayOfMonth.addMonths(1);
    public static void isBeforeInsert(List<FTMSSO__c> lstSONew){
        System.debug('ThongDebug :'+lstSONew.size());
        Integer numberFTSSO = 0;
        List<AggregateResult> lstNumber = getMaxFTMSSOInMonth(firstDayOfMonth, firstDayOfNextMonth);
        if(lstNumber[0].get('expr0') != null) {
            numberFTSSO = Integer.valueOf(lstNumber[0].get('expr0'));
        }
       
        List<String> portCodeLst = new List<String>();
        for (FTMSSO__c ship : lstSONew){
            if (ship.TypeofTrade__c == 'Export') {
                if (ship.TransportationWay__c == 'SEA' || ship.TransportationWay__c == 'AIR') {
                    if(ship.POLAOD__c != null) {
                        portCodeLst.add(ship.POLAOD__c);
                    }
                    if(ship.PODAOA__c != null) {
                        portCodeLst.add(ship.PODAOA__c);
                    }
                }
            }
        }
        Map<ID, PortCode__c> mapPortCode = new Map<ID, PortCode__c>();
        if(!portCodeLst.isEmpty()) {
            mapPortCode = getPortCode(portCodeLst);
        }
        // accouted date and file no
        List<String> lstIdAdShip = new List<String>();
        for (FTMSSO__c ship : lstSONew) {
            lstIdAdShip.add(ship.ConsolidationID__c);
        }
        List<AdvancedShipment__c> lstAdShip = [SELECT Id, Name, AccountedDate__c, FileNo__c FROM AdvancedShipment__c WHERE Id IN: lstIdAdShip];
        Map<String, AdvancedShipment__c> mapIdAdShip = new Map<String, AdvancedShipment__c>();
        for (AdvancedShipment__c item : lstAdShip){
            mapIdAdShip.put(item.Id, item);
        }
        for (FTMSSO__c ship : lstSONew){
            if (ship.AccountedDate__c == null || ship.isClone()) {
            	ship.AccountedDate__c = mapIdAdShip.get(ship.ConsolidationID__c).AccountedDate__c;
            }
            if (ship.JobRequestID__c == null || ship.isClone()) {
            	ship.JobRequestID__c = mapIdAdShip.get(ship.ConsolidationID__c).FileNo__c;
            }
            if (ship.isClone()){
                ship.CheckClone__c = true;
            }

            if (ship.TypeofTrade__c == 'Export') {
                String numberFTSSOStr = String.valueOf(numberFTSSO + 1);
                if (ship.TransportationWay__c == 'SEA') {
                    if(ship.POLAOD__c != null) {
                        polPordCode = mapPortCode.get(ship.POLAOD__c).Standard_Port_Code__c.right(3);
                    }
                    if(ship.PODAOA__c != null) {
                        podPordCode =  mapPortCode.get(ship.PODAOA__c).Standard_Port_Code__c.right(3);
                    }
                    ship.HBLNumber__c = polPordCode + podPordCode + lastNumerOfYearStr + monthStr + numberFTSSOStr.leftPad(3,'0');
                    ship.HBLNumber__c = checkMaxLength(ship.HBLNumber__c);
                }

                if (ship.TransportationWay__c == 'AIR') {
                    if(ship.PODAOA__c != null) {
                        podPordCode =  mapPortCode.get(ship.PODAOA__c).Standard_Port_Code__c.right(3);
                    }
                    ship.HAWBNumber__c = 'TCL' + lastNumerOfYearStr + monthStr + numberFTSSOStr.leftPad(3,'0') + podPordCode;
                    ship.HAWBNumber__c = checkMaxLength(ship.HAWBNumber__c);
                }
                numberFTSSO++;
                ship.Number__c = numberFTSSO;
                System.debug('ThongcheckNumber :'+ship.Number__c);
            }
        }
    }
    public static void isBeforeUpdate(List<FTMSSO__c> lstSONew, Map<Id,FTMSSO__c> mapSOOld){
        System.debug('ThongDebug2 :'+lstSONew.size());
        Integer numberFTSSO = 0;
        System.debug('firstDayOfMonth :'+firstDayOfMonth);
        System.debug('firstDayOfNextMonth :'+firstDayOfNextMonth);
        List<AggregateResult> lstNumber = getMaxFTMSSOInMonth(firstDayOfMonth, firstDayOfNextMonth);
        System.debug('ThongDebuglstNumber :'+lstNumber.size());
        if(lstNumber[0].get('expr0') != null) {
            numberFTSSO = Integer.valueOf(lstNumber[0].get('expr0'));
        }
       
        //Map<ID, PortCode__c> mapPortCode = getPortCode();
        List<String> portCodeLst = new List<String>();
        for (FTMSSO__c ship : lstSONew){
            if (ship.TypeofTrade__c == 'Export') {
                if (ship.TransportationWay__c == 'SEA' || ship.TransportationWay__c == 'AIR') {
                    if(ship.POLAOD__c != null) {
                        portCodeLst.add(ship.POLAOD__c);
                    }
                    if(ship.PODAOA__c != null) {
                        portCodeLst.add(ship.PODAOA__c);
                    }
                }
            }
        }

        Map<ID, PortCode__c> mapPortCode = new Map<ID, PortCode__c>();
        if(!portCodeLst.isEmpty()) {
            mapPortCode = getPortCode(portCodeLst);
        }
        Map<String, Id> mapRecordTypes = retrieveRecordTypeIdsByNames();
        // accouted date and file no
        List<String> lstIdAdShip = new List<String>();
        for (FTMSSO__c ship : lstSONew) {
            lstIdAdShip.add(ship.ConsolidationID__c);
        }
        System.debug('lstIdAdShip :'+lstIdAdShip);
        List<AdvancedShipment__c> lstAdShip = [SELECT Id, Name, AccountedDate__c, FileNo__c FROM AdvancedShipment__c WHERE Id IN: lstIdAdShip];
        System.debug('lstAdShip :'+lstAdShip.size());
        Map<String, AdvancedShipment__c> mapIdAdShip = new Map<String, AdvancedShipment__c>();
        for (AdvancedShipment__c item : lstAdShip){
            mapIdAdShip.put(item.Id, item);
        }
        for (FTMSSO__c ship : lstSONew){
            if (ship.AccountedDate__c == null) {
            	ship.AccountedDate__c = mapIdAdShip.get(ship.ConsolidationID__c).AccountedDate__c;
            }
            if (ship.JobRequestID__c == null) {
            	ship.JobRequestID__c = mapIdAdShip.get(ship.ConsolidationID__c).FileNo__c;
            }
            if ((ship.Shipment_Type__c != mapSOOld.get(ship.Id).Shipment_Type__c) || (ship.Shipment_Type__c != 'FCL' && (ship.CargoQuantity__c != mapSOOld.get(ship.Id).CargoQuantity__c || ship.CargoUnit__c != mapSOOld.get(ship.Id).CargoUnit__c))) {
                Map<String,String> mapSOReadContainer = new Map<String,String>();
                Map<String,Decimal> mapContTypeandQuantity = new Map<String,Decimal>();
                List<CntrinTrans__c> lstCNTR = [SELECT Id, Name, F_TMS_S_O__c, F_TMS_S_O__r.Shipment_Type__c, Container_Number__c, Container_Type__c, Seal_Number__c, Container_Quantity__c, Cargo_Quantity__c, Gross_Weight_Kg__c, Measurement_CBM__c, Cargo_Unit__c FROM CntrinTrans__c WHERE F_TMS_S_O__c =: ship.Id];
                for (CntrinTrans__c cont : lstCNTR) {
                    if (!mapContTypeandQuantity.containsKey(cont.Container_Type__c)) {
                        Decimal contQuantity = cont.Container_Quantity__c != null? cont.Container_Quantity__c : 0;
                        mapContTypeandQuantity.put(cont.Container_Type__c,contQuantity);
                    } else {
                        Decimal contQuantity = cont.Container_Quantity__c != null? cont.Container_Quantity__c : 0;
                        Decimal contQuan = mapContTypeandQuantity.get(cont.Container_Type__c) + contQuantity;
                        mapContTypeandQuantity.put(cont.Container_Type__c, contQuan);
                    }
                }
                String readCont = '';
                Integer count = 0;
                for (String key : mapContTypeandQuantity.keySet()) {
                    Decimal contQuantity = mapContTypeandQuantity.get(key);
                    if (count ==0) {
                        if (contQuantity > 0 && contQuantity <10) {
                            readCont += ReadNumberToWords.convert(contQuantity.setScale(2, System.RoundingMode.HALF_UP)) + ' ('+'0'  + contQuantity + ')X' + key;
                        } else {
                            readCont += ReadNumberToWords.convert(contQuantity.setScale(2, System.RoundingMode.HALF_UP)) + ' (' + contQuantity + ')X' + key;
                        }
                    } else {
                        if (contQuantity > 0 && contQuantity <10) {
                            readCont += ' AND ' +  ReadNumberToWords.convert(contQuantity.setScale(2, System.RoundingMode.HALF_UP)) + ' ('+'0'  + contQuantity + ')X' + key;
                        } else {
                            readCont += ' AND ' +  ReadNumberToWords.convert(contQuantity.setScale(2, System.RoundingMode.HALF_UP)) + ' (' + contQuantity + ')X' + key;
                        }
                    }
                    count++;
                }
                // for (CntrinTrans__c cont : lstCNTR) {
                //     Decimal contQuantity = cont.Container_Quantity__c != null? cont.Container_Quantity__c : 0;
                //     if (!mapSOReadContainer.containsKey(cont.F_TMS_S_O__c)) {
                //         String readCont = '';
                //         if (contQuantity > 0 && contQuantity <10) {
                //             readCont = ReadNumberToWords.convert(contQuantity.setScale(2, System.RoundingMode.HALF_UP)) + ' ('+'0'  + contQuantity + ')X' + cont.Container_Type__c;
                //         } else {
                //             readCont = ReadNumberToWords.convert(contQuantity.setScale(2, System.RoundingMode.HALF_UP)) + ' (' + contQuantity + ')X' + cont.Container_Type__c;
                //         }
                //         mapSOReadContainer.put(cont.F_TMS_S_O__c,readCont);
                //     } else {
                //         String readCont = mapSOReadContainer.get(cont.F_TMS_S_O__c);
                //         if (contQuantity > 0 && contQuantity <10) {
                //             readCont += ' AND ' + ReadNumberToWords.convert(contQuantity.setScale(2, System.RoundingMode.HALF_UP)) + ' ('+'0'  + contQuantity + ')X' + cont.Container_Type__c;
                //         } else {
                //             readCont += ' AND ' + ReadNumberToWords.convert(contQuantity.setScale(2, System.RoundingMode.HALF_UP)) + ' (' + contQuantity + ')X' + cont.Container_Type__c;
                //         }
                //         mapSOReadContainer.put(cont.F_TMS_S_O__c,readCont);
                //     }
                // }

                if (ship.Shipment_Type__c == 'FCL') {
                    ship.ReadContainers__c = readCont + ' CONTAINER(S)'; 
                    ship.ReadCargoes__c = readCont + ' CONTAINER(S) ONLY';
                } else {
                    Decimal shipQuantity = ship.CargoQuantity__c != null? ship.CargoQuantity__c : 0;
                    ship.ReadContainers__c = 'A PART OF ' + readCont + ' CONTAINER(S)';
                    ship.ReadCargoes__c = ReadNumberToWords.convert(shipQuantity.setScale(2, System.RoundingMode.HALF_UP)) + ' (' + shipQuantity + ') ' + ship.CargoUnit__c + '(S) ONLY';
                }
            }
            // Change HBL When ETD is updated
            if (ship.ETD__c != mapSOOld.get(ship.Id).ETD__c) {
                if (ship.TypeofTrade__c == 'Export') {
                    String numberFTSSOStr = String.valueOf(numberFTSSO + 1);
                    if (ship.TransportationWay__c == 'SEA') {
                        if(ship.POLAOD__c != null) {
                            polPordCode = mapPortCode.get(ship.POLAOD__c).Standard_Port_Code__c.right(3);
                        }
                        if(ship.PODAOA__c != null) {
                            podPordCode =  mapPortCode.get(ship.PODAOA__c).Standard_Port_Code__c.right(3);
                        }
                        ship.HBLNumber__c = polPordCode + podPordCode + lastNumerOfYearStr + monthStr + numberFTSSOStr.leftPad(3,'0');
                        ship.HBLNumber__c = checkMaxLength(ship.HBLNumber__c);
                    }
    
                    if (ship.TransportationWay__c == 'AIR') {
                        if(ship.PODAOA__c != null) {
                            podPordCode =  mapPortCode.get(ship.PODAOA__c).Standard_Port_Code__c.right(3);
                        }
                        ship.HAWBNumber__c = 'TCL' + lastNumerOfYearStr + monthStr + numberFTSSOStr.leftPad(3,'0') + podPordCode;
                        ship.HAWBNumber__c = checkMaxLength(ship.HAWBNumber__c);
                    }
                    numberFTSSO++;
                    ship.Number__c = numberFTSSO;
                }
            }
        }
    }
    
    private static Map<String, Id> retrieveRecordTypeIdsByNames() {
        String objectName = 'FTMSSO__c';
        Map<String, Id> mapRecordTypes = new Map<String, Id>();
        List<RecordType> recordTypes = [
                SELECT DeveloperName, Id
                FROM RecordType
                WHERE SObjectType = :objectName AND IsActive = True
        ];
        for (RecordType rt : recordTypes) {
            mapRecordTypes.put(rt.DeveloperName, rt.Id);
        }
        return mapRecordTypes;
    }
    private static List<AggregateResult> getMaxFTMSSOInMonth(Datetime firstDayOfMonth, Datetime firstDayOfNextMonth) {
        List<AggregateResult> lstNumber = new List<AggregateResult>();
        lstNumber = [SELECT MAX(Number__c) FROM FTMSSO__c WHERE Createddate >= :firstDayOfMonth AND Createddate < :firstDayOfNextMonth];
        System.debug('lstNumber :'+lstNumber.size());
        return lstNumber;
    }

    private static Map<ID, PortCode__c> getPortCode(List<String> portCodeLst) {
        Map<ID, PortCode__c> mapPortCode = new Map<ID, PortCode__c>([SELECT Id, Standard_Port_Code__c FROM PortCode__c WHERE Id In :portCodeLst]);
        System.debug('mapPortCode' + mapPortCode);
        return mapPortCode;
    }
    private static String checkMaxLength(String tmpStr) {
        if(tmpStr.length() > 12) {
           tmpStr = tmpStr.left(12);
        }
        return tmpStr;
    }
}