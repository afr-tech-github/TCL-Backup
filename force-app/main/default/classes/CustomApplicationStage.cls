public with sharing class CustomApplicationStage {
    @AuraEnabled
    public static List<String> getPickListValuesIntoList(){
        List<String> pickListValuesList= new List<String>();
        Schema.DescribeFieldResult fieldResult = Applicationn__c.Stage__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
        }     
        return pickListValuesList;
    }
    @AuraEnabled
    public static string getCurrentStage(String id){
        try {
            Applicationn__c rs = [SELECT Stage__c FROM Applicationn__c WHERE Id = :id];
            return rs.Stage__c;
        } catch (Exception e) {
            return null;
        }
    }
    @AuraEnabled
    public static string markCurrentStage(String id, String curStage){
        try {
            Applicationn__c rs = [SELECT Stage__c FROM Applicationn__c WHERE Id = :id];
            rs.Stage__c = curStage;
            update rs;
            return 'SUCCESS';
        } catch (Exception e) {
            return null;
        }
    }
    @AuraEnabled
    public static List<Application_Assessment__c> getApplicationAssessmentList(String applicationId, String curStage){
        try {
            List<Application_Assessment__c> rsList = [SELECT Name, AssessorUser__r.Name, Result__c FROM Application_Assessment__c WHERE Application__c = :applicationId AND Stage__c = :curStage LIMIT 3];
            return rsList;
        } catch (Exception e) {
            return new List<Application_Assessment__c>();
        }
    }
    @AuraEnabled
    public static List<ApplicationToDoList__c> getApplicationToDoList(String applicationId, String actionF){
        try {
            List<ApplicationToDoList__c> rsList = [SELECT Name, Time__c, Status__c FROM ApplicationToDoList__c WHERE Application__c = :applicationId AND Action__c = :actionF LIMIT 3];
            return rsList;
        } catch (Exception e) {
            return new List<ApplicationToDoList__c>();
        }
    }
}