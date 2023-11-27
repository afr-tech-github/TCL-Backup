({
    myAction : function(component, event, helper) {

    },
    createBlankMultiTab: function(component, event, helper) {
        window.location.href="/apex/page_printSeaManifest?id="+component.get("v.recordId");
    },
    close: function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    }

    
})