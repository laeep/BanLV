document.writeln("<div id=\'tbox\'> <a title=\'返回顶部\' id=\'gotop\'></a></div>");
function b(){
	h = 300;
	t = $(document).scrollTop();
	if(t>h){
		$('#gotop').slideDown();
	}else{
		$('#gotop').slideUp();
	}
}
b();
$(document).ready(function(e) {
	
	InitData();
	$('#gotop').click(function(){
		$('html,body').animate({scrollTop: '0'}, 300);	
	})
});
$(window).scroll(function(e){
	b();		
})
function InitData()
{
	if(location.href.indexOf("_xinren")>0)
	{
		getPhotoListString(1);//新人
	}
	if(location.href.indexOf("_renqi")>0)
	{
		getPhotoListString(2);//人气
	}
	if(location.href.indexOf("_tuijian")>0)
	{
		getPhotoListString(3);//推荐
	}
	if(location.href.indexOf("_heibang")>0)
	{
		getHeiBListString();//黑榜
	}		
}