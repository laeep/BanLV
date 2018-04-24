<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="../inc/const.asp"-->
<!--#include file="../inc/conn.asp"-->
<!--#include file="../Session.asp" -->
<!--#include file="../inc/Function.asp" -->
<%
If Not JudgePower("admin") Then Error1

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

Dim memName,memMobile,sqlWhere,ssql
memName = Request.Form("memName")
memMobile = Request.Form("memMobile")

sqlWhere = Request("s")
If sqlWhere="" Then
	sqlWhere = " 1=1"
	If memName<>"" Then
		sqlWhere = sqlWhere & " and mem_name like '%"&memName&"%'"
	End If
	If memMobile<>"" Then
		sqlWhere = sqlWhere & " and mem_mobile='"&memMobile&"'"
	End If
End IF

sqlWhere=replace(sqlWhere,"_kongge_"," ")
sqlWhere=replace(sqlWhere,"_dian_",".")
sqlWhere=replace(sqlWhere,"_douhao_",",")
sqlWhere=replace(sqlWhere,"_dengyuhao_","=")
sqlWhere=replace(sqlWhere,"_baifenhao_","%")
sqlWhere=replace(sqlWhere,"_dayuhao_",">")
sqlWhere=replace(sqlWhere,"_xiaoyuhao_","<")

Dim f_CountRecNum,f_PageNum
f_PageNum = 20

Call OpenDataBase  

f_CountRecNum = Conn.Execute("select count(id) from BL_m_member_info where"&sqlWhere)(0)
f_CountPageNum = JInt(f_CountRecNum,f_PageNum)
If CurrPage = 1 Then
	ssql = "select top "&f_PageNum&" * from BL_m_member_info where "&sqlWhere&" order by id desc"
Else
	ssql = "select top "&f_PageNum&" * from BL_m_member_info where id<(select min(id) from (select top "&Cstr(f_PageNum*(CurrPage-1))&" id from BL_m_member_info where "&sqlWhere&" order by id desc) as t) and "&sqlWhere&" order by id desc"
End If
'Response.Write(ssql)
Set rec= Conn.execute(ssql)   
     
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<META HTTP-EQUIV="Pragma"  CONTENT="no-cache">    
<META HTTP-EQUIV="Cache-Control" CONTENT="no-cache">    
<META HTTP-EQUIV="Expires" CONTENT="0">  
<title>会员列表</title>
<link href="../css/style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="../js/jquery.js"></script>
</head>

<body>
<div class="place"> <span>位置：</span>
  <ul class="placeul">
    <li>首页</li>
    <li>系统管理</li>
    <li>会员列表</li>
  </ul>
</div>
<div class="rightinfo">

  <form method="POST" action="?t=<%=countType%>" align="center">
    <ul class="prosearch">
      <li>
        <label>查询：</label>
        <i>会员名称</i><a>
        <input id="memName" name="memName" type="text" class="scinput" value="<%=memName%>" />
        </a> <i>会员手机</i><a>
        <input id="memMobile" name="memMobile" type="text" class="scinput" value="<%=memMobile%>" />
        </a> <a>
        <input name="" type="submit" class="sure" value="查询"/>
        </a></li>
    </ul>
  </form>
  
  <table class="tablelist1">
    <thead>
      <tr>
        <th>会员名称</th>
        <th>会员手机</th>
        <th>综合积分</th>
        <th>会员邮件</th>
        <th>会员头衔</th>
        <th>会员注册时间</th>
        <th>最后登录时间</th>
        <th>操作</th>
      </tr>
    </thead>
    <tbody>
      <%
	Do While Not rec.Eof 
	%>
      <tr>
        <td><%=rec("mem_name")%></td>
        <td><%=rec("mem_mobile")%></td>
        <td><%=Clng(rec("mem_points"))+Clng(rec("mem_points_add"))%></td>
        <td><%=rec("mem_email")%></td>
        <td><%=rec("mem_label")%></td>
        <td><%=rec("mem_join_time")%></td>
        <td><%=rec("mem_last_login")%></td>
        <td><a class='tablelink' href='memGroupSet.asp?id=<%=rec("id")%>&mN=<%=rec("mem_name")%>'>设置组别</a></td>
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
	  sqlWhere=replace(sqlWhere,"%","_baifenhao_")
	  sqlWhere=replace(sqlWhere,">","_dayuhao_")
	  sqlWhere=replace(sqlWhere,"<","_xiaoyuhao_")
	  
	 if CurrPage <> 1 then
	     response.write "<li class=""paginItem""><a href=memlist.asp?s="&sqlWhere&"&page=1>第一页</a>&nbsp;&nbsp;</li>"
	     response.write "<li class=""paginItem""><a href=memlist.asp?s="&sqlWhere&"&page="&(CurrPage-1)&">上一页</a>&nbsp;&nbsp;</li"
	 end if
	 if CurrPage <> f_CountPageNum then
	     response.write "<li class=""paginItem""><a href=memlist.asp?s="&sqlWhere&"&page="&(CurrPage+1)&">下一页</a>&nbsp;&nbsp;</li>"
	     response.write "<li class=""paginItem""><a href=memlist.asp?s="&sqlWhere&"&page="&f_CountPageNum&">最后一页</a>&nbsp;&nbsp;</li>"
	 end if
	  %>
      
    </ul>
  </div>
</div>
<script type="text/javascript">
	$('.tablelist1 tbody tr:odd').addClass('odd');
	</script>
</body>
</html>
<%
rec.close
set rec=nothing
Call connClose
%>
