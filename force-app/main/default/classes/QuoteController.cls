public with sharing class QuoteController{
    @AuraEnabled
    public static String getFieldLabels(){
        try{
            Map<String, String> fieldLabels = new Map<String, String>();
            fieldLabels.put('Name', SObjectType.Quote_route__c.fields.Name.getLabel());
            fieldLabels.put('Route_Name__c', SObjectType.Quote_route__c.fields.Route_Name__c.getLabel());
            fieldLabels.put('Origin_Country__c', SObjectType.Quote_route__c.fields.Origin_Country__c.getLabel());
            fieldLabels.put('Destination_Country__c', SObjectType.Quote_route__c.fields.Destination_Country__c.getLabel());
            fieldLabels.put('POLAOL__c', SObjectType.Quote_route__c.fields.POLAOL__c.getLabel());
            fieldLabels.put('PODAOD__c', SObjectType.Quote_route__c.fields.PODAOD__c.getLabel());

            fieldLabels.put('Approver__c', SObjectType.Sales_Order__c.fields.Approver__c.getLabel());
            fieldLabels.put('Quote_ID__c', SObjectType.Sales_Order__c.fields.Quote_ID__c.getLabel());
            fieldLabels.put('Approved_date__c', SObjectType.Sales_Order__c.fields.Approved_date__c.getLabel());
            fieldLabels.put('Valid_Date__c', SObjectType.Sales_Order__c.fields.Valid_Date__c.getLabel());
            fieldLabels.put('Approved_date__c', SObjectType.Sales_Order__c.fields.Approved_date__c.getLabel());
            fieldLabels.put('ShipmentConverted__c', SObjectType.Sales_Order__c.fields.ShipmentConverted__c.getLabel());
            fieldLabels.put('Submiter__c', SObjectType.Sales_Order__c.fields.Submiter__c.getLabel());
            fieldLabels.put('Booking_ID__c', SObjectType.Sales_Order__c.fields.Booking_ID__c.getLabel());
            fieldLabels.put('Housse_Freight_Collect_Prepaid__c', SObjectType.Sales_Order__c.fields.Housse_Freight_Collect_Prepaid__c.getLabel());
            fieldLabels.put('Vessel_Flight__c', SObjectType.Sales_Order__c.fields.Vessel_Flight__c.getLabel());
            fieldLabels.put('TypeofTrade__c', SObjectType.Sales_Order__c.fields.TypeofTrade__c.getLabel());
            fieldLabels.put('Voyage__c', SObjectType.Sales_Order__c.fields.Voyage__c.getLabel());
            fieldLabels.put('ShipmentTerm__c', SObjectType.Sales_Order__c.fields.ShipmentTerm__c.getLabel());
            fieldLabels.put('ETD__c', SObjectType.Sales_Order__c.fields.ETD__c.getLabel());
            fieldLabels.put('TransportationWay__c', SObjectType.Sales_Order__c.fields.TransportationWay__c.getLabel());
            fieldLabels.put('ETA__c', SObjectType.Sales_Order__c.fields.ETA__c.getLabel());
            fieldLabels.put('CreateCustomClearance__c', SObjectType.Sales_Order__c.fields.CreateCustomClearance__c.getLabel());
            fieldLabels.put('CreateTrucking__c', SObjectType.Sales_Order__c.fields.CreateTrucking__c.getLabel());
            fieldLabels.put('Commodity__c', SObjectType.Sales_Order__c.fields.Commodity__c.getLabel());
            fieldLabels.put('NetWeight__c', SObjectType.Sales_Order__c.fields.NetWeight__c.getLabel());
            fieldLabels.put('Description_of_Goods__c', SObjectType.Sales_Order__c.fields.Description_of_Goods__c.getLabel());
            fieldLabels.put('GrossWeight__c', SObjectType.Sales_Order__c.fields.GrossWeight__c.getLabel());
            fieldLabels.put('Cargo_Quantity__c', SObjectType.Sales_Order__c.fields.Cargo_Quantity__c.getLabel());
            fieldLabels.put('MeasurementTotalCBM__c', SObjectType.Sales_Order__c.fields.MeasurementTotalCBM__c.getLabel());
            fieldLabels.put('Remarks__c', SObjectType.Sales_Order__c.fields.Remarks__c.getLabel());
            fieldLabels.put('INCOTERMS__c', SObjectType.Sales_Order__c.fields.INCOTERMS__c.getLabel());
            fieldLabels.put('Customer__c', SObjectType.Sales_Order__c.fields.Customer__c.getLabel());
            fieldLabels.put('Shipper__c', SObjectType.Sales_Order__c.fields.Shipper__c.getLabel());
            fieldLabels.put('Consignee__c', SObjectType.Sales_Order__c.fields.Consignee__c.getLabel());
            fieldLabels.put('Housse_Notify_Party__c', SObjectType.Sales_Order__c.fields.Housse_Notify_Party__c.getLabel());
            fieldLabels.put('Quote_route__c', SObjectType.Sales_Order__c.fields.Quote_route__c.getLabel());
            fieldLabels.put('Route_Name__c', SObjectType.Sales_Order__c.fields.Route_Name__c.getLabel());
            fieldLabels.put('P_O_L_A_O_D__c', SObjectType.Sales_Order__c.fields.P_O_L_A_O_D__c.getLabel());
            fieldLabels.put('P_O_D_A_O_A__c', SObjectType.Sales_Order__c.fields.P_O_D_A_O_A__c.getLabel());
            fieldLabels.put('Place_of_Receipt__c', SObjectType.Sales_Order__c.fields.Place_of_Receipt__c.getLabel());
            fieldLabels.put('Place_of_Delivery__c', SObjectType.Sales_Order__c.fields.Place_of_Delivery__c.getLabel());
            fieldLabels.put('Pick_Up_Address__c', SObjectType.Sales_Order__c.fields.Pick_Up_Address__c.getLabel());
            fieldLabels.put('Delivery_Address__c', SObjectType.Sales_Order__c.fields.Delivery_Address__c.getLabel());
            return JSOn.serialize(fieldLabels);
        } catch (Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class Response{
        @AuraEnabled
        public Quote__c[] Quote;
        @AuraEnabled
        public Quote_route__c[] QuoteRoute;
        @AuraEnabled
        public Quoteline__c[] QuoteLineNoCombo;
        @AuraEnabled
        public Quoteline__c[] QuoteLineCombo;
    }

    @AuraEnabled
    public static Response getData(String QuoteId){
        Response res = new Response();
        res.Quote = [SELECT Id,Validto__c,ContainerType1__c,ContainerType2__c,ContainerType3__c,ContainerQuantity1__c, ContainerQuantity2__c, ContainerQuantity3__c,Remarks__c, InquiryID__c, RequesterCompany__c, Commodity1__c, DescriptionofGoods__c, Cargo_Quantity__c, INCOTERMS__c, MeasurementTotalCBM__c, NetWeight__c, GrossWeight__c, DIM_Dimension__c, VesselFlight__c, Volume__c, Voyage__c, ETD__c, ETA__c, ShipmentTerm__c, TypeofTrade__c, TransportationWay__c
                     FROM Quote__c
                     where Id = :QuoteId
                     ORDER By Name];
        res.QuoteRoute = [SELECT Id, Name, Route_Name__c, Origin_Country__c, Destination_Country__c, POLAOL__c, PODAOD__c,Place_of_Receipt__c,Place_of_Delivery__c,Place_of_Delivery__r.Name,Place_of_Receipt__r.Name
                          FROM Quote_route__c
                          where Quote__c = :QuoteId
                          ORDER By Name];
        res.QuoteLineCombo = [SELECT Id, Name,SupplierVendor__c,SupplierVendor__r.Name, ServiceID__r.Name, ChargeUnit__c, ContainerType1__c, ChargeQuantity__c, CurrencyBuying__c, BuyingListPriceActual__c, CurrencySelling__c, SellingListPriceActual__c, TaxRateSelling__c, TotalSellingInclTaxActual__c,TaxRateBuying__c,TotalBuyingInclTaxActual__c, Combo_Product__c, Combo_Product__r.Name, Quote_route__c
                              FROM Quoteline__c
                              WHERE Quote_route__c = :res.QuoteRoute AND Combo_Product__c != null
                              ORDER BY Name];
        res.QuoteLineNoCombo = [SELECT Id, Name,SupplierVendor__c,SupplierVendor__r.Name, ServiceID__r.Name, ChargeUnit__c, ContainerType1__c, ChargeQuantity__c, CurrencyBuying__c, BuyingListPriceActual__c, CurrencySelling__c, SellingListPriceActual__c, TaxRateSelling__c, TotalSellingInclTaxActual__c,TaxRateBuying__c,TotalBuyingInclTaxActual__c, Combo_Product__c, Combo_Product__r.Name, Quote_route__c
                                FROM Quoteline__c
                                WHERE Quote_route__c = :res.QuoteRoute AND Combo_Product__c = null
                                ORDER BY Name];
        return res;
    }

    @AuraEnabled
    public static String saveRecords(Sales_Order__c SalesOrder, List<String> QLIds){
        System.debug('saveRecords?? '+ SalesOrder);
        try{
            insert SalesOrder;
            List<Sales_Order_Line__c> lstQOL = new List<Sales_Order_Line__c>();
            List<Quoteline__c> lstQL = [SELECT Id,PriceOptionID__c,Invoiceto__c ,Quote_route__c,Route__c, Name, ReferencePrice__c, ServiceID__c, LineItemNameEng__c, LineItemNameLocal__c, Combo_Product__c, ChargeQuantity__c, ChargeUnit__c, ContainerType1__c, TaxRateSelling__c, TaxRateBuying__c, SellingListPriceActual__c, BuyingListPriceLocal__c, BuyingListPriceActual__c, SellingListPriceLocal__c, SellingListPriceFCY__c, BuyingListPriceFCY__c, CurrencySelling__c, FxRateIDSelling__c, ExchangeRateSelling__c, ExchangeRateSellingUSD__c, CurrencyBuying__c, FxRateID__c, ExchangeRateBuying__c, ExchangeRateBuyingUSD__c
                                        From Quoteline__c
                                        Where Id In:QLIds];
            for (Integer i = 0; i < lstQL.size(); i++){
                Sales_Order_Line__c soL = new Sales_Order_Line__c();
                soL.SO_ID__c = SalesOrder.Id;
                soL.ReferencePrice__c = lstQL[i].ReferencePrice__c;
                soL.QuotelineID__c = lstQL[i].Id;
                soL.PriceOptionID__c = lstQL[i].PriceOptionID__c;
                soL.Invoice_to__c = lstQL[i].Invoiceto__c;
                
                soL.Container_Type__c = lstQL[i].ContainerType1__c;
                
                soL.Quote_route__c = lstQL[i].Quote_route__c;
                soL.RouteID__c = lstQL[i].Route__c;
                soL.Service__c = lstQL[i].ServiceID__c;
                soL.Line_Item_Name_Eng__c = lstQL[i].LineItemNameEng__c;
                soL.Line_Item_Name_Local__c = lstQL[i].LineItemNameLocal__c;
                soL.ComboProduct__c = lstQL[i].Combo_Product__c;
                soL.ChargeQuantity__c = lstQL[i].ChargeQuantity__c;
                soL.Charge_unit__c = lstQL[i].ChargeUnit__c;
                soL.TaxRateSelling__c = lstQL[i].TaxRateSelling__c;
                soL.TaxRateBuying__c = lstQL[i].TaxRateBuying__c;
                soL.SellingListPriceActual__c = lstQL[i].SellingListPriceActual__c;
                soL.BuyingListPriceLocal__c = lstQL[i].BuyingListPriceLocal__c;
                soL.BuyingListPriceActual__c = lstQL[i].BuyingListPriceActual__c;
                soL.SellingListPriceLocal__c = lstQL[i].SellingListPriceLocal__c;
                soL.SellingListPriceFCY__c = lstQL[i].SellingListPriceFCY__c;
                soL.BuyingListPriceFCY__c = lstQL[i].BuyingListPriceFCY__c;
                soL.CurrencySelling__c = lstQL[i].CurrencySelling__c;
                soL.FxRateIDSelling__c = lstQL[i].FxRateIDSelling__c;
                soL.ExchangeRateSelling__c = lstQL[i].ExchangeRateSelling__c;
                soL.ExchangeRateSellingUSD__c = lstQL[i].ExchangeRateSellingUSD__c;
                soL.Currency_Buying__c = lstQL[i].CurrencyBuying__c;
                soL.FxRateID__c = lstQL[i].FxRateID__c;
                soL.ExchangeRateBuying__c = lstQL[i].ExchangeRateBuying__c;
                soL.ExchangeRateBuyingUSD__c = lstQL[i].ExchangeRateBuyingUSD__c;
                System.debug('123456??:' + soL);
                lstQOL.add(soL);
            }
            insert lstQOL;
            return SalesOrder.Id;
        } catch (DmlException e){
            throw e;
        }
    }

    @AuraEnabled
    public static Map<Integer, List<Quote_route__c>> getQR(List<String> QLIds){
        Map<Integer, List<Quote_route__c>> mapResult = new Map<Integer, List<Quote_route__c>>();
        List<Quote_route__c> lstQR = new List<Quote_route__c>();
        List<AggregateResult> lst = [SELECT Quote_route__c
                                     from Quoteline__c
                                     Where Id IN:QLIds
                                     GROUP BY Quote_route__c];
        System.debug('123456:' + lstQR);
        if (lst.size() == 1){
            lstQR = [Select Id, POLAOL__c, PODAOD__c, PickUpAddress__c, DeliveryAddress__c, Route__r.Route__r.From__c, Route__r.Route__r.To__c
                     from Quote_route__c
                     Where Id = :(String)lst[0].get('Quote_route__c')];
            mapResult.put(1, lstQR);
        } else{
            mapResult.put(2, lstQR);
        }
        return mapResult;
    }

    // @AuraEnabled
    // public static Map<Integer, List<Quote_route__c>> getQR(List<String> QLIds){
    //     Map<Integer, List<Quote_route__c>> mapResult = new Map<Integer, List<Quote_route__c>>();
    //     List<Quote_route__c> lstQR = new List<Quote_route__c>();
    //     List<AggregateResult> lst = [SELECT Quote_route__c
    //                                  from Quoteline__c
    //                                  Where Id IN:QLIds
    //                                  GROUP BY Quote_route__c];
    //     System.debug('123456:' + lstQR);
    //     if (lst.size() == 1){
    //         lstQR = [Select Id, POLAOL__c, PODAOD__c, PickUpAddress__c, DeliveryAddress__c, Route__r.Route__r.From__c, Route__r.Route__r.To__c
    //                  from Quote_route__c
    //                  Where Id = :(String)lst[0].get('Quote_route__c')];
    //         mapResult.put(1, lstQR);
    //     } else{
    //         mapResult.put(2, lstQR);
    //     }
    //     return mapResult;
    // }

    @AuraEnabled
    public static List<Quote_route__c> getRoute(String QuoteId){
        System.debug(' jhsbfsdkf ');

        return [SELECT Route__r.Route__c
                FROM Quote_route__c
                WHERE Quote__c = :QuoteId];
    }
    @AuraEnabled
    public static Service__c getTariff(String serId) {
        // System.debug('serId: '+ [SELECT Tariff__c
        // FROM Service__c
        // WHERE Id = :serId]);
        return [SELECT Tariff__c
        FROM Service__c
        WHERE Id = :serId];
  

    }
    

    @AuraEnabled
    public static void saveQuoteLineList(List<Quoteline__c> quoteLineList, Id quoteId){
        List<Id> Id = new List<Id>();
        for (Quoteline__c quoLine : quoteLineList){
            if(quoLine.ReferencePrice__c != null || quoLine.ReferencePrice__c != ''){
                Id.add(quoLine.ReferencePrice__c);
            }
        }
        
        List<ReferencePrice__c> referencePrices = getReferencePricesByIds(Id);
        System.debug('IdMM:' + Id);
        System.debug('referencePrices<<:' + referencePrices);

        List<Id> Idsv = new List<Id>();
        for (Quoteline__c quoLine : quoteLineList){
            if(quoLine.ServiceID__c != null || quoLine.ServiceID__c != ''){
                Idsv.add(quoLine.ServiceID__c);
            }
        }

        System.debug('IdMM22:' + Idsv);
        
        List<Service__c> Services = getServiceByIds(Idsv);
        System.debug('referencePrices<<22:' + Services);

     

        for (Quoteline__c quoLine : quoteLineList){
            quoLine.QuoteID__c = quoteId;
           for(ReferencePrice__c refPrice : referencePrices){
               if (quoLine.ReferencePrice__c == refPrice.Id){
                quoLine.ServiceID__c=refPrice.ServiceName__c;
                quoLine.SupplierVendor__c=refPrice.Account__c;
                quoLine.BuyingListPriceActual__c=refPrice.UnitPriceofBuying__c;
                quoLine.CurrencyBuying__c=refPrice.CurrencyBuying__c;
                quoLine.ChargeUnit__c=refPrice.ChargeUnit__c;
                quoLine.Route__c=refPrice.Route__c;
                quoLine.ContainerType1__c=refPrice.ContainerType__c;
             
               }
           }
        }
        for (Quoteline__c quoLine : quoteLineList){
            
            System.debug('quoLine.ReferencePrice__c:' + quoLine.ReferencePrice__c);

            // if(!(quoLine.ReferencePrice__c!=null && quoLine.ReferencePrice__c!='')){
                if(String.isEmpty(quoLine.ReferencePrice__c)){
                for(Service__c ser : Services){
                    System.debug('ser.I:' + ser.Id);
                     System.debug( 'quoLine.ServiceID__c:' + quoLine.ServiceID__c);
                    if (quoLine.ServiceID__c == ser.Id && ser.Tariff__c == true && quoLine.Print__c == true){
                        quoLine.CurrencyBuying__c=ser.Currency__c;
                        quoLine.BuyingListPriceActual__c=ser.BuyingListPriceActual__c;
                        quoLine.Print__c=false;
                    }
                }
                }
        }

        try{
            Insert quoteLineList;
        } catch (DmlException e){
            throw e;
        }
    }
    
    public static List<Quoteline__c> getQlByIds(List<Id> recordIds) {
        List<Quoteline__c> referencePrices = new List<Quoteline__c>();

        if (recordIds != null && !recordIds.isEmpty()) {
            referencePrices = [SELECT Id,ReferencePrice__c FROM Quoteline__c WHERE Id IN :recordIds];
        }

        return referencePrices;
    }
    public static List<ReferencePrice__c> getReferencePricesByIds(List<Id> recordIds) {
        List<ReferencePrice__c> referencePrices = new List<ReferencePrice__c>();


        if (recordIds != null && !recordIds.isEmpty()) {
            referencePrices = [SELECT Id, 
            ServiceName__c,
            Account__c,
            UnitPriceofBuying__c,
            CurrencyBuying__c,
            ChargeUnit__c,
            Route__c,
            ContainerType__c FROM ReferencePrice__c WHERE Id IN :recordIds];
        }

        return referencePrices;
    }

    public static List<Service__c> getServiceByIds(List<Id> recordIds) {
        List<Service__c> Services = new List<Service__c>();


        if (recordIds != null && !recordIds.isEmpty()) {
            Services = [SELECT Id, 
            Tariff__c,Currency__c,BuyingListPriceActual__c FROM Service__c WHERE Id IN :recordIds];
        }

        return Services;
    }

    @AuraEnabled
    public static Boolean deleteQuoteLine(List<String> QLIds){
        try{
            // Set<String> Ids = new Set<String>();
            // for (Integer i = 0; i < lstQuoteLineId.size(); i++){
            //     Ids.add((String) lstQuoteLineId[i]);
            // }
            List<Quoteline__c> quoteLines = [Select Id
                                             FROM Quoteline__c
                                             WHERE Id IN:QLIds];
            if (quoteLines.size() == 0)
                return false;
            delete quoteLines;
            return true;
        } catch (Exception e){
            throw e;
        }
    }

    @AuraEnabled
    public static List<Quoteline__c> getQLUpdate(List<String> QLIds){
        try{
            List<Quoteline__c> quoteLines = [Select Name, Id, ReferencePrice__c, PrintingSection__c, ChargeQuantity__c, CurrencySelling__c, TaxRateSelling__c, SellingListPriceActual__c, Remarks__c, Section__c
                                             From Quoteline__c
                                             WHERE Id IN:QLIds
                                             ORDER BY NAME];

            return quoteLines;
        } catch (Exception e){
            throw e;
        }
    }

    @AuraEnabled
    public static List<Quoteline__c> updateQL(List<Quoteline__c> quoteLineList,Boolean isUpdate){
        List<Id> Id = new List<Id>();  
        List<Id> IdQl = new List<Id>();   

        if(isUpdate){
        System.debug('quoteLineList:' + quoteLineList);

        for (Quoteline__c quoLine : quoteLineList){
            if(IdQl.contains(quoLine.Id) == false){
                IdQl.add(quoLine.Id);
            }
        }
        List<Quoteline__c> QlList = getQlByIds(IdQl);

        for(Quoteline__c quoLine : quoteLineList){

            if( String.isEmpty(quoLine.ReferencePrice__c)){
                for(Quoteline__c Ql : QlList){
                   if( quoLine.Id == Ql.Id){
                       quoLine.ReferencePrice__c = Ql.ReferencePrice__c;
                   }
                }
            }
        }
        for(Quoteline__c quoLine : quoteLineList){
            if(Id.contains(quoLine.ReferencePrice__c) == false){
                Id.add(quoLine.ReferencePrice__c);
            }
        }
        System.debug('quoteLineList22:' + quoteLineList);

        List<ReferencePrice__c> referencePrices = getReferencePricesByIds(Id);
        for (Quoteline__c quoLine : quoteLineList){
           for(ReferencePrice__c refPrice : referencePrices){
               if (quoLine.ReferencePrice__c == refPrice.Id){
                quoLine.ServiceID__c=refPrice.ServiceName__c;
                quoLine.SupplierVendor__c=refPrice.Account__c;
                quoLine.BuyingListPriceActual__c=refPrice.UnitPriceofBuying__c;
                quoLine.CurrencyBuying__c=refPrice.CurrencyBuying__c;
                quoLine.ChargeUnit__c=refPrice.ChargeUnit__c;
                quoLine.Route__c=refPrice.Route__c;
                quoLine.ContainerType1__c=refPrice.ContainerType__c;
             
               }
           }
        }
        System.debug('quoteLineList3:' + quoteLineList);
    }
        try{
            upsert quoteLineList;
            Set<String> Ids = new Set<String>();
            for (Integer i = 0; i < quoteLineList.size(); i++){
                Ids.add((String) quoteLineList[i].Id);
            }
            return [Select Name, Id, 
            ServiceID__c, SupplierVendor__c, BuyingListPriceActual__c ,CurrencyBuying__c ,TaxRateBuying__c ,ChargeUnit__c,ContainerType1__c, 
            ReferencePrice__c, PrintingSection__c, ChargeQuantity__c, CurrencySelling__c, TaxRateSelling__c, SellingListPriceActual__c, Remarks__c, Section__c
                    From Quoteline__c
                    Where Id In:Ids];
        } catch (Exception e){
            throw e;
        }
    }

}