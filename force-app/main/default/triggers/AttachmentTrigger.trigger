trigger AttachmentTrigger on Attachment (after insert) {
    // if(trigger.isAfter && trigger.isInsert){
    //     for (Attachment att : Trigger.new) {
    //         ContentVersion cv = new ContentVersion();
    //         cv.PathOnClient = att.Name;
    //         cv.Title = att.Name;
    //         cv.Description = att.Name;
    //         cv.VersionData = att.body;
    //         cv.FirstPublishLocationId = att.ParentId;
    //         insert cv;
    //     }
    // }
}