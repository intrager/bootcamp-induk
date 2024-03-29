package com.bootcamp.induk.service;

import static org.junit.Assert.assertTrue;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.bootcamp.induk.dao.BoardDao;
import com.bootcamp.induk.dao.ReplyDao;
import com.bootcamp.induk.domain.BoardDto;
import com.bootcamp.induk.domain.ReplyDto;
import com.bootcamp.induk.service.ReplyService;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"file:src/main/webapp/WEB-INF/spring/root-context.xml"})
public class ReplyServiceImplTest {
	@Autowired
	ReplyService replyService;
	@Autowired
	ReplyDao replyDao;
	@Autowired
	BoardDao boardDao;

	@Test
	public void remove() throws Exception {
		boardDao.deleteAll();
	
		BoardDto boardDto = new BoardDto("hello", "hello", "asdf");
		assertTrue(boardDao.insert(boardDto) == 1);
		Integer bno = boardDao.selectAll().get(0).getBno();
		System.out.println("bno = " + bno);
		
		replyDao.deleteAll(bno);
		ReplyDto replyDto = new ReplyDto(bno, 0, "hi", "qwer");
		
		assertTrue(boardDao.select(bno).getReply_cnt() == 0);
		assertTrue(replyService.write(replyDto) == 1);
		assertTrue(boardDao.select(bno).getReply_cnt() == 1);
		
		Integer rno = replyDao.selectAll(bno).get(0).getRno();
		
		// 일부러 예외를 발생시키고 트랜잭션이 취소되는지 확인해야 함
		int rowCnt = replyService.remove(rno, bno, replyDto.getReplier());
		assertTrue(rowCnt == 1);
		assertTrue(boardDao.select(bno).getReply_cnt() == 0);
	}
	
	@Test
	public void write() throws Exception {
		boardDao.deleteAll();
		
		BoardDto boardDto = new BoardDto("hello", "hello", "asdf");
		assertTrue(boardDao.insert(boardDto) == 1);
		Integer bno = boardDao.selectAll().get(0).getBno();
		System.out.println("bno = " + bno);
		
		replyDao.deleteAll(bno);
		ReplyDto replyDto = new ReplyDto(bno, 0, "hi", "qwer");
		
		assertTrue(boardDao.select(bno).getReply_cnt() == 0);
		assertTrue(replyService.write(replyDto) == 1);
		
		Integer rno = replyDao.selectAll(bno).get(0).getRno();
		assertTrue(boardDao.select(bno).getReply_cnt() == 1);
	}
}
