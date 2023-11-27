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
                    // break;
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
        // fields.Street = '32 Prince Street';
        cmp.find('recordEditForm').submit(fields);
    },
    onLoad: function (cmp, event, helper) {
        console.log("onRecordLoad...", cmp.get('v.id'));
        if (!cmp.get("v.firstTimeRecordLoad")) return;

        var isSelling = cmp.get('v.isSelling');
        // var isVATRateSelling = cmp.get('v.isVATRateSelling');
        // var isVATRateSelling = cmp.get('v.isVATRateSelling');
        // var isCurrencyConversionForSelling = cmp.get('v.isCurrencyConversionForSelling');
        // var isExchangeRateSellingDebit = cmp.get('v.isExchangeRateSellingDebit');
        // var isVATRateBuying = cmp.get('v.isVATRateBuying');
        // var isExchangeRateBuyingCredit = cmp.get('v.isExchangeRateBuyingCredit');
        // var isCurrencyConversionForBuying = cmp.get('v.isCurrencyConversionForBuying');
        // var isAdvancePaymentonbehalfofOurCompany = cmp.get('v.isAdvancePaymentonbehalfofOurCompany');
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
    // onClone: function (cmp, event, helper) {
        
    //     var isSelected = cmp.get('v.isSelected');
    //     console.log('isSelected: ',isSelected);
    //     console.log('cmp: ',cmp);
    //     if(!isSelected){
    //         console.log('if isSelected: ',isSelected);
    //     	var msg = 'Are you sure you want to clone this item?';
    //     	if (!confirm(msg)) {
    //         	return;
    //     	} else {
    //         	helper.onToggleSpinner(cmp);
    //         	var cloneQuoteline = cmp.get("c.cloneQuoteline2");
                
    //         	cloneQuoteline.setParams({ id: cmp.get('v.id') });
    //         	cloneQuoteline.setCallback(this, function (response) {
    //             	var state = response.getState();
    //                 console.log('stateeee :'+state);
    //             	if (state === "SUCCESS") {
    //                 	var res = JSON.parse(JSON.stringify(response.getReturnValue())) || false;
    //                     console.log('res :'+res);
    //                     // $A.get('e.force:refreshView').fire();
    //                     // $A.get("e.force:editRecord").fire();
    //                 	if (res) {
                            
    //                     	cmp.set('v.isShow', true);
    //                     	var parent = cmp.get('v.parent');
                            
    //                     	parent.onClone(cmp, event, helper);
    //                         // console.log('parent :'+ parent.onClone());
    //                         // helper.onRefresh(cmp);
    //                 	}
    //             	}
    //             	else if (state === "ERROR") {
    //                 	var errors = response.getError();
    //                 	console.log("Error message: " + JSON.stringify(errors));
    //             	}

    //                 // helper.onRefresh123(cmp);
    //         // fieldCmps[i].set('v.value', buyTankaLocal);
    //                 // $A.get('e.force:refreshView').fire(); 
    //                 // spinner.reload(); 
    //         	});
                
    //         	$A.enqueueAction(cloneQuoteline);
                
    //             // var parent1 = cmp.get('v.isShow');
    //             // parent1.refresh();
                
    //     	}
    //         // window.parent.reload();
    //         // parent.refresh();
    //         console.log('cloneQuoteline :'+cloneQuoteline);
    //     }
    //     // helper.onSave(cmp);
        
    //     // helper.onRefresh(cmp);
        
    // },
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

    }
})