
package com.project.app.chat.service;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.project.app.chat.mapper.ChatRoomMapper;
import java.util.List;
import com.project.app.chat.model.ChatRoomListDto;
@Service
public class ChatRoomService {

    private final ChatRoomMapper chatRoomMapper;

    public ChatRoomService(ChatRoomMapper chatRoomMapper) {
        this.chatRoomMapper = chatRoomMapper;
    }

    // 거래번호로 채팅방 조회 또는 생성
    @Transactional
    public Long getOrCreateRoom(Long tradeSeq) {

        // 1. 거래번호 검증
        if (tradeSeq == null || tradeSeq <= 0) {
            throw new IllegalArgumentException(
                "올바르지 않은 거래번호입니다.");
        }

        // 2. 거래 행 잠금
        // 동일 거래의 채팅방 중복 생성 방지
        Long lockedTradeSeq =
                chatRoomMapper.lockTradeBySeq(tradeSeq);

        if (lockedTradeSeq == null) {
            throw new IllegalStateException(
                "존재하지 않는 거래입니다.");
        }

        // 3. 기존 채팅방 조회
        Long roomSeq =
                chatRoomMapper.findRoomSeqByTradeSeq(tradeSeq);

        if (roomSeq != null) {
            return roomSeq;
        }

        // 4. 채팅방 생성
        int result =
                chatRoomMapper.createRoomByTradeSeq(tradeSeq);

        if (result != 1) {
            throw new IllegalStateException(
                "채팅방 생성에 실패했습니다.");
        }

        // 5. 생성된 채팅방 번호 조회
        roomSeq =
                chatRoomMapper.findRoomSeqByTradeSeq(tradeSeq);

        if (roomSeq == null) {
            throw new IllegalStateException(
                "채팅방 생성 후 조회에 실패했습니다.");
        }

        return roomSeq;
    }

    // 로그인 회원의 채팅방 목록 조회
    @Transactional(readOnly = true)
    public List<ChatRoomListDto> getChatRoomList(Long memberSeq) {

        // 로그인 회원번호 검증
        if (memberSeq == null || memberSeq <= 0) {
            throw new IllegalArgumentException(
                "올바르지 않은 회원번호입니다.");
        }

        // 본인이 참여한 채팅방 목록만 조회
        return chatRoomMapper.findChatRoomList(memberSeq);
    }

}
