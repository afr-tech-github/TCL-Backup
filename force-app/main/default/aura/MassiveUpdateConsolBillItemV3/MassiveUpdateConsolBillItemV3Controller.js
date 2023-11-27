({
    init: function (cmp, event, helper) {
        
        var isFirstRecord = cmp.get('v.isFirstRecord');
        isFirstRecord && cmp.set('v.recordLabelClass', 'slds-form-element__label');
    },
    updateFields: function (cmp, event, helper) {
        var isSelected = cmp.get('v.isSelected');
        if (isSelected) {
            isSelected && console.log('update this record: ' + cmp.get('v.id'));
            var params = event.getParam('arguments');
            var fieldData = JSON.parse(JSON.stringify(params.fields));
            var fieldNames = fieldData.map(x => x.key);
            var fieldCmps = helper.findFieldCmps(cmp);

            for (var i = 0; i < fieldCmps.length; i++) {
                var fieldName = fieldCmps[i].get('v.fieldName');
                if (fieldNames.includes(fieldName)) {
                    var value = fieldData.find(x => x.key == fieldName).value;
                    fieldCmps[i].set('v.value', value);
                }
            }
        }
    },
    getFields: function (cmp, event, helper) {
        var id = cmp.get('v.id'), isSelected = cmp.get('v.isSelected'), obj = { Id: id, isSelected };
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
            }), 5000
        );
    },
    onToggleSelect: function (cmp, event, helper) {
        var params = event.getParam('arguments');
        cmp.set('v.isSelected', params.isSelected);
    },
    onToggleMultiCurrency: function(cmp, event, helper){
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
        console.log("onRecordLoad...", cmp.get('v.id'));
        if (!cmp.get("v.firstTimeRecordLoad")) return;

        var isSelling = cmp.get('v.isSelling');
        var fields = event.getParam("recordUi").record.fields;

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
    onDelete: function (cmp, event, helper) {
        var msg = 'Are you sure you want to delete this item?';
        if (!confirm(msg)) {
            return;
        } else {
            helper.onToggleSpinner(cmp);

            var deleteBilling = cmp.get("c.deleteBilling");
            console.log('logg :'+deleteBilling);
            deleteBilling.setParams({ id: cmp.get('v.id') });

            deleteBilling.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var res = JSON.parse(JSON.stringify(response.getReturnValue())) || false;
                    if (res) {
                        cmp.set('v.isShow', false);
                        var parent = cmp.get('v.parent');
                        parent.getDeleteItem(cmp.get('v.id'));
                    }
                }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    console.log("Error message: " + JSON.stringify(errors));
                }

                helper.onToggleSpinner(cmp);
                $A.get('e.force:refreshView').fire();
            });
            $A.enqueueAction(deleteBilling);
        }
    },
    onChange: function (cmp, event, helper) {
        var billId = event.getSource().get('v.class');
        var listBillId = cmp.get('v.listBillId');
        if(!listBillId.includes(billId)){
            listBillId.push(billId);
        }
        console.log(listBillId);

    },
    showSubBill: function (cmp, event, helper){
        var showBilling = cmp.get("c.getSubBillings");
        
            console.log('logg :'+showBilling);
            var isSelling = cmp.get("v.isSelling");
            console.log('shipmentId :'+cmp.get("v.id"));
            console.log('isSelling :'+isSelling);
            showBilling.setParams({ 
                shipmentId: cmp.get("v.id"), 
                isSelling,
            });

            showBilling.setCallback(this, function (response) {
                var state = response.getState();
                var lstBill  = [];
                console.log(state);
                if (state === "SUCCESS") {
                    
                    var result = JSON.parse(JSON.stringify(response.getReturnValue())) || [];
                    console.log(result);
                    console.log(result.length);
                    for (var i = 0; i < result.length; i++) {
                        let a = result[i].Id;
                        
                        console.log(a);
                        cmp.set("v.listIds",result[i].Id);
                        lstBill.push(result[i]);
                     
                        
                    }
                    cmp.set("v.listIds2", lstBill);
                    
                }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    console.log("Error message: " + JSON.stringify(errors));
                }
            });
            $A.enqueueAction(showBilling);
    },
    togglePackageList: function(component, event, helper) {
        var target = event.currentTarget;
            console.log('target :'+target.tagName);
            var imageDown = target.querySelector('.imageDown');
            console.log('imageDown :'+imageDown);
            // var testCmps2 = cmp.find("ship");
            // console.log('testCmps :'+testCmps2);
            var index = target;
            var dataIndex = index.getAttribute("data-index");
            console.log('dataIndex :'+dataIndex);
            
            var container= index.parentElement.parentElement;
            console.log('container :'+container.tagName);
            var Mydiv= container.querySelector(`.${dataIndex}`);
            console.log("Mydiv", Mydiv.clientHeight);
            console.log("Mydiv 2", Mydiv.tagName);
            console.log("Mydiv :", container.querySelector( '.' + dataIndex));
            


        console.log('check');
        var showBilling = component.get("c.getSubBillings");
        
            console.log('logg :'+showBilling);
            var isSelling = component.get("v.isSelling");
            console.log('shipmentId :'+component.get("v.id"));
            console.log('isSelling :'+isSelling);
            showBilling.setParams({ 
                shipmentId: component.get("v.id"), 
                isSelling,
            });

            showBilling.setCallback(this, function (response) {
                var state = response.getState();
                var lstBill  = [];
                console.log(state);
                if (state === "SUCCESS") {
                    console.log('checksuccess');
                    var result = JSON.parse(JSON.stringify(response.getReturnValue())) || [];
                    console.log(result);
                    console.log(result.length);
                    for (var i = 0; i < result.length; i++) {
                        let a = result[i].Id;
                        
                        console.log(a);
                        component.set("v.listIds",result[i].Id);
                        lstBill.push(result[i]);
                     
                        
                    }
                    component.set("v.listIds2", lstBill);
                    console.log('lstBill '+lstBill);
                    if(Mydiv.clientHeight==0){
                        var tb =Mydiv.querySelector('.subtable')
                      
                            Mydiv.style.display = 'block';
                      
                        
                    }else{
                        Mydiv.style.display= "none";
                    }

                    console.log('checkLog');
        // event.stopPropagation();
        
                }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    console.log("Error message: " + JSON.stringify(errors));
                }
            });
            $A.enqueueAction(showBilling);

            
       

        // Mydiv.style.height = container.querySelector('item'+dataIndex).clientHeight + 'px';

        // if(Mydiv.clientHeight==0){
        //     console.log("checklog");
        //     var table = Mydiv.querySelector('.subtable');
        //     console.log('table :'+table.tagName);
        //     var tableHeight = table.clientHeight;
        //     if( tableHeight > 50){
          

        //     var table2 = Mydiv.querySelector('.subtable');
        //     console.log('table2 :'+table2);
        //     var tableHeight2 = table2.clientHeight;
        //     console.log('tableHeight2 :'+tableHeight2);
        //     Mydiv.style.height = tableHeight2 + 20 + 'px';
        //     Mydiv.classList.add("show");
        //     imageDown.classList.add("rotate");
        //     index.classList.add("boderbottom");
        //    } 


        // }else{
        //     imageDown.classList.remove("rotate");
        //     Mydiv.classList.remove("show");
        //     Mydiv.style.height = 0 + 'px';
        // index.classList.remove("boderbottom");
        // } 
    },
    
})