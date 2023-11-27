({
    doInit : function(component, event, helper) {

    },
    handleGenerate: function (component, event, helper) {
        var isCreateAttachment = component.get("v.isCreateAttachment");
        var backGround = component.get("v.backGround");
        console.log('backGround :'+backGround);
        console.log('123 :'+isCreateAttachment);
     
        var recordId = component.get("v.recordId");
        if (isCreateAttachment) {
            helper.createAttachment(component, event);
        }
        var page = '';
        if(backGround == 'true'){
            page = 'page_HBL';
        }else{
            page = 'page_HBL_Nobackground';
        }
        
        // var page = 'page_HBL';
        var url =
            "/apex/"+page+"?id=" + recordId;
        url += '&isCreateAttachment=' + isCreateAttachment;
        url += '&backGround=' + backGround;
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