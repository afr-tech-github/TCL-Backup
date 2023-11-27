public without sharing class AllocatePaymentController {
    public List<Connectbill__c> ConnectBills {get;set;}
    public Payment_Voucher__c PaymentVoucher {get;set;} 

    private static Set<String> fieldsConnectBillQuery = new Set<String>();
    static{
        fieldsConnectBillQuery.add('Id');
        fieldsConnectBillQuery.add('Payment_Request_Currency__c');
        fieldsConnectBillQuery.add('Total_Paid_USD__c');
        fieldsConnectBillQuery.add('Total_Paid_VND__c');
        fieldsConnectBillQuery.add('Unpaid_Balance__c');
        fieldsConnectBillQuery.add('Request_Payment_Amount__c');
        fieldsConnectBillQuery.add('Service_Name__c');
        fieldsConnectBillQuery.add('Billingid__c');
        fieldsConnectBillQuery.add('Payment_Request__r.Name');
    }
    private static Set<String> fieldsPaymentVoucherQuery = new Set<String>();
    static{
        fieldsPaymentVoucherQuery.add('Id');
        fieldsPaymentVoucherQuery.add('Payment_Amount__c');
        fieldsPaymentVoucherQuery.add('Payment_To__r.Id');
        fieldsPaymentVoucherQuery.add('Payment_Currency__c');
        fieldsPaymentVoucherQuery.add('Payment_To__r.AccountNameENG__c');
        fieldsPaymentVoucherQuery.add('Allocated_Amount__c');
    }

    
    @AuraEnabled
    public static List<Connectbill__c> QueryConnectBill(String Payment_to, String Currency_Voucher){
        
        List<Connectbill__c>ConnectBills_temp = new List<Connectbill__c>();
        String strSelect  = String.join(new List<String>(fieldsConnectBillQuery),',');
        String strQuery   = 'SELECT ' + strSelect + ' FROM Connectbill__c WHERE  Unpaid_Balance__c > 0' + 
                                'AND Payment_Request_Currency__c = \'' + Currency_Voucher + '\'' + 'AND Payment_Request__r.Payment_to__r.Id = \'' + Payment_to + '\'';
        try {
            ConnectBills_temp = Database.query(strQuery);
        } catch (Exception e) {
            ConnectBills_temp = new List<Connectbill__c>();
            throw new AuraHandledException(e.getMessage());
        }
        return ConnectBills_temp;
    }

    @AuraEnabled
    public static Payment_Voucher__c QueryPaymentVoucher(String recordId)
    {
        Payment_Voucher__c PaymentVoucher_temp = new Payment_Voucher__c();
        String strSelect  = String.join(new List<String>(fieldsPaymentVoucherQuery),',');
        String strQuery    = 'SELECT ' + strSelect + ' FROM Payment_Voucher__c WHERE Id = \'' + recordId + '\'';
        try {
            PaymentVoucher_temp = Database.query(strQuery);
        } catch (Exception e) {
            PaymentVoucher_temp = new Payment_Voucher__c();
            throw new AuraHandledException(e.getMessage());
        }
        return PaymentVoucher_temp;
    }

    @AuraEnabled
    public static Integer InsertPaymentAllocation(String CurrencyPayment, List<String> AllocateTo, String PaymentVoucherId,
                                                                                    List<decimal> Amount, List<String> ConnectBill)
    {
        List<Payment_Allocation__c> lstPaymentAllocation = new List<Payment_Allocation__c>();
        for(Integer i = 0; i < AllocateTo.size(); i++)
        {
            Payment_Allocation__c PaymentAllocation = new Payment_Allocation__c();
            if(CurrencyPayment=='USD')
            {
                PaymentAllocation.Amount_USD__c = Amount[i];
                PaymentAllocation.Amountvnd__c = 0;
            }
            else
            {
                PaymentAllocation.Amountvnd__c = Amount[i];
                PaymentAllocation.Amount_USD__c = 0;
            }
            //PaymentAllocation.Currency__c = CurrencyPayment;
            PaymentAllocation.Allocate_to__c = AllocateTo[i];   
            PaymentAllocation.AllocatetoPR__c = ConnectBill[i];
            PaymentAllocation.Payment_Voucher__c = PaymentVoucherId;
            lstPaymentAllocation.add(PaymentAllocation);
        }
        insert lstPaymentAllocation;
        return lstPaymentAllocation.size();

    }

    @AuraEnabled
    public static void UpdatePaymentVoucher(decimal CurrentAllocation,String PaymentVoucherId)
    {
        Payment_Voucher__c lstPaymentVoucher = [SELECT Id,Allocated_Amount__c FROM Payment_Voucher__c WHERE Id =: PaymentVoucherId];
        if(lstPaymentVoucher.Allocated_Amount__c != null)
        {
            lstPaymentVoucher.Allocated_Amount__c += CurrentAllocation;
        }
        else{
            lstPaymentVoucher.Allocated_Amount__c = CurrentAllocation;
        }
        update lstPaymentVoucher;
    }

    
    public AllocatePaymentController() {
    }
}