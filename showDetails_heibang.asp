<!--#include file="inc/Const.asp"-->
<!--#include file="inc/Conn.asp"-->
<!--#include file="inc/Session.asp"-->
<%
Dim goodsId,priceString
goodsId =Request.QueryString("id")
If goodsId="" Then
	Response.Write("非法访问1！")
	Response.End()
Else
	goodsId =CLng(goodsId)
End If
If IsNull(Session(G_SessionPre&"_Mem_ID")) Or Session(G_SessionPre&"_Mem_ID")="" Then
	Response.Redirect("index_heibang.asp")
End If

Call OpenDataBase
Set goodsRs=Conn.Execute("select mem_id,report_goods_name,report_goods_qq,id,report_goods_weixin,report_goods_cai,report_goods_photo,report_goods_tel,report_goods_desc from BL_V_report_list where id="&goodsId)
If goodsRs.Eof Then
	goodsRs.Close
	Set goodsRs = Nothing
	Call connClose
	Response.Write("非法访问2！")
	Response.End()
End If
If goodsRs("report_goods_qq")="" then QQ="-" else QQ=goodsRs("report_goods_qq")
If goodsRs("report_goods_tel")="" then Tel="-" else Tel=goodsRs("report_goods_tel")
If goodsRs("report_goods_weixin")="" then Weixin="-" else Weixin=goodsRs("report_goods_weixin")
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width,initial-scale=1.0,user-scalable=no">
<meta name="format-detection" content="telephone=no">
<title>黑榜详情</title>
<link rel="stylesheet" type="text/css" href="css/style.css"/>
<link rel="stylesheet" type="text/css" href="css/index.css"/>
<script src="js/jquery-2.2.3.min.js"></script>
<script src="js/comm.js"></script>
<script src="js/showDetail_heibang.js"></script>
</head>
<body>
<div class="tc-fx-mask hidden">
    <div class="tc-fx-box">
			<a class="fxclose"><img src="images/close.png" width="32"></a>
			<div class="tc-fx-box2">
				<h3>您的分享链接已经生成</h3>
				<div class="fx1">请手动选择链接后复制</div>
				<div class="fx2"></div>
			</div>
		</div>
    </div>
<article class="jubao">
  <div class="row showtoux flex">
  <a class="home02" href="index_tuijian.asp"><img src="images/home02.png" width="32" height="32"></a>
    <div class="showtoux-co1"> <span class="icon icon-cai1" attr="2a<%=goodsRs("id")%>" onClick="zancai(2,<%=goodsRs("id")%>)"><%=goodsRs("report_goods_cai")%></span><span id="f_goods_id" style="display:none;"><%=goodsRs("id")%></span> </div>
    <div class="showtoux-co2">
      <div class="text-align"><img src="<%=goodsRs("report_goods_photo")%>" width="100%"></div>
      <div class="tx-txt">
        <div class="fz16"><%=goodsRs("report_goods_name")%></div>
        <div class="tel-txt"> <span>QQ:<%=QQ%></span> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <span style="line-height: 1.5;"> <span class="tel2"><%=Tel%></span> </span> </div>
        <div>微信：<%=Weixin%></div>
      </div>
    </div>
    <div class="showtoux-co1 float-left"> <span class="icon icon-share1" id="share">分享</span> </div>
  </div>
  <div class="details-bg"></div>
  <div class="row flex" id="jubaoliyou_div"> <span class="fz24">上榜理由</span>
    <div class="fwsp-line"></div>
  </div>
  <%
	goodsRs.Close
	Set goodsRs = Nothing
	Call OpenDataBase
	Set CommentRs=Conn.Execute("select * from BL_s_goods_comment_info where goods_id="&goodsId&" order by id desc")
	Do While Not CommentRs.Eof
	
	%>
  <div class="row padding-lr20"> <!--span class="color80">用户 <%=CommentRs("mem_id")%>：</span-->
    <div class="comment-item row">
      <div> <%=CommentRs("comment_desc")%> </div>
      <div class="dingcai"><span onClick="zancaiComment(1,<%=CommentRs("id")%>)"> 顶 </span><span id="a<%=CommentRs("id")%>">[<%=CommentRs("comment_zan")%>]</span><span onClick="zancaiComment(2,<%=CommentRs("id")%>)"> 踩 </span><span id="b<%=CommentRs("id")%>">[<%=CommentRs("comment_cai")%>]</span></div>
    </div>
  </div>
  <%
		CommentRs.MoveNext
	Loop
	CommentRs.Close
	Set CommentRs = Nothing
	Call connClose
	%>
  <div class="row">
    <div class="margin-b10"></div>
    <div style="padding: 0 36px;">
      <textarea class="text-area" id="commentDesc"></textarea>
    </div>
  </div>
  <div class="row text-align">
    <input type="button" value="提交评论" class="btn btn-success" onClick="tijiaoHBComment();" />
  </div>
</article>
<section class="screenW">
  <div class="subW">
    <div class="info">
      <div class="shareBox">
        <h2>请选择您的分享方式：</h2>
        <div class="bdsharebuttonbox"> <a href="#" class="bds_qzone" data-cmd="qzone" title="分享到QQ空间">QQ空间</a> <a href="#" class="bds_tsina" data-cmd="tsina" title="分享到新浪微博">新浪微博</a> <a href="#" class="bds_sqq" data-cmd="sqq" title="分享到QQ好友">QQ</a> <a href="#" class="bds_tqq" data-cmd="tqq" title="分享到腾讯微博">腾讯微博</a></div>
        <div class="bdsharebuttonbox"> <a href="#" onclick="return false;" class="popup_more" data-cmd="more"></a> </div>
      </div>
    </div>
    <div class="close">关闭</div>
  </div>
</section>
<div style="display:none;"><script src="https://s22.cnzz.com/z_stat.php?id=1262562117&web_id=1262562117" language="JavaScript"></script></div>
</body>
</html>
