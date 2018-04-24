<!--#include file="inc/Const.asp"-->
<%
	Session(G_SessionPre&"_Admin_ID") =""
	Session(G_SessionPre&"_Admin_Name")=""
	Response.Redirect "login.asp"
%>