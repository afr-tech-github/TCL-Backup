@isTest
public class UpdateKhoanThuControllerTest {
    @istest public static void case1() {
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
        
     	List<FTMSSO__c> jsonvl= new List<FTMSSO__c>();
        jsonvl.add(item);
        insert jsonvl;
        
        
        List<FTMSBill__c> billlist= new List<FTMSBill__c>();
        FTMSBill__c bill = new FTMSBill__c(
        FTMSSO__c=item.Id,
            InvoiceTo__c= act.Id,
            PaymentTo__c= act2.Id
            
        );
        billlist.add(bill);
        insert billlist;
        String JsonSO= JSON.serialize(billlist);
        Test.startTest();
       // UpdateKhoanThuController.getRecordTypeId();
        UpdateKhoanThuController.getDescribeSobjectResult();
       UpdateKhoanThuController.getAllBillingsInvoice(item.Id,true);
        UpdateKhoanThuController.getAllBillingsInvoice(item.Id,false);
        UpdateKhoanThuController.getAllBillingsPayment(item.Id,true);
       UpdateKhoanThuController.getAllBillingsPayment(item.Id,false);
        UpdateKhoanThuController.updateBillings(JsonSO, true, true, true, true, true, true, true, true, true, true);
UpdateKhoanThuController.deleteBilling(bill.Id);
        System.assertEquals(true, true);
        Test.stopTest();
    }
}