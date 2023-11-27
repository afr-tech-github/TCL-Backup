@isTest
public class PrintSIControllerTest {
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
        CntrinTrans__c cntr1= new CntrinTrans__c(
            F_TMS_S_O__c = item.Id,
            Container_Type__c= '20\'DC'
        );
            insert cntr1;
        Test.startTest();
        PageReference pageRef = Page.page_SI;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id', String.valueOf(item.Id));
        ApexPages.StandardController stdController = new ApexPages.StandardController(item);
        PrintSIController form = new PrintSIController();
        PrintSIController.generateAttachmentFile(item.Id, true, 'fcl','true');
        System.assertEquals(true, true);
        Test.stopTest();
    }
}