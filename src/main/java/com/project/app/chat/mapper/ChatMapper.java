
package com.project.app.chat.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.project.app.chat.model.ChatMessage;

@Mapper
public interface ChatMapper {

    // 새 메시지 번호 생성
    Long nextMessageSeq();

    // 채팅 메시지 저장
    int insert(ChatMessage message);

    // 저장된 메시지 1건 조회
    ChatMessage findById(@Param("messageId") Long messageId);

    // 채팅방의 메시지 전체 조회
    List<ChatMessage> findByRoomId(@Param("roomId") String roomId);

}
