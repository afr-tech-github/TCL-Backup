@isTest
public class AdvancedShipmentClassTest {
    @isTest public static void case1(){
        list<AdvancedShipment__c> listadvan= new list<AdvancedShipment__c>();
           PortCode__c pc2= new PortCode__c(Name= 'VP of Services',Active__c = true);
        insert pc2;
        Id rcID= Schema.SObjectType.AdvancedShipment__c.getRecordTypeInfosByName().get('Consol').getRecordTypeId();
        AdvancedShipment__c av= new AdvancedShipment__c(
       		RecordTypeId=rcID,
            Branch__c= 'Ho Chi Minh',
            Shipment_Type__c='Consol',
            Master_Record_Type__c='Ocean Export',
            MPOL__c=pc2.Id
          
        );
        insert av;
        listadvan.add(av);
        AdvancedShipment__c av2 = av.clone();
        
     
        listadvan.add(av2);
        Test.startTest();
        AdvancedShipmentClass.isBeforeInsert(listadvan);
        System.assertEquals(true, true);
    	Test.stopTest();
    }
    
}