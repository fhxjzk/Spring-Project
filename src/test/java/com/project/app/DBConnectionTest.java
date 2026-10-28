package com.project.app;

import static org.junit.Assert.assertTrue;

import java.sql.Connection;

import javax.sql.DataSource;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

/**
 * DB 연결 확인용 테스트
 *
 * secret.properties를 만든 뒤 이 파일에서 우클릭 > Run As > JUnit Test
 * 초록색 막대가 나오면 DB 설정이 맞는 것이다.
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {
		"file:src/main/webapp/WEB-INF/spring/root-context.xml",
		"file:src/main/webapp/WEB-INF/spring/security-context.xml"
})
public class DBConnectionTest {

	@Autowired
	private DataSource dataSource;

	@Test
	public void DB_연결() throws Exception {

		try (Connection conn = dataSource.getConnection()) {
			assertTrue(conn.isValid(3));
		}
	}

}
