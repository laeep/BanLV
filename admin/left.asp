<!--#include file="inc/Const.asp"-->
<!--#include file="inc/Conn.asp"-->
<!--#include file="Session.asp" -->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>无标题文档</title>
<link href="css/style.css" rel="stylesheet" type="text/css" />
<script language="JavaScript" src="js/jquery.js"></script>
<script type="text/javascript">
$(function(){	
	//导航切换
	$(".menuson .header").click(function(){
		var $parent = $(this).parent();
		$(".menuson>li.active").not($parent).removeClass("active open").find('.sub-menus').hide();
		
		$parent.addClass("active");
		if(!!$(this).next('.sub-menus').size()){
			if($parent.hasClass("open")){
				$parent.removeClass("open").find('.sub-menus').hide();
			}else{
				$parent.addClass("open").find('.sub-menus').show();	
			}
		}
	});
	
	// 三级菜单点击
	$('.sub-menus li').click(function(e) {
        $(".sub-menus li.active").removeClass("active")
		$(this).addClass("active");
    });
	
	$('.title').click(function(){
		var $ul = $(this).next('ul');
		$('dd').find('.menuson').slideUp();
		if($ul.is(':visible')){
			$(this).next('.menuson').slideUp();
		}else{
			$(this).next('.menuson').slideDown();
		}
	});
	$("a").attr("target","rightFrame");
})	
</script>
</head>

<body style="background:#f0f9fd;">
<div class="lefttop"><span></span><%=G_SiteName%></div>
<dl class="leftmenu">
<%
Call OpenDataBase
Function ReadMenuData(f_parentId,f_level)
	Dim menuRs,navPicStr
	Dim MenuStr
	Set menuRs = Conn.Execute("select * from BL_G_MenuClass where MenuHideFlag=0 and MenuParentID="&f_parentId&" and MenuLevel="&f_level&" order by MenuOrder asc")
	Do While Not menuRs.Eof
		
		If f_level = 1 Then
			If JudgePower(menuRs("MenuPop")) Then
				If IsNull(menuRs("MenuPicUrl")) Then navPicStr="images/leftico01.png" else navPicStr=menuRs("MenuPicUrl")
				MenuStr = MenuStr & "<dd><div class=""title""> <span><img src="""&navPicStr&""" /></span>"&menuRs("MenuName")&"</div>"
				MenuStr = MenuStr & ReadMenuData(menuRs("id"),2)
				MenuStr = MenuStr & "</dd>"
			End If
		ElseIf f_level = 2 Then
			If JudgePower(menuRs("MenuPop")) Then
				MenuStr = MenuStr & "<li><cite></cite><a href="""&menuRs("MenuLink")&""">"&menuRs("MenuName")&"</a><i></i></li>"
			End IF
		End If
		menuRs.MoveNext
	Loop
	If f_level = 2 and MenuStr<>"" Then
		MenuStr = " <ul class=""menuson"">" & MenuStr & "</ul>"
	End IF
	menuRs.Close
	Set menuRs = Nothing
	ReadMenuData = MenuStr
End Function

Response.Write(ReadMenuData(0,1))
Call connClose
%>
</dl>
</body>
</html>
