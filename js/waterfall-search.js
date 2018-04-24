$(function(){
    //waterfall('user-main','user-box');

    $('#reset-search').click(function(){
    	location.href = location.href;
    });
    $('.rown').find('span').each(function(i){
    	$(this).bind('click',function(){
			if($(this).hasClass('active-num1')){
				$(this).removeClass('active-num1');
			}else{
    			$(this).addClass('active-num1').parent('div').siblings('div').find('span').removeClass('active-num1');
			}
    	});
    });

});

function dingzhiSearch(){
	var data="";
    $.each($(".search-form").find(".active-num1"), function(){
        var li=$(this).attr("attr");
        data=data+"_" +li;
    });
    if(data.length>0){
		$('.search-form').hide();
		$('#searching').show();
		data=data.slice(1);
		//console.log(data);
		//return false;
		$.ajax({
		   type: "POST",
		   url: "listServer.asp",
		   data: "a=6&d="+data,//复杂搜索
		   dataType:"text",
		   success: function(ret){
			   //console.log(ret);
				if(ret!=""){
					//转换为json数据
					var dataJson = eval('('+ret+')');
					$.each(dataJson.data,function(index,dom){
					var $box = $('<li class="user-box"></li>');
					//$box.html('<div class="pic"><img src="./img/'+$(dom).attr('src')+'"></div>');
					$box.html('<div class="li-box">'
							+'<a href="showDetails.asp?id='+$(dom).attr('id')+'"><img class="pubuliu" w="'+$(dom).attr('W')+'" h="'+$(dom).attr('H')+'" src="'+$(dom).attr('src')+'"></a>'
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
					$('#user-main').append($box);

					});
					waterfall('user-main','user-box');
					$('#searching').hide();
					$('#reset-con').show();
				}
			  else
			  {
				  $('#searching').hide();
				  $('#noData').show();
				$('#reset-con').show();
			  }
		   }
		}); 
    }
    else
    {
        alert("请至少选择一个条件");
    }
	$('#reset-con').show();
}

function simpleSearch(){
	var searchString=$("#iSimpleSearch").val();
	if(searchString==""){
		alert("请输入内容后再搜索");
		return false;
	}
	$('.search-form').hide();
	$('#searching').show();

	$.ajax({
	   type: "POST",
	   url: "listServer.asp",
	   data: "a=7&i="+searchString,
	   dataType:"text",
	   success: function(ret){
			//console.log(ret);
			if(ret!=""){
				//转换为json数据
				var dataJson = eval('('+ret+')');
				$.each(dataJson.data,function(index,dom){
				var $box = $('<li class="user-box"></li>');
				//$box.html('<div class="pic"><img src="./img/'+$(dom).attr('src')+'"></div>');
				$box.html('<div class="li-box">'
						+'<a href="showDetails.asp?id='+$(dom).attr('id')+'"><img class="pubuliu" w="'+$(dom).attr('W')+'" h="'+$(dom).attr('H')+'" src="'+$(dom).attr('src')+'"></a>'
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
				$('#user-main').append($box);
				
				waterfall('user-main','user-box');
				$('#searching').hide();
				$('#reset-con').show();
				
				});
			}
			else
	   		{
				$('#searching').hide();
				$('#noData').show();
				$('#reset-con').show();
			}
	   }
	}); 

}
