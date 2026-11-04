
<%@ page contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>재능톡</title>

<style>
* {
    box-sizing: border-box;
}

body {
    margin: 0;
    font-family: "Malgun Gothic", Arial, sans-serif;
    background: #f2f5fa;
    color: #17253d;
}

.chat-container {
    max-width: 850px;
    height: min(850px, 94dvh);
    min-height: 400px;
    margin: 3vh auto;
    background: white;
    display: flex;
    flex-direction: column;
    border-radius: 16px;
    overflow: hidden;
    box-shadow: 0 8px 30px rgba(0,0,0,0.08);
}

.chat-header {
    padding: 20px 24px;
    border-bottom: 1px solid #e5eaf2;
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 12px;
}

.chat-title {
    font-size: 22px;
    font-weight: bold;
    color: #2f6fed;
}

.chat-subtitle {
    margin-top: 6px;
    color: #77849a;
    font-size: 13px;
}

.connection-status {
    font-size: 12px;
    color: #66758c;
    text-align: right;
}

.room-controls {
    padding: 10px 24px;
    background: #fafbfd;
    border-bottom: 1px solid #e5eaf2;
    display: flex;
    align-items: center;
    gap: 10px;
}

.room-controls input {
    width: 85px;
    padding: 8px;
    border: 1px solid #d9e0ec;
    border-radius: 8px;
}

.room-controls button {
    background: #e8f0ff;
    color: #2f6fed;
    border: none;
    padding: 9px 14px;
    border-radius: 8px;
    cursor: pointer;
}

.messages {
    flex: 1;
    min-height: 0;
    overflow-y: auto;
    padding: 24px;
    background: #f2f6fc;
}

.message-row {
    display: flex;
    margin-bottom: 18px;
    align-items: flex-end;
    gap: 10px;
}

.message-row.mine {
    justify-content: flex-end;
}

.message-row.other {
    justify-content: flex-start;
}

.avatar {
    width: 36px;
    height: 36px;
    border-radius: 50%;
    background: #dce8fa;
    color: #4269a5;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 17px;
    flex-shrink: 0;
}

.message-body {
    max-width: 75%;
    min-width: 0;
}

.sender-name {
    font-size: 12px;
    color: #62738c;
    margin-bottom: 6px;
}

.bubble {
    padding: 12px 15px;
    border-radius: 16px;
    font-size: 14px;
    line-height: 1.6;
    white-space: pre-wrap;
    overflow-wrap: anywhere;
}

.mine .bubble {
    background: #2f6fed;
    color: white;
    border-bottom-right-radius: 4px;
}

.other .bubble {
    background: white;
    color: #17253d;
    border-bottom-left-radius: 4px;
    box-shadow: 0 2px 8px rgba(0,0,0,0.035);
}

.message-time {
    font-size: 11px;
    color: #8b98aa;
    margin-top: 5px;
}

.mine .message-time {
    text-align: right;
}

.chat-input-area {
    padding: 18px 22px;
    background: white;
    border-top: 1px solid #e5eaf2;
    display: flex;
    gap: 12px;
}

.message-input {
    flex: 1;
    min-width: 0;
    border: 1px solid #e2e7f0;
    background: #f5f7fb;
    padding: 14px 18px;
    border-radius: 25px;
    font-size: 14px;
    outline: none;
}

.message-input:focus {
    border-color: #2f6fed;
}

.send-button {
    background: #2f6fed;
    color: white;
    border: none;
    border-radius: 25px;
    padding: 0 24px;
    font-weight: bold;
    cursor: pointer;
}

.send-button:hover {
    background: #2058c5;
}

@media (max-width: 600px) {
    .chat-container {
        height: 100dvh;
        min-height: 0;
        margin: 0;
        border-radius: 0;
    }

    .chat-header {
        padding: 16px;
    }

    .messages {
        padding: 15px;
    }

    .room-controls {
        padding: 8px 15px;
    }

    .chat-input-area {
        padding: 12px;
    }

    .send-button {
        padding: 0 17px;
    }

    .message-body {
        max-width: 82%;
    }
}
</style>
</head>

<body>

<div class="chat-container">

    <div class="chat-header">
        <div>
            <div class="chat-title">💬 재능톡</div>
            <div class="chat-subtitle">
                고객과 고수가 함께하는 재능 거래 채팅
            </div>
        </div>
        <div class="connection-status" id="status">
            서버 연결 중...
        </div>
    </div>

    
        <label for="roomId">채팅방</label>
        <input type="number"
               id="roomId"
               value="${empty roomSeq ? '1' : roomSeq}"
               min="1">

        <button type="button" onclick="joinRoom()">
            입장
        </button>
    </div>

    <div class="messages" id="messages"></div>

    <div class="chat-input-area">
        <input type="text"
               id="message"
               class="message-input"
               placeholder="메시지를 입력하세요"
               maxlength="2000">

        <button type="button"
                class="send-button"
                onclick="sendMessage()">
            전송
        </button>
    </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/@stomp/stompjs@7.2.1/bundles/stomp.umd.min.js"></script>

<script>
const contextPath =
    '${pageContext.request.contextPath}';

const initialRoomSeq =
    '${empty roomSeq ? "" : roomSeq}';

const loginMemberSeq =
    '${empty loginMemberSeq ? "" : loginMemberSeq}';

const protocol =
    location.protocol === 'https:' ? 'wss:' : 'ws:';

let currentRoom = null;
let subscription = null;
let roomVersion = 0;
let historyLoading = false;
let pendingMessages = [];

const displayedMessageIds = new Set();

const client = new StompJs.Client({
    brokerURL: protocol + '//' + location.host
        + contextPath + '/ws',

    reconnectDelay: 5000,

    onConnect: function () {
        document.getElementById('status').textContent =
            '● 연결됨';

        if (currentRoom !== null) {
            subscribeRoom();
            loadHistory(currentRoom, roomVersion);

        } else if (/^[0-9]{1,18}$/.test(initialRoomSeq)) {
            document.getElementById('roomId').value =
                initialRoomSeq;
            joinRoom();

        } else {
            document.getElementById('status').textContent =
                '채팅방에 입장하세요';
        }
    },

    onStompError: function (frame) {
        document.getElementById('status').textContent =
            '연결 오류: ' + (frame.headers['message'] || '');
    },

    onWebSocketClose: function () {
        document.getElementById('status').textContent =
            '연결이 끊어졌습니다.';
    }
});

client.activate();

function formatTime(value) {
    if (!value) return '';

    const date = new Date(value);

    if (isNaN(date.getTime())) {
        return String(value);
    }

    return date.toLocaleTimeString('ko-KR', {
        hour: 'numeric',
        minute: '2-digit'
    });
}

function appendMessage(message) {
    if (!message) return;

    const messageId = message.messageId;

    if (messageId != null) {
        const id = String(messageId);

        if (displayedMessageIds.has(id)) return;

        displayedMessageIds.add(id);
    }

    const senderSeq =
        message.senderSeq == null ? '' : String(message.senderSeq);

    const mine =
        loginMemberSeq !== '' &&
        senderSeq === loginMemberSeq;

    const content = message.content || '';
    const createdAt = message.createdAt || '';

    const row = document.createElement('div');
    row.className = 'message-row ' + (mine ? 'mine' : 'other');

    if (!mine) {
        const avatar = document.createElement('div');
        avatar.className = 'avatar';
        avatar.textContent = '👤';
        row.appendChild(avatar);
    }

    const body = document.createElement('div');
    body.className = 'message-body';

    const name = document.createElement('div');
    name.className = 'sender-name';
    name.textContent = mine ? '나' : '상대방';
    body.appendChild(name);

    const bubble = document.createElement('div');
    bubble.className = 'bubble';
    bubble.textContent = content;
    body.appendChild(bubble);

    if (createdAt) {
        const time = document.createElement('div');
        time.className = 'message-time';
        time.textContent = formatTime(createdAt);
        body.appendChild(time);
    }

    row.appendChild(body);

    const messages = document.getElementById('messages');
    messages.appendChild(row);
    messages.scrollTop = messages.scrollHeight;
}

function joinRoom() {
    if (!client.connected) {
        alert('서버 연결을 기다려 주세요.');
        return;
    }

    const roomId =
        document.getElementById('roomId').value.trim();

    if (!/^[0-9]{1,18}$/.test(roomId)) {
        alert('올바른 채팅방 번호를 입력하세요.');
        return;
    }

    if (subscription) {
        subscription.unsubscribe();
        subscription = null;
    }

    currentRoom = roomId;
    roomVersion++;

    historyLoading = true;
    pendingMessages = [];
    displayedMessageIds.clear();

    document.getElementById('messages').textContent = '';

    subscribeRoom();
    loadHistory(roomId, roomVersion);
}

function subscribeRoom() {
    if (subscription) {
        subscription.unsubscribe();
    }

    const subscribedRoom = currentRoom;

    subscription = client.subscribe(
        '/topic/room/' + subscribedRoom,
        function (frame) {
            if (currentRoom !== subscribedRoom) return;

            const data = JSON.parse(frame.body);

            if (historyLoading) {
                pendingMessages.push(data);
            } else {
                appendMessage(data);
            }
        }
    );

    document.getElementById('status').textContent =
        '채팅방 ' + currentRoom + ' 연결 중...';
}

async function loadHistory(roomId, version) {
    historyLoading = true;
    pendingMessages = [];

    document.getElementById('status').textContent =
        '이전 대화 불러오는 중...';

    try {
        const response = await fetch(
            contextPath + '/chat/history/'
            + encodeURIComponent(roomId),
            { cache: 'no-store' }
        );

        if (!response.ok) {
            throw new Error('HTTP ' + response.status);
        }

        const history = await response.json();

        if (version !== roomVersion) return;

        const messages =
            document.getElementById('messages');

        messages.textContent = '';
        displayedMessageIds.clear();

        history.forEach(function (message) {
            appendMessage(message);
        });

        pendingMessages.forEach(function (message) {
            appendMessage(message);
        });

        document.getElementById('status').textContent =
            '● 채팅방 연결됨';

    } catch (error) {
        if (version !== roomVersion) return;

        document.getElementById('status').textContent =
            '대화 조회 실패: ' + error.message;

        pendingMessages.forEach(function (message) {
            appendMessage(message);
        });

    } finally {
        if (version === roomVersion) {
            historyLoading = false;
            pendingMessages = [];
        }
    }
}

function sendMessage() {
    if (!client.connected || currentRoom === null) {
        alert('먼저 채팅방에 입장하세요.');
        return;
    }

    const input = document.getElementById('message');
    const content = input.value.trim();

    if (!content) return;

    client.publish({
        destination: '/app/chat.send/' + currentRoom,
        body: JSON.stringify({
            roomId: currentRoom,
            content: content
        })
    });

    input.value = '';
    input.focus();
}

document.getElementById('message').addEventListener(
    'keydown',
    function (event) {
        if (event.key === 'Enter' && !event.isComposing) {
            event.preventDefault();
            sendMessage();
        }
    }
);
</script>

</body>
</html>
