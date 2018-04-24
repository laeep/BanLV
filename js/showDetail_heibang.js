// JavaScript Document
$(function(){

	$('.tc-fx-mask').height($(document).height());
	$('.fxclose').bind('click',function(){
		$('.tc-fx-mask').addClass("hidden");
	});
	$('#share').bind('click',function(){
		$(".fx2").text(location.href);
		$('.tc-fx-mask').removeClass("hidden");
	});

});
function tijiaoHBComment(){
	var commDesc=$("#commentDesc").val();
	var reportId =$("#f_goods_id").text();
	//alert(reportId);
	if(commDesc!=""){
		$.ajax({
		   type: "POST",
		   url: "server.asp",
		   data: "a=8&i="+reportId+"&c="+commDesc,
		   dataType:"text",
		   success: function(data){
				var retArray=data.split("|");
				switch (retArray[0]){
						case "0":
							$("#commentDesc").val("");

							$("#jubaoliyou_div").after('<div class="row padding-lr20">'
							+'<span class="color80">用户 '+retArray[1]+'：</span>'
							+'<div class="comment-item row">'
							+'<div> '+commDesc+' </div>'
							+'<div class="dingcai"><span onClick="zancaiComment(1,'+retArray[2]+')"> 顶 </span><span id="a'+retArray[2]+'">[0]</span><span onClick="zancaiComment(2,'+retArray[2]+')"> 踩 </span><span id="b'+retArray[2]+'">[0]</span></div>'
							+'</div>'
							+'</div>'
							);
							alert("提交评论成功！");
							break;
						case "1":
							alert("提交评论失败！");
							break;
						default :
							alert("异常错误！"+data);
				}
		   }, 
			error:function(XMLHttpRequest, textStatus, errorThrown){ 
			   alert("操作失败！");
			}
		});
	}
}
