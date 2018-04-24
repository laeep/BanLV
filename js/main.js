$(function(){
	
	$('.write').each(function(i){
		$(this).bind('click',function(){
			$(this).siblings('input').attr("disabled",false);
		});
	});
	showDingContent();
	showCollectContent();
	checkSign();
	/*
	$('.user').find('input').each(function(i){
		$(this).bind('blur',function(){
			$(this).attr("disabled",true);
		});
	});
	*/
	$('#Imgtouxiang').click(function(){
		$('#photo-main').show();
	});
	$('#cancelBtn').click(function(){
		$('#photo-main').hide();
	});
	var pc = new PhotoClip('#clipArea', {
		size: [120,120],
		outputSize: [120,120],
		//adaptive: ['60%', '80%'],
		file: '#file',
		view: '#view',
		ok: '#clipBtn',
		style: {
			maskColor: 'rgba(0,0,0,.5)',
			maskBorder: '2px dashed #ddd',
			jpgFillColor: '#fff'
		},
		//img: 'img/mm.jpg',
		loadStart: function() {
			//console.log('开始读取照片');
		},
		loadComplete: function() {
			//console.log('照片读取完成');
		},
		done: function(dataURL) {
			$('#Imgtouxiang').attr("src",dataURL);
			$('#photo-main').hide();
			//console.log(dataURL);
		},
		fail: function(msg) {
			alert(msg);
		}
	});
});

function upLoad()
{
	var base64Data	= encodeURIComponent($('#Imgtouxiang').attr("src"));
	var mem_nick	= $('#userNick').val();
	var mem_mobile 	= $('#mobileNo').val();
	var mem_email	= $('#eMail').val();
	var oldPass 	= $('#oldPass').val();
	var pass1 		= $('#pass1').val();
	var pass2	 	= $('#pass2').val();
	//alert(mem_nick);
	var submitData="base64_string="+base64Data+"&mem_nick="+mem_nick+"&mem_mobile="+mem_mobile+"&mem_email="+mem_email+"&oldPass="+oldPass+"&pass1="+pass1+"&pass2="+pass2; 
	$.ajax({
	   type: "POST",
	   url: "my_info_save.asp",
	   data: submitData,
	   dataType:"text",
	   contentType: "application/x-www-form-urlencoded; charset=gb2312",
	   success: function(data){
			switch (data){
					case "11":
						alert("原密码错误！");
						break;
					case "12":
						alert("请重新登录！");
						location.href="login.asp?url="+location.href;
						break;
					case "13":
						alert("新密码和重复密码必须一致！");
						break;
					case "14":
						alert("用户昵称已经存在，请更换一个！");
						break;
					case "0":
						alert("修改成功！");
						break;
					default :
						alert("异常错误！"+data);
			}
	   }, 
		error:function(XMLHttpRequest, textStatus, errorThrown){ 
		   alert("修改失败！");
		}
	});  
}


function showDingContent(){
	$.ajax({
	   type: "POST",
	   url: "ListServer.asp",
	   data: "a=4",//按定制内容推荐
	   dataType:"text",
	   success: function(ret){
			//console.log(ret);
			if(ret!=""){
				//转换为json数据
				var dataJson = eval('('+ret+')');
				$('#mem_rec').html("");
				$.each(dataJson.data,function(index,dom){
				var $box = $('<li class="lilili"></li>');
				//$box.html('<div class="pic"><img src="./img/'+$(dom).attr('src')+'"></div>');
				$box.html('<div class="li-box">'
						+'<a href="showDetails.asp?id='+$(dom).attr('id')+'"><img src="'+$(dom).attr('src')+'" class="img1"></a>'
						+'<div class="name text-align margin-t5">'+$(dom).attr('name')+'</div>'
						+'<div class="price text-align">'+$(dom).attr('price')+'</div>'
						+'<div class="row huidi">'
							+'<div class="col-6 zan-box"><span class="zan" onClick=zancai(1,'+$(dom).attr('id')+'); attr="1a'+$(dom).attr('id')+'"></span> <span>'+$(dom).attr('zan')+'</span></div>'
							+'<div class="col-6 zan-box"><span class="cai" onClick=zancai(2,'+$(dom).attr('id')+'); attr="2a'+$(dom).attr('id')+'"></span> <span>'+$(dom).attr('cai')+'</span></div>'
						+'</div>'
						+$(dom).attr('place')
						+'<div>'
						//	+'<div class="zan-box tx-box"><span class="tx"><img src="'+$(dom).attr('memphoto')+'" width="20" height="20"></span> <a href="otherUser_info.asp?id='+$(dom).attr('memid')+'">'+$(dom).attr('memName')+'</a><span>推荐</span></div>'
						+'</div>'
					+'</div>');
				$('#mem_rec').append($box);
				
				//alert('000');
				//pagesIndex =pagesIndex+1;
				//isPosting = false;
				});
				//waterfall('mem_rec','lilili');
			}
	   }
	}); 	

}
function showCollectContent(){
	$.ajax({
	   type: "POST",
	   url: "listServer.asp",
	   data: "a=5",//按定制内容推荐
	   dataType:"text",
	   success: function(ret){
			//console.log(ret);
			if(ret!=""){
				//转换为json数据
				var dataJson = eval('('+ret+')');
				$('#myCollect').html("");
				$.each(dataJson.data,function(index,dom){
				var $box = $('<li class="lilili1"></li>');
				//$box.html('<div class="pic"><img src="./img/'+$(dom).attr('src')+'"></div>');
				$box.html('<div class="li-box">'
						+'<a href="showDetails.asp?id='+$(dom).attr('id')+'"><img src="'+$(dom).attr('src')+'" class="img1"></a>'
						+'<div class="name text-align margin-t5">'+$(dom).attr('name')+'</div>'
						+'<div class="price text-align">'+$(dom).attr('price')+'</div>'
						+'<div class="row huidi">'
							+'<div class="col-6 zan-box"><span class="zan" onClick=zancai(1,'+$(dom).attr('id')+'); attr="1a'+$(dom).attr('id')+'"></span> <span>'+$(dom).attr('zan')+'</span></div>'
							+'<div class="col-6 zan-box"><span class="cai" onClick=zancai(2,'+$(dom).attr('id')+'); attr="2a'+$(dom).attr('id')+'"></span> <span>'+$(dom).attr('cai')+'</span></div>'
						+'</div>'
						+$(dom).attr('place')
						+'<div>'
						//	+'<div class="zan-box tx-box"><span class="tx"><img src="'+$(dom).attr('memphoto')+'" width="20" height="20"></span> <a href="otherUser_info.asp?id='+$(dom).attr('memid')+'">'+$(dom).attr('memName')+'</a> <span>推荐</span></div>'
						+'</div>'
					+'</div>');
				$('#myCollect').append($box);

				});
				//waterfall('myCollect','lilili1');
			}
	   }
	}); 	

}
function checkSign(){
		$.ajax({
		   type: "POST",
		   url: "server.asp",
		   data: "a=9",
		   dataType:"text",
		   success: function(data){
				//alert(data);
				switch (data){
						case "0":
							$("#signA").text("签到");
							break;
						case "1":
							$("#signA").text("已签到");
							$("#signA").removeClass("btn-blue").addClass("bg80");
							$("#signA").unbind();
							break;
						default :
							alert("异常错误！"+data);
				}
		   }, 
			/*error:function(XMLHttpRequest, textStatus, errorThrown){ 
			   alert("操作失败！");
			}*/
		});
}





