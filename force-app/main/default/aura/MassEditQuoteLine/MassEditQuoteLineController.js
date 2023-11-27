({
    doinit: function (cmp, event, helper) {
        var getRoute = cmp.get('c.getRoute');
        var getLstQuoteLine = cmp.get('v.lstQuoteLine');
        getLstQuoteLine.push({
            'sobjectType': 'Quoteline__c',
            'ReferencePrice__c': '',
            // 'PrintingSection__c': '',
            'ChargeQuantity__c': '',
            'CurrencySelling__c': '',
            'TaxRateSelling__c': '',
            'SellingListPriceActual__c': '',
            'Remarks__c': '',
        })
        cmp.set('v.lstQuoteLine', getLstQuoteLine);

        getRoute.setParams({
            QuoteId: cmp.get('v.recordId')
        })
        getRoute.setCallback(this, function (response) {
            var state = response.getState();
            var result = [];
            if (state === 'SUCCESS') {
                var res = response.getReturnValue();
                var stringQuery = ''
                for (var i = 0; i < res.length; i++) {
                    if ('Route__r' in res[i]) {
                        result.push(res[i].Route__r.Route__c);
                    }
                }
                var uniqueSet = new Set(result);
                var setToArr = [...uniqueSet];
                for (var i = 0; i < setToArr.length; i++) {
                    stringQuery += '\'' + setToArr[i] + '\',';
                }
                if (stringQuery.lastIndexOf(',')) {
                    stringQuery = stringQuery.slice(0, stringQuery.length - 1);
                }
                var resultString = 'Route__c IN ' + '(' + stringQuery + ')';
                cmp.set('v.queryRoute', resultString);
                helper.showData(cmp);
                helper.refreshData(cmp);
            }
        })
        $A.enqueueAction(getRoute);
    },
    addRow: function (cmp, event, helper) {
        var lstQuoteLine = cmp.get("v.lstQuoteLine");
        lstQuoteLine.push({
            'sobjectType': 'Quoteline__c',
            'ReferencePrice__c': '',
            // 'PrintingSection__c': '',
            'ChargeQuantity__c': '',
            'CurrencySelling__c': '',
            'TaxRateSelling__c': '',
            'SellingListPriceActual__c': '',
            'Remarks__c': '',
        });
        cmp.set("v.lstQuoteLine", lstQuoteLine);
    },

    removeRecord: function (cmp, event, helper) {
        var lstQuoteLine = cmp.get("v.lstQuoteLine");
        var selectedItem = event.currentTarget;
        var index = selectedItem.dataset.record;
        lstQuoteLine.splice(index, 1);
        cmp.set("v.lstQuoteLine", lstQuoteLine);
    },

    saveQuoteLines: function (cmp, event, helper) {
        var spinner = cmp.find("spinner");
        $A.util.removeClass(spinner, "slds-hide");
        var action = cmp.get("c.saveQuoteLineList");
        action.setParams({
            quoteLineList: cmp.get("v.lstQuoteLine"),
            quoteId: cmp.get("v.recordId")
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            var toastEvent = $A.get("e.force:showToast");
            if (state === "SUCCESS") {
                $A.util.addClass(spinner, "slds-hide");
                toastEvent.setParams({
                    "type": 'success',
                    "title": "Success",
                    "message": 'Quote Line saved successfully'
                });
                toastEvent.fire();
                helper.showData(cmp);
                helper.refreshData(cmp);
                cmp.set("v.lstQuoteLine", []);
                cmp.set('v.isShowTable', false);
                cmp.set('v.body', []);
                cmp.set('v.isShowTable', true);
                cmp.set('v.truckingService', null);
                cmp.set('v.isSelectAll', false);
                $A.enqueueAction(cmp.get('c.addRow'));
                // $A.enqueueAction(cmp.get('c.addRow'));
                $A.get('e.force:refreshView').fire();
            } else if (state === "ERROR") {
                var errors = response.getError();
                $A.util.addClass(spinner, "slds-hide");
                if (errors) {
                    toastEvent.setParams({
                        "type": 'error',
                        "title": "Error",
                        "message": errors[0].pageErrors[0].message
                    });
                }
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },

    // onchangeRefPrice: function (cmp, event) {
    //     // var getCountAction = cmp.get("v.CountAction");
    //     var lstQuoteLine = cmp.get("v.lstQuoteLine");
    //     // var selectedItem = event.currentTarget;
    //     var index = event.getSource().get('v.styleClass');
    //     lstQuoteLine[index].ReferencePrice__c = cmp.get('v.RefPriceID');
    //     cmp.set('v.lstQuoteLine', lstQuoteLine);
    //     cmp.set('v.RefPriceID', null);
    //     // var selectedStore = cmp.get("v.lstQuoteLine")[index]; // Use it retrieve the store record
    // },

    onUpdateQuoteLine: function (cmp, event, helper) {
        var actionFunc = 'update';
        var resultLstQuoteLine = helper.resultLstQuoteLine(cmp, actionFunc);
        if (resultLstQuoteLine.length == 0) {
            return;
        } else {
            var action = cmp.get('c.updateQuoteLine');
            var spinner = cmp.find("spinner");
            $A.util.removeClass(spinner, "slds-hide");
            action.setParams({
                "lstQuoteLine": resultLstQuoteLine
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                var toastEvent = $A.get("e.force:showToast");
                if (state === "SUCCESS") {
                    var getlstQuoteLine = cmp.get('v.lstQuoteLine');
                    $A.util.toggleClass(spinner, "slds-hide");
                    toastEvent.setParams({
                        "type": 'success',
                        "title": "Success",
                        "message": 'Quote Line saved successfully'
                    });
                    toastEvent.fire();
                    helper.showData(cmp);
                    helper.refreshData(cmp);
                    // cmp.set('v.isShowTable', false);
                    // cmp.set('v.body', []);
                    // cmp.set('v.isShowTable', true);
                    // cmp.set('v.isSelectAll', false);
                    $A.util.addClass(spinner, "slds-hide");

                    // for (var key in getlstQuoteLine[0]) {
                    //     if (key != 'clofor_com_cfs__POLAOD__c' && key != 'clofor_com_cfs__PODAOA__c' && key != 'sobjectType') {
                    //         getlstQuoteLine[0][key] = null;
                    //     }
                    // }
                    // cmp.set('v.lstQuoteLine', getlstQuoteLine[0]);
                    // cmp.find('lookupId').forEach(function (f) {
                    //     f.fireChanging('');
                    // })
                }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        toastEvent.setParams({
                            "type": 'error',
                            "title": "Error",
                            "message": errors[0].pageErrors[0].message
                        });
                    }
                    $A.util.addClass(spinner, "slds-hide");
                    toastEvent.fire();
                }
            });
            $A.enqueueAction(action);
        }
    },
    getEvent: function (cmp, event, helper) {
        // console.log(1111);
        // var div = document.getElementById('main');
        // var hasHorizontalScrollbar = div.scrollWidth > div.clientWidth;
        // var hasVerticalScrollbar = div.scrollHeight > div.clientHeight;
        // console.log(hasHorizontalScrollbar);
        // console.log(hasVerticalScrollbar);
        var getLstQuoteLine = cmp.get("v.lstQuoteLine");
        var lstQuoteLine = [];
        var getLst = cmp.get('v.lstQuoteLineUpdate');
        var getQuoteLineChanged = event.getParam("lstQuoteLineChanged");
        console.log('1234567' + JSON.stringify(getQuoteLineChanged))
        if (getLst.length == 0) {
            getLst.push(getQuoteLineChanged);
        } else {
            var indexLst = 0;
            var exist = getLst.find(function (number, index) {
                if (number.Id == getQuoteLineChanged.Id) {
                    indexLst = index;
                }
                return number.Id == getQuoteLineChanged.Id;
            })
            if (exist) {
                getLst.splice(indexLst, 1);
            }
            getLst.push(getQuoteLineChanged);
        }
        var checkExistChecked = lstQuoteLine.find(function (number, index) {
            return number.isChecked == true;
        })
        if (checkExistChecked) {
            cmp.set('v.isShowSaveBtn', false);
            cmp.set('v.isShowUpdateBtn', true);
            if (getLstQuoteLine.length > 1) {
                getLstQuoteLine.splice(1, getLstQuoteLine.length - 1);
                cmp.set("v.lstQuoteLine", getLstQuoteLine);
            }
        } else {
            cmp.set('v.isShowSaveBtn', true);
            cmp.set('v.isShowUpdateBtn', true);
        }
        cmp.set('v.lstQuoteLineUpdate', getLst);
        console.log('1234567' + JSON.stringify(cmp.get('v.lstQuoteLineUpdate')));

    },

    onChangeAll: function (cmp, event, helper) {
        var getCheckboxAll = event.getSource().get("v.checked");
        if (getCheckboxAll) {
            helper.onToggleSelect(cmp, true);
        } else {
            helper.onToggleSelect(cmp, false);
        }
    },

    onUpdateFieldChange: function (cmp, event, helper) {
        var lstQuoteLine = cmp.get("v.lstQuoteLine");
        var valueLookup = event.getSource().get('v.selectedRecordId');
        var objectLookup = event.getSource().get('v.objectType');
        var value = event.getSource().get('v.value');
        var fieldName = event.getSource().get('v.fieldName');
        var classField = event.getSource().get('v.class');
        var classLookup = event.getSource().get('v.styleClass');
        // var getChecked = event.getSource().get('v.checked');
        var changedFields = cmp.get('v.changedFieldsCheckbox');
        if (classField == '0' || classLookup == '0') {
            if (fieldName) {
                changedFields[0][fieldName] = value;
            }
            else if (objectLookup) {
                changedFields[0][objectLookup] = valueLookup;
            }
            cmp.set('v.changedFieldsCheckbox', changedFields);
        }
        if (objectLookup == 'ReferencePrice__c') {
            lstQuoteLine[classLookup].ReferencePrice__c = valueLookup;
            cmp.set('v.lstQuoteLine', lstQuoteLine);
            cmp.set('v.RefPriceID', null);
        }
        if (objectLookup == 'Quote_route__c') {
            lstQuoteLine[classLookup].Quote_route__c = cmp.get('v.QuoteRoute');
            cmp.set('v.lstQuoteLine', lstQuoteLine);
            cmp.set('v.QuoteRoute', null);
        }
    },
    onDeleteQuoteLine: function (cmp, event, helper) {
        var actionFunc = 'delete';
        var msg = 'Are you sure you want to delete this item?';
        var resultLstQuoteLine = helper.resultLstQuoteLine(cmp, actionFunc);
        if (resultLstQuoteLine.length == 0) {
            return;
        } else {
            if (!confirm(msg)) {
                return;
            } else {
                var action = cmp.get('c.deleteQuoteLine');
                var spinner = cmp.find("spinner");
                $A.util.removeClass(spinner, "slds-hide");
                action.setParams({
                    // "lstIdQuoteLine": cmp.get('v.lstIdQuoteLine'),
                    "lstQuoteLineId": resultLstQuoteLine
                });
                action.setCallback(this, function (response) {
                    var state = response.getState();
                    var toastEvent = $A.get("e.force:showToast");
                    if (state === "SUCCESS") {
                        var getlstQuoteLine = cmp.get('v.lstQuoteLine');
                        $A.util.addClass(spinner, "slds-hide");
                        toastEvent.setParams({
                            "type": 'success',
                            "title": "Success",
                            "message": 'Quote Line deleted successfully'
                        });
                        toastEvent.fire();
                        helper.showData(cmp);
                        helper.refreshData(cmp);
                    }
                    else if (state === "ERROR") {
                        var errors = response.getError();
                        if (errors) {
                            toastEvent.setParams({
                                "type": 'error',
                                "title": "Error",
                                "message": errors[0].pageErrors[0].message
                            });
                        }
                        $A.util.addClass(spinner, "slds-hide");
                        toastEvent.fire();
                    }
                });
                $A.enqueueAction(action);
            }

        }
    },
    onRefresh: function (cmp, event, helper) {
        helper.showData(cmp);
        helper.refreshData(cmp);
    },
    // onToggleSpinner: function (cmp) {
    //     var spinner = cmp.find("spinner");
    //     $A.util.toggleClass(spinner, "slds-hide");
    // },
});