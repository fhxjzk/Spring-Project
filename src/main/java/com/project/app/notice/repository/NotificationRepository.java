
package com.project.app.notice.repository;

import java.util.List;

import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.project.app.notice.mapper.NoticeMapper;
import com.project.app.notice.model.NotificationDto;

@Repository
public class NotificationRepository {

    private final NoticeMapper noticeMapper;

    public NotificationRepository(NoticeMapper noticeMapper) {
        this.noticeMapper = noticeMapper;
    }

    // 1. 알림 저장
    @Transactional(rollbackFor = Exception.class)
    public Long save(NotificationDto dto) {

        Long notificationId = noticeMapper.nextNoticeSeq();

        if (notificationId == null) {
            throw new IllegalStateException("알림 번호 생성 실패");
        }

        dto.setNotificationId(notificationId);

        int result = noticeMapper.insert(dto);

        if (result != 1) {
            throw new IllegalStateException("알림 저장 실패");
        }

        return notificationId;
    }

    // 2. 특정 회원의 알림 목록 조회
    public List<NotificationDto> findByReceiverSeq(Long receiverSeq) {
        return noticeMapper.findByReceiverSeq(receiverSeq);
    }

    // 3. 본인 알림 읽음 처리
    public boolean markAsRead(Long notificationId, Long receiverSeq) {
        return noticeMapper.markAsRead(notificationId, receiverSeq) > 0;
    }
}
