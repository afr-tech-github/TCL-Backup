({
    showData: function (cmp, valueSearch) {
        cmp.set('v.isShowSpinner', true);
        var today = new Date();
        var dd = String(today.getDate()).padStart(2, '0');
        var mm = String(today.getMonth() + 1).padStart(2, '0'); 
        var yyyy = today.getFullYear();
        var currentDate = yyyy + '-' + mm + '-' + dd;
        cmp.set('v.Quote.QuoteIssueDate__c', currentDate);
        
        var getFieldLabels = cmp.get("c.getFieldLabels");
        var getInfoData = cmp.get('c.getData');
        var getQuote = cmp.get('v.Quote');
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
            InquiryId: cmp.get('v.sObjectName') === 'Inquiry__c' ? cmp.get('v.recordId') : cmp.get('v.IQID'),
            valueSearch: valueSearch
        })
        getInfoData.setCallback(this, function (response) {
            var state = response.getState();
            var result = [];
            if (state === 'SUCCESS') {
                var res = response.getReturnValue();
                console.log('ahahha' + JSON.stringify(res));
                if (res.InquiryRoute.length == 0) {
                    cmp.set('v.showNoRecords', true);
                    // cmp.set('v.isShowData', false);
                    // cmp.set('v.isShowConvert', false);
                } else {
                    cmp.set('v.showNoRecords', false);
               
                    getQuote.PickupAddress__c = res.InquiryRoute[0].PickUpAddress__c,
                    getQuote.DeliveryAddress__c = res.InquiryRoute[0].DeliveryAddress__c,
                    // InquiryRoute
                    // console.log('111111' + JSON.stringify(res));
                    getQuote.RequesterCompany__c = res.Inquiry[0].Customer__c,

                    getQuote.ContainerType1__c = res.Inquiry[0].ContainerType1__c,
                    // console.log(' getQuote.ContainerType1__c ',getQuote.ContainerType1__c )
                    getQuote.ContainerType2__c = res.Inquiry[0].ContaineType2__c,
                    // console.log(' getQuote.ContainerType2__c ',getQuote.ContainerType2__c )
                    getQuote.ContainerType3__c = res.Inquiry[0].ContainerType3__c,
                    // console.log(' getQuote.ContainerType3__c ',getQuote.ContainerType3__c )
                    getQuote.ContainerQuantity1__c = res.Inquiry[0].ContainerQuantity1__c,
                    // console.log(' getQuote.ContainerQuantity1__c ',getQuote.ContainerQuantity1__c )
                    getQuote.ContainerQuantity2__c = res.Inquiry[0].ContainerQuantity2__c,
                    // console.log(' getQuote.ContainerQuantity2__c ',getQuote.ContainerQuantity2__c )
                    getQuote.ContainerQuantity3__c = res.Inquiry[0].ContainerQuantity3__c,
                    // console.log(' getQuote.ContainerQuantity3__c ',getQuote.ContainerQuantity3__c )

                    // getQuote.RequesterCompany__c = res.Inquiry[0].Customer__c,

                        getQuote.RequestCompanysPIC__c = res.Inquiry[0].Contact__c,
                        getQuote.QuotePIC__c = res.Inquiry[0].CreatedById,
                        getQuote.Validto__c = res.Inquiry[0].Valid_End_Date__c,
                        getQuote.RequestDetail__c = res.Inquiry[0].InquirysNote__c,
                        getQuote.QuoteName__c = res.Inquiry[0].Subject__c,
                        getQuote.Remarks__c = res.Inquiry[0].Remark__c,

                        
                        // console.log('xx',res.Inquiry[0].Subject__c);
                        getQuote.InquiryID__c = cmp.get('v.recordId'),
                        getQuote.TypeofTrade__c = res.Inquiry[0].TypeofTrade__c,
                        getQuote.ShipmentTerm__c = res.Inquiry[0].ShipmentTerm__c,
                        getQuote.TransportationWay__c = res.Inquiry[0].TransportationWay__c,
                        getQuote.Commodity1__c = res.Inquiry[0].Commodity__c,
                        getQuote.DescriptionofGoods__c = res.Inquiry[0].Description_of_Goods__c,
                        getQuote.TypeOfCargo1__c = res.Inquiry[0].Type_of_Cargo__c,
                        getQuote.INCOTERMS__c = res.Inquiry[0].Incoterms__c,
                        getQuote.Cargo_Quantity__c = res.Inquiry[0].Quantity__c,
                        getQuote.GrossWeight__c = res.Inquiry[0].Gross_WeightKg__c,
                        getQuote.NetWeight__c = res.Inquiry[0].Net_WeightKg__c,
                        getQuote.MeasurementTotalCBM__c = res.Inquiry[0].MeasurementCBM__c,
                        getQuote.Volume__c = res.Inquiry[0].Volume__c,
                        getQuote.DIM_Dimension__c = res.Inquiry[0].DIMDimension__c,
                        getQuote.ETD__c = res.Inquiry[0].ETD__c,
                        getQuote.ETA__c = res.Inquiry[0].ETA__c,

                        cmp.set('v.Quote', getQuote);
                    for (var i = 0; i < res.InquiryRoute.length; i++) {
                        var inRoute = {
                            'Id': res.InquiryRoute[i].Id,
                            'Name': res.InquiryRoute[i].Name,
                            'OriginCountry': res.InquiryRoute[i].OriginCountry__c,
                            'DestinationCountry': res.InquiryRoute[i].DestinationCountry__c,
                            'POL': res.InquiryRoute[i].POLAOL__c,
                            'POD': res.InquiryRoute[i].PODAOD__c,
                            "RouteName__c": res.InquiryRoute[i].RouteName__c,

                            'Place_of_Receipt__c': res.InquiryRoute[i].Place_of_Receipt__r ? res.InquiryRoute[i].Place_of_Receipt__r.Name : '',
                            'Place_of_Delivery__c': res.InquiryRoute[i].Place_of_Delivery__r ? res.InquiryRoute[i].Place_of_Delivery__r.Name : '',
                            'NameComboProduct': '',
                            'NameComboProductId': '',
                            // 'ComboProduct': {},
                            'InquiryNoCombo': []
                            
                        }
                        // console.log('Place_of_Receipt__c', res.InquiryRoute[i].Place_of_Receipt__r.Name,
                        // 'Place_of_Delivery__c', res.InquiryRoute[i].Place_of_Delivery__r.Name);
                        if ('InquiryLineCombo' in res) {
                            var checkExist = res.InquiryLineCombo.filter(function (ele, index) {
                                return ele.Route__c == res.InquiryRoute[i].Id;
                            })
                            if (checkExist.length > 0) {
                                inRoute.NameComboProduct = checkExist[0].ComboProduct__r.Name;
                                inRoute.NameComboProductId = checkExist[0].ComboProduct__r.Id;
                                for (var j = 0; j < checkExist.length; j++) {
                                    if (checkExist[j].StartTime__c) {
                                        var timeStart = new Date(checkExist[j].StartTime__c)
                                        checkExist[j].StartTime__c = timeStart.toLocaleString();
                                    }
                                    if (checkExist[j].EndTime__c) {
                                        var timeEnd = new Date(checkExist[j].EndTime__c)
                                        checkExist[j].EndTime__c = timeEnd.toLocaleString();
                                    }
                                    // inRoute.InquiryLineCombo.push(checkExist[j])
                                }
                                var resultComboproduct = {
                                    // 'IdComboProduct:': checkExist[0].ComboProduct__r.Name,
                                    'InquiryLineCombo': checkExist,

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
                        if ('InquiryLineNoCombo' in res) {
                            var find = res.InquiryLineNoCombo.filter(function (ele, index) {
                                return ele.Route__c == res.InquiryRoute[i].Id;
                            });
                            // console.log('check find : ' + JSON.stringify(find));
                            if (find.length > 0) {
                                for (var j = 0; j < find.length; j++) {
                                    if (find[j].StartTime__c) {
                                        var timeStart = new Date(find[j].StartTime__c)
                                        find[j].StartTime__c = timeStart.toLocaleString();
                                    }
                                    if (find[j].EndTime__c) {
                                        var timeEnd = new Date(find[j].EndTime__c)
                                        find[j].EndTime__c = timeEnd.toLocaleString();
                                    }
                                    inRoute.InquiryNoCombo.push(find[j])
                                }
                            }
                        }
                        result.push(inRoute);
                    }
                    cmp.set('v.result', result);

                }
                cmp.set('v.isShowSpinner', false);

            }
        })
        $A.enqueueAction(getInfoData);
        $A.enqueueAction(getFieldLabels);
    }
})