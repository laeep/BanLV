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
	Dim userAccount,newPassword,tempPass
	userAccount = Request.Form("userAccount")
	tempPass= CreateRandomString(6)
	
	If userAccount="" Then
		Call ShowErrorInfo("请输入你要重置密码的会员账号！",0)
	End IF
	
	Call OpenDataBase
	newPassword = md5(tempPass,32)
	Set PassRs=Conn.Execute("select id from BL_m_member_info where mem_name='"&userAccount&"'")
	If Not PassRs.Eof Then
		Conn.Execute("update BL_m_member_info set mem_pass='"&newPassword&"' where mem_name='"&userAccount&"'")
		Conn.Close
		Set Conn = Nothing
		Call WriteOperLog("1","重置密码："&userAccount)
		'Response.Write("你充值账号的新密码为【"&tempPass&"】,不包含【】")
	Else
		Call ShowErrorInfo("未找到你输入的账号！",0)
	End If	
End IF           
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>重置密码</title>
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
    <li>重置密码</li>
  </ul>
</div>
<div class="formbody">
  <div class="formtitle"><span>重置密码</span></div>
  <form action="" method="post">
    <input type="hidden" name="action" value="1" />
    <ul class="forminfo">
      <li>
        <label>用户账号</label>
        <input name="userAccount" type="text" class="dfinput" value="<%=userAccount%>"/>
      </li>
      <li>
        <label>&nbsp;</label>
        <input name="" type="submit" class="btn" value="重置"/>
      </li>
    </ul>
  </form>
	<%
    If tempPass<>"" Then
    %>
  <ul class="prosearch">
      <li>
        <label>重置结果：</label>
        <i>会员名称：<%=userAccount%>,重置后的密码【<span style="font-weight:bold; color:red;"><%=tempPass%></span>】,不含【】符号</i>
       </li>
    </ul>
    <%
	end If
	%>
</div>
</body>
</html>
