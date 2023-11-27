<aura:application  access="GLOBAL" extends="ltng:outApp">
    <aura:attribute name="parentId" type="Id"  />
    <!-- <aura:handler event="c:close_pubUp" action="{!c.onMyAttributeChanged}"/> -->
    <!-- <aura:event  ></aura:event> -->
    <!-- <aura:registerEvent name="passValueEvent" type="c:onMyAttributeChanged"/> -->
    <c:UploadFieldAttachments  parentId="{!v.parentId}"  /> 
    <!-- <p onclick="{!c.onMyAttributeChanged}">asddfsdfsldfmklsdfkjnskldnfknsdkfnsdlnfsldfklsd</p>    -->
    
</aura:application>