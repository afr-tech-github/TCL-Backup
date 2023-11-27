// currencySelectorController.js
({
  handleCurrencyChange: function (component, event, helper) {},

  printDocument: function (component, event, helper) {
    var recordId = component.get("v.recordId");
    var isChecked = component.get("v.isChecked");
    let url = "";
    console.log("run");
    // Chuyển đến trang "print_Document" với các tham số recordId và cur
    if (isChecked) {
      var GetData = component.get("c.generateAttachmentFileForSeaManifest");

      GetData.setParams({
        id: component.get("v.recordId"),
      });
      GetData.setCallback(this, function (response) {
        var state = response.getState();
        console.log(state);
        if (state === "SUCCESS") {
          component.set("v.packages", response.getReturnValue());

          console.log("rủnun");
        }
      });
      $A.enqueueAction(GetData);
    }
    url = "/apex/page_printAirManifest?id=" + recordId;
    window.location.href = url;

    // Sử dụng Navigation Service để chuyển đến trang
  },
});