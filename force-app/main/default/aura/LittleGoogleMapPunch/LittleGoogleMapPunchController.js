({
    init : function(component, event, helper) {
        var recordId = component.get("v.recordId");
        component.set("v.frameSrc",'https://tcl-02-dev-ed--c.develop.vf.force.com/apex/GoogleMapPunch?id='+recordId);
        
    }
})