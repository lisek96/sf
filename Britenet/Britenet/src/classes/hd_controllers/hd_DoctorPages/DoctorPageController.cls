public with sharing class DoctorPageController {
    public Doctor__c doctor { get; set; }
    private final static String deleteDefaultAvatarMessage = 'You\'ve tried to delete default avatar, its impossible!';
    private final static String succesfullAvatarDeleteMessage = 'You\'ve succesfully deleted your avatar.';
    private final String newHospitalAndDoctorPageURL = System.label.NewHospitalAndDoctorPageURL;
    public Boolean enableDeleteAvatarButton {get; set; }

    public DoctorPageController(ApexPages.StandardController stdController) {
        doctor = (Doctor__c) stdController.getRecord();
        checkIfItsPossibleToDeleteAvatar();
    }

    public void checkIfItsPossibleToDeleteAvatar(){
        List<Attachment> attachments = new List<Attachment>();
        attachments = [SELECT Id FROM Attachment WHERE ParentId =: doctor.Id AND Name='avatar'];
        if(!attachments.isEmpty()) enableDeleteAvatarButton = true;
        else enableDeleteAvatarButton = false;
    }
    public PageReference createNewHospitalAndDoctor() {
        return new PageReference(newHospitalAndDoctorPageURL);
    }

    public PageReference refresh(){
        return null;
    }
    @RemoteAction
    public static PageReference hireButton(){
        ApexPages.getMessages().clear();
        return null;
    }
    @RemoteAction
    public static PageReference saveImage(String name, String contentType, String data, String doctor) {
        List<Attachment> attachmentsToDelete= [SELECT Id, name FROM Attachment WHERE ParentId =:doctor AND Name =: 'avatar'];
        if(attachmentsToDelete.size()!=0) delete attachmentsToDelete;
        Attachment attachedPhoto = new Attachment(Name = name, OwnerId = UserInfo.getUserId(), contentType = contentType, Body = EncodingUtil.base64Decode(data), ParentId = doctor);
        Database.insert(attachedPhoto, true);
        return ApexPages.currentPage();
    }
    public Id getAvatarFileId(){
        List<doctor__c> doctors = [SELECT (select Name, id, CreatedDate from Attachments ORDER BY CreatedDate DESC) FROM Doctor__C  WHERE id=:doctor.Id];
        Attachment defaultDoctorAvatar = [SELECT id from Attachment WHERE Name='defaultAvatar'];
        if(doctors.get(0).Attachments.size()==0) return defaultDoctorAvatar.Id;
        Attachment[] attachments = doctors.get(0).Attachments;
        Attachment avatarAttachment = null;
        for(Attachment attachment : attachments){
            if(attachment.Name == 'avatar') {
                avatarAttachment = attachment;
                break;
            }
        }
        if(avatarAttachment==null) avatarAttachment=defaultDoctorAvatar;

        return avatarAttachment.Id;
    }
    public PageReference deleteAvatar(){
        enableDeleteAvatarButton=false;
        List<Attachment> attachmentToDelete = [SELECT Id, name FROM Attachment WHERE ParentId =:doctor.Id AND Name =: 'avatar'];
        if(attachmentToDelete.size()==0) {
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.FATAL, deleteDefaultAvatarMessage));
            return ApexPages.currentPage();
        }
        delete attachmentToDelete;
        ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, succesfullAvatarDeleteMessage));
        return ApexPages.currentPage();
    }
}