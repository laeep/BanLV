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
	'删除分组名称本身
	Conn.Execute("delete from BL_m_group_info where id ="&idList)
	'删除会员权限中的本分组ID
	Conn.Execute("delete from BL_m_member_group where group_id ="&idList)
	'删除本分组所关联的权限
	Conn.Execute("delete from BL_m_group_right where group_id ="&idList)
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


Call OpenDataBase
	
Dim f_CountRecNum,f_PageNum
f_PageNum = 20

f_CountRecNum = Conn.Execute("select count(id) from BL_m_group_info")(0)
f_CountPageNum = JInt(f_CountRecNum,f_PageNum)
If CurrPage = 1 Then
	ssql = "select top "&f_PageNum&" * from BL_m_group_info order by id desc"
Else
	ssql = "select top "&f_PageNum&" * from BL_m_group_info where id<(select min(id) from (select top "&Cstr(f_PageNum*(CurrPage-1))&" id from BL_m_group_info order by id desc) as t) order by id desc"
End If
Set rec= Conn.execute(ssql)            
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>分组列表</title>
<link href="../css/style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="../js/jquery.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	$(".cancel").click(function(){
  		$(".tip").fadeOut(100);
	});
	$(".tiptop a").click(function(){
	  $(".tip").fadeOut(200);
	});
});
function delGroupSure(f_groupId,f_page){
	$("#groupId").val(f_groupId);
	$("#page").val(f_page);
	$(".tip").fadeIn(200);
}
function delGroupOk(){
	var f_groupId=$("#groupId").val();
	var f_page =$("#page").val();
	location.href='groupList.asp?a=1&id='+f_groupId+'&page='+f_page;
}
</script>
</head>

<body>
<div class="place"> <span>位置：</span>
  <ul class="placeul">
    <li>首页</li>
    <li>系统管理</li>
    <li>分组列表</li>
  </ul>
</div>
<div class="rightinfo">
  <div class="tools">
    <ul class="toolbar">
      <li class="click" onclick="javascript:location.href='groupAdd.asp';"><span><img src="../images/t01.png" /></span>添加</li>
    </ul>
  </div>
  <table class="tablelist">
    <thead>
      <tr>
        <th>组编号</th>
        <th>组名</th>
        <th>分组状态</th>
        <th>用户操作</th>
      </tr>
    </thead>
    <tbody>
      <%
	Do While Not rec.Eof
		If rec("group_state")=0 Then
			ShowStateStr = "<font color='red'>失效</font>"
		Else
			ShowStateStr = "正常"
		End If
	%>
      <tr>
        <td><%=rec("id")%></td>
        <td><%=rec("group_name")%></td>
        <td><%=ShowStateStr%></td>
        <td><a class='tablelink' href='javascript:delGroupSure(<%=rec("id")%>,<%=CurrPage%>);'>删除</a>&nbsp;&nbsp;&nbsp;&nbsp;<a class='tablelink' href='groupadd.asp?action=1&id=<%=rec("id")%>'>修改</a>&nbsp;&nbsp;&nbsp;&nbsp;<a class='tablelink' href='grouprightset.asp?gN=<%=rec("group_name")%>&id=<%=rec("id")%>'>设置权限</a></td>
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
	  
	 if CurrPage <> 1 then
	     response.write "<li class=""paginItem""><a href=groupList.asp?page=1>第一页</a>&nbsp;&nbsp;</li>"
	     response.write "<li class=""paginItem""><a href=groupList.asp?page="&(CurrPage-1)&">上一页</a>&nbsp;&nbsp;</li>"
	 end if
	 if CurrPage <> f_CountPageNum then
	     response.write "<li class=""paginItem""><a href=groupList.asp?page="&(CurrPage+1)&">下一页</a>&nbsp;&nbsp;</li>"
	     response.write "<li class=""paginItem""><a href=groupList.asp?page="&f_CountPageNum&">最后一页</a>&nbsp;&nbsp;</li>"
	 end if
	  %>
    </ul>
  </div>
</div>
<div class="tip">
    <div class="tiptop"><span>提示信息</span><a></a></div>
    
  <div class="tipinfo">
    <span><img src="../images/ticon.png" /></span>
    <div class="tipright">
    <p>是否确认对此组进行删除？删除后无法恢复！</p>
    <cite>如果是请点击确定按钮 ，否则请点取消。</cite>
    </div>
    </div>
    
    <div class="tipbtn">
    <input name="groupId" id="groupId" type="hidden"  value="" /><input name="page" id="page" type="hidden"  value="" />
    <input name="" type="button"  class="sure" value="确定"  onclick="delGroupOk()"/>&nbsp;
    <input name="" type="button"  class="cancel" value="取消" />
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
