({
    doinit: function (component,event,helper){
      $A.enqueueAction(component.get('c.addRow'));
    },
    addRow: function(component, event, helper) {
        //get the account List from component  
        var billList = component.get("v.billList");
        //Add New Account Record
        billList.push({
            'sobjectType': 'FTMSBill__c',
            'Service__c': '',
            'ChargeQuantity__c': '',
            'ChargeUnit__c': '',
            'ContainerType__c': '',
            'Description__c': '', 
            'AdvancePaymentonbehalfofCustomer__c':false,
            'InvoiceTo__c': '', 
            'UnitPriceofSellingLocal__c': '', 
            'TaxIncluded__c': false,
            'CurrencySelling__c': '', 
            'IssuedTaxInvSelling__c': false, 
            'TaxRateSelling__c': '', 
            'PaymentTo__c': '', 
            'UnitPriceofBuyingLocal__c': '', 
            'TaxIncludedBuying__c':false, 
            'CurrencyBuying__c': '', 
            'IssuedTaxInvBuying__c':false,
            'TaxRateBuying__c': '', 
            
        });
        component.set("v.billList", billList);
        console.log('billList:' + JSON.stringify(billList));

    },
    
    removeRecord: function(component, event, helper) {
        //Get the account list
        var billList = component.get("v.billList");
        //Get the target object
        var selectedItem = event.currentTarget;
        //Get the selected item index
        var index = selectedItem.dataset.record;
        //Remove single record from account list
        billList.splice(index, 1);
        //Set modified account list
        component.set("v.billList", billList);
    },
    	
    saveBills: function(component, event, helper) {      
        if (helper.validateAccountRecords(component, event)) {
            //Call Apex method and pass account list as a parameters
            var spinner = component.find("spinner");
            $A.util.toggleClass(spinner, "slds-hide");
            var con = component.get("v.recordId");
            var action = component.get("c.saveBillList");
            action.setParams({
                "billList": component.get("v.billList"),
                "shipmentId": component.get("v.recordId"),
            });
            console.log('action:' + JSON.stringify(action));
            console.log('action:' + JSON.stringify(con));
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    //set empty account list
                    component.set("v.billList", []);
                    $A.util.toggleClass(spinner, "slds-hide");
                    var res = response.getReturnValue();
                    console.log('123: '+res);
                    if (res === null){
                        alert('Bill saved successfully');
                        $A.enqueueAction(component.get('c.addRow'));
                        // var url = "/lightning/r/clofor_com_cfs__CustomObject1__c/" + component.get("v.recordId")+"/view";
                        // window.open(url, "_self")
                        eval("$A.get('e.force:refreshView').fire();");
                        // helper.callUpdateRefresh();
                    } else {
                        alert(res);
                        var url = "/lightning/r/FTMSSO__c/" + component.get("v.recordId")+"/view";
                        window.open(url, "_self")
                    }
                    
                } else {
                    var errors = response.getError();
                    console.log(errors);
                    // alert(errors);
                }
                //get response status 
                //var state = response.getState();
                //if (state === "SUCCESS") {
                //    component.set("v.billList", []);
                //  $A.util.toggleClass(spinner, "slds-hide");
                //    alert('Bill saved successfully');
                //    $A.enqueueAction(component.get('c.addRow'));
                //    // eval("$A.get('e.force:refreshView').fire();");
                //    $A.get('e.force:refreshView').fire();
                //    helper.callUpdateRefresh();
                    
                //} else {
                //    var url = "/lightning/r/FTMSSO__c/" + component.get("v.recordId")+"/view";
                //    var errors = response.getError();
                //    console.log(errors);
                    //window.open(url, "_self");
                //}
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