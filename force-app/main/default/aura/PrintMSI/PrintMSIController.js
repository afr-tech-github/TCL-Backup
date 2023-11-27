({
	doInit : function(component, event, helper) {
	
	},
	handleGenerate : function(component, event, helper){
        var isCreateAttachment = component.get("v.isCreateAttachment");

        var recordId = component.get("v.recordId");
        console.log('isCreateAttachment1: '+isCreateAttachment)
        if(isCreateAttachment){
            console.log('isCreateAttachment: '+isCreateAttachment)
            helper.createAttachment(component, event);
        }
        
        var url = '/apex/page_FormSIMBL?id=' + recordId;
        // var url = '/apex/clofor_com_cfs__page_QuotationReportMultiCurrencyPdf?quoteId=' + recordId;
        // url += '&language=' + language;
        // url += '&isTax=' + isTax;
        // url += '&isAmount=' + isAmount;
        // url += '&isSum=' + isSum;
        window.open(url, '_blank');
        // var urlEvent = $A.get("e.force:navigateToURL");
        // urlEvent.setParams({
        //     "url": url
        // });
        // urlEvent.fire();
    }
})