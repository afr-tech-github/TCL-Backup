({
	createAttachment : function(component, event) {
        var recordId = component.get("v.recordId");

        var action = component.get("c.createAttatchment");
        console.log('###recordId##' + component.get("v.recordId"))
        action.setParams({
            "recordId" : recordId
        });
        action.setCallback(this, function(response) {
                var state = response.getState();
                //debugger;
                if(component.isValid() && state === "SUCCESS") {
                   console.log('response state: ' + state);
                    
                } else {
                    console.log('Problem getting RelatedRecordList, response state: ' + state);
                }
        });
        $A.enqueueAction(action);
    }
})