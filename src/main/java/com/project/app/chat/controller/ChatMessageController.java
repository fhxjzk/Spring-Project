
package com.project.app.chat.controller;

import java.security.Principal;
import java.sql.SQLException;

import org.springframework.dao.DataAccessException;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;

import com.project.app.auth.CustomUser;
import com.project.app.chat.filter.MessageFilterService;
import com.project.app.chat.mapper.ChatRoomMapper;
import com.project.app.chat.model.ChatMessage;
import com.project.app.chat.repository.ChatMessageRepository;
import com.project.app.notice.service.NotificationService;

@Controller
public class ChatMessageController {

    private final MessageFilterService messageFilterService;
    private final SimpMessagingTemplate messagingTemplate;
    private final ChatMessageRepository chatMessageRepository;
    private final ChatRoomMapper chatRoomMapper;
    private final NotificationService notificationService;

    public ChatMessageController(
            MessageFilterService messageFilterService,
            SimpMessagingTemplate messagingTemplate,
            ChatMessageRepository chatMessageRepository,
            ChatRoomMapper chatRoomMapper,
            NotificationService notificationService) {

        this.messageFilterService = messageFilterService;
        this.messagingTemplate = messagingTemplate;
        this.chatMessageRepository = chatMessageRepository;
        this.chatRoomMapper = chatRoomMapper;
        this.notificationService = notificationService;
    }

    @MessageMapping("/chat.send/{roomId}")
    public void sendMessage(
            @DestinationVariable String roomId,
            @Payload ChatMessage message,
            Principal principal) {

        // 1. 로그인 회원 확인
        if (!(principal instanceof Authentication)) {
            return;
        }

        Authentication authentication = (Authentication) principal;

        if (!(authentication.getPrincipal() instanceof CustomUser)) {
            return;
        }

        CustomUser user =
                (CustomUser) authentication.getPrincipal();

        Long senderSeq = user.getMemberSeq();

        if (senderSeq == null) {
            return;
        }

        // 2. 채팅방 번호 검증
        if (roomId == null ||
                !roomId.matches("[0-9]{1,18}")) {
            return;
        }

        Long chatRoomSeq;

        try {
            chatRoomSeq = Long.valueOf(roomId);
        } catch (NumberFormatException e) {
            return;
        }

        // 3. 채팅방 참여자 권한 확인
        if (chatRoomMapper.countMembership(
                chatRoomSeq, senderSeq) == 0) {
            return;
        }

        // 4. 메시지 내용 확인
        if (message == null ||
                message.getContent() == null ||
                message.getContent().trim().isEmpty()) {
            return;
        }

        // 5. 메시지 필터링
        String filteredContent =
                messageFilterService.filter(
                        message.getContent());

        if (filteredContent == null ||
                filteredContent.trim().isEmpty()) {
            return;
        }

        // Oracle VARCHAR2(4000) 범위 확인
        if (filteredContent.getBytes(
                java.nio.charset.StandardCharsets.UTF_8
                ).length > 4000) {
            return;
        }

        // 6. 로그인 회원번호로 메시지 저장
        ChatMessage savedMessage;

        try {
            savedMessage = chatMessageRepository.save(
                    chatRoomSeq,
                    senderSeq,
                    filteredContent);

        } catch (SQLException | DataAccessException e) {
            System.err.println("채팅 메시지 저장 실패");
            e.printStackTrace();
            return;
        }

        // 7. 채팅방에 메시지 전송
        messagingTemplate.convertAndSend(
                "/topic/room/" + chatRoomSeq,
                savedMessage);

        // 8. 채팅 상대방 알림
        // 알림 실패가 채팅 저장 결과에 영향을 주지 않도록 처리
        try {

            Long receiverSeq =
                    chatRoomMapper.findReceiverSeq(
                            chatRoomSeq, senderSeq);

            if (receiverSeq == null) {
                return;
            }

            String receiverLoginId =
                    chatRoomMapper.findLoginId(receiverSeq);

            if (receiverLoginId == null ||
                    receiverLoginId.trim().isEmpty()) {
                return;
            }

            notificationService.send(
                    receiverSeq,
                    receiverLoginId,
                    "CHAT",
                    "새 채팅 메시지",
                    "새로운 채팅 메시지가 도착했습니다.",
                    chatRoomSeq
            );

        } catch (Exception e) {
            System.err.println("채팅 알림 처리 실패");
            e.printStackTrace();
        }
    }
}
