({
    init: function (cmp, event, helper) {
        helper.initial(cmp);
       
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
    togglePackageList: function(component, event, helper) {
        event.stopPropagation();
        var target = event.currentTarget;
        var imageDown = target.querySelector('.imageDown');
       
        
        var index = target;
        var dataIndex = index.getAttribute("data-index");

        var container= index.parentElement.parentElement.parentElement;

        var Mydiv= container.querySelector(`.${dataIndex}`);

    

        if(Mydiv.clientHeight==0){
            var table = Mydiv.querySelector('.subtable');
            
            var tableHeight = table.clientHeight;
           if( tableHeight > 50){
          

            var table2 = Mydiv.querySelector('.subtable');
            var tableHeight2 = table2.clientHeight;

           Mydiv.style.height = tableHeight2 + 20 + 'px';
            Mydiv.classList.add("show");
            imageDown.classList.add("rotate");
            index.classList.add("boderbottom");
           } 


        }else{
            imageDown.classList.remove("rotate");
            Mydiv.classList.remove("show");
            Mydiv.style.height = 0 + 'px';
        index.classList.remove("boderbottom");
        } 
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
    deleteSearch : function(component, event, helper) {
        const value = event.target.value;
        if(value == ''){
            console.log('resetSearch')
            helper.initial(component);
        }

    },
    handleSearch: function(component, event, helper) {
        var searchValue_c = component.get("v.searchValue");
        if(searchValue_c != ''){
            
            helper.initial(component);
        }
        console.log('handle',searchValue_c)

    },
    handleCheck: function(component, event, helper) {
        // var listSelect= component.get("v.selected");
        var maintable= document.getElementById('myTableDebit');
        // console.log("maintable",123);

        var target = event.currentTarget;
        var parent = target.getAttribute("data-parent");
        // console.log("parent",parent);
        var checkboxes = maintable.querySelectorAll(`input.${parent}`)
        var checkAllCheckbox = maintable.querySelector(`#${parent}`)
        
        var listRemove = component.get("v.selectedPK");
        const value = event.target.value;

        if(!listRemove.includes(value)){
            listRemove.push(value);
           
        }else{
            const index = listRemove.indexOf(value);
            listRemove.splice(index, 1);
        }

        console.log(listRemove)
        component.set("v.selectedPK",listRemove);
        if( checkboxes.length>1){
            // console.log('nhuvvvx4')
            var allChecked = Array.from(checkboxes).reduce(function (acc, checkbox) {
                // console.log("true or false",checkbox);
                return acc && checkbox.checked;
            }, true);
            checkAllCheckbox.checked = allChecked;
        }else{
            // console.log('1slot')

            event.target.checked ? checkAllCheckbox.checked = true: checkAllCheckbox.checked = false
        }
        
    },
    AddOneOder: function(component, event, helper) {
         
        var maintable= document.getElementById('myTableDebit');
        var target = event.currentTarget;
        var parent = target.getAttribute("data-id");
        var checkboxes = maintable.querySelectorAll(`input.${parent}`)
        var listRemove = component.get("v.selectedPK");
        var listDetail = component.get("v.listDetail");


        const value = event.target.value;


        if(event.target.checked){   
            
            
            for(var i=0;i<checkboxes.length;i++){
                checkboxes[i].checked=true
            }

            for(var i=0;i<listDetail.length;i++){         
                if(listDetail[i].Document__c == value && listRemove.indexOf(listDetail[i].Id) === -1 ){
                    
                    listRemove.push(listDetail[i].Id);
                }
            }
           
          
              

          

        }else{

            console.log("xxnxxv3");
            for(var i=0;i<checkboxes.length;i++){   
                checkboxes[i].checked=false
            }

            for(var i=0;i<listDetail.length;i++){
                if(listDetail[i].Document__c == value && listRemove.indexOf(listDetail[i].Id) !== -1 ){
                    const index = listRemove.indexOf(listDetail[i].Id);
                      console.log("index",index);

                     listRemove.splice(index, 1);
                 
                }
            }

        }
        console.log(listRemove)

        component.set("v.selectedPK",listRemove);


       
         
    },
    togglePackageList: function(component, event, helper) {
        event.stopPropagation();
        var target = event.currentTarget;
        var imageDown = target.querySelector('.imageDown');
       
        
        var index = target;
        var dataIndex = index.getAttribute("data-index");

        var container= index.parentElement.parentElement.parentElement;

        var Mydiv= container.querySelector(`.${dataIndex}`);

    

        if(Mydiv.clientHeight==0){
            var table = Mydiv.querySelector('.subtable');
            
            var tableHeight = table.clientHeight;
           if( tableHeight > 50){
          

            var table2 = Mydiv.querySelector('.subtable');
            var tableHeight2 = table2.clientHeight;

           Mydiv.style.height = tableHeight2 + 20 + 'px';
            Mydiv.classList.add("show");
            imageDown.classList.add("rotate");
            index.classList.add("boderbottom");
           } 


        }else{
            imageDown.classList.remove("rotate");
            Mydiv.classList.remove("show");
            Mydiv.style.height = 0 + 'px';
        index.classList.remove("boderbottom");
        } 
    },
})