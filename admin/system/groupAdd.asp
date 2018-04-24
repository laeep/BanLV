<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="../inc/const.asp"-->
<!--#include file="../inc/conn.asp"-->
<!--#include file="../Session.asp" -->
<!--#include file="../inc/Function.asp" -->
<!--#include file="../inc/md5.asp" -->
<%
If Not JudgePower("admin") Then Error1
Dim act,groupId
groupId = Request("id")
act=Request.Form("action")
If act="1" Then
	Dim groupName,groupState
	groupName = Request.Form("groupName")
	groupState = Request.Form("groupState")
	Call OpenDataBase
	If groupId="" Then
		If groupName="" Then
			Call ShowErrorInfo("权限组名必须输入！",0)
		End IF
		Conn.execute("insert into BL_m_group_info(group_name,group_state) values('"&groupName&"',"&groupState&")") 
		Call ShowErrorInfo("添加成功！","groupList.asp")
	Else
		Conn.Execute("update BL_m_group_info set group_name='"&groupName&"',group_state="&groupState&" where id="&groupId)
		Call ShowErrorInfo("修改成功！","groupList.asp")
	End If
Else
	If groupId<>"" Then
		Call OpenDataBase
		Set adminRs=Conn.Execute("select * from BL_m_group_info where id=" & groupId)
		If Not adminRs.Eof Then
			groupName = adminRs("group_name")
			groupState = adminRs("group_state")
			pageTitle	="修改组名"
		Else
			Call ShowErrorInfo("非法操作！","groupList.asp")
		End If
		Call connClose
	Else
		groupState	=1
		pageTitle	="添加组名"
	End If
End IF           
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>添加组名</title>
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
    <li>分组管理</li>
  </ul>
</div>
<div class="formbody">
  <div class="formtitle"><span><%=pageTitle%></span></div>
  <ul class="forminfo">
    <form action="" method="post">
      <input type="hidden" name="action" value="1" />
      <li>
        <label>权限组名</label>
        <input name="groupName" type="text" class="dfinput" value="<%=groupName%>" />
      </li>
      <li>
        <label>分组状态</label>
        <cite>
        <input name="groupState" type="radio" value="1" <% If groupState=1 Then Response.Write("checked='checked'")%> />
        正常&nbsp;&nbsp;&nbsp;&nbsp;
        <input name="groupState" type="radio" value="0" <% If groupState=0 Then Response.Write("checked='checked'")%> />
        失效</cite></li>
      <li>
        <label>&nbsp;</label>
        <input name="" type="submit" class="btn" value="保存"/>
      </li>
    </form>
  </ul>
</div>
</body>
</html>
