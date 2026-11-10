
package com.project.app.chat.filter;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.springframework.stereotype.Service;

@Service
public class AccountMaskingService {

    // '계좌', '계좌번호' 뒤에 오는 숫자
    private static final Pattern LABELED_ACCOUNT_PATTERN =
            Pattern.compile(
                "(계좌번호|계좌)\\s*[:：]?\\s*" +
                "((?<!\\d)\\d+(?:-\\d+){0,5}(?!\\d))"
            );

    // 계좌라는 단어가 없는 하이픈 구분 숫자
    private static final Pattern ACCOUNT_PATTERN =
            Pattern.compile(
                "(?<![\\d-])\\d{2,6}(?:-\\d{2,6}){1,4}(?![\\d-])"
            );

    public String mask(String message) {

        if (message == null || message.isEmpty()) {
            return message;
        }

        // 1. '계좌' 또는 '계좌번호'가 있는 경우
        Matcher labeledMatcher =
                LABELED_ACCOUNT_PATTERN.matcher(message);

        StringBuffer labeledResult = new StringBuffer();

        while (labeledMatcher.find()) {

            String account = labeledMatcher.group(2);

            if (countDigits(account) < 9 ||
                    countDigits(account) > 19) {
                labeledMatcher.appendReplacement(
                    labeledResult,
                    Matcher.quoteReplacement(
                        labeledMatcher.group()
                    )
                );
                continue;
            }

            String masked = account.replaceAll("\\d", "*");

            String replacement =
                    labeledMatcher.group(1) + " " + masked;

            labeledMatcher.appendReplacement(
                labeledResult,
                Matcher.quoteReplacement(replacement)
            );
        }

        labeledMatcher.appendTail(labeledResult);

        // 2. 계좌라는 단어가 없는 숫자도 검사
        Matcher matcher =
                ACCOUNT_PATTERN.matcher(labeledResult.toString());

        StringBuffer result = new StringBuffer();

        while (matcher.find()) {

            String account = matcher.group();

            int digits = countDigits(account);

            // 10~14자리만 계좌번호 후보로 처리
            if (digits < 10 || digits > 14 ||
                    account.startsWith("010-")) {

                matcher.appendReplacement(
                    result,
                    Matcher.quoteReplacement(account)
                );
                continue;
            }

            String masked = account.replaceAll("\\d", "*");

            matcher.appendReplacement(
                result,
                Matcher.quoteReplacement(masked)
            );
        }

        matcher.appendTail(result);

        return result.toString();
    }

    private int countDigits(String value) {

        int count = 0;

        for (int i = 0; i < value.length(); i++) {
            if (Character.isDigit(value.charAt(i))) {
                count++;
            }
        }

        return count;
    }
}
