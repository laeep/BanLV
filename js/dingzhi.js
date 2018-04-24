// JavaScript Document
$(function(){
	getDingPara();
	$('.rown').find('span').each(function(i){
    	$(this).bind('click',function(){
			if($(this).hasClass('active-num1')){
				$(this).removeClass('active-num1');
			}else{
    			$(this).addClass('active-num1').parent('div').siblings('div').find('span').removeClass('active-num1');
			}
    	});
    });
	//alert($('*[attr="place0"]').attr("id"));
});
function clearOP(){
	//alert("1");
	$("#search-form").find(".active-num1").removeClass("active-num1");
}
function tijiao()
{
    var data="";
    $.each($("#search-form").find(".active-num1"), function() {

        var li=$(this).attr("attr");
        data=data+"_" +li;
     
    });
    if(data.length>0){
	data=data.slice(1);
	$.ajax({
	   type: "POST",
	   url: "server.asp",
	   data: "a=2&d="+data,//定制
	   dataType:"text",
	   success: function(ret){
			switch (ret){
					case "0":
						alert("定制成功！点确定返回");
						location.href="my_info.asp";
						break;
					case "1":
						alert("你尚未登录，请登录后再定制！");
						location.href="login.asp?url="+location.href;
						break;
					case "2":
						alert("你没有选择你感兴趣的选项！");
						break;
					default :
						alert("异常错误！"+ret);
			}
	   }, 
		error:function(XMLHttpRequest, textStatus, errorThrown){ 
		   alert("操作失败！");
		}
	}); 
    }
    else
    {
        alert("请至少选择一项");
    }
    //alert(data);
}

function getDingPara(){
	$.ajax({
	   type: "POST",
	   url: "server.asp",
	   data: "a=3",//定制参数获取
	   dataType:"text",
	   success: function(ret){
			//alert(ret);
			switch(ret){
				case 0:
					break;
				case 1:
					alert("你尚未登录，请登录后再定制！");
					location.href="login.asp?url="+location.href;
					break;
				default :
					var itemArray=ret.split("_");
					for(var item1 in itemArray) 
					{
						//alert(itemArray[item1]);
						$('*[attr="'+itemArray[item1]+'"]').addClass('active-num1');
						//$("#search-form").find("")
						//document.write(itemArray[item1]+",");
					}
			}
			
	   }, 
		error:function(XMLHttpRequest, textStatus, errorThrown){ 
		   alert("操作失败！");
		}
	}); 
}