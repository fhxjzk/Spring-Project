package com.project.app.trade.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.project.app.trade.model.TradeDto;
import com.project.app.trade.model.TradeFileDto;
import com.project.app.trade.model.TradeNoticeDto;
import com.project.app.trade.model.TradeQuoteDto;

//SQL은 resources/mappers/trade/TradeMapper.xml 에 있다 (메서드 이름 = XML의 id)
@Mapper
public interface TradeMapper {

	//결제할 때 쓰는 ③ 견적·요청서
	TradeQuoteDto getQuote(Long quoteSeq);

	int selectRequest(Long requestSeq);

	int selectQuote(@Param("requestSeq") Long requestSeq, @Param("quoteSeq") Long quoteSeq);

	int cancelRequest(Long requestSeq);

	//거래
	int add(TradeDto dto);

	TradeDto get(Long tradeSeq);

	List<TradeDto> listByCustomer(Long customerSeq);

	List<TradeDto> listByExpert(Long expertSeq);

	//상태 변경: 바뀐 행 수를 돌려준다 (1 성공, 0 이미 다른 상태)
	int start(Long tradeSeq);

	int complete(Long tradeSeq);

	int confirm(Long tradeSeq);

	int cancel(Long tradeSeq);

	List<Long> listAutoConfirmTargets(int days);

	int countReview(Long tradeSeq);

	int countConfirmedByExpert(Long expertSeq);

	int countOngoing(Long memberSeq);

	//알림 받을 회원 (TradeNoticeService)
	TradeNoticeDto noticeMember(Long memberSeq);
	List<TradeNoticeDto> noticeUnselectedExperts(@Param("requestSeq") Long requestSeq, @Param("quoteSeq") Long quoteSeq);

	//결과물 파일
	int addFile(TradeFileDto dto);

	List<TradeFileDto> listFiles(Long tradeSeq);

	TradeFileDto getFile(Long tradeFileSeq);

}
