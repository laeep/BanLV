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
	Dim rightCode,rightName
	rightCode = Request.Form("rightCode")
	rightName = Request.Form("rightName")
	Call OpenDataBase
	If adminId="" Then
		If rightName="" or rightCode="" Then
			Call ShowErrorInfo("权限代码和权限名称都必须输入！",0)
		End IF
		Conn.execute("insert into BL_m_right_info(right_code,right_name) values('"&rightCode&"','"&rightName&"')") 
		Call ShowErrorInfo("添加成功！","rightList.asp")
	Else
		Conn.Execute("update BL_m_right_info set right_code='"&rightCode&"',right_name='"&rightName&"' where id="&adminId)
		Call ShowErrorInfo("修改成功！","rightList.asp")
	End If
Else
	If adminId<>"" Then
		Call OpenDataBase
		Set adminRs=Conn.Execute("select * from BL_m_right_info where id=" & adminId)
		If Not adminRs.Eof Then
			rightCode = adminRs("right_code")
			rightName	= adminRs("right_name")
			pageTitle	="修改权限"
		Else
			Call ShowErrorInfo("非法操作！","rightList.asp")
		End If
		Call connClose
	Else
		pageTitle	="添加权限"
	End If
End IF           
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=pageTitle%></title>
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
    <li>权限管理</li>
  </ul>
</div>
<div class="formbody">
  <div class="formtitle"><span><%=pageTitle%></span></div>
  <ul class="forminfo">
    <form action="" method="post">
      <input type="hidden" name="action" value="1" />
      <li>
        <label>权限名称</label>
        <input name="rightName" type="text" class="dfinput" value="<%=rightName%>"/>
      </li>
      <li>
        <label>权限代码</label>
        <input name="rightCode" type="text" class="dfinput" value="<%=rightCode%>" />
      </li>
      
      <li>
        <label>&nbsp;</label>
        <input name="" type="submit" class="btn" value="保存"/>
      </li>
    </form>
  </ul>
</div>
</body>
</html>
