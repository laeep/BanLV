// JavaScript Document
//签到
function mySign(){
	$.ajax({
	   type: "POST",
	   url: "server.asp",
	   data: "a=1",
	   dataType:"text",
	   success: function(data){
			//alert(data);
			switch (data){
					case "0":
						$("#signA").text("已签到");
						$("#signA").removeClass("btn-blue").addClass("bg80");
						$("#signA").unbind();
						alert("签到成功！");
						break;
					case "1":
						alert("你尚未登录，请登录后再签到！");
						location.href="login.asp?url="+location.href;
						break;
					case "2":
						alert("你今天已经签过到了，请明天再来！");
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
//收藏,取消收藏
function collectGoods(f_cancel,f_id){
	$.ajax({
	   type: "POST",
	   url: "server.asp",
	   data: "a=5&i="+f_cancel+"&g="+f_id,
	   dataType:"text",
	   success: function(data){
			//alert(data);
			switch (data){
					case "10":
						$("#collect1").toggle();
						$("#collect0").toggle();
						alert("取消收藏成功！");
						break;
					case "1":
						alert("你尚未登录，请登录后再操作！");
						location.href="login.asp?url="+location.href;
						break;
					case "3":
						alert("对不起，你没有此权限！");
						break;
					case "20":
						$("#collect0").toggle();
						$("#collect1").toggle();
						alert("收藏成功！");
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

//列表页收藏,取消收藏
function collectGoodsList(f_cancel,f_id){
	$.ajax({
	   type: "POST",
	   url: "server.asp",
	   data: "a=5&i="+f_cancel+"&g="+f_id,
	   dataType:"text",
	   success: function(data){
			//alert(data);
			switch (data){
					case "10":
						$("#collect"+f_id).removeClass("active1").addClass("active0");
						$("#collect"+f_id).attr("href","javascript:collectGoodsList(0,"+f_id+");");
						alert("取消收藏成功！");
						break;
					case "1":
						alert("你尚未登录，请登录后再操作！");
						location.href="login.asp?url="+location.href;
						break;
					case "3":
						alert("对不起，你没有此权限！");
						break;
					case "20":
						$("#collect"+f_id).removeClass("active0").addClass("active1");
						$("#collect"+f_id).attr("href","javascript:collectGoodsList(1,"+f_id+");");
						alert("收藏成功！");
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
//赞踩goods
function zancai(f_type,f_goods){
	$.ajax({
	   type: "POST",
	   url: "Server.asp",
	   data: "a=4&g="+f_goods+"&t="+f_type,
	   dataType:"text",
	   success: function(ret){
		   //alert(ret);
		   switch(ret){
				case "1":
					alert("你尚未登录，请登录后再操作！");
					location.href="login.asp?url="+location.href;
					break;
				case "2":
					alert("参数传递错误！");
					break;
				case "3":
					alert("对不起，你没有此权限！");
					break;
				case "4":
					alert("你不能既赞又踩，请先取消赞或者踩！");
					break;
				case "13":
					var zancaiValue=(parseInt($('*[attr="'+f_type+'a'+f_goods+'"]').text())-1).toString();
					$('*[attr="'+f_type+'a'+f_goods+'"]').text(zancaiValue);
					alert("取消赞成功！");
					break;
				case "23":
					var zancaiValue=(parseInt($('*[attr="'+f_type+'a'+f_goods+'"]').text())-1).toString();
					$('*[attr="'+f_type+'a'+f_goods+'"]').text(zancaiValue);
					alert("取消踩成功！");
					break;
				case "10":
					var zancaiValue=(parseInt($('*[attr="'+f_type+'a'+f_goods+'"]').text())+1).toString();
					$('*[attr="'+f_type+'a'+f_goods+'"]').text(zancaiValue);
					alert("点赞成功！");
					break;
				case "20":
					var zancaiValue=(parseInt($('*[attr="'+f_type+'a'+f_goods+'"]').text())+1).toString();
					$('*[attr="'+f_type+'a'+f_goods+'"]').text(zancaiValue);
					alert("踩成功！");
					break;
				default:
					alert("异常"+ret);
		   }
		   
	   }
	});
}
//赞踩评论
function zancaiComment(f_type,f_comment){
	$.ajax({
	   type: "POST",
	   url: "Server.asp",
	   data: "a=7&c="+f_comment+"&t="+f_type,
	   dataType:"text",
	   success: function(ret){
		   //console.log(ret);
		   switch(ret){
				case "1":
					alert("你尚未登录，请登录后再操作！");
					location.href="login.asp?url="+location.href;
					break;
				case "2":
					alert("参数传递错误！");
					break;
				case "13":
				case "23":
					alert("您已经赞或踩过此评论！");
					break;
				case "10":
					var sourceNum=$("#a"+f_comment).text().replace(/[^0-9]/ig,"");
					$("#a"+f_comment).text('['+(parseInt(sourceNum)+1).toString()+']');
					alert("操作成功！");
					break;
				case "20":
					var sourceNum=$("#b"+f_comment).text().replace(/[^0-9]/ig,"");
					$("#b"+f_comment).text('['+(parseInt(sourceNum)+1).toString()+']');
					alert("操作成功！");
					break;
				default:
					alert("异常"+ret);
		   }
		   
	   }
	});
}
function showGoodsExt(){
	var f_goods=$("#f_goods_id").text();
	$.ajax({
	   type: "POST",
	   url: "Server.asp",
	   data: "a=6&g="+f_goods,
	   dataType:"text",
	   success: function(ret){
		   //alert(ret);
		   //console.log(ret);
		   var maxValue=0;
		   var maxType="";
		   var preType ="";
		   var dataJson = eval('('+ret+')');
		   var firstValue=0;
		   var itemIndex=0;
		   var firstItemName="";

		   for(var p in dataJson){
			   	if(p!="collect"){//判断是否显示收藏
				   if(p.substring(1,p.length-1)!=preType){
						firstValue = dataJson[p];
						itemIndex = 0;
						firstItemName = p
						//alert(Math.max.apply(null,$('input[id^="'+preType+'"]').val()));
						//if(parseInt(dataJson[p])!=0){
						//	$("#"+p).parent().addClass("active-num");
						//}
				   }
				   else{
					   //console.log(itemIndex);
					   itemIndex =itemIndex +1
					   if((parseInt(dataJson[p])<parseInt(firstValue)) && (itemIndex==1)){
						   $("#"+firstItemName).parent().addClass("active-num");
					   }
				   }
				   $("#"+p).text(dataJson[p]);
				   preType =p.substring(1,p.length-1);
			   }else{
				   $("#"+p+dataJson[p]).show();
			   }
			   
		   }

	   }
	});
}
//onClick="zancai(1,<%=GoodsRs("id")%>);" attr="1a<%=GoodsRs("id")%>"></span><span><%=GoodsRs("goods_zan")
/*
 parend 父级id
 clsName 元素class
 瀑布流格式化
 */
function waterfall(parent,clsName){
    var $parent = $('#'+parent);//父元素
    var $boxs = $parent.find('.'+clsName);//所有box元素
    var iPinW = $boxs.eq(0).width();// 一个块框box的宽
    var cols = Math.floor( $( window ).width() / iPinW );//列数
    //$parent.width(iPinW * cols).css({'margin': '0 auto'});

    var pinHArr=[];//用于存储 每列中的所有块框相加的高度。

	
	  $boxs.each( function( index, dom){
		var gao = [];
        gao[index] = $('.user-box').width()*$boxs.eq(index).find('.pubuliu').attr('h')/$boxs.eq(index).find('.pubuliu').attr('w');
        $boxs.eq(index).find('.pubuliu').css({'width':$('.user-box').width(),'height':gao[index]});
        if( index < cols ){
            //pinHArr[ index ] = $(dom).position().top + $(dom).outerHeight(true); //所有列的高度
			pinHArr[ index ] = $boxs.eq(index).innerHeight() + 5; //所有列的高度
        }else{
            var minH = Math.min.apply( {}, pinHArr );//数组pinHArr中的最小值minH
            var minHIndex = getMinKey( pinHArr, minH );
            $boxs.eq(index).css({
                'position': 'absolute',
                'top': minH,
                'left': $boxs[minHIndex].offsetLeft
            });
			pinHArr[minHIndex] = pinHArr[minHIndex] + $boxs.eq(index).innerHeight() + 5;
            //console.log('a'+pinHArr);
            //添加元素后修改pinHArr
            //pinHArr[ minHIndex ] = pinHArr[ minHIndex ] + $boxs.eq(index).height()+10;//更新添加了块框后的列高
            
            //console.log(pinHArr);
        }
		
        
    });
    $parent.css('height', Math.max.apply({},pinHArr));  //给父级设置最高的高度
	//console.log($boxs.eq(0).outerHeight(true) +','+ $boxs.eq(0).position().top);
	//console.log(pinHArr);
	

}

//检验是否满足加载数据条件，即触发添加块框函数waterfall()的高度：最后一个块框的距离网页顶部+自身高的一半(实现未滚到底就开始加载)
function checkscrollside(parent,clsName){
    //最后一个块框
    var $lastBox = $('#'+parent).find('.'+clsName).last(),
        lastBoxH = $lastBox.offset().top + $lastBox.height()/ 2,
        scrollTop = $(window).scrollTop(),
        documentH = $(window).height();
    return lastBoxH < scrollTop + documentH ? true : false;
}

 //获取数组中最小元素的键名  
function getMinKey(arr,min){  
	for(var key in arr){  
		if(arr[key]==min){  
			return key;  
		}  
	}  
}  
