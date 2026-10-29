
package com.project.app.notice.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.project.app.notice.model.NotificationDto;

@Mapper
public interface NoticeMapper {

    // 새 알림 번호 생성
    Long nextNoticeSeq();

    // 알림 저장
    int insert(NotificationDto dto);

    // 회원별 알림 목록 조회
    List<NotificationDto> findByReceiverSeq(
            @Param("receiverSeq") Long receiverSeq);

    // 본인 알림 읽음 처리
    int markAsRead(
            @Param("notificationId") Long notificationId,
            @Param("receiverSeq") Long receiverSeq);
}
