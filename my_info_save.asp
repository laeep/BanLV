<!--#include file="inc/Const.asp"-->
<!--#include file="inc/Conn.asp"-->
<!--#include file="inc/md5.asp"-->
<!--#include file="inc/function.asp"-->
<%
If Session(G_SessionPre&"_Mem_ID")="" or isnull(Session(G_SessionPre&"_Mem_ID")) Then
	Response.Write(12)
	Response.End()
End If
Dim pass1,pass2,oldPass,newPass,imgBase64,userNick,mobileNo,eMail
pass1	=Request.Form("pass1")
pass2	=Request.Form("pass2")
oldPass	=Request.Form("oldPass")
imgBase64=unescape(Request.Form("base64_string"))
userNick=lostDangerChar(Request.Form("mem_nick"))
mobileNo=Request.Form("mem_mobile")
eMail	=Request.Form("mem_email")


'Call WriteFile("2222.txt",PostInfoStr)

'For i = 0 to Ubound(PostDataArr)
'	PostUnitDataArr = Split(PostDataArr(i),"=")
'	j=Ubound(PostUnitDataArr)
'	Do while j>1
'		PostUnitDataArr(1)=PostUnitDataArr(1)&"="
'		j=j-1
'	Loop
'	dictParaValue.add PostUnitDataArr(0),PostUnitDataArr(1)
'Next
Call OpenDataBase
If pass1<>"" And pass2<>"" And oldPass<>"" Then
	'更新密码
	If pass1=pass2 Then
		oldPass = md5(oldPass,32)
		Set PsRs=Conn.Execute("select mem_pass from BL_m_member_info where id="&Session(G_SessionPre&"_Mem_ID"))
		If Not PsRs.Eof Then
			newPass = md5(pass1,32)
			If LCase(PsRs("mem_pass"))=LCase(oldPass) Then
				Conn.Execute("update BL_m_member_info set mem_pass='"&newPass&"' where id="&Session(G_SessionPre&"_Mem_ID"))
			Else
				Response.Write(11)'原密码错误
				PsRs.Close
				Set PsRs = Nothing
				Call connClose
				Response.End()
			End If
		Else
			Response.Write(12)'请重新登录
			PsRs.Close
			Set PsRs = Nothing
			Call connClose
			Response.End()
		End If
		PsRs.Close
		Set PsRs = Nothing
	Else
		Response.Write(13)'两次输入的密码不一致
		Call connClose
		Response.End()
	End If
End IF

'检测昵称，并更新
If userNick<>"" Then
	Set NickRs=Conn.Execute("Select id from BL_m_member_info where mem_nick='"&userNick&"' and id<>"& Session(G_SessionPre&"_Mem_ID"))
	If NickRs.Eof Then
		Conn.Execute("update BL_m_member_info set mem_nick='"&userNick&"' where id=" & Session(G_SessionPre&"_Mem_ID"))
		Session(G_SessionPre&"_Mem_Nick")	=userNick
	Else
		Response.Write(14)'昵称已经存在，请更换
		Call connClose
		Response.End()
	End If
	NickRs.Close
	Set NickRs = Nothing
End If
'更新头像
If Instr(1,Lcase(imgBase64),"base64")>0 Then
	path=Replace(Now()," ","")
	path=Replace(path,"/","")
	path=Replace(path,"-","")
	path=Replace(path,":","")
	path= "userFace/" & Session(G_SessionPre&"_Mem_ID") & path &  ".jpg"'    ‘’‘’‘图片保存路径
	'Call WriteFile("2222.txt",imgBase64)
	Call saveImg(path,imgBase64)
	Conn.Execute("update BL_m_member_info set mem_photo='"&path&"' where id="& Session(G_SessionPre&"_Mem_ID"))
	Session(G_SessionPre&"_Mem_Photo")	=path
End If
Conn.Execute("update BL_m_member_info set mem_mobile='"&mobileNo&"',mem_email='"&eMail&"' where id="& Session(G_SessionPre&"_Mem_ID"))

Call connClose
'For Each key in dictParaValue
'	Call WriteFile("111111.txt",key & "：" & dictParaValue(key))
	'Select Case key
	'	Case "base64_string"
		
	'	Case "pass1"
	'	Case "pass1"
	'	Case "oldPass"
	'		oldPass = dictParaValue(key)
	'	Case Else
		
	'End Select
'Next
response.Write("0") 
'Response.End()
'd.Add "re","Red"
'd.Add "gr","Green"
'd.Add "bl","Blue"
'd.Add "pi","Pink"
'Response.Write("The value of key bl is: " & d.Item("bl"))


'Call WriteFile("111111.txt",content)



'Dim a
'a=request.Form("basestr")
'Response.Write(a)
'

%>