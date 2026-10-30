
package com.project.app.chat.filter;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.springframework.stereotype.Service;

@Service
public class AccountMaskingService {

    // "계좌", "계좌번호" 뒤에 오는 숫자 패턴
    private static final Pattern ACCOUNT_PATTERN =
            Pattern.compile(
                "(계좌번호|계좌)\\s*[:：]?\\s*" +
                "((?=\\d[\\d-]{8,19}(?!\\d))\\d+(?:-\\d+){0,5})"
            );

    public String mask(String message) {

        if (message == null || message.isEmpty()) {
            return message;
        }

        Matcher matcher = ACCOUNT_PATTERN.matcher(message);
        StringBuffer result = new StringBuffer();

        while (matcher.find()) {

            String account = matcher.group(2);

            // 숫자는 *로 바꾸고 하이픈은 유지
            String masked = account.replaceAll("\\d", "*");

            String replacement =
                    matcher.group(1) + " " + masked;

            matcher.appendReplacement(
                    result,
                    Matcher.quoteReplacement(replacement)
            );
        }

        matcher.appendTail(result);

        return result.toString();
    }
}
