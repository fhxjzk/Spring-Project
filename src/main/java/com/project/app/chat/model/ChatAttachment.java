
package com.project.app.chat.model;

public class ChatAttachment {

    private Long attachmentSeq;
    private Long chatMessageSeq;
    private String originalName;
    private String storedName;
    private String contentType;
    private Long fileSize;

    public Long getAttachmentSeq() {
        return attachmentSeq;
    }

    public void setAttachmentSeq(Long attachmentSeq) {
        this.attachmentSeq = attachmentSeq;
    }

    public Long getChatMessageSeq() {
        return chatMessageSeq;
    }

    public void setChatMessageSeq(Long chatMessageSeq) {
        this.chatMessageSeq = chatMessageSeq;
    }

    public String getOriginalName() {
        return originalName;
    }

    public void setOriginalName(String originalName) {
        this.originalName = originalName;
    }

    public String getStoredName() {
        return storedName;
    }

    public void setStoredName(String storedName) {
        this.storedName = storedName;
    }

    public String getContentType() {
        return contentType;
    }

    public void setContentType(String contentType) {
        this.contentType = contentType;
    }

    public Long getFileSize() {
        return fileSize;
    }

    public void setFileSize(Long fileSize) {
        this.fileSize = fileSize;
    }
}
