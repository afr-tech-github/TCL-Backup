public class FTMSBillClass {
	public static void isBeforeInsert(List<FTMSBill__c> lstBillNew){
        for (FTMSBill__c bill : lstBillNew){
             if (bill.PaymentConfirmedSelling__c == true) {
                if (bill.AmountReceivedfromCustomerLocal__c == null || bill.AmountReceivedfromCustomerLocal__c == 0) {
                    bill.AmountReceivedfromCustomerLocal__c = bill.TotalSellingInclTaxLocal__c;
                }
    
                if (bill.AmountReceivedfromCustomer__c == null || bill.AmountReceivedfromCustomer__c == 0) {
                    bill.AmountReceivedfromCustomer__c = bill.TotalSellingInclTaxFCY__c ;
                }
            }
            
            if (bill.PaymentConfirmedBuying__c == true) {
                if (bill.AmountPaidforCustomerLocal__c == null || bill.AmountPaidforCustomerLocal__c == 0) {
                    bill.AmountPaidforCustomerLocal__c = bill.TotalBuyingInclTaxLocal__c;
                }
    
                if (bill.AmountPaidforCustomerFCY__c == null || bill.AmountPaidforCustomerFCY__c == 0) {
                    bill.AmountPaidforCustomerFCY__c = bill.TotalBuyingInclTaxFCY__c;
                }
            }
        }
    }
    public static void isBeforeUpdate(List<FTMSBill__c> lstBillNew, List<FTMSBill__c> lstBillOld){
        for (FTMSBill__c bill : lstBillNew){
            if (bill.PaymentConfirmedSelling__c == true) {
                if (bill.AmountReceivedfromCustomerLocal__c == null || bill.AmountReceivedfromCustomerLocal__c == 0) {
                    bill.AmountReceivedfromCustomerLocal__c = bill.TotalSellingInclTaxLocal__c;
                }
    
                if (bill.AmountReceivedfromCustomer__c == null || bill.AmountReceivedfromCustomer__c == 0) {
                    bill.AmountReceivedfromCustomer__c = bill.TotalSellingInclTaxFCY__c ;
                }
            }
            
            if (bill.PaymentConfirmedBuying__c == true) {
                if (bill.AmountPaidforCustomerLocal__c == null || bill.AmountPaidforCustomerLocal__c == 0) {
                    bill.AmountPaidforCustomerLocal__c = bill.TotalBuyingInclTaxLocal__c;
                }
    
                if (bill.AmountPaidforCustomerFCY__c == null || bill.AmountPaidforCustomerFCY__c == 0) {
                    bill.AmountPaidforCustomerFCY__c = bill.TotalBuyingInclTaxFCY__c;
                }
            }
        }
    }
}