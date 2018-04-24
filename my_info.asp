<!--#include file="inc/Const.asp"-->
<!--#include file="inc/Conn.asp"-->
<!--#include file="inc/Session.asp"-->
<%
'Response.Write(Session(G_SessionPre&"_Mem_Pop"))
Call IsLogin
Call OpenDataBase
Dim userFace
Set memRs=Conn.Execute("select *,mem_points+mem_points_add as mem_allPoints from BL_m_member_info where id="&Session(G_SessionPre&"_Mem_ID"))
If memRs.Eof Then
	Call ShowErrorInfo("账号不存在，返回！",0)
Else
	If memRs("mem_photo")<>"" Then 
		userFace =memRs("mem_photo")
	Else
		userFace ="images/img/noFace.jpg"
	End If
End If
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width,initial-scale=1.0,user-scalable=no">
<meta name="format-detection" content="telephone=no">
<title>我的资料</title>
<link rel="stylesheet" type="text/css" href="css/style.css"/>
<script src="js/jquery-2.2.3.min.js"></script>
<script src="js/iscroll-zoom.js"></script>
<script src="js/hammer.min.js"></script>
<script src="js/lrz.all.bundle.js"></script>
<script src="js/PhotoClip.js"></script>
<script src="js/comm.js?v=1"></script>
<script src="js/main.js?v=11"></script>
</head>
<body>
<header class="head-go"> <a href="index_tuijian.asp" class="fanhui"></a> 我的资料 </header>

<article class="user">
  <form action="#">
    <div class="row user-toubu">
      <%If Not JudgePower("P001001") Then%>
      <div class="toux"><img src="<%=userFace%>" width="120" height="120"></div>
      <%Else%>
      <div class="toux"><img src="<%=userFace%>" id="Imgtouxiang" width="120" height="120"></div>
      <%end If%>
      <p class="text-align margin-tb5 color80">数字ID:<%=memRs("id")%></p>
      <p class="text-align user-btns"> <a href="jubao.asp" class="btn btn-small btn-red btn-60">黑榜提交</a> <a href="javascript:mySign();" class="btn btn-small btn-blue btn-60" id="signA">签到</a> <a href="share.asp" class="btn btn-small btn-orange btn-60">分享提交</a> </p>
    </div>
    <div class="row margin-t15">
      <div class="col-6">
        <label>用户账号：</label>
      </div>
      <div class="col-6"> <%=memRs("mem_name")%> </div>
    </div>
    <div class="row">
      <div class="col-6">
        <label>用户昵称：</label>
      </div>
      <div class="col-6 user-edit">
        <input type="text" id="userNick" value="<%=memRs("mem_nick")%>" class="txt1 txt3" maxlength="8" />
      </div>
    </div>
    <div class="row">
      <div class="col-6">
        <label>用户头衔：</label>
      </div>
      <div class="col-6"> <%=memRs("mem_label")%> &nbsp;&nbsp;<a href="dingzhi.asp?a=<%=memRs("mem_name")%>"><img src="images/dingzhi.png" width="22"> <img src="images/write.png" width="22"></a> </div>
    </div>
    <hr style="margin-top: 0px; margin-bottom: 10px;">
    <div class="row">
      <div class="col-6">
        <label>综合积分：</label>
      </div>
      <div class="col-6"> <%=memRs("mem_allPoints")%> </div>
    </div>
    <div class="row">
      <div class="col-6">
        <label>发布分享：</label>
      </div>
      <div class="col-6"> <%=memRs("mem_share_num")%> </div>
    </div>
    <div class="row">
      <div class="col-6">
        <label>发布举报：</label>
      </div>
      <div class="col-6"> <%=memRs("mem_jubao_num")%> </div>
    </div>
    <div class="row">
      <div class="col-6">
        <label>发布评论：</label>
      </div>
      <div class="col-6"> <%=memRs("mem_comment_num")%> </div>
    </div>
    <div class="row">
      <div class="col-6">
        <label>威望：</label>
      </div>
      <div class="col-6"> <%=memRs("mem_weiwang")%> </div>
    </div>
    <div class="row">
      <div class="col-6">
        <label>贡献值：</label>
      </div>
      <div class="col-6"> <%=memRs("mem_gongxian")%> </div>
    </div>
    <hr style="margin-top: 0; margin-bottom: 10px;">
    <div class="row">
      <div class="col-6">
        <label>手机号：</label>
      </div>
      <div class="col-6 user-edit">
        <input type="text" id="mobileNo" value="<%=memRs("mem_mobile")%>" class="txt1 txt3" />
      </div>
    </div>
    <div class="row">
      <div class="col-6">
        <label>邮箱：</label>
      </div>
      <div class="col-6 user-edit">
        <input type="text" id="eMail" value="<%=memRs("mem_email")%>" class="txt1 txt3" maxlength="30" />
      </div>
    </div>
   
    <div class="row">
      <div class="col-6">
        <label>原密码：</label>
      </div>
      <div class="col-6">
        <input type="password" id="oldPass" class="txt1 txt3" />
      </div>
    </div>
    <div class="row">
      <div class="col-6">
        <label>新密码：</label>
      </div>
      <div class="col-6">
        <input type="password" id="pass1" class="txt1 txt3" />
      </div>
    </div>
    <div class="row">
      <div class="col-6">
        <label>确认密码：</label>
      </div>
      <div class="col-6">
        <input type="password" id="pass2" class="txt1 txt3" />
      </div>
    </div>
    
    <div class="row">
      <div style="text-align:center;">
        <input type="button" value="提交" class="btn btn-success" onclick="upLoad();" />
      </div>
    </div>
    <hr style="margin-top: 0; margin-bottom: 10px;">
    <div class="row">
      <div class="col-6">
        <label>注册时间：</label>
      </div>
      <div class="col-6"> <%=formatdatetime(memRs("mem_join_time"),2)%> </div>
    </div>
    <div class="row">
      <div class="col-6">
        <label>最后登录：</label>
      </div>
      <div class="col-6"> <%=formatdatetime(memRs("mem_last_login"),2)%> </div>
    </div>
    <%
	memRs.Close
	Set memRs = Nothing
	
	
	
	%>
    <hr style="margin-top: 0; margin-bottom: 10px;">
    <div style="padding: 0 0 0 20px;">
     <%
	 'Response.Write("["&Session(G_SessionPre&"_Mem_Pop")&"---")
	 Call OpenDataBase
	  Set PopRs=Conn.Execute("select right_code,right_name from BL_m_right_info order by right_code")
	  Do While Not PopRs.Eof
	  	Response.Write("<div class=""row"">")
		Response.Write("<div class=""col-3""><label>"&PopRs("right_name")&"：</label></div>")
		If Instr(1,Session(G_SessionPre&"_Mem_Pop"),PopRs("right_code"))>0 Then
			Response.Write("<div class=""col-3""> <span class=""right""></span> </div>")
		Else
			Response.Write("<div class=""col-3""> <span class=""error""></span> </div>")
		End If
	  	PopRs.MoveNext
		If PopRs.Eof Then
			Response.Write("</div>")
			Exit Do
		Else
			Response.Write("<div class=""col-3""><label>"&PopRs("right_name")&"：</label></div>")
			If Instr(1,Session(G_SessionPre&"_Mem_Pop"),PopRs("right_code"))>0 Then
				Response.Write("<div class=""col-3""> <span class=""right""></span> </div>")
			Else
				Response.Write("<div class=""col-3""> <span class=""error""></span> </div>")
			End If
			Response.Write("</div>")
		End If
		PopRs.MoveNext
	  Loop
	  PopRs.Close
	  Set PopRs = Nothing
	  %>
    </div>
    <hr />
  </form>
  <section class="user-sc">
    <div class="row user-sc-tit" style="color: #FF008C;"><a href="javascript:showDingContent();" class="user-right">换一批</a>会员推荐</div>
    <div class="row user-sc-con">
      <ul class="user-list" id="mem_rec">
      </ul>
    </div>
  </section>
  <hr style="margin-top: 10px; margin-bottom:0px;">
  <section class="user-sc">
    <div class="row user-sc-tit">我的收藏</div>
    <div class="row user-sc-con">
      <ul class="user-list" id="myCollect">
        
        
      </ul>
    </div>
  </section>
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
<%
Call connClose
%>
<div style="display:none;"><script src="https://s22.cnzz.com/z_stat.php?id=1262562117&web_id=1262562117" language="JavaScript"></script></div>
</body>
</html>
