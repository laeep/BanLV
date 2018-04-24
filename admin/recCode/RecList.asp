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

Dim getAccount,useAccount,sqlWhere,ssql
getAccount = Request.Form("b")
useAccount = Request.Form("c")
action	   =Request.Form("action")

sqlWhere = Request("s")
If action=1 then sqlWhere=""
If sqlWhere="" Then
	sqlWhere = " 1=1"
	If getAccount<>"" Then
		sqlWhere = sqlWhere & " and b.mem_name = '"&getAccount&"'"
		CurrPage= 1
	End If
	If useAccount<>"" Then
		sqlWhere = sqlWhere & " and c.mem_name = '"&useAccount&"'"
		CurrPage=1
	End If
	'If sqlWhere = " 1=1"
End IF

sqlWhere=replace(sqlWhere,"_kongge_"," ")
sqlWhere=replace(sqlWhere,"_dian_",".")
sqlWhere=replace(sqlWhere,"_douhao_",",")
sqlWhere=replace(sqlWhere,"_dengyuhao_","=")
sqlWhere=replace(sqlWhere,"_baifenhao_","%")
sqlWhere=replace(sqlWhere,"_dayuhao_",">")
sqlWhere=replace(sqlWhere,"_xiaoyuhao_","<")
sqlWhere=replace(sqlWhere,"_danyinhao_","'")

Dim f_CountRecNum,f_PageNum
f_PageNum = 20

Call OpenDataBase  

f_CountRecNum = Conn.Execute("select count(a.id) from BL_s_rec_code_info a left join BL_m_member_info b on a.get_mem_id=b.ID left join BL_m_member_info c on a.use_mem_id=c.ID where"&sqlWhere)(0)
'Response.Write(f_CountRecNum)
'Response.End()
f_CountPageNum = JInt(f_CountRecNum,f_PageNum)
If CurrPage = 1 Then
	ssql = "select top "&f_PageNum&" a.id,a.code_str,b.mem_name as bmem,a.get_time,c.mem_name as cmem,a.use_time from BL_s_rec_code_info a left join BL_m_member_info b on a.get_mem_id=b.ID left join BL_m_member_info c on a.use_mem_id=c.ID where "&sqlWhere&" order by a.id desc"
Else
	ssql = "select top "&f_PageNum&" a.id,a.code_str,b.mem_name as bmem,a.get_time,c.mem_name as cmem,a.use_time from BL_s_rec_code_info a left join BL_m_member_info b on a.get_mem_id=b.ID left join BL_m_member_info c on a.use_mem_id=c.ID where a.id<(select min(id) from (select top "&Cstr(f_PageNum*(CurrPage-1))&" a.id as id from BL_s_rec_code_info a left join BL_m_member_info b on a.get_mem_id=b.ID left join BL_m_member_info c on a.use_mem_id=c.ID where "&sqlWhere&" order by a.id desc) as t) and "&sqlWhere&" order by a.id desc"
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
<title>列表</title>
<link href="../css/style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="../js/jquery.js"></script>
</head>

<body>
<div class="place"> <span>位置：</span>
  <ul class="placeul">
    <li>首页</li>
    <li>系统管理</li>
    <li>推荐码列表</li>
  </ul>
</div>
<div class="rightinfo">

  <form method="POST" action="" align="center"><input type="hidden" name="action" value="1" />
    <ul class="prosearch">
      <li>
        <label>查询：</label>
        <i>领取账号</i><a>
        <input id="b" name="b" type="text" class="scinput" value="<%=getAccount%>" />
        </a> <i>被推荐账号</i><a>
        <input id="c" name="c" type="text" class="scinput" value="<%=useAccount%>" />
        </a> <a>
        <input name="" type="submit" class="sure" value="查询"/>
        </a></li>
    </ul>
  </form>
  
  <table class="tablelist1">
    <thead>
      <tr>
        <th>ID</th>
        <th>推荐码</th>
        <th>领取账号</th>
        <th>领取时间</th>
        <th>使用账号</th>
        <th>使用时间</th>
        
      </tr>
    </thead>
    <tbody>
      <%
	Do While Not rec.Eof

	%>
      <tr>
      <td><%=rec("id")%></td>
        <td><%=rec("code_str")%></td>
        <td><%=rec("bmem")%></td>
        <td><%=rec("get_time")%></td>
        <td><%=rec("cmem")%></td>
        <td><%=rec("use_time")%></td>
       
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
	  sqlWhere=replace(sqlWhere,"'","_danyinhao_")
	  If sqlWhere="_kongge_1_dengyuhao_1" then sqlWhere=""
	 if CurrPage <> 1 then
	     response.write "<li class=""paginItem""><a href=Reclist.asp?s="&sqlWhere&"&page=1>第一页</a>&nbsp;&nbsp;</li>"
	     response.write "<li class=""paginItem""><a href=Reclist.asp?s="&sqlWhere&"&page="&(CurrPage-1)&">上一页</a>&nbsp;&nbsp;</li"
	 end if
	 if CurrPage <> f_CountPageNum then
	     response.write "<li class=""paginItem""><a href=Reclist.asp?s="&sqlWhere&"&page="&(CurrPage+1)&">下一页</a>&nbsp;&nbsp;</li>"
	     response.write "<li class=""paginItem""><a href=Reclist.asp?s="&sqlWhere&"&page="&f_CountPageNum&">最后一页</a>&nbsp;&nbsp;</li>"
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
