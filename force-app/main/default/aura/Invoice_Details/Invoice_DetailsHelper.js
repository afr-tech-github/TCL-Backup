({
    initial : function(component) {
        component.set("v.isLoading", true);
        var GetData = component.get("c.getListWapper");

        var searchValue_c = component.get("v.searchValue");

    
        var type = "Invoice";
        GetData.setParams({
            ShipID: component.get("v.recordId"),
            pagination:1,
            searchValue:searchValue_c,
            recordType:type
        });
        GetData.setCallback(this, function(response) {
            var result = response.getReturnValue();
            var doc = result.DocList; 
            var detal = result.DocListDT; 
           component.set("v.listDetail",detal);

            var x = doc.map((item)=>{
                var dt =  detal.filter(function(dti) {
                    return dti.Document__c == item.Id;
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