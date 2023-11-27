({
    init : function(component, event, helper) {
        var recordId = component.get("v.recordId");
        var isCheckIn = component.get("v.isCheckIn");
        
        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(
                (position) => {
                    const pos = {
                        lat: position.coords.latitude,
                        lng: position.coords.longitude,
                    };
                    component.set("v.frameSrc",'https://tcl-02-dev-ed--c.develop.vf.force.com/apex/GetGoogleMapAddress?id='+recordId+'&lat='+pos.lat+'&lng='+pos.lng+'&isCheckIn='+isCheckIn.toString());
                    var savePosition = component.get("c.savePosition");
                    savePosition.setParams({
                        "recordId": recordId,
                        "latitude": pos.lat,
                        "longitude": pos.lng,
                        "isCheckIn": isCheckIn
                    });
                    $A.enqueueAction(savePosition);
                    
                },
                ()=>{

                }
            );
        }
        
    },
    
})