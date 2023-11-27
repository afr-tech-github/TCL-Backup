({
    doInit : function(component, event, helper) {

    },
    handleGenerate: function (component, event, helper) {
        // var isCreateAttachment = component.get("v.isCreateAttachment");
       
        // console.log('123 :'+isCreateAttachment);

        var isCreateAttachment = component.get("v.isCreateAttachment");

        var recordId = component.get("v.recordId");
        if(isCreateAttachment){
            helper.createAttachment(component, event);
        }
        
     
        // var recordId = component.get("v.recordId");
        // if (isCreateAttachment) {
        //     helper.createAttachment(component, event);
        // }

        console.log('recordId :'+component.get("v.backGround"));
        var url;
        if(component.get("v.backGround") === 'false'){
            url = "/apex/page_HAWB2?id=" + recordId;
        }else{
            url = "/apex/page_HAWB3?id=" + recordId;
        }
        // var page = 'page_HBL';
        // var url = "/apex/page_HAWB?id=" + recordId;
        // url += '&isCreateAttachment=' + isCreateAttachment;
        console.log(url);
        window.open(url,'_blank');
        // var urlEvent = $A.get("e.force:navigateToURL");
        // console.log("url: " + url);
        // urlEvent.setParams({
        //     url: url
        // });
        // urlEvent.fire();
    }
})