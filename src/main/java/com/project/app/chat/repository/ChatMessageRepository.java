
package com.project.app.chat.repository;

import java.sql.Connection;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import javax.sql.DataSource;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.project.app.chat.model.ChatMessage;

@Repository
public class ChatMessageRepository {


private final DataSource dataSource;

public ChatMessageRepository(
        @Qualifier("dataSource") DataSource dataSource) {
    this.dataSource = dataSource;
}

// 팀 프로젝트의 HikariCP 연결 풀 사용
private Connection getConnection() throws SQLException {
    return dataSource.getConnection();
}


    // 1. 메시지 저장 후 저장된 메시지 반환
    public ChatMessage save(String roomId, String sender, String content)
            throws SQLException {

        if (roomId == null || !roomId.matches("[0-9]{1,18}")) {
            throw new SQLException("올바르지 않은 채팅방 번호입니다.");
        }

        String sequenceSql =
                "SELECT SEQ_PROLINK_CHAT_MESSAGE.NEXTVAL FROM DUAL";

        String insertSql =
                "INSERT INTO PROLINK_CHAT_MESSAGE " +
                "(MESSAGE_ID, ROOM_ID, SENDER, CONTENT) " +
                "VALUES (?, ?, ?, ?)";

        String selectSql =
                "SELECT MESSAGE_ID, ROOM_ID, SENDER, CONTENT, " +
                "TO_CHAR(CREATED_AT, 'YYYY-MM-DD HH24:MI:SS') AS CREATED_TIME " +
                "FROM PROLINK_CHAT_MESSAGE WHERE MESSAGE_ID = ?";

        try (Connection conn = getConnection()) {

            conn.setAutoCommit(false);

            try {
                long messageId;

                // 시퀀스 번호 생성
                try (PreparedStatement pstmt =
                        conn.prepareStatement(sequenceSql);
                     ResultSet rs = pstmt.executeQuery()) {

                    if (!rs.next()) {
                        throw new SQLException("메시지 번호 생성 실패");
                    }

                    messageId = rs.getLong(1);
                }

                // Oracle에 저장
                try (PreparedStatement pstmt =
                        conn.prepareStatement(insertSql)) {

                    pstmt.setLong(1, messageId);
                    pstmt.setString(2, roomId);
                    pstmt.setString(3, sender);
                    pstmt.setString(4, content);

                    pstmt.executeUpdate();
                }

                // 저장된 메시지 조회
                ChatMessage savedMessage;

                try (PreparedStatement pstmt =
                        conn.prepareStatement(selectSql)) {

                    pstmt.setLong(1, messageId);

                    try (ResultSet rs = pstmt.executeQuery()) {

                        if (!rs.next()) {
                            throw new SQLException("저장 메시지 조회 실패");
                        }

                        savedMessage = mapMessage(rs);
                    }
                }

                conn.commit();
                return savedMessage;

            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        }
    }

    // 2. 기존 방식: 메시지 내용만 조회
    public List<String> findByRoomId(String roomId)
            throws SQLException {

        List<String> messages = new ArrayList<>();

        String sql =
                "SELECT CONTENT FROM PROLINK_CHAT_MESSAGE " +
                "WHERE ROOM_ID = ? ORDER BY MESSAGE_ID ASC";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, roomId);

            try (ResultSet rs = pstmt.executeQuery()) {

                while (rs.next()) {
                    messages.add(rs.getString("CONTENT"));
                }
            }
        }

        return messages;
    }

    // 3. 채팅 내역 조회: ID, 작성자, 내용, 시간 포함
    public List<ChatMessage> findMessagesByRoomId(String roomId)
            throws SQLException {

        List<ChatMessage> messages = new ArrayList<>();

        String sql =
                "SELECT MESSAGE_ID, ROOM_ID, SENDER, CONTENT, " +
                "TO_CHAR(CREATED_AT, 'YYYY-MM-DD HH24:MI:SS') AS CREATED_TIME " +
                "FROM PROLINK_CHAT_MESSAGE " +
                "WHERE ROOM_ID = ? ORDER BY MESSAGE_ID ASC";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, roomId);

            try (ResultSet rs = pstmt.executeQuery()) {

                while (rs.next()) {
                    messages.add(mapMessage(rs));
                }
            }
        }

        return messages;
    }

    // 4. 조회 결과를 ChatMessage 객체로 변환
    private ChatMessage mapMessage(ResultSet rs)
            throws SQLException {

        ChatMessage message = new ChatMessage();

        message.setMessageId(rs.getLong("MESSAGE_ID"));
        message.setRoomId(rs.getString("ROOM_ID"));
        message.setSender(rs.getString("SENDER"));
        message.setContent(rs.getString("CONTENT"));
        message.setCreatedAt(rs.getString("CREATED_TIME"));

        return message;
    }
}


