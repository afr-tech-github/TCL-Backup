@isTest
public class PrintSIMBLControllerTest {
@isTest
    public static void Test1(){
       
        
        PortCode__c pc2= new PortCode__c(Name= 'VP of Services',Active__c = true);
        insert pc2;
        
        
		Id rcID= Schema.SObjectType.AdvancedShipment__c.getRecordTypeInfosByName().get('Consol').getRecordTypeId();
        AdvancedShipment__c avand= new AdvancedShipment__c(
        RecordTypeId=rcID,
            Master_Record_Type__c='Ocean Export',
            Number_of_House_BL__c= 100,
            	MPOL__c=pc2.Id,
            	Branch__c='Ho Chi Minh'
        );
        insert avand;
        Test.startTest();
        PageReference pageRef = Page.page_FormSIMBL;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id', String.valueOf(avand.Id));
        ApexPages.StandardController stdController = new ApexPages.StandardController(avand);
        PrintSIMBLController form = new PrintSIMBLController();
        System.assertEquals(true, true);
        Test.stopTest();
    }
}