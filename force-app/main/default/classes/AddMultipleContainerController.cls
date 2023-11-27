public with sharing class AddMultipleContainerController {
    @AuraEnabled
    public static List <String> getPiklistValues() {
        List<String> plValues = new List<String>();
          
        // //Get the object type from object name. Here I've used custom object Book.
        // Schema.SObjectType objType = Schema.getGlobalDescribe().get('ConsolCNTR__c');
          
        // //Describe the sObject using its object type.
        // Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
          
        // //Get the specific field information from field name. Here I've used custom field Genre__c of Book object.
        // Schema.DescribeFieldResult objFieldInfo = objDescribe.fields.getMap().get('clofor_com_cfs__CargoTypeUnit__c').getDescribe();
          
        // //Get the picklist field values.
        // List<Schema.PicklistEntry> picklistvalues = objFieldInfo.getPicklistValues();
          
        // //Add the picklist values to list.
        // for(Schema.PicklistEntry plv: picklistvalues) {
        //     plValues.add(plv.getValue());
        // }
        // plValues.sort();
        plValues.add('Air Flat-bed');
        plValues.add('B/L');
        plValues.add('Bag');
        plValues.add('Bale,compressed');
        plValues.add('Bale,non-compressed');
        plValues.add('Bar');
        plValues.add('Barrel');
        plValues.add('Basket');
        plValues.add('Bill');
        plValues.add('Box');
        plValues.add('Bulk, gas（at 1031mber and 15℃）');
        plValues.add('Bulk, liguefied gas（at abnomal temperature/pressure）');
        plValues.add('Bulk, liquid');
        plValues.add('Bulk, solid, fineparticles(powders）');
        plValues.add('Bulk, solid, granular particles(grains）');
        plValues.add('Bulk, solid, large particles(nodules）');
        plValues.add('Bundle');
        plValues.add('Cage');
        plValues.add('Can,cylindrical');
        plValues.add('Can,rectangular');
        plValues.add('Carboy,non-protected');
        plValues.add('Carboy,protected');
        plValues.add('Carton');
        plValues.add('Case');
        plValues.add('Cask');
        plValues.add('CBM');
        plValues.add('Certificate');
        plValues.add('Chest');
        plValues.add('Coil');
        plValues.add('Container');
        plValues.add('Crate');
        plValues.add('Cylinder');
        plValues.add('Day');
        plValues.add('DemiJohn, protected');
        plValues.add('DemiJohn,non-protected');
        plValues.add('Drum');
        plValues.add('EA');
        plValues.add('Fibre Drum');
        plValues.add('Flask');
        plValues.add('Flexible Container');
        plValues.add('Frame');
        plValues.add('g');
        plValues.add('HEAD');
        plValues.add('Hogeshead');
        plValues.add('Ingot');
        plValues.add('Jar');
        plValues.add('Jug');
        plValues.add('Keg');
        plValues.add('Kg');
        plValues.add('Km');
        plValues.add('License');
        plValues.add('Log');
        plValues.add('Logs, in bundle/bunch/truss');
        plValues.add('Lowbed');
        plValues.add('Mat');
        plValues.add('Net');
        plValues.add('Other');
        plValues.add('Others');
        plValues.add('Pack');
        plValues.add('Package');
        plValues.add('Packet');
        plValues.add('Pail');
        plValues.add('Pallet');
        plValues.add('Pallet & Package');
        plValues.add('Parcel');
        plValues.add('Pen');
        plValues.add('Piece');
        plValues.add('Pipe');
        plValues.add('Pipes, in bundle/bunch/truss');
        plValues.add('Planks, in bundle/bunch/truss');
        plValues.add('Plate');
        plValues.add('Plates, in bundle/bunch/truss');
        plValues.add('Reel');
        plValues.add('Roll');
        plValues.add('RTON');
        plValues.add('Sack');
        plValues.add('Set');
        plValues.add('Sheet');
        plValues.add('Sheet,in bundle/bunch/truss');
        plValues.add('Shipment');
        plValues.add('Skeleton Case');
        plValues.add('Skid');
        plValues.add('Slab');
        plValues.add('Steel Case');
        plValues.add('Steel Envelop');
        plValues.add('Tierce');
        plValues.add('Time');
        plValues.add('Tin');
        plValues.add('Ton');
        plValues.add('Tray');
        plValues.add('Tub');
        plValues.add('Unit');
        plValues.add('Unpacked or unpackaged');
        plValues.add('Vanpack');
        plValues.add('Vat');
        plValues.add('Wooden Drum');
        return plValues;
    }
    
    @AuraEnabled
    public static String saveContList(List<ConsolCNTR__c> contList,Id shipmentId) 
	{   
        for(ConsolCNTR__c cont: contList){
            cont.AdvancedShipment__c = shipmentId;
            // if(cont.CurrencySelling__c == custom.FCYCurrency__c){
            //     cont.UnitPriceFCY__c = cont.UnitPriceFCY__c;
            //     cont.UnitPriceofSellingLocal__c = null;
            // }else if(cont.CurrencySelling__c == custom.LocalCurrency__c){
            //     cont.UnitPriceofSellingLocal__c = cont.UnitPriceFCY__c;
            // }else {
            //     cont.UnitPriceofSellingLocal__c = null;
            // }

            // if(cont.CurrencyBuying__c == custom.FCYCurrency__c){
            //     cont.UnitPriceofBuyingFCY__c = cont.UnitPriceofBuyingFCY__c;
            //     cont.UnitPriceofBuyingLocal__c = null;
            // }else if(cont.CurrencyBuying__c == custom.LocalCurrency__c){
            //     cont.UnitPriceofBuyingLocal__c = cont.UnitPriceofBuyingFCY__c;
            // }else {
            //     cont.UnitPriceofSelling3rdCurrency__c = cont.UnitPriceofSellingLocal__c;
            //     cont.UnitPriceofSellingLocal__c = null;
            // }        
        }
        try {
            insert contList;
            
        } catch (Exception e) {
            return e.getMessage();
        }
        return null;
        // System.debug('accList1:' + accList);     

        // System.debug('accList2:' + accList);
    }
    
}