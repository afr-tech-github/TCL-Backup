({
    validateAccountRecords: function(component, event) {
        //Validate all account records
        var isValid = true;
        var billList = component.get("v.billList");
        // for (var i = 0; i < billList.length; i++) {
        //     if (billList[i].Name == '') {
        //         isValid = false;
        //         alert('Account Name cannot be blank on '+(i + 1)+' row number');
        //     }
        // }
        if(billList.length == 0){
            alert('Null');
            isValid = false;
        }
        return isValid;
    },
    validateFieldPricingName: function(component, event) {
      //Validate all account records
      var isValid = true;
      var billList = component.get("v.billList");
      for (var i = 0; i < billList.length; i++) {
          if (billList[i].PricingName__c == '') {
              isValid = false;
              // alert('Account Name cannot be blank on '+(i + 1)+' row number');
          }
      }
      // if(billList.length == 0){
      //     alert('Null');
      //     isValid = false;
      // }
      return isValid;
  },
    // callUpdateRefresh: function(){
    //     var appEvent = $A.get("e.c:addBillUpdateEvt");
    //     appEvent.fire();
    // },
   
      onToggleSpinner: function (cmp) {
        var spinner = cmp.find("spinner");
        $A.util.toggleClass(spinner, "slds-hide");
      }
    
})