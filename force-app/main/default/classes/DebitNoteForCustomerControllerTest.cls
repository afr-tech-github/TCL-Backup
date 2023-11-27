@isTest
public class DebitNoteForCustomerControllerTest {
    public static testMethod void DebitNoteCustomerTest(){
        Test.startTest();
        Date eta = Date.newInstance(2023, 02, 20);
        Date etd = Date.newInstance(2023, 02, 15);
        FTMSSO__c shipment = new FTMSSO__c(Branch__c = 'Ho Chi Minh', ETA__c = eta, ETD__c = etd);
        insert shipment;
        PageReference pageRef = Page.page_DebitNoteForCustomer; // Add your VF page Name here
        pageRef.getParameters().put('shipId', shipment.Id);
        //pageRef.getParameters().put('showInfo', 'true');
        //pageRef.getParameters().put('attachment', 'true');
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('shipId', shipment.Id);
        	DebitNoteForCustomerController DebitNote = new DebitNoteForCustomerController();
        Test.stopTest();
    }
}