<!--#include file="inc/Const.asp"-->
<!--#include file="inc/Conn.asp"-->
<!--#include file="inc/Session.asp"-->
<!--#include file="inc/function.asp"-->
<%
Call IsLogin
If Not JudgePower("P000014") Then Error1("您没有举报的权限！")
Dim action,userName,userQq,userTel,userWeixin,useTime,jubaoLiYou,imgBase64,path
action = Request.Form("action")
If action = "1" Then
	userName 	= lostDangerChar(Request.Form("userName"))
	userQq 		= lostDangerChar(Request.Form("userQq"))
	userTel 	= lostDangerChar(Request.Form("userTel"))
	userWeixin 	= lostDangerChar(Request.Form("userWeixin"))
	useTime 	= lostDangerChar(Request.Form("useTime"))
	jubaoLiYou 	= lostDangerChar(Request.Form("jubaoLiYou"))
	imgBase64 	= Request.Form("ImgBase64")
	If userName="" Then
		Call ShowErrorInfo("请输入名字，返回！",0)
	End If
	If userQq="" and userTel="" and userWeixin="" Then
		Call ShowErrorInfo("QQ、TEL、微信至少输入一项，请返回输入！",0)
	End If
	If useTime="" Then
		Call ShowErrorInfo("请选择体验时间，返回！",0)
	End If
	If jubaoLiYou="" Then
		Call ShowErrorInfo("请输入举报理由，返回！",0)
	End If
	If imgBase64="" Then
		Call ShowErrorInfo("请选择照片，返回！",0)
	End If
	
	If Instr(1,Lcase(imgBase64),"base64")>0 Then
		path=Replace(Now()," ","")
		path=Replace(path,"/","")
		path=Replace(path,"-","")
		path=Replace(path,":","")
		path= "userFace/jubao/" & Session(G_SessionPre&"_Mem_ID") & path &  ".jpg"'    ‘’‘’‘图片保存路径
		'Call WriteFile("2222.txt",imgBase64)
		Call saveImg(path,imgBase64)
		'Conn.Execute("update BL_m_member_info set mem_photo='"&path&"' where id="& Session(G_SessionPre&"_Mem_ID"))
	End If
	Call OpenDataBase
	StrSql="insert into BL_s_report_info(report_goods_name,report_mem_id,report_goods_qq,report_goods_weixin,report_goods_tel,report_goods_use_time,report_goods_photo,report_goods_desc)	values('"&userName&"','"&Session(G_SessionPre&"_Mem_ID")&"','"&userQq&"','"&userWeixin&"','"&userTel&"','"&useTime&"','"&path&"','"&jubaoLiYou&"')"
	'Response.Write(StrSql)
	Conn.Execute(StrSql)
	
	Set jubaoRs=Conn.Execute("select top 1 id from BL_s_report_info where report_goods_photo='"&path&"' order by id desc")
	If Not jubaoRs.Eof Then
		If jubaoLiYou<>"" Then
			Conn.Execute("insert into BL_s_goods_comment_info(mem_id,goods_id,comment_desc) values("&Session(G_SessionPre&"_Mem_ID")&","&jubaoRs("id")&",'"&jubaoLiYou&"')")
		End If
	End If
	jubaoRs.Close
	Set jubaoRs = Nothing
	Call connClose
	Call ShowErrorInfo("举报成功，请等待审核！","my_info.asp")
End If
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width,initial-scale=1.0,user-scalable=no">
<meta name="format-detection" content="telephone=no">
<title>黑榜提交</title>
<link rel="stylesheet" type="text/css" href="css/style.css"/>
<script src="js/jquery-2.2.3.min.js"></script>
<script src="js/iscroll-zoom.js"></script>
<script src="js/hammer.min.js"></script>
<script src="js/lrz.all.bundle.js"></script>
<script src="js/PhotoClip.js"></script>
<script language="javascript">
$(function(){
	$('#Imgtouxiang').click(function(){
		$('#photo-main').show();
	});
	$('#cancelBtn').click(function(){
		$('#photo-main').hide();
	});
	
	var pc = new PhotoClip('#clipArea', {
		size: [220,270],
		outputSize: [440,540],
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
			$('#Imgtouxiang').css("height","270");
			$('#Imgtouxiang').css("width","220px");
			$("#ImgBase64").val(dataURL);
			$('#photo-main').hide();
			//console.log(dataURL);
		},
		fail: function(msg) {
			alert(msg);
		}
	});
});
</script>
</head>
<body>

<article class="jubao">
  <form action="" method="post"><textarea id="ImgBase64" name="ImgBase64" style="display:none;"></textarea>
  <input type="hidden" name="action" value="1">
    <div class="row margin-t15 margin-b10">
      <div class="text-align"><img src="images/jia.png" id="Imgtouxiang"></div>
    </div>
    <div class="row flex">
      <div class="col-6">
        <div class="flex padding-t5">
          <label class="lab1">名字：</label>
          <input type="text" class="txt1" name="userName">
        </div>
      </div>
      <div class="col-6">
        <div class="flex padding-t5">
          <label class="lab1">Q Q：</label>
          <input type="text" class="txt1" name="userQq">
        </div>
      </div>
    </div>
    <div class="row flex">
      <div class="col-6">
        <div class="flex padding-t5">
          <label class="lab1">Tel：</label>
          <input type="tel" class="txt1" name="userTel">
        </div>
      </div>
      <div class="col-6">
        <div class="flex padding-t5">
          <label class="lab1">微信：</label>
          <input type="text" class="txt1" name="userWeixin">
        </div>
      </div>
    </div>
    <div class="row flex">
      <div class="padding-t5">
        <label class="lab1" style="width: 7rem;">体验时间：</label>
        <input type="date" name="useTime" class="txt1 txt2">
      </div>
    </div>
    <hr style="margin-top: 10px; margin-bottom: 5px;">
    <div class="row">
      <div>
        <label style="color:#808080;">上榜理由</label>
      </div>
      <div style="padding: 0 36px;">
        <textarea class="text-area" name="jubaoLiYou"></textarea>
      </div>
    </div>
    <div class="row text-align">
      <input type="submit" value="提交" class="btn btn-success" />
    </div>
  </form>
</article>
<div id="photo-main">
  <div id="clipArea"></div>
  <div class="photo-foot">
    <div class="uploader1 blue"> <a href="javascript:;" class="button" name="file">打开</a>
      <input id="file" type="file" accept="image/*" multiple  />
    </div>
    <a href="javascript:;" class="button2" id="cancelBtn">返回</a>
    <a href="javascript:;" class="button" id="clipBtn">截取</a> </div>
  <!--<img src="" id="view11">--> 
</div>
<div style="display:none;"><script src="https://s22.cnzz.com/z_stat.php?id=1262562117&web_id=1262562117" language="JavaScript"></script></div>
</body>
</html>
