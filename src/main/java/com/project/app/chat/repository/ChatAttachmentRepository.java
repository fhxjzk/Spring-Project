
package com.project.app.chat.repository;

import java.sql.SQLException;
import java.util.List;

import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.project.app.chat.mapper.ChatAttachmentMapper;
import com.project.app.chat.model.ChatAttachment;

@Repository
public class ChatAttachmentRepository {

    private final ChatAttachmentMapper chatAttachmentMapper;

    public ChatAttachmentRepository(
            ChatAttachmentMapper chatAttachmentMapper) {
        this.chatAttachmentMapper = chatAttachmentMapper;
    }

    // 1. 첨부파일 정보 저장
    @Transactional(rollbackFor = Exception.class)
    public ChatAttachment save(
            Long chatMessageSeq,
            String originalName,
            String storedName,
            String contentType,
            Long fileSize) throws SQLException {

        if (chatMessageSeq == null || chatMessageSeq <= 0) {
            throw new SQLException("메시지 번호가 올바르지 않습니다.");
        }

        if (originalName == null || originalName.trim().isEmpty()
                || storedName == null || storedName.trim().isEmpty()
                || contentType == null || contentType.trim().isEmpty()
                || fileSize == null || fileSize <= 0) {
            throw new SQLException("첨부파일 정보가 올바르지 않습니다.");
        }

        Long attachmentSeq =
                chatAttachmentMapper.nextAttachmentSeq();

        if (attachmentSeq == null) {
            throw new SQLException("첨부파일 번호 생성 실패");
        }

        ChatAttachment attachment = new ChatAttachment();
        attachment.setAttachmentSeq(attachmentSeq);
        attachment.setChatMessageSeq(chatMessageSeq);
        attachment.setOriginalName(originalName);
        attachment.setStoredName(storedName);
        attachment.setContentType(contentType);
        attachment.setFileSize(fileSize);

        int result = chatAttachmentMapper.insert(attachment);

        if (result != 1) {
            throw new SQLException("첨부파일 정보 저장 실패");
        }

        ChatAttachment savedAttachment =
                chatAttachmentMapper.findById(attachmentSeq);

        if (savedAttachment == null) {
            throw new SQLException("첨부파일 정보 조회 실패");
        }

        return savedAttachment;
    }

    // 2. 첨부파일 번호로 조회
    public ChatAttachment findById(Long attachmentSeq) {
        return chatAttachmentMapper.findById(attachmentSeq);
    }

    // 3. 메시지에 연결된 첨부파일 조회
    public List<ChatAttachment> findByMessageId(
            Long chatMessageSeq) {
        return chatAttachmentMapper.findByMessageId(chatMessageSeq);
    }

    // 4. 첨부파일 DB 정보 삭제
    public void deleteById(Long attachmentSeq)
            throws SQLException {

        if (attachmentSeq == null || attachmentSeq <= 0) {
            throw new SQLException("첨부파일 번호가 올바르지 않습니다.");
        }

        int result =
                chatAttachmentMapper.deleteById(attachmentSeq);

        if (result != 1) {
            throw new SQLException("첨부파일 삭제 실패");
        }
    }

    // 5. 첨부파일 DB 정보 교체
    public ChatAttachment updateAttachment(
            Long attachmentSeq,
            String originalName,
            String storedName,
            String contentType,
            Long fileSize) throws SQLException {

        if (attachmentSeq == null || attachmentSeq <= 0) {
            throw new SQLException("첨부파일 번호가 올바르지 않습니다.");
        }

        if (originalName == null || originalName.trim().isEmpty()
                || storedName == null || storedName.trim().isEmpty()
                || contentType == null || contentType.trim().isEmpty()
                || fileSize == null || fileSize <= 0) {
            throw new SQLException("새 첨부파일 정보가 올바르지 않습니다.");
        }

        int result = chatAttachmentMapper.updateAttachment(
                attachmentSeq,
                originalName,
                storedName,
                contentType,
                fileSize
        );

        if (result != 1) {
            throw new SQLException("첨부파일 교체 실패");
        }

        ChatAttachment updatedAttachment =
                chatAttachmentMapper.findById(attachmentSeq);

        if (updatedAttachment == null) {
            throw new SQLException("교체된 첨부파일 조회 실패");
        }

        return updatedAttachment;
    }
}
