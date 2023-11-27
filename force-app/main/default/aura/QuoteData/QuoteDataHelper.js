({
    showData: function (cmp) {
        cmp.set('v.isShowSpinner', true);
        cmp.set('v.isShowData', true);
        cmp.set('v.isShowConvert', false);
        cmp.set('v.isShowIQCmp', false);
        cmp.set('v.isShowCreateCmp', false);
        cmp.set('v.isShowUpdateCmp', false);
        var getFieldLabels = cmp.get("c.getFieldLabels");
        var getInfoData = cmp.get('c.getData');
        var getSaleOrder = cmp.get('v.SaleOrder');
        getFieldLabels.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set('v.fieldLabels', JSON.parse(response.getReturnValue() || '{}'));
            }
            else if (state === "ERROR") {
                var errors = response.getError();
            }
        });

        getInfoData.setParams({
            QuoteId: cmp.get('v.recordId')
        })
        getInfoData.setCallback(this, function (response) {
            var state = response.getState();
            var result = [];
            if (state === 'SUCCESS') {
                var res = response.getReturnValue();
                // console.log('111111' + JSON.stringify(res));
                getSaleOrder.Quote_ID__c = cmp.get('v.recordId'),

                    getSaleOrder.Customer__c = res.Quote[0].RequesterCompany__c,
                    getSaleOrder.Commodity__c = res.Quote[0].Commodity1__c,
                    getSaleOrder.Description_of_Goods__c = res.Quote[0].DescriptionofGoods__c,
                    getSaleOrder.Cargo_Quantity__c = res.Quote[0].Cargo_Quantity__c,
                    getSaleOrder.INCOTERMS__c = res.Quote[0].INCOTERMS__c,
                    getSaleOrder.Measurement_CBM__c = res.Quote[0].MeasurementTotalCBM__c,
                    getSaleOrder.NetWeight__c = res.Quote[0].NetWeight__c,
                    getSaleOrder.GrossWeight__c = res.Quote[0].GrossWeight__c,
                    getSaleOrder.DIM_Dimension__c = res.Quote[0].DIM_Dimension__c,
                    getSaleOrder.Volume__c = res.Quote[0].VesselFlight__c,
                    // getSaleOrder.Vessel_Flight__c = res.Quote[0].Volume__c,
                    getSaleOrder.Voyage__c = res.Quote[0].Voyage__c,
                    getSaleOrder.ETD__c = res.Quote[0].ETD__c,
                    getSaleOrder.ETA__c = res.Quote[0].ETA__c,
                    getSaleOrder.Valid_Date__c = res.Quote[0].Validto__c,
                    getSaleOrder.Remarks__c = res.Quote[0].Remarks__c,
                    getSaleOrder.ContainerQuantity1__c = res.Quote[0].ContainerQuantity1__c,
                    getSaleOrder.ContainerQuantity2__c = res.Quote[0].ContainerQuantity2__c,
                    getSaleOrder.ContainerQuantity3__c = res.Quote[0].ContainerQuantity3__c,
                    getSaleOrder.ContainerType1__c = res.Quote[0].ContainerType1__c,
                    getSaleOrder.ContainerType2__c = res.Quote[0].ContainerType2__c,
                    getSaleOrder.ContainerType3__c = res.Quote[0].ContainerType3__c,
                    getSaleOrder.MeasurementTotalCBM__c = res.Quote[0].MeasurementTotalCBM__c,
                    
                    
                    getSaleOrder.ShipmentTerm__c = res.Quote[0].ShipmentTerm__c,
                    getSaleOrder.TypeofTrade__c = res.Quote[0].TypeofTrade__c,
                    getSaleOrder.TransportationWay__c = res.Quote[0].TransportationWay__c,
                    cmp.set('v.SaleOrder', getSaleOrder);
                cmp.set('v.IQID', res.Quote[0].InquiryID__c);

                console.log('111111' + JSON.stringify(res.QuoteRoute));

                for (var i = 0; i < res.QuoteRoute.length; i++) {
                    var inRoute = {
                        'Id': res.QuoteRoute[i].Id,
                        'Name': res.QuoteRoute[i].Name,
                        'Route_Name__c': res.QuoteRoute[i].Route_Name__c,
                        'Origin_Country__c': res.QuoteRoute[i].Origin_Country__c,
                        'Destination_Country__c': res.QuoteRoute[i].Destination_Country__c,
                        'POLAOL__c': res.QuoteRoute[i].POLAOL__c,
                        'PODAOD__c': res.QuoteRoute[i].PODAOD__c,
                        'Place_of_Receipt__c': res.QuoteRoute[i].Place_of_Receipt__r ? res.QuoteRoute[i].Place_of_Receipt__r.Name : '',
                        'Place_of_Delivery__c': res.QuoteRoute[i].Place_of_Delivery__r ? res.QuoteRoute[i].Place_of_Delivery__r.Name : '',

                        'NameComboProduct': '',
                        'NameComboProductId': '',
                        // // 'ComboProduct': {},
                        'QuoteLineNoCombo': []
                    }
                    if ('QuoteLineCombo' in res) {
                        var checkExist = res.QuoteLineCombo.filter(function (ele, index) {
                            return ele.Quote_route__c == res.QuoteRoute[i].Id;
                        })
                        if (checkExist.length > 0) {
                            inRoute.NameComboProduct = checkExist[0].Combo_Product__r.Name;
                            inRoute.NameComboProductId = checkExist[0].Combo_Product__r.Id;
                            var resultComboproduct = {
                                // 'IdComboProduct:': checkExist[0].ComboProduct__r.Name,
                                'QuoteLineCombo': checkExist,

                            }
                            // var getListCombobroduct = [];
                            // res.InquiryLineCombo.forEach(function (ele, index) {
                            //     if (!getListCombobroduct.includes(ele.ComboProduct__c)) {
                            //         getListCombobroduct.push(ele.ComboProduct__c);
                            //     }
                            // })
                            // console.log(JSON.stringify(getListCombobroduct));
                            // // var co
                            // for (var k = 0; k < getListCombobroduct.length; k++) {
                            //     var ComboproductItem =
                            //     {
                            //         'Id': getListCombobroduct[k],
                            //         'IdInquiryRoute': res.InquiryRoute[i].Id,
                            //         // 'Name': 
                            //         'InquiryLineCombo': []
                            //     }

                            //     var findCombo = res.InquiryLineCombo.filter(function (ele, index) {
                            //         return ele.ComboProduct__c == getListCombobroduct[k] && ele.Route__c == ComboproductItem.IdInquiryRoute;
                            //     })
                            //     if (findCombo.length > 0) {
                            //         findCombo.forEach(function (ele, index) {
                            //             ComboproductItem.InquiryLineCombo.push(ele);
                            //         });
                            //     }
                            inRoute.ComboProduct = resultComboproduct;
                            // }
                        }
                    }
                    if ('QuoteLineNoCombo' in res) {
                        var find = res.QuoteLineNoCombo.filter(function (ele, index) {
                            return ele.Quote_route__c == res.QuoteRoute[i].Id;
                        });
                        // console.log('check find : ' + JSON.stringify(find));
                        if (find.length > 0) {
                            for (var j = 0; j < find.length; j++) {
                                inRoute.QuoteLineNoCombo.push(find[j])
                            }
                        }
                    }
                    result.push(inRoute);
                }
                cmp.set('v.result', result);
                
                cmp.set('v.isShowSpinner', false);
            }
        })
        $A.enqueueAction(getInfoData);
        $A.enqueueAction(getFieldLabels);
    },
})