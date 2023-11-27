({
    createAttachment : function(component, event) {
        var isCreateAttachment = component.get("v.isCreateAttachment");
        var isBackground = component.get("v.backGround");
        console.log('isCreateAttachment :'+isCreateAttachment);
        console.log('isBackground :'+isBackground);
        var recordId = component.get("v.recordId");
        console.log('recordId :'+recordId);

        var action = component.get("c.generateAttachmentFile");   
        console.log('action :'+action);
        action.setParams({
                    "recordId" : recordId,
                    "requiredAttachmentCreation" : isCreateAttachment,
                    "isBackground" : isBackground
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