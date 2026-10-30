
<%@ page contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>ProLink 채팅방 테스트</title>
</head>
<body>
    <h2>ProLink 채팅방 테스트</h2>

    <label>채팅방 번호:</label>
    <input type="number" id="roomId" value="101" min="1">

    <button onclick="joinRoom()">채팅방 입장</button>

    <p id="status">연결 중...</p>

    <div id="messages"
         style="border:1px solid #ccc; height:250px;
                overflow-y:auto; padding:10px;">
    </div>

    <input type="text" id="sender"
           placeholder="이름" value="고객A">

    <input type="text" id="message"
           placeholder="메시지를 입력하세요"
           style="width:300px;">

    <button onclick="sendMessage()">전송</button>

    <script src="https://cdn.jsdelivr.net/npm/@stomp/stompjs@7.2.1/bundles/stomp.umd.min.js"></script>

    <script>
        const contextPath = '${pageContext.request.contextPath}';
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
                    '서버 연결 성공 - 채팅방에 입장하세요';

                if (currentRoom !== null) {
                    subscribeRoom();
                    loadHistory(currentRoom, roomVersion);
                }
            },

            onStompError: function (frame) {
                document.getElementById('status').textContent =
                    'STOMP 오류: ' + frame.headers['message'];
            },

            onWebSocketClose: function () {
                document.getElementById('status').textContent =
                    '연결이 끊어졌습니다.';
            }
        });

        client.activate();

        function appendMessage(message) {
            if (!message) {
                return;
            }

            const messageId = message.messageId;

            if (messageId != null) {
                const id = String(messageId);

                if (displayedMessageIds.has(id)) {
                    return;
                }

                displayedMessageIds.add(id);
            }

            const sender = message.sender || '알 수 없음';
            const content = message.content || '';
            const createdAt = message.createdAt || '';

            const div = document.createElement('div');
            div.style.padding = '5px 0';
            div.style.borderBottom = '1px solid #eee';

            const text = document.createElement('span');
            text.textContent = sender + ': ' + content;

            div.appendChild(text);

            if (createdAt) {
                const time = document.createElement('small');
                time.style.color = '#777';
                time.style.marginLeft = '10px';
                time.textContent = createdAt;

                div.appendChild(time);
            }

            const messages =
                document.getElementById('messages');

            messages.appendChild(div);
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
                alert('채팅방 번호는 숫자로 입력하세요.');
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
                    if (currentRoom !== subscribedRoom) {
                        return;
                    }

                    const data = JSON.parse(frame.body);

                    if (historyLoading) {
                        pendingMessages.push(data);
                    } else {
                        appendMessage(data);
                    }
                }
            );

            document.getElementById('status').textContent =
                '채팅방 ' + currentRoom + ' 입장 완료';
        }

        async function loadHistory(roomId, version) {
            historyLoading = true;
            pendingMessages = [];

            document.getElementById('status').textContent =
                '채팅방 ' + roomId + ' 이전 대화 불러오는 중...';

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

                if (version !== roomVersion) {
                    return;
                }

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
                    '채팅방 ' + roomId + ' 입장 완료';

            } catch (error) {
                if (version !== roomVersion) {
                    return;
                }

                document.getElementById('status').textContent =
                    '이전 대화 조회 실패: ' + error.message;

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

            if (!content) {
                return;
            }

            const sender =
                document.getElementById('sender').value.trim();

            if (!sender) {
                alert('보낸 사람 이름을 입력하세요.');
                return;
            }

            client.publish({
                destination: '/app/chat.send/' + currentRoom,
                body: JSON.stringify({
                    roomId: currentRoom,
                    sender: sender,
                    content: content
                })
            });

            input.value = '';
        }
    </script>
</body>
</html>

