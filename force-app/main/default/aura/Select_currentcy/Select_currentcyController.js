// currencySelectorController.js
({
    handleCurrencyChange: function(component, event, helper) {
        var selectedValue = event.getSource().get("v.value");
        component.set("v.selectedCurrency", selectedValue);
    },

    printDocument: function(component, event, helper) {
        var recordId = component.get("v.recordId");
        var selectedCurrency = component.get("v.selectedCurrency");
        var isChecked = component.get("v.isChecked");
        let url=''
        console.log('run');
        // Chuyển đến trang "print_Document" với các tham số recordId và cur
        if(isChecked){

            
            var GetData = component.get("c.generateAttachmentFileForDocument");
    
    
        
            GetData.setParams({
                id: component.get("v.recordId"),
                cur: selectedCurrency
            });
            GetData.setCallback(this, function(response) {
                var state = response.getState();
                console.log(state);
                if (state === "SUCCESS") {
                    component.set("v.packages", response.getReturnValue());
                    
                    console.log('rủnun')
                }
        })
        $A.enqueueAction(GetData)
     }
     url= '/apex/print_Document?id=' + recordId + '&cur=' + selectedCurrency;
                    window.location.href=url;
        
        // Sử dụng Navigation Service để chuyển đến trang
    }
})