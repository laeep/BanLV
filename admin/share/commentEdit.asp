<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="../inc/const.asp"-->
<!--#include file="../inc/conn.asp"-->
<!--#include file="../Session.asp" -->
<!--#include file="../inc/Function.asp" -->
<!--#include file="../inc/md5.asp" -->
<%
If Not JudgePower("admin") Then Error1
Dim act,comId
comId = Request("id")
act=Request.Form("action")
If act="1" Then
	Dim Desc
	Desc = Request.Form("Desc")
	
	Call OpenDataBase
	If comId<>"" Then
		
		If Desc<>"" Then
			Conn.Execute("update BL_s_goods_comment_info set comment_desc='" & Desc & "' where id="&comId)
			Call ShowErrorInfo("修改成功！","sharelist.asp")
		
		End IF
	End If
Else
	If comId<>"" Then
		Call OpenDataBase
		Set adminRs=Conn.Execute("select * from BL_s_goods_comment_info where id=" & comId)
		If Not adminRs.Eof Then
			Desc = adminRs("comment_desc")
		Else
			Call ShowErrorInfo("非法操作！","sharelist.asp")
		End If
		Call connClose
	End If
End IF           
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>评论修改</title>
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
    <li>评论管理</li>
    <li>评论修改</li>
  </ul>
</div>
<div class="formbody">
  <div class="formtitle"><span><%=pageTitle%></span></div>
  <ul class="forminfo">
    <form action="" method="post">
      <input type="hidden" name="action" value="1" />
      <li>
        <label>评论内容</label>
        <textArea name="Desc" style="width:500px;height:150px; border:solid 1px #006699;"><%=Desc%></textArea>
       
      </li>
      
        <label>&nbsp;</label>
        <input name="" type="submit" class="btn" value="保存"/>
      </li>
    </form>
  </ul>
</div>
</body>
</html>
