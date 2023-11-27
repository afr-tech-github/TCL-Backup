public class CNTRClass {
    
    public static String convertToPlural(String input) {
        List<String> pluralWords = new List<String>();
        String[] words = input.split(';');
        for (String word : words) {
            if( word.contains(',')){
                List<String> tmpList = new List<String>();
                String[] wordsItems = word.split(','); 
                for (String wordItem : wordsItems) {
                    String tmp = convertWordToPlural(wordItem.trim());
                    tmpList.add(tmp);
                }
                 String resultTmp = '';

                for (Integer i = 0; i < tmpList.size(); i++) {
                    resultTmp += tmpList[i].trim();
                    if( i< tmpList.size()-1){

                        resultTmp +=  ', ';
                    }
                   
            
                }
                pluralWords.add(resultTmp);

            }
            else{
                String pluralWord = convertWordToPlural(word.trim());
                pluralWords.add(pluralWord);
            }
        }
        
        String result = '';
        for (Integer i = 0; i < pluralWords.size(); i++) {
            if (i > 0) {
                result += '; ';
            }
            result += pluralWords[i];
        }
        
        return result;
    }
    
    private static boolean checkChar(String c) {
        System.debug('debuggg List value :'+ c);
 
        return c == 'A' || c == 'E' || c == 'I' || c == 'O' || c == 'U';
    }

    public static String convertWordToPlural(String word) {
        if (word == null || word.length() == 0 ||word.endsWith('ED')){
            return word;
        }
        
        if (word.endsWith('Y') && !checkChar(word.substring(word.length()-1))) {
            return word.substring(0, word.length() - 1) + 'IES';
        } else if (word.endsWith('S') || word.endsWith('CH') || word.endsWith('SH') || word.endsWith('X') || word.endsWith('Z')) {
            return word + 'ES';
        } 
        else {
            return word + 'S';
        } 
    }

    public static void readContainerandCargoesInsertandUpdate(List<CntrinTrans__c> listCNTRNew) {
        Set<Id> lstIdSO = new Set<Id>();
        for (CntrinTrans__c cont : listCNTRNew) {
            if (!lstIdSO.contains(cont.F_TMS_S_O__c)){
                lstIdSO.add(cont.F_TMS_S_O__c);
            }
        }
        if (lstIdSO.size()>0) {
            Map<String,String> mapSOReadContainer = new Map<String,String>();
            // Map<String,String> mapSOReadCargoes = new Map<String,String>();
            // List<FTMSSO__c> lstSO= [SELECT Id, Name, HBLType__c, ReadContainers__c, ReadCargoes__c FROM FTMSSO__c WHERE Id in: lstIdSO];
            // for (FTMSSO__c so : lstSO) {
            //     mapSOReadContainer.put(so,new List<CntrinTrans__c>());
            // }
            List<CntrinTrans__c> lstCNTR = [SELECT Id, Name, F_TMS_S_O__c, F_TMS_S_O__r.Shipment_Type__c, Container_Number__c, Container_Type__c, Seal_Number__c, Container_Quantity__c, Cargo_Quantity__c, Gross_Weight_Kg__c, Measurement_CBM__c, Cargo_Unit__c FROM CntrinTrans__c WHERE F_TMS_S_O__c IN: lstIdSO];
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
            
            Map<String,Decimal> mapConType = new Map<String,Decimal>();
            Map<String,List<Decimal>> mapIdSoContQuantity = new Map<String,List<Decimal>>();
            Map<String,List<String>> mapIdSoContType = new Map<String,List<String>>();
            List<WrapperCon> lstWrapper = new List<WrapperCon>();
            Set<String> setIdSoContype = new Set<String>();

            for (CntrinTrans__c cont : lstCNTR) {
                WrapperCon item = new WrapperCon();
                item.idSO = cont.F_TMS_S_O__c;
                item.contype = cont.Container_Type__c;
                Decimal quantityCont = cont.Container_Quantity__c != null? cont.Container_Quantity__c : 0;
                if (!mapConType.containsKey(item.idSO+'-'+item.contype)) {
                    mapConType.put(item.idSO+'-'+item.contype,quantityCont);
                    lstWrapper.add(item);
                } else {
                    Decimal quantity = mapConType.get(item.idSO+'-'+item.contype) + quantityCont;
                    mapConType.put(item.idSO+'-'+item.contype,quantity);
                }
            }
            for (WrapperCon item : lstWrapper) {
                List<Decimal> lstQuantity = mapIdSoContQuantity.get(item.idSO);
                List<String> lstContType = mapIdSoContType.get(item.idSO);
                if (!mapIdSoContQuantity.containsKey(item.idSO)){
                    lstQuantity = new List<Decimal>();
                    lstQuantity.add(mapConType.get(item.idSO+'-'+item.contype));
                    mapIdSoContQuantity.put(item.idSO,lstQuantity);
                    lstContType = new List<String>();
                    lstContType.add(item.contype);
                    mapIdSoContType.put(item.idSO,lstContType);
                } else {
                    lstQuantity.add(mapConType.get(item.idSO+'-'+item.contype));
                    lstContType.add(item.contype);
                    mapIdSoContQuantity.put(item.idSO,lstQuantity);
                    mapIdSoContType.put(item.idSO,lstContType);
                }
            }
            System.debug('mapConType: '+ mapConType);
            System.debug('mapIdSoContQuantity: '+ mapIdSoContQuantity);
            System.debug('mapIdSoContType: '+ mapIdSoContType);


            // Update Shipment
            List<FTMSSO__c> lstSO= [SELECT Id, Name, HBLType__c, ReadContainers__c, ReadCargoes__c, Shipment_Type__c, CargoType__c, CargoQuantity__c,CargoUnit__c FROM FTMSSO__c WHERE Id in: lstIdSO];
            for (FTMSSO__c ship : lstSO){
                String readContainer = '';
                Integer count = 0;
                for (Decimal value : mapIdSoContQuantity.get(ship.Id)) {
                    if (count != 0) {
                        if (value > 0 && value <10) {
                            readContainer += ' AND ' + ReadNumberToWords.convert(value.setScale(2, System.RoundingMode.HALF_UP)) + ' ('+'0'  + value + ')X' + mapIdSoContType.get(ship.Id).get(count);
                        } else {
                            readContainer += ' AND ' + ReadNumberToWords.convert(value.setScale(2, System.RoundingMode.HALF_UP)) + ' (' + value + ')X' + mapIdSoContType.get(ship.Id).get(count);
                        }
                    } else {
                        if (value > 0 && value <10) {
                            readContainer += ReadNumberToWords.convert(value.setScale(2, System.RoundingMode.HALF_UP)) + ' ('+'0'  + value + ')X' + mapIdSoContType.get(ship.Id).get(count);
                        } else {
                            readContainer += ReadNumberToWords.convert(value.setScale(2, System.RoundingMode.HALF_UP)) + ' (' + value + ')X' + mapIdSoContType.get(ship.Id).get(count);
                        }
                    }
                    count ++;
                }
                if (ship.Shipment_Type__c == 'FCL') {
                    ship.ReadContainers__c = readContainer + ' CONTAINER(S)'; 
                    ship.ReadCargoes__c = readContainer + ' CONTAINER(S) ONLY';
                } else {
                    Decimal shipQuantity = ship.CargoQuantity__c != null? ship.CargoQuantity__c : 0;
                    ship.ReadContainers__c = 'A PART OF ' + readContainer + ' CONTAINER(S)';
                    ship.ReadCargoes__c = ReadNumberToWords.convert(shipQuantity.setScale(2, System.RoundingMode.HALF_UP)) + ' (' + shipQuantity + ') ' + ship.CargoUnit__c + '(S) ONLY';
                }
            }

            // // Update Shipment
            // List<FTMSSO__c> lstSO= [SELECT Id, Name, HBLType__c, ReadContainers__c, ReadCargoes__c, Shipment_Type__c, CargoType__c, CargoQuantity__c,CargoUnit__c FROM FTMSSO__c WHERE Id in: lstIdSO];
            // for (FTMSSO__c ship : lstSO){
            //     Decimal shipQuantity = ship.CargoQuantity__c != null? ship.CargoQuantity__c : 0;
            //     if (ship.Shipment_Type__c == 'FCL') {
            //         ship.ReadContainers__c = mapSOReadContainer.get(ship.Id); 
            //         ship.ReadCargoes__c = 'SAY '+ mapSOReadContainer.get(ship.Id) + ' ONLY';
            //     } else {
            //         ship.ReadContainers__c = 'A PART OF ' + mapSOReadContainer.get(ship.Id);
            //         ship.ReadCargoes__c = 'SAY '+ ReadNumberToWords.convert(shipQuantity.setScale(2, System.RoundingMode.HALF_UP)) + ' (' + shipQuantity + ')X' + ship.CargoUnit__c + ' ONLY';
            //     }
            // }
            update lstSO;
        }
    }

    public static void readContainerandCargoesDelete(List<CntrinTrans__c> listCNTROld) {
        Set<Id> lstIdSO = new Set<Id>();
        Set<Id> lstIdCNTROld = new Set<Id>();
        for (CntrinTrans__c cont : listCNTROld) {
            if (!lstIdSO.contains(cont.F_TMS_S_O__c)){
                lstIdSO.add(cont.F_TMS_S_O__c);
            }
            lstIdCNTROld.add(cont.Id);
        }
        if (lstIdSO.size()>0) {
            Map<String,String> mapSOReadContainer = new Map<String,String>();
            // Map<String,String> mapSOReadCargoes = new Map<String,String>();
            // List<FTMSSO__c> lstSO= [SELECT Id, Name, HBLType__c, ReadContainers__c, ReadCargoes__c FROM FTMSSO__c WHERE Id in: lstIdSO];
            // for (FTMSSO__c so : lstSO) {
            //     mapSOReadContainer.put(so,new List<CntrinTrans__c>());
            // }
            List<CntrinTrans__c> lstCNTR = [SELECT Id, Name, F_TMS_S_O__c, F_TMS_S_O__r.Shipment_Type__c, Container_Number__c, Container_Type__c, Seal_Number__c, Container_Quantity__c, Cargo_Quantity__c, Gross_Weight_Kg__c, Measurement_CBM__c, Cargo_Unit__c FROM CntrinTrans__c WHERE F_TMS_S_O__c IN: lstIdSO AND Id NOT IN: lstIdCNTROld];
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

            // // Update Shipment
            // List<FTMSSO__c> lstSO= [SELECT Id, Name, HBLType__c, ReadContainers__c, ReadCargoes__c, Shipment_Type__c, CargoType__c, CargoQuantity__c FROM FTMSSO__c WHERE Id in: lstIdSO];
            // for (FTMSSO__c ship : lstSO){
            //     Decimal shipQuantity = ship.CargoQuantity__c != null? ship.CargoQuantity__c : 0;
            //     if (ship.Shipment_Type__c == 'FCL') {
            //         ship.ReadContainers__c = mapSOReadContainer.get(ship.Id); 
            //         ship.ReadCargoes__c = 'SAY '+ mapSOReadContainer.get(ship.Id) + ' ONLY';
            //     } else {
            //         ship.ReadContainers__c = 'A PART OF' + mapSOReadContainer.get(ship.Id);
            //         ship.ReadCargoes__c = 'SAY '+ ReadNumberToWords.convert(shipQuantity.setScale(2, System.RoundingMode.HALF_UP)) + ' (' + shipQuantity + ')X' + ship.CargoType__c + ' ONLY';
            //     }
            // }

            Map<String,Decimal> mapConType = new Map<String,Decimal>();
            Map<String,List<Decimal>> mapIdSoContQuantity = new Map<String,List<Decimal>>();
            Map<String,List<String>> mapIdSoContType = new Map<String,List<String>>();
            List<WrapperCon> lstWrapper = new List<WrapperCon>();
            Set<String> setIdSoContype = new Set<String>();
            
            for (CntrinTrans__c cont : lstCNTR) {
                WrapperCon item = new WrapperCon();
                item.idSO = cont.F_TMS_S_O__c;
                item.contype = cont.Container_Type__c;
                Decimal quantityCont = cont.Container_Quantity__c != null? cont.Container_Quantity__c : 0;

                if (!mapConType.containsKey(item.idSO+'-'+item.contype)) {
                    mapConType.put(item.idSO+'-'+item.contype,quantityCont);
                    lstWrapper.add(item);
                } else {
                    Decimal quantity = mapConType.get(item.idSO+'-'+item.contype) + quantityCont;
                    mapConType.put(item.idSO+'-'+item.contype,quantity);
                }
            }
            for (WrapperCon item : lstWrapper) {
                List<Decimal> lstQuantity = mapIdSoContQuantity.get(item.idSO);
                List<String> lstContType = mapIdSoContType.get(item.idSO);
                if (!mapIdSoContQuantity.containsKey(item.idSO)){
                    lstQuantity = new List<Decimal>();
                    lstQuantity.add(mapConType.get(item.idSO+'-'+item.contype));
                    mapIdSoContQuantity.put(item.idSO,lstQuantity);
                    lstContType = new List<String>();
                    lstContType.add(item.contype);
                    mapIdSoContType.put(item.idSO,lstContType);
                } else {
                    lstQuantity.add(mapConType.get(item.idSO+'-'+item.contype));
                    lstContType.add(item.contype);
                    mapIdSoContQuantity.put(item.idSO,lstQuantity);
                    mapIdSoContType.put(item.idSO,lstContType);
                }
            }
            System.debug('mapConType: '+ mapConType);
            System.debug('mapIdSoContQuantity: '+ mapIdSoContQuantity);
            System.debug('mapIdSoContType: '+ mapIdSoContType);

            // Update Shipment
            List<FTMSSO__c> lstSO= [SELECT Id, Name, HBLType__c, ReadContainers__c, ReadCargoes__c, Shipment_Type__c, CargoType__c, CargoQuantity__c,CargoUnit__c FROM FTMSSO__c WHERE Id in: lstIdSO];
            for (FTMSSO__c ship : lstSO){
                String readContainer = '';
                Integer count = 0;
                for (Decimal value : mapIdSoContQuantity.get(ship.Id)) {
                    if (count != 0) {
                        if (value > 0 && value <10) {
                            readContainer += ' AND ' + ReadNumberToWords.convert(value.setScale(2, System.RoundingMode.HALF_UP)) + ' ('+'0'  + value + ')X' + mapIdSoContType.get(ship.Id).get(count);
                        } else {
                            readContainer += ' AND ' + ReadNumberToWords.convert(value.setScale(2, System.RoundingMode.HALF_UP)) + ' (' + value + ')X' + mapIdSoContType.get(ship.Id).get(count);
                        }
                    } else {
                        if (value > 0 && value <10) {
                            readContainer += ReadNumberToWords.convert(value.setScale(2, System.RoundingMode.HALF_UP)) + ' ('+'0'  + value + ')X' + mapIdSoContType.get(ship.Id).get(count);
                        } else {
                            readContainer += ReadNumberToWords.convert(value.setScale(2, System.RoundingMode.HALF_UP)) + ' (' + value + ')X' + mapIdSoContType.get(ship.Id).get(count);
                        }
                    }
                }
                if (ship.Shipment_Type__c == 'FCL') {
                    ship.ReadContainers__c = readContainer; 
                    ship.ReadCargoes__c = 'SAY '+ readContainer + ' ONLY';
                } else {
                    Decimal shipQuantity = ship.CargoQuantity__c != null? ship.CargoQuantity__c : 0;
                    ship.ReadContainers__c = 'A PART OF ' + readContainer;
                    ship.ReadCargoes__c = 'SAY '+ ReadNumberToWords.convert(shipQuantity.setScale(2, System.RoundingMode.HALF_UP)) + ' (' + shipQuantity + ')X' + ship.CargoUnit__c + ' ONLY';
                }
            }
            update lstSO;
        }
    }
    public class WrapperCon {
        public String contype {get; set;}
        public String idSO {get; set;}
        public WrapperCon() {
            contype = '';
            idSO = '';
        } 
    }
}