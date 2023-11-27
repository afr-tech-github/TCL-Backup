({
	findFieldCmps : function(cmp) {
        var cmps = cmp.find('field'), formattedCmps = [];
        console.log('log field');
        if(!cmps) return {};
        if ($A.util.isArray(cmps)) {
            formattedCmps = cmps;
        } else {
            formattedCmps = [cmps];
        }
        return formattedCmps;
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
        console.log('checkLog');
        event.stopPropagation();
        var target = event.currentTarget;
        console.log('target :'+target.tagName);
        var imageDown = target.querySelector('.imageDown');
        console.log('imageDown :'+imageDown);
        
        var index = target;
        var dataIndex = index.getAttribute("data-index");
        console.log('dataIndex :'+dataIndex);
        
        var container= index.parentElement.parentElement;
        console.log('container :'+container.tagName);
        var Mydiv= container.querySelector(`.${dataIndex}`);
        console.log("Mydiv", Mydiv.clientHeight);
        console.log("Mydiv 2", Mydiv.tagName);
        console.log("Mydiv :", container.querySelector( '.' + dataIndex));
        if(Mydiv.clientHeight==0){
            var tb =Mydiv.querySelector('table')
            setTimeout(() => {
                Mydiv.style.height=tb.clientHeight + 'px';
            }, 500);
            
        }else{
            Mydiv.style.height=0 + 'px'
        }
       

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
	onToggleSpinner: function(cmp){
        var spinner = cmp.find("spinner");
        $A.util.toggleClass(spinner, "slds-hide");
    },
    onTest : function(cmp, event){
        var boolean1 = false;
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
                console.log(state);
                if (state === "SUCCESS") {
                    
                    var result = JSON.parse(JSON.stringify(response.getReturnValue())) || [];
                    console.log(result);
                    console.log(result.length);
                    for (var i = 0; i < result.length; i++) {
                        let a = result[i].Id;
                        console.log(a);
                        cmp.set("v.listIds",result[i].Id);
                        cmp.set("v.listIds2", result[i]);
                    }
                    var lstBill = cmp.get("v.listIds");
                     console.log(lstBill);
                     boolean1 = true;
                    return boolean1;
                }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    console.log("Error message: " + JSON.stringify(errors));
                }
            });
            $A.enqueueAction(showBilling);
    }
})