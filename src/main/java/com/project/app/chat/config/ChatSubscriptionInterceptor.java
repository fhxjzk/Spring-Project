
package com.project.app.chat.config;

import org.springframework.messaging.Message;
import org.springframework.messaging.MessageChannel;
import org.springframework.messaging.simp.stomp.StompCommand;
import org.springframework.messaging.simp.stomp.StompHeaderAccessor;
import org.springframework.messaging.support.ChannelInterceptor;
import org.springframework.security.core.Authentication;

import com.project.app.auth.CustomUser;
import com.project.app.chat.mapper.ChatRoomMapper;

public class ChatSubscriptionInterceptor implements ChannelInterceptor {

    private final ChatRoomMapper chatRoomMapper;

    public ChatSubscriptionInterceptor(ChatRoomMapper chatRoomMapper) {
        this.chatRoomMapper = chatRoomMapper;
    }

    @Override
    public Message<?> preSend(
            Message<?> message,
            MessageChannel channel) {

        StompHeaderAccessor accessor =
                StompHeaderAccessor.wrap(message);

        if (StompCommand.SUBSCRIBE.equals(accessor.getCommand())) {

            String destination = accessor.getDestination();

            // 구독 주소가 없는 요청 차단
            if (destination == null) {
                throw new SecurityException("구독 주소가 없습니다.");
            }

            // 개인 알림 주소만 허용
            if ("/user/queue/notifications".equals(destination)) {
                return message;
            }

            // 정해진 채팅방 주소 이외에는 모두 차단
            if (!destination.matches("/topic/room/[0-9]{1,18}")) {
                throw new SecurityException("구독할 수 없는 주소입니다.");
            }

            // 채팅방 번호 추출
            String roomId =
                    destination.substring("/topic/room/".length());

            Long chatRoomSeq = Long.valueOf(roomId);

            // 로그인 회원 확인
            if (!(accessor.getUser() instanceof Authentication)) {
                throw new SecurityException("로그인이 필요합니다.");
            }

            Authentication authentication =
                    (Authentication) accessor.getUser();

            if (!(authentication.getPrincipal() instanceof CustomUser)) {
                throw new SecurityException("로그인이 필요합니다.");
            }

            CustomUser user =
                    (CustomUser) authentication.getPrincipal();

            Long memberSeq = user.getMemberSeq();

            // 채팅방 참여자 권한 확인
            if (memberSeq == null ||
                    chatRoomMapper.countMembership(
                            chatRoomSeq, memberSeq) == 0) {

                throw new SecurityException(
                        "해당 채팅방 구독 권한이 없습니다.");
            }
        }

        return message;
    }
}
