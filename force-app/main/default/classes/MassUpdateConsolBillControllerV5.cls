public with sharing class MassUpdateConsolBillControllerV5 {
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
      SELECT (SELECT id FROM Consol_Bills__r),Id,
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
      SELECT Id,
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
    // List<ConsolBill__c> records = (List<ConsolBill__c>) System.JSON.deserialize(
    //   u,
    //   List<ConsolBill__c>.class
    // );
    // map<string,Object> resultMap = (map<string,Object>)JSON.deserializeUntyped(billString);
    // System.debug('debug1 :' + resultMap);
    List<ConsolBill__c> lstIdChild = new List<ConsolBill__c>();
    System.debug('Thong Debug :'+jsonRecords);
    Set<Id> ids = (new Map<Id, SObject>(jsonRecords)).keySet();
    System.debug('Idd :' + ids);
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

    for (ConsolBill__c childId : billings) {
      lstIdChild.addAll(childId.Consol_Bills__r);
    }
    System.debug('lstIdChild :'+lstIdChild);
    List<ConsolBill__c> itemsIdsToRemove = new List<ConsolBill__c>();

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
    // for (ConsolBill__c bill : itemsIdsToRemove) {
    //   System.debug('debug 4 :' + bill.ExchangeRateSelling__c);
    // }
    System.debug('debug3  :' + itemsIdsToRemove.size());
    try {
      update itemsIdsToRemove;
      return JSON.serialize(itemsIdsToRemove);
    } catch (Exception e) {
      throw new DmlException(e.getMessage());
    }
  }
}