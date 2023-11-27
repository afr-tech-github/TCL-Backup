({
  updateQL: function (cmp, lstQLUpdate, updateAll) {
    var toastEvent = $A.get("e.force:showToast");
    cmp.set("v.isShowSpinner", true);
    var action = cmp.get("c.updateQL");
    action.setParams({
      quoteLineList: lstQLUpdate,
      isUpdate: updateAll,
    });
    action.setCallback(this, function (response) {
      var res = response.getReturnValue();
      var state = response.getState();
      console.log(state, "xxx");
      if (state === "SUCCESS") {
        toastEvent.setParams({
          type: "success",
          title: "Success",
          message: "Quote Line saved successfully",
        });
        toastEvent.fire();
        cmp.set("v.lstQLUpdate", res);
        cmp.set("v.checkAll", false);
        cmp.find("field").forEach(function (f) {
          f.reset();
        });
        cmp.find("lookupId").forEach(function (f) {
          f.fireChanging(null);
        });
        jQuery(".selectAll").prop("checked", false);
        // $A.get("e.force:refreshView").fire();
      } else if (state === "ERROR") {
        var errors = response.getError();
        console.log(errors);
        if (errors) {
          toastEvent.setParams({
            type: "error",
            title: "Error",
            message: errors[0].pageErrors[0].message,
          });
        }
        toastEvent.fire();
      }
      cmp.set("v.isShowSpinner", false);
      if (cmp.get("v.sObjectName") == "Quote__c") {
        var compEvent = cmp.getEvent("quoteEvent");
        compEvent.setParams({
          message: true,
        });
        compEvent.fire();
      }
    });
    $A.enqueueAction(action);
  },
});