
package com.project.app.chat.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.project.app.chat.model.ChatAttachment;

@Mapper
public interface ChatAttachmentMapper {

    // 1. 첨부파일 번호 생성
    Long nextAttachmentSeq();

    // 2. 첨부파일 정보 저장
    int insert(ChatAttachment attachment);

    // 3. 첨부파일 1건 조회
    ChatAttachment findById(
            @Param("attachmentSeq") Long attachmentSeq
    );

    // 4. 메시지에 연결된 첨부파일 조회
    List<ChatAttachment> findByMessageId(
            @Param("chatMessageSeq") Long chatMessageSeq
    );

    // 5. 첨부파일 정보 삭제
    int deleteById(
            @Param("attachmentSeq") Long attachmentSeq
    );

    // 6. 기존 첨부파일을 새 파일 정보로 교체
    int updateAttachment(
            @Param("attachmentSeq") Long attachmentSeq,
            @Param("originalName") String originalName,
            @Param("storedName") String storedName,
            @Param("contentType") String contentType,
            @Param("fileSize") Long fileSize
    );

}
