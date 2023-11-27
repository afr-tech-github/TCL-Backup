trigger FTMSSOTrigger on FTMSSO__c (before insert, before update) {
    List<FTMSSO__c> lstSO = new List<FTMSSO__c>();
    for(FTMSSO__c so : Trigger.new){
        if(so.TransportationWay__c == 'SEA'){
            if(so.JobRequestID__c == null || so.AccountedDate__c == null || so.HBLNumber__c == null){
                lstSO.add(so);
                if (trigger.isBefore) {
                    if (trigger.isInsert) {
                        FTMSSOClass.isBeforeInsert(lstSO);
                    }
                    if (trigger.isUpdate) {
                        FTMSSOClass.isBeforeUpdate(lstSO,Trigger.oldMap);
                    }
                }
                
            }
        }
        if(so.TransportationWay__c == 'AIR'){
            if(so.JobRequestID__c == null || so.AccountedDate__c == null || so.HAWBNumber__c == null){
                lstSO.add(so);
                if (trigger.isBefore) {
                    if (trigger.isInsert) {
                        FTMSSOClass.isBeforeInsert(lstSO);
                    }
                    if (trigger.isUpdate) {
                        FTMSSOClass.isBeforeUpdate(lstSO,Trigger.oldMap);
                    }
                }
                
            }
        }

    }
    
    // if (trigger.isBefore) {
    //     if (trigger.isInsert) {
    //         FTMSSOClass.isBeforeInsert(Trigger.new);
    //     }
    //     if (trigger.isUpdate) {
    //         FTMSSOClass.isBeforeUpdate(Trigger.new,Trigger.oldMap);
    //     }
    // }
}