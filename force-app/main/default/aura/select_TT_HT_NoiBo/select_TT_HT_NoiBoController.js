({
    myAction : function(component, event, helper) {

    },
    createBlankMultiTab: function(component, event, helper) {
        var isChecked = component.get("v.isChecked");

        window.location.href="/apex/page_TT_HT_NoiBo?id="+component.get("v.recordId") +"&check=" + isChecked;
    },
    close: function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    }

    
})