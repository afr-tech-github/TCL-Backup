({
    init : function(component, event, helper) {
        helper.initial(component);
    },
    deleteSearch : function(component, event, helper) {
        const value = event.target.value;
        if(value == ''){
            console.log('resetSearch')
            helper.initial(component);
        }

    },
    handleSearch: function(component, event, helper) {
        var searchValue_c = component.get("v.searchValue");
        if(searchValue_c != ''){
            
            helper.initial(component);
        }
        console.log('handle',searchValue_c)

    },
    handleCheck: function(component, event, helper) {
        // var listSelect= component.get("v.selected");
        var maintable= document.getElementById('myTableDebit');
        // console.log("maintable",123);

        var target = event.currentTarget;
        var parent = target.getAttribute("data-parent");
        // console.log("parent",parent);
        var checkboxes = maintable.querySelectorAll(`input.${parent}`)
        var checkAllCheckbox = maintable.querySelector(`#${parent}`)
        
        var listRemove = component.get("v.selectedPK");
        const value = event.target.value;

        if(!listRemove.includes(value)){
            listRemove.push(value);
           
        }else{
            const index = listRemove.indexOf(value);
            listRemove.splice(index, 1);
        }

        console.log(listRemove)
        component.set("v.selectedPK",listRemove);
        if( checkboxes.length>1){
            // console.log('nhuvvvx4')
            var allChecked = Array.from(checkboxes).reduce(function (acc, checkbox) {
                // console.log("true or false",checkbox);
                return acc && checkbox.checked;
            }, true);
            checkAllCheckbox.checked = allChecked;
        }else{
            // console.log('1slot')

            event.target.checked ? checkAllCheckbox.checked = true: checkAllCheckbox.checked = false
        }
        
    },
    AddOneOder: function(component, event, helper) {
         
        var maintable= document.getElementById('myTableDebit');
        var target = event.currentTarget;
        var parent = target.getAttribute("data-id");
        var checkboxes = maintable.querySelectorAll(`input.${parent}`)
        var listRemove = component.get("v.selectedPK");
        var listDetail = component.get("v.listDetail");


        const value = event.target.value;


        if(event.target.checked){   
            
            
            for(var i=0;i<checkboxes.length;i++){
                checkboxes[i].checked=true
            }

            for(var i=0;i<listDetail.length;i++){         
                if(listDetail[i].Document__c == value && listRemove.indexOf(listDetail[i].Id) === -1 ){
                    
                    listRemove.push(listDetail[i].Id);
                }
            }
           
          
              

          

        }else{
            for(var i=0;i<checkboxes.length;i++){   
                checkboxes[i].checked=false
            }

            for(var i=0;i<listDetail.length;i++){
                if(listDetail[i].Document__c == value && listRemove.indexOf(listDetail[i].Id) !== -1 ){
                    const index = listRemove.indexOf(listDetail[i].Id);
                      console.log("index",index);

                     listRemove.splice(index, 1);
                 
                }
            }

        }
        console.log(listRemove)

        component.set("v.selectedPK",listRemove);


       
         
    },
    togglePackageList: function(component, event, helper) {
        event.stopPropagation();
        var target = event.currentTarget;
        var imageDown = target.querySelector('.imageDown');
       
        
        var index = target;
        var dataIndex = index.getAttribute("data-index");

        var container= index.parentElement.parentElement.parentElement;

        var Mydiv= container.querySelector(`.${dataIndex}`);

    

        if(Mydiv.clientHeight==0){
            var table = Mydiv.querySelector('.subtable');
            
            var tableHeight = table.clientHeight;
           if( tableHeight > 50){
          

            var table2 = Mydiv.querySelector('.subtable');
            var tableHeight2 = table2.clientHeight;

           Mydiv.style.height = tableHeight2 + 20 + 'px';
            Mydiv.classList.add("show");
            imageDown.classList.add("rotate");
            index.classList.add("boderbottom");
           } 


        }else{
            imageDown.classList.remove("rotate");
            Mydiv.classList.remove("show");
            Mydiv.style.height = 0 + 'px';
        index.classList.remove("boderbottom");
        } 
    },
    deletePackage  : function(component, event, helper) {

        let confirmAction = confirm("Confirm deletion of selected document details?");
        if (confirmAction) {
            var listdelete = component.get("v.selectedPK")
            if(listdelete.length > 0){
            component.set("v.isLoading", true);

            var action3 = component.get("c.deletePKD");
            action3.setParams({
                ListPKID: listdelete
            });
          
            action3.setCallback(this, function(response) {

                var result= JSON.parse(response.getReturnValue())
                if (result.isSuccess) {
                    component.set("v.selectedPK", []);
                    // component.set("v.isLoading", true);
                    alert('Successful deletion')
                    helper.initial(component);   
                }else{
                    component.set("v.selectedPK", []);
                    alert(result.message)
                     helper.initial(component);
                }
                // $A.get('e.force:refreshView').fire();
            })
            $A.enqueueAction(action3);
        
            
        }
        } else {
          alert("Action canceled");
        }

}
})