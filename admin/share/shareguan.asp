<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="../inc/const.asp"-->
<!--#include file="../inc/conn.asp"-->
<!--#include file="../Session.asp" -->
<!--#include file="../inc/Function.asp" -->
<%
If Not JudgePower("admin") Then Error1


Dim memid,page,t
memid	= Request.QueryString("id")
page	= Request.QueryString("p")
t		= Request.QueryString("t")

Call OpenDataBase  

If t="0" Then
	Conn.execute("update BL_s_goods_info set goods_guan=1 where id="&memid)   
Else
	Conn.execute("update BL_s_goods_info set goods_guan=0 where id="&memid) 
End If
Call connClose
Response.Redirect("sharelist.asp?page="&page)

%>
