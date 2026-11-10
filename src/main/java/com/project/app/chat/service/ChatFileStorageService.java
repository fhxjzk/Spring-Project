
package com.project.app.chat.service;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.Locale;
import java.util.UUID;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

@Service
public class ChatFileStorageService {

    private static final Path UPLOAD_DIR =
            Paths.get("C:\\chat-uploads");

    private static final long MAX_FILE_SIZE =
            50L * 1024 * 1024;

    public String save(MultipartFile file) throws IOException {

        if (file == null || file.isEmpty()) {
            throw new IOException("파일이 비어 있습니다.");
        }

        if (file.getSize() > MAX_FILE_SIZE) {
            throw new IOException("파일은 50MB 이하여야 합니다.");
        }

        String originalName = file.getOriginalFilename();

        if (originalName == null) {
            throw new IOException("파일명이 없습니다.");
        }

        // 경로를 제외한 파일명만 사용
        originalName = originalName.replace("\\", "/");
        originalName = originalName.substring(
                originalName.lastIndexOf('/') + 1);

        String lowerName =
                originalName.toLowerCase(Locale.ROOT);

        String contentType = file.getContentType();
        String extension;

        if ((lowerName.endsWith(".jpg")
                || lowerName.endsWith(".jpeg"))
                && "image/jpeg".equals(contentType)) {
            extension = ".jpg";

        } else if (lowerName.endsWith(".png")
                && "image/png".equals(contentType)) {
            extension = ".png";

        } else if (lowerName.endsWith(".gif")
                && "image/gif".equals(contentType)) {
            extension = ".gif";

        } else if (lowerName.endsWith(".mp4")
                && "video/mp4".equals(contentType)) {
            extension = ".mp4";

        } else {
            throw new IOException("허용되지 않는 파일 형식입니다.");
        }

        // 실제 파일 헤더 확인
        try (InputStream input = file.getInputStream()) {

            byte[] header = new byte[12];
            int length = 0;

            while (length < header.length) {
                int count = input.read(
                        header,
                        length,
                        header.length - length);

                if (count == -1) {
                    break;
                }

                length += count;
            }

            if (!isValidHeader(header, length, extension)) {
                throw new IOException(
                        "실제 파일 형식이 올바르지 않습니다.");
            }
        }

        Files.createDirectories(UPLOAD_DIR);

        String storedName =
                UUID.randomUUID().toString() + extension;

        Path target = UPLOAD_DIR.resolve(storedName);

        try (InputStream input = file.getInputStream()) {
            Files.copy(input,target);
        }

        return storedName;
    }

    private boolean isValidHeader(
            byte[] h, int length, String extension) {

        if (".jpg".equals(extension)) {
            return length >= 3
                    && (h[0] & 0xFF) == 0xFF
                    && (h[1] & 0xFF) == 0xD8
                    && (h[2] & 0xFF) == 0xFF;
        }

        if (".png".equals(extension)) {
            return length >= 8
                    && (h[0] & 0xFF) == 0x89
                    && h[1] == 0x50
                    && h[2] == 0x4E
                    && h[3] == 0x47
                    && h[4] == 0x0D
                    && h[5] == 0x0A
                    && h[6] == 0x1A
                    && h[7] == 0x0A;
        }

        if (".gif".equals(extension)) {
            return length >= 6
                    && h[0] == 'G'
                    && h[1] == 'I'
                    && h[2] == 'F'
                    && h[3] == '8'
                    && (h[4] == '7' || h[4] == '9')
                    && h[5] == 'a';
        }

        if (".mp4".equals(extension)) {
            return length >= 12
                    && h[4] == 'f'
                    && h[5] == 't'
                    && h[6] == 'y'
                    && h[7] == 'p';
        }

        return false;
    }

    public Path getFilePath(String storedName)
            throws IOException {

        if (storedName == null
                || !storedName.matches(
                        "[0-9a-fA-F-]{36}\\.(jpg|png|gif|mp4)")) {
            throw new IOException("잘못된 파일 이름입니다.");
        }

        Path directory =
                UPLOAD_DIR.toAbsolutePath().normalize();

        Path target =
                directory.resolve(storedName).normalize();

        if (!target.startsWith(directory)) {
            throw new IOException("잘못된 파일 경로입니다.");
        }

        return target;
    }

    public void delete(String storedName)
            throws IOException {

        Files.deleteIfExists(getFilePath(storedName));
    }
}
