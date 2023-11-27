({
	doInit : function(component, event, helper) {
	
	},
	handleGenerate : function(component, event, helper){
        var isCreateAttachment = component.get("v.isCreateAttachment");

        var recordId = component.get("v.recordId");
        if(isCreateAttachment){
            helper.createAttachment(component, event);
            var url = '/apex/page_PrintAN_Air_Attachment?id=' + recordId; 
            window.open(url, '_blank');
        }
        else{
            var url = '/apex/page_PrintAN_Air?id=' + recordId;
            window.open(url, '_blank');
        }
        


    }
})