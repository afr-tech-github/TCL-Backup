({
  helperMethod: function () {},
  getTrans: function (component, event, helper) {
    var getTrans = component.get("c.getTransValue");
    console.log("rũnxxx", component.get("v.recordId"));
    getTrans.setParams({
      recordIdx: component.get("v.recordId"),
    });
    getTrans.setCallback(this, function (response) {
      var state = response.getState();
      var selectedIds = [];
      var res = response.getReturnValue();

      var StringValue = res[0].TransportationWay__c;
      selectedIds = StringValue.split(";");
      console.log("selectedIds", StringValue, selectedIds);
      component.set("v.TransValue", selectedIds);

      const InqureLine = [];
      InqureLine.push({
        Id:"" ,
        ComboProduct__c: res[0].ComboProduct1__c,
      });
      component.set("v.InqureLine", InqureLine);
   
      component.set("v.comboProduct",res[0].ComboProduct1__c ? res[0].ComboProduct1__c : '');

      //   if (state === "SUCCESS") {

      //     component.set("v.TransValue", "");
      //   } else {
      //     console.log("state", state);
      //   }
    });
    $A.enqueueAction(getTrans);
  },
});