
package com.project.app.chat.controller;

import java.sql.SQLException;

import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;

import com.project.app.chat.filter.MessageFilterService;
import com.project.app.chat.model.ChatMessage;
import com.project.app.chat.repository.ChatMessageRepository;

@Controller
public class ChatMessageController {

    private final MessageFilterService messageFilterService;
    private final SimpMessagingTemplate messagingTemplate;
    private final ChatMessageRepository chatMessageRepository;

    public ChatMessageController(
            MessageFilterService messageFilterService,
            SimpMessagingTemplate messagingTemplate,
            ChatMessageRepository chatMessageRepository) {

        this.messageFilterService = messageFilterService;
        this.messagingTemplate = messagingTemplate;
        this.chatMessageRepository = chatMessageRepository;
    }


@MessageMapping("/chat.send/{roomId}")
public void sendMessage(
        @DestinationVariable String roomId,
        @Payload ChatMessage message) {

    System.out.println("채팅 메시지 수신: " + roomId);

    if (roomId == null || !roomId.matches("[0-9]{1,18}")) {
        return;
    }

    if (message == null
            || message.getContent() == null
            || message.getContent().trim().isEmpty()
            || message.getSender() == null
            || message.getSender().trim().isEmpty()) {
        return;
    }

    // 1. 메시지 마스킹
    String filteredContent =
            messageFilterService.filter(message.getContent());

    if (filteredContent == null) {
        return;
    }

    // 2. Oracle 저장 후 ID와 작성 시간 가져오기
    ChatMessage savedMessage;

    try {
        savedMessage = chatMessageRepository.save(
                roomId,
                message.getSender(),
                filteredContent);

        System.out.println(
                "Oracle 저장 성공! 메시지 ID: "
                + savedMessage.getMessageId());

    } catch (SQLException e) {
        System.err.println("Oracle 메시지 저장 실패");
        e.printStackTrace();
        return;
    }

    // 3. 저장된 메시지 정보를 실시간 전송
    messagingTemplate.convertAndSend(
            "/topic/room/" + roomId,
            savedMessage);
}
}
