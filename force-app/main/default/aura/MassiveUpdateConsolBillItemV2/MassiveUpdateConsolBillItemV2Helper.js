({
	findFieldCmps : function(cmp) {
        var cmps = cmp.find('field'), formattedCmps = [];
        console.log('log field');
        if(!cmps) return {};
        if ($A.util.isArray(cmps)) {
            formattedCmps = cmps;
        } else {
            formattedCmps = [cmps];
        }
        return formattedCmps;
	},
	onToggleSpinner: function(cmp){
        var spinner = cmp.find("spinner");
        $A.util.toggleClass(spinner, "slds-hide");
    },
    initial : function(component) {
        component.set("v.isLoading", true);
        var GetData = component.get("c.getListWapper");

        GetData.setParams({
            ShipID: component.get("v.recordId"),
            pagination:1
        });
        GetData.setCallback(this, function(response) {
            var result = response.getReturnValue();
            var doc = result.DocList; 
            var detal = result.DocListDT; 
            console.log('loggg :'+detal);
           component.set("v.listDetail",detal);

            var x = doc.map((item)=>{
                var dt =  detal.filter(function(dti) {
                    return dti.MasterBilling__c == item.Id;
                  });
                return {
                    Doc: item,
                    DocDT :dt
                }
            })
            // component.set("v.ListWapper", result);
           component.set("v.ListWapper",x);
            console.log("resultxxxxxxxx",x);
        })
        $A.enqueueAction(GetData)
        component.set("v.selectedPK",[]);

        component.set("v.isLoading", false);
    },
})