<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="../inc/const.asp"-->
<!--#include file="../inc/conn.asp"-->
<!--#include file="../Session.asp" -->
<!--#include file="../inc/Function.asp" -->
<!--#include file="../inc/md5.asp" -->
<%
Dim act
act=Request.Form("action")
If act="1" Then
	Dim userAccount,sourcePassword,newPassword,newPassword2
	userAccount = Session(G_SessionPre&"_Admin_Name")
	sourcePassword = Request.Form("sourcePassword")
	newPassword = Request.Form("newPassword")
	newPassword2 = Request.Form("newPassword2")
	If newPassword="" or sourcePassword="" or newPassword2="" Then
		Call ShowErrorInfo("原密码和新密码及其重复密码都必须输入！",0)
	End IF
	If newPassword<>newPassword2 Then
		Call ShowErrorInfo("新密码和重复密码不一致！",0)
	End If
	Call OpenDataBase
	sourcePassword = md5(sourcePassword,32)
	newPassword = md5(newPassword,32)
	Set PassRs=Conn.Execute("select password from BL_G_Admin_User where username='"&userAccount&"'")
	If Not PassRs.Eof Then
		If LCase(PassRs(0))=LCase(sourcePassword) Then
			Conn.Execute("update BL_G_Admin_User set password='"&newPassword&"' where username='"&userAccount&"'")
			Call ShowErrorInfo("修改成功，请重新登录！",G_AdminDir&"login.asp")
		Else
			PassRs.Close
			Set PassRs = Nothing
			Call ShowErrorInfo("您输入的原来密码不正确！",0)
		End If
	Else
		Call ShowErrorInfo("非法操作！",0)
	End If	
End IF           
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>密码修改</title>
<link href="../css/style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="../js/jquery.js"></script>
<script language="javascript" type="text/javascript">
function  CA()
{
if($("#Select").attr("checked")=='checked')
	$("#id").attr("checked",true);
else
	$("#id").attr("checked",false);
}
</script>
</head>

<body>
<div class="place"> <span>位置：</span>
  <ul class="placeul">
    <li>首页</li>
    <li>系统管理</li>
    <li>修改密码</li>
  </ul>
</div>
<div class="formbody">
  <div class="formtitle"><span>修改密码</span></div>
  <form action="" method="post">
    <input type="hidden" name="action" value="1" />
    <ul class="forminfo">
      <li>
        <label>用户账号</label>
        <input name="userAccount" type="text" class="dfinput" readonly="readonly" value="<%=Session(G_SessionPre&"_Admin_Name")%>" />
      </li>
      <li>
        <label>原来密码</label>
        <input name="sourcePassword" type="password" class="dfinput" />
      </li>
      <li>
        <label>新的密码</label>
        <input name="newPassword" type="password" class="dfinput" />
      </li>
      <li>
        <label>重复密码</label>
        <input name="newPassword2" type="password" class="dfinput" />
      </li>
      <li>
        <label>&nbsp;</label>
        <input name="" type="submit" class="btn" value="保存"/>
      </li>
    </ul>
  </form>
</div>
</body>
</html>
