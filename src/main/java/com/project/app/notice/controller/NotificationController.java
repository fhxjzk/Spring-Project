
package com.project.app.notice.controller;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.project.app.auth.CustomUser;
import com.project.app.notice.model.NotificationDto;
import com.project.app.notice.service.NotificationService;

@RestController
@RequestMapping("/notification")
public class NotificationController {

    private final NotificationService notificationService;

    public NotificationController(
            NotificationService notificationService) {
        this.notificationService = notificationService;
    }

    // 로그인한 회원의 알림 목록 조회
    @GetMapping("/list")
    public ResponseEntity<List<NotificationDto>> list(
            Authentication authentication) {

        CustomUser user = getLoginUser(authentication);

        return ResponseEntity.ok(
            notificationService.getNotifications(
                user.getMemberSeq()
            )
        );
    }

    // 로그인한 회원의 알림 읽음 처리
    @PostMapping("/{notificationId}/read")
    public ResponseEntity<Void> markAsRead(
            @PathVariable Long notificationId,
            Authentication authentication) {

        CustomUser user = getLoginUser(authentication);

        boolean updated = notificationService.markAsRead(
            notificationId,
            user.getMemberSeq()
        );

        if (!updated) {
            return ResponseEntity.notFound().build();
        }

        return ResponseEntity.noContent().build();
    }

    private CustomUser getLoginUser(
            Authentication authentication) {

        if (authentication == null ||
            !(authentication.getPrincipal() instanceof CustomUser)) {

            throw new org.springframework.web.server
                .ResponseStatusException(
                    HttpStatus.UNAUTHORIZED,
                    "로그인이 필요합니다."
                );
        }

        return (CustomUser) authentication.getPrincipal();
    }
}
