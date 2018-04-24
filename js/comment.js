$(function(){
	
	$('#comment').find('input[type=radio]').each(function(i){
		$(this).bind('click',function(){
			if($(this).is(':checked')){
				$(this).siblings('label').addClass('color4c').parent('div').siblings('div').find('label').removeClass('color4c');
			}
		});
	});

});

function upLoad()
{
	var data="";
    $.each($("#comment").find(".color4c"), function() {

        var li=$(this).attr("for");
        data=data+"_" +li;
     
    });
	
	if(data.split("_").length<11){
		alert("所有单选项目必须全部选择！");
		return false;
	}
	data=data.slice(1);
	$("#allDanXuan").val(data);
	if($("#price1p").val()=="" && $("#pricePp").val()=="" && $("#priceBy").val()=="" && $("#priceBt").val()==""){
		alert("１Ｐ、ＰＰ、ＢＹ、ＢＴ价格至少输入一项！");
		return false;
	}
	if($("#useTime").val()==""){
		alert("请选择体验时间!");
		return false;
	}
	$("#commentForm").submit();
}






