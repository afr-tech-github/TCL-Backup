global with sharing class ShowReceivablePayableBatch implements Database.Batchable<sObject>, Database.Stateful {
    private List<String> ankenMeisaiIdUpdateList {get; set;}
    private FTMSBill__c objAnkenMeisaiInput {get; set;}
    private Boolean isShowReceivable {get; set;}

    global ShowReceivablePayableBatch(List<String> ankenMeisaiIdList, FTMSBill__c objAnkenMeisai, Boolean isShowReceivable) {
        this.ankenMeisaiIdUpdateList = ankenMeisaiIdList;
        this.objAnkenMeisaiInput = objAnkenMeisai;
        this.isShowReceivable = isShowReceivable;
    }

    global List<FTMSBill__c> start(Database.BatchableContext bc) {
        List<FTMSBill__c> ankenMeisaiUpdateList = new List<FTMSBill__c>();
        if (!ankenMeisaiIdUpdateList.isEmpty()) {
            for(String meisaiIdUpdate : this.ankenMeisaiIdUpdateList) {
                ankenMeisaiUpdateList.add(this.createanKenMeisaiUpdate(meisaiIdUpdate, this.objAnkenMeisaiInput, this.isShowReceivable));					
            }
        }
        return ankenMeisaiUpdateList;
	}

    global void execute(Database.BatchableContext bc, List<FTMSBill__c> ankenMeisaiUpdateList) {
        Savepoint sp;
        try {
			if (!ankenMeisaiUpdateList.isEmpty()) {
				sp = Database.setSavepoint();
				FlsService.doupdate(ankenMeisaiUpdateList);
			}
		} catch (Exception ex) {
            if (sp != null) {
				Database.rollback(sp);
			}

		}    
    }

    global void finish(Database.BatchableContext bc) {
        try {
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            string[] to = new string[] { UserInfo.getUserEmail() };
           
            email.setToAddresses(to);
            email.setSubject('ShowReceivablePayablBatch');
            String msg = 'Process done. <br/><br/>';
            email.setHtmlBody(msg);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });      
        } catch (Exception ex) {

        }
    }

    private FTMSBill__c createanKenMeisaiUpdate(String meisaiIdUpdate
                                                                    ,FTMSBill__c objAnkenMeisai
                                                                    ,Boolean isReceivable) {
        FTMSBill__c objAnkenMeisaiUpdate = new FTMSBill__c();
        objAnkenMeisaiUpdate.Id = meisaiIdUpdate;
        FTMSBill__c getBill = [SELECT Id, TotalSellingInclTaxLocal__c, TotalSellingInclTaxFCY__c, TotalBuyingInclTaxLocal__c,TotalBuyingInclTaxFCY__c FROM FTMSBill__c WHERE Id =: meisaiIdUpdate];

        if (isReceivable) {
            objAnkenMeisaiUpdate.PaymentConfirmedSelling__c = objAnkenMeisai.PaymentConfirmedSelling__c;
            objAnkenMeisaiUpdate.ApplicantSelling__c = objAnkenMeisai.ApplicantSelling__c;
            objAnkenMeisaiUpdate.PaymentTypeSelling__c = objAnkenMeisai.PaymentTypeSelling__c;
            objAnkenMeisaiUpdate.PaymentSettledDateSelling__c = objAnkenMeisai.PaymentSettledDateSelling__c;
            objAnkenMeisaiUpdate.BankAccountforReceipt__c = objAnkenMeisai.BankAccountforReceipt__c;
            objAnkenMeisaiUpdate.PaymentNotesSelling__c = objAnkenMeisai.PaymentNotesSelling__c;

            // if (objAnkenMeisai.PaymentConfirmedSelling__c == true) {
            //     if (objAnkenMeisai.AmountReceivedfromCustomerLocal__c == null || objAnkenMeisai.AmountReceivedfromCustomerLocal__c == 0) {
            //         objAnkenMeisaiUpdate.AmountReceivedfromCustomerLocal__c = objAnkenMeisai.TotalSellingInclTaxLocal__c;
            //     }
    
            //     if (objAnkenMeisai.AmountReceivedfromCustomer__c == null || objAnkenMeisai.AmountReceivedfromCustomer__c == 0) {
            //         objAnkenMeisaiUpdate.AmountReceivedfromCustomer__c = objAnkenMeisai.TotalSellingInclTaxFCY__c ;
            //     }
            // }
        } else {
            objAnkenMeisaiUpdate.PaymentConfirmedBuying__c = objAnkenMeisai.PaymentConfirmedBuying__c;
            objAnkenMeisaiUpdate.BeneficiaryBuying__c = objAnkenMeisai.BeneficiaryBuying__c;
            objAnkenMeisaiUpdate.PaymentTypeBuying__c = objAnkenMeisai.PaymentTypeBuying__c;
            objAnkenMeisaiUpdate.PaymentSettledDateBuying__c = objAnkenMeisai.PaymentSettledDateBuying__c;
            objAnkenMeisaiUpdate.BankAccountforPayment__c = objAnkenMeisai.BankAccountforPayment__c;
            objAnkenMeisaiUpdate.PaymentNotesBuying__c = objAnkenMeisai.PaymentNotesBuying__c;

            // if (objAnkenMeisai.PaymentConfirmedBuying__c == true) {
            //     if (objAnkenMeisai.AmountPaidforCustomerLocal__c == null || objAnkenMeisai.AmountPaidforCustomerLocal__c == 0) {
            //         objAnkenMeisaiUpdate.AmountPaidforCustomerLocal__c = objAnkenMeisai.TotalBuyingInclTaxLocal__c;
            //     }
    
            //     if (objAnkenMeisai.AmountPaidforCustomerFCY__c == null || objAnkenMeisai.AmountPaidforCustomerFCY__c == 0) {
            //         objAnkenMeisaiUpdate.AmountPaidforCustomerFCY__c = objAnkenMeisai.TotalBuyingInclTaxFCY__c;
            //     }
            // }
        }
        
        return objAnkenMeisaiUpdate;
    }
}