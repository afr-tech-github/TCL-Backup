({
    init : function(component, event, helper) {
        window.parent.location = 'https://tcl-02-dev-ed.develop.lightning.force.com/'+component.get("v.recId");
	}
})