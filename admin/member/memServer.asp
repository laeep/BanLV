<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="../inc/const.asp"-->
<!--#include file="../inc/conn.asp"-->
<!--#include file="../Session.asp" -->
<!--#include file="../inc/Function.asp" -->
<%
Dim Action,memId
Action = CInt(Request.Form("a"))
If Action=1 Then
	Dim sendNum
	memId	=Request.Form("i")
	sendNum	=Request.Form("n")
	If sendNum="" or memId="" Then
		Response.Write(-1)
		Response.End()
	End IF
	If Not IsNum(sendNum) Then
		Response.Write(-1)
		Response.End()
	End IF
	sendNum = CLng(sendNum)
	If sendNum>999 or sendNum<1 Then
		Response.Write(-1)
		Response.End()
	End IF
	Call OpenDataBase  
	Set cmd = Server.CreateObject("Adodb.Command")
	cmd.ActiveConnection = Conn
	cmd.CommandText = "[usp_create_recCode]"
	cmd.CommandType = 4
	cmd.Parameters.Append cmd.CreateParameter("@mem_id",200, 1,20 ,memId)
	cmd.Parameters.Append cmd.CreateParameter("@num",3,1,4,sendNum)
	cmd.Execute
	'session("shop_joyousNum")=CSng(session("shop_joyousNum"))+Cint(chargeNum)
	Call connClose
	Response.Write(0)
ElseIf Action=2 Then
	Dim endTime
	memId	=Request.Form("i")
	endTime	=Request.Form("t")
	If endTime="" or memId="" Then
		Response.Write(-1)
		Response.End()
	End IF
	If Not Isdate(endTime) Then
		Response.Write(-1)
		Response.End()
	End IF
	Call OpenDataBase
	Conn.Execute("update BL_m_member_info set mem_end_time='"&endTime&"' where id="&memId) 
	Call connClose
	Response.Write(0)
ElseIf Action=3 Then
	Dim pointsNum
	memId	=Request.Form("i")
	pointsNum=Request.Form("n")
	If pointsNum="" or memId="" Then
		Response.Write(-1)
		Response.End()
	End IF
	If Not IsNum(pointsNum) Then
		Response.Write(-1)
		Response.End()
	End IF
	pointsNum = CLng(pointsNum)
	
	Call OpenDataBase
	Conn.Execute("update BL_m_member_info set mem_points_add="&pointsNum&" where id="&memId) 
	Call connClose
	Response.Write(0)
End If
%>