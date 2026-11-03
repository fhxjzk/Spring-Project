package com.project.app.category.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class CategoryDto {
	private Long categorySeq;
	private Long parentSeq;
	private String name;
	private int sortOrder;
	private String enabled;
}
