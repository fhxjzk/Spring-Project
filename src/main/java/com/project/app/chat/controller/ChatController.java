
package com.project.app.chat.controller;

import java.sql.SQLException;
import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;

import com.project.app.chat.filter.MessageFilterService;
import com.project.app.chat.model.ChatMessage;
import com.project.app.chat.repository.ChatMessageRepository;

@Controller
public class ChatController {

    private final MessageFilterService messageFilterService;
    private final ChatMessageRepository chatMessageRepository;

    public ChatController(
            MessageFilterService messageFilterService,
            ChatMessageRepository chatMessageRepository) {

        this.messageFilterService = messageFilterService;
        this.chatMessageRepository = chatMessageRepository;
    }

    // 1. 채팅 메시지 마스킹 테스트
    @PostMapping(
        value = "/chat/filter",
        produces = "text/plain;charset=UTF-8"
    )
    @ResponseBody
    public String filterMessage(@RequestBody String message) {

        return messageFilterService.filter(message);
    }

    // 2. 채팅 테스트 화면
    @GetMapping("/chat-test")
    public String chatTest() {

        return "chat-test";
    }

    // 3. Oracle에서 이전 채팅 내역 조회
    @GetMapping("/chat/history/{roomId}")
    @ResponseBody
    public ResponseEntity<?> getChatHistory(
            @PathVariable("roomId") String roomId) {

        if (roomId == null ||
                !roomId.matches("[0-9]{1,18}")) {

            return ResponseEntity.badRequest()
                    .body("올바르지 않은 채팅방 번호입니다.");
        }

        try {

            List<ChatMessage> messages =
                    chatMessageRepository
                        .findMessagesByRoomId(roomId);

            return ResponseEntity.ok(messages);

        } catch (SQLException e) {

            e.printStackTrace();

            return ResponseEntity
                    .status(500)
                    .body("채팅 내역 조회 중 오류가 발생했습니다.");
        }
    }
}

