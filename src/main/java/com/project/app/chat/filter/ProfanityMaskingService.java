
package com.project.app.chat.filter;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.springframework.stereotype.Service;

@Service
public class ProfanityMaskingService {

    // 테스트용 금칙어 목록
    private static final String[] BAD_WORDS = {
        "시발",
        "씨발",
        "병신",
        "개새끼",
        "꺼져"
    };

    public String mask(String message) {

        if (message == null || message.isEmpty()) {
            return message;
        }

        String result = message;

        for (String word : BAD_WORDS) {

            // 대소문자 구분 없이 해당 단어 검색
            Pattern pattern = Pattern.compile(
                Pattern.quote(word),
                Pattern.CASE_INSENSITIVE
            );

            Matcher matcher = pattern.matcher(result);

            String replacement =
                    "*".repeat(word.length());

            result = matcher.replaceAll(
                Matcher.quoteReplacement(replacement)
            );
        }

        return result;
    }
}
