/* eslint-disable capitalized-comments */
({
    doInit: function (component, event, helper) {
        console.log(component.get("v.recordId"));
        var action = component.get("c.checkTypeHBL");
        action.setParams({
            "recordId": component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('response state: ' + state);
                component.set('v.typeHBL', response.getReturnValue());
            }
            else if (state === "INCOMPLETE") {
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                            errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
        var getDescribeSobjectResult = component.get("c.checkApp");
        getDescribeSobjectResult.setParams({shipmentID: component.get("v.recordId")});
        getDescribeSobjectResult.setCallback(this, function (response) {
            var state = response.getState();
            console.log('getDescribeSobjectResult: ', response);
            if (state === "SUCCESS") {
                var res = response.getReturnValue();
                console.log(res);
                if(res === true){
                    component.set("v.checkAll",true);
                }if(res === false){
                    component.set("v.checkApp",true);
                }
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                console.log("Error message: " + errors);
            }

        });
        $A.enqueueAction(getDescribeSobjectResult);
    },
    handleGenerate: function (component, event, helper) {
        var isCreateAttachment = component.get("v.isCreateAttachment");
        var isShowCont = component.get("v.isShowCont");
        console.log('123 :'+isCreateAttachment);
        // var isCreateNumber = component.get("v.isNumber");
        var recordId = component.get("v.recordId");
        // var type = component.get("v.type");
        var type = component.get("v.typeHBL");
        var backGround = component.get("v.backGround");

        if (isCreateAttachment) {
            helper.createAttachment(component, event);
        }

        // eslint-disable-next-line no-console
        console.log("type: " + type + ", id: " + recordId + ", backGround: " + backGround);
        var page = 'page_PrintHBL';
        if (type === 'FCL'){
            page += 'Full';
        }
        if (backGround === 'false'){
            page += 'Blank';
        }
        var url =
            "/apex/"+page+"?id=" + recordId;
        url += '&type=' + type;
        url += '&backGround=' + backGround;
        url += '&isCreateAttachment=' + isCreateAttachment;
        url += '&isShowCont=' + isShowCont;
        var urlEvent = $A.get("e.force:navigateToURL");

        // eslint-disable-next-line no-console
        console.log("url: " + url);
        urlEvent.setParams({
            url: url
        });
        urlEvent.fire();
    }
});