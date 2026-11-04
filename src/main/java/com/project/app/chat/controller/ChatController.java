
package com.project.app.chat.controller;

import java.sql.SQLException;
import java.util.List;

import org.springframework.dao.DataAccessException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.project.app.auth.CustomUser;
import com.project.app.chat.filter.MessageFilterService;
import com.project.app.chat.mapper.ChatRoomMapper;
import com.project.app.chat.model.ChatMessage;
import com.project.app.chat.repository.ChatMessageRepository;
import com.project.app.chat.service.ChatRoomService;
import com.project.app.chat.model.ChatRoomListDto;
@Controller
public class ChatController {

    private final MessageFilterService messageFilterService;
    private final ChatMessageRepository chatMessageRepository;
    private final ChatRoomMapper chatRoomMapper;
    private final ChatRoomService chatRoomService;

    public ChatController(
            MessageFilterService messageFilterService,
            ChatMessageRepository chatMessageRepository,
            ChatRoomMapper chatRoomMapper,
            ChatRoomService chatRoomService) {

        this.messageFilterService = messageFilterService;
        this.chatMessageRepository = chatMessageRepository;
        this.chatRoomMapper = chatRoomMapper;
        this.chatRoomService = chatRoomService;
    }

    // 1. 채팅 메시지 필터링
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
    public String chatTest(
            Authentication authentication,
            Model model) {

        if (authentication == null ||
                !(authentication.getPrincipal() instanceof CustomUser)) {
            return "redirect:/login";
        }

        CustomUser user =
                (CustomUser) authentication.getPrincipal();

        Long memberSeq = user.getMemberSeq();

        if (memberSeq == null) {
            return "redirect:/login";
        }

        model.addAttribute("loginMemberSeq", memberSeq);

        return "chat-test";
    }

    // 3. 거래 상세 화면에서 채팅방 입장
    @GetMapping("/chat/enter")
    public String enterChat(
            @RequestParam("tradeSeq") Long tradeSeq,
            Authentication authentication,
            Model model) {

        // 로그인 확인
        if (authentication == null ||
                !(authentication.getPrincipal() instanceof CustomUser)) {
            return "redirect:/login";
        }

        CustomUser user =
                (CustomUser) authentication.getPrincipal();

        Long memberSeq = user.getMemberSeq();

        if (memberSeq == null) {
            return "redirect:/login";
        }

        // 거래번호 검증
        if (tradeSeq == null || tradeSeq <= 0) {
            return "redirect:/trade/mylist.do";
        }

        // 중요: 채팅방 생성 전에 거래 참여자 확인
        int membership =
                chatRoomMapper.countTradeMembership(
                        tradeSeq, memberSeq);

        if (membership == 0) {
            return "redirect:/trade/mylist.do";
        }

        // 권한이 확인된 거래만 채팅방 조회 또는 생성
        Long roomSeq =
                chatRoomService.getOrCreateRoom(tradeSeq);

        // 채팅방 참여 권한 재확인
        if (chatRoomMapper.countMembership(
                roomSeq, memberSeq) == 0) {

            return "redirect:/trade/mylist.do";
        }


        // 채팅 상대방 정보 조회
        Long opponentSeq =
                chatRoomMapper.findReceiverSeq(roomSeq, memberSeq);

        if (opponentSeq == null) {
            return "redirect:/trade/mylist.do";
        }

        String opponentName = null;

        List<ChatRoomListDto> chatRooms =
                chatRoomMapper.findChatRoomList(memberSeq);

        for (ChatRoomListDto room : chatRooms) {
            if (roomSeq.equals(room.getChatRoomSeq())) {
                opponentName = room.getOpponentName();
                break;
            }
        }

        if (opponentName == null || opponentName.trim().isEmpty()) {
            opponentName = "상대방";
        }

        // 채팅 화면에 정보 전달
        model.addAttribute("loginMemberSeq", memberSeq);
        model.addAttribute("roomSeq", roomSeq);
        model.addAttribute("opponentName", opponentName);

        return "chat-test";

    }

    // 4. 이전 채팅 내역 조회
    @GetMapping("/chat/history/{roomId}")
    @ResponseBody
    public ResponseEntity<?> getChatHistory(
            @PathVariable("roomId") String roomId,
            Authentication authentication) {

        // 로그인 확인
        if (authentication == null ||
                !(authentication.getPrincipal() instanceof CustomUser)) {

            return ResponseEntity
                    .status(HttpStatus.UNAUTHORIZED)
                    .body("로그인이 필요합니다.");
        }

        // 채팅방 번호 확인
        if (roomId == null ||
                !roomId.matches("[0-9]{1,18}")) {

            return ResponseEntity.badRequest()
                    .body("올바르지 않은 채팅방 번호입니다.");
        }

        Long chatRoomSeq;

        try {
            chatRoomSeq = Long.valueOf(roomId);
        } catch (NumberFormatException e) {
            return ResponseEntity.badRequest()
                    .body("올바르지 않은 채팅방 번호입니다.");
        }

        // 로그인 회원 확인
        CustomUser user =
                (CustomUser) authentication.getPrincipal();

        Long memberSeq = user.getMemberSeq();

        // 채팅방 참여 권한 확인
        if (memberSeq == null ||
                chatRoomMapper.countMembership(
                        chatRoomSeq, memberSeq) == 0) {

            return ResponseEntity
                    .status(HttpStatus.FORBIDDEN)
                    .body("해당 채팅방에 접근할 권한이 없습니다.");
        }

        // 이전 대화 조회
        try {
            List<ChatMessage> messages =
                    chatMessageRepository
                        .findMessagesByRoomId(chatRoomSeq);

            return ResponseEntity.ok(messages);

        } catch (SQLException | DataAccessException e) {

            return ResponseEntity
                    .status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("채팅 내역 조회 중 오류가 발생했습니다.");
        }
    }

    // 5. 내 채팅방 목록 화면
    @GetMapping("/chat/list")
    public String chatList(
            Authentication authentication,
            Model model) {

        // 로그인 확인
        if (authentication == null ||
                !(authentication.getPrincipal() instanceof CustomUser)) {
            return "redirect:/login";
        }

        CustomUser user =
                (CustomUser) authentication.getPrincipal();

        Long memberSeq = user.getMemberSeq();

        if (memberSeq == null || memberSeq <= 0) {
            return "redirect:/login";
        }

        // 로그인 회원의 채팅방 목록 조회
        List<ChatRoomListDto> rooms =
                chatRoomService.getChatRoomList(memberSeq);

        model.addAttribute("chatRooms", rooms);
        model.addAttribute("loginMemberSeq", memberSeq);

        return "chat-list";
    }

}
