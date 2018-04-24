<!--#include file="inc/Const.asp"-->
<!--#include file="inc/Conn.asp"-->
<!--#include file="inc/md5.asp"-->
<!--#include file="inc/function.asp"-->
<%

Dim action,comeUrl
comeUrl =Request.Form("url")
action = Cint(Request.QueryString("a"))
If action=1 Then
	Dim userName,userPass
	userName 	= Replace(Trim(Request.Form("userName")),",","")
	userPass	=trim(Request("userPass"))
	If userName="" Or userPass="" Then
		Call ShowErrorInfo("用户名称和密码必须输入，请确认！",0)
	End If
	
	If Not CheckAccountOk(userName) Then
		Call ShowErrorInfo("用户名输入错误，请确认！",0)
	End If
	
	userPass=md5(userPass,32)
	
	Call OpenDataBase
	Set Rs=Conn.Execute("select id,mem_label,mem_pass,mem_nick,mem_label,mem_photo from BL_m_member_info where mem_is_del=0 and mem_name='"&userName&"'")
	If Not Rs.Eof Then
		If Rs("mem_pass")= userPass Then
			'========================
			'登录成功，更新用户相关资料
			'更新最后一次登录时间 和 用户综合积分
			Conn.Execute("update BL_m_member_info set mem_last_login=getdate(),mem_points=mem_weiwang+0.5*mem_gongxian where mem_name='"&userName&"'")
			'更新用户等级
			memPoints=Conn.Execute("select mem_points+mem_points_add from BL_m_member_info where mem_name='"&userName&"'")(0)
			memPoints=CLng(memPoints)
			If memPoints>100000 Then
				memLevel="大贤者"
			ElseIf memPoints>50000 Then
				memLevel="贤者"
			ElseIf memPoints>10000 Then
				memLevel="打桩机"
			ElseIf memPoints>5000 Then
				memLevel="火炮手"
			ElseIf memPoints>1000 Then
				memLevel="女性之友"
			ElseIf memPoints>600 Then
				memLevel="千人斩"
			ElseIf memPoints>300 Then
				memLevel="百人斩"
			ElseIf memPoints>100 Then
				memLevel="十人斩"
			Else
				memLevel="新手"
			End If
			Conn.Execute("update BL_m_member_info set mem_label='"&memLevel&"' where mem_name='"&userName&"'")
			'==========================
			'Response.Write("00000000000000<br />")
			strsql="select right_code from BL_m_right_info where ID in(select right_id from BL_m_group_right where group_id in(select group_id from BL_m_member_group m,BL_m_group_info g where g.group_state=1 and g.ID=m.group_id and mem_id ="&Rs("id")&"))"
			'Response.Write(strsql)
			Set PopRs=Conn.Execute(strsql)
			Dim PopStr,nickName
			'If PopRs.Eof Then
				'如果用户第一次登陆，则初始化
				'计算综合积分
			'	Conn.Execute()
			'End IF
			nickName=Rs("mem_nick")
			If nickName="" Then
				nickName =userName
			End If
			Do while Not PopRs.Eof
				PopStr=PopStr & "," & PopRs("right_code")
				PopRs.MoveNext
			Loop
			PopRs.Close
			Set PopRs = Nothing
			'Response.Write("["&PopStr&"]")
			If PopStr="" Then PopStr =G_YouKePopList
			'Response.Write("["&PopStr&"]")
			'Response.End()
			Session(G_SessionPre&"_Mem_ID") 	=Rs("id")
			Session(G_SessionPre&"_Mem_Name")	=userName
			Session(G_SessionPre&"_Mem_Pop")	=PopStr
			Session(G_SessionPre&"_Mem_Nick")	=nickName
			Session(G_SessionPre&"_Mem_Lable")	=memLevel
			If Len(Rs("mem_photo"))>5 Then
				Session(G_SessionPre&"_Mem_Photo")	=Rs("mem_photo")
			Else
				Session(G_SessionPre&"_Mem_Photo")	="images/img/noFace.jpg"
			End If

			If comeUrl<>"" Then
				Response.Redirect(comeUrl)
			Else
				Response.Redirect("index_tuijian.asp")
			End If
			'Response.Write(Session(G_SessionPre&"_Mem_Pop"))
		Else
			Call ShowErrorInfo("用户名或密码错误，请重新输入!","/login.asp")
		End If
	Else
		Call ShowErrorInfo("您输入的账号没有注册，请重新输入!","/login.asp")
	End If
	Rs.Close
	Set Rs = Nothing
End If
%>

