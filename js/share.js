$(function(){
	
	$('#okbtn').click(function(){
		$('#photo-main').show();
	});
	$('#cancelBtn').click(function(){
		$('#photo-main').hide();
	});
	
	$('#comment').find('input[type=radio]').each(function(i){
		$(this).bind('click',function(){
			if($(this).is(':checked')){
				$(this).siblings('label').addClass('color4c').parent('div').siblings('div').find('label').removeClass('color4c');
			}
		});
	});
	var pc = new PhotoClip('#clipArea', {
		size: [220,270],
		outputSize: [440,540],
		outputQuality:0.9,
		lrzOption: {
				quality:.9
			},
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
			console.log('开始读取照片');
		},
		loadComplete: function() {
			console.log('照片读取完成');
		},
		done: function(dataURL) {
			$("#okbtn").attr("src",dataURL);
			$("#ImgBase64").val(dataURL);
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
	var data="";
    $.each($("#comment").find(".color4c"), function() {

        var li=$(this).attr("for");
        data=data+"_" +li;
     
    });
	//console.log(data);
	if(data.split("_").length<11){
		alert("所有单选项目必须全部选择！");
		return false;
	}
	data=data.slice(1);
	$("#allDanXuan").val(data);
	if($("#userQq").val()=="" && $("#userWeixin").val()=="" && $("#userTel").val()==""){
		alert("ＱＱ、ＴＥＬ、微信至少输入一项！");
		return false;
	}
	if($("#price1p").val()=="" && $("#pricePp").val()=="" && $("#priceBy").val()=="" && $("#priceBt").val()==""){
		alert("１Ｐ、ＰＰ、ＢＹ、ＢＴ价格至少输入一项！");
		return false;
	}
	if($("#userName").val()==""){
		alert("名字必须输入！");
		return false;
	}
	if($("#ImgBase64").val()==""){
		alert("请点击+号，选择照片!");
		return false;
	}
	if($("#useTime").val()==""){
		alert("请选择体验时间!");
		return false;
	}
	$("#shareForm").submit();
}






