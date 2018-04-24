<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="../inc/const.asp"-->
<!--#include file="../inc/conn.asp"-->
<!--#include file="../Session.asp" -->
<!--#include file="../inc/Function.asp" -->
<%
If Not JudgePower("admin") Then Error1

Dim CurrPage

Dim action,idList
action=request.QueryString("a")
idList = request.QueryString("id")
If action="1" Then
	Call OpenDataBase
	Conn.Execute("delete from BL_G_Admin_User where id in("&idList&")")
	Call connClose
End IF
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

f_CountRecNum = Conn.Execute("select count(id) from BL_G_Admin_User where"&sqlWhere)(0)
f_CountPageNum = JInt(f_CountRecNum,f_PageNum)
If CurrPage = 1 Then
	ssql = "select top "&f_PageNum&" * from BL_G_Admin_User  where "&sqlWhere&" order by id desc"
Else
	ssql = "select top "&f_PageNum&" * from BL_G_Admin_User where id<(select min(id) from (select top "&Cstr(f_PageNum*(CurrPage-1))&" id from BL_G_Admin_User where "&sqlWhere&" order by id desc) as t) and "&sqlWhere&" order by id desc"
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
<script language="javascript" type="text/javascript">
$(function () {
	$("#Select").click(function(){    
		if(this.checked){    
			$(".selectId").prop("checked", true);   
		}else{    
			$(".selectId").prop("checked", false); 
		}    
	});  

});
function modify()
{
	var chk_value =[]; 
	$('input[name="id"]:checked').each(function(){ 
		chk_value.push($(this).val()); 
	}); 
	if(chk_value.length==0){
		alert('请选择一个账号再进行操作！');
		return false;
	}
	if(chk_value.length>1){
		alert('修改只能选择一个进行操作！');
		return false;
	}
	location.href='useradminadd.asp?id='+chk_value;
}
function del()
{
	var chk_value =[]; 
	$('input[name="id"]:checked').each(function(){ 
		chk_value.push($(this).val()); 
	}); 
	if(chk_value.length==$('input[name="id"]').length)
	{
		alert("要不得，全部删除了就木有账号可以登录了！");
		return false;
	}
	if(chk_value.length==0){
		alert('请选择一个账号再进行操作！');
		return false;
	}
	if(confirm("确定要删除选中的账号吗？"))
	{
		location.href='useradminList.asp?a=1&id='+chk_value;
	}
	
}

</script>
</head>

<body>
<div class="place"> <span>位置：</span>
  <ul class="placeul">
    <li>首页</li>
    <li>系统管理</li>
    <li>用户列表</li>
  </ul>
</div>
<div class="rightinfo">

  <div class="tools">
    
    	<ul class="toolbar">
        <li class="click" onclick="javascript:location.href='userAdminAdd.asp';"><span><img src="../images/t01.png" /></span>添加</li>
        <li class="click" onclick="modify();"><span><img src="../images/t02.png" /></span>修改</li>
        <li class="click" onclick="del();"><span><img src="../images/t03.png" /></span>删除</li>
        </ul>
        
    </div>
 
  <table class="tablelist">
    <thead>
      <tr>
      	<th><input name="Select" id="Select" type="checkbox" />全选</th>
        <th>用户账号</th>
        <th>用户状态</th>
        <th>用户权限</th>
      </tr>
    </thead>
    <tbody>
      <%
	Do While Not rec.Eof
		If rec("flag")="1" Then
			dataState="正常"
		Else
			dataState="<span style='color:red;'>锁定</span>"
		End If

		If rec("popLevel")="admin" Then
			userPop="<span style='color:red;'>管理员</span>"
		Else
			userPop="录入权限"
		End If
	%>
      <tr>
      	<td><input name="id" class="selectId" type="checkbox" value="<%=rec("id")%>" />&nbsp;&nbsp;<%=rec("id")%></td>
        <td><%=rec("username")%></td>
        <td><%=dataState%></td>
        <td ><%=userPop%></td>
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
	     response.write "<li class=""paginItem""><a href=userAdminList.asp?s="&sqlWhere&"&page=1>第一页</a>&nbsp;&nbsp;</li>"
	     response.write "<li class=""paginItem""><a href=userAdminList.asp?s="&sqlWhere&"&page="&(CurrPage-1)&">上一页</a>&nbsp;&nbsp;</li>"
	 end if
	 if CurrPage <> f_CountPageNum then
	     response.write "<li class=""paginItem""><a href=userAdminList.asp?s="&sqlWhere&"&page="&(CurrPage+1)&">下一页</a>&nbsp;&nbsp;</li>"
	     response.write "<li class=""paginItem""><a href=userAdminList.asp?s="&sqlWhere&"&page="&f_CountPageNum&">最后一页</a>&nbsp;&nbsp;</li>"
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
