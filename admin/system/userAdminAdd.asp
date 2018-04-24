<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="../inc/const.asp"-->
<!--#include file="../inc/conn.asp"-->
<!--#include file="../Session.asp" -->
<!--#include file="../inc/Function.asp" -->
<!--#include file="../inc/md5.asp" -->
<%
If Not JudgePower("admin") Then Error1
Dim act,adminId
adminId = Request("id")
act=Request.Form("action")
If act="1" Then
	Dim userAccount,userPassword,userState,userPoplevel
	userAccount = Request.Form("userAccount")
	userPassword = Request.Form("userPassword")
	userState = Request.Form("userState")
	userPoplevel = Request.Form("userPoplevel")
	Call OpenDataBase
	If adminId="" Then
		If userAccount="" or userPassword="" Then
			Call ShowErrorInfo("用户账号和密码都必须输入！",0)
		End IF
		userPassword = md5(userPassword,32)
		Conn.execute("insert into BL_G_Admin_User(username,password,flag,popLevel) values('"&userAccount&"','"&userPassword&"',"&userState&",'"&userPoplevel&"')") 
		Call ShowErrorInfo("添加成功！","userAdminList.asp")
	Else
		If userPassword="" Then
			Conn.Execute("update BL_G_Admin_User set flag=" & userState & ",popLevel='"&userPoplevel&"' where username='"&userAccount&"'")
			Call ShowErrorInfo("修改成功！","userAdminList.asp")
		Else
			userPassword = md5(userPassword,32)
			Conn.Execute("update BL_G_Admin_User set password='"&userPassword&"',flag=" & userState & ",popLevel='"&userPoplevel&"' where username='"&userAccount&"'")
			Call ShowErrorInfo("修改成功！","userAdminList.asp")
		End IF
	End If
Else
	If adminId<>"" Then
		Call OpenDataBase
		Set adminRs=Conn.Execute("select * from BL_G_Admin_User where id=" & adminId)
		If Not adminRs.Eof Then
			userAccount = adminRs("username")
			userState	= adminRs("flag")
			userPoplevel= adminRs("popLevel")
			pageTitle	="修改用户"
			passAlt		="&nbsp; <font color='red';>如不需要修改请留空</font>"
			readonlyStr	="readonly='readonly'"
		Else
			Call ShowErrorInfo("非法操作！","userAdminList.asp")
		End If
		Call connClose
	Else
		userState	="1"
		pageTitle	="添加用户"
		readonlyStr =""
	End If
End IF           
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>用户列表</title>
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
    <li>账号管理</li>
  </ul>
</div>
<div class="formbody">
  <div class="formtitle"><span><%=pageTitle%></span></div>
  <ul class="forminfo">
    <form action="" method="post">
      <input type="hidden" name="action" value="1" />
      <li>
        <label>用户账号</label>
        <input name="userAccount" type="text" class="dfinput" value="<%=userAccount%>" <%=readonlyStr%> />
      </li>
      <li>
        <label>用户密码</label>
        <input name="userPassword" type="password" class="dfinput" />
        <%=passAlt%> </li>
      <li>
        <label>用户状态</label>
        <cite>
        <input name="userState" type="radio" value="1" <% If userState="1" Then Response.Write("checked='checked'")%> />
        正常&nbsp;&nbsp;&nbsp;&nbsp;
        <input name="userState" type="radio" value="0" <% If userState="0" Then Response.Write("checked='checked'")%> />
        锁定</cite></li>
      <li>
        <label>用户权限</label>
        <cite>
        <input name="userPoplevel" type="radio" value="admin" <% If userPoplevel="admin" Then Response.Write("checked='checked'")%> />
        管理员权限&nbsp;&nbsp;&nbsp;&nbsp;
        <input name="userPoplevel" type="radio" value="common" <% If userPoplevel="0" Then Response.Write("checked='checked'")%> />
        普通权限</cite></li>
      <li>
        <label>&nbsp;</label>
        <input name="" type="submit" class="btn" value="保存"/>
      </li>
    </form>
  </ul>
</div>
</body>
</html>
