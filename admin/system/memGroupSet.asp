<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="../inc/const.asp"-->
<!--#include file="../inc/conn.asp"-->
<!--#include file="../Session.asp" -->
<!--#include file="../inc/Function.asp" -->
<!--#include file="../inc/md5.asp" -->
<%
If Not JudgePower("admin") Then Error1
Dim act,memId,memName
memName=Request.QueryString("mN")
memId = Request("id")
act=Request.Form("action")
If act="1" Then
	Dim groupIdList
	groupIdList = Request.Form("groupIdList")
	'Response.Write(groupIdList)
	Call OpenDataBase
	If groupIdList="" Then
		Call ShowErrorInfo("至少要选择一个权限组！",0)
	Else
		'清除以前的组别
		Conn.Execute("delete from BL_m_member_group where mem_id="&memId)
		Dim groupIdArray
		groupIdArray = split(groupIdList,",")
		For i = 0 to UBound(groupIdArray)
			Conn.Execute("insert into BL_m_member_group(mem_id,group_id) values("&memId&","&groupIdArray(i)&")")
		Next
		Call ShowErrorInfo("设置成功！","memList.asp")
	End If
Else
	If memId="" Then
		Call ShowErrorInfo("非法操作！","memList.asp")
	End If
End IF           
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>设置组别</title>
<link href="../css/style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="../js/jquery.js"></script>
<script language="javascript" type="text/javascript">
function  CA()
{
if($("#Select").attr("checked")=='checked')
	$("#id").attr("checked",true);
else
	$("#id").attr("checked",false);
}

</script>
</head>

<body>
<div class="place"> <span>位置：</span>
  <ul class="placeul">
    <li>首页</li>
    <li>系统管理</li>
    <li>设置组别</li>
  </ul>
</div>
<div class="mainbox">
  <div class="mainleft"><!--leftinfo end-->
    
    <div>
      <div class="listtitle">组别设置</div>
      <div class="maintj">
        <form method="post" action=""><input name="id" value="memId" type="hidden" />
        <input name="action" value="1" type="hidden" />
        <table width="100%" border="1" cellspacing="1" cellpadding="1">
          <tr>
            <td width="50%" style="border:1px #ccc solid;">会员名称</td>
            <td style="border:1px #ccc solid; padding:10px 10px; text-align:left;">组别名称</td>
          </tr>
          <tr>
            <td width="50%" style="border:1px #ccc solid;"><%=memName%></td>
            <td style="border:1px #ccc solid; padding:10px 10px; text-align:left;"><%
            Call OpenDataBase
			Set groupRs=Conn.Execute("select ID,group_name,1 as flag from dbo.BL_m_group_info where id in(select group_ID from BL_m_member_group where mem_id="&memId&") union select ID,group_name,0 as flag from dbo.BL_m_group_info where id not in(select group_ID from BL_m_member_group where mem_id="&memId&") order by id")
			Do While Not groupRs.Eof
				If groupRs("flag")=0 Then
					Response.Write("<div class=""taee""><input type=""checkbox"" name=""groupIdList"" value="""&groupRs("id")&"""/>"&groupRs("group_name")&"</div><br />")
				Else
					Response.Write("<div class=""taee""><input type=""checkbox"" name=""groupIdList"" value="""&groupRs("id")&""" checked />"&groupRs("group_name")&"</div><br />")
				End If
				groupRs.MoveNext
			Loop
			Call connClose
			%></td>
          </tr>
          <tr>
            <td width="100%" height="70" style="border:1px #ccc solid;" colspan="2"><input name="" type="submit" class="btn" value="提交"/></td>
          </tr>
        </table>
        </form>
      </div>
    </div>
  </div>
</div>
</div>
</body>
</html>
