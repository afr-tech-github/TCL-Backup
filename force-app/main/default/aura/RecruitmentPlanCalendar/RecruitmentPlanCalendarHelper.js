({
    showAnnualy : function(c, e, h) {
        var getAllLine = c.get("c.getAllRPLLineByWeek");
        getAllLine.setParams({
            rplId: c.get("v.recordId")
        });
        getAllLine.setCallback(this, function(response){
            let state = response.getState();
            if(state === 'SUCCESS'){
                console.log(112);
                c.set("v.listRPLLine", response.getReturnValue());
                let listRPLLine = c.get("v.listRPLLine");
                let dataTbody = document.querySelector(".data-tbody");
                dataTbody.innerHTML = ``;
                let weekTr = document.createElement("tr");
                weekTr.classList.add("week-head-tr");
                weekTr.innerHTML += `<th class='week-of-year'><div style='width: 200px; height: 100px; background-color: #ffe599;'>Weeks of year</div></th>`;
                weekTr.innerHTML += `<td><div style='width: 200px; height: 100px;'></div></td>`;
                weekTr.innerHTML += `<td><div style='width: 200px; height: 100px;'></div></td>`;
                weekTr.innerHTML += `<td><div style='width: 200px; height: 100px;'></div></td>`;
                weekTr.innerHTML += `<td><div style='width: 200px; height: 100px;'></div></td>`;
                weekTr.innerHTML += `<td><div style='width: 200px; height: 100px;'></div></td>`;
                dataTbody.appendChild(weekTr);
                console.log(113);
                console.log(listRPLLine.length);
                console.log(listRPLLine[0].Week_of_year__c);
                console.log(listRPLLine[listRPLLine.length-1].Week_of_year__c);
                for(let i = listRPLLine[0].Week_of_year__c; i<=listRPLLine[listRPLLine.length-1].Week_of_year__c; i++){
                    //calculate week date
                    console.log(118);
                    console.log(c.get("v.targetYear"));
                    let calD = (1 + (i - 1) * 7);
                    let nextCalD = (7 + (i - 1) * 7);
                    let calWeekD = new Date(c.get("v.targetYear"), 0, calD);
                    let nextCalWeekD = new Date (c.get("v.targetYear"), 0, nextCalD);
                    //
                    console.log(117);
                    let dataTr = document.createElement("tr");
                    dataTr.classList.add("week-body-tr");
                    dataTr.innerHTML += `<th class='week-of-year'><div style='width: 200px; height: 100px; background-color: #ffe599;'><div>${i}</div><div>(${calWeekD.getDate() >= 10 ? calWeekD.getDate() : '0' + (calWeekD.getDate())}/${calWeekD.getMonth() >= 9 ? calWeekD.getMonth() + 1 : '0' + (calWeekD.getMonth() + 1)}/${calWeekD.getFullYear()} -> ${nextCalWeekD.getDate() >= 10 ? nextCalWeekD.getDate() : '0' + (nextCalWeekD.getDate())}/${nextCalWeekD.getMonth() >= 9 ? nextCalWeekD.getMonth() + 1 : '0' + (nextCalWeekD.getMonth() + 1)}/${nextCalWeekD.getFullYear()})</div></th>`;
                    let colCount = 0;
                    console.log(114);
                    for(let j=0; j<listRPLLine.length; j++){
                        if(listRPLLine[j].Week_of_year__c && i == listRPLLine[j].Week_of_year__c){
                            
                            let dataTd = document.createElement("td");
                            let dataDiv = document.createElement("div");
                            dataDiv.style.height = 100+'px';
                            dataDiv.style.width = 200+'px';
                            dataDiv.classList.add('detail-btn');
                            colCount++;
                            console.log(115);
                            dataDiv.innerHTML += `<span title="${listRPLLine[j].Position__c && listRPLLine[j].Position__r.Name ? listRPLLine[j].Position__r.Name : ''}">${listRPLLine[j].Position__c && listRPLLine[j].Position__r.Name ? listRPLLine[j].Position__r.Name : ''}</span>`;
                            dataDiv.innerHTML += `<span title="${listRPLLine[j].Quantity__c ? listRPLLine[j].Quantity__c : ''}">${listRPLLine[j].Quantity__c ? listRPLLine[j].Quantity__c : ''}</span>`;
                            dataDiv.innerHTML += `<span title="${listRPLLine[j].ReasonsForRecruitment__c ? listRPLLine[j].ReasonsForRecruitment__c : ''}">${listRPLLine[j].ReasonsForRecruitment__c ? listRPLLine[j].ReasonsForRecruitment__c : ''}</span>`;
                            dataDiv.innerHTML += `<span title="${listRPLLine[j].Manager__c && listRPLLine[j].Manager__r.Name ? listRPLLine[j].Manager__r.Name : ''}">${listRPLLine[j].Manager__c && listRPLLine[j].Manager__r.Name ? listRPLLine[j].Manager__r.Name : ''}</span>`;
                            console.log(116);
                            if(listRPLLine[j].Change__c == 'Position'){
                                dataDiv.style.backgroundColor = '#fce5cd';
                            } else if(listRPLLine[j].Change__c == 'Quantity'){
                                dataDiv.style.backgroundColor = '#fff2cc';
                            } else if(listRPLLine[j].Change__c == 'Time'){
                                dataDiv.style.backgroundColor = '#d9ead3';
                            } else if(listRPLLine[j].Change__c == 'Mixed'){
                                dataDiv.style.backgroundColor = '#c9daf8';
                            } else if(listRPLLine[j].Change__c == 'Arised'){
                                dataDiv.style.backgroundColor = '#d9d2e9';
                            }
                            dataDiv.onclick = function(){
                                window.location.href = 'https://tcl-02-dev-ed.develop.lightning.force.com/'+listRPLLine[j].Id;
                            }
                            dataTd.appendChild(dataDiv);
                            dataTr.appendChild(dataTd);
                            
                        }
                        
                        if(colCount >= 4){
                            colCount++;
                            break;
                        }
                    }
                    if(colCount < 4){
                        for(let u=colCount; u<4; u++){
                            let dataTd = document.createElement("td");
                            let dataDiv = document.createElement("div");
                            dataDiv.style.height = 100+'px';
                            dataDiv.style.width = 200+'px';
                            dataTd.appendChild(dataDiv);
                            dataTr.appendChild(dataTd);
                            colCount++;
                        }
                        let dataTd = document.createElement("td");
                        dataTd.style.height = 100+'px';
                        dataTd.style.width = 200+'px';
                        dataTr.appendChild(dataTd);
                        
                    } 
                    if(colCount > 4){
                        let dataTd = document.createElement("td");
                        let dataDiv = document.createElement("div");
                        dataDiv.style.height = 100+'px';
                        dataDiv.style.width = 200+'px';
                        dataDiv.innerHTML = `More...`;
                        dataDiv.classList.add("more-btn");
                        dataDiv.dataset.column = 4;
                        dataDiv.dataset.week = i;
                        dataDiv.dataset.id = dataDiv.id = 'moreBtn'+dataDiv.dataset.week;
                        dataDiv.onclick = function(){
                            h.showMore(c, e, h, dataDiv.dataset.id);
                        }
                        dataTd.classList.add("more-btn-td");
                        dataTd.appendChild(dataDiv);
                        dataTr.appendChild(dataTd);
                    }
                    dataTbody.appendChild(dataTr);
                }
            }
        });
        $A.enqueueAction(getAllLine);
    },
    showQuarterly : function(c, e, h, quarter) {
        var getAllLine = c.get("c.getAllRPLLineByQuarter");
        getAllLine.setParams({
            rplId: c.get("v.recordId"),
            quarter: quarter
        });
        getAllLine.setCallback(this, function(response){
            let state = response.getState();
            if(state === 'SUCCESS'){
                c.set("v.listRPLLine", response.getReturnValue());
                let listRPLLine = c.get("v.listRPLLine");
                let dataTbody = document.querySelector(".data-tbody");
                dataTbody.innerHTML = ``;
                let weekTr = document.createElement("tr");
                weekTr.classList.add("week-head-tr");
                weekTr.innerHTML += `<th class='week-of-year'><div style='width: 200px; height: 100px; background-color: #ffe599;'>Weeks of year</div></th>`;
                weekTr.innerHTML += `<td><div style='width: 200px; height: 100px;'></div></td>`;
                weekTr.innerHTML += `<td><div style='width: 200px; height: 100px;'></div></td>`;
                weekTr.innerHTML += `<td><div style='width: 200px; height: 100px;'></div></td>`;
                weekTr.innerHTML += `<td><div style='width: 200px; height: 100px;'></div></td>`;
                weekTr.innerHTML += `<td><div style='width: 200px; height: 100px;'></div></td>`;
                dataTbody.appendChild(weekTr);
                for(let i = listRPLLine[0].Week_of_year__c; i<=listRPLLine[listRPLLine.length-1].Week_of_year__c; i++){
                    //calculate week date
                    let calD = (1 + (i - 1) * 7);
                    let nextCalD = (7 + (i - 1) * 7);
                    let calWeekD = new Date(c.get("v.targetYear"), 0, calD);
                    let nextCalWeekD = new Date (c.get("v.targetYear"), 0, nextCalD);
                    //
                    let dataTr = document.createElement("tr");
                    dataTr.classList.add("week-body-tr");
                    dataTr.innerHTML += `<th class='week-of-year'><div style='width: 200px; height: 100px; background-color: #ffe599;'><div>${i}</div><div>(${calWeekD.getDate() >= 10 ? calWeekD.getDate() : '0' + (calWeekD.getDate())}/${calWeekD.getMonth() >= 9 ? calWeekD.getMonth() + 1 : '0' + (calWeekD.getMonth() + 1)}/${calWeekD.getFullYear()} -> ${nextCalWeekD.getDate() >= 10 ? nextCalWeekD.getDate() : '0' + (nextCalWeekD.getDate())}/${nextCalWeekD.getMonth() >= 9 ? nextCalWeekD.getMonth() + 1 : '0' + (nextCalWeekD.getMonth() + 1)}/${nextCalWeekD.getFullYear()})</div></th>`;
                    let colCount = 0;
                    for(let j=0; j<listRPLLine.length; j++){
                        if(listRPLLine[j].Week_of_year__c && i == listRPLLine[j].Week_of_year__c){
                            
                            let dataTd = document.createElement("td");
                            let dataDiv = document.createElement("div");
                            dataDiv.style.height = 100+'px';
                            dataDiv.style.width = 200+'px';
                            dataDiv.classList.add('detail-btn');
                            colCount++;
                            dataDiv.innerHTML += `<span title="${listRPLLine[j].Position__c && listRPLLine[j].Position__r.Name ? listRPLLine[j].Position__r.Name : ''}">${listRPLLine[j].Position__c && listRPLLine[j].Position__r.Name ? listRPLLine[j].Position__r.Name : ''}</span>`;
                            dataDiv.innerHTML += `<span title="${listRPLLine[j].Quantity__c ? listRPLLine[j].Quantity__c : ''}">${listRPLLine[j].Quantity__c ? listRPLLine[j].Quantity__c : ''}</span>`;
                            dataDiv.innerHTML += `<span title="${listRPLLine[j].ReasonsForRecruitment__c ? listRPLLine[j].ReasonsForRecruitment__c : ''}">${listRPLLine[j].ReasonsForRecruitment__c ? listRPLLine[j].ReasonsForRecruitment__c : ''}</span>`;
                            dataDiv.innerHTML += `<span title="${listRPLLine[j].Manager__c && listRPLLine[j].Manager__r.Name ? listRPLLine[j].Manager__r.Name : ''}">${listRPLLine[j].Manager__c && listRPLLine[j].Manager__r.Name ? listRPLLine[j].Manager__r.Name : ''}</span>`;
                            if(listRPLLine[j].Change__c == 'Position'){
                                dataDiv.style.backgroundColor = '#fce5cd';
                            } else if(listRPLLine[j].Change__c == 'Quantity'){
                                dataDiv.style.backgroundColor = '#fff2cc';
                            } else if(listRPLLine[j].Change__c == 'Time'){
                                dataDiv.style.backgroundColor = '#d9ead3';
                            } else if(listRPLLine[j].Change__c == 'Mixed'){
                                dataDiv.style.backgroundColor = '#c9daf8';
                            } else if(listRPLLine[j].Change__c == 'Arised'){
                                dataDiv.style.backgroundColor = '#d9d2e9';
                            }
                            dataDiv.onclick = function(){
                                window.location.href = 'https://tcl-02-dev-ed.develop.lightning.force.com/'+listRPLLine[j].Id;
                            }
                            dataTd.appendChild(dataDiv);
                            dataTr.appendChild(dataTd);
                        }
                        
                        if(colCount >= 4){
                            colCount++;
                            break;
                        }
                    }
                    if(colCount < 4){
                        for(let u=colCount; u<4; u++){
                            let dataTd = document.createElement("td");
                            let dataDiv = document.createElement("div");
                            dataDiv.style.height = 100+'px';
                            dataDiv.style.width = 200+'px';
                            dataTd.appendChild(dataDiv);
                            dataTr.appendChild(dataTd);
                            colCount++;
                        }
                        let dataTd = document.createElement("td");
                        dataTd.style.height = 100+'px';
                        dataTd.style.width = 200+'px';
                        dataTr.appendChild(dataTd);
                        
                    } 
                    if(colCount > 4){
                        let dataTd = document.createElement("td");
                        let dataDiv = document.createElement("div");
                        dataDiv.style.height = 100+'px';
                        dataDiv.style.width = 200+'px';
                        dataDiv.innerHTML = `More...`;
                        dataDiv.classList.add("more-btn");
                        dataDiv.dataset.column = 4;
                        dataDiv.dataset.week = i;
                        dataDiv.dataset.id = dataDiv.id = 'moreBtn'+dataDiv.dataset.week;
                        dataDiv.onclick = function(){
                            h.showMore(c, e, h, dataDiv.dataset.id);
                        }
                        dataTd.classList.add("more-btn-td");
                        dataTd.appendChild(dataDiv);
                        dataTr.appendChild(dataTd);
                    }
                    dataTbody.appendChild(dataTr);
                }
            }
        });
        $A.enqueueAction(getAllLine);
    },
    showMonthly : function(c, e, h, month) {
        var getAllLine = c.get("c.getAllRPLLineByMonth");
        getAllLine.setParams({
            rplId: c.get("v.recordId"),
            month: month
        });
        getAllLine.setCallback(this, function(response){
            let state = response.getState();
            if(state === 'SUCCESS'){
                c.set("v.listRPLLine", response.getReturnValue());
                let listRPLLine = c.get("v.listRPLLine");
                let dataTbody = document.querySelector(".data-tbody");
                dataTbody.innerHTML = ``;
                let weekTr = document.createElement("tr");
                weekTr.classList.add("week-head-tr");
                weekTr.innerHTML += `<th class='week-of-year'><div style='width: 200px; height: 100px; background-color: #ffe599;'>Weeks of year</div></th>`;
                weekTr.innerHTML += `<td><div style='width: 200px; height: 100px;'></div></td>`;
                weekTr.innerHTML += `<td><div style='width: 200px; height: 100px;'></div></td>`;
                weekTr.innerHTML += `<td><div style='width: 200px; height: 100px;'></div></td>`;
                weekTr.innerHTML += `<td><div style='width: 200px; height: 100px;'></div></td>`;
                weekTr.innerHTML += `<td><div style='width: 200px; height: 100px;'></div></td>`;
                dataTbody.appendChild(weekTr);
                for(let i = listRPLLine[0].Week_of_year__c; i<=listRPLLine[listRPLLine.length-1].Week_of_year__c; i++){
                    //calculate week date
                    let calD = (1 + (i - 1) * 7);
                    let nextCalD = (7 + (i - 1) * 7);
                    let calWeekD = new Date(c.get("v.targetYear"), 0, calD);
                    let nextCalWeekD = new Date (c.get("v.targetYear"), 0, nextCalD);
                    //
                    let dataTr = document.createElement("tr");
                    dataTr.classList.add("week-body-tr");
                    dataTr.innerHTML += `<th class='week-of-year'><div style='width: 200px; height: 100px; background-color: #ffe599;'><div>${i}</div><div>(${calWeekD.getDate() >= 10 ? calWeekD.getDate() : '0' + (calWeekD.getDate())}/${calWeekD.getMonth() >= 9 ? calWeekD.getMonth() + 1 : '0' + (calWeekD.getMonth() + 1)}/${calWeekD.getFullYear()} -> ${nextCalWeekD.getDate() >= 10 ? nextCalWeekD.getDate() : '0' + (nextCalWeekD.getDate())}/${nextCalWeekD.getMonth() >= 9 ? nextCalWeekD.getMonth() + 1 : '0' + (nextCalWeekD.getMonth() + 1)}/${nextCalWeekD.getFullYear()})</div></th>`;
                    let colCount = 0;
                    for(let j=0; j<listRPLLine.length; j++){
                        if(listRPLLine[j].Week_of_year__c && i == listRPLLine[j].Week_of_year__c){
                            
                            let dataTd = document.createElement("td");
                            let dataDiv = document.createElement("div");
                            dataDiv.style.height = 100+'px';
                            dataDiv.style.width = 200+'px';
                            dataDiv.classList.add('detail-btn');
                            colCount++;
                            dataDiv.innerHTML += `<span title="${listRPLLine[j].Position__c && listRPLLine[j].Position__r.Name ? listRPLLine[j].Position__r.Name : ''}">${listRPLLine[j].Position__c && listRPLLine[j].Position__r.Name ? listRPLLine[j].Position__r.Name : ''}</span>`;
                            dataDiv.innerHTML += `<span title="${listRPLLine[j].Quantity__c ? listRPLLine[j].Quantity__c : ''}">${listRPLLine[j].Quantity__c ? listRPLLine[j].Quantity__c : ''}</span>`;
                            dataDiv.innerHTML += `<span title="${listRPLLine[j].ReasonsForRecruitment__c ? listRPLLine[j].ReasonsForRecruitment__c : ''}">${listRPLLine[j].ReasonsForRecruitment__c ? listRPLLine[j].ReasonsForRecruitment__c : ''}</span>`;
                            dataDiv.innerHTML += `<span title="${listRPLLine[j].Manager__c && listRPLLine[j].Manager__r.Name ? listRPLLine[j].Manager__r.Name : ''}">${listRPLLine[j].Manager__c && listRPLLine[j].Manager__r.Name ? listRPLLine[j].Manager__r.Name : ''}</span>`;
                            if(listRPLLine[j].Change__c == 'Position'){
                                dataDiv.style.backgroundColor = '#fce5cd';
                            } else if(listRPLLine[j].Change__c == 'Quantity'){
                                dataDiv.style.backgroundColor = '#fff2cc';
                            } else if(listRPLLine[j].Change__c == 'Time'){
                                dataDiv.style.backgroundColor = '#d9ead3';
                            } else if(listRPLLine[j].Change__c == 'Mixed'){
                                dataDiv.style.backgroundColor = '#c9daf8';
                            } else if(listRPLLine[j].Change__c == 'Arised'){
                                dataDiv.style.backgroundColor = '#d9d2e9';
                            }
                            dataDiv.onclick = function(){
                                window.location.href = 'https://tcl-02-dev-ed.develop.lightning.force.com/'+listRPLLine[j].Id;
                            }
                            dataTd.appendChild(dataDiv);
                            dataTr.appendChild(dataTd);
                        }
                        
                        if(colCount >= 4){
                            colCount++;
                            break;
                        }
                    }
                    if(colCount < 4){
                        for(let u=colCount; u<4; u++){
                            let dataTd = document.createElement("td");
                            let dataDiv = document.createElement("div");
                            dataDiv.style.height = 100+'px';
                            dataDiv.style.width = 200+'px';
                            dataTd.appendChild(dataDiv);
                            dataTr.appendChild(dataTd);
                            colCount++;
                        }
                        let dataTd = document.createElement("td");
                        dataTd.style.height = 100+'px';
                        dataTd.style.width = 200+'px';
                        dataTr.appendChild(dataTd);
                        
                    } 
                    if(colCount > 4){
                        let dataTd = document.createElement("td");
                        let dataDiv = document.createElement("div");
                        dataDiv.style.height = 100+'px';
                        dataDiv.style.width = 200+'px';
                        dataDiv.innerHTML = `More...`;
                        dataDiv.classList.add("more-btn");
                        dataDiv.dataset.column = 4;
                        dataDiv.dataset.week = i;
                        dataDiv.dataset.id = dataDiv.id = 'moreBtn'+dataDiv.dataset.week;
                        dataDiv.onclick = function(){
                            h.showMore(c, e, h, dataDiv.dataset.id);
                        }
                        dataTd.classList.add("more-btn-td");
                        dataTd.appendChild(dataDiv);
                        dataTr.appendChild(dataTd);
                    }
                    dataTbody.appendChild(dataTr);
                }
            }
        });
        $A.enqueueAction(getAllLine);
    },
    showMore: function(c,e,h, thisId){
        let moreBtn = document.querySelector("#"+thisId);
        let tarEle = moreBtn;
        let parentTd;
        let parentEle;
        while (tarEle.parentElement) {
            if (tarEle.parentElement.classList.contains('week-body-tr')) {
                parentEle = tarEle.parentElement;
                break;
            }
            tarEle = tarEle.parentElement;
        }
        tarEle = moreBtn;
        while (tarEle.parentElement) {
            if (tarEle.parentElement.classList.contains('more-btn-td')) {
                parentTd = tarEle.parentElement;
                break;
            }
            tarEle = tarEle.parentElement;
        }
        let getMoreRecord = c.get("c.getMoreRecord");
        getMoreRecord.setParams({
            rplId: c.get("v.recordId"),
            weekNum: moreBtn.dataset.week,
            colNum: moreBtn.dataset.column,
        });
        getMoreRecord.setCallback(this, function(resp){
            let state = resp.getState();
            if(state === 'SUCCESS'){
                c.set("v.listRPLLineAdditional", resp.getReturnValue());
                let listRPLLineAdditional = c.get("v.listRPLLineAdditional");
                parentTd.remove();
                
                for(let j=0; j<listRPLLineAdditional.length; j++){
                    let dataTd = document.createElement("td");
                    let dataDiv = document.createElement("div");
                    dataDiv.style.height = 100+'px';
                    dataDiv.style.width = 200+'px';
                    dataDiv.innerHTML += `<span title="${listRPLLineAdditional[j].Position__c && listRPLLineAdditional[j].Position__r.Name ? listRPLLineAdditional[j].Position__r.Name : ''}">${listRPLLineAdditional[j].Position__c && listRPLLineAdditional[j].Position__r.Name ? listRPLLineAdditional[j].Position__r.Name : ''}</span>`;
                            dataDiv.innerHTML += `<span title="${listRPLLineAdditional[j].Quantity__c ? listRPLLineAdditional[j].Quantity__c : ''}">${listRPLLineAdditional[j].Quantity__c ? listRPLLineAdditional[j].Quantity__c : ''}</span>`;
                            dataDiv.innerHTML += `<span title="${listRPLLineAdditional[j].ReasonsForRecruitment__c ? listRPLLineAdditional[j].ReasonsForRecruitment__c : ''}">${listRPLLineAdditional[j].ReasonsForRecruitment__c ? listRPLLineAdditional[j].ReasonsForRecruitment__c : ''}</span>`;
                            dataDiv.innerHTML += `<span title="${listRPLLineAdditional[j].Manager__c && listRPLLineAdditional[j].Manager__r.Name ? listRPLLineAdditional[j].Manager__r.Name : ''}">${listRPLLineAdditional[j].Manager__c && listRPLLineAdditional[j].Manager__r.Name ? listRPLLineAdditional[j].Manager__r.Name : ''}</span>`;
                    if(listRPLLineAdditional[j].Change__c == 'Position'){
                        dataDiv.style.backgroundColor = '#fce5cd';
                    } else if(listRPLLineAdditional[j].Change__c == 'Quantity'){
                        dataDiv.style.backgroundColor = '#fff2cc';
                    } else if(listRPLLineAdditional[j].Change__c == 'Time'){
                        dataDiv.style.backgroundColor = '#d9ead3';
                    } else if(listRPLLineAdditional[j].Change__c == 'Mixed'){
                        dataDiv.style.backgroundColor = '#c9daf8';
                    } else if(listRPLLineAdditional[j].Change__c == 'Arised'){
                        dataDiv.style.backgroundColor = '#d9d2e9';
                    }
                    dataTd.appendChild(dataDiv);
                    parentEle.appendChild(dataTd);
                    if(j == 3){
                        break;
                    }
                }
                
                if(listRPLLineAdditional.length > 4){
                    let curColNum = Number(moreBtn.dataset.column);
                    moreBtn.dataset.column = curColNum + 4;
                    parentEle.appendChild(parentTd);
                }
            } else {
                console.log('error');
            }
        });
        $A.enqueueAction(getMoreRecord);
    },
    getRPL: function(c,e,h,resolve, reject){
        let getCurRPL = c.get("c.getCurRPL");
        getCurRPL.setParams({
            id: c.get("v.recordId")
        });
        getCurRPL.setCallback(this, function(resp){
            let state = resp.getState();
            if(state === 'SUCCESS'){
                c.set("v.curentRPL", resp.getReturnValue());
                let curRPL = c.get("v.curentRPL");
                console.log(curRPL.StartDate__c);
                let targetYear = curRPL.StartDate__c.split("-")[0];
                c.set("v.targetYear", Number(targetYear));
                
                resolve();
            } else {
                console.log('Error h.getRPL');
                reject();
            }
        });
        $A.enqueueAction(getCurRPL);
    }
})