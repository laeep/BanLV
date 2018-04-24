<%
If IsNull(Session(G_SessionPre&"_Admin_ID")) Or Session(G_SessionPre&"_Admin_ID")="" Then
	Response.Write("<script>top.location="""&G_AdminDir&"login.asp"";</script>")
	Response.End()
End If

Function JudgePower(m_PagePop)
	JudgePower=False
	If Instr(1,Session(G_SessionPre&"_Admin_Pop"),m_PagePop)>0 or m_PagePop="0" or Session(G_SessionPre&"_Admin_Pop")="admin" Then
		JudgePower = True
	End If
End Function

Function Error1
	if IsObject(Conn) then
		Conn.Close
		Set Conn = Nothing
	end if
	Response.Write("<script>alert(""您的权限不足，请联系管理员！"");history.back()</script>")
	Response.End
End function
%>