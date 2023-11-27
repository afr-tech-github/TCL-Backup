trigger FTMSBillTrigger on FTMSBill__c (before insert, before update) {
	if (trigger.isBefore) {
        if (trigger.isInsert) {
            FTMSBillClass.isBeforeInsert(Trigger.new);
        }
        if (trigger.isUpdate) {
            FTMSBillClass.isBeforeUpdate(Trigger.new,Trigger.old);
        }
    }
}