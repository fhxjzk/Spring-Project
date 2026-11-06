
package com.project.app.chat.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.project.app.chat.model.ChatMessage;

@Mapper
public interface ChatMapper {

    // 메시지 고유번호 생성
    Long nextMessageSeq();

    // 채팅 메시지 저장
    int insert(ChatMessage message);

    // 메시지 1건 조회
    ChatMessage findById(
            @Param("messageId") Long messageId
    );

    // 채팅방 전체 메시지 조회
    List<ChatMessage> findByRoomId(
            @Param("roomId") Long chatRoomSeq
    );
}
