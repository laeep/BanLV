<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="../inc/const.asp"-->
<!--#include file="../inc/conn.asp"-->
<!--#include file="../Session.asp" -->
<!--#include file="../inc/Function.asp" -->
<%
If Not JudgePower("P100003") Then Error1

Dim CurrPage


CurrPage=Request.QueryString("page")
If(Instr(1,CurrPage,"<")>0) Then
	Response.End
End If
If CurrPage="" Then 
	CurrPage=1
Else
	CurrPage = Cint(CurrPage)
	If CurrPage<1 Then
		CurrPage=1
	End If
End IF

Dim account,sqlWhere,ssql
account = Request.Form("account")
sqlWhere = Request("s")

If sqlWhere="" Then
	sqlWhere = " 1=1"
	If account<>"" Then
		sqlWhere = sqlWhere & " and username='"&account&"'"
	End If
End IF

sqlWhere=replace(sqlWhere,"_kongge_"," ")
sqlWhere=replace(sqlWhere,"_dian_",".")
sqlWhere=replace(sqlWhere,"_douhao_",",")
sqlWhere=replace(sqlWhere,"_dengyuhao_","=")
Call OpenDataBase
	
Dim f_CountRecNum,f_PageNum,zhifuresult
f_PageNum = 20

f_CountRecNum = Conn.Execute("select count(id) from BL_G_Log_login where"&sqlWhere)(0)
f_CountPageNum = JInt(f_CountRecNum,f_PageNum)
If CurrPage = 1 Then
	ssql = "select top "&f_PageNum&" * from BL_G_Log_login  where "&sqlWhere&" order by id desc"
Else
	ssql = "select top "&f_PageNum&" * from BL_G_Log_login where id<(select min(id) from (select top "&Cstr(f_PageNum*(CurrPage-1))&" id from BL_G_Log_login where "&sqlWhere&" order by id desc) as t) and "&sqlWhere&" order by id desc"
End If
Set rec= Conn.execute(ssql)            
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>用户列表</title>
<link href="../css/style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="../js/jquery.js"></script>

</head>

<body>
<div class="place"> <span>位置：</span>
  <ul class="placeul">
    <li>首页</li>
    <li>系统管理</li>
    <li>操作日志</li>
  </ul>
</div>
<div class="rightinfo">
<form method="POST" action="?page=1" align="center">
    <ul class="prosearch">
      <li>
        <label>查询：</label>
        <i>登录账号</i><a>
        <input name="account" type="text" class="scinput" />
        </a><a>
        <input name="" type="submit" class="sure" value="查询"/>
        </a></li>
    </ul>
  </form>
  
  <table class="tablelist">
    <thead>
      <tr>
      	<th>用户账号</th>
        <th>操作ＩＰ</th>
        <th>操作时间</th>
        <th>操作结果</th>
        <th>操作内容</th>
      </tr>
    </thead>
    <tbody>
      <%
	Do While Not rec.Eof
		If rec("loginok")="1" Then
			dataState="成功"
		Else
			dataState="<span style='color:red;'>失败</span>"
		End If

	%>
      <tr>
      	<td><%=rec("username")%></td>
        <td><%=rec("userip")%></td>
        <td><%=rec("logtime")%></td>
        <td><%=dataState%></td>
        <td><%=rec("operContent")%></td>
      </tr>
      <%
     	rec.MoveNext
	Loop

    %>
    </tbody>
  </table>
  <div class="pagin">
    <div class="message">共<i class="blue"><%=f_CountRecNum%></i>条记录，当前显示第&nbsp;<i class="blue"><%=CurrPage%>&nbsp;</i>页/共<i class="blue"><%=f_CountPageNum%></i>页</div>
    <ul class="paginList">
      <%
	  sqlWhere=replace(sqlWhere," ","_kongge_")
	  sqlWhere=replace(sqlWhere,".","_dian_")
	  sqlWhere=replace(sqlWhere,",","_douhao_")
	  sqlWhere=replace(sqlWhere,"=","_dengyuhao_")
	 if CurrPage <> 1 then
	     response.write "<li class=""paginItem""><a href=userAdminlog.asp?s="&sqlWhere&"&page=1>第一页</a>&nbsp;&nbsp;</li>"
	     response.write "<li class=""paginItem""><a href=userAdminlog.asp?s="&sqlWhere&"&page="&(CurrPage-1)&">上一页</a>&nbsp;&nbsp;</li>"
	 end if
	 if CurrPage <> f_CountPageNum then
	     response.write "<li class=""paginItem""><a href=userAdminlog.asp?s="&sqlWhere&"&page="&(CurrPage+1)&">下一页</a>&nbsp;&nbsp;</li>"
	     response.write "<li class=""paginItem""><a href=userAdminlog.asp?s="&sqlWhere&"&page="&f_CountPageNum&">最后一页</a>&nbsp;&nbsp;</li>"
	 end if
	  %>
    </ul>
  </div>
</div>
<script type="text/javascript">
	$('.tablelist tbody tr:odd').addClass('odd');
	</script>
</body>
</html>
<%
rec.close
set rec=nothing
Conn.close
set Conn=nothing
%>
