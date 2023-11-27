({
    createAttachment : function(component, event) {
        var isCreateAttachment = component.get("v.isCreateAttachment");
        var recordId = component.get("v.recordId");
        var type = component.get("v.type");
        var backGround = component.get("v.backGround");
        var action = component.get("c.generateAttachmentFile");   
        action.setParams({
                    "recordId" : recordId,
                    "requiredAttachmentCreation" : isCreateAttachment,
                    "type" : type,
                    "backGround" : backGround,
                }); 
                action.setCallback(this, function(response) {
                var state = response.getState();
                //debugger;
                if(component.isValid() && state === "SUCCESS") {
                   console.log('response state: ' + state);
                   var attachment = response.getState();
                
                } else {
                    console.log('Problem getting RelatedRecordList, response state: ' + state);
                }
                
        });
        $A.enqueueAction(action);
    }
})