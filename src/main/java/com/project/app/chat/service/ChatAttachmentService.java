
package com.project.app.chat.service;

import java.io.IOException;
import java.sql.SQLException;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.support.TransactionSynchronization;
import org.springframework.transaction.support.TransactionSynchronizationManager;
import org.springframework.web.multipart.MultipartFile;

import com.project.app.chat.model.ChatAttachment;
import com.project.app.chat.model.ChatMessage;
import com.project.app.chat.repository.ChatAttachmentRepository;
import com.project.app.chat.repository.ChatMessageRepository;

@Service
public class ChatAttachmentService {

    private static final String DELETED_CONTENT =
            "삭제된 첨부파일입니다.";

    private final ChatFileStorageService fileStorageService;
    private final ChatAttachmentRepository attachmentRepository;
    private final ChatMessageRepository messageRepository;

    public ChatAttachmentService(
            ChatFileStorageService fileStorageService,
            ChatAttachmentRepository attachmentRepository,
            ChatMessageRepository messageRepository) {

        this.fileStorageService = fileStorageService;
        this.attachmentRepository = attachmentRepository;
        this.messageRepository = messageRepository;
    }

    // 1. 기존 사진·동영상 업로드
    @Transactional(rollbackFor = Exception.class)
    public ChatMessage saveAttachment(
            Long chatRoomSeq,
            Long senderSeq,
            MultipartFile file) throws Exception {

        if (file == null || file.isEmpty()) {
            throw new IOException("첨부파일이 없습니다.");
        }

        String contentType = file.getContentType();

        String content = "video/mp4".equals(contentType)
                ? "[동영상]" : "[사진]";

        String storedName = null;

        try {
            storedName = fileStorageService.save(file);

            final String newStoredName = storedName;
            registerRollbackCleanup(newStoredName);

            ChatMessage message = messageRepository.save(
                    chatRoomSeq, senderSeq, content);

            ChatAttachment attachment = attachmentRepository.save(
                    message.getMessageId(),
                    getOriginalName(file),
                    storedName,
                    contentType,
                    file.getSize()
            );

            message.setAttachmentSeq(
                    attachment.getAttachmentSeq());

            message.setAttachmentContentType(
                    attachment.getContentType());

            return message;

        } catch (Exception e) {
            if (storedName != null) {
                try {
                    fileStorageService.delete(storedName);
                } catch (IOException deleteError) {
                    e.addSuppressed(deleteError);
                }
            }
            throw e;
        }
    }

    // 2. 내가 보낸 첨부파일 삭제
    @Transactional(rollbackFor = Exception.class)
    public ChatMessage deleteAttachment(
            Long attachmentSeq,
            Long memberSeq) throws Exception {

        ChatAttachment attachment =
                getOwnedAttachment(attachmentSeq, memberSeq);

        ChatMessage message = messageRepository.findById(
                attachment.getChatMessageSeq());

        attachmentRepository.deleteById(attachmentSeq);

        messageRepository.updateContent(
                message.getMessageId(),
                DELETED_CONTENT
        );

        // DB 커밋이 성공한 뒤 실제 파일 삭제
        registerCommitCleanup(attachment.getStoredName());

        ChatMessage updated = messageRepository.findById(
                message.getMessageId());

        if (updated == null) {
            throw new SQLException("변경된 메시지 조회 실패");
        }

        return updated;
    }

    // 3. 내가 보낸 첨부파일 교체
    @Transactional(rollbackFor = Exception.class)
    public ChatMessage replaceAttachment(
            Long attachmentSeq,
            Long memberSeq,
            MultipartFile file) throws Exception {

        if (file == null || file.isEmpty()) {
            throw new IOException("새 첨부파일이 없습니다.");
        }

        ChatAttachment oldAttachment =
                getOwnedAttachment(attachmentSeq, memberSeq);

        String newStoredName = fileStorageService.save(file);

        try {
            registerRollbackCleanup(newStoredName);

            String contentType = file.getContentType();

            attachmentRepository.updateAttachment(
                    attachmentSeq,
                    getOriginalName(file),
                    newStoredName,
                    contentType,
                    file.getSize()
            );

            String content = "video/mp4".equals(contentType)
                    ? "[동영상]" : "[사진]";

            messageRepository.updateContent(
                    oldAttachment.getChatMessageSeq(),
                    content
            );

            ChatMessage updated = messageRepository.findById(
                    oldAttachment.getChatMessageSeq());

            if (updated == null) {
                throw new SQLException("교체된 메시지 조회 실패");
            }

            // DB 커밋 후 기존 파일 정리
            registerCommitCleanup(oldAttachment.getStoredName());

            return updated;

        } catch (Exception e) {
            try {
                fileStorageService.delete(newStoredName);
            } catch (IOException deleteError) {
                e.addSuppressed(deleteError);
            }
            throw e;
        }
    }

    // 4. 작성자 권한 확인
    private ChatAttachment getOwnedAttachment(
            Long attachmentSeq,
            Long memberSeq) throws Exception {

        if (attachmentSeq == null || attachmentSeq <= 0
                || memberSeq == null || memberSeq <= 0) {
            throw new IllegalArgumentException(
                    "첨부파일 또는 회원번호가 올바르지 않습니다.");
        }

        ChatAttachment attachment =
                attachmentRepository.findById(attachmentSeq);

        if (attachment == null) {
            throw new IllegalArgumentException(
                    "첨부파일을 찾을 수 없습니다.");
        }

        ChatMessage message = messageRepository.findById(
                attachment.getChatMessageSeq());

        if (message == null) {
            throw new IllegalArgumentException(
                    "채팅 메시지를 찾을 수 없습니다.");
        }

        if (!memberSeq.equals(message.getSenderSeq())) {
            throw new SecurityException(
                    "본인이 보낸 첨부파일만 변경할 수 있습니다.");
        }

        return attachment;
    }

    // 5. 원본 파일명 정리
    private String getOriginalName(MultipartFile file) {

        String name = file.getOriginalFilename();

        if (name == null || name.trim().isEmpty()) {
            name = "attachment";
        }

        name = name.replace("\\", "/");
        name = name.substring(name.lastIndexOf('/') + 1);

        if (name.length() > 255) {
            name = name.substring(0, 255);
        }

        return name;
    }

    // 6. 트랜잭션 롤백 시 새 파일 정리
    private void registerRollbackCleanup(final String storedName) {

        if (!TransactionSynchronizationManager
                .isSynchronizationActive()) {
            throw new IllegalStateException(
                    "트랜잭션 동기화가 활성화되지 않았습니다.");
        }

        TransactionSynchronizationManager.registerSynchronization(
                new TransactionSynchronization() {

                    @Override
                    public void afterCompletion(int status) {

                        if (status != STATUS_COMMITTED) {
                            deleteFileQuietly(storedName);
                        }
                    }
                }
        );
    }

    // 7. DB 커밋 후 기존 파일 정리
    private void registerCommitCleanup(final String storedName) {

        if (!TransactionSynchronizationManager
                .isSynchronizationActive()) {
            throw new IllegalStateException(
                    "트랜잭션 동기화가 활성화되지 않았습니다.");
        }

        TransactionSynchronizationManager.registerSynchronization(
                new TransactionSynchronization() {

                    @Override
                    public void afterCommit() {
                        deleteFileQuietly(storedName);
                    }
                }
        );
    }

    // 8. 파일 정리 실패 시 로그 출력
    private void deleteFileQuietly(String storedName) {

        try {
            fileStorageService.delete(storedName);
        } catch (IOException e) {
            System.err.println(
                    "첨부파일 정리 실패: " + storedName);
            e.printStackTrace();
        }
    }
}
