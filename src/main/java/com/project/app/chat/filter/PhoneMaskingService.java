
package com.project.app.chat.filter;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.springframework.stereotype.Service;

@Service
public class PhoneMaskingService {

    private static final Pattern PHONE_PATTERN =
            Pattern.compile(
                "(?<!\\d)01[016789][\\s.-]?\\d{3,4}[\\s.-]?\\d{4}(?!\\d)"
            );

    public String mask(String message) {

        if (message == null || message.isEmpty()) {
            return message;
        }

        Matcher matcher = PHONE_PATTERN.matcher(message);
        StringBuffer result = new StringBuffer();

        while (matcher.find()) {

            String masked = matcher.group()
                    .replaceAll("\\d", "*");

            matcher.appendReplacement(
                    result,
                    Matcher.quoteReplacement(masked)
            );
        }

        matcher.appendTail(result);

        return result.toString();
    }
}

