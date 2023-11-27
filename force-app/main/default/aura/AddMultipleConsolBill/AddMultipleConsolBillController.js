({
    doinit: function (component,event,helper){
      $A.enqueueAction(component.get('c.addRow'));
    },
    addRow: function(component, event, helper) {
        //get the account List from component  
        var billList = component.get("v.billList");
        //Add New Account Record
        billList.push({
            'sobjectType': 'ConsolBill__c',
            'PricingName__c': '',
            'FTMSSO__c': '',
            'ChargeUnit__c': '',
            'Quantity__c': 0,
            'Container_Type__c': '', 
            'Invoiceto__c': '',
            'CurrencySelling__c': '', 
            'CurrencyBuying__c': '', 
            'UnitPriceofSellingActual__c': 0, 
            'TaxRatioSelling__c': 0,
            'Tax_Included_Selling__c': false, 
            'PaymentTo__c': '', 
            'UnitPriceofBuyingActual__c': 0, 
            'TaxRatioBuying__c': 0, 
            'Tax_Included__c': false, 
            
        });
        component.set("v.billList", billList);
        console.log('billList:' + JSON.stringify(billList));

    },
    
    removeRecord: function(component, event, helper) {
         var msg = 'Are you sure you want to delete this item?';
        if (!confirm(msg)) {
            return;
        } else {
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
        }

    },
    	
    saveBills: function(component, event, helper) {      
        if (helper.validateAccountRecords(component, event)) {
            if(helper.validateFieldPricingName(component,event)){
                            //Call Apex method and pass account list as a parameters
            var spinner = component.find("spinner");
            $A.util.toggleClass(spinner, "slds-hide");
            const target = event.currentTarget;
            const index = target;
            console.log('index :'+index.tagName);
            const container = index.parentElement.parentElement.parentElement.parentElement.parentElement;
            console.log('container :'+container.tagName);
            const Mydiv = container.querySelector('.hideComponent');
            console.log('container :'+Mydiv.tagName);
            const Myshow = container.querySelector('.showComponent');
            console.log('container :'+Myshow.tagName);
            var displaySetting = Mydiv.style.display;
            // var spinner = component.find("spinner");
            // $A.util.toggleClass(spinner, "slds-hide");
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
                    //component.set("v.billList", []);
                    $A.util.toggleClass(spinner, "slds-hide");
                    var res = response.getReturnValue();
                    console.log('123: '+res);
                    if (res === null){
                        component.set("v.billList", []);
                        alert('Bill saved successfully');
                        $A.enqueueAction(component.get('c.addRow'));
                        // var url = "/lightning/r/clofor_com_cfs__CustomObject1__c/" + component.get("v.recordId")+"/view";
                        // window.open(url, "_self")
                        eval("$A.get('e.force:refreshView').fire();");
                        // helper.callUpdateRefresh();
                    } else {
                        // var url = "/lightning/r/ConsolBill__c/" + component.get("v.recordId")+"/view";
                        // window.open(url, "_self")
                        alert(res);
                    }
                    if(displaySetting = 'block'){
                        Mydiv.style.display='none';
                        Myshow.style.display='block';
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
            else{
                alert("You must enter the Pricing Name field");
            }
        }
        else{
            alert("null");
        }
    },
    closeCom: function(cmp,event,helper){
        const target = event.currentTarget;
        const index = target;
        console.log('index :'+index.tagName);
        const container = index.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement;
        console.log('container :'+container.tagName);
        const Mydiv = container.querySelector('.hideComponent');
        console.log('container :'+Mydiv.tagName);
        const Myshow = container.querySelector('.showComponent');
        console.log('container :'+Myshow.tagName);
        var displaySetting = Mydiv.style.display;
        if(displaySetting == 'block'){
            Mydiv.style.display='none';
            Myshow.style.display='block';
        }
    },
    showComponent: function(cmp,event,helper){
        const target = event.currentTarget;
        const index = target;
        console.log('index :'+index.tagName);
        const container = index.parentElement.parentElement;
        console.log('container :'+container.tagName);
        const Mydiv = container.querySelector('.hideComponent');
        console.log('container :'+Mydiv.tagName);
        const Myshow = container.querySelector('.showComponent');
        console.log('container :'+Myshow.tagName);
        var displaySetting = Mydiv.style.display;
        
        if(displaySetting == 'none'){
            Mydiv.style.display='block';
            Myshow.style.display='none';
        }
    },
    onToggleSpinner: function(cmp){
        var spinner = cmp.find("spinner");
        $A.util.toggleClass(spinner, "slds-hide");
    },
})