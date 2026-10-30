package com.project.app.auth;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.security.web.savedrequest.HttpSessionRequestCache;
import org.springframework.security.web.savedrequest.SavedRequest;

import com.project.app.member.mapper.MemberMapper;

public class CustomLoginSuccessHandler implements AuthenticationSuccessHandler {

	@Autowired
	private MemberMapper mapper;

	@Override
	public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication) throws IOException, ServletException {

		//마지막 로그인 일시 갱신
		mapper.updateLastLogin(((CustomUser) authentication.getPrincipal()).getMemberSeq());

		//로그인 전에 들어가려던 페이지가 있으면 그 페이지로, 없으면 메인으로
		SavedRequest savedRequest = new HttpSessionRequestCache().getRequest(request, response);

		if (savedRequest != null) {
			response.sendRedirect(savedRequest.getRedirectUrl());
		} else {
			response.sendRedirect(request.getContextPath() + "/index.do");
		}
	}

}