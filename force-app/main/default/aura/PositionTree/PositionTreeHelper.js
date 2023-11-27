({
    findPosById : function(c, resolve, reject) {
        // let treePos = c.find("tree-pos");
        let recordId = c.get('v.recordId');
        let getPositionById = c.get('c.getPositionById');
        getPositionById.setParams({
            id: recordId
        });
        getPositionById.setCallback(this, (response)=>{
            let state = response.getState();
            if(state === 'SUCCESS'){
                c.set("v.positions", response.getReturnValue());
                let positions = c.get("v.positions");
                c.set("v.curPosition", positions[0]);
                // treePos.set("v.selectedItem", positions[0].name);
                resolve();
            } else {
                reject();
            }
        });
        $A.enqueueAction(getPositionById);
    },
    findAllPos : function(c, resolve, reject) {
        let recordId = c.get('v.recordId');
        let getAllPosition = c.get('c.getAllPosition');
        getAllPosition.setParams({
            id: recordId
        });
        getAllPosition.setCallback(this, (response)=>{
            let state = response.getState();
            if(state === 'SUCCESS'){
                let positions = c.get("v.positions");
                c.set("v.concatPositions", response.getReturnValue());
                let concatPositions = c.get("v.concatPositions");
                positions = positions.concat(concatPositions);
                c.set("v.positions", positions);
                resolve();
            } else {
                reject();
            }
        });
        $A.enqueueAction(getAllPosition);
    },
    list_to_tree: function (list, c) {
        var map = {}, node, parentItems = [], i;
        
        for (i = 0; i < list.length; i += 1) {
            map[list[i].name] = i; // initialize the map
            list[i].items = []; // initialize the children
        }
        
        for (i = 0; i < list.length; i += 1) {
          node = list[i];
          if (node.parentId) {
            // if you have dangling branches check that map[node.parentId] exists
            list[map[node.parentId]].items.push(node);
          } else {
            parentItems.push(node);
          }
        }
        c.set("v.items", parentItems);
      }
})