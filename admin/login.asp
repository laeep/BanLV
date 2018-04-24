<!--#include file="inc/Const.asp"-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>欢迎登录<%=G_SiteName%>管理系统</title>
<link href="css/style.css" rel="stylesheet" type="text/css" />
<script language="JavaScript" src="js/jquery.js"></script>
<script src="js/cloud.js" type="text/javascript"></script>
<script language="javascript" type="text/javascript">

if(window.parent.location != window.location)
{window.parent.location=window.location;}
	$(function(){
    $('.loginbox').css({'position':'absolute','left':($(window).width()-692)/2});
	$(window).resize(function(){  
    $('.loginbox').css({'position':'absolute','left':($(window).width()-692)/2});
    });
});  
</script>
</head>
<style type="text/css">
dl, dt, dd, span {
	margin: 0;
	padding: 0;
	display: block;
}
</style>
<body style="background-color:#1c77ac; background-image:url(images/light.png); background-repeat:no-repeat; background-position:center top; overflow:hidden;">
<div id="mainBody">
  <div id="cloud1" class="cloud"></div>
  <div id="cloud2" class="cloud"></div>
</div>
<div class="loginbody"> <span class="systemlogo">欢迎登录【<%=G_SiteName%>】</span>
  <div class="loginbox loginbox2">
    <form action="Chkadmin.asp" method="post" >
      <ul>
      <li>
        <input name="Username" type="text" class="loginuser" onclick="JavaScript:this.value=''" value="<%=Request.Cookies("JR_AD")("UserName")%>" />
      </li>
      <li>
        <input name="password" type="password" class="loginpwd" onclick="JavaScript:this.value=''" value="<%=Request.Cookies("JR_AD")("UserPass")%>"/>
      </li>
      <li class="yzm"> <span>
        <input name="verifycode" type="text" onclick="JavaScript:this.value=''" autocomplete="off"/>
        </span><cite style="vertical-align:middle; margin-top:8px;"><img id="imgcode" src="yzCode.asp" align="absmiddle" onClick="JavaScript:document.getElementById('imgcode').src='yzcode.asp?a='+Math.random();" style="cursor:pointer;"></cite> </li>
      <li>
      <input name="tijiao" type="submit" class="loginbtn" value="登录" /><label><input name="savePass" type="checkbox" value="1" checked="checked" />记住密码</label>
      </li>
      </ul>
    </form>
  </div>
</div>
<div class="loginbm">版权所有  2016 <a href="<%=G_SiteUrl%>"><%=G_SiteUrl%></a></div>
</body>
</html>
