({
  doinit: function (component, event, helper) {
    var getRoute = component.get("c.getRouteCreate");
    console.log("x", component.get("v.recordId"));
    getRoute.setParams({
      recordIdx: component.get("v.recordId"),
    });
    getRoute.setCallback(this, function (response) {
      var state = response.getState();
      var selectedIds = [];
      if (state === "SUCCESS") {
        var res = response.getReturnValue();
        for (var i = 0; i < res.length; i++) {
          selectedIds.push(res[i].Id);
        }
        if (selectedIds && selectedIds.length > 0) {
          var combinedCondition = "Id IN ('" + selectedIds.join("','") + "')";

          component.set("v.queryConditions", combinedCondition);
          console.log("combinedConditionxx", combinedCondition);
          console.log("resMy", res);
        } else {
          component.set("v.queryConditions", "");
        }
      } else {
        console.log("state", state);
      }
    });
    $A.enqueueAction(getRoute);
    helper.getTrans(component, event, helper);
  },
  addRow: function (cmp, event, helper) {
    const InqureLine = cmp.get("v.InqureLine");
    InqureLine.push({
      Id: "",
      ComboProduct__c: cmp.get("v.comboProduct"),
    });
    cmp.set("v.InqureLine", InqureLine);
  },
  removeRecord: function (component, event, helper) {
    //Get the account list
    var billList = component.get("v.InqureLine");
    if (billList.length != 1) {
      //Get the target object
      var selectedItem = event.currentTarget;
      //Get the selected item index
      var index = selectedItem.dataset.record;
      //Remove single record from account list
      billList.splice(index, 1);
      //Set modified account list
      component.set("v.InqureLine", billList);
    }
  },
  confirm: function (cmp, event, helper) {
    console.log("xxx", JSON.stringify(cmp.get("v.InqureLine")));
    var saveILx = cmp.get("c.saveInqureline");
    console.log("xxx");
    var IL = cmp.get("v.InqureLine");
    var listQLS = [];
    var toastEvent = $A.get("e.force:showToast");

    for (var i = 0; i < IL.length; i++) {
      console.log(!IL[i].TransportationWay__c);
      console.log(!IL[i].Service__c);
      if (!IL[i].TransportationWay__c || !IL[i].Service__c) {
        alert("Transportation Way AND Service Required");
        return;
      }
    }
    console.log("chạy rồi nà");
    for (var i = 0; i < IL.length; i++) {
      listQLS.push({
        Inquiry__c: cmp.get("v.recordId"),
        Route__c: IL[i].Route__c || "",
        TransportationWay__c: IL[i].TransportationWay__c || "",
        ComboProduct__c: IL[i].ComboProduct__c || "",
        Requested__c: IL[i].Requested__c || "",
        Service__c: IL[i].Service__c || false,
      });
    }

    saveILx.setParams({
      ListQL: listQLS,
    });

    saveILx.setCallback(this, function (response) {
      var state = response.getState();
      var rs = response.getReturnValue();
      if (state === "SUCCESS") {
        toastEvent.setParams({
          type: "success",
          title: "Success",
          message: "Inquiry Line saved successfully",
        });
        toastEvent.fire();
        cmp.set("v.InqureLine", []);
      } else {
        toastEvent.setParams({
          type: "error",
          title: "Error",
          message: rs,
        });
        toastEvent.fire();
      }
    });
    $A.enqueueAction(saveILx);
  },
  changex: function (cmp, event, helper) {
    console.log(event.getSource().get("v.value"));
  },
  onUpdateFieldChange: function (cmp, event, helper) {
    var lstQuoteLine = cmp.get("v.InqureLine");

    var valueLookup = event.getSource().get("v.selectedRecordId");
    var index = event.getSource().get("v.styleClass");
    lstQuoteLine[index].Route__c = valueLookup;
    cmp.set("v.InqureLine", lstQuoteLine);

    console.log("valueLookup", valueLookup);
  },
  callParentFunction: function (cmp, event, helper) {
    var backFn = cmp.getEvent("parentFunction");
    backFn.fire();
  },
});