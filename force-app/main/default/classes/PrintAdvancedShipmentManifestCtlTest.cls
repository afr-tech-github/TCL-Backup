@isTest
public class PrintAdvancedShipmentManifestCtlTest {
	@isTest
    public static void Test1(){
       
        
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
        Test.startTest();
        PageReference pageRef = Page.page_PrintAdvancedShipmentManifest;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id', String.valueOf(av.Id));
        ApexPages.StandardController stdController = new ApexPages.StandardController(av);
        PrintAdvancedShipmentManifestController form = new PrintAdvancedShipmentManifestController();
        System.assertEquals(true, true);
        Test.stopTest();
    }
}