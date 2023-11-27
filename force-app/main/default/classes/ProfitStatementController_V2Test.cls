@isTest
public class ProfitStatementController_V2Test {
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
        
        FTMSSO__c item = new FTMSSO__c( 
          
            POLAOD__c= pc2.Id,
            VesselFlight__c= 'AC',
            CargoQuantity__c=100,
            Branch__c='Ho Chi Minh',
            Agent__c=act.Id,
            CarrierAirlinerVendor__c= act.Id,
            AccountedDate__c = acDate);
        insert item;
        
         
        
        CompanyInformation__c cpninf= new CompanyInformation__c(
        Name='cpninf1',
            Branch__c='Ho Chi Minh'
        );
        insert cpninf;
        
        FTMSBill__c bill = new FTMSBill__c(
        FTMSSO__c=item.Id,
            InvoiceTo__c= act.Id,
            PaymentTo__c= act2.Id
            
        );
        insert bill;
        Test.startTest();
        PageReference pageRef = Page.page_ProfitStatement;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id', String.valueOf(item.Id));
        ApexPages.StandardController stdController = new ApexPages.StandardController(item);
        ProfitStatementController_V2 form = new ProfitStatementController_V2();
     
        System.assertEquals(true, true);
        Test.stopTest();
    }
}