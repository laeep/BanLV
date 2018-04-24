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
	Dim jQQ,jWeixin,jTel,jName,jCai,jOrderTime
	jQQ 	= Request.Form("jQQ")
	jWeixin	= Request.Form("jWeixin")
	jTel 	= Request.Form("jTel")
	jName 	= Request.Form("jName")
	jCai= Request.Form("jCai")
	jOrderTime	= Request.Form("jOrderTime")
	
	Call OpenDataBase
	Conn.Execute("update BL_s_report_info set report_goods_name='"&jName&"',report_goods_qq='" & jQQ & "',report_goods_weixin='"&jWeixin&"',report_goods_tel='"&jTel&"',report_goods_cai="&jCai&",report_order_by_time='"&jOrderTime&"' where id="&menuId)
	Call ShowErrorInfo("修改成功！","jubaoList.asp")

Else
	If menuId<>"" Then
		Call OpenDataBase
		Set MenuRs=Conn.Execute("select * from BL_s_report_info where id=" & menuId)
		If Not MenuRs.Eof Then
			jName 	= MenuRs("report_goods_name")
			jQQ		= MenuRs("report_goods_qq")
			jWeixin		= MenuRs("report_goods_weixin")
			jTel	= MenuRs("report_goods_tel")
			jCai	= MenuRs("report_goods_cai")
			jOrderTime	= MenuRs("report_order_by_time")
		Else
			Call ShowErrorInfo("非法操作！","jubaoList.asp")
		End If
		MenuRs.Close
		Set MenuRs = Nothing
		Call connClose
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
        <label>姓名</label>
        <input name="jName" type="text" class="dfinput" value="<%=jName%>" />
      </li>
      <li>
        <label>QQ</label>
        <input name="jQQ" type="text" class="dfinput" value="<%=jQQ%>" />
      </li>
      <li>
        <label>微信</label>
        <input name="jWeixin" type="text" class="dfinput" value="<%=jWeixin%>" />
      </li>
      
      <li>
        <label>电话</label>
        <input name="jTel" type="text" class="dfinput" value="<%=jTel%>" />
      </li>
      <li>
        <label>踩数</label>
        <input name="jCai" type="text" class="dfinput" value="<%=jCai%>" />
      </li>
      <li>
        <label>排序</label>
        <input name="jOrderTime" type="text" class="dfinput" value="<%=jOrderTime%>" />
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
