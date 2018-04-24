<%
Sub IsLogin
	If IsNull(Session(G_SessionPre&"_Mem_ID")) Or Session(G_SessionPre&"_Mem_ID")="" Then
	
		Response.Write("<script>alert('你尚未登录，无法进行此操作，请先登录！');top.location="""&G_Website_Dir&"/login.asp"";</script>")
		Response.End()
	End If
End Sub 

Function JudgePower(m_PagePop)
	JudgePower=False
	If Session(G_SessionPre&"_Mem_ID")<>"" Then
		Call OpenDataBase
		strsql="select right_code from BL_m_right_info where ID in(select right_id from BL_m_group_right where group_id in(select group_id from BL_m_member_group m,BL_m_group_info g where g.group_state=1 and g.ID=m.group_id and mem_id ="&Session(G_SessionPre&"_Mem_ID")&"))"
		Set PopRs=Conn.Execute(strsql)
		Do while Not PopRs.Eof
			PopStr=PopStr & "," & PopRs("right_code")
			PopRs.MoveNext
		Loop
		PopRs.Close
		Set PopRs = Nothing
		If PopStr="" Then PopStr =G_YouKePopList
		Session(G_SessionPre&"_Mem_Pop") =PopStr
		'REsponse.Write(Session(G_SessionPre&"_Mem_Pop"))
		'REsponse.End()
		If Instr(1,Session(G_SessionPre&"_Mem_Pop"),m_PagePop)>0 Then
			JudgePower = True
		End If
		Call connClose
	End If
End Function

Function Error1(f_info)
	Response.Write("<script>alert("""&f_info&""");history.back()</script>")
	Response.End
End function
%>