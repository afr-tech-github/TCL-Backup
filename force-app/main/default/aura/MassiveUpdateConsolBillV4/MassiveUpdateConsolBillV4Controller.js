({
    init: function (cmp, event, helper) {
        // var isFirstRecord = cmp.get('v.isFirstRecord');
        // isFirstRecord && cmp.set('v.recordLabelClass', 'slds-form-element__label');
        // helper.handleRefreshView();
        helper.initData(cmp);
        // $A.get('e.force:refreshView').fire();
        // $A.get("e.force:closeQuickAction").fire();
    },
    onTabRefreshed : function(component, event, helper) {
        var refreshedTabId = event.getParam("tabId");
        console.log('refreshedTabId :'+refreshedTabId);
        var workspaceAPI = component.find("workspace");
        console.log('workspaceAPI :'+workspaceAPI);
        workspaceAPI.getTabInfo({
            tabId : refreshedTabId,
            callback : function(error, response){
                console.log(response);
            }
        });
    },
    updateFields: function (cmp, event, helper) {
        var isSelected = cmp.get('v.isSelected');
        if (isSelected) {
            isSelected && console.log('update this record: ' + cmp.get('v.id'));
            var params = event.getParam('arguments');
            var fieldData = JSON.parse(JSON.stringify(params.fields));
            var fieldNames = fieldData.map((x) => x.key);
            var fieldCmps = helper.findFieldCmps(cmp);

            for (var i = 0; i < fieldCmps.length; i++) {
                var fieldName = fieldCmps[i].get('v.fieldName');
                if (fieldNames.includes(fieldName)) {
                    var value = fieldData.find((x) => x.key == fieldName).value;
                    fieldCmps[i].set('v.value', value);
                }
            }
        }
    },
    getFields: function (cmp, event, helper) {
        var id = cmp.get('v.id'),
            isSelected = cmp.get('v.isSelected'),
            obj = { Id: id, isSelected };
        var fieldCmps = helper.findFieldCmps(cmp);

        for (var i = 0; i < fieldCmps.length; i++) {
            var value = fieldCmps[i].get('v.value');
            var fieldName = fieldCmps[i].get('v.fieldName');
            obj[fieldName] = value;
        }
        return obj;
    },
    refresh: function (cmp, event, helper) {
        var cloneCmp = cmp;
        cloneCmp.set('v.isShow', false);
        window.setTimeout(
            $A.getCallback(function () {
                console.log('refresh...');
                cloneCmp.set('v.isShow', true);
            }),
            5000
        );
    },
    onToggleSelect: function (cmp, event, helper) {
        var params = event.getParam('arguments');
        cmp.set('v.isSelected', params.isSelected);
    },
    onToggleMultiCurrency: function (cmp, event, helper) {
        var params = event.getParam('arguments');
        cmp.set('v.isMultiCurrency', params.isMultiCurrency);
    },
    onSave: function (cmp, event, helper) {
        helper.onToggleSpinner(cmp);
    },
    onSubmit: function (cmp, event, helper) {
        helper.onToggleSpinner(cmp);
        event.preventDefault();
        var fields = event.getParam('fields');
        console.log('fields: ', JSON.parse(JSON.stringify(fields)));
        cmp.find('recordEditForm').submit(fields);
    },
    onLoad: function (cmp, event, helper) {
        console.log('onRecordLoad...', cmp.get('v.id'));
        if (!cmp.get('v.firstTimeRecordLoad')) return;

        var isSelling = cmp.get('v.isSelling');
        var fields = event.getParam('recordUi').record.fields;

        var buyTankaUSD = (fields.UnitPriceofBuyingFCY__c && fields.UnitPriceofBuyingFCY__c.value) || 0;
        buyTankaUSD = Math.round(buyTankaUSD * 1000) / 1000;
        var buyTankaLocal = (fields.UnitPriceofBuyingLocal__c && fields.UnitPriceofBuyingLocal__c.value) || 0;
        buyTankaLocal = Math.round(buyTankaLocal);

        var sellTankaUSD = (fields.UnitPriceFCY__c && fields.UnitPriceFCY__c.value) || 0;
        sellTankaUSD = Math.round(sellTankaUSD * 1000) / 1000;
        var sellTankaLocal = (fields.UnitPriceofSellingLocal__c && fields.UnitPriceofSellingLocal__c.value) || 0;
        sellTankaLocal = Math.round(sellTankaLocal);

        var fieldCmps = helper.findFieldCmps(cmp);
        for (var i = 0; i < fieldCmps.length; i++) {
            var fieldName = fieldCmps[i].get('v.fieldName');
            if (buyTankaUSD && !isSelling && fieldName == 'UnitPriceofBuyingFCY__c') {
                fieldCmps[i].set('v.value', buyTankaUSD);
                continue;
            }
            if (buyTankaLocal && !isSelling && fieldName == 'UnitPriceofBuyingLocal__c') {
                fieldCmps[i].set('v.value', buyTankaLocal);
                continue;
            }

            if (sellTankaUSD && isSelling && fieldName == 'UnitPriceFCY__c') {
                fieldCmps[i].set('v.value', sellTankaUSD);
                continue;
            }
            if (sellTankaLocal && isSelling && fieldName == 'UnitPriceofSellingLocal__c') {
                fieldCmps[i].set('v.value', sellTankaLocal);
                continue;
            }
        }
    },
    onSuccess: function (cmp, event, helper) {
        helper.onToggleSpinner(cmp);
    },
    onError: function (cmp, event, helper) {
        helper.onToggleSpinner(cmp);
    },
    handleSuccess: function(component, event, helper) {
        $A.get('e.force:refreshView').fire();
    },
    onDelete: function (cmp, event, helper) {
        var msg = 'Are you sure you want to delete this item?';
        if (!confirm(msg)) {
            return;
        } else {
            helper.onToggleSpinner(cmp);
            var selectedItem = event.currentTarget;
            var recordId = selectedItem.dataset.recordid;
            var deleteBilling = cmp.get('c.deleteBilling');
            console.log('logg :' + recordId);
            console.log('logg3 :' + cmp.get('v.id'));
            // helper.onToggleSpinner(cmp);
            deleteBilling.setParams({ id: recordId });

            deleteBilling.setCallback(this, function (response) {
                var state = response.getState();
                if (state === 'SUCCESS') {
                    var res = JSON.parse(JSON.stringify(response.getReturnValue())) || false;
                    // if (res) {
                    //     cmp.set('v.isShow', false);
                    //     var parent = cmp.get('v.parent');
                    //     parent.getDeleteItem(cmp.get('v.id'));
                    // }
                    // console.log('checkdone1123');
                    // if(test.style.display = 'block'){
                    //     test.style.display = 'none';
                    //     cmp.set('v.isLoading', false);
                    // }
                    // helper.onToggleSpinner(cmp);
                    // $A.get(e.force.refreshView).fire();
                    
                } else if (state === 'ERROR') {
                    var errors = response.getError();
                    console.log('Error message: ' + JSON.stringify(errors));
                }
                console.log('checkdone1');
                helper.initData(cmp);
                helper.onToggleSpinner(cmp);
                eval("$A.get(e.force.refreshView).fire();");
                
                // helper.callUpdateRefresh();
                console.log('checkdone');

            });
            $A.enqueueAction(deleteBilling);
        }
            
            // cmp.set('v.isLoading', true);
            // const hide = event.currentTarget;
            // const index = hide.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement;
            // console.log('index :'+index.tagName);
            // const test = index.querySelector('.hide');
            // console.log('test :'+test);
            // if(test.style.display = 'none'){
            //     test.style.display = 'block';
                
            // }
            
        // }
    },
    onChange: function (cmp, event, helper) {
        var billId = event.getSource().get('v.class');
        var listBillId = cmp.get('v.listBillId');
        if (!listBillId.includes(billId)) {
            listBillId.push(billId);
        }
        console.log(listBillId);
    },
    UpdateReload: function(cmp,event,helper){
        helper.initData(cmp);
    },
    showSubBill: function (cmp, event, helper) {
        var showBilling = cmp.get('c.getSubBillings');

        console.log('logg :' + showBilling);
        var isSelling = cmp.get('v.isSelling');
        console.log('shipmentId :' + cmp.get('v.id'));
        console.log('isSelling :' + isSelling);
        showBilling.setParams({
            shipmentId: cmp.get('v.id'),
            isSelling
        });

        showBilling.setCallback(this, function (response) {
            var state = response.getState();
            var lstBill = [];
            console.log(state);
            if (state === 'SUCCESS') {
                var result = JSON.parse(JSON.stringify(response.getReturnValue())) || [];
                console.log(result);
                console.log(result.length);
                for (var i = 0; i < result.length; i++) {
                    let a = result[i].Id;

                    console.log(a);
                    cmp.set('v.listIds', result[i].Id);
                    lstBill.push(result[i]);
                }
                cmp.set('v.listIds2', lstBill);
            } else if (state === 'ERROR') {
                var errors = response.getError();
                console.log('Error message: ' + JSON.stringify(errors));
            }
        });
        $A.enqueueAction(showBilling);
    },
    // togglePackageList: function(component, event, helper) {
    //     var target = event.currentTarget;
    //         console.log('target :'+target.tagName);
    //         var imageDown = target.querySelector('.imageDown');
    //         console.log('imageDown :'+imageDown);
    //         // var testCmps2 = cmp.find("ship");
    //         // console.log('testCmps :'+testCmps2);
    //         var index = target;
    //         var dataIndex = index.getAttribute("data-index");
    //         console.log('dataIndex :'+dataIndex);

    //         var container= index.parentElement.parentElement;
    //         console.log('container :'+container.tagName);
    //         var Mydiv= container.querySelector(`.${dataIndex}`);
    //         console.log("Mydiv", Mydiv.clientHeight);
    //         console.log("Mydiv 2", Mydiv.tagName);
    //         console.log("Mydiv :", container.querySelector( '.' + dataIndex));

    //     console.log('check');
    //     var showBilling = component.get("c.getSubBillings");

    //         console.log('logg :'+showBilling);
    //         var isSelling = component.get("v.isSelling");
    //         console.log('shipmentId :'+component.get("v.id"));
    //         console.log('isSelling :'+isSelling);
    //         showBilling.setParams({
    //             shipmentId: component.get("v.id"),
    //             isSelling,
    //         });

    //         showBilling.setCallback(this, function (response) {
    //             var state = response.getState();
    //             var lstBill  = [];
    //             console.log(state);
    //             if (state === "SUCCESS") {
    //                 console.log('checksuccess');
    //                 var result = JSON.parse(JSON.stringify(response.getReturnValue())) || [];
    //                 console.log(result);
    //                 console.log(result.length);
    //                 for (var i = 0; i < result.length; i++) {
    //                     let a = result[i].Id;

    //                     console.log(a);
    //                     component.set("v.listIds",result[i].Id);
    //                     lstBill.push(result[i]);

    //                 }
    //                 component.set("v.listIds2", lstBill);
    //                 console.log('lstBill '+lstBill);
    //                 if(Mydiv.clientHeight==0){
    //                     var tb =Mydiv.querySelector('.subtable')

    //                         Mydiv.style.display = 'block';

    //                 }else{
    //                     Mydiv.style.display= "none";
    //                 }

    //                 console.log('checkLog');
    //     // event.stopPropagation();

    //             }
    //             else if (state === "ERROR") {
    //                 var errors = response.getError();
    //                 console.log("Error message: " + JSON.stringify(errors));
    //             }
    //         });
    //         $A.enqueueAction(showBilling);
    // },
    togglePackageList: function (component, event, helper) {
        var target = event.currentTarget;
        console.log('target :' + target.tagName);
        var imageDown = target.querySelector('.imageDown');
        console.log('imageDown :' + imageDown);
        var index = target;
        var dataIndex = index.getAttribute('data-index');
        console.log('dataIndex :' + dataIndex);

        var container = index.parentElement.parentElement.parentElement.parentElement;
        console.log('container :' + container.tagName);
        var Mydiv = container.querySelector(`.${dataIndex}`);
        // var Mydiv = container.querySelector(".subtable");
        console.log(Mydiv.clientHeight);
        if (Mydiv.clientHeight == 0) {
            Mydiv.style.display = 'block';
            imageDown.style.transform = 'rotate(90deg)';
            index.classList.add("boderbottom");
        } else {
            Mydiv.style.display = 'none';
            imageDown.style.transform = 'rotate(0deg)';

            index.classList.remove("boderbottom");
        }
    },
    onSaveAll: function (cmp, event, helper) {
        // const childRecordId = [];
        helper.onToggleSpinner(cmp);
        // const allRecords = [];
        // const formattedCmps = [];
        // const formattedCmps2 = [];
        var bill = cmp.get('v.ListWapper2');
        // for (var i = 0; i < bill.length; i++) {
        //     allRecords.push(bill[i])
            
        // }
        var billString = JSON.stringify(bill);
        // var bill = cmp.find('recordEditForm');
        console.log('1123 :' + bill.length);
        console.log('billbill :' + bill);
        // console.log('11234 :' + bill);
        var billChild = cmp.get('v.listChild');
        console.log('billChild :'+billChild);
        // var billString = JSON.stringify(cmp.get('v.ListWapper2'));
        console.log('billString :'+billString);

        // console.log('parent'+parent);
        var updateBillings = cmp.get('c.updateBillings');
        console.log('Checkkk');
        console.log('checkJson :'+JSON.stringify(cmp.get('v.ListWapper2')));
        updateBillings.setParams({
            jsonRecords: bill,
            billString: billString
        });
        console.log('Checkkk2');
        updateBillings.setCallback(this, function (response) {
            console.log('Checkkk3');
            var state = response.getState();
            //   $A.util.toggleClass(spinner, "slds-hide");
            if (state === 'SUCCESS') {
                console.log('SUCCESS');
                var errors = response.getError();
                console.log('Error', errors);
                console.log(JSON.parse(JSON.stringify(response.getReturnValue())));
                // window.reload();
                // $A.get('e.force:refreshView').fire();
            } else if (state === 'ERROR') {
                var errors = response.getError();
                console.log('Error', errors);
                var message = '';
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        message = errors[0].message;
                    }
                } else {
                    message = 'Unknown error';
                }
                console.log('message', message);
                var toastEvent = $A.get('e.force:showToast');
                toastEvent.setParams({
                    type: 'error',
                    message
                });
                toastEvent.fire();
            }
                helper.initData(cmp);
                helper.onToggleSpinner(cmp);
                eval("$A.get(e.force.refreshView).fire();");
        });
        $A.enqueueAction(updateBillings);
    }
});