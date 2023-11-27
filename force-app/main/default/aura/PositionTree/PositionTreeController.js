({
    init : function(c, e, h) {
        let newPromise = new Promise((resolve, reject)=>{
            h.findPosById(c, resolve, reject);
        });
        newPromise
        // .then(()=>{
        //     let curPos = c.get("v.curPosition");
        //         let positions = c.get("v.positions");
        //         let items = [{
        //             label: curPos.Position__r.Name,
        //             name: curPos.Id,
        //             metatext: curPos.Name,
        //             expanded: true,
        //             parentId: curPos.ReportTo__c,
        //             items: []
        //         }];
        //         let flag = true;
        //         while(flag){
        //             if(curPos!= null && curPos.ReportTo__c != null && curPos.ReportTo__c != ''){
        //                 for(let i = 0; i<positions.length; i++){
        //                     if(positions[i].Id == curPos.ReportTo__c){
        //                         let parentItems = [{
        //                             label: positions[i].Position__r.Name,
        //                             name: positions[i].Id,
        //                             metatext: positions[i].Name,
        //                             expanded: true,
        //                             parentId: curPos.ReportTo__c,
        //                             items: items
        //                         }];
        //                         items = parentItems;
        //                         curPos = positions[i];
                                
        //                         break;
        //                     }
        //                 }
        //             } else {
        //                 c.set("v.items", items);
        //                 flag = false;
        //             }
        //         }
        // })
        .then(()=>{
            return new Promise((resolve, reject)=>{
                h.findAllPos(c, resolve, reject);
            });
        })
        .then(()=>{
            return new Promise((resolve, reject)=>{
                let positions = c.get("v.positions");
                let parentItems = [];
                for(let i = 0; i<positions.length; i++){
                    let pos = {
                        label: positions[i].Position__r.Name,
                        name: positions[i].Id,
                        metatext: positions[i].Name,
                        expanded: true,
                        parentId: positions[i].ReportTo__c,
                        items: null
                    };
                    parentItems.push(pos);
                }
                resolve(parentItems);
            });
        })
        .then((parentItems)=>{
            h.list_to_tree(parentItems, c);
        })
        .catch(()=>{

        })
        .finally(()=>{
        });
        
    },
})