
package com.project.app.chat.model;

public class ChatMessage {

    private Long messageId;
    private Long chatRoomSeq;
    private Long senderSeq;
    private String content;
    private String createdAt;

    // 사진·영상 첨부파일 정보
    private Long attachmentSeq;
    private String attachmentContentType;

    public ChatMessage() {
    }

    public Long getMessageId() {
        return messageId;
    }

    public void setMessageId(Long messageId) {
        this.messageId = messageId;
    }

    public Long getChatRoomSeq() {
        return chatRoomSeq;
    }

    public void setChatRoomSeq(Long chatRoomSeq) {
        this.chatRoomSeq = chatRoomSeq;
    }

    public Long getSenderSeq() {
        return senderSeq;
    }

    public void setSenderSeq(Long senderSeq) {
        this.senderSeq = senderSeq;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }

    // 첨부파일 번호
    public Long getAttachmentSeq() {
        return attachmentSeq;
    }

    public void setAttachmentSeq(Long attachmentSeq) {
        this.attachmentSeq = attachmentSeq;
    }

    // 첨부파일 종류
    public String getAttachmentContentType() {
        return attachmentContentType;
    }

    public void setAttachmentContentType(
            String attachmentContentType) {
        this.attachmentContentType = attachmentContentType;
    }
}
