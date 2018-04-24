<%
Sub OpenDataBase
	Err.Clear
	'On Error Resume Next
	Set Conn = Server.CreateObject("ADODB.Connection")
	ConnStr="Provider=SQLOLEDB.1;Password=gjdnfnRj!#24gjdnfnRj!#24;Persist Security Info=True;User ID=QuanZi;Initial Catalog=51lf_database;Data Source=127.0.0.1"
	Conn.Open ConnStr
	If Err.Number<>0 Then
		Response.Write "<center>数据库连接错误</center>"
		Response.End
	End If
End Sub


'关闭数据库连接-
Sub connClose()
	If TypeName(Conn)="Connection" Then
		conn.close
		set conn = nothing
	end if 
End Sub
%>