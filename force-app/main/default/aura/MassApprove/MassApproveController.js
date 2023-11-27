({
    init : function(c, e, h) {
        let massApprove = c.get("c.massApprovePaySlip");
        massApprove.setParams({
            prId: c.get("v.recordId")
        });
        massApprove.setCallback(this, function(resp){
            let state = resp.getState();
            if(state === 'SUCCESS'){
                let mes = resp.getReturnValue();
                if(mes == ''){
                    c.set("v.mess", 'SUCCESS');
                    setTimeout(() => {
                        window.location.href = 'https://tcl-02-dev-ed.develop.lightning.force.com/'+c.get("v.recordId");
                    }, 1000);
                } else {
                    c.set("v.mess", "FAILED: "+mes);
                }
                
            } else {
                c.set("v.mess", "FAILED: "+mes);
            }
        });
        $A.enqueueAction(massApprove);
    }
})