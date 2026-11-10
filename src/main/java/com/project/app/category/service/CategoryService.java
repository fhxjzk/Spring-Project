package com.project.app.category.service;

import java.nio.charset.StandardCharsets;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.project.app.category.model.CategoryDto;
import com.project.app.category.repository.CategoryDao;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class CategoryService {
	private final CategoryDao categoryDao;

	//tbl_category.name VARCHAR2(50) 은 바이트 기준. 한글 한 글자 = 3바이트라 한글 약 16자
	private static final int NAME_MAX_BYTES = 50;

	//사용중인(enabled가 'Y'인) 대분류 카테고리만 가져오는 메서드
	public List<CategoryDto> getTopCategory() {
		List<CategoryDto> clist = categoryDao.getTopCategory();
		return clist;
	}

	//사용중인 소분류 전체. 대분류 순서(parent_seq) → 소분류 순서(sort_order)로 정렬되어 있다
	public List<CategoryDto> getSubCategoryList() {
		return categoryDao.getSubCategoryList();
	}

	//================ 관리자 카테고리 관리 (E-03) ================
	//대분류는 고정(메인 카드 아이콘이 대분류마다 있어서)이고, 소분류만 추가 · 순서 변경 · 사용 안 함을 한다

	//대분류 전체 (사용 안 함 포함)
	public List<CategoryDto> getAdminTopCategoryList() {
		return categoryDao.getAdminTopCategoryList();
	}

	//대분류 하나. 없거나 소분류 번호면 null
	public CategoryDto getAdminTopCategory(Long categorySeq) {

		if (categorySeq == null) {
			return null;
		}

		CategoryDto dto = categoryDao.getCategory(categorySeq);

		return (dto != null && dto.getParentSeq() == null) ? dto : null;
	}

	//한 대분류의 소분류 전부 (사용 안 함 포함, 서비스 수 · 요청서 수 포함)
	public List<CategoryDto> getAdminSubCategoryList(Long parentSeq) {
		return categoryDao.getAdminSubCategoryList(parentSeq);
	}

	/**
	 * 소분류 추가. 그 대분류의 맨 뒤 순서로 들어간다
	 * @return 1 성공, -1 이름이 비었거나 너무 김, -2 같은 대분류에 같은 이름이 있음, -3 없는 대분류
	 */
	public int addSubCategory(Long parentSeq, String name) {

		if (getAdminTopCategory(parentSeq) == null) {
			return -3;
		}

		name = (name == null) ? "" : name.trim();

		if (name.isEmpty() || name.getBytes(StandardCharsets.UTF_8).length > NAME_MAX_BYTES) {
			return -1;
		}

		//사용 안 함인 소분류와 이름이 같아도 막는다. 그 소분류를 다시 사용하면 된다
		if (categoryDao.countSameName(parentSeq, name) > 0) {
			return -2;
		}

		CategoryDto dto = new CategoryDto();
		dto.setParentSeq(parentSeq);
		dto.setName(name);

		return categoryDao.addSubCategory(dto);
	}

	/**
	 * 소분류 순서를 한 칸 올리거나 내린다.
	 * 더미처럼 sort_order 가 겹치거나 비어 있어도 되도록, 바꾼 뒤 그 대분류의 소분류 전부를 1, 2, 3… 으로 다시 매긴다
	 * @param up true 면 위로, false 면 아래로
	 * @return 바꾼 소분류의 대분류 번호 (화면을 다시 보여 줄 때 쓴다). 없는 소분류면 null
	 */
	@Transactional
	public Long move(Long categorySeq, boolean up) {

		CategoryDto target = (categorySeq == null) ? null : categoryDao.getCategory(categorySeq);

		if (target == null || target.getParentSeq() == null) {
			return null;
		}

		List<CategoryDto> list = categoryDao.getAdminSubCategoryList(target.getParentSeq());

		int index = -1;
		for (int i = 0; i < list.size(); i++) {
			if (list.get(i).getCategorySeq().equals(categorySeq)) {
				index = i;
				break;
			}
		}

		int other = up ? index - 1 : index + 1;

		//맨 위에서 올리기, 맨 아래에서 내리기는 그대로 둔다
		if (index >= 0 && other >= 0 && other < list.size()) {
			CategoryDto tmp = list.get(index);
			list.set(index, list.get(other));
			list.set(other, tmp);
		}

		for (int i = 0; i < list.size(); i++) {
			if (list.get(i).getSortOrder() != i + 1) {
				categoryDao.updateSortOrder(list.get(i).getCategorySeq(), i + 1);
			}
		}

		return target.getParentSeq();
	}

	/**
	 * 소분류 사용 / 사용 안 함.
	 * 사용 안 함이면 새 서비스 · 요청서 · 검색에서 고를 수 없고, 이미 등록된 서비스와 요청서는 그대로 남는다
	 * @return 1 성공, 0 실패 (없는 소분류, 대분류, 잘못된 값)
	 */
	public int updateEnabled(Long categorySeq, String enabled) {

		if (categorySeq == null || !("Y".equals(enabled) || "N".equals(enabled))) {
			return 0;
		}

		return categoryDao.updateEnabled(categorySeq, enabled);
	}

}
