({
    showData: function (cmp) {
        console.log('START INIT')
        if (!cmp.get('v.Spinner')) {
            cmp.set('v.Spinner', true);
        }
        var getQuoteId = cmp.get('v.recordId');
        var thisHelper = this;
        var cloneCmp = cmp;
        var isTrucking = cmp.get('v.isTrucking');
        var getQuoteLine = cmp.get("c.getAllQuoteLine");
        var queryRoute = cmp.get('v.queryRoute');
        getQuoteLine.setParams({
            QuoteId: cmp.get("v.recordId"),
        });
        getQuoteLine.setCallback(this, function (response) {
            var state = response.getState();
            var res = JSON.parse(JSON.stringify(response.getReturnValue())) || [];
            if (state === 'SUCCESS') {
                if (res.length == 0) {
                    cmp.set('v.Spinner', false);
                } else {
                    for (var i = 0; i < res.length; i++) {
                        const quoteLine = res[i], isFirstRecord = i == 0, RefPriceID = res[i].ReferencePriceID__c, sectionQuoteLine = res[i].Section__c;
                        window.setTimeout(
                            $A.getCallback(function () {
                                console.log(quoteLine);
                                thisHelper.createComponent(cloneCmp, quoteLine, getQuoteId, queryRoute, RefPriceID, sectionQuoteLine, isFirstRecord);
                                if (quoteLine == res[res.length - 1]) {
                                    setTimeout(function () {
                                        cmp.set('v.isShow', true);
                                        cmp.set('v.Spinner', false);
                                    }, 5000)
                                }
                            }), (i+1) * 100
                        );
                    }
                }
            }
        });
        $A.enqueueAction(getQuoteLine);
    },
    createComponent: function (cmp, quoteLine, QuoteId, queryRoute, RefPriceID, sectionQuoteLine, isFirstRecord) {
        $A.createComponent(
            "c:MassEditQuoteLineItem",
            {
                QuoteLine: quoteLine,
                id: quoteLine.Id,
                queryRoute: queryRoute,
                RefPriceID: RefPriceID,
                sectionQuoteLine: sectionQuoteLine,
                'aura:id': 'MassEditQuoteLineItem',
                isFirstRecord,
                QuoteId: QuoteId,
                parent: cmp,
                quoteLineChanged: [{ 'sobjectType': 'QuoteLine__c', Id: quoteLine.Id, }]

            },
            function (cmp1, status, error) {
                if (status === "SUCCESS") {
                    // cmp.set('v.Spinner', true);
                    console.log('11111' + cmp1);
                    var body = cmp.get("v.body");
                    body.push(cmp1);
                    cmp.set("v.body", body);
                    // cmp.set('v.Spinner', false);

                    // cmp.set('v.isShow', true);
                    // setTimeout(function(){
                    //     cmp.set('v.Spinner', false);
                    // },5000)
                    // $A.get('e.force:refreshView').fire();
                }
                else if (status === "INCOMPLETE") {
                    console.log("No response from server or client is offline.")
                }
                else if (status === "ERROR") {
                    console.log("Error: " + error);
                }
            }
        )
    },

    onToggleSelect: function (cmp, isSelected) {
        var cmps = cmp.find('MassEditQuoteLineItem'), formattedCmps = [];
        if (!cmps) return;
        if ($A.util.isArray(cmps)) {
            formattedCmps = cmps;
        } else {
            formattedCmps = [cmps];
        }
        for (var i = 0; i < formattedCmps.length; i++) {
            formattedCmps[i].onChangeItem(isSelected);
        }
    },

    resultLstQuoteLine: function (cmp, action) {
        var toastEvent = $A.get("e.force:showToast");
        var resultLstQuoteLine = [];
        var changedFields = cmp.get('v.changedFieldsCheckbox');
        var lstQuoteLine = cmp.get('v.lstQuoteLine')[0];
        var lstQuoteLineUpdate = cmp.get('v.lstQuoteLineUpdate');
        for (var key in lstQuoteLine) {
            if (lstQuoteLine[key] && key != 'sobjectType') {
                changedFields[0][key] = lstQuoteLine[key];
            }
        }
        var obj = {
            sobjectType: "Quoteline__c",
        }
        var result = lstQuoteLineUpdate.filter(function (number, index) {
            return number.isChecked == true
        })
        if (action == 'update') {
            if (result.length > 0) {
                if (Object.keys(changedFields[0]).length == 0) {
                    toastEvent.setParams({
                        "type": 'error',
                        "title": "Error",
                        "message": "MỘT NGÀY E TÚ CẦN 12k KIM CƯƠNG"
                    });
                    toastEvent.fire();
                }
                else {
                    for (var i = 0; i < result.length; i++) {
                        var obj = {
                            sobjectType: "Quoteline__c",
                        }
                        obj.Id = result[i].Id;
                        for (var key in changedFields[0]) {
                            obj[key] = changedFields[0][key];
                        }
                        // for (var j = 0; j < changedFields.length; j++) {
                        //     obj[changedFields[j].key] = changedFields[j].value;
                        // }
                        resultLstQuoteLine.push(obj);
                    }
                }
            }
            else {
                for (var i = 0; i < lstQuoteLineUpdate.length; i++) {
                    delete lstQuoteLineUpdate[i].isChecked;
                }
                resultLstQuoteLine = lstQuoteLineUpdate;
            }
            return resultLstQuoteLine;
        } else if (action == 'delete') {
            if (result.length > 0) {
                for (var i = 0; i < result.length; i++) {
                    resultLstQuoteLine.push(result[i].Id);
                }
            }
            else {
                toastEvent.setParams({
                    "type": 'error',
                    "title": "Error",
                    "message": "PLEASE SELECT QUOTELINE BEFORE DELETING !!!"
                });
                toastEvent.fire();
            }
            return resultLstQuoteLine;
        }

    },
    refreshData: function (cmp) {
        var getLstQuoteLine = cmp.get('v.lstQuoteLine');
        cmp.set('v.isShowTable', false);
        cmp.set('v.body', []);
        cmp.set('v.isShowTable', true);
        cmp.set('v.isSelectAll', false);
        for (var key in getLstQuoteLine[0]) {
            if (key != 'sobjectType') {
                getLstQuoteLine[0][key] = "";
            }
        }
        cmp.set('v.lstQuoteLine', getLstQuoteLine);
        cmp.find('lookupId').forEach(function (f) {
            f.fireChanging(null);
        })
        cmp.set('v.isShowSaveBtn', true);
        cmp.set('v.isShowUpdateBtn', true);
        cmp.set('v.isShowUpdateBtn', true);
        cmp.set('v.lstQuoteLineUpdate', []);
        // cmp.set('v.isShowTable', false);
        // cmp.set('v.body', []);
        // cmp.set('v.isShowTable', true);
        // cmp.set('v.isSelectAll', false);
        // for (var key in getlstQuoteLine[0]) {
        //     getlstQuoteLine[0][key] = "";
        // }
        // cmp.set('v.lstQuoteLine', getlstQuoteLine);
        // cmp.find('lookupId').forEach(function (f) {
        //     f.fireChanging(null);
        // })
        // cmp.set('v.isShowSaveBtn', true);
        // cmp.set('v.isShowUpdateBtn', true);
        // cmp.set('v.isShowUpdateBtn', true);
    }
});