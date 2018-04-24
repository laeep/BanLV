<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="../inc/const.asp"-->
<!--#include file="../inc/conn.asp"-->
<!--#include file="../Session.asp" -->
<!--#include file="../inc/Function.asp" -->
<%
If Not JudgePower("admin") Then Error1

Dim action,idList
action=request.QueryString("a")
idList = request.QueryString("id")
If action="1" Then
	Call OpenDataBase
	Conn.Execute("delete from BL_G_MenuClass where id ="&CInt(idList))
	Call connClose
End IF

Dim account,sqlWhere,ssql
account = Request.Form("account")
sqlWhere = Request("s")

If sqlWhere="" Then
	sqlWhere = " 1=1"
	If account<>"" Then
		sqlWhere = sqlWhere & " and username='"&account&"'"
	End If
End IF

Call OpenDataBase       
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<META HTTP-EQUIV="Pragma"  CONTENT="no-cache">    
<META HTTP-EQUIV="Cache-Control" CONTENT="no-cache">    
<META HTTP-EQUIV="Expires" CONTENT="0">  
<title>菜单列表</title>
<link href="../css/style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="../js/jquery.js"></script>
<script language="javascript" type="text/javascript">
function del(f_id)
{
	if(confirm("确定要删除选中的内容吗？删除后无法恢复！"))
	{
		location.href='menuList.asp?a=1&id='+f_id;
	}
	
}
</script>
</head>

<body>
<div class="place"> <span>位置：</span>
  <ul class="placeul">
    <li>首页</li>
    <li>系统管理</li>
    <li>菜单列表</li>
  </ul>
</div>
<div class="rightinfo">

  <div class="tools">
    
    	<ul class="toolbar">
        <li class="click" onclick="javascript:location.href='menuAdd.asp';"><span><img src="../images/t01.png" /></span>添加</li>
        </ul>
        
    </div>
  
  <table class="tablelist1">
    <thead>
      <tr>
        <th>菜单名称</th>
        <th>链接地址</th>
        <th>菜单权限</th>
        <th>显示顺序</th>
        <th>显示状态</th>
        <th colspan="2">操作</th>
      </tr>
    </thead>
    <tbody>
      <% Response.Write(ReadMenuData(0,1)) %>
    </tbody>
  </table>
  
</div>
<script type="text/javascript">
	$('.tablelist1 tbody tr:odd').addClass('odd');
	</script>
</body>
</html>
<%

Function ReadMenuData(f_parentId,f_level)
	Dim menuRs,ShowStateStr
	Dim MenuStr
	Set menuRs = Conn.Execute("select * from BL_G_MenuClass where MenuParentID="&f_parentId&" and MenuLevel="&f_level&" order by MenuOrder asc")
	Do While Not menuRs.Eof
		If menuRs("MenuHideFlag")=True Then
			ShowStateStr = "<font color='red'>隐藏</font>"
		Else
			ShowStateStr = "正常"
		End If
		If f_level = 1 Then
			MenuStr = MenuStr & "<tr><td>"&menuRs("MenuName")&"("&menuRs("id")&")</td><td>"&menuRs("MenuLink")&"</td><td>"&menuRs("MenuPop")&"</td><td>"&menuRs("MenuOrder")&"</td><td>"&ShowStateStr&"</td><td><span onclick='del("&menuRs("id")&");'>删除</span><a class='tablelink' href='menuAdd.asp?id="&menuRs("id")&"'>修改</a></td></tr>"
			MenuStr = MenuStr & ReadMenuData(menuRs("id"),2)
		ElseIf f_level = 2 Then
			MenuStr = MenuStr & "<tr><td>……"&menuRs("MenuName")&"("&menuRs("id")&")</td><td>"&menuRs("MenuLink")&"</td><td>"&menuRs("MenuPop")&"</td><td>"&menuRs("MenuOrder")&"</td><td>"&ShowStateStr&"</td><td><span onclick='del("&menuRs("id")&");'>删除</span><a class='tablelink' href='menuAdd.asp?id="&menuRs("id")&"'>修改</a></td></tr>"
		End If
		menuRs.MoveNext
	Loop
	menuRs.Close
	Set menuRs = Nothing
	ReadMenuData = MenuStr
End Function
Call connClose
%>
