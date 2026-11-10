
package com.project.app.notice.service;

import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;
import java.util.List;

import com.project.app.notice.model.NotificationDto;
import com.project.app.notice.repository.NotificationRepository;

@Service
public class NotificationService {

    private final NotificationRepository repository;
    private final SimpMessagingTemplate messagingTemplate;

    public NotificationService(
            NotificationRepository repository,
            SimpMessagingTemplate messagingTemplate) {

        this.repository = repository;
        this.messagingTemplate = messagingTemplate;
    }

    // 팀원들이 공통으로 호출하는 알림 메서드
    public Long send(
            Long receiverSeq,
            String receiverLoginId,
            String type,
            String title,
            String message,
            Long referenceId) {

        NotificationDto dto = new NotificationDto();

        dto.setReceiverSeq(receiverSeq);
        dto.setNotificationType(type);
        dto.setTitle(title);
        dto.setMessage(message);
        dto.setReferenceId(referenceId);

        // 1. Oracle DB에 알림 저장
        Long notificationId = repository.save(dto);

        // 2. 로그인한 사용자에게 실시간 알림 전송
        messagingTemplate.convertAndSendToUser(
                receiverLoginId,
                "/queue/notifications",
                dto
        );

        return notificationId;
    }

    // 특정 회원의 알림 목록 조회
    public List<NotificationDto> getNotifications(Long receiverSeq) {

        return repository.findByReceiverSeq(receiverSeq);
    }

    // 특정 회원의 알림 읽음 처리
    public boolean markAsRead(
            Long notificationId,
            Long receiverSeq) {

        return repository.markAsRead(notificationId, receiverSeq);
    }

}
