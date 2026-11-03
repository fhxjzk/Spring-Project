package com.project.app.expert.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

/**
 * tbl_portfolio_image (포트폴리오 사진 한 장)
 *
 * 컬럼: image_seq, portfolio_seq, file_name, origin_name, slot
 *   - file_name   : 서버에 저장한 이름 (UUID_원래이름)
 *   - origin_name : 사용자가 올린 원래 이름
 *   - slot        : 1 ~ 5, 보여 주는 순서 (1이 대표 사진)
 */
@Getter
@Setter
@ToString
public class PortfolioImageDto {

	// TODO 컬럼을 camelCase 필드로 (PK/FK 는 Long)

}
