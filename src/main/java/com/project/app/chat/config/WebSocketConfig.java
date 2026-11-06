
package com.project.app.chat.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;
import org.springframework.web.socket.config.annotation.WebSocketMessageBrokerConfigurer;
import org.springframework.messaging.simp.config.ChannelRegistration;
import com.project.app.chat.mapper.ChatRoomMapper;
@Configuration
@EnableWebSocketMessageBroker
public class WebSocketConfig implements WebSocketMessageBrokerConfigurer {
    private final ChatRoomMapper chatRoomMapper;

    public WebSocketConfig(ChatRoomMapper chatRoomMapper) {
        this.chatRoomMapper = chatRoomMapper;
    }
    @Override
    public void registerStompEndpoints(StompEndpointRegistry registry) {
        registry.addEndpoint("/ws");
    }

    @Override
    public void configureMessageBroker(MessageBrokerRegistry registry) {

        // 기존 채팅방 메시지 전송
        registry.enableSimpleBroker("/topic", "/queue");

        // 클라이언트에서 서버로 메시지를 보내는 경로
        registry.setApplicationDestinationPrefixes("/app");

        // 로그인 사용자별 알림 전송 경로
        registry.setUserDestinationPrefix("/user");
    }
    @Override
    public void configureClientInboundChannel(ChannelRegistration registration) {
        registration.interceptors(
            new ChatSubscriptionInterceptor(chatRoomMapper)
        );
    }
}
