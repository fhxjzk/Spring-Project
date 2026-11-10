
package com.project.app.chat.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import com.project.app.chat.model.ChatRoomListDto;

@Mapper
public interface ChatRoomMapper {

    // 1. 로그인 회원이 채팅방 참여자인지 확인
    @Select(
        "SELECT COUNT(*) " +
        "FROM tbl_chat_room " +
        "WHERE chat_room_seq = #{chatRoomSeq} " +
        "AND (customer_seq = #{memberSeq} " +
        "OR expert_seq = #{memberSeq})"
    )
    int countMembership(
        @Param("chatRoomSeq") Long chatRoomSeq,
        @Param("memberSeq") Long memberSeq
    );

    // 2. 채팅 상대방 회원번호 조회
    @Select(
        "SELECT CASE " +
        "WHEN customer_seq = #{senderSeq} THEN expert_seq " +
        "WHEN expert_seq = #{senderSeq} THEN customer_seq " +
        "END " +
        "FROM tbl_chat_room " +
        "WHERE chat_room_seq = #{chatRoomSeq} " +
        "AND (customer_seq = #{senderSeq} " +
        "OR expert_seq = #{senderSeq})"
    )
    Long findReceiverSeq(
        @Param("chatRoomSeq") Long chatRoomSeq,
        @Param("senderSeq") Long senderSeq
    );

    // 3. 회원번호로 로그인 ID 조회
    @Select(
        "SELECT id " +
        "FROM tbl_member " +
        "WHERE member_seq = #{memberSeq}"
    )
    String findLoginId(
        @Param("memberSeq") Long memberSeq
    );

    // 4. 거래번호로 기존 채팅방 조회
    @Select(
        "SELECT chat_room_seq " +
        "FROM tbl_chat_room " +
        "WHERE trade_seq = #{tradeSeq}"
    )
    Long findRoomSeqByTradeSeq(
        @Param("tradeSeq") Long tradeSeq
    );

    // 5. 거래 행 잠금
    @Select(
        "SELECT trade_seq " +
        "FROM tbl_trade " +
        "WHERE trade_seq = #{tradeSeq} " +
        "FOR UPDATE"
    )
    Long lockTradeBySeq(
        @Param("tradeSeq") Long tradeSeq
    );

    // 6. 실제 거래정보로 채팅방 생성
    @Insert(
        "INSERT INTO tbl_chat_room " +
        "(chat_room_seq, trade_seq, customer_seq, expert_seq, regdate) " +
        "SELECT seq_chat_room.NEXTVAL, " +
        "t.trade_seq, t.customer_seq, t.expert_seq, SYSDATE " +
        "FROM tbl_trade t " +
        "WHERE t.trade_seq = #{tradeSeq} " +
        "AND t.customer_seq <> t.expert_seq"
    )
    int createRoomByTradeSeq(
        @Param("tradeSeq") Long tradeSeq
    );

    // 7. 거래 참여자 권한 확인
    @Select(
        "SELECT COUNT(*) " +
        "FROM tbl_trade " +
        "WHERE trade_seq = #{tradeSeq} " +
        "AND (customer_seq = #{memberSeq} " +
        "OR expert_seq = #{memberSeq})"
    )
    int countTradeMembership(
        @Param("tradeSeq") Long tradeSeq,
        @Param("memberSeq") Long memberSeq
    );

    // 8. 로그인 회원의 채팅방 번호 목록 조회
    @Select(
        "SELECT chat_room_seq " +
        "FROM tbl_chat_room " +
        "WHERE customer_seq = #{memberSeq} " +
        "OR expert_seq = #{memberSeq} " +
        "ORDER BY chat_room_seq DESC"
    )
    List<Long> findRoomSeqsByMemberSeq(
        @Param("memberSeq") Long memberSeq
    );

    // 9. 로그인 회원의 채팅방 상세 목록 조회
    @Select(
        "SELECT " +
        "r.chat_room_seq AS \"chatRoomSeq\", " +
        "r.trade_seq AS \"tradeSeq\", " +
        "CASE WHEN r.customer_seq = #{memberSeq} " +
        "THEN r.expert_seq ELSE r.customer_seq END AS \"opponentSeq\", " +
        "m.name AS \"opponentName\", " +
        "msg.content AS \"lastMessage\", " +
        "TO_CHAR(msg.regdate, 'YYYY-MM-DD HH24:MI') AS \"lastMessageTime\" " +
        "FROM tbl_chat_room r " +
        "JOIN tbl_member m ON m.member_seq = " +
        "(CASE WHEN r.customer_seq = #{memberSeq} " +
        "THEN r.expert_seq ELSE r.customer_seq END) " +
        "LEFT JOIN tbl_chat_message msg ON msg.chat_message_seq = " +
        "(SELECT MAX(cm.chat_message_seq) " +
        "FROM tbl_chat_message cm " +
        "WHERE cm.chat_room_seq = r.chat_room_seq) " +
        "WHERE r.customer_seq = #{memberSeq} " +
        "OR r.expert_seq = #{memberSeq} " +
        "ORDER BY msg.regdate DESC NULLS LAST, r.chat_room_seq DESC"
    )
    List<ChatRoomListDto> findChatRoomList(
        @Param("memberSeq") Long memberSeq
    );

    // 10. 메시지 번호로 해당 채팅방 번호 조회 (신규 추가)
    @Select(
        "SELECT chat_room_seq " +
        "FROM tbl_chat_message " +
        "WHERE chat_message_seq = #{chatMessageSeq}"
    )
    Long findRoomSeqByMessageId(
        @Param("chatMessageSeq") Long chatMessageSeq
    );

}
