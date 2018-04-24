<%
Response.CodePage		=65001
Response.Charset		="UTF-8"
session.codepage		=65001

Response.Buffer   		=True    
Response.ExpiresAbsolute=Now()   -   1    
Response.Expires   		=0    
Response.CacheControl   ="no-cache"    
Response.AddHeader "Pragma","No-Cache" 
  
Dim ConnStr,Conn,ConnAcc,ConnBilling,ConnBound,ConnCenter
Const G_SiteName	= "后台管理系统"
Const G_SiteUrl 	= "http://www.51lf.net/login.asp"
Const G_AllowIP		= "10.226.37.41"
Const G_SessionPre 	= "BL"
Const G_LimitLogin 	= "0"	'0不限制登录IP，1限制登录IP
Const G_AdminDir	= "/admin/"
Const G_XuniDir		= ""
Const G_CommMemID	= "10207"'后台分享模拟前台账号的ID
%>