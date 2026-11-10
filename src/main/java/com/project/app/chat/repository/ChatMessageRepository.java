
package com.project.app.chat.repository;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.project.app.chat.mapper.ChatMapper;
import com.project.app.chat.model.ChatMessage;

@Repository
public class ChatMessageRepository {

    private final ChatMapper chatMapper;

    public ChatMessageRepository(ChatMapper chatMapper) {
        this.chatMapper = chatMapper;
    }

    // 1. 메시지 저장
    @Transactional(rollbackFor = Exception.class)
    public ChatMessage save(
            Long chatRoomSeq,
            Long senderSeq,
            String content) throws SQLException {

        if (chatRoomSeq == null || chatRoomSeq <= 0
                || senderSeq == null || senderSeq <= 0) {
            throw new SQLException(
                    "채팅방 또는 회원번호가 올바르지 않습니다.");
        }

        if (content == null || content.trim().isEmpty()) {
            throw new SQLException("메시지 내용이 없습니다.");
        }

        Long messageId = chatMapper.nextMessageSeq();

        if (messageId == null) {
            throw new SQLException("메시지 번호 생성 실패");
        }

        ChatMessage message = new ChatMessage();
        message.setMessageId(messageId);
        message.setChatRoomSeq(chatRoomSeq);
        message.setSenderSeq(senderSeq);
        message.setContent(content);

        int result = chatMapper.insert(message);

        if (result != 1) {
            throw new SQLException("메시지 저장 실패");
        }

        ChatMessage savedMessage =
                chatMapper.findById(messageId);

        if (savedMessage == null) {
            throw new SQLException("저장 메시지 조회 실패");
        }

        return savedMessage;
    }

    // 2. 채팅 메시지 내용만 조회
    public List<String> findByRoomId(Long chatRoomSeq)
            throws SQLException {

        List<ChatMessage> messages =
                chatMapper.findByRoomId(chatRoomSeq);

        List<String> contents = new ArrayList<>();

        for (ChatMessage message : messages) {
            contents.add(message.getContent());
        }

        return contents;
    }

    // 3. 채팅방 전체 메시지 조회
    public List<ChatMessage> findMessagesByRoomId(
            Long chatRoomSeq) throws SQLException {

        return chatMapper.findByRoomId(chatRoomSeq);
    }

    // 4. 메시지 번호로 1건 조회
    public ChatMessage findById(Long messageId)
            throws SQLException {

        if (messageId == null || messageId <= 0) {
            throw new SQLException(
                    "메시지 번호가 올바르지 않습니다.");
        }

        return chatMapper.findById(messageId);
    }

    // 5. 메시지 내용 변경 (추가)
    public void updateContent(
            Long messageId,
            String content) throws SQLException {

        if (messageId == null || messageId <= 0) {
            throw new SQLException(
                    "메시지 번호가 올바르지 않습니다.");
        }

        if (content == null || content.trim().isEmpty()) {
            throw new SQLException(
                    "변경할 메시지 내용이 없습니다.");
        }

        int result = chatMapper.updateContent(
                messageId,
                content
        );

        if (result != 1) {
            throw new SQLException(
                    "메시지 내용 변경 실패");
        }
    }
}
