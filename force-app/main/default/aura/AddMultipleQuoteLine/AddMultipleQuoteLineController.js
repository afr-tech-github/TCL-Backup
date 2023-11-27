({
    doinit: function (component, event, helper) {
      $A.enqueueAction(component.get('c.addRow'));
    },
  
    addRow: function (component, event, helper) {
      var lstObject = component.get("v.lstObject");

          lstObject.push({
            sobjectType: "Quoteline__c",
            PrintingSection__c: "",
            ServiceID__c: "",
            Print__c: true,
            ChargeQuantity__c: "",
            ChargeUnit__c: "",
            Type__c: "",
            CurrencySelling__c: "",
            TaxRateSelling__c: "",
            SellingListPriceLocal__c: "",
            SellingListPriceFCY__c: "",
            // clofor_com_cfs__BuyTaxInitial__c: "",
            Remarks__c: ""
          });
          component.set("v.lstObject", lstObject);
      console.log(JSON.stringify(lstObject))
    },
  
    removeRecord: function (component, event, helper) {
      var lstObject = component.get("v.lstObject");
      var selectedItem = event.currentTarget;
      var index = selectedItem.dataset.record;
      lstObject.splice(index, 1);
      component.set("v.lstObject", lstObject);
    },
  
    saveBills: function (component, event, helper) {
      // if (helper.validateAccountRecords(component, event)) {
        var spinner = component.find("spinner");
        $A.util.toggleClass(spinner, "slds-hide");
  
        var action = component.get("c.saveQuoteLineList");
        action.setParams({
          quoteLineList: component.get("v.lstObject"),
          quoteId: component.get("v.recordId")
        });
  
        action.setCallback(this, function (response) {
             var state = response.getState();
                if (state === "SUCCESS") {
                    //set empty account list
                    component.set("v.lstObject", []);
                    $A.util.toggleClass(spinner, "slds-hide");
                    var res = response.getReturnValue();
                    console.log('123: '+res);
                    if (res === null){
                        alert('Bill saved successfully');
                        $A.enqueueAction(component.get('c.addRow'));

                        eval("$A.get('e.force:refreshView').fire();");
                    } else {
                        alert(res);
                        var url = "/lightning/r/Quote__c/" + component.get("v.recordId")+"/view";
                        window.open(url, "_self")
                    }
                    
                } else {
                    var errors = response.getError();
                    console.log(errors);
                    // alert(errors);
                }
          //var state = response.getState();
          //if (state === "SUCCESS") {
          //  component.set("v.lstObject", []);
          //  $A.util.toggleClass(spinner, "slds-hide");
          //  alert("Saved successfully");
          //  $A.enqueueAction(component.get('c.addRow'));
          //  var url = "/lightning/r/Quote__c/" + component.get("v.recordId")+"/view";
          //  window.open(url, "_self")
          //} else {
          //  var errors = response.getError();
          //  console.log("Error message: " + errors);
          //}
        });
        $A.enqueueAction(action);
      // }
    },
    onToggleSpinner: function (cmp) {
      var spinner = cmp.find("spinner");
      $A.util.toggleClass(spinner, "slds-hide");
    }
  });