
document.addEventListener("DOMContentLoaded", function () {

    const bell = document.getElementById("notificationBell");
    const panel = document.getElementById("notificationPanel");
    const list = document.getElementById("notificationList");
    const count = document.getElementById("notificationCount");
    // 알림 소리 재생
let notificationAudioContext = null;

function playNotificationSound() {
    try {
        const AudioContextClass =
            window.AudioContext || window.webkitAudioContext;

        if (!AudioContextClass) {
            return;
        }

        if (!notificationAudioContext) {
            notificationAudioContext = new AudioContextClass();
        }

        const audioContext = notificationAudioContext;

        if (audioContext.state !== "running") {
    audioContext.resume()
        .then(function () {
            playNotificationSound();
        })
        .catch(function (error) {
            console.warn("오디오 활성화 실패", error);
        });
    return;
}

        // 부드러운 2음 알림
        [880, 1174.66].forEach(function (frequency, index) {
            const oscillator = audioContext.createOscillator();
            const gain = audioContext.createGain();

            const startTime =
                audioContext.currentTime + index * 0.18;

            oscillator.type = "sine";
            oscillator.frequency.value = frequency;

            gain.gain.setValueAtTime(0.0001, startTime);
            gain.gain.exponentialRampToValueAtTime(
                0.12, startTime + 0.02
            );
            gain.gain.exponentialRampToValueAtTime(
                0.0001, startTime + 0.35
            );

            oscillator.connect(gain);
            gain.connect(audioContext.destination);

            oscillator.start(startTime);
            oscillator.stop(startTime + 0.36);
        });
    } catch (error) {
        console.warn("알림 소리 재생 실패", error);
    }
}

// 사용자가 화면을 클릭하면 브라우저 오디오 활성화
document.addEventListener("click", function unlockAudio() {
    const AudioContextClass =
        window.AudioContext || window.webkitAudioContext;

    if (AudioContextClass) {
        if (!notificationAudioContext) {
            notificationAudioContext = new AudioContextClass();
        }

        notificationAudioContext.resume().catch(function () {});
    }

    document.removeEventListener("click", unlockAudio);
});
    if (!bell || !panel || !list || !count) {
        return;
    }

    // 현재 사이트의 컨텍스트 경로 가져오기
   const script = document.querySelector(
    'script[src$="notification.js"]'
);

if (!script) {
    console.error("notification.js 파일을 찾지 못했습니다.");
    return;
}

const scriptPath = new URL(script.src, window.location.href).pathname;

const contextPath = scriptPath.split(
    "/resources/js/notification.js"
)[0];

    // 알림 목록을 안전하게 화면에 표시
    function renderNotifications(notifications) {
        list.replaceChildren();

        if (notifications.length === 0) {
            const li = document.createElement("li");
            li.textContent = "새로운 알림이 없습니다.";
            list.appendChild(li);
        }

        notifications.forEach(function (notification) {
            const li = document.createElement("li");

            const title = document.createElement("strong");
            title.textContent = notification.title || "알림";

            const message = document.createElement("div");
            message.textContent = notification.message || "";

           
li.appendChild(title);
li.appendChild(message);

// 읽지 않은 알림에만 클릭 기능 추가
if (notification.isRead === "N") {

    li.style.cursor = "pointer";
    li.title = "클릭하면 읽음 처리됩니다.";

    li.addEventListener("click", function () {

        // 중복 클릭 방지
        if (li.dataset.processing === "true") {
            return;
        }

        li.dataset.processing = "true";

        // Spring Security CSRF 토큰 확인
        const csrfToken = document.querySelector(
            'meta[name="_csrf"]'
        );

        const csrfHeader = document.querySelector(
            'meta[name="_csrf_header"]'
        );

        const headers = {};

        if (csrfToken && csrfHeader) {
            headers[csrfHeader.content] = csrfToken.content;
        }

        fetch(
            contextPath + "/notification/" +
            notification.notificationId + "/read",
            {
                method: "POST",
                credentials: "same-origin",
                headers: headers
            }
        )
        .then(function (response) {
            if (!response.ok) {
                throw new Error(
                    "읽음 처리 실패: " + response.status
                );
            }

            // 성공하면 서버 목록 다시 조회
            loadNotifications();
        })
        .catch(function (error) {
            console.error(error);
            alert("알림을 읽음 처리하지 못했습니다.");
        })
        .finally(function () {
            li.dataset.processing = "false";
        });

    });
}

list.appendChild(li);

        });

        const unreadCount = notifications.filter(function (item) {
            return item.isRead === "N";
        }).length;

        count.textContent = unreadCount;
        count.hidden = unreadCount === 0;
    }

    // 서버에서 알림 목록 가져오기
    function loadNotifications() {
        fetch(contextPath + "/notification/list", {
            credentials: "same-origin",
            headers: {
                "Accept": "application/json"
            }
        })
        .then(function (response) {
            if (!response.ok) {
                throw new Error("알림 조회 실패: " + response.status);
            }
            return response.json();
        })
        .then(function (notifications) {
            renderNotifications(notifications);
        })
        .catch(function (error) {
            console.error(error);
            list.replaceChildren();

            const li = document.createElement("li");
            li.textContent = "알림을 불러오지 못했습니다.";
            list.appendChild(li);
        });
    }

    // 종 버튼 클릭
    bell.addEventListener("click", function () {
        panel.hidden = !panel.hidden;

        if (!panel.hidden) {
            loadNotifications();
        }
    });
    
    // 실시간 알림 WebSocket 연결
    function connectNotificationWebSocket() {

        // STOMP 라이브러리가 없으면 연결하지 않음
        if (typeof StompJs === "undefined") {
            console.warn("STOMP 라이브러리가 없습니다.");
            return;
        }

        const protocol = window.location.protocol === "https:"
            ? "wss:"
            : "ws:";

        const client = new StompJs.Client({
            brokerURL: protocol + "//" +
                window.location.host + contextPath + "/ws",

            reconnectDelay: 5000,

            onConnect: function () {
                console.log("알림 WebSocket 연결 성공");

              client.subscribe(
    "/user/queue/notifications",
    function (message) {
        console.log("새 알림 도착", message.body);

        // 새 알림 수신 시 알림음 1회 재생
        playNotificationSound();

        // 알림 목록 및 읽지 않은 알림 개수 갱신
        loadNotifications();
           }
         );
            },

            onStompError: function (frame) {
                console.error("STOMP 오류", frame);
            },

            onWebSocketError: function (error) {
                console.error("WebSocket 연결 오류", error);
            }
        });

        client.activate();
    }
    loadNotifications();
    connectNotificationWebSocket();
    

});
