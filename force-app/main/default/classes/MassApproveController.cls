public with sharing class MassApproveController {
    @AuraEnabled
    public static String massApprovePaySlip(String prId){
        try {
            List<Payslip__c> listPaySlip = [SELECT Id FROM Payslip__c WHERE Payroll__c = :prId AND Status__c != 'Employee Approved' AND Status__c != 'HR Approved'];
            List<String> listPSId = new List<String>();
            for(Payslip__c ps : listPaySlip){
                listPSId.add(ps.Id);
            }
            List<ProcessInstance> listPI = [SELECT Id,TargetObjectId,TargetObject.Name,CreatedDate,
            (SELECT ID FROM WorkItems),
            (SELECT Id, StepStatus, CreatedDate, ProcessNodeId, ProcessNode.Name, Comments 
                                                FROM StepsAndWorkitems WHERE ProcessNodeId = '04b8d0000010wS9AAI' AND StepStatus = 'Pending' ORDER BY CreatedDate) FROM ProcessInstance WHERE TargetObjectId IN :listPSId AND ProcessDefinitionId = '04a8d0000010wUCAAY'];
            

            List<Approval.ProcessWorkitemRequest> lstWorkItemRequest = new List<Approval.ProcessWorkitemRequest>();
            for(ProcessInstance pi : listPI){
                for(Integer i=0; i<pi.StepsAndWorkitems.size(); i++){
                    Approval.ProcessWorkitemRequest objWorkItemRequest = new Approval.ProcessWorkitemRequest();
                    objWorkItemRequest.setComments('Approved');
                    objWorkItemRequest.setAction('Approve');//approve or reject
                    objWorkItemRequest.setWorkitemId(pi.StepsAndWorkitems[0].Id);
                    lstWorkItemRequest.add(objWorkItemRequest);
                }
            }
            String message = '';
            Integer recordsProcessed = 0;
            Approval.ProcessResult[] lstProcessResult = Approval.process(lstWorkItemRequest,FALSE);
            for(Approval.ProcessResult processResult : lstProcessResult){
                if(processResult.isSuccess()){
                    recordsProcessed++;
                }
                else{
                    for(Database.Error error : processResult.getErrors()){
                        message += error.getMessage();
                    }
                }
            }
            if(listPaySlip.size() <= 0){
                message = 'Zero payslip';
            }
            if(recordsProcessed == listPI.size() && message == ''){
                message = '';
            }
            return message;
           
        } catch (Exception e) {
            System.debug(999);
            throw new AuraHandledException(e.getMessage());
            // return null;
        }
        
    }
}