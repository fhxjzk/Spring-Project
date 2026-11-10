
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>채팅 목록</title>

<style>
* {
    box-sizing: border-box;
}

body {
    margin: 0;
    background: #f4f7fc;
    color: #202936;
    font-family: Arial, "Malgun Gothic", sans-serif;
}

.chat-container {
    width: 100%;
    max-width: 760px;
    min-height: 100vh;
    margin: 0 auto;
    background: #ffffff;
}

.chat-header {
    padding: 26px 24px 20px;
    border-bottom: 1px solid #e7ebf2;
}

.chat-header h1 {
    margin: 0;
    font-size: 24px;
}

.chat-header p {
    margin: 9px 0 0;
    font-size: 13px;
    color: #7b8798;
}

.chat-list {
    display: flex;
    flex-direction: column;
}

.chat-room {
    display: flex;
    align-items: center;
    gap: 15px;
    padding: 20px 22px;
    border-bottom: 1px solid #edf0f5;
    text-decoration: none;
    color: inherit;
    transition: background 0.15s;
}

.chat-room:hover {
    background: #f4f7ff;
}

.chat-avatar {
    width: 52px;
    height: 52px;
    flex-shrink: 0;
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: 50%;
    background: #e4ecff;
    color: #356cf0;
    font-size: 24px;
}

.chat-content {
    flex: 1;
    min-width: 0;
}

.chat-top {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 12px;
}

.chat-name {
    font-size: 16px;
    font-weight: bold;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
}

.chat-time {
    flex-shrink: 0;
    font-size: 11px;
    color: #9aa4b2;
}

.chat-message {
    margin-top: 8px;
    color: #697586;
    font-size: 13px;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
}

.chat-trade {
    margin-top: 6px;
    color: #9aa4b2;
    font-size: 11px;
}

.chat-arrow {
    color: #b2bdca;
    font-size: 22px;
}

.chat-empty {
    padding: 100px 20px;
    text-align: center;
    color: #8793a3;
}

.chat-empty strong {
    display: block;
    margin-bottom: 12px;
    font-size: 17px;
    color: #394455;
}

.chat-empty p {
    margin: 0;
    font-size: 13px;
    line-height: 1.7;
}

@media (max-width: 600px) {
    .chat-header {
        padding: 22px 18px;
    }

    .chat-room {
        padding: 17px 15px;
        gap: 12px;
    }

    .chat-avatar {
        width: 46px;
        height: 46px;
    }
}
</style>
</head>

<body>

<div class="chat-container">

    <header class="chat-header">
        <h1>채팅</h1>
        <p>거래 상대방과 나눈 대화를 확인하세요.</p>
    </header>

    <main class="chat-list">

        <c:choose>

            <c:when test="${empty chatRooms}">
                <div class="chat-empty">
                    <strong>아직 채팅방이 없습니다.</strong>
                    <p>
                        거래 상세 화면에서 채팅을 시작하면<br>
                        이곳에 대화 목록이 표시됩니다.
                    </p>
                </div>
            </c:when>

            <c:otherwise>

                <c:forEach var="room" items="${chatRooms}">

                    <c:url var="chatEnterUrl" value="/chat/enter">
                        <c:param name="tradeSeq" value="${room.tradeSeq}" />
                    </c:url>

                    <a class="chat-room"
                       href="${chatEnterUrl}">

                        <div class="chat-avatar"
                             aria-hidden="true">👤</div>

                        <div class="chat-content">

                            <div class="chat-top">

                                <span class="chat-name">
                                    <c:out value="${room.opponentName}"
                                           default="상대방" />
                                </span>

                                <span class="chat-time">
                                    <c:out value="${room.lastMessageTime}" />
                                </span>

                            </div>

                            <div class="chat-message">
                                <c:choose>
                                    <c:when test="${empty room.lastMessage}">
                                        아직 대화 내용이 없습니다.
                                    </c:when>
                                    <c:otherwise>
                                        <c:out value="${room.lastMessage}" />
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <div class="chat-trade">
                                거래번호
                                <c:out value="${room.tradeSeq}" />
                            </div>

                        </div>

                        <span class="chat-arrow"
                              aria-hidden="true">›</span>

                    </a>

                </c:forEach>

            </c:otherwise>

        </c:choose>

    </main>

</div>

</body>
</html>
