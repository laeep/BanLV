// JavaScript Document
$(function(){
	$('.fuwu-show').each(function(i){
		$(this).bind('click',function(){
			if($(this).find('span').text()=='展开'){
				$(this).find('span').text('隐藏');
				$(this).find('img').attr('src','images/arrow-up.png');
			}else{
				$(this).find('span').text('展开');
				$(this).find('img').attr('src','images/arrow-down.png');
			}
			$(this).parent().next('.fuwu-con').toggle();
		});
	});
	showGoodsExt();
	
	$('.tc-fx-mask').height($(document).height());
	$('.fxclose').bind('click',function(){
		$('.tc-fx-mask').addClass("hidden");
	});
	$('#share').bind('click',function(){
		$(".fx2").text(location.href);
		$('.tc-fx-mask').removeClass("hidden");
	});

});

