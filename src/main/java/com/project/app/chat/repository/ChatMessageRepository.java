
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

    // 1. 메시지 저장 후 저장된 메시지 반환
    @Transactional(rollbackFor = Exception.class)
    public ChatMessage save(String roomId, String sender, String content)
            throws SQLException {

        if (roomId == null || !roomId.matches("[0-9]{1,18}")) {
            throw new SQLException("올바르지 않은 채팅방 번호입니다.");
        }

        Long messageId = chatMapper.nextMessageSeq();

        if (messageId == null) {
            throw new SQLException("메시지 번호 생성 실패");
        }

        ChatMessage message = new ChatMessage();
        message.setMessageId(messageId);
        message.setRoomId(roomId);
        message.setSender(sender);
        message.setContent(content);

        int result = chatMapper.insert(message);

        if (result != 1) {
            throw new SQLException("메시지 저장 실패");
        }

        ChatMessage savedMessage = chatMapper.findById(messageId);

        if (savedMessage == null) {
            throw new SQLException("저장 메시지 조회 실패");
        }

        return savedMessage;
    }

    // 2. 기존 방식: 메시지 내용만 조회
    public List<String> findByRoomId(String roomId)
            throws SQLException {

        List<ChatMessage> messages =
                chatMapper.findByRoomId(roomId);

        List<String> contents = new ArrayList<>();

        for (ChatMessage message : messages) {
            contents.add(message.getContent());
        }

        return contents;
    }

    // 3. 채팅 내역 조회
    public List<ChatMessage> findMessagesByRoomId(String roomId)
            throws SQLException {

        return chatMapper.findByRoomId(roomId);
    }
}
