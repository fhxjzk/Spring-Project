
package com.project.app.chat.model;

public class ChatMessage {

    // 채팅 메시지 고유번호
    private Long messageId;

    // 채팅방 고유번호
    private Long chatRoomSeq;

    // 메시지를 보낸 로그인 회원번호
    private Long senderSeq;

    // 메시지 내용
    private String content;

    // 메시지 작성일
    private String createdAt;

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
}
