<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="../inc/const.asp"-->
<!--#include file="../inc/conn.asp"-->
<!--#include file="../Session.asp" -->
<!--#include file="../inc/Function.asp" -->
<%
If Not JudgePower("admin") Then Error1


Dim memid,page
memid	= Request.QueryString("id")
page	= Request.QueryString("p")

Call OpenDataBase  
'删除基本信息
Conn.execute("delete from BL_s_goods_info where id="&memid)
'删除扩展信息
Conn.execute("delete from BL_s_goods_ext_info where goods_id="&memid)
Call connClose
Response.Redirect("sharelist.asp?page="&page)

%>
