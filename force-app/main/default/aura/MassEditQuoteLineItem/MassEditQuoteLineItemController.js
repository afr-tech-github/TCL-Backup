({
    doInit: function (cmp, event, helper) {
        cmp.set('v.DefaultRef', cmp.get('v.RefPriceID'));
        cmp.set('v.DefaultSection', cmp.get('v.sectionQuoteLine'));
        
    },
    onChangeItem: function (cmp, event) {

        var countRefPriceID = cmp.get('v.countRefPriceID');
        var countSection = cmp.get('v.countSection');
        var quoteLineChanged = cmp.get('v.quoteLineChanged');
        var valueLookup = event.getSource().get('v.selectedRecordId');
        var objectLookup = event.getSource().get('v.objectType');
        var value = event.getSource().get('v.value');
        var fieldName = event.getSource().get('v.fieldName');
        var getCheckbox = event.getSource().get("v.checked");
        var getClass = event.getSource().get("v.class");
        var getChecked = event.getSource().get('v.checked');

        if (event.getParam('arguments')) {
            var params = event.getParam('arguments');
            quoteLineChanged[0].isChecked = params.isSelected;
            cmp.set('v.isSelected', params.isSelected);
        }
        if (fieldName) {
            if (typeof (value) === 'object' && Object.keys(value).length) {
                quoteLineChanged[0][fieldName] = value[0];
            } else if (typeof (value) === 'object' && !Object.keys(value).length) {
                quoteLineChanged[0][fieldName] = null;
            }
            else {
                quoteLineChanged[0][fieldName] = value;
            }
        }
        else if (objectLookup == 'ReferencePrice__c') {
            // var div = document.querySelector( '#hihihaha.slds-dropdown' );
            // div.
            if (!event.getParam("oldValue") && countRefPriceID == 0) {
                quoteLineChanged[0].ReferencePrice__c = valueLookup;
                cmp.set('v.countRefPriceID', 1);
            } else if (countRefPriceID != 0) {
                if (countRefPriceID % 2 != 0) {
                    quoteLineChanged[0].ReferencePrice__c = null;
                } else if (countRefPriceID % 2 == 0) {
                    quoteLineChanged[0].ReferencePrice__c = valueLookup;
                }
                countRefPriceID++;
                cmp.set('v.countRefPriceID', countRefPriceID);
            }
        }
        else if (objectLookup == 'Section__c') {
            if (!event.getParam("oldValue") && countSection == 0) {
                quoteLineChanged[0].Section__c = valueLookup;
                cmp.set('v.countSection', 1);
            } else if (countSection != 0) {
                if (countSection % 2 != 0) {
                    quoteLineChanged[0].Section__c = null;
                } else if (countSection % 2 == 0) {
                    quoteLineChanged[0].Section__c = valueLookup;
                }
                countSection++;
                console.log(countSection);
                cmp.set('v.countSection', countSection);
            }
        } else if (getClass == 'selectItem') {
            quoteLineChanged[0].isChecked = getChecked;
        }
        
        if (Object.keys(quoteLineChanged[0]).length == 3) {
            if (quoteLineChanged[0].ReferencePrice__c == cmp.get('v.DefaultRef')) {
                delete quoteLineChanged[0].ReferencePrice__c;
            } else if (quoteLineChanged[0].Section__c == cmp.get('v.DefaultSection')) {
                delete quoteLineChanged[0].Section__c;
            }
        }
        cmp.set('v.quoteLineChanged', quoteLineChanged);
        console.log('000000' + JSON.stringify(cmp.get('v.quoteLineChanged')));
        if (Object.keys(quoteLineChanged[0]).length != 2) {
            var cmpEvent = cmp.getEvent("changedFields");
            cmpEvent.setParams({
                "lstQuoteLineChanged": quoteLineChanged[0],
            });
            cmpEvent.fire();
        }
    },
})