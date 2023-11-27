({
	doInit : function(component, event, helper) {
	},

	findPaymentVoucher : function(component, event, helper) {
		helper.findPaymentVoucher(component, event);
		//helper.findConnectBilling(component, event);
	},

	findConnectBilling : function(component, event, helper) {
		helper.findConnectBilling(component, event);
	},
	handleCheckboxChange: function(component, event, helper) {
		var selectedIndexes   = component.get("v.selectedIndexes") || [];
		var CurrentAllocation = component.get("v.CurrentAllocation") || 0;
		var connectBillList   = component.get("v.connectBillList");
		var AmountToAllocate  = component.get("v.paymentVoucher.Payment_Amount__c");
		var listValue         = component.get("v.listValue");

		var checkbox = event.getSource();
		var index = checkbox.get("v.name");
		var amount = connectBillList[index].Unpaid_Balance__c;
		
		console.log(checkbox.get("v.checked"))

		if (checkbox.get("v.checked")) {
			// Checkbox is checked
			selectedIndexes.push(index);
			listValue.splice(index, 1, amount);
			console.log('selectedIndexes :'+selectedIndexes);
			console.log('index added:'+index);

			//Change input field to disabled
			var input_field = document.getElementById(index);
			input_field.disabled = true;
			input_field.value = amount;
			input_field.setCustomValidity('');
			//Tells the lightning-input to show the error right away without needing interaction 
			input_field.reportValidity(); 
		} else {
			// Checkbox is unchecked
			var indexPos = selectedIndexes.indexOf(index);
			if (indexPos > -1) {

				//Update listValue and Index of selected checkbox
				selectedIndexes.splice(indexPos, 1);
				listValue.splice(index, 1, 0);
				console.log('selectedIndexes :'+selectedIndexes)
				console.log('index remove:'+index)

				//Change input field to enabled
				var input_field = document.getElementById(index);
				input_field.disabled = false;
				input_field.value = '';
				input_field.setCustomValidity('');
				//Tells the lightning-input to show the error right away without needing interaction 
				input_field.reportValidity(); 
				//Change checkbox All to unchecked
				var checkBoxAll = document.getElementById('checkboxAll');
				checkBoxAll.checked = false;
			}

		}

		var tempAllocate = 0.0;
		for (var i = 0; i < listValue.length; i++) {
			tempAllocate += parseFloat(listValue[i]);
		}

		var Balance          = AmountToAllocate-tempAllocate;



		component.set("v.Balance",Balance);
		component.set("v.CurrentAllocation", tempAllocate);
		component.set("v.selectedIndexes", selectedIndexes);
		component.set("v.listValue", listValue);
		console.log('listValue :'+listValue);

		console.log('selectedIndexes :'+selectedIndexes);
		console.log('ListValue :'+listValue);
		
	},

	handleInputChange: function(component, event, helper) {

		var inputField = event.getSource();
		var listValue = component.get("v.listValue");
		var AmoutToAllocate = component.get("v.paymentVoucher.Payment_Amount__c");
		var amount = inputField.get("v.value");
		var index = inputField.get("v.id");
		var max   = inputField.get("v.max");
		console.log(inputField)
		if (amount == '' || amount == 0) {
			amount = 0;
		}
		else if (amount > max) {
			// amount = max;
			helper.showToast('Ooops !', 'Value too high! Please check again!', 'error');
			//return;
		}
		else{
			inputField.setCustomValidity('');
			//Tells the lightning-input to show the error right away without needing interaction 
			inputField.reportValidity(); 
		}

		listValue.splice(index, 1, amount);

		component.set("v.listValue", listValue);
		var tempAllocate = 0.0;
		for (var i = 0; i < listValue.length; i++) {
			tempAllocate += parseFloat(listValue[i]);
		}

		component.set("v.CurrentAllocation", tempAllocate);
		var Balance = AmoutToAllocate-tempAllocate;
		component.set("v.Balance",Balance);
		console.log('listValue :'+listValue);
	
	},

	handleCheckboxAllChange: function(component, event, helper) {
		var selecAll = event.getSource();
		var checked  = selecAll.get("v.checked");
		var listValue = [];
		var selectedIndexes = [];
		var tempAllocate = 0.0;
		var listCheckbox = component.find('bill')||[];
		var connectBillList   = component.get("v.connectBillList")||[];
		var AmoutToAllocate   = component.get("v.paymentVoucher.Payment_Amount__c");

		// console.log(listCheckbox.length)
		// console.log(listCheckbox);
		if (listCheckbox.length != undefined)
		{
			if(checked){
				console.log('checked');
				for (var i = 0; i < listCheckbox.length; i++) {
					
					listCheckbox[i].set("v.checked", true);
					selectedIndexes.push(i);
					var unpaidBalance = connectBillList[i].Unpaid_Balance__c;
					listValue.push(unpaidBalance);
					console.log(unpaidBalance);
					tempAllocate += parseFloat(unpaidBalance);

					var input_field = document.getElementById(i);
					input_field.disabled = true;
					input_field.value = unpaidBalance;
					input_field.setCustomValidity('');
					//Tells the lightning-input to show the error right away without needing interaction 
					input_field.reportValidity(); 
				}
			}
			else {
				for (var i = 0; i < listCheckbox.length; i++) {
					var input_field = document.getElementById(i);
					listCheckbox[i].set("v.checked", false);
					listValue.push(0);
					input_field.disabled = false;
					input_field.value = '';
					input_field.setCustomValidity('');
					//Tells the lightning-input to show the error right away without needing interaction 
					input_field.reportValidity(); 
				}
			}
		}
		else{
			if(checked){
					listCheckbox.set("v.checked", true);
					selectedIndexes.push(0);
					var unpaidBalance = connectBillList[0].Unpaid_Balance__c;
					listValue.push(unpaidBalance);
					console.log(unpaidBalance);
					tempAllocate += parseFloat(unpaidBalance);

					var input_field = document.getElementById(0);
					input_field.disabled = true;
					input_field.value = unpaidBalance;
					input_field.setCustomValidity('');
					//Tells the lightning-input to show the error right away without needing interaction 
					input_field.reportValidity(); 
			}
			else {
					var input_field = document.getElementById(0);
					listCheckbox.set("v.checked", false);
					listValue.push(0);
					input_field.disabled = false;
					input_field.value = '';
					input_field.setCustomValidity('');
					//Tells the lightning-input to show the error right away without needing interaction 
					input_field.reportValidity(); 
			}
		}

		component.set("v.selectedIndexes", selectedIndexes);
		component.set("v.listValue", listValue);
		component.set("v.CurrentAllocation", tempAllocate);
		var Balance = AmoutToAllocate-tempAllocate;
		component.set("v.Balance",Balance);
		
		console.log('listValue :'+listValue);
		console.log('selectedIndexes :'+selectedIndexes);
	},

	handleConfirm: function(component, event, helper) {
		var listValue = component.get("v.listValue")||[];
		var connectBillList   = component.get("v.connectBillList");
		var Amount = [];
		var AllocateTo = [];
		var AllocatetoPR  = [];
		var Balance   = component.get("v.Balance")||0;

		if(Balance > 0){
			for (var i = 0; i < listValue.length; i++) {
				if (listValue[i] > 0 && listValue[i] <= connectBillList[i].Unpaid_Balance__c) {
					Amount.push(listValue[i]);
					AllocateTo.push(connectBillList[i].Billingid__c);
					AllocatetoPR.push(connectBillList[i].Id);
				}
				else if (listValue[i] > connectBillList[i].Unpaid_Balance__c) {
					helper.showToast('Ooops !', 'Allocation is too high! Please check again!', 'error');
					return;
				}
			}
			component.set("v.AmountList",Amount);
			component.set("v.AllocateTo",AllocateTo);
			component.set("v.AllocatedToPr",AllocatetoPR);
			console.log('Amount :'+component.get("v.AmountList"));
			console.log('AllocateTo :'+component.get("v.AllocateTo"));
			console.log('AllocatedToPr:'+component.get("v.AllocatedToPr"));
			helper.createPaymentAllocation(component, event);
		}
		else{
			helper.showToast('Ooops !', 'Balance can not be negative or 0! Please check again!', 'error');
		}
	}
	
})