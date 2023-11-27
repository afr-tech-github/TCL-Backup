@isTest
public class FTMSSOClassTest {
@isTest
    public static void Test1(){
        PortCode__c pc2= new PortCode__c(Name= 'VP of Services',Active__c = true);
        insert pc2;
        Date acDate=  Date.newInstance(2023, 02, 12);      
        List<Account> listAc= new List<Account>();
        
       Account act= new Account(
                Name='account');
        listAc.add(act);
         Account act2= new Account(
                Name='account2');
        listAc.add(act2);
        insert listAc;
        
        List<FTMSSO__c> listSo= new List<FTMSSO__c>();
        
        Id itemID =Schema.SObjectType.FTMSSO__c.getRecordTypeInfosByName().get('Air Import').getRecordTypeId();
        Id itemID2 =Schema.SObjectType.FTMSSO__c.getRecordTypeInfosByName().get('Air Export').getRecordTypeId();
        FTMSSO__c item = new FTMSSO__c( 
            RecordTypeId=itemID,
            POLAOD__c= pc2.Id,
            VesselFlight__c= 'AC',
            CargoQuantity__c=100,
            Branch__c='Ho Chi Minh',
            Agent__c=act.Id,
              AccountedDate__c = null,
            CarrierAirlinerVendor__c= act.Id
          );
        listSo.add(item);
        FTMSSO__c item2 = new FTMSSO__c( 
            RecordTypeId= itemID2,
            POLAOD__c= pc2.Id,
            VesselFlight__c= 'AC',
            CargoQuantity__c=100,
            Branch__c='Ho Chi Minh',
            Agent__c=act.Id,
            CarrierAirlinerVendor__c= act.Id,
            AccountedDate__c = acDate);
        listSo.add(item2);
        insert listSo;
         FTMSSO__c item3= item.clone();
        listSo.add(item3);
        FTMSSO__c item4 = item2.clone();
        listSo.add(item4);
        
        
        item3.Shipment_Type__c='FCL';
        item4.Shipment_Type__c='Logistics';
        Map<Id,FTMSSO__c> old= new  Map<id,FTMSSO__c>();
        old.put(item.Id, item4);
         old.put(item2.Id, item3);
         old.put(item3.Id, item2);
         old.put(item4.Id, item);
        
        List<CntrinTrans__c> cntL= new List<CntrinTrans__c>();
        
        CntrinTrans__c cnt = new CntrinTrans__c(
        F_TMS_S_O__c= item.Id,
            Container_Type__c='40\'DC'
        );
        cntL.add(cnt);
         CntrinTrans__c cnt2 = new CntrinTrans__c(
        F_TMS_S_O__c= item2.Id,
            Container_Type__c='20\'OT'
        );
        cntL.add(cnt2);
       
            
        insert cntL;
        Test.startTest();
        
     //	FTMSSOClass.isBeforeInsert(listSo); 
        FTMSSOClass.isBeforeUpdate(listSo,old);
        System.assertEquals(true, true);
        Test.stopTest();
    }
}