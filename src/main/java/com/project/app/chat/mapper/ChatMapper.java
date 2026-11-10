
package com.project.app.chat.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.project.app.chat.model.ChatMessage;

@Mapper
public interface ChatMapper {

    // 1. 메시지 고유번호 생성
    Long nextMessageSeq();

    // 2. 채팅 메시지 저장
    int insert(ChatMessage message);

    // 3. 메시지 1건 조회
    ChatMessage findById(
            @Param("messageId") Long messageId
    );

    // 4. 채팅방 전체 메시지 조회
    List<ChatMessage> findByRoomId(
            @Param("roomId") Long chatRoomSeq
    );

    // 5. 채팅 메시지 내용 변경 (추가)
    int updateContent(
            @Param("messageId") Long messageId,
            @Param("content") String content
    );
}
