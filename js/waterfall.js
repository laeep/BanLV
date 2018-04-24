var pagesIndex=1;
var isPosting = false;
var isLoginFilter = 0;
$.ajax({
	type: "POST",
	url: "server.asp",
	data: "a=10",
	dataType:"text",
	success: function(ret){
		isLoginFilter = eval('('+ret+')');	
	}
})


$( window ).on( "load", function(){
    waterfall('user-main','user-box');
});


window.onscroll=function(){
       
        if(checkscrollside('user-main','user-box') && !isPosting){
            isPosting = true;
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
        }
    }
function getPhotoListString(f_type){
	//if(!allowLoadNext){
	//	return false;
	//}
	//allowLoadNext=false;
	$.ajax({
	   type: "POST",
	   url: "listServer.asp",
	   data: "a="+f_type+"&i="+pagesIndex,
	   dataType:"text",
	   success: function(ret){
			//console.log(ret);
			if(ret!=""){
				//转换为json数据
				var dataJson = eval('('+ret+')');
				$.each(dataJson.data,function(index,dom){
					var $box = $('<li class="user-box"></li>');
					
					if($(dom).attr('isad')=='0')
					{
						if(isLoginFilter){
							$box.html('<div class="li-box">'
								+'<a href="showDetails.asp?id='+$(dom).attr('id')+'"><img class="pubuliu" src="'+$(dom).attr('src')+'" w="'+$(dom).attr('W')+'" h="'+$(dom).attr('H')+'"></a>'
								+$(dom).attr('lable_flag')
								+'<div class="add_box"><a class="active'+$(dom).attr('C')+'" id="collect'+$(dom).attr('id')+'" href="javascript:collectGoodsList('+$(dom).attr('C')+','+$(dom).attr('id')+');"></a></div>'
								+'<div class="name text-align margin-t5">'+$(dom).attr('name')+'</div>'
								+'<div class="price text-align">'+$(dom).attr('price')+'</div>'
								+'<div class="row huidi">'
									+'<div class="col-6 zan-box"><span class="zan"></span> <span>'+$(dom).attr('zan')+'</span></div>'
									+'<div class="col-6 zan-box"><span class="cai"></span> <span>'+$(dom).attr('cai')+'</span></div>'
								+'</div>'
								+$(dom).attr('place')
								+'<div>'
								+'</div>'
							+'</div>');
						}else{
							$box.html('<div class="li-box">'
									+'<a href="showDetails.asp?id='+$(dom).attr('id')+'"><img class="pubuliu filter" src="'+$(dom).attr('src')+'" w="'+$(dom).attr('W')+'" h="'+$(dom).attr('H')+'"></a>'
									+$(dom).attr('lable_flag')
									+'<div class="add_box"><a class="active'+$(dom).attr('C')+'" id="collect'+$(dom).attr('id')+'" href="javascript:collectGoodsList('+$(dom).attr('C')+','+$(dom).attr('id')+');"></a></div>'
									+'<div class="name text-align margin-t5">'+$(dom).attr('name')+'</div>'
									+'<div class="price text-align">'+$(dom).attr('price')+'</div>'
									+'<div class="row huidi">'
										+'<div class="col-6 zan-box"><span class="zan"></span> <span>'+$(dom).attr('zan')+'</span></div>'
										+'<div class="col-6 zan-box"><span class="cai"></span> <span>'+$(dom).attr('cai')+'</span></div>'
									+'</div>'
									+$(dom).attr('place')
									+'<div>'
									+'</div>'
								+'</div>');
						}
					}else
					{
						$box.html('<div class="li-box">'
								+'<a href="'+$(dom).attr('adurl')+'" target="_blank"><img class="pubuliu" src="'+$(dom).attr('src')+'" w="'+$(dom).attr('W')+'" h="'+$(dom).attr('H')+'"></a>'
								+$(dom).attr('lable_flag')
							+'</div>');
					}
					$('#user-main').append($box);

				});
			waterfall('user-main','user-box');
			isPosting = false;
			pagesIndex =pagesIndex+1;
			//console.log(pagesIndex)
			}
	   }
	}); 	
}


