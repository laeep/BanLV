<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%
Response.CodePage		=65001
Response.Charset		="UTF-8"
session.codepage		=65001

Response.Buffer   		=True    
Response.ExpiresAbsolute=Now()   -   1    
Response.Expires   		=0    
Response.CacheControl   ="no-cache"    
Response.AddHeader "Pragma","No-Cache" 
  
Dim ConnStr,Conn

Const G_SessionPre 	= "BL"
Const G_YouKePopList= ",P000010,P000011,P010005,P020010,P030001"
Const G_Website_Dir = ""
%>