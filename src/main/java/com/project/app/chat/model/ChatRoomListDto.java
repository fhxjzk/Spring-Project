
package com.project.app.chat.model;

public class ChatRoomListDto {

    private Long chatRoomSeq;
    private Long tradeSeq;
    private Long opponentSeq;
    private String opponentName;
    private String lastMessage;
    private String lastMessageTime;

    public Long getChatRoomSeq() {
        return chatRoomSeq;
    }

    public void setChatRoomSeq(Long chatRoomSeq) {
        this.chatRoomSeq = chatRoomSeq;
    }

    public Long getTradeSeq() {
        return tradeSeq;
    }

    public void setTradeSeq(Long tradeSeq) {
        this.tradeSeq = tradeSeq;
    }

    public Long getOpponentSeq() {
        return opponentSeq;
    }

    public void setOpponentSeq(Long opponentSeq) {
        this.opponentSeq = opponentSeq;
    }

    public String getOpponentName() {
        return opponentName;
    }

    public void setOpponentName(String opponentName) {
        this.opponentName = opponentName;
    }

    public String getLastMessage() {
        return lastMessage;
    }

    public void setLastMessage(String lastMessage) {
        this.lastMessage = lastMessage;
    }

    public String getLastMessageTime() {
        return lastMessageTime;
    }

    public void setLastMessageTime(String lastMessageTime) {
        this.lastMessageTime = lastMessageTime;
    }
}
