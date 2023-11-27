public with sharing class PositionTreeController {

    @AuraEnabled
    public static List<Employee__c> getPositionById(String id){
        List<Employee__c> rsList = new List<Employee__c>();
        String tmpId = id;
        Employee__c rs;
        while(tmpId != null){
            rs = [SELECT Id, Name, ReportTo__c, Position__r.Name FROM Employee__c WHERE Id = :tmpId];
            rsList.add(rs);
            tmpId = rs.ReportTo__c;
        }
        return rsList;
    }

    @AuraEnabled
    public static List<Employee__c> getAllPosition(String id){
        List<Employee__c> rsList = new List<Employee__c>();
        List<Employee__c> listRs;
        List<String> ids = new List<String>();
        ids.add(id);
        while(ids.size() > 0){
            try{
                listRs = [SELECT Id, Name, ReportTo__c, Position__r.Name FROM Employee__c WHERE ReportTo__c IN :ids];
            } catch(Exception e){
                listRs = new List<Employee__c>();
            }
            ids = new List<String>();
            for(Employee__c item : listRs){
                ids.add(item.Id);
                rsList.add(item);
            }
        }

        return rsList;
    }
}