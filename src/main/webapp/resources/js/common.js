/*
	common.js: 모든 페이지에서 쓰는 공통 스크립트 (asset.jsp에서 불러온다)
*/

//jQuery Ajax 요청에 CSRF 토큰을 자동으로 붙인다.
//이게 없으면 Ajax로 POST, PUT, DELETE를 보낼 때 403 오류가 난다.
$(document).ajaxSend(function (e, xhr) {
	const token = $('meta[name="_csrf"]').attr('content');
	const header = $('meta[name="_csrf_header"]').attr('content');

	if (token && header) {
		xhr.setRequestHeader(header, token);
	}
});
