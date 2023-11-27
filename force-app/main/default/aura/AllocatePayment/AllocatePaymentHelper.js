({
	helperMethod : function() {
		
	},
	findPaymentVoucher : function(component, event) {
		var action = component.get("c.QueryPaymentVoucher");
		var recordId = component.get("v.recordId");
		action.setParams({"recordId": recordId});
		console.debug('recordId :'+recordId);
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state === "SUCCESS") {
			  	console.log('SUCCESS-Voucher');
			 	 var result = response.getReturnValue();
				component.set("v.paymentVoucher",result);
			//   component.set("v.CurrentAllocationInit",component.get("v.paymentVoucher.Allocated_Amount__c"));
			//   console.log(component.get("v.paymentVoucher.Allocated_Amount__c"));
			  //do something with the result
			 	 this.findConnectBilling(component, event);
			}
			else if (state === "INCOMPLETE") {
			  // wait, what?
			}
			else if (state === "ERROR") {
			  var errors = response.getError();
			  if (errors && errors[0] && errors[0].message) {
				console.log("Error message: " +
							errors[0].message);
				reject(errors[0].message);
			} else {
				console.log("Unknown error");
				reject("Unknown error");
			}
			}
		  });
		  $A.enqueueAction(action);
	},

	findConnectBilling : function(component, event)
	{
		var action = component.get('c.QueryConnectBill');
		var currency = component.get('v.paymentVoucher.Payment_Currency__c');
		var paymentToId = component.get('v.paymentVoucher.Payment_To__r.Id');

		action.setParams({ 
			'Payment_to': paymentToId,
			'Currency_Voucher': currency
		});
		console.log('paymentToId :'+paymentToId);
		console.log('currency :'+currency);
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state === "SUCCESS") {
			  console.log('SUCCESS');
			  var result = response.getReturnValue();
			  component.set("v.connectBillList",result)
			  component.set("v.listValue",Array(result.length).fill(0));
			  //do something with the result
			}
			else if (state === "INCOMPLETE") {
			  // wait, what?
			}
			else if (state === "ERROR") {
			  var errors = response.getError();
			  if (errors && errors[0] && errors[0].message) {
				console.log("Error message: " +
							errors[0].message);
				reject(errors[0].message);
			} else {
				console.log("Unknown error");
				reject("Unknown error");
			}
			}
		  });
		  $A.enqueueAction(action);
	},

	showToast : function(title, message, error) {
        let toastParams = {
            title: title,
            message: message, // Error message
            type: error
        };
        let toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams(toastParams);
        toastEvent.fire();
    },

	createPaymentAllocation : function(component, event){
		var AmountList    = component.get("v.AmountList");
		var AllocateTo    = component.get("v.AllocateTo");
		var AllocaterToPr =component.get("v.AllocatedToPr");
		var currency      = component.get("v.paymentVoucher.Payment_Currency__c");
		var recordId = component.get("v.recordId");
		var currentAllocation = component.get("v.CurrentAllocation");

		if(currency!='VND' && currency!='USD'){
			this.showToast('Ooops !', 'Currency is not supported!', 'error');
			return;
		}
		else{
		var action = component.get("c.InsertPaymentAllocation");
		action.setParams({
			"CurrencyPayment" : currency, 
			"AllocateTo": AllocateTo,
			"Amount" : AmountList,
			"ConnectBill" : AllocaterToPr,
			"PaymentVoucherId" : recordId,
			 }); 
			 action.setCallback(this, function(response) {
				var state = response.getState();
				if (state === "SUCCESS") {
				  	console.log('SUCCESS_INSERT');
				  	var result = response.getReturnValue();
				  	console.log('result :'+result);
				  	this.showToast('Success !', result + ' Record Inserted Successfully', 'success');
          		  	$A.get("e.force:closeQuickAction").fire();
					//$A.get('e.force:refreshView').fire();
				  	console.log('SUCCESS_INSERT2');
					this.updatePaymentVoucher(component, event);
					console.log('SUCCESS_INSERT3');
				  //do something with the result
				}
				else if (state === "INCOMPLETE") {
				  // wait, what?
				}
				else if (state === "ERROR") {
				  	var errors = response.getError();
				  	if (errors && errors[0] && errors[0].message) {
						// console.log("Error message: " +
						// 			errors[0].message);
					this.showToast('Ooops !', errors[0].message, 'error');
					reject(errors[0].message);
				} else {
					//console.log("Unknown error");
					this.showToast('Ooops !', 'Unknown error', 'error');
					reject("Unknown error");
				}
				}
			  });
			  $A.enqueueAction(action);
		}
	},

	updatePaymentVoucher : function(component, event){
		var recordId = component.get("v.recordId");
		var currentAllocation = component.get("v.CurrentAllocation");
		var action = component.get("c.UpdatePaymentVoucher");
		action.setParams({
			"CurrentAllocation" : currentAllocation, 
			"PaymentVoucherId" : recordId,
			 }); 
			 action.setCallback(this, function(response) {
				var state = response.getState();
				if (state === "SUCCESS") {
				  	console.log('SUCCESS_INSERT_HMM');
				  	var result = response.getReturnValue();
				  	console.log('result :'+result);
					this.showToast('Success !',' Update Voucher Successfully', 'success');
				  //do something with the result
				}
				else if (state === "INCOMPLETE") {
				  // wait, what?
				}
				else if (state === "ERROR") {
				  	var errors = response.getError();
				  	if (errors && errors[0] && errors[0].message) {
						// console.log("Error message: " +
						// 			errors[0].message);
					this.showToast('Ooops !', errors[0].message, 'error');
					reject(errors[0].message);
				} else {
					//console.log("Unknown error");
					this.showToast('Ooops !', 'Unknown error', 'error');
					reject("Unknown error");
				}
				}
			  });
			  $A.enqueueAction(action);
	}
	
})