({
  doinit: function (cmp, event, helper) {
    console.log("START INIT INQUIRY");
    var getValueSearch = "";
    helper.showData(cmp, getValueSearch);
  },
  showDetail: function (cmp, event, helper) {
    var selectedItem = event.currentTarget;
    var id = selectedItem.dataset.record;
    if (jQuery("." + id).hasClass("hideRow")) {
      jQuery("." + id).removeClass("hideRow");
      // jQuery('#' + id).addClass('rorateImg')
    } else {
      jQuery("." + id).addClass("hideRow");
      jQuery(".child" + id).addClass("hideRow");
      // jQuery('#' + id).removeClass('rorateImg')
    }
  },

  onSelectPOAll: function (cmp, event, helper) {
    var selectedItem = event.currentTarget;
    var id = selectedItem.dataset.record;
    if (jQuery("." + id).is(":checked")) {
      jQuery(".priceId" + id).prop("checked", true);
    } else {
      jQuery(".priceId" + id).prop("checked", false);
    }
  },
  onSelectPO: function (cmp, event, helper) {
    var selectedItem = event.currentTarget;
    var id = selectedItem.dataset.record;
    if (jQuery(".priceId" + id).is(":checked")) {
      // jQuery('.priceId'+id).prop( "checked", true);
    } else {
      jQuery(".priceId" + id).prop("checked", false);
    }
  },
  CreateInquiry: function (cmp, event, helper) {
    var scrollOptions = {
      left: 0,
      top: 0,
      behavior: "smooth",
    };
    window.scrollTo(scrollOptions);
    cmp.set("v.ShowCreateInquiry", true);
    cmp.set("v.isShowData", false);
  },
  parentFunction: function (cmp, event, helper) {
    cmp.set("v.ShowCreateInquiry", false);
    cmp.set("v.isShowData", true);
  },
  onNext: function (cmp, event, helper) {
    var scrollOptions = {
      left: 0,
      top: 0,
      behavior: "smooth",
    };
    window.scrollTo(scrollOptions);

    var toastEvent = $A.get("e.force:showToast");
    var POIds = [];
    var poSelected = jQuery(".priceId:checkbox:checked");
    if (poSelected.length > 0) {
      for (var i = 0; i < poSelected.length; i++) {
        var idPO = poSelected[i].id
          .replace(/\s/g, "")
          .replace(/packItemId/g, "");
        POIds.push(idPO);
      }
      var strPO = POIds.join(",");
      cmp.set("v.POIds", POIds);
      var spinner = cmp.find("spinnerMain");
      $A.util.removeClass(spinner, "slds-hide");
      cmp.set("v.isShowConvert", true);
      cmp.set("v.isShowData", false);
      setTimeout(function () {
        $A.util.addClass(spinner, "slds-hide");
      }, 2000);
    } else {
      toastEvent.setParams({
        type: "error",
        title: "Error",
        message: "PLEASE CHOOSE AT LEAST 1 PRICE OPTION AT EACH SERVICE !!!",
      });
      toastEvent.fire();
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
  onSave: function (cmp, event, helper) {
    var actionSave = cmp.get("c.saveRecordsIQ");
    actionSave.setParams({
      POIds: cmp.get("v.POIds"),
      QuoteItem: cmp.get("v.Quote"),
    });
    actionSave.setCallback(this, function (response) {
      var toastEvent = $A.get("e.force:showToast");
      var state = response.getState();
      console.log(state);
      if (state === "SUCCESS") {
        var res = response.getReturnValue();
        var url = "/lightning/r/Quote__c/" + res + "/view";
        toastEvent.setParams({
          type: "success",
          title: "Success",
          message: "Quote Line saved successfully",
        });
        toastEvent.fire();
        cmp.set("v.isShowConvert", false);
        cmp.set("v.isShowData", true);
        window.open(url, "_blank");
        $A.get("e.force:refreshView").fire();
      } else if (state === "ERROR") {
        var errors = response.getError();
        console.log("errors" + JSON.stringify(errors));
        if (errors) {
          toastEvent.setParams({
            type: "error",
            title: "Error",
            message: errors[0].pageErrors[0].message,
          });
        }
        toastEvent.fire();
      }
    });
    $A.enqueueAction(actionSave);
  },
  onSaveFrom: function (cmp, event, helper) {
    var toastEvent = $A.get("e.force:showToast");
    var POIds = [];
    var poSelected = jQuery(".priceId:checkbox:checked");
    if (poSelected.length > 0) {
      for (var i = 0; i < poSelected.length; i++) {
        var idPO = poSelected[i].id
          .replace(/\s/g, "")
          .replace(/packItemId/g, "");
        POIds.push(idPO);
      }
      var strPO = POIds.join(",");
      cmp.set("v.POIds", POIds);
    } else {
      toastEvent.setParams({
        type: "error",
        title: "Error",
        message: "PLEASE CHOOSE AT LEAST 1 PRICE OPTION AT EACH SERVICE !!!",
      });
      toastEvent.fire();
    }
    if (cmp.get("v.POIds").length > 0) {
      var actionSave = cmp.get("c.saveRecordsQ");
      actionSave.setParams({
        POIds: cmp.get("v.POIds"),
        QuoteId: cmp.get("v.QuoteId"),
      });
      actionSave.setCallback(this, function (response) {
        cmp.set("v.isShowSpinner", true);
        var toastEvent = $A.get("e.force:showToast");
        var state = response.getState();
        console.log(state);
        if (state === "SUCCESS") {
          toastEvent.setParams({
            type: "success",
            title: "Success",
            message: "Quote Line saved successfully",
          });
          toastEvent.fire();
          $A.get("e.force:refreshView").fire();
          var compEvent = cmp.getEvent("quoteEvent");
          compEvent.setParams({
            message: true,
          });
          compEvent.fire();
        } else if (state === "ERROR") {
          var errors = response.getError();
          console.log("errors" + JSON.stringify(errors));
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
      $A.enqueueAction(actionSave);
    }
  },
  onSearch: function (cmp, event, helper) {
    var getValueSearch = cmp.get("v.valueSearch");
    helper.showData(cmp, getValueSearch);
  },
  onBack: function (cmp, event, helper) {
    if (cmp.get("v.sObjectName") !== "Inquiry__c") {
      var compEvent = cmp.getEvent("quoteEvent");
      compEvent.setParams({
        message: true,
      });
      compEvent.fire();
    }
  },
});