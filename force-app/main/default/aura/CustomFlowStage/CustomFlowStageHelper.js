({
    initData : function(c,e,h) {
        let newPro = new Promise((res,rej)=>{
            let getCurrentStage = c.get("c.getCurrentStage");
            getCurrentStage.setParams({
                id: c.get("v.recordId")
            })
            getCurrentStage.setCallback(this, function(resp){
                let state = resp.getState();
                if(state === 'SUCCESS'){
                    c.set("v.currentStage", resp.getReturnValue());
                    res();
                } else {
                    console.log('ERROR getCurrentStage');
                    rej();
                }
            });
            $A.enqueueAction(getCurrentStage);
        })
        newPro.then(()=>{
            return new Promise((res, rej)=>{
                let getStageList = c.get("c.getPickListValuesIntoList");
                getStageList.setCallback(this, function(resp){
                    let state = resp.getState();
                    if(state === 'SUCCESS'){
                        c.set("v.stageList", resp.getReturnValue());
                        res();
                    } else {
                        rej();
                    }
                });
                $A.enqueueAction(getStageList);
            })
        })
        .then(()=>{
            let stageItems = document.querySelectorAll(".stage-item");
            
            let checkFlag = false;
            for(let i=0; i<stageItems.length; i++){
                if(checkFlag && !stageItems[i].classList.contains("current")){
                    stageItems[i].classList.remove("checked");
                }
                if(!stageItems[i].classList.contains("current") && !checkFlag){
                    stageItems[i].classList.add("checked");
                } else {
                    checkFlag = true;
                }
            }

            if(c.get("v.currentStage") == 'Inviting'){
                h.getAppTodoList(c,e,h, 'Schedule the interview');
                let todoBox = document.querySelector(".todo-box");
                if(todoBox){
                    todoBox.style.display = 'block';
                }
                
                let assesBox = document.querySelector(".asses-box");
                if(assesBox){
                    assesBox.style.display = 'none';
                }
            } else if(c.get("v.currentStage") == 'Sending Offer Letter'){
                h.getAppTodoList(c,e,h, 'Send offer letter');
                let todoBox = document.querySelector(".todo-box");
                if(todoBox){
                    todoBox.style.display = 'block';
                }
                let assesBox = document.querySelector(".asses-box");
                if(assesBox){
                    assesBox.style.display = 'none';
                }
            } else if(c.get("v.currentStage") != 'CV Qualified' && c.get("v.currentStage") != 'Considering' && c.get("v.currentStage") != 'Completed'){
                h.getAppAssesList(c,e,h,c.get("v.currentStage"));
                let todoBox = document.querySelector(".todo-box");
                if(todoBox){
                    todoBox.style.display = 'none';
                }
                let assesBox = document.querySelector(".asses-box");
                if(assesBox){
                    assesBox.style.display = 'block';
                }
            }
        });
    },
    showMyToast : function(toastType, mess) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "type": toastType,
            "message": mess
        });
        toastEvent.fire();
    },
    getAppAssesList: function(c,e,h, curStage){
        let getApplicationAssessmentList = c.get("c.getApplicationAssessmentList");
        getApplicationAssessmentList.setParams({
            applicationId: c.get("v.recordId"),
            curStage: curStage
        });
        getApplicationAssessmentList.setCallback(this, (resp)=>{
            let state = resp.getState();
            if(state === 'SUCCESS'){
                c.set("v.appAssessmentList", resp.getReturnValue());
            } else {
                c.set("v.appAssessmentList", []);
            }
        });
        $A.enqueueAction(getApplicationAssessmentList);
    },
    getAppTodoList: function(c,e,h, actionF){
        let getApplicationToDoList = c.get("c.getApplicationToDoList");
        getApplicationToDoList.setParams({
            applicationId: c.get("v.recordId"),
            actionF: actionF
        });
        getApplicationToDoList.setCallback(this, (resp)=>{
            let state = resp.getState();
            if(state === 'SUCCESS'){
                c.set("v.appTodoList", resp.getReturnValue());
            } else {
                c.set("v.appTodoList", []);
            }
        });
        $A.enqueueAction(getApplicationToDoList);
    }
})