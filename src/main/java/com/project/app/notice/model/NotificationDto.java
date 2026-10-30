
package com.project.app.notice.model;

import java.sql.Timestamp;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class NotificationDto {

    private Long notificationId;
    private Long receiverSeq;

    private String notificationType;
    private String title;
    private String message;

    private Long referenceId;
    private String isRead;

    private Timestamp createdAt;
}
