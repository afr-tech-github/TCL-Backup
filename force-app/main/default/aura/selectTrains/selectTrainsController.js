({
  init: function (component, event, helper) {
    var orderId = component.get("v.recordId");

    // Call the server to retrieve packages for the current order
    var action = component.get("c.getPackagesForOrder");
    action.setParams({ orderId: orderId });

    console.log("state", orderId);
    action.setCallback(this, function (response) {
      var state = response.getState();
      if (state === "SUCCESS") {
        component.set("v.packages", response.getReturnValue());
      }
    });

    $A.enqueueAction(action);
  },

  handleRadioChange: function (component, event, helper) {
    var selectedValue = event.getSource().get("v.value");
    component.set("v.selected", selectedValue);
  },

  createBlankMultiTab: function (component, event, helper) {
    var ixd = component.get("v.selected");
    var orderId = component.get("v.recordId");
    var isChecked = component.get("v.isChecked");
    console.log(isChecked);
    if (isChecked) {
      var GetData = component.get("c.GetgenerateAttachmentFile");

      GetData.setParams({
        recordID: orderId,
        id: ixd,
      });
      GetData.setCallback(this, function (response) {
        var state = response.getState();
        console.log(state);
        if (state === "SUCCESS") {
          // component.set("v.packages", response.getReturnValue());

          console.log("rủnun");
        }
      });
      $A.enqueueAction(GetData);
    }

    window.location.href =
      "/apex/page_TruckingBillForm?id=" + ixd + "&orderId=" + orderId;
  },
});