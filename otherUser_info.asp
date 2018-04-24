<!--#include file="inc/Const.asp"-->
<!--#include file="inc/Conn.asp"-->
<!--#include file="inc/Session.asp"-->
<!--#include file="inc/function.asp"-->
<%
Call IsLogin
If Not JudgePower("P010001") Then Error1("您没有查看其他用户信息的权限！")
Dim memId
memId=Request.QueryString("id")
If memId<>"" Then
	memId=CInt(memId)
Else
	Call ShowErrorInfo("非法操作！",0)
End If
Call OpenDataBase
Set memRs=Conn.Execute("select *,mem_points+mem_points_add as mem_allPoints from BL_m_member_info where mem_is_del=0 and id="&memId)
If memRs.Eof Then
	Call ShowErrorInfo("账号不存在，返回！",0)
End If
%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8" />
		<meta name="viewport" content="width=device-width,initial-scale=1.0,user-scalable=no">
		<meta name="format-detection" content="telephone=no">
		<title>用户资料</title>
		<link rel="stylesheet" type="text/css" href="css/style.css"/>
	</head>
	<body>
		
		<header class="head-go"><a href="javascript:history.back();" class="fanhui"></a>
			用户资料
		</header>
		<article class="user">
				
				<div class="row user-toubu" style="background: none;">
					<div class="toux"><img src="<%=memRs("mem_photo")%>"></div>
				</div>
				
				<div class="row margin-t15">
					<div class="col-6">
						<label>用户名：</label>
					</div>
					<div class="col-6">
						<%=memRs("mem_nick")%>
					</div>
				</div>
				<div class="row">
					<div class="col-6">
						<label>用户ID：</label>
					</div>
					<div class="col-6">
						<%=memRs("id")%>
					</div>
				</div>
				<div class="row">
					<div class="col-6">
						<label>头衔：</label>
					</div>
					<div class="col-6">
						<%=memRs("mem_label")%>
					</div>
				</div>
				<hr style="margin-top: 0px; margin-bottom: 10px;">
				<div class="row">
					<div class="col-6">
						<label>综合积分：</label>
					</div>
					<div class="col-6">
						<%=memRs("mem_allPoints")%>
					</div>
				</div>
				<div class="row">
					<div class="col-6">
						<label>发布分享：</label>
					</div>
					<div class="col-6">
						<%=memRs("mem_share_num")%>
					</div>
				</div>
				<div class="row">
					<div class="col-6">
						<label>发布举报：</label>
					</div>
					<div class="col-6">
						<%=memRs("mem_jubao_num")%>
					</div>
				</div>
				<div class="row">
					<div class="col-6">
						<label>发布评论：</label>
					</div>
					<div class="col-6">
						<%=memRs("mem_comment_num")%>
					</div>
				</div>
				<div class="row">
					<div class="col-6">
						<label>威望：</label>
					</div>
					<div class="col-6">
						<%=memRs("mem_weiwang")%>
					</div>
				</div>
				<div class="row">
					<div class="col-6">
						<label>贡献值：</label>
					</div>
					<div class="col-6">
						<%=memRs("mem_gongxian")%>
					</div>
				</div>
				
				<hr style="margin-top: 0; margin-bottom: 10px;">
				<div class="row">
					<div class="col-6">
						<label>注册时间：</label>
					</div>
					<div class="col-6">
						<%=formatdatetime(memRs("mem_join_time"),2)%>
					</div>
				</div>
				<div class="row">
					<div class="col-6">
						<label>最后登录：</label>
					</div>
					<div class="col-6">
						<%=formatdatetime(memRs("mem_last_login"),2)%>
					</div>
				</div>
				<hr style="margin-top: 0; margin-bottom: 10px;">

		</article>
<div style="display:none;"><script src="https://s22.cnzz.com/z_stat.php?id=1262562117&web_id=1262562117" language="JavaScript"></script></div>
	</body>
</html>
<%
memRs.Close
Set memRs = Nothing
Call connClose
%>
