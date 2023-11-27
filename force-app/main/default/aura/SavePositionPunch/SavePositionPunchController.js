({
    init : function(component, event, helper) {
        console.log(120);
        var recordId = component.get("v.recordId");
        
        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(
                (position) => {
                    const pos = {
                        lat: position.coords.latitude,
                        lng: position.coords.longitude,
                    };
                    console.log(recordId);
                    component.set("v.frameSrc",'https://tcl-02-dev-ed--c.develop.vf.force.com/apex/RedirectPunch?id='+recordId);
                    console.log(111);
                    var savePosition = component.get("c.savePosition");
                    savePosition.setParams({
                        "recordId": recordId,
                        "latitude": pos.lat,
                        "longitude": pos.lng
                    });
                    $A.enqueueAction(savePosition);
                    
                },
                ()=>{

                }
            );
        }
        
    },
    
})