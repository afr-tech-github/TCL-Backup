public with sharing class InquiryController{
    @AuraEnabled
    public static String getFieldLabels(){
        try{
            Map<String, String> fieldLabels = new Map<String, String>();

         
            fieldLabels.put('ContainerQuantity1__c', SObjectType.Quote__c.fields.ContainerQuantity1__c.getLabel());
            fieldLabels.put('ContainerQuantity2__c', SObjectType.Quote__c.fields.ContainerQuantity2__c.getLabel());
            fieldLabels.put('ContainerQuantity3__c', SObjectType.Quote__c.fields.ContainerQuantity3__c.getLabel());
            fieldLabels.put('ContainerType1__c', SObjectType.Quote__c.fields.ContainerType1__c.getLabel());
            fieldLabels.put('ContainerType2__c', SObjectType.Quote__c.fields.ContainerType2__c.getLabel());
           
            fieldLabels.put('ContainerType3__c', SObjectType.Quote__c.fields.ContainerType3__c.getLabel());
            fieldLabels.put('Currency__c', SObjectType.Quote__c.fields.Currency__c.getLabel());
            fieldLabels.put('Remarks__c', SObjectType.Quote__c.fields.Remarks__c.getLabel());
            
            
            fieldLabels.put('DeliveryAddress__c', SObjectType.Quote__c.fields.DeliveryAddress__c.getLabel());
            fieldLabels.put('PickupAddress__c', SObjectType.Quote__c.fields.PickupAddress__c.getLabel());
            fieldLabels.put('RequesterCompany__c', SObjectType.Quote__c.fields.RequesterCompany__c.getLabel());
            fieldLabels.put('Requested__c', SObjectType.InquiryLine__c.fields.Requested__c.getLabel());
            fieldLabels.put('RequestCompanysPIC__c', SObjectType.Quote__c.fields.RequestCompanysPIC__c.getLabel());
            fieldLabels.put('QuotePIC__c', SObjectType.Quote__c.fields.QuotePIC__c.getLabel());
            fieldLabels.put('InquiryID__c', SObjectType.Quote__c.fields.InquiryID__c.getLabel());
            fieldLabels.put('TypeofTrade__c', SObjectType.Quote__c.fields.TypeofTrade__c.getLabel());
            fieldLabels.put('ShipmentTerm__c', SObjectType.Quote__c.fields.ShipmentTerm__c.getLabel());
            fieldLabels.put('TransportationWay__c', SObjectType.Quote__c.fields.TransportationWay__c.getLabel());
            fieldLabels.put('Commodity1__c', SObjectType.Quote__c.fields.Commodity1__c.getLabel());
            fieldLabels.put('DescriptionofGoods__c', SObjectType.Quote__c.fields.DescriptionofGoods__c.getLabel());
            fieldLabels.put('TypeOfCargo1__c', SObjectType.Quote__c.fields.TypeOfCargo1__c.getLabel());
            fieldLabels.put('INCOTERMS__c', SObjectType.Quote__c.fields.INCOTERMS__c.getLabel());
            fieldLabels.put('GrossWeight__c', SObjectType.Quote__c.fields.GrossWeight__c.getLabel());
            fieldLabels.put('NetWeight__c', SObjectType.Quote__c.fields.NetWeight__c.getLabel());
            fieldLabels.put('MeasurementTotalCBM__c', SObjectType.Quote__c.fields.MeasurementTotalCBM__c.getLabel());
            fieldLabels.put('Volume__c', SObjectType.Quote__c.fields.Volume__c.getLabel());
            fieldLabels.put('DIM_Dimension__c', SObjectType.Quote__c.fields.DIM_Dimension__c.getLabel());
            fieldLabels.put('ETD__c', SObjectType.Quote__c.fields.ETD__c.getLabel());
            fieldLabels.put('ETA__c', SObjectType.Quote__c.fields.ETA__c.getLabel());
            fieldLabels.put('QuoteName__c', SObjectType.Quote__c.fields.QuoteName__c.getLabel());
            fieldLabels.put('QuoteIssueDate__c', SObjectType.Quote__c.fields.QuoteIssueDate__c.getLabel());
            fieldLabels.put('Validto__c', SObjectType.Quote__c.fields.Validto__c.getLabel());
            fieldLabels.put('ExternalSalesman__c', SObjectType.Quote__c.fields.ExternalSalesman__c.getLabel());
            fieldLabels.put('Additional_Contract_Date__c', SObjectType.Quote__c.fields.Additional_Contract_Date__c.getLabel());
            fieldLabels.put('Contract_ID__c', SObjectType.Quote__c.fields.Contract_ID__c.getLabel());
            fieldLabels.put('Currency__c', SObjectType.Quote__c.fields.Currency__c.getLabel());
            fieldLabels.put('RequestDetail__c', SObjectType.Quote__c.fields.RequestDetail__c.getLabel());
            fieldLabels.put('Cargo_Quantity__c', SObjectType.Quote__c.fields.Cargo_Quantity__c.getLabel());

            fieldLabels.put('RouteName__c', SObjectType.InquiryRoute__c.fields.RouteName__c.getLabel());
            fieldLabels.put('OriginCountry__c', SObjectType.InquiryRoute__c.fields.OriginCountry__c.getLabel());
            fieldLabels.put('DestinationCountry__c', SObjectType.InquiryRoute__c.fields.DestinationCountry__c.getLabel());
            fieldLabels.put('POLAOL__c', SObjectType.InquiryRoute__c.fields.POLAOL__c.getLabel());
            fieldLabels.put('PODAOD__c', SObjectType.InquiryRoute__c.fields.PODAOD__c.getLabel());

            fieldLabels.put('Name', SObjectType.InquiryLine__c.fields.Name.getLabel());
            fieldLabels.put('Service__c', SObjectType.InquiryLine__c.fields.Service__c.getLabel());
            fieldLabels.put('ServiceType__c', SObjectType.InquiryLine__c.fields.ServiceType__c.getLabel());
            fieldLabels.put('StartTime__c', SObjectType.InquiryLine__c.fields.StartTime__c.getLabel());
            fieldLabels.put('EndTime__c', SObjectType.InquiryLine__c.fields.EndTime__c.getLabel());
            fieldLabels.put('DurationMinute__c', SObjectType.InquiryLine__c.fields.DurationMinute__c.getLabel());

            fieldLabels.put('NamePO', SObjectType.Price_Option__c.fields.Name.getLabel());
            fieldLabels.put('ReferencePrice__c', SObjectType.Price_Option__c.fields.ReferencePrice__c.getLabel());
            fieldLabels.put('SupplierVendor__c', SObjectType.Price_Option__c.fields.SupplierVendor__c.getLabel());
            fieldLabels.put('ChargeUnit__c', SObjectType.Price_Option__c.fields.ChargeUnit__c.getLabel());
            fieldLabels.put('ContainerType__c', SObjectType.Price_Option__c.fields.ContainerType__c.getLabel());
            fieldLabels.put('CurrencyPO', SObjectType.Price_Option__c.fields.Currency__c.getLabel());
            fieldLabels.put('BuyingListPriceActual__c', SObjectType.Price_Option__c.fields.BuyingListPriceActual__c.getLabel());
            fieldLabels.put('Com__c', SObjectType.Price_Option__c.fields.Com__c.getLabel());
            fieldLabels.put('DEM__c', SObjectType.Price_Option__c.fields.DEM__c.getLabel());
            fieldLabels.put('DET__c', SObjectType.Price_Option__c.fields.DET__c.getLabel());
            fieldLabels.put('ST__c', SObjectType.Price_Option__c.fields.ST__c.getLabel());

            return JSOn.serialize(fieldLabels);
        } catch (Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class Response{
        @AuraEnabled
        public Inquiry__c[] Inquiry;
        @AuraEnabled
        public InquiryRoute__c[] InquiryRoute;
        @AuraEnabled
        public InquiryLine__c[] InquiryLineNoCombo;
        @AuraEnabled
        public InquiryLine__c[] InquiryLineCombo;
        // @AuraEnabled
        // public Price_Option__c[] priceNoCombo;
        // @AuraEnabled
        // public Price_Option__c[] priceCombo;
    }

    @AuraEnabled
    public static Response getData(String InquiryId, String valueSearch){
        Response res = new Response();
        res.Inquiry = [SELECT Id, ContainerType1__c,
        ContaineType2__c,
        ContainerType3__c,
        ContainerQuantity1__c,
        ContainerQuantity2__c,
        ContainerQuantity3__c, Customer__c,Remark__c,Subject__c, InquirysNote__c,Valid_End_Date__c,Contact__c, CreatedById, Name, TypeofTrade__c, ShipmentTerm__c, TransportationWay__c, Commodity__c, Description_of_Goods__c, Type_of_Cargo__c, Incoterms__c, Quantity__c, Gross_WeightKg__c, Net_WeightKg__c, MeasurementCBM__c, Volume__c, DIMDimension__c, ETD__c, ETA__c
                       FROM Inquiry__c
                       where Id = :InquiryId
                       ORDER By Name];
        if (valueSearch.length() > 0){
            String resultSearch = '%' + valueSearch + '%';
            res.InquiryRoute = [SELECT Id, Name,PickUpAddress__c,DeliveryAddress__c, OriginCountry__c, DestinationCountry__c, POLAOL__c, PODAOD__c,RouteName__c,Place_of_Receipt__r.Name,Place_of_Delivery__r.Name,Place_of_Delivery__c,Place_of_Receipt__c
                                FROM InquiryRoute__c
                                where Inquiry__c = :InquiryId AND Name LIKE:resultSearch
                                ORDER By Name];
        } else{
            res.InquiryRoute = [SELECT Id, Name,PickUpAddress__c,DeliveryAddress__c, OriginCountry__c, DestinationCountry__c, POLAOL__c, PODAOD__c,RouteName__c,Place_of_Receipt__r.Name,Place_of_Delivery__r.Name,Place_of_Delivery__c,Place_of_Receipt__c
                                FROM InquiryRoute__c
                                where Inquiry__c = :InquiryId
                                ORDER By Name];
        }
        res.InquiryLineNoCombo = [SELECT Id, Name, Service__r.Name, ServiceType__c,Requested__c,PricingMember__c, StartTime__c, EndTime__c, DurationMinute__c, ComboProduct__c, ComboProduct__r.Name, Route__c, (SELECT Id, Name, ReferencePrice__r.Name, SupplierVendor__r.Name, ChargeUnit__c, ContainerType__c, Currency__c, BuyingListPriceActual__c, Com__c, DEM__c, DET__c, ST__c
                                                                                                                                                                                   from Price_Options__r
                                                                                                                                                                                   where ComboProduct__c = null
                                                                                                                                                                                   ORDER By Name)
                                  FROM InquiryLine__c
                                  WHERE Route__c = :res.InquiryRoute AND ComboProduct__c = null
                                  ORDER BY Name];
        res.InquiryLineCombo = [SELECT Id, Name, Service__r.Name, ServiceType__c,Requested__c,PricingMember__c, StartTime__c, EndTime__c, DurationMinute__c, ComboProduct__c, ComboProduct__r.Name, Route__c, (SELECT Id, Name, ReferencePrice__r.Name, SupplierVendor__r.Name, ChargeUnit__c, ContainerType__c, Currency__c, BuyingListPriceActual__c, Com__c, DEM__c, DET__c, ST__c
                                                                                                                                                                                 from Price_Options__r
                                                                                                                                                                                 where ComboProduct__c != null
                                                                                                                                                                                 ORDER By Name)
                                FROM InquiryLine__c
                                WHERE Route__c = :res.InquiryRoute AND ComboProduct__c != null
                                ORDER BY Name];
        return res;
    }

    @AuraEnabled
    public static String saveRecordsIQ(Quote__c QuoteItem, List<String> POIds){
        try{
            insert QuoteItem;
            List<String> containsRouteId = new List<String>();
            List<Quote_route__c> lstQR = new List<Quote_route__c>();
            List<Quoteline__c> lstQL = new List<Quoteline__c>();
            List<Price_Option__c> lstPO = [SELECT Id, Name, Service__c, SupplierVendor__c, Route__c, InquiryLine__r.Route__c, InquiryLine__r.Route__r.Route__c, InquiryLine__r.Route__r.Inquiry__c, InquiryLine__r.Route__r.DeliveryAddress__c, InquiryLine__r.Route__r.PickUpAddress__c, POLAOD__c, PODAOA__c, ChargeUnit__c, ContainerType__c, Currency__c, BuyingListPriceActual__c, ReferencePrice__c, ComboProduct__c
                                           FROM Price_Option__c
                                           WHERE Id IN:POIds];
            for (Integer i = 0; i < lstPO.size(); i++){
                Quote_route__c qr = new Quote_route__c();
                if (!containsRouteId.contains(lstPO[i].InquiryLine__r.Route__c)){
                    qr.Quote__c = QuoteItem.Id;
                    qr.Inquiry_Route__c = lstPO[i].InquiryLine__r.Route__c;
                    qr.Inquiry__c = lstPO[i].InquiryLine__r.Route__r.Inquiry__c;
                    qr.Route__c = lstPO[i].InquiryLine__r.Route__r.Route__c;
                    qr.PickUpAddress__c = lstPO[i].InquiryLine__r.Route__r.PickUpAddress__c;
                    qr.DeliveryAddress__c = lstPO[i].InquiryLine__r.Route__r.DeliveryAddress__c;
                    containsRouteId.add(lstPO[i].InquiryLine__r.Route__c);
                    lstQR.add(qr);
                }
            }
            insert lstQR;
            for (Integer i = 0; i < lstPO.size(); i++){
                Quoteline__c ql = new Quoteline__c();
                ql.QuoteID__c = QuoteItem.Id;
                ql.PriceOptionID__c = lstPO[i].Id;
                ql.Invoiceto__c = QuoteItem.RequesterCompany__c;
                ql.SupplierVendor__c = lstPO[i].SupplierVendor__c;
                ql.ServiceID__c = lstPO[i].Service__c;
                ql.Route__c = lstPO[i].Route__c;
                ql.ChargeUnit__c = lstPO[i].ChargeUnit__c;
                ql.ContainerType1__c = lstPO[i].ContainerType__c;
                ql.CurrencyBuying__c = lstPO[i].Currency__c;
                ql.BuyingListPriceActual__c = lstPO[i].BuyingListPriceActual__c;
                ql.ReferencePrice__c = lstPO[i].ReferencePrice__c;
                ql.POL__c = lstPO[i].POLAOD__c;
                ql.POD__c = lstPO[i].PODAOA__c;
                ql.Combo_Product__c = lstPO[i].ComboProduct__c;
                for (Integer j = 0; j < lstQR.size(); j++){
                    if (lstQR[j].Inquiry_Route__c == lstPO[i].InquiryLine__r.Route__c){
                        ql.Quote_route__c = lstQR[j].Id;
                        break;
                    }
                }
                lstQL.add(ql);
            }
            insert lstQL;
            System.debug('123456' + lstQR);
            return QuoteItem.Id;
        } catch (DmlException e){
            throw e;
        }
    }
    @AuraEnabled
    public static List<Inquiry__c> getTransValue(String recordIdx){
        // recordIdx ='a0I8d000007BAo6EAG';
        List<Inquiry__c>  lstPO;
        try {
            lstPO = [SELECT Id, TransportationWay__c,ComboProduct1__c	
            FROM Inquiry__c
            WHERE Id = :recordIdx];
        } catch (Exception e) {
            lstPO= new List<Inquiry__c>();
        }
        return lstPO;
    }
    @AuraEnabled
    public static List<InquiryRoute__c> getRouteCreate(String recordIdx){
        // recordIdx ='a0I8d000007BAo6EAG';
        List<InquiryRoute__c>  lstPO;
        try {
            lstPO = [SELECT Id, Name
            FROM InquiryRoute__c
            WHERE Inquiry__c = :recordIdx];
        } catch (Exception e) {
            lstPO= new List<InquiryRoute__c>();
        }
        return lstPO;
    }
    @AuraEnabled
    public static String saveInqureline(List<InquiryLine__c> ListQL){
        List<String> routeID = new List<String>();
        for (Integer i = 0; i < ListQL.size(); i++){
            routeID.add(ListQL[i].Route__c);
        }
        List<InquiryRoute__c> lstRoute = [SELECT Id, Name,RouteID__c
                                          FROM InquiryRoute__c
                                          WHERE Id IN:routeID];
        for (Integer i = 0; i < ListQL.size(); i++){
            for (Integer j = 0; j < lstRoute.size(); j++){
                if (ListQL[i].Route__c == lstRoute[j].Id){
                    ListQL[i].RouteID__c = lstRoute[j].RouteID__c;
                    break;
                }
            }
        }
        List<String> serID = new List<String>();
        for (Integer i = 0; i < ListQL.size(); i++){
            serID.add(ListQL[i].Service__c);
        }
        List<Service__c> lisSer = [SELECT Id, Name,ServiceType__c
                                          FROM Service__c
                                          WHERE Id IN:serID];
        for (Integer i = 0; i < ListQL.size(); i++){
            for (Integer j = 0; j < lisSer.size(); j++){
                if (ListQL[i].Service__c == lisSer[j].Id){
                    ListQL[i].ServiceType__c = lisSer[j].ServiceType__c;
                    break;
                }
            }
        }
        
        try {
            insert ListQL;
            return 'Success';
        } catch (Exception e) {
           return e.getMessage();
        }
      
    }

    @AuraEnabled
    public static String saveRecordsQ(List<String> POIds, String QuoteId){
        List<Price_Option__c> lstPO = [SELECT Id, Name, Service__c, SupplierVendor__c, Route__c, InquiryLine__r.Route__c, InquiryLine__r.Route__r.Route__c, InquiryLine__r.Route__r.Inquiry__c, InquiryLine__r.Route__r.DeliveryAddress__c, InquiryLine__r.Route__r.PickUpAddress__c, POLAOD__c, PODAOA__c, ChargeUnit__c, ContainerType__c, Currency__c, BuyingListPriceActual__c, ReferencePrice__c, ComboProduct__c
                                       FROM Price_Option__c
                                       WHERE Id IN:POIds];
        List<Quote_route__c> lstQR = [Select Id, Inquiry_Route__c
                                      from Quote_route__c
                                      where Quote__c = :QuoteId];
        String getRequesterCompany = [SELECT Id, RequesterCompany__c FROM Quote__c Where Id=:QuoteId].RequesterCompany__c;                              
        Map<String, List<Price_Option__c>> resultMap = new Map<String, List<Price_Option__c>>();
        for (Integer i = 0; i < lstPO.size(); i++){
            if (resultMap.containsKey((String) lstPO[i].InquiryLine__r.Route__c)){
                resultMap.get((String) lstPO[i].InquiryLine__r.Route__c).add(lstPO[i]);
            } else{
                resultMap.put((String) lstPO[i].InquiryLine__r.Route__c, new List<Price_Option__c>{ lstPO[i] });
            }
        }
        List<Price_Option__c> lsPOSaveQRNew = new List<Price_Option__c>();
        List<Price_Option__c> lsPOSaveQRExist = new List<Price_Option__c>();
        List<Quote_route__c> lsQRNew = new List<Quote_route__c>();
        List<Quote_route__c> lsQRExist = new List<Quote_route__c>();
        List<Quoteline__c> lsQLSaveQRNew = new List<Quoteline__c>();
        List<Quoteline__c> lsQLSaveQRExist = new List<Quoteline__c>();
        List<String> keyMap = new List<String>(resultMap.keySet());
        try{
            for (Integer i = 0; i < keyMap.size(); i++){
                for (Integer j = 0; j < lstQR.size(); j++){
                    if (keyMap[i] == lstQR[j].Inquiry_Route__c){
                        for (Integer k = 0; k < resultMap.get(keyMap[i]).size(); k++){
                            lsPOSaveQRExist.add(resultMap.get(keyMap[i])[k]);
                        }
                        lsQRExist.add(lstQR[j]);
                        break;
                    } else{
                        if (j == lstQR.size() - 1){
                            Quote_route__c qr = new Quote_route__c();
                            qr.Quote__c = QuoteId;
                            qr.Inquiry_Route__c = keyMap[i];
                            qr.Inquiry__c = resultMap.get(keyMap[i])[0].InquiryLine__r.Route__r.Inquiry__c;
                            qr.Route__c = resultMap.get(keyMap[i])[0].InquiryLine__r.Route__r.Route__c;
                            qr.PickUpAddress__c = resultMap.get(keyMap[i])[0].InquiryLine__r.Route__r.PickUpAddress__c;
                            qr.DeliveryAddress__c = resultMap.get(keyMap[i])[0].InquiryLine__r.Route__r.DeliveryAddress__c;
                            lsQRNew.add(qr);
                            for (Integer l = 0; l < resultMap.get(keyMap[i]).size(); l++){
                                lsPOSaveQRNew.add(resultMap.get(keyMap[i])[l]);
                            }
                        }
                    }
                }
            }
            insert lsQRNew;
            for (Integer i = 0; i < lsPOSaveQRNew.size(); i++){
                Quoteline__c ql = new Quoteline__c();
                ql.QuoteID__c = QuoteId;
                ql.PriceOptionID__c = lsPOSaveQRNew[i].Id;
                ql.Invoiceto__c = getRequesterCompany;
                ql.SupplierVendor__c = lsPOSaveQRNew[i].SupplierVendor__c;
                ql.ServiceID__c = lsPOSaveQRNew[i].Service__c;
                ql.Route__c = lsPOSaveQRNew[i].Route__c;
                ql.ChargeUnit__c = lsPOSaveQRNew[i].ChargeUnit__c;
                ql.ContainerType1__c = lsPOSaveQRNew[i].ContainerType__c;
                ql.CurrencyBuying__c = lsPOSaveQRNew[i].Currency__c;
                ql.BuyingListPriceActual__c = lsPOSaveQRNew[i].BuyingListPriceActual__c;
                ql.ReferencePrice__c = lsPOSaveQRNew[i].ReferencePrice__c;
                ql.POL__c = lsPOSaveQRNew[i].POLAOD__c;
                ql.POD__c = lsPOSaveQRNew[i].PODAOA__c;
                ql.Combo_Product__c = lsPOSaveQRNew[i].ComboProduct__c;
                for (Integer j = 0; j < lsQRNew.size(); j++){
                    if (lsQRNew[j].Inquiry_Route__c == lsPOSaveQRNew[i].InquiryLine__r.Route__c){
                        ql.Quote_route__c = lsQRNew[j].Id;
                        break;
                    }
                }
                lsQLSaveQRNew.add(ql);
            }
            insert lsQLSaveQRNew;

            for (Integer i = 0; i < lsPOSaveQRExist.size(); i++){
                Quoteline__c ql = new Quoteline__c();
                ql.QuoteID__c = QuoteId;
                ql.PriceOptionID__c = lsPOSaveQRExist[i].Id;
                ql.Invoiceto__c = getRequesterCompany;
                ql.SupplierVendor__c = lsPOSaveQRExist[i].SupplierVendor__c;
                ql.ServiceID__c = lsPOSaveQRExist[i].Service__c;
                ql.Route__c = lsPOSaveQRExist[i].Route__c;
                ql.ChargeUnit__c = lsPOSaveQRExist[i].ChargeUnit__c;
                ql.ContainerType1__c = lsPOSaveQRExist[i].ContainerType__c;
                ql.CurrencyBuying__c = lsPOSaveQRExist[i].Currency__c;
                ql.BuyingListPriceActual__c = lsPOSaveQRExist[i].BuyingListPriceActual__c;
                ql.ReferencePrice__c = lsPOSaveQRExist[i].ReferencePrice__c;
                ql.POL__c = lsPOSaveQRExist[i].POLAOD__c;
                ql.POD__c = lsPOSaveQRExist[i].PODAOA__c;
                ql.Combo_Product__c = lsPOSaveQRExist[i].ComboProduct__c;
                for (Integer j = 0; j < lsQRExist.size(); j++){
                    if (lsQRExist[j].Inquiry_Route__c == lsPOSaveQRExist[i].InquiryLine__r.Route__c){
                        ql.Quote_route__c = lsQRExist[j].Id;
                        break;
                    }
                }
                lsQLSaveQRExist.add(ql);
            }
            insert lsQLSaveQRExist;
            return 'haha';
        } catch (DmlException e){
            throw e;
        }
    }
    

}