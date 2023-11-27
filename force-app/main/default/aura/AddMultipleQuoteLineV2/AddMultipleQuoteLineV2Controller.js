({
  doinit: function (cmp, event, helper) {
    var randomId = "id_" + Math.random().toString(36).substring(6);
    var getRoute = cmp.get("c.getRoute");
    var getLstQuoteLine = cmp.get("v.lstQuoteLine");
    getLstQuoteLine.push({
      sobjectType: "Quoteline__c",
      ReferencePrice__c: "",
      ServiceID__c: "",
      Id: randomId,
      SupplierVendor__c: "",
      BuyingListPriceActual__c: "",
      CurrencyBuying__c: "",
      ChargeUnit__c: "",
      Route__c: "",
      ContainerType1__c: "",
      ChargeQuantity__c: "",
      CurrencySelling__c: "",
      TaxRateSelling__c: "",
      SellingListPriceActual__c: "",
      Remarks__c: "",
      Print__c: false,
    });
    cmp.set("v.lstQuoteLine", getLstQuoteLine);

    getRoute.setParams({
      QuoteId: cmp.get("v.QuoteId"),
    });
    getRoute.setCallback(this, function (response) {
      cmp.set("v.isShowSpinner", true);
      var state = response.getState();
      var result = [];
      if (state === "SUCCESS") {
        var res = response.getReturnValue();
        var stringQuery = "";
        for (var i = 0; i < res.length; i++) {
          if ("Route__r" in res[i]) {
            result.push(res[i].Route__r.Route__c);
          }
        }
        var uniqueSet = new Set(result);
        var setToArr = [...uniqueSet];
        for (var i = 0; i < setToArr.length; i++) {
          stringQuery += "'" + setToArr[i] + "',";
        }
        if (stringQuery.lastIndexOf(",")) {
          stringQuery = stringQuery.slice(0, stringQuery.length - 1);
        }
        var resultString = "Route__c IN " + "(" + stringQuery + ")";
        cmp.set("v.queryRoute", resultString);
        if (cmp.get("v.queryRoute")) {
          cmp.set("v.isShowSpinner", false);
        }
      }
    });
    $A.enqueueAction(getRoute);
  },
  addRow: function (cmp, event, helper) {
    var randomId = "id_" + Math.random().toString(36).substring(6);

    var lstQuoteLine = cmp.get("v.lstQuoteLine");
    lstQuoteLine.push({
      sobjectType: "Quoteline__c",
      ReferencePrice__c: "",
      Id: randomId,
      ServiceID__c: "",
      SupplierVendor__c: "",
      BuyingListPriceActual__c: "",
      CurrencyBuying__c: "",
      ChargeUnit__c: "",
      Route__c: "",
      ContainerType1__c: "",
      Print__c: false,
      ChargeQuantity__c: "",
      CurrencySelling__c: "",
      TaxRateSelling__c: "",
      SellingListPriceActual__c: "",
      Remarks__c: "",
    });
    cmp.set("v.lstQuoteLine", lstQuoteLine);
  },
  changeServiceId: function (cmp, event, helper) {
    var valueLookup = event.getParam("value");
    var lstQuoteLine = cmp.get("v.lstQuoteLine");
    var idP = event
      .getSource()
      .getElements()[0]
      .parentElement.getAttribute("data-record");

    var setTariff = cmp.get("c.getTariff");
    console.log("idP", valueLookup);
    setTariff.setParams({
      serId: valueLookup[0],
    });

    setTariff.setCallback(this, function (response) {
      // cmp.set("v.isShowSpinner", true);
      var state = response.getState();
      console.log("response", JSON.stringify(response.getReturnValue())); // response.getReturnValue());
      console.log("state", state);
      if (state === "SUCCESS") {
        var res = response.getReturnValue();
        console.log("res", res);
        lstQuoteLine.forEach(function (item) {
          if (item.Id == idP) {
            item.Print__c = Boolean(res.Tariff__c);
          }
        });
        cmp.set("v.lstQuoteLine", lstQuoteLine);
      }
    });
    $A.enqueueAction(setTariff);
  },
  changeDiv: function (cmp, event, helper) {
    var selectedItem = event.currentTarget;
    var index = selectedItem.dataset.record;
    cmp.set("v.IdServiece", index);
  },

  // Function to remove a record
  removeRecord: function (cmp, event, helper) {
    var lstQuoteLine = cmp.get("v.lstQuoteLine");
    var selectedItem = event.currentTarget;
    var index = selectedItem.dataset.record;
    lstQuoteLine.splice(index, 1);
    cmp.set("v.lstQuoteLine", lstQuoteLine);
  },

  saveQuoteLines: function (cmp, event, helper) {
    cmp.set("v.isShowSpinner", true);
    var action = cmp.get("c.saveQuoteLineList");
    action.setParams({
      quoteLineList: cmp.get("v.lstQuoteLine"),
      quoteId: cmp.get("v.QuoteId"),
    });

    console.log("action:" + JSON.stringify(cmp.get("v.lstQuoteLine")));

    action.setCallback(this, function (response) {
      var toastEvent = $A.get("e.force:showToast");
      var state = response.getState();
      if (state === "SUCCESS") {
        toastEvent.setParams({
          type: "success",
          title: "Success",
          message: "Quote Line saved successfully",
        });
        toastEvent.fire();
        cmp.set("v.lstQuoteLine", []);
        // $A.enqueueAction(cmp.get('c.doinit'));
        $A.get("e.force:refreshView").fire();
        var compEvent = cmp.getEvent("quoteEvent");
        compEvent.setParams({
          message: true,
        });
        compEvent.fire();
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
    $A.enqueueAction(action);
  },
  onUpdateFieldChange: function (cmp, event, helper) {
    var objectLookup = event.getSource().get("v.objectType");
    // console.log("objectLookup",objectLookup);
    var valueLookup = event.getSource().get("v.selectedRecordId");
    // console.log("valueLookup",valueLookup);
    var lstQuoteLine = cmp.get("v.lstQuoteLine");
    // console.log("lstQuoteLine",JSON.stringify(lstQuoteLine));
    var index = event.getSource().get("v.styleClass");
    // console.log("index",index);

    if (objectLookup == "ReferencePrice__c") {
      lstQuoteLine[index].ReferencePrice__c = valueLookup;
      cmp.set("v.lstQuoteLine", lstQuoteLine);
      cmp.set("v.RefPriceID", null);
    }
    if (objectLookup == "Quote_route__c") {
      lstQuoteLine[index].Quote_route__c = valueLookup;
      cmp.set("v.lstQuoteLine", lstQuoteLine);
      cmp.set("v.QuoteRoute", null);
    }
  },
  showwData: function (cmp) {
    var lstQuoteLine = cmp.get("v.lstQuoteLine");
    console.log("lstQuoteLine", JSON.stringify(lstQuoteLine));
  },
  onBack: function (cmp, event, helper) {
    if (cmp.get("v.sObjectName") == "Quote__c") {
      var compEvent = cmp.getEvent("quoteEvent");
      compEvent.setParams({
        message: true,
      });
      compEvent.fire();
    }
  },
});