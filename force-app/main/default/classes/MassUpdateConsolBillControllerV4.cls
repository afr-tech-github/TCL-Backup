public with sharing class MassUpdateConsolBillControllerV4 {
  @AuraEnabled
  public static String getRecordTypeId() {
    //TODO: Need to clarify which spefic developer name record here
    return [
      SELECT Id, SobjectType
      FROM RecordType
      WHERE
        SobjectType = 'FTMSBill__c'
        AND DeveloperName = 'Selling_Buyging_Standard'
    ]
    .Id;
  }

  @AuraEnabled
  public static String getDescribeSobjectResult() {
    DescribeSobjectResult objResult = Schema.SObjectType.FTMSBill__c;
    return objResult.isCreateable() +
      '_' +
      objResult.isUpdateable() +
      '_' +
      objResult.isAccessible() +
      '_' +
      objResult.isDeletable();
  }
  @AuraEnabled
  public static List<ConsolBill__c> getAllBillings(String shipmentId) {
    List<ConsolBill__c> getBilling = new List<ConsolBill__c>();
    getBilling = [
      SELECT (SELECT Id,
      Name,
      MasterBilling__c,
      PricingName__c,
      FTMSSO__c,
      ChargeUnit__c,
      Quantity__c,
      Container_Type__c,
      Invoiceto__c,
      CurrencySelling__c,
      UnitPriceofSellingActual__c,
      TaxRatioSelling__c,
      Tax_Included_Selling__c,
      PaymentTo__c,
      UnitPriceofBuyingActual__c,
      TaxRatioBuying__c,
      Tax_Included__c FROM Consol_Bills__r),Id,
      Name,
      MasterBilling__c,
      PricingName__c,
      FTMSSO__c,
      ChargeUnit__c,
      Quantity__c,
      Container_Type__c,
      Invoiceto__c,
      CurrencySelling__c,
      UnitPriceofSellingActual__c,
      TaxRatioSelling__c,
      Tax_Included_Selling__c,
      PaymentTo__c,
      UnitPriceofBuyingActual__c,
      TaxRatioBuying__c,
      Tax_Included__c
      FROM ConsolBill__c
      WHERE ConsolidationShipmentName__c = :shipmentId AND MasterBilling__c = null
      ORDER BY Name
    ];

    return getBilling;
  }

  @AuraEnabled
  public static List<ConsolBill__c> getNewBillings(
    String shipmentId,
    Boolean isSelling,
    List<String> ids
  ) {
    List<ConsolBill__c> getBilling = new List<ConsolBill__c>();
    // if(isSelling){
    getBilling = [
      SELECT Id
      FROM ConsolBill__c
      WHERE ConsolidationShipmentName__c = :shipmentId AND Id NOT IN :ids
      ORDER BY Name
    ];
    System.debug('Thong debug :' + getBilling);
    // } else {
    //     getBilling =  [Select Id FROM ConsolBill__c
    //         WHERE ConsolidationShipmentName__c = :shipmentId
    //         AND Id NOT IN :ids

    //         ORDER BY Name];
    // }

    return getBilling;
  }
  @AuraEnabled
  public static List<ConsolBill__c> getSubBillings(String shipmentId) {
    List<ConsolBill__c> getBilling = new List<ConsolBill__c>();
    System.debug('shipmentId :' + shipmentId);
    getBilling = [
      SELECT Id, Name
      FROM ConsolBill__c
      WHERE MasterBilling__c = :shipmentId
      ORDER BY Name
    ];
    System.debug('Thong debug 2 :' + getBilling);

    return getBilling;
  }
  @AuraEnabled
  public static Map<String, Object> getListWapper(String ShipID) {
    Map<String, Object> result = new Map<String, Object>();
    List<ConsolBill__c> lisdt = new List<ConsolBill__c>();
    List<ConsolBill__c> lisdoc = [
      SELECT id, (SELECT id FROM Consol_Bills__r)
      FROM ConsolBill__c
      WHERE ConsolidationShipmentName__c = :ShipID
      ORDER BY Name
    ];

    List<Id> unique = new List<Id>();
    for (ConsolBill__c lisdocItem : lisdoc) {
      if (lisdocItem.Id != null && !unique.contains(lisdocItem.Id)) {
        unique.add(lisdocItem.Id);
      }
    }

    system.debug('Fu doc list:' + lisdoc);
    if (lisdoc.size() > 0) {
      lisdt = [SELECT Id FROM ConsolBill__c WHERE MasterBilling__c IN :unique];
    }
    system.debug('Fu docdt list :' + lisdoc);
    result.put('DocList', lisdoc);
    result.put('DocListDT', lisdt);
    return result;
  }

  @AuraEnabled
  public static Boolean deleteBilling(String id) {
    try {
      List<ConsolBill__c> billings = [
        SELECT Id
        FROM ConsolBill__c
        WHERE Id = :id
      ];
      if (billings.size() == 0)
        return false;
      delete billings;
      return true;
    } catch (DmlException e) {
      throw e;
    }
  }

  @AuraEnabled
  public static String updateBillings(List<ConsolBill__c> jsonRecords, String billString) {
    System.debug('checkdebug1 :'+billString);
    // String u = '[{"Id":"a058d00000AhkaaAAB","Name":"MC-000007","MasterBilling__c":"a058d00000AhkauAAB","PricingName__c":"a0J8d000004TaQgEAK","ChargeUnit__c":"Container","Quantity__c":"7","Container_Type__c":"20\'DC","CurrencySelling__c":"USD","UnitPriceofSellingActual__c":0,"TaxRatioSelling__c":10,"Tax_Included_Selling__c":false,"PaymentTo__c":"0018d00000lU4oUAAS","UnitPriceofBuyingActual__c":1,"Tax_Included__c":false,"Consol_Bills__r":[{"MasterBilling__c":"a058d00000AhkaaAAB","Id":"a058d000009ad21AAA","Quantity__c":"8"},{"MasterBilling__c":"a058d00000AhkaaAAB","Id":"a058d00000AhkakAAB"}]';
    List<Object> input = (List<Object>)JSON.deserializeUntyped(billString);
    System.debug('checkdebug2 :'+input);
    Map<String, Object> results = new Map<String, Object>();
    Map<String, Object> resultsRelationship = new Map<String, Object>();
    List<List<Object>> lstCustomers = new List<List<Object>>();
    List<Object> lstCustomerstest = new List<Object>();
    List<ConsolBill__c> lstBillDetails = new List<ConsolBill__c>();
    List<ConsolBill__c> lstBillRelationship = new List<ConsolBill__c>();
    Set<String> setId = new Set<String>();
    for (Integer i=0;i < input.size();i++) {
      results = (Map<String, Object>)input[i];  
      System.debug('recordsMap :'+results);
      ConsolBill__c consolidatedRecord = new ConsolBill__c();

      if(results.get('Consol_Bills__r') != null){
        lstCustomers.add((List<Object>)results.get('Consol_Bills__r'));
      }
      System.debug('lstCustomerssss :'+lstCustomers.size());
    }
    System.debug('lstBillDetails :'+lstBillDetails);
    System.debug('lstCustomersSize :'+lstCustomers.size());
    // Map<String, Object> results = (Map<String, Object>)JSON.deserializeUntyped(billString);
    System.debug('results :'+results);
    
    System.debug('lstCustomers :'+lstCustomers);
    // for (Integer i=0;i < lstCustomers.size();i++) {
    //   for (Integer j=0;j < lstCustomers[i].size();j++) {
    //     ConsolBill__c billRecord = new ConsolBill__c();
    //     billRecord.ChargeUnit__c = (String)lstCustomers[i][j].get('ChargeUnit__c');
    //     lstBillRelationship.add(billRecord);
    //   }

    // }
    for (List<Object> lstOb : lstCustomers) {
        for (Object ob : lstOb) {
          // ConsolBill__c billRecord = new ConsolBill__c();
          // billRecord.ChargeUnit__c = (String)ob.get('ChargeUnit__c');
          lstCustomerstest.add(ob);
        }
    }
    System.debug('lstCustomerstest :'+lstCustomerstest);

    for(Integer i=0; i<lstCustomerstest.size(); i++){
      resultsRelationship = (Map<String, Object>)lstCustomerstest[i];
      System.debug('resultsRelationship :'+resultsRelationship);
      ConsolBill__c billRecord = new ConsolBill__c();
      billRecord.ChargeUnit__c = (String)resultsRelationship.get('ChargeUnit__c');
      billRecord.Container_Type__c = (String)resultsRelationship.get('Container_Type__c');
      billRecord.FTMSSO__c = (String)resultsRelationship.get('FTMSSO__c');
      billRecord.Id = (String)resultsRelationship.get('Id');
      billRecord.PaymentTo__c = (String)resultsRelationship.get('PaymentTo__c');
      billRecord.Invoiceto__c = (String)resultsRelationship.get('Invoiceto__c');
      billRecord.PricingName__c = (String)resultsRelationship.get('PricingName__c');
      billRecord.CurrencySelling__c = (String)resultsRelationship.get('CurrencySelling__c');
      billRecord.CurrencyBuying__c = (String)resultsRelationship.get('CurrencyBuying__c');
      // billRecord.UnitPriceofSellingActual__c = (Decimal)resultsRelationship.get('UnitPriceofSellingActual__c');
      billRecord.UnitPriceofSellingActual__c = Integer.valueOf(String.valueOf(resultsRelationship.get('UnitPriceofSellingActual__c')));
      System.debug('checktype :'+resultsRelationship.get('Quantity__c'));
      billRecord.Quantity__c = Integer.valueOf(String.valueOf(resultsRelationship.get('Quantity__c')));
      // billRecord.TaxRatioBuying__c = (Decimal)resultsRelationship.get('TaxRatioBuying__c');
      billRecord.TaxRatioBuying__c = Integer.valueOf(String.valueOf(resultsRelationship.get('TaxRatioBuying__c')));
      // billRecord.TaxRatioSelling__c = (Decimal)resultsRelationship.get('TaxRatioSelling__c');
      billRecord.TaxRatioSelling__c = Integer.valueOf(String.valueOf(resultsRelationship.get('TaxRatioSelling__c')));
      billRecord.Tax_Included_Selling__c = Boolean.valueOf(String.valueOf(resultsRelationship.get('Tax_Included_Selling__c')));
      // billRecord.UnitPriceofBuyingActual__c = (Decimal)resultsRelationship.get('UnitPriceofBuyingActual__c');
      billRecord.UnitPriceofBuyingActual__c = Integer.valueOf(String.valueOf(resultsRelationship.get('UnitPriceofBuyingActual__c')));
      // billRecord.Tax_Included__c = (Boolean)resultsRelationship.get('Tax_Included__c');
      billRecord.Tax_Included__c = Boolean.valueOf(String.valueOf(resultsRelationship.get('Tax_Included__c')));
      lstBillRelationship.add(billRecord);
    }
    System.debug('lstBillRelationship :'+lstBillRelationship);
    
    // for (Object customer : lstCustomers) {
    //   // now get attributes for this customer.
    //   Map<String, Object> customerAttributes = (Map<String, Object>)customer;
    //   // now loop through our customer attributes.
    //   for (String attributeName : customerAttributes.keyset()) {
    //       System.debug('========> ' + attributeName + ' = ' + 
    //           customerAttributes.get(attributeName));
    //   }
    // }
    
    // List<ConsolBill__c> recordsUpdate = new List<ConsolBill__c>();
    // List<ConsolBill__c> recordsReUpdate = new List<ConsolBill__c>();
    // Set<String> setId = new Set<String>();

    // for (Object ob : input) {
    //     if(!setId.contains(ob.get('Id'))){
    //       recordsReUpdate.add((ConsolBill__c)ob);
    //     }
    // }
    // System.debug('recordsReUpdate :'+recordsReUpdate);



    System.debug('Thong Debug 2 :'+input);
    
    List<ConsolBill__c> lstIdChild = new List<ConsolBill__c>();
    System.debug('Thong Debug :'+jsonRecords);
    Set<Id> ids = (new Map<Id, SObject>(jsonRecords)).keySet();
    Set<Id> idsRelationship = (new Map<Id, SObject>(lstBillRelationship)).keySet();
    System.debug('Idd :' + ids);
    System.debug('idsRelationship :' + idsRelationship);
    List<ConsolBill__c> billings = [SELECT Id,
        
        Name,
        MasterBilling__c,
        PricingName__c,
        FTMSSO__c,
        ChargeUnit__c,
        Quantity__c,
        Container_Type__c,
        Invoiceto__c,
        CurrencySelling__c,
        UnitPriceofSellingActual__c,
        TaxRatioSelling__c,
        Tax_Included_Selling__c,
        PaymentTo__c,
        UnitPriceofBuyingActual__c,
        TaxRatioBuying__c,
        Tax_Included__c
      FROM ConsolBill__c
      WHERE Id IN :ids
      ORDER BY Name
    ];
    System.debug('debug2 :' + billings);
    /////Query bill relationship
    List<ConsolBill__c> billingRelationship = [SELECT Id,
        
        Name,
        MasterBilling__c,
        PricingName__c,
        FTMSSO__c,
        ChargeUnit__c,
        Quantity__c,
        Container_Type__c,
        Invoiceto__c,
        CurrencySelling__c,
        UnitPriceofSellingActual__c,
        TaxRatioSelling__c,
        Tax_Included_Selling__c,
        PaymentTo__c,
        UnitPriceofBuyingActual__c,
        TaxRatioBuying__c,
        Tax_Included__c
      FROM ConsolBill__c
      WHERE Id IN :idsRelationship
      ORDER BY Name
    ];
    System.debug('debug3 :' + billingRelationship);

    for (ConsolBill__c childId : billings) {
      lstIdChild.addAll(childId.Consol_Bills__r);
    }
    System.debug('lstIdChild :'+lstIdChild);
    List<ConsolBill__c> itemsIdsToRemove = new List<ConsolBill__c>();
    List<ConsolBill__c> itemsIdsToRemoveRelationShip = new List<ConsolBill__c>();

    for (Integer i = 0; i < jsonRecords.size(); i++) {
      ConsolBill__c r = jsonRecords[i];

      if (billings[i].Id == r.Id) {
        System.debug('checkdebug1');
        if (
          billings[i].PricingName__c != r.PricingName__c ||
          billings[i].MasterBilling__c != r.MasterBilling__c ||
          billings[i].FTMSSO__c != r.FTMSSO__c ||
          billings[i].ChargeUnit__c != r.ChargeUnit__c ||
          billings[i].Quantity__c != r.Quantity__c ||
          billings[i].Container_Type__c != r.Container_Type__c ||
          billings[i].Invoiceto__c != r.Invoiceto__c ||
          billings[i].CurrencySelling__c != r.CurrencySelling__c ||
          billings[i].UnitPriceofSellingActual__c !=
          r.UnitPriceofSellingActual__c ||
          billings[i].TaxRatioSelling__c != r.TaxRatioSelling__c ||
          billings[i].Tax_Included_Selling__c != r.Tax_Included_Selling__c ||
          billings[i].PaymentTo__c != r.PaymentTo__c ||
          billings[i].UnitPriceofBuyingActual__c !=
          r.UnitPriceofBuyingActual__c ||
          billings[i].TaxRatioBuying__c != r.TaxRatioBuying__c ||
          billings[i].Tax_Included__c != r.Tax_Included__c 
        ) {
        System.debug('checkdebug2');

          itemsIdsToRemove.add(r);
        }
      }
      System.debug('ThongCheck :'+itemsIdsToRemove);
    
    }
    //// gán giá trị vào Relationship
    for (Integer i = 0; i < lstBillRelationship.size(); i++) {
      ConsolBill__c r = lstBillRelationship[i];

      if (billingRelationship[i].Id == r.Id) {
        System.debug('checkdebug1');
        if (
          billingRelationship[i].PricingName__c != r.PricingName__c ||
          billingRelationship[i].MasterBilling__c != r.MasterBilling__c ||
          billingRelationship[i].FTMSSO__c != r.FTMSSO__c ||
          billingRelationship[i].ChargeUnit__c != r.ChargeUnit__c ||
          billingRelationship[i].Quantity__c != r.Quantity__c ||
          billingRelationship[i].Container_Type__c != r.Container_Type__c ||
          billingRelationship[i].Invoiceto__c != r.Invoiceto__c ||
          billingRelationship[i].CurrencySelling__c != r.CurrencySelling__c ||
          billingRelationship[i].UnitPriceofSellingActual__c !=
          r.UnitPriceofSellingActual__c ||
          billingRelationship[i].TaxRatioSelling__c != r.TaxRatioSelling__c ||
          billingRelationship[i].Tax_Included_Selling__c != r.Tax_Included_Selling__c ||
          billingRelationship[i].PaymentTo__c != r.PaymentTo__c ||
          billingRelationship[i].UnitPriceofBuyingActual__c !=
          r.UnitPriceofBuyingActual__c ||
          billingRelationship[i].TaxRatioBuying__c != r.TaxRatioBuying__c ||
          billingRelationship[i].Tax_Included__c != r.Tax_Included__c 
        ) {
        System.debug('checkdebug223');

          itemsIdsToRemoveRelationShip.add(r);
        }
      }
      System.debug('ThongCheck112 :'+itemsIdsToRemoveRelationShip);
    
    }
    // for (ConsolBill__c bill : itemsIdsToRemove) {
    //   System.debug('debug 4 :' + bill.ExchangeRateSelling__c);
    // }
    System.debug('debug33  :' + itemsIdsToRemove.size());
    System.debug('debug3344  :' + itemsIdsToRemoveRelationShip.size());
    try {
      update itemsIdsToRemove;
      update itemsIdsToRemoveRelationShip;
      System.debug('checkupdate');
      return JSON.serialize(itemsIdsToRemove);
    } catch (Exception e) {
      throw new DmlException(e.getMessage());
    }
  }
}