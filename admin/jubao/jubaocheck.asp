<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="../inc/const.asp"-->
<!--#include file="../inc/conn.asp"-->
<!--#include file="../Session.asp" -->
<!--#include file="../inc/Function.asp" -->
<%
If Not JudgePower("admin") Then Error1


Dim jubaoId,page,t,memId
jubaoId	= Request.QueryString("id")
page	= Request.QueryString("p")
t		= Request.QueryString("t")

Call OpenDataBase  
memId =Conn.Execute("select report_mem_id from BL_s_report_info where id="&jubaoId)(0)
If t="0" Then
	Conn.execute("update BL_s_report_info set recheck_state=1 where id="&jubaoId)
	Conn.execute("update BL_m_member_info set mem_jubao_num=mem_jubao_num+1 where id="&memId)
	Conn.Execute("update BL_m_member_info set mem_weiwang=mem_weiwang+3 where id="&memId)   
Else
	Conn.execute("update BL_s_report_info set recheck_state=0 where id="&jubaoId) 
	Conn.execute("update BL_m_member_info set mem_jubao_num=mem_jubao_num-1 where id="&memId)
	Conn.Execute("update BL_m_member_info set mem_weiwang=mem_weiwang-3 where id="&memId)
End If
Call connClose
Response.Redirect("jubaolist.asp?page="&page)

%>
