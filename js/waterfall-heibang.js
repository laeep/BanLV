var pagesIndex=1;
var isPosting = false;
$( window ).on( "load", function(){
    waterfall('user-main','user-box');

    window.onscroll=function(){
        if(checkscrollside('user-main','user-box') && !isPosting){
            isPosting = true;
            getHeiBListString();
            //isPosting = false;
			
        }
    }
});

function getHeiBListString(){
	$.ajax({
	   type: "POST",
	   url: "listServer.asp",
	   data: "a=8&i="+pagesIndex,
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
						+'<a href="showDetails_heibang.asp?id='+$(dom).attr('id')+'"><img class="pubuliu" src="'+$(dom).attr('src')+'" w="'+$(dom).attr('W')+'" h="'+$(dom).attr('H')+'"></a>'
						+'<div class="name text-align margin-t5">'+$(dom).attr('name')+'</div>'
						+'<div class="price text-align">QQ:'+$(dom).attr('qq')+'</div>'
						+'<div class="row huidi">'
							+'<div class="col-6 zan-box"><span class="cai"></span> <span>'+$(dom).attr('cai')+'</span></div>'
						+'</div>'
						+'<div>'
						+'</div>'
					+'</div>');
				$('#user-main').append($box);
				});
				waterfall('user-main','user-box');
				isPosting = false;
				pagesIndex =pagesIndex+1;
console.log(pagesIndex)
			}
	   }
	}); 	
}