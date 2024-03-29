<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ page session="true"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
	<script src="https://code.jquery.com/jquery-1.11.3.js"></script>
	<title>Reply</title>
	<style>
	* {
		border : 0;
		padding : 0;
	}

	ul {
		border:  1px solid rgb(235,236,239);
		border-bottom : 0;
	}

	li {
		background-color: #f9f9fa;
		list-style-type: none;
		border-bottom : 1px solid rgb(235,236,239);
		padding : 18px 18px 0 18px;
	}

	#replyForm {
		width : 50%;
		margin : auto;
	}

	.reply-content {
		overflow-wrap: break-word;
	}

	.reply-bottom {
		font-size:9pt;
		color : rgb(97,97,97);
		padding: 8px 0 8px 0;
	}

	.reply-bottom > a {
		color : rgb(97,97,97);
		text-decoration: none;
		margin : 0 6px 0 0;
	}

	.reply-area {
		padding : 0 0 0 46px;
	}

	.replier {
		font-size:12pt;
		font-weight:bold;
	}

	.replier-writebox {
		padding : 15px 20px 20px 20px;
	}

	.reply-img {
		font-size:36px;
		position: absolute;
	}

	.reply-item {
		position:relative;
	}

	.up_date {
		margin : 0 8px 0 0;
	}

	#reply-writebox {
		background-color: white;
		border : 1px solid #e5e5e5;
		border-radius: 5px;
	}

	textarea {
		display: block;
		width: 100%;
		min-height: 17px;
		padding: 0 20px;
		border: 0;
		outline: 0;
		font-size: 13px;
		resize: none;
		box-sizing: border-box;
		background: transparent;
		overflow-wrap: break-word;
		overflow-x: hidden;
		overflow-y: auto;
	}

	#reply-writebox-bottom {
		padding : 3px 10px 10px 10px;
		min-height : 35px;
	}

	.btn {
		font-size:10pt;
		color : black;
		background-color: #eff0f2;
		text-decoration: none;
		padding : 9px 10px 9px 10px;
		border-radius: 5px;
		float : right;
	}

	#btn-write-reply, #btn-write-nestedReply { 
		color : #009f47;
		background-color: #e0f8eb;
	}

	#btn-cancel-nestedReply { 
		background-color: #eff0f2;
		margin-right : 10px;
	}

	#btn-write-modify { 
		color : #009f47;
		background-color: #e0f8eb;
	}

	#btn-cancel-modify { 
		margin-right : 10px;
	}

	#nestedReply-writebox {
		display : none;
		background-color: white;
		border : 1px solid #e5e5e5;
		border-radius: 5px;
		margin : 10px;
	}

	#nestedReply-writebox-bottom {
		padding : 3px 10px 10px 10px;
		min-height : 35px;
	}

	#modify-writebox {
		background-color: white;
		border : 1px solid #e5e5e5;
		border-radius: 5px;
		margin : 10px;
	}

	#modify-writebox-bottom {
		padding : 3px 10px 10px 10px;
		min-height : 35px;
	}

	/* The Modal (background) */
	.modal {
		display: none; /* Hidden by default */
		position: fixed; /* Stay in place */
		z-index: 1; /* Sit on top */
		padding-top: 100px; /* Location of the box */
		left: 0;
		top: 0;
		width: 100%; /* Full width */
		height: 100%; /* Full height */
		overflow: auto; /* Enable scroll if needed */
		background-color: rgb(0,0,0); /* Fallback color */
		background-color: rgba(0,0,0,0.4); /* Black w/ opacity */
	}

	/* Modal Content */
	.modal-content {
		background-color: #fefefe;
		margin: auto;
		padding: 20px;
		border: 1px solid #888;
		width: 50%;
	}

	/* The Close Button */
	.close {
		color: #aaaaaa;
		float: right;
		font-size: 28px;
		font-weight: bold;
	}

	.close:hover,
	.close:focus {
		color: #000;
		text-decoration: none;
		cursor: pointer;
	}

	.paging {
		color: black;
		width: 100%;
		text-align: center;
	}

	.page {
		color: black;
		text-decoration: none;
		padding: 6px;
		margin-right: 10px;
	}

	.paging-active {
		background-color: rgb(216, 216, 216);
		border-radius: 5px;
		color: rgb(24, 24, 24);
	}

	.paging-container {
		width:100%;
		height: 70px;
		margin-top: 50px;
		margin : auto;
	}
	</style>
</head>
<body>
	<div id="replyForm">
		<div id="replyList"></div>
		<div class="paging-container">
			<div class="paging">
				<c:if test="${totalCnt==null || totalCnt==0}">
		        	<div> 댓글이 없습니다. </div>
		        </c:if>
		        <c:if test="${totalCnt!=null && totalCnt!=0}">
		          <c:if test="${ph.showPrev}">
		            <a class="page" href="<c:url value="/reply${ph.sc.getReplyString(ph.beginPage-1)}"/>">&lt;</a>
		          </c:if>
		          <c:forEach var="i" begin="${ph.beginPage}" end="${ph.endPage}">
		            <a class="page ${i==ph.sc.page? 'paging-active' : ''}" href="<c:url value="/${ph.sc.getReplyString(i)}"/>">${i}</a>
		          </c:forEach>
		          <c:if test="${ph.showNext}">
		            <a class="page" href="<c:url value="/reply${ph.sc.getReplyString(ph.endPage+1)}"/>">&gt;</a>
		          </c:if>
		        </c:if>
			</div>
		</div>
		<!-- 댓글 -->
		<div id="reply-writebox">
			<div class="replier replier-writebox">${id}</div>
			<div class="reply-writebox-content">
				<textarea name="reply" id="reply" cols="30" rows="5" placeholder="댓글을 남겨보세요"></textarea>
			</div>
			<div id="reply-writebox-bottom">
				<div class="register-box">
					<a href="replies" class="btn" id="btn-write-reply">등록</a>
				</div>
			</div>
		</div>
	</div>
	<div id="nestedReply-writebox">
		<div class="replier replier-writebox">${id}</div>
		<div class="nestedReply-writebox-content">
			<textarea name="reply" id="nestedReply" cols="30" rows="3" placeholder="답글을 남겨보세요"></textarea>
		</div>
		<div id="nestedReply-writebox-bottom">
			<div class="register-box">
				<a href="#" class="btn" id="btn-write-nestedReply">등록</a>
				<a href="#" class="btn" id="btn-cancel-nestedReply">취소</a>
			</div>
		</div>
	</div>
    <div id="modalWin" class="modal">
        <!-- Modal content -->
        <div class="modal-content">
            <span class="close">&times;</span>
            <p>
            <h2> | 댓글 수정</h2>
            <div id="modify-writebox">
                <div class="replier replier-writebox">${id}</div>
                <div class="modify-writebox-content">
                    <textarea name="reply" id="modReply" cols="30" rows="5" placeholder="댓글을 남겨보세요"></textarea>
                </div>
                <div id="modify-writebox-bottom">
                    <div class="register-box">
                        <a href="#" class="btn" id="btn-write-modify">등록</a>
                    </div>
                </div>
            </div>
            </p>
        </div>
    </div>
	<script>

	let id = 'asdf';
	let bno = 2087;

	let addZero = function(value = 1){
		return value > 9 ? value : "0" + value;
	}

	let dateToString = function(ms = 0) {
		let date = new Date(ms);

		let yyyy = date.getFullYear();
		let mm = addZero(date.getMonth() + 1);
		let dd = addZero(date.getDate());

		let HH = addZero(date.getHours());
		let MM = addZero(date.getMinutes());
		let ss = addZero(date.getSeconds());          

		return yyyy+"."+mm+"."+dd+ " " + HH + ":" + MM + ":" + ss;            
	}

	let showList = function(bno) {
		$.ajax({
			type: 'GET',	// 요청 메서드
			url: '/induk/replies?bno=' + bno,	// 요청 URI
			success: function(result) {
				$("#replyList").html(toHTML(result)); // 서버로부터 응답이 도착하면 호출될 함수
			},
			error: function() { alert("error") } // 에러가 발생했을 때 호출될 함수
		});	// $.ajax()
	}

	let toHTML = function(replies) {
		let tmp = "<ul>";
		
		replies.forEach(function(reply) {

			tmp += '<li class="reply-item" data-rno=' + reply.rno
			tmp += ' data-bno=' + reply.bno + '>'
			if(reply.rno != reply.prno)
				tmp += 'ㄴ'
			tmp += ' <span class="reply-img"><i class="fa fa-user-circle" aria-hidden="true"></i></span>' 
			tmp += ' <div class="reply-area">'
			tmp += ' <div class="replier">' + reply.replier + '</div>'
			tmp += ' <div class="reply-content">' + reply.reply + '</div>'
			tmp += ' <div class="reply-bottom">'
			tmp += ' 	<span class="up_date">' + reply.up_date + '</span>'
			tmp += '	<a href="#" class="btn-write" data-rno=' + reply.rno 
					+ ' data-bno=' + reply.bno + ' data-prno=' + reply.prno + '>답글쓰기</a>'  
			tmp += '	<a href="#" class="btn-modify" data-rno=' + reply.rno 
					+ ' data-bno=' + reply.bno + ' data-prno=' + reply.prno + '>수정</a>' 
			tmp += '	<a href="#" class="btn-delete" data-rno=' + reply.rno 
					+ ' data-bno=' + reply.bno + ' data-prno=' + reply.prno + '>삭제</a>'
			tmp += '</div>'
			tmp += '</div>'
			tmp += '</li>'
		})
		
		return tmp + "</ul>";
	}

	$(document).ready(function(){

		/* POST(Create) */
		$("#btn-write-reply").click(function(e) {
			let reply = $("textarea[id=reply]").val();

			if(reply.trim() == '') {
				alert("댓글을 입력해주세요.");
				$("textarea[id=reply]").focus()
				return;
			}

			$.ajax({
				type: 'POST',	// 요청 메서드
				url: '/induk/replies?bno=' + bno,	// 요청 URI	// /induk/replies?bno=893 POST
				headers: { "content-type" : "application/json" },	// 요청 헤더
				data: JSON.stringify({bno: bno, reply: reply}),	// 서버로 전송할 데이터, stringify()로 직렬화 필요
				success: function(result) {
					alert(result);
					showList(bno);
				},
				error : function() { alert("Write error"); }
			});


		});

		/* GET 대댓글 */
		$("a.btn-write").click(function(e){
			let target = e.target;
			let rno = target.getAttribute("data-rno")
			let bno = target.getAttribute("data-bno")

			let repForm = $("#nestedReply-writebox");
			repForm.appendTo($("li[data-rno="+rno+"]"));
			repForm.css("display", "block");
			repForm.attr("data-prno", prno);
			repForm.attr("data-bno",  bno);
		});

		/* 대댓 등록 */
		$("#btn-write-nestedReply").click(function() {
			let reply = $("textarea[id=nestedReply]").val();
			let prno = $("#nestedReply-writebox").attr("data-prno");

			if(reply.trim() == '') {
				alert("댓글을 입력해주세요");
				$("textarea[id=nestedReply]").focus()
				return;
			}

			$.ajax({
				type: 'POST',		// 요청 메서드
				url: '/induk/replies?bno=' + bno	,	// 요청 URI	// /induk/replies?bno=893	POST
				headers: { "content-type" : "application/json"},	// 요청 헤더
				data: JSON.stringify({prno:prno, bno:bno, reply:reply}),	// 서버로 전송할 데이터, stringify로 직렬화 필요
				success: function(result) {
					alert(result);
					showList(bno);
				},
				error: function() { alert("error") }	// 에러가 발생했을 때, 호출될 함수
			});	// $.ajax()
		});

		/* 대댓 취소 */
		$("#btn-cancel-nestedReply").click(function(e){
			$("#nestedReply-writebox").css("display", "none");
		});

		/* Delete reply */
		$("#btn-delete").click(function(e){
			let rno = $(this).attr("data-rno");
			let bno = $(this).attr("data-bno");
			$.ajax({
				type: 'DELETE',		// 요청 메서드
				url: '/induk/replies/' + rno + '?bno=' + bno,	// 요청 URI
				success: function(result) {
					alert(result)
					showList(bno);
				},
				error: function() {alert("error")}	// 에러가 발생했을 때, 호출될 함수
			})	// $.ajax()
		});

		/* modal */
		$("a.btn-modify").click(function(e){
			let target = e.target;
			let rno = target.getAttribute("data-rno");
			let bno = target.getAttribute("data-bno");
			let prno = target.getAttribute("data-prno");
			let li = $("li[data-rno="+rno+"]");
			let replier = $(".replier", li).first().text();
			let reply = $(".reply-content", li).first().text();

			$("#modalWin .replier").text(replier);
			$("#modalWin textarea").text(reply);
			$("#btn-write-modify").attr("data-rno", rno);
			$("#btn-write-modify").attr("data-prno", prno);
			$("#btn-write-modify").attr("data-bno", bno);

			// 팝업창을 열고 내용을 보여준다.
			$("#modalWin").css("display","block");
		});

		$("#btn-write-modify").click(function(){
			// 1. 변경된 내용을 서버로 전송
			let rno = $(this).attr("data-rno");
			let reply = $("textarea[id=modReply]").val();

			if(reply.trim() == '') {
				alert("댓글을 입력해주세요");
				$("textarea[id=modReply]").focus()
				return;
			}
           
			$.ajax({
				type: 'PATCH',		// 요청 메서드
				url: '/induk/replies/' + rno,	// 요청 URI 	// /induk/replies/70	PATCH
				headers: { "content-type" : "application/json"},	// 요청 헤더
				data: JSON.stringify({rno:rno, reply:reply}),	// 서버로 전송할 데이터, stringify()로 직렬화 필요
				success: function(result) {
					alert(result);
				},
				error: function() { alert("error") }	// 에러가 발생했을 때, 호출될 함수
			});	// $.ajax()

			// 2. 모달 창을 닫는다. 
			$(".close").trigger("click");
			showList(bno);
		});

		
		$(".close").click(function(){
			$("#modalWin").css("display","none");
		});

	});

	</script>
</body>
</html>