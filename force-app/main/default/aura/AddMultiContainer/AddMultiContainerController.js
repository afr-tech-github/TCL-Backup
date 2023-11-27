({
    doinit: function (component,event,helper){
        var action = component.get("c.getPiklistValues");
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log(state);
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                var plValues = [];
                for (var i = 0; i < result.length; i++) {
                    plValues.push({
                        label: result[i],
                        value: result[i]
                    });
                }
                component.set("v.cargoUnitList", plValues);
            }
        });
        $A.enqueueAction(action);
        console.log('pickList:' + component.get("v.cargoUnitList"));
        $A.enqueueAction(component.get('c.addRow'));
    },
    addRow: function(component, event, helper) {
        //get the account List from component  
        var contList = component.get("v.contList");
        //Add New Account Record
        contList.push({
            'sobjectType': 'ConsolCNTR__c',
            'Container_Number__c':'',
            'Seal_Number__c': '',
            'Container_Type__c': '',
            'Cargo_Quantity__c': '', 
            'Cargo_Unit__c': '', 
            'Gross_WeightKg__c': '', 
            'Net_WeightKg__c': '', 
            'MeasurementCBM__c': '', 
        });
        component.set("v.contList", contList);
        console.log('contList:' + JSON.stringify(contList));

    },
    
    removeRecord: function(component, event, helper) {
        //Get the account list
        var contList = component.get("v.contList");
        //Get the target object
        var selectedItem = event.currentTarget;
        //Get the selected item index
        var index = selectedItem.dataset.record;
        //Remove single record from account list
        contList.splice(index, 1);
        //Set modified account list
        component.set("v.contList", contList);
    },
    	
    saveConts: function(component, event, helper) {      
        if (helper.validateAccountRecords(component, event)) {
            //Call Apex method and pass account list as a parameters
            var spinner = component.find("spinner");
            $A.util.toggleClass(spinner, "slds-hide");
            var con = component.get("v.recordId");
            var action = component.get("c.saveContList");
            action.setParams({
                "contList": component.get("v.contList"),
                "shipmentId": component.get("v.recordId"),
            });

            console.log('action:' + JSON.stringify(action));
            console.log('action:' + JSON.stringify(con));

            action.setCallback(this, function(response) {
                //get response status 
                var state = response.getState();
                if (state === "SUCCESS") {
                    //set empty account list
                    component.set("v.contList", []);
                    $A.util.toggleClass(spinner, "slds-hide");
                    var res = response.getReturnValue();
                    console.log('123: '+res);
                    if (res === null){
                        alert('Container saved successfully');
                        $A.enqueueAction(component.get('c.addRow'));
                        // var url = "/lightning/r/clofor_com_cfs__CustomObject1__c/" + component.get("v.recordId")+"/view";
                        // window.open(url, "_self")
                        eval("$A.get('e.force:refreshView').fire();");
                    } else {
                        alert(res);
                        var url = "/lightning/r/AdvancedShipment__c/" + component.get("v.recordId")+"/view";
                        window.open(url, "_self")
                    }
                    
                } else {
                    var errors = response.getError();
                    console.log(errors);
                    // alert(errors);
                }
            }); 
            console.log('action:' + JSON.stringify(action));
            $A.enqueueAction(action);
            
            // $A.util.toggleClass(spinner, "slds-hide");

       }
    },
    onToggleSpinner: function(cmp){
        var spinner = cmp.find("spinner");
        $A.util.toggleClass(spinner, "slds-hide");
    },
})