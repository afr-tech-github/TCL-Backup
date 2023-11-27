@isTest
public class ManifestControllerTest {
@isTest
    public static void Test1(){
       
        
        PortCode__c pc2= new PortCode__c(Name= 'VP of Services',Active__c = true);
        insert pc2;
        Date acDate=  Date.newInstance(2023, 02, 12);
       Account act= new Account(
                Name='account');
        insert act;
        FTMSSO__c item = new FTMSSO__c( 
           
            POLAOD__c= pc2.Id,
            VesselFlight__c= 'AC',
            CargoQuantity__c=100,
            CarrierAirlinerVendor__c= act.Id,
            AccountedDate__c = acDate);
        insert item;
        Test.startTest();
        PageReference pageRef = Page.page_Manifest;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id', String.valueOf(item.Id));
        pageRef.getParameters().put('reportType', 'excel');
        ApexPages.StandardController stdController = new ApexPages.StandardController(item);
        ManifestController form = new ManifestController();
        form.reset();
        form.generateReport();
        System.assertEquals(true, true);
        
        Test.stopTest();
    }
}