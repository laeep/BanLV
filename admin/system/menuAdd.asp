<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="../inc/const.asp"-->
<!--#include file="../inc/conn.asp"-->
<!--#include file="../Session.asp" -->
<!--#include file="../inc/Function.asp" -->
<!--#include file="../inc/md5.asp" -->
<%
If Not JudgePower("admin") Then Error1
Dim act,menuId
menuId = Request("id")
act=Request.Form("action")
If act="1" Then
	Dim menuName,menuLink,menuPop,menuOrder,menuParentId,menuHide,menuLevel
	menuName 	= Request.Form("menuName")
	menuLink	= Request.Form("menuLink")
	menuPop 	= Request.Form("menuPop")
	menuOrder 	= Request.Form("menuOrder")
	menuParentId= Request.Form("menuParentId")
	menuHide	= Request.Form("menuHide")
	menuLevel 	= Request.Form("menuLevel")
	
	Call OpenDataBase
	If menuId="" Then
		If menuName="" or menuLink="" or menuPop ="" or menuParentId="" Then
			Call ShowErrorInfo("请填写完整后再提交！",0)
		End IF
		
		Conn.execute("insert into BL_G_MenuClass(MenuName,MenuLink,MenuOrder,MenuPop,MenuParentID,MenuHideFlag,MenuLevel) values('"&menuName&"','"&menuLink&"',"&menuOrder&",'"&menuPop&"',"&menuParentId&","&menuHide&","&menuLevel&")") 
		Call ShowErrorInfo("添加成功！","menuList.asp")
	Else
		Conn.Execute("update BL_G_MenuClass set MenuName='"&menuName&"',MenuOrder=" & menuOrder & ",MenuLink='"&menuLink&"',MenuPop='"&menuPop&"',MenuParentID="&menuParentId&",MenuHideFlag="&menuHide&",MenuLevel="&menuLevel&" where id="&menuId)
		Call ShowErrorInfo("修改成功！","menuList.asp")
	End If
Else
	If menuId<>"" Then
		Call OpenDataBase
		Set MenuRs=Conn.Execute("select * from BL_G_MenuClass where id=" & menuId)
		If Not MenuRs.Eof Then
			menuName 	= MenuRs("MenuName")
			menuLink	= MenuRs("MenuLink")
			menuOrder	= MenuRs("MenuOrder")
			menuPop		= MenuRs("MenuPop")
			menuParentId= MenuRs("MenuParentID")
			menuHide	= MenuRs("MenuHideFlag")
			menuLevel	= MenuRs("MenuLevel")
			pageTitle	="修改菜单"
		Else
			Call ShowErrorInfo("非法操作！","menuList.asp")
		End If
		MenuRs.Close
		Set MenuRs = Nothing
		Call connClose
	Else
		menuParentId=0
		menuHide	=0
		pageTitle	="添加菜单"
		menuLevel 	=1
		menuOrder	=0
	End If
End IF           
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>添加菜单</title>
<link href="../css/style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="../js/jquery.js"></script>
</head>

<body>
<div class="place"> <span>位置：</span>
  <ul class="placeul">
    <li>首页</li>
    <li>系统管理</li>
    <li>菜单管理</li>
  </ul>
</div>
<div class="formbody">
  <div class="formtitle"><span><%=pageTitle%></span></div>
  <ul class="forminfo">
    <form action="" method="post">
      <input type="hidden" name="action" value="1" />
      <li>
        <label>上级菜单编号</label>
        <input name="menuParentId" type="text" class="dfinput" value="<%=menuParentId%>" />
      </li>
      <li>
        <label>菜单名称</label>
        <input name="menuName" type="text" class="dfinput" value="<%=menuName%>" />
      </li>
      <li>
        <label>链接地址</label>
        <input name="menuLink" type="text" class="dfinput" value="<%=menuLink%>" />
      </li>
      <li>
        <label>显示状态</label>
        <cite>
        <input name="menuHide" type="radio" value="0" <% If menuHide=False Then Response.Write("checked='checked'")%> />
        正常&nbsp;&nbsp;&nbsp;&nbsp;
        <input name="menuHide" type="radio" value="1" <% If menuHide=true Then Response.Write("checked='checked'")%> />
        隐藏</cite></li>
      <li>
        <label>菜单权限</label>
        <input name="menuPop" type="text" class="dfinput" value="<%=menuPop%>" />
      </li>
      <li>
        <label>菜单显示顺序</label>
        <input name="MenuOrder" type="text" class="dfinput" value="<%=MenuOrder%>" />
      </li>
      <li>
        <label>菜单层次</label>
        <input name="menuLevel" type="text" class="dfinput" value="<%=menuLevel%>" />
      </li>
      <li>
        <label>&nbsp;</label>
        <input name="" type="submit" class="btn" value="保存" />
      </li>
    </form>
  </ul>
</div>
</body>
</html>
