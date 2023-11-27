({
    validateAccountRecords: function(component, event) {
        var isValid = true;
        var contList = component.get("v.contList");
        if(contList.length == 0){
            alert('Null');
            isValid = false;
        }
        return isValid;
    },
    
})