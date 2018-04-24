<!--#include file="inc/Const.asp"-->
<!--#include file="inc/Conn.asp"-->
<!--#include file="inc/md5.asp"-->
<!--#include file="inc/function.asp"-->
<%



Call OpenDataBase
dim sql
dim rs
dim username
dim password,savePass
username=replace(trim(request("username")),"'","")
password=trim(Request("password"))
savePass=request.Form("savePass")
If savePass="1" Then
	Response.Cookies("JR_AD")("UserName") = username
	Response.Cookies("JR_AD")("UserPass") = password
	Response.Cookies("JR_AD").Expires= DateAdd("m",60,now()) 
Else
	Response.Cookies("JR_AD")("UserName") = ""
	Response.Cookies("JR_AD")("UserPass") = ""
End If
password=md5(password,32)

If G_LimitLogin="1" Then
	If Instr(1,G_AllowIP,GetCustIp)=0 Then 
		Call ShowErrorInfo("异常！",0)
	End If
End IF
If request("verifycode")="" Then
	Call ShowErrorInfo("您没有输入确认码，请返回！",0)
ElseIf LCase(session("verifycode"))<>LCase(trim(request("verifycode"))) Then
	Call ShowErrorInfo("您输入的确认码和系统产生的不一致，请重新输入!",0)
End If 
Set rs=Server.CreateObject("adodb.recordset")
sql="select ID,UserName,Password,popLevel from BL_G_Admin_User where UserName='"&username&"' and flag=1"
rs.open sql,Conn,1,1
If not(rs.bof and rs.eof) Then
	'Response.Write(password & "|" &rs("password"))
	'Response.End()
	If LCase(password)=LCase(rs("password")) Then
		Session(G_SessionPre&"_Admin_ID") =rs("id")
		Session(G_SessionPre&"_Admin_Name")=rs("UserName")
		Session(G_SessionPre&"_Admin_Pop")=rs("popLevel")
		rs.Close
		Set rs = Nothing
		Conn.Execute("insert into BL_G_Log_login(username,userip,loginok) values('"&Session(G_SessionPre&"_Admin_Name")&"','"&GetCustIp&"',1)")
		Call connClose
		Response.Redirect "manage.asp"
	else
		Conn.Execute("insert into BL_G_Log_login(username,userip,loginok) values('"&username&"','"&GetCustIp&"',0)")
		rs.Close
		Set rs = Nothing
		Call ShowErrorInfo("用户名或密码错误，请重新输入!",0)
	end If
else
	rs.Close
	Set rs = Nothing
	Call ShowErrorInfo("用户名错误或者你的帐号已被停止使用!",0)
end If 
%>

