({
  doinit: function (cmp, event, helper) {
    console.log("INIT UPDATE QUOTE LINE");
    var getRoute = cmp.get("c.getRoute");
    var getLstQuoteLine = cmp.get("v.lstQuoteLine");
    getLstQuoteLine.push({
      sobjectType: "Quoteline__c",
      ReferencePrice__c: "",
      ChargeQuantity__c: "",
      CurrencySelling__c: "",
      TaxRateSelling__c: "",
      SellingListPriceActual__c: "",
      Remarks__c: "",
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
        // if (cmp.get('v.queryRoute')) {
        // setTimeout(function () {
        cmp.set("v.isShowSpinner", false);
        // }, 3000)
        // }
      }
    });
    $A.enqueueAction(getRoute);
  },

  onUpdateFieldChange: function (cmp, event, helper) {
    var changedFields = cmp.get("v.changedFieldsAll");
    var valueLookup = event.getSource().get("v.selectedRecordId");
    var objectLookup = event.getSource().get("v.objectType");
    var value = event.getSource().get("v.value");
    var fieldName = event.getSource().get("v.fieldName");
    if (fieldName) {
      console.log(1);
      changedFields[0][fieldName] = value;
    } else if (objectLookup) {
      console.log(2);
      changedFields[0][objectLookup] = valueLookup;
    }
    console.log(JSON.stringify(changedFields));
    cmp.set("v.changedFieldsAll", changedFields);
  },

  onUpdateFieldChangeItem: function (cmp, event, helper) {
    var lstQLUpdate = cmp.get("v.lstQLUpdate");
    var valueLookup = event.getSource().get("v.selectedRecordId");
    var objectLookup = event.getSource().get("v.objectType");
    var value = event.getSource().get("v.value");
    var fieldName = event.getSource().get("v.fieldName");
    var classField = event.getSource().get("v.class");
    var classLookup = event.getSource().get("v.styleClass");
    if (fieldName) {
      lstQLUpdate[classField][fieldName] = value;
    } else if (objectLookup) {
      lstQLUpdate[classLookup][objectLookup] = valueLookup;
    }
    cmp.set("v.lstQLUpdate", lstQLUpdate);
  },

  onUpdate: function (cmp, event, helper) {
    var getchangedFieldsAll = cmp.get("v.changedFieldsAll");
    var qlSelected = jQuery(".quoteLineId:checkbox:checked");
    const listUpdate = cmp.get("v.lstQLUpdate");

    console.log(qlSelected.length);
    if (qlSelected.length > 0) {
      if (Object.keys(getchangedFieldsAll[0]).length == 0) {
        toastEvent.setParams({
          type: "error",
          title: "Error",
          message: "Thay đổi thông tin hộ",
        });
        toastEvent.fire();
      } else {
        var resultUpdate = [];
        for (var i = 0; i < qlSelected.length; i++) {
          var item = {
            Id: qlSelected[i].id.replace(/\s/g, ""),
          };
          // resultUpdate.push(getchangedFieldsAll[0]);
          // resultUpdate[i].Id = qlSelected[i].id.replace(/\s/g, "");
          for (const [key, value] of Object.entries(getchangedFieldsAll[0])) {
            if (Array.isArray(value)) {
              item[key] = value[0];
            } else {
              item[key] = value;
            }
          }
          resultUpdate.push(item);
          //   console.log(JSON.stringify(resultUpdate));
        }
        // for (var i = 0; i < listUpdate.length; i++) {
        //   for (var j = 0; j < resultUpdate.length; j++) {
        //     if (
        //       listUpdate[i].Id == resultUpdate[j].Id &&
        //       listUpdate[i].ReferencePrice__c &&
        //       resultUpdate[j].ReferencePrice__c
        //     ) {
        //       resultUpdate[j].ReferencePrice__c =
        //         listUpdate[i].ReferencePrice__c;
        //     }
        //   }
        // }
        console.log(
          "getchangedFieldsAll ",
          JSON.stringify(getchangedFieldsAll[0])
        );
        console.log("resultUpdate ", JSON.stringify(resultUpdate));
        helper.updateQL(cmp, resultUpdate,true);
      }
    } else {
      console.log(2);
      helper.updateQL(cmp, cmp.get("v.lstQLUpdate"),false);
    }
  },

  onSelectQL: function (cmp, event, helper) {
    var selectedItem = event.currentTarget;
    var id = selectedItem.dataset.record;
    // var recordEditForm = component.find(`${id}form`);
    if (jQuery("." + id).is(":checked")) {
      //   recordEditForm.reset();
      console.log("checked");
    } else {
      jQuery(".selectAll").prop("checked", false);
    }
  },
  onSelectAllQL: function (cmp, event, helper) {
    if (jQuery(".selectAll").is(":checked")) {
      jQuery(".quoteLineId").prop("checked", true);
    } else {
      jQuery(".quoteLineId").prop("checked", false);
    }
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