package com.bootcamp.induk.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.bootcamp.induk.domain.ReplyDto;
import com.bootcamp.induk.service.interfaces.ReplyService;

@Controller
@RequiredArgsConstructor
public class ReplyController {

	private final ReplyService replyService;

	// 댓글을 등록하는 메서드
	@PostMapping("/replies")	// /replies?bno=871	POST
	@ResponseBody
	public ResponseEntity<String> write(@RequestBody ReplyDto dto, Integer bno, HttpSession session, Model m) {
//		String commenter = (String) session.getAttribute("id");
		String replier = "asdf";
		dto.setReplier(replier);
		dto.setBno(bno);

		List<ReplyDto> list = null;
		try {
			if(replyService.writeReply(dto) != 1)
				throw new Exception("Write failed");
			list = replyService.readReplyList(bno);
			m.addAttribute("list", list);

			return new ResponseEntity<>("Write_success", HttpStatus.OK);
		} catch(Exception e) {
			e.printStackTrace();
			return new ResponseEntity<String>("Write_err", HttpStatus.BAD_REQUEST);
		}
	}

	// 지정된 게시물의 모든 댓글을 가져오는 메서드
	@GetMapping("/replies")	// /replies?bno=874	GET
	public ResponseEntity<List<ReplyDto>> list(Integer bno) {
		List<ReplyDto> list = null;
		try {
			list = replyService.readReplyList(bno);
			return new ResponseEntity<List<ReplyDto>>(list, HttpStatus.OK);	// 200
		} catch (Exception e) {
			e.printStackTrace();
			return new ResponseEntity<List<ReplyDto>>(HttpStatus.BAD_REQUEST);	// 400
		}
	}

	// 댓글을 수정하는 메서드
	@PatchMapping("/replies/{rno}")	// /replies/70 PATCH
	public ResponseEntity<String> modify(@PathVariable Integer rno, @RequestBody ReplyDto dto) {
		String replier = "asdf";

		dto.setReplier(replier);
		dto.setRno(rno);
		System.out.println("dto = " + dto);

		try {
			if(replyService.modifyReply(dto) != 1)
				throw new Exception("Modify failed");

			return new ResponseEntity<>("Modify_success", HttpStatus.OK);
		} catch(Exception e) {
			e.printStackTrace();
			return new ResponseEntity<String>("Modify_err", HttpStatus.BAD_REQUEST);
		}
	}

	// 지정된 댓글을 삭제하는 메서드
	@DeleteMapping("/replies/{rno}")	// DELETE /replies/1?bno=871 <-- 삭제할 댓글 번호
	public ResponseEntity<String> remove(@PathVariable Integer rno, Integer bno, HttpSession session) {
//		String commenter = (String) session.getAttribute("id");
		String replier = "asdf";
		try {
			int rowCnt = replyService.removeReply(rno, bno, replier);
		
			if(rowCnt != 1)
				throw new Exception("Delete Failed");
			
			return new ResponseEntity<>("Delete_success", HttpStatus.OK);
		} catch (Exception e) {
			e.printStackTrace();
			return new ResponseEntity<>("Delete_err", HttpStatus.BAD_REQUEST);
		}
	}

}
