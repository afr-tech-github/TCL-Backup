trigger CntrinTransTrigger on CntrinTrans__c (before insert, before update, before delete, after insert, after update) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            for (CntrinTrans__c cntr : Trigger.new) {
                if(cntr.Cargo_Unit__c != null){
                    cntr.Cargo_Unit_Text__c = CNTRClass.convertToPlural(cntr.Cargo_Unit__c);
                }
            }
        }
        if (Trigger.isUpdate) {
            for (CntrinTrans__c cntr : Trigger.new) {
                if(cntr.Cargo_Unit__c != null){
                    cntr.Cargo_Unit_Text__c = CNTRClass.convertToPlural(cntr.Cargo_Unit__c);
                }
            }
        }
        if (Trigger.isDelete) {
            CNTRClass.readContainerandCargoesDelete(Trigger.old);
        }
    }
    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            CNTRClass.readContainerandCargoesInsertandUpdate(Trigger.new);
        }
        if (Trigger.isUpdate) {
            CNTRClass.readContainerandCargoesInsertandUpdate(Trigger.new);
        }
    }
    

}