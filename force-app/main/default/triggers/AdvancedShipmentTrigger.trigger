trigger AdvancedShipmentTrigger on AdvancedShipment__c (before insert, before update) {
    if (trigger.isBefore) {
        if (trigger.isInsert) {
            AdvancedShipmentClass.isBeforeInsert(Trigger.new);
        }
        if (trigger.isUpdate) {
            AdvancedShipmentClass.isBeforeUpdate(Trigger.new);
            
        }
    }
}