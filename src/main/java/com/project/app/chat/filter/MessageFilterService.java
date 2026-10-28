
package com.project.app.chat.filter;

import org.springframework.stereotype.Service;

@Service
public class MessageFilterService {

    private final PhoneMaskingService phoneMaskingService;
    private final AccountMaskingService accountMaskingService;
    private final ProfanityMaskingService profanityMaskingService;

    public MessageFilterService(
            PhoneMaskingService phoneMaskingService,
            AccountMaskingService accountMaskingService,
            ProfanityMaskingService profanityMaskingService) {

        this.phoneMaskingService = phoneMaskingService;
        this.accountMaskingService = accountMaskingService;
        this.profanityMaskingService = profanityMaskingService;
    }

    public String filter(String message) {

        if (message == null || message.isEmpty()) {
            return message;
        }

        // 1. 전화번호 마스킹
        String result = phoneMaskingService.mask(message);

        // 2. 계좌번호 마스킹
        result = accountMaskingService.mask(result);

        // 3. 욕설 마스킹
        result = profanityMaskingService.mask(result);

        return result;
    }
}
