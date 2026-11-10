
package com.project.app.chat.controller;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.security.Principal;

import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.project.app.auth.CustomUser;
import com.project.app.chat.mapper.ChatRoomMapper;
import com.project.app.chat.model.ChatAttachment;
import com.project.app.chat.model.ChatMessage;
import com.project.app.chat.repository.ChatAttachmentRepository;
import com.project.app.chat.service.ChatAttachmentService;
import com.project.app.chat.service.ChatFileStorageService;

@RestController
public class ChatAttachmentController {

    private final ChatAttachmentService attachmentService;
    private final ChatAttachmentRepository attachmentRepository;
    private final ChatFileStorageService fileStorageService;
    private final ChatRoomMapper chatRoomMapper;
    private final SimpMessagingTemplate messagingTemplate;

    public ChatAttachmentController(
            ChatAttachmentService attachmentService,
            ChatAttachmentRepository attachmentRepository,
            ChatFileStorageService fileStorageService,
            ChatRoomMapper chatRoomMapper,
            SimpMessagingTemplate messagingTemplate) {

        this.attachmentService = attachmentService;
        this.attachmentRepository = attachmentRepository;
        this.fileStorageService = fileStorageService;
        this.chatRoomMapper = chatRoomMapper;
        this.messagingTemplate = messagingTemplate;
    }

    // 1. 사진·영상 업로드
    @PostMapping("/chat/attachment/upload")
    public ResponseEntity<?> upload(
            @RequestParam("roomId") Long roomId,
            @RequestPart("file") MultipartFile file,
            Principal principal) {

        Long senderSeq = getLoginMemberSeq(principal);

        if (senderSeq == null) {
            return errorResponse(
                    HttpStatus.UNAUTHORIZED,
                    "로그인이 필요합니다.");
        }

        if (roomId == null || roomId <= 0) {
            return errorResponse(
                    HttpStatus.BAD_REQUEST,
                    "잘못된 채팅방 번호입니다.");
        }

        if (chatRoomMapper.countMembership(roomId, senderSeq) == 0) {
            return errorResponse(
                    HttpStatus.FORBIDDEN,
                    "채팅방 접근 권한이 없습니다.");
        }

        if (file == null || file.isEmpty()) {
            return errorResponse(
                    HttpStatus.BAD_REQUEST,
                    "첨부파일이 없습니다.");
        }

        try {
            ChatMessage savedMessage =
                    attachmentService.saveAttachment(
                            roomId, senderSeq, file);

            messagingTemplate.convertAndSend(
                    "/topic/room/" + roomId,
                    savedMessage);

            return ResponseEntity.ok(savedMessage);

        } catch (IOException e) {
            return errorResponse(
                    HttpStatus.BAD_REQUEST,
                    e.getMessage());

        } catch (Exception e) {
            System.err.println("채팅 첨부파일 업로드 실패");
            e.printStackTrace();

            return errorResponse(
                    HttpStatus.INTERNAL_SERVER_ERROR,
                    "파일 업로드 중 오류가 발생했습니다.");
        }
    }

    // 2. 사진·영상 조회
    @GetMapping("/chat/attachment/{attachmentSeq}")
    public ResponseEntity<?> viewAttachment(
            @PathVariable("attachmentSeq") Long attachmentSeq,
            Principal principal) {

        Long memberSeq = getLoginMemberSeq(principal);

        if (memberSeq == null) {
            return errorResponse(
                    HttpStatus.UNAUTHORIZED,
                    "로그인이 필요합니다.");
        }

        if (attachmentSeq == null || attachmentSeq <= 0) {
            return errorResponse(
                    HttpStatus.BAD_REQUEST,
                    "잘못된 첨부파일 번호입니다.");
        }

        try {
            ChatAttachment attachment =
                    attachmentRepository.findById(attachmentSeq);

            if (attachment == null) {
                return errorResponse(
                        HttpStatus.NOT_FOUND,
                        "첨부파일을 찾을 수 없습니다.");
            }

            Long roomSeq =
                    chatRoomMapper.findRoomSeqByMessageId(
                            attachment.getChatMessageSeq());

            if (roomSeq == null
                    || chatRoomMapper.countMembership(
                            roomSeq, memberSeq) == 0) {

                return errorResponse(
                        HttpStatus.FORBIDDEN,
                        "첨부파일 조회 권한이 없습니다.");
            }

            Path path = fileStorageService.getFilePath(
                    attachment.getStoredName());

            if (!Files.isRegularFile(path)) {
                return errorResponse(
                        HttpStatus.NOT_FOUND,
                        "저장된 파일이 없습니다.");
            }

            Resource resource = new FileSystemResource(path);

            MediaType mediaType = MediaType.parseMediaType(
                    attachment.getContentType());

            return ResponseEntity.ok()
                    .contentType(mediaType)
                    .contentLength(Files.size(path))
                    .header(
                            HttpHeaders.CONTENT_DISPOSITION,
                            "inline")
                    .header(
                            "X-Content-Type-Options",
                            "nosniff")
                    .body(resource);

        } catch (IOException e) {
            return errorResponse(
                    HttpStatus.NOT_FOUND,
                    "파일을 읽을 수 없습니다.");

        } catch (Exception e) {
            System.err.println("첨부파일 조회 실패");
            e.printStackTrace();

            return errorResponse(
                    HttpStatus.INTERNAL_SERVER_ERROR,
                    "첨부파일 조회 중 오류가 발생했습니다.");
        }
    }

    // 3. 내가 보낸 첨부파일 삭제
    @DeleteMapping("/chat/attachment/{attachmentSeq}")
    public ResponseEntity<?> deleteAttachment(
            @PathVariable("attachmentSeq") Long attachmentSeq,
            Principal principal) {

        Long memberSeq = getLoginMemberSeq(principal);

        if (memberSeq == null) {
            return errorResponse(
                    HttpStatus.UNAUTHORIZED,
                    "로그인이 필요합니다.");
        }

        try {
            ChatMessage updated =
                    attachmentService.deleteAttachment(
                            attachmentSeq, memberSeq);

            messagingTemplate.convertAndSend(
                    "/topic/room/" + updated.getChatRoomSeq(),
                    updated);

            return ResponseEntity.ok(updated);

        } catch (SecurityException e) {
            return errorResponse(
                    HttpStatus.FORBIDDEN,
                    e.getMessage());

        } catch (IllegalArgumentException e) {
            return errorResponse(
                    HttpStatus.BAD_REQUEST,
                    e.getMessage());

        } catch (Exception e) {
            System.err.println("채팅 첨부파일 삭제 실패");
            e.printStackTrace();

            return errorResponse(
                    HttpStatus.INTERNAL_SERVER_ERROR,
                    "첨부파일 삭제 중 오류가 발생했습니다.");
        }
    }

    // 4. 내가 보낸 첨부파일 교체
    @PostMapping("/chat/attachment/{attachmentSeq}/replace")
    public ResponseEntity<?> replaceAttachment(
            @PathVariable("attachmentSeq") Long attachmentSeq,
            @RequestPart("file") MultipartFile file,
            Principal principal) {

        Long memberSeq = getLoginMemberSeq(principal);

        if (memberSeq == null) {
            return errorResponse(
                    HttpStatus.UNAUTHORIZED,
                    "로그인이 필요합니다.");
        }

        if (file == null || file.isEmpty()) {
            return errorResponse(
                    HttpStatus.BAD_REQUEST,
                    "새 첨부파일이 없습니다.");
        }

        try {
            ChatMessage updated =
                    attachmentService.replaceAttachment(
                            attachmentSeq, memberSeq, file);

            messagingTemplate.convertAndSend(
                    "/topic/room/" + updated.getChatRoomSeq(),
                    updated);

            return ResponseEntity.ok(updated);

        } catch (SecurityException e) {
            return errorResponse(
                    HttpStatus.FORBIDDEN,
                    e.getMessage());

        } catch (IllegalArgumentException e) {
            return errorResponse(
                    HttpStatus.BAD_REQUEST,
                    e.getMessage());

        } catch (IOException e) {
            return errorResponse(
                    HttpStatus.BAD_REQUEST,
                    e.getMessage());

        } catch (Exception e) {
            System.err.println("채팅 첨부파일 교체 실패");
            e.printStackTrace();

            return errorResponse(
                    HttpStatus.INTERNAL_SERVER_ERROR,
                    "첨부파일 교체 중 오류가 발생했습니다.");
        }
    }

    // 5. 로그인 회원번호 확인
    private Long getLoginMemberSeq(Principal principal) {

        if (!(principal instanceof Authentication)) {
            return null;
        }

        Authentication authentication =
                (Authentication) principal;

        if (!authentication.isAuthenticated()
                || !(authentication.getPrincipal()
                        instanceof CustomUser)) {
            return null;
        }

        return ((CustomUser) authentication.getPrincipal())
                .getMemberSeq();
    }

    // 6. 한글 오류 메시지를 UTF-8로 반환
    private ResponseEntity<String> errorResponse(
            HttpStatus status, String message) {

        return ResponseEntity.status(status)
                .contentType(new MediaType(
                        "text",
                        "plain",
                        StandardCharsets.UTF_8))
                .body(message);
    }
}
