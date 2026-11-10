
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

        // 구독 요청이 아닌 경우 기존 처리 유지
        if (!StompCommand.SUBSCRIBE.equals(accessor.getCommand())) {
            return message;
        }

        // 1. 로그인 회원 확인
        if (!(accessor.getUser() instanceof Authentication)) {
            throw new SecurityException("로그인이 필요합니다.");
        }

        Authentication authentication =
                (Authentication) accessor.getUser();

        if (!authentication.isAuthenticated()
                || !(authentication.getPrincipal() instanceof CustomUser)) {
            throw new SecurityException("로그인이 필요합니다.");
        }

        CustomUser user =
                (CustomUser) authentication.getPrincipal();

        Long memberSeq = user.getMemberSeq();

        if (memberSeq == null) {
            throw new SecurityException("회원정보가 없습니다.");
        }

        // 2. 구독 주소 확인
        String destination = accessor.getDestination();

        if (destination == null) {
            throw new SecurityException("구독 주소가 없습니다.");
        }

        // 3. 로그인한 회원만 개인 알림 구독 허용
        if ("/user/queue/notifications".equals(destination)) {
            return message;
        }

        // 4. 정해진 채팅방 주소만 허용
        if (!destination.matches("/topic/room/[0-9]{1,18}")) {
            throw new SecurityException("구독할 수 없는 주소입니다.");
        }

        // 5. 채팅방 번호 추출
        String roomId =
                destination.substring("/topic/room/".length());

        Long chatRoomSeq;

        try {
            chatRoomSeq = Long.valueOf(roomId);
        } catch (NumberFormatException e) {
            throw new SecurityException("올바르지 않은 채팅방 번호입니다.");
        }

        // 6. 실제 채팅방 참여자인지 DB 확인
        if (chatRoomMapper.countMembership(
                chatRoomSeq, memberSeq) == 0) {

            throw new SecurityException(
                    "해당 채팅방 구독 권한이 없습니다.");
        }

        return message;
    }
}
