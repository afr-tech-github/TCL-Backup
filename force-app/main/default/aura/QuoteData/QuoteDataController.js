({
  doinit: function (cmp, event, helper) {
    console.log("START INIT QUOTE");
    // var getValueSearch = '';
    helper.showData(cmp);
  },
  showDetail: function (cmp, event, helper) {
    var selectedItem = event.currentTarget;
    var id = selectedItem.dataset.record;
    if (jQuery("." + id).hasClass("hideRow")) {
      jQuery("." + id).removeClass("hideRow");
      jQuery("#" + id).addClass("rorateImg");
    } else {
      jQuery("." + id).addClass("hideRow");
      jQuery(".child" + id).addClass("hideRow");
      jQuery("#" + id).removeClass("rorateImg");
      jQuery(".down" + id).removeClass("rorateImg");
    }
  },

  onSelectQLAll: function (cmp, event, helper) {
    var selectedItem = event.currentTarget;
    var id = selectedItem.dataset.record;
    if (jQuery("." + id).is(":checked")) {
      jQuery(".lineId" + id).prop("checked", true);
    } else {
      jQuery(".lineId" + id).prop("checked", false);
    }
  },
  onSelectQL: function (cmp, event, helper) {
    var selectedItem = event.currentTarget;
    var id = selectedItem.dataset.record;
    if (jQuery(".lineId" + id).is(":checked")) {
      // jQuery('.lineId'+id).prop( "checked", true);
    } else {
      jQuery(".lineId" + id).prop("checked", false);
    }
  },
  onCreateSO: function (cmp, event, helper) {
    var toastEvent = $A.get("e.force:showToast");
    var QLIds = [];
    var poSelected = jQuery(".lineId:checkbox:checked");

    if (poSelected.length > 0) {
      cmp.set("v.isShowSpinner", true);
      for (var i = 0; i < poSelected.length; i++) {
        var idQL = poSelected[i].id
          .replace(/\s/g, "")
          .replace(/packItemId/g, "");
        QLIds.push(idQL);
      }
      // var QLIds = QLIds.join(',');
      cmp.set("v.QLIds", QLIds);
      console.log("hehehe " + cmp.get("v.QLIds"));
      var actionGetInfoQL = cmp.get("c.getQR");
      actionGetInfoQL.setParams({
        QLIds: cmp.get("v.QLIds"),
      });
      actionGetInfoQL.setCallback(this, function (response) {
        var state = response.getState();
        if (state === "SUCCESS") {
          var res = response.getReturnValue();
          if ("1" in res) {
            cmp.set("v.isShowSpinner", false);
            var scrollOptions = {
              left: 0,
              top: 0,
              behavior: "smooth",
            };
            window.scrollTo(scrollOptions);
            cmp.set("v.isShowConvert", true);
            cmp.set("v.isShowData", false);
            cmp.set("v.QuoteRouteSelect", res["1"]);
            var getSaleOrder = cmp.get("v.SaleOrder");
            getSaleOrder.Quote_route__c = res["1"][0].Id;
            getSaleOrder.P_O_L_A_O_D__c = res["1"][0].Route__r.Route__r.From__c;
            getSaleOrder.P_O_D_A_O_A__c = res["1"][0].Route__r.Route__r.To__c;
            getSaleOrder.Pick_Up_Address__c = res["1"][0].PickUpAddress__c;
            getSaleOrder.Delivery_Address__c = res["1"][0].DeliveryAddress__c;
            cmp.set("v.SaleOrder", getSaleOrder);
          } else {
            toastEvent.setParams({
              type: "error",
              title: "Error",
              message:
                "PLEASE ONLY CHOOSE QUOTELINE IN THE SAME QUOTE ROUTE. THANKS!!! ",
            });
            toastEvent.fire();
            cmp.set("v.isShowSpinner", false);
          }
        } else if (state === "ERROR") {
          var errors = response.getError();
          $A.util.addClass(spinner, "slds-hide");
          if (errors) {
            toastEvent.setParams({
              type: "error",
              title: "Error",
              message: errors[0].pageErrors[0].message,
            });
          }
          toastEvent.fire();
          cmp.set("v.isShowSpinner", false);
        }
      });
      $A.enqueueAction(actionGetInfoQL);
    } else {
      toastEvent.setParams({
        type: "error",
        title: "Error",
        message: "PLEASE CHOOSE AT LEAST 1 QUOTE LINE AT EACH SERVICE !!!",
      });
      toastEvent.fire();
      cmp.set("v.isShowSpinner", false);
    }
  },
  onPrevious: function (cmp, event, helper) {
    var scrollOptions = {
      left: 0,
      top: 0,
      behavior: "smooth",
    };
    window.scrollTo(scrollOptions);
    var spinner = cmp.find("spinnerMain");
    $A.util.removeClass(spinner, "slds-hide");
    cmp.set("v.isShowConvert", false);
    cmp.set("v.isShowData", true);
    setTimeout(function () {
      $A.util.addClass(spinner, "slds-hide");
    }, 3000);
  },
  onTest: function (cmp, event, helper) {
    console.log(cmp.get("v.SaleOrder"));
  },
  mpEvent: function (cmp, event, helper) {
    var spinner = event.currentTarget.getAttribute("data-field");
    var oder = cmp.get("v.SaleOrder");
    oder[spinner] = event.currentTarget.checked;
  },
  onConfirm: function (cmp, event, helper) {
    cmp.set("v.isShowSpinner", true);
    var actionSave = cmp.get("c.saveRecords");
    var spinner = cmp.find("spinnerMain");
    console.log("spinner", cmp.get("v.SaleOrder"));
    actionSave.setParams({
      SalesOrder: cmp.get("v.SaleOrder"),
      QLIds: cmp.get("v.QLIds"),
    });
    actionSave.setCallback(this, function (response) {
      var toastEvent = $A.get("e.force:showToast");
      var state = response.getState();
      if (state === "SUCCESS") {
        cmp.set("v.isShowSpinner", false);
        var res = response.getReturnValue();
        var url = "/lightning/r/Sales_Order__c/" + res + "/view";
        toastEvent.setParams({
          type: "success",
          title: "Success",
          message: "Sales Order saved successfully",
        });
        toastEvent.fire();
        $A.util.addClass(spinner, "slds-hide");
        cmp.set("v.isShowConvert", false);
        cmp.set("v.isShowData", true);
        window.open(url, "_blank");
        helper.showData(cmp);
      } else if (state === "ERROR") {
        var errors = response.getError();
        $A.util.addClass(spinner, "slds-hide");
        if (errors) {
          toastEvent.setParams({
            type: "error",
            title: "Error",
            message: errors[0].pageErrors[0].message,
          });
        }
        toastEvent.fire();
        cmp.set("v.isShowSpinner", false);
      }
    });
    $A.enqueueAction(actionSave);
  },

  onDelete: function (cmp, event, helper) {
    var msg = "Are you sure you want to delete this item?";
    var toastEvent = $A.get("e.force:showToast");
    var QLIds = [];
    var poSelected = jQuery(".lineId:checkbox:checked");

    if (poSelected.length > 0) {
      if (!confirm(msg)) {
        return;
      } else {
        cmp.set("v.isShowSpinner", true);
        for (var i = 0; i < poSelected.length; i++) {
          var idQL = poSelected[i].id
            .replace(/\s/g, "")
            .replace(/packItemId/g, "");
          QLIds.push(idQL);
        }
        var strPO = QLIds.join(",");
        cmp.set("v.QLIds", QLIds);
        var actionDelete = cmp.get("c.deleteQuoteLine");
        actionDelete.setParams({
          QLIds: cmp.get("v.QLIds"),
        });
        actionDelete.setCallback(this, function (response) {
          var state = response.getState();
          if (state === "SUCCESS") {
            toastEvent.setParams({
              type: "success",
              title: "Success",
              message: "QUOTE LINE DELETED SUCCESSFULLY !!!",
            });
            toastEvent.fire();
            helper.showData(cmp);
          } else if (state === "ERROR") {
            var errors = response.getError();
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
        });
        $A.enqueueAction(actionDelete);
      }
    } else {
      toastEvent.setParams({
        type: "error",
        title: "Error",
        message: "PLEASE CHOOSE AT LEAST 1 QUOTE LINE BEFORE DELETE !!!",
      });
      toastEvent.fire();
    }
  },

  onUpdate: function (cmp, event, helper) {
    var toastEvent = $A.get("e.force:showToast");
    var QLIds = [];
    var poSelected = jQuery(".lineId:checkbox:checked");

    if (poSelected.length > 0) {
      cmp.set("v.isShowSpinner", true);
      for (var i = 0; i < poSelected.length; i++) {
        var idQL = poSelected[i].id
          .replace(/\s/g, "")
          .replace(/packItemId/g, "");
        QLIds.push(idQL);
      }
      // var strPO = QLIds.join(',');
      cmp.set("v.QLIds", QLIds);
      var actionGetInfoQL = cmp.get("c.getQLUpdate");
      actionGetInfoQL.setParams({
        QLIds: cmp.get("v.QLIds"),
      });
      actionGetInfoQL.setCallback(this, function (response) {
        var state = response.getState();
        if (state === "SUCCESS") {
          var res = response.getReturnValue();
          cmp.set("v.lstQLUpdate", res);
          cmp.set("v.isShowData", false);
          cmp.set("v.isShowConvert", false);
          cmp.set("v.isShowCreateCmp", false);
          cmp.set("v.isShowUpdateCmp", true);
        } else if (state === "ERROR") {
          var errors = response.getError();
          $A.util.addClass(spinner, "slds-hide");
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
      });
      $A.enqueueAction(actionGetInfoQL);
    } else {
      toastEvent.setParams({
        type: "error",
        title: "Error",
        message: "PLEASE CHOOSE AT LEAST 1 QUOTE LINE BEFORE UPDATE !!!",
      });
      toastEvent.fire();
    }
  },

  handleCmpEvent: function (cmp, event, helper) {
    helper.showData(cmp);
  },
  openModel: function (cmp, event, helper) {
    cmp.set("v.isModalOpen", true);
  },

  closeModel: function (cmp, event, helper) {
    cmp.set("v.isModalOpen", false);
  },

  submitDetails: function (cmp, event, helper) {
    cmp.set("v.isModalOpen", false);
    if (cmp.get("v.value") == "addFrom") {
      cmp.set("v.isShowData", false);
      cmp.set("v.isShowConvert", false);
      cmp.set("v.isShowIQCmp", true);
    } else {
      cmp.set("v.isShowData", false);
      cmp.set("v.isShowConvert", false);
      cmp.set("v.isShowCreateCmp", true);
    }
  },
  onRefresh: function (cmp, event, helper) {
    helper.showData(cmp);
  },
});