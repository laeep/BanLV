<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="../inc/const.asp"-->
<!--#include file="../inc/conn.asp"-->
<!--#include file="../Session.asp" -->
<!--#include file="../inc/Function.asp" -->
<!--#include file="../inc/md5.asp" -->
<%
If Not JudgePower("admin") Then Error1
Dim act,adminId
adminId = Request("id")
act=Request.Form("action")
If act="1" Then
	Dim adImg,adLink
	adImg = Request.Form("adImg")
	adLink = Request.Form("adLink")
	Call OpenDataBase
	If adminId="" Then
		If adImg="" or adLink="" Then
			Call ShowErrorInfo("图片和链接地址都必须输入！",0)
		End IF
		Conn.execute("insert into BL_s_ad_info(ad_img_url,ad_link_url) values('"&adImg&"','"&adLink&"')") 
		Call ShowErrorInfo("添加成功！","adList.asp")
	Else
		Conn.Execute("update BL_s_ad_info set ad_img_url='"&adImg&"',ad_link_url='"&adLink&"' where id="&adminId)
		Call ShowErrorInfo("修改成功！","adList.asp")
	End If
	Application("topAdLink")=adLink
	Application("topAdUrl")=adImg
Else
	If adminId<>"" Then
		Call OpenDataBase
		Set adminRs=Conn.Execute("select * from BL_s_ad_info where id=" & adminId)
		If Not adminRs.Eof Then
			adImg = adminRs("ad_img_url")
			adLink	= adminRs("ad_link_url")
			pageTitle	="修改广告"
		Else
			Call ShowErrorInfo("非法操作！","adList.asp")
		End If
		Call connClose
	Else
		pageTitle	="添加广告"
	End If
	Application("topAdLink")=adLink
	Application("topAdUrl")=adImg
End IF           
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=pageTitle%></title>
<link href="../css/style.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" href="../kindeditor/themes/default/default.css" />
<script type="text/javascript" src="../js/jquery.js"></script>
<script charset="utf-8" src="../kindeditor/kindeditor.js"></script>
<script charset="utf-8" src="../kindeditor/lang/zh_CN.js"></script>
<script>
$(function () {
	
	KindEditor.ready(function(K) {
		var editor = K.editor({
			uploadJson : '../kindeditor/asp/upload_json.asp',
            fileManagerJson : '../kindeditor/asp/file_manager_json.asp',
			allowFileManager : true
			
		});
		K('#image').click(function() {
			editor.loadPlugin('image', function() {
				editor.plugin.imageDialog({
					imageUrl : K('#adImg').val(),
					clickFn : function(url, title, width, height, border, align) {
						K('#adImg').val(url);
						editor.hideDialog();
					}
				});
			});
		});
		
	});
});
</script>
</head>

<body>
<div class="place"> <span>位置：</span>
  <ul class="placeul">
    <li>首页</li>
    <li>系统管理</li>
    <li>广告管理</li>
  </ul>
</div>
<div class="formbody">
  <div class="formtitle"><span><%=pageTitle%></span></div>
  <ul class="forminfo">
    <form action="" method="post">
      <input type="hidden" name="action" value="1" />
      <li>
        <label>链接地址</label>
        <input name="adLink" type="text" class="dfinput" value="<%=adLink%>"/>（格式：http://www.xxx.com）
      </li>
      <li>
        <label>广告图片</label>
        <input name="adImg" id="adImg" type="text" class="dfinput" value="<%=adImg%>" />&nbsp;<input type="button" id="image" class="btn" value="选择图片" /></td>
      </li>
      
      <li>
        <label>&nbsp;</label>
        <input name="" type="submit" class="btn" value="保存"/>
      </li>
    </form>
  </ul>
</div>
</body>
</html>
