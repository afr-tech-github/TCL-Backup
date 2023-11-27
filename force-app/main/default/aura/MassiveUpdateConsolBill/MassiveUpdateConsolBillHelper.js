({
    helperInit: function(cmp, helper){
        var getDescribeSobjectResult = cmp.get("c.getDescribeSobjectResult");
        console.log(getDescribeSobjectResult);
        getDescribeSobjectResult.setCallback(this, function (response) {
            var state = response.getState();
            console.log('getDescribeSobjectResult: ', response);
            if (state === "SUCCESS") {
                var res = response.getReturnValue();
                var resArr = res.split('_');
                console.log('getDescribeSobjectResult: ', res);
                if(resArr.length == 4){
                    cmp.set('v.isCreateable', resArr[0] == 'true');
                    cmp.set('v.isUpdateable', resArr[1] == 'true');
                    cmp.set('v.isAccessible', resArr[2] == 'true');
                    cmp.set('v.isDeletable', resArr[3] == 'true');
                }
                helper.initData(cmp);
                
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                console.log("Error message: " + errors);
            }
        });
        $A.enqueueAction(getDescribeSobjectResult);
    },
    initData: function (cmp) {
        console.log('not good');
        console.log(cmp);
        var thisHelper = this;
        var cloneCmp = cmp;
        var isSelling = cmp.get("v.isSelling");
        console.log('testttt112');
        console.log('sss :'+isSelling);
        var getAllBillings = cmp.get("c.getAllBillings");
        console.log('ddd :'+getAllBillings);
        getAllBillings.setParams({ shipmentId: cmp.get("v.recordId"), isSelling });
        getAllBillings.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var res = JSON.parse(JSON.stringify(response.getReturnValue())) || [];
                console.log("From server list quote line: ", res);
                cmp.set('v.numberOfDisplayRecord', res.length);
                let listIds = cmp.get("v.listIds");
                let newPromise = new Promise(function(resolve, reject) {
                    for (var i = 0; i < res.length; i++) {
                        let quoteLine = res[i], isFirstRecord = i == 0;
                        if(isFirstRecord) {
                            cmp.set('v.id', quoteLine.Id);
                        }
                        listIds.push(res[i].Id);
                        console.log('Thong log:')+listIds;
                        window.setTimeout(
                            $A.getCallback(function () {
                                if(isFirstRecord){
                                    thisHelper.createComponent(cloneCmp, quoteLine, isFirstRecord);
                                    thisHelper.createComponent(cloneCmp, quoteLine, false);
                                } else {
                                    thisHelper.createComponent(cloneCmp, quoteLine, isFirstRecord);
                                }
                            }), i * 100
                        );
                    }
                    resolve();
                });
                newPromise.then(()=>{
                    cmp.set("v.listIds", listIds);
                });
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                console.log("Error message: " + errors);
            }
        });
        $A.enqueueAction(getAllBillings);
    },
    initNewData: function (cmp) {
        console.log('not good');
        console.log(cmp);
        var thisHelper = this;
        var cloneCmp = cmp;
        var isSelling = cmp.get("v.isSelling");
        console.log('testttt123');
        console.log(isSelling);
        let listIds = cmp.get("v.listIds");
        console.log('check :'+listIds);
        var getNewBillings = cmp.get("c.getNewBillings");
        getNewBillings.setParams({ 
            shipmentId: cmp.get("v.recordId"), 
            isSelling,
            ids: listIds
        });
        getNewBillings.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var res = JSON.parse(JSON.stringify(response.getReturnValue())) || [];
                var cmpParam = [];
                console.log("From server list quote line: ", res);
                cmp.set('v.numberOfDisplayRecord', res.length);
                
                let newPromise = new Promise(function(resolve, reject) {
                    for (var i = 0; i < res.length; i++) {
                        let quoteLine = res[i], isFirstRecord = false;
                        console.log("hello bro");
                        console.log(res[i].Id);
                        listIds.push(res[i].Id);
                        window.setTimeout(
                            $A.getCallback(function () {
                                thisHelper.createComponent(cloneCmp, quoteLine, isFirstRecord);
                            }), i * 100
                        );
                    }
                    resolve();
                });
                newPromise.then(()=>{
                    cmp.set("v.listIds", listIds);
                });
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                console.log("Error message: " + errors);
            }
        });
        $A.enqueueAction(getNewBillings);
    },
    createComponent: function (cloneCmp, billing, isFirstRecord) {
        var isSelling = cloneCmp.get('v.isSelling');
        var isUpdateable = cloneCmp.get('v.isUpdateable');
        var isAccessible = cloneCmp.get('v.isAccessible');
        var isDeletable = cloneCmp.get('v.isDeletable');
        $A.createComponent(
            "c:MassiveUpdateConsolBillItem",
            {
                id: isFirstRecord ? '' : billing.Id,
                'aura:id': 'massiveUpdateConsolBillItem',
                isFirstRecord,
                isSelling,
                parent: cloneCmp,
                isUpdateable: isUpdateable,
                isAccessible: isAccessible,
                isDeletable: isDeletable
            },
            (massiveUpdateConsolBillItem, status, errorMessage) => {
                if (status === "SUCCESS") {
                    var body = cloneCmp.get("v.body");
                    body.push(massiveUpdateConsolBillItem);
                    cloneCmp.set("v.body", body);
                    console.log('7776');
                }
                else if (status === "INCOMPLETE") {
                    console.log("No response from server or client is offline.")
                }
                else if (status === "ERROR") {
                    console.log("Error: " + errorMessage);
                }
            }
        );
    },
    onToggleSelect: function (cmp, isSelected) {
        var cmps = cmp.find('massiveUpdateConsolBillItem'), formattedCmps = [];
        var allRecords = [];

        if (!cmps) return;
        if ($A.util.isArray(cmps)) {
            formattedCmps = cmps;
        } else {
            formattedCmps = [cmps];
        }
        for (var i = 0; i < formattedCmps.length; i++) {
            console.log(formattedCmps[i].get('v.id'), ' ', formattedCmps[i].get('v.isShow'));
            formattedCmps[i].onToggleSelect(isSelected);
        }
    },
    onToggleMultiCurrency: function (cmp, isMultiCurrency) {
        var cmps = cmp.find('massiveUpdateConsolBillItem'), formattedCmps = [];
        var allRecords = [];

        if (!cmps) return;
        if ($A.util.isArray(cmps)) {
            formattedCmps = cmps;
        } else {
            formattedCmps = [cmps];
        }
        for (var i = 0; i < formattedCmps.length; i++) {
            formattedCmps[i].onToggleMultiCurrency(isMultiCurrency);
        }
    },
    onSave: function (cmp, changedFields) {
        var spinner = cmp.find("spinner");
        $A.util.toggleClass(spinner, "slds-hide");
        var listInput = cmp.find("field");
        console.log('123'+listInput);
        
        var cmps = cmp.find('massiveUpdateConsolBillItem'), formattedCmps = [];
        var allRecords = [];

        if (!cmps) return;
        if ($A.util.isArray(cmps)) {
            for (var i = 0; i < cmps.length; i++) {
                cmps[i].get('v.isShow') && formattedCmps.push(cmps[i]);
            }
        } else {
            cmps.get('v.isShow') && (formattedCmps = [cmps]);
        }

        for (var i = 0; i < formattedCmps.length; i++) {
            if (formattedCmps[i].get('v.isShow')) {
                var record = JSON.parse(JSON.stringify(formattedCmps[i].getFields()));
                if (changedFields) {
                    for (var j = 0; j < changedFields.length; j++) {
                        var fieldName = changedFields[j].key;
                        var value = changedFields[j].value;
                        fieldName && record.isSelected && (record[fieldName] = value);
                    }
                }
                if(record.Id != ''){
                    allRecords.push(record);
                }
                
                
            }
        }

        var updateBillings = cmp.get("c.updateBillings");
        var isSelling = cmp.get("v.isSelling");
        updateBillings.setParams({ jsonRecords: JSON.stringify(allRecords), isSelling });

        updateBillings.setCallback(this, function (response) {
            var state = response.getState();
            $A.util.toggleClass(spinner, "slds-hide");
            if (state === "SUCCESS") {
                console.log("SUCCESS");
                var errors = response.getError();
                console.log("Error", errors);
                console.log(JSON.parse(JSON.stringify(response.getReturnValue())));
                if (changedFields) {
                    for (var i = 0; i < formattedCmps.length; i++) {
                        var record = JSON.parse(JSON.stringify(formattedCmps[i].getFields()));
                        record.isSelected && formattedCmps[i].updateFields(changedFields);
                    }
                }
                $A.get('e.force:refreshView').fire();
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                console.log("Error", errors);
                var message = "";
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        message = errors[0].message;
                    }
                } else {
                    message = "Unknown error";
                }
                console.log("message", message);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    type: "error",
                    message
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(updateBillings);
    },
    onModified: function (cmp, event, helper) {
        var isExpandable = cmp.find("idRow");
        console.log(isExpandable);
    },
    onToggleSpinner: function (cmp) {
        var spinner = cmp.find("spinner");
        $A.util.toggleClass(spinner, "slds-hide");
    }
})