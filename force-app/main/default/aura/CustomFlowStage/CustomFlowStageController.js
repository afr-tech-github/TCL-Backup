({
    init : function(c, e, h) {
        h.initData(c,e,h);
    },
    markAsComplete: function(c,e,h){
        let stageContent;
        let stageItems = document.querySelectorAll(".stage-item");
        for(let i = 0; i<stageItems.length; i++){
            if(stageItems[i].classList.contains("current") && i != (stageItems.length-1)){
                stageContent = stageItems[i+1].querySelector(".stage-item-content");
            }
        }
        let markCurrentStage = c.get("c.markCurrentStage");
        markCurrentStage.setParams({
            id: c.get("v.recordId"),
            curStage: stageContent.textContent
        });
        markCurrentStage.setCallback(this,(resp)=>{
            let state = resp.getState();
            if(state === 'SUCCESS'){
                if(resp.getReturnValue()){
                    h.showMyToast('success', "Stage changed successfully.");
                    h.initData(c,e,h);
                    let markCompleteBtn = document.querySelector(".mark-btn.complete-mark");
                    if(!markCompleteBtn.classList.contains("show")){
                        markCompleteBtn.classList.add("show");
                    }
                    let markStageBtn = document.querySelector(".mark-btn.stage-mark");
                    if(markStageBtn.classList.contains("show")){
                        markStageBtn.classList.remove("show");
                    }
                } else {
                    h.showMyToast('error', "Stage changed failed.");
                }
            } else {
                h.showMyToast('error', "Stage changed failed.");
            }
        });
        $A.enqueueAction(markCurrentStage);
    },
    markAsCurrent: function(c,e,h){
        let stageItem = document.querySelector(".stage-item.selected");
        let stageContent = stageItem.querySelector(".stage-item-content");

        let markCurrentStage = c.get("c.markCurrentStage");
        markCurrentStage.setParams({
            id: c.get("v.recordId"),
            curStage: stageContent.textContent
        });
        markCurrentStage.setCallback(this,(resp)=>{
            let state = resp.getState();
            if(state === 'SUCCESS'){
                if(resp.getReturnValue()){
                    h.showMyToast('success', "Stage changed successfully.");
                    h.initData(c,e,h);
                    let markCompleteBtn = document.querySelector(".mark-btn.complete-mark");
                    if(!markCompleteBtn.classList.contains("show")){
                        markCompleteBtn.classList.add("show");
                    }
                    let markStageBtn = document.querySelector(".mark-btn.stage-mark");
                    if(markStageBtn.classList.contains("show")){
                        markStageBtn.classList.remove("show");
                    }
                } else {
                    h.showMyToast('error', "Stage changed failed.");
                }
            } else {
                h.showMyToast('error', "Stage changed failed.");
            }
        });
        $A.enqueueAction(markCurrentStage);
    },
    selectStage: function(c,e,h){
        let curEle = e.currentTarget;
        let selectedStageItem = document.querySelector(".stage-item.selected");
        if(selectedStageItem.classList.contains("selected")){
            selectedStageItem.classList.remove("selected");
        }
        if(!curEle.classList.contains("selected")){
            curEle.classList.add("selected");
        }
        if(curEle.classList.contains("current")){
            let markCompleteBtn = document.querySelector(".mark-btn.complete-mark");
            if(!markCompleteBtn.classList.contains("show")){
                markCompleteBtn.classList.add("show");
            }
            let markStageBtn = document.querySelector(".mark-btn.stage-mark");
            if(markStageBtn.classList.contains("show")){
                markStageBtn.classList.remove("show");
            }
        } else {
            let markCompleteBtn = document.querySelector(".mark-btn.complete-mark");
            if(markCompleteBtn.classList.contains("show")){
                markCompleteBtn.classList.remove("show");
            }
            let markStageBtn = document.querySelector(".mark-btn.stage-mark");
            if(!markStageBtn.classList.contains("show")){
                markStageBtn.classList.add("show");
            }
        }
        let stageContent = curEle.querySelector(".stage-item-content");
        if(stageContent.textContent == 'Inviting'){
            h.getAppTodoList(c,e,h, 'Schedule the interview');
            let todoBox = document.querySelector(".todo-box");
            if(todoBox){
                todoBox.style.display = 'block';
            }
            let assesBox = document.querySelector(".asses-box");
            if(assesBox){
                assesBox.style.display = 'none';
            }
        } else if(stageContent.textContent == 'Sending Offer Letter'){
            h.getAppTodoList(c,e,h, 'Send offer letter');
            let todoBox = document.querySelector(".todo-box");
            if(todoBox){
                todoBox.style.display = 'block';
            }
            let assesBox = document.querySelector(".asses-box");
            if(assesBox){
                assesBox.style.display = 'none';
            }
        } else if(stageContent.textContent != 'CV Qualified' && stageContent.textContent != 'Considering' && stageContent.textContent != 'Completed'){
            h.getAppAssesList(c,e,h,stageContent.textContent);
            let todoBox = document.querySelector(".todo-box");
            if(todoBox){
                todoBox.style.display = 'none';
            }
            let assesBox = document.querySelector(".asses-box");
            if(assesBox){
                assesBox.style.display = 'block';
            }
        }
    }
})