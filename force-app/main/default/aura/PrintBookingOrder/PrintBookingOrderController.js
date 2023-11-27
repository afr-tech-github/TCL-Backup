({
	doInit : function(component, event, helper) {
	
	},
	handleGenerate : function(component, event, helper){
        var isCreateAttachment = component.get("v.isCreateAttachment");

        var recordId = component.get("v.recordId");
        if(isCreateAttachment){
			console.log("SURE_1?");
            helper.createAttachment(component, event);
            var url = '/apex/page_PrintBookingOrder_Attachment?id=' + recordId; 
            window.open(url, '_blank');
        }
        else{
            var url = '/apex/page_PrintBookingOrder?id=' + recordId;
            window.open(url, '_blank');
        }
        


    }
})