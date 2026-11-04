
<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c"
           uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="path" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport"
      content="width=device-width, initial-scale=1.0">
<title>내 채팅 - ProLink</title>

<style>
* {
    box-sizing: border-box;
}

body {
    margin: 0;
    background: #f5f6f8;
    font-family: Arial, sans-serif;
    color: #222;
}

.container {
    max-width: 720px;
    margin: 40px auto;
    padding: 24px;
    background: white;
    border-radius: 12px;
}

h2 {
    margin-top: 0;
}

.chat-item {
    display: block;
    padding: 18px 12px;
    border-bottom: 1px solid #eee;
    color: inherit;
    text-decoration: none;
}

.chat-item:hover {
    background: #f7f9fc;
}

.chat-top {
    display: flex;
    justify-content: space-between;
    gap: 12px;
}

.chat-name {
    font-weight: bold;
}

.chat-time {
    font-size: 12px;
    color: #888;
}

.chat-message {
    margin-top: 8px;
    color: #666;
    font-size: 14px;
    overflow-wrap: anywhere;
}

.empty {
    padding: 50px 0;
    text-align: center;
    color: #888;
}
</style>
</head>

<body>

<div class="container">

    <h2>내 채팅</h2>

    <c:choose>
        <c:when test="${empty chatRooms}">
            <div class="empty">
                아직 참여한 채팅방이 없습니다.
            </div>
        </c:when>

        <c:otherwise>
            <c:forEach var="room" items="${chatRooms}">

                <c:url var="chatUrl" value="/chat/enter">
                    <c:param name="tradeSeq"
                             value="${room.tradeSeq}" />
                </c:url>

                <a class="chat-item"
                   href="<c:out value='${chatUrl}' />">

                    <div class="chat-top">
                        <span class="chat-name">
                            <c:out value="${room.opponentName}" />
                        </span>

                        <span class="chat-time">
                            <c:out value="${room.lastMessageTime}" />
                        </span>
                    </div>

                    <div class="chat-message">
                        <c:choose>
                            <c:when test="${empty room.lastMessage}">
                                아직 메시지가 없습니다.
                            </c:when>
                            <c:otherwise>
                                <c:out value="${room.lastMessage}" />
                            </c:otherwise>
                        </c:choose>
                    </div>

                </a>

            </c:forEach>
        </c:otherwise>
    </c:choose>

</div>

</body>
</html>
