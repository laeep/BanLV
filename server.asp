<!--#include file="inc/Const.asp"-->
<!--#include file="inc/Conn.asp"-->
<!--#include file="inc/Session.asp"-->
<!--#include file="inc/Function.asp"-->
<%
Dim action,exeSql,retString,goodsId
action = Request("a")

If action=1 Then '签到
	If Session(G_SessionPre&"_Mem_ID")="" or IsNull(Session(G_SessionPre&"_Mem_ID")) Then
		Response.Write(1)'未登录
		Response.End()
	Else
		Call OpenDataBase
		Set signRs=Conn.Execute("select id from BL_r_sign_log where datediff(day,insert_time,getdate())=0 and mem_id="&Session(G_SessionPre&"_Mem_ID"))
		If signRs.Eof Then
			Conn.Execute("insert into BL_r_sign_log(mem_id) values("&Session(G_SessionPre&"_Mem_ID")&")")
			Conn.Execute("update BL_m_member_info set mem_gongxian=mem_gongxian+1 where id="&Session(G_SessionPre&"_Mem_ID"))
			Response.Write(0)
		Else
			Response.Write(2)'今天已经签过到了
			signRs.Close
			Set signRs = Nothing
			Call connClose
			Response.End()
		End If
		Call connClose
	End If
End If

If action=2 Then '定制
	If Session(G_SessionPre&"_Mem_ID")="" or IsNull(Session(G_SessionPre&"_Mem_ID")) Then
		Response.Write(1)'未登录
		Response.End()
	Else
		Dim dingzhiStr
		dingzhiStr = Request.Form("d")
		If dingzhiStr="" Then
			Response.Write(2)'未定制
			Response.End()
		Else
			Dim dzArray,itemName,itemClass
			dzArray = Split(dingzhiStr,"_")
			Call OpenDataBase
			Conn.Execute("delete from BL_m_member_dingzhi_info where mem_id="&Session(G_SessionPre&"_Mem_ID"))
			For i = 0 to Ubound(dzArray)
				itemName	=left(dzArray(i),len(dzArray(i))-1)
				itemClass 	=right(dzArray(i),1)
				Conn.Execute("insert into BL_m_member_dingzhi_info(mem_id,goods_itemName,goods_itemClass) values("&Session(G_SessionPre&"_Mem_ID")&",'"&itemName&"',"&itemClass&")")
			Next
			Response.Write(0)'未定制
			Call connClose
		End If
	End IF
End If

If action=3 Then '还原定制项目
	If Session(G_SessionPre&"_Mem_ID")="" or IsNull(Session(G_SessionPre&"_Mem_ID")) Then
		Response.Write(1)'未登录
		Response.End()
	End If
	Dim retValue
	Call OpenDataBase
	Set DingRs=Conn.Execute("select * from BL_m_member_dingzhi_info where mem_id="&Session(G_SessionPre&"_Mem_ID"))
	If Not DingRs.Eof Then
		Do While Not DingRs.Eof
			retValue =retValue & DingRs("goods_itemName") & DingRs("goods_itemClass") &"_"
			DingRs.MoveNext
		Loop
		retValue = Left(retValue,len(retValue)-1)
	Else
		retValue=0
	End If
	DingRs.Close
	Set DingRs = Nothing
	Call connClose
	Response.Write(retValue)
End IF

If action=4 Then '赞踩goods
	If Session(G_SessionPre&"_Mem_ID")="" or IsNull(Session(G_SessionPre&"_Mem_ID")) Then
		Response.Write(1)'未登录
		Response.End()
	End If
	Dim zanCaiType
	goodsId 	=Request.Form("g")
	zanCaiType 	=Request.Form("t")
	If goodsId="" Or zanCaiType="" Then
		Response.Write(2)'参数错误
		Response.End()
	End If
	goodsId 	=CLng(goodsId)
	zanCaiType 	=CLng(zanCaiType)
		'判断权限
	If zanCaiType=1 Then
		If Not JudgePower("P000010") Then
			Response.Write(3)'没有权限
			Response.End()
		End If
	Else
		If Not JudgePower("P000011") Then
			Response.Write(3)'没有权限
			Response.End()
		End If
	End If
	'增加判断是否为自己提交的信息，是 则不能操作！
	

	Call OpenDataBase
	Set ZanRs=Conn.Execute("select id from BL_r_zan_cai_log where zan_cai="&zanCaiType&" and  mem_id="&Session(G_SessionPre&"_Mem_ID")&" and goods_id="&goodsId)
	If Not ZanRs.Eof Then
		
		Conn.Execute("delete from BL_r_zan_cai_log where id="&ZanRs("id"))
		If goodsId<1000000 Then'大于一百万为举报列表点踩
			If zanCaiType=1 Then
				Conn.Execute("update BL_s_goods_info set goods_zan=goods_zan-1 where id="&goodsId)
				'取消点赞一次减少一点贡献值
				Conn.Execute("update BL_m_member_info set mem_gongxian=mem_gongxian-1 where id="&Session(G_SessionPre&"_Mem_ID"))
			Else
				Conn.Execute("update BL_s_goods_info set goods_cai=goods_cai-1 where id="&goodsId)
			End If
		Else
			Conn.Execute("update BL_s_report_info set report_goods_cai=report_goods_cai-1 where id="&goodsId)
		End If
		Response.Write(zanCaiType&"3")'取消赞或者踩
		
	Else
	'临时改改改改改改改改改改改改改改改改改改改改改改改改改改改改改改改改改改改改改改改改改改改改
		Set ZanRs1=Conn.Execute("select id from BL_r_zan_cai_log where mem_id="&Session(G_SessionPre&"_Mem_ID")&" and goods_id="&goodsId)
		If Not ZanRs1.Eof Then
			Response.Write(4)'不能集采有赞
			ZanRs1.Close
			Set ZanRs1 = Nothing
		Else
			Conn.Execute("insert into BL_r_zan_cai_log(mem_id,goods_id,zan_cai) values("&Session(G_SessionPre&"_Mem_ID")&","&goodsId&","&zanCaiType&")")
			If goodsId<1000000 Then'大于一百万为举报列表点踩
				If zanCaiType=1 Then
					Conn.Execute("update BL_s_goods_info set goods_zan=goods_zan+1 where id="&goodsId)
					'点赞一次增加一点贡献值
					Conn.Execute("update BL_m_member_info set mem_gongxian=mem_gongxian+1 where id="&Session(G_SessionPre&"_Mem_ID"))
				Else
					Conn.Execute("update BL_s_goods_info set goods_cai=goods_cai+1 where id="&goodsId)
				End If
			Else
				Conn.Execute("update BL_s_report_info set report_goods_cai=report_goods_cai+1 where id="&goodsId)
			End If
			Response.Write(zanCaiType &"0")
		End If
	End If
	ZanRs.Close
	Set ZanRs = Nothing
	Call connClose
	
End If

If action=5 Then '收藏或者取消收藏
	'判断是否有权限
	If Not JudgePower("P000020") Then
		Response.Write(3)'没有权限
		Response.End()
	End If
	
	If Session(G_SessionPre&"_Mem_ID")="" or IsNull(Session(G_SessionPre&"_Mem_ID")) Then
		Response.Write(1)'未登录
		Response.End()
	Else
		Dim IsCancel
		IsCancel = Request.Form("i")
		goodsId = Request.Form("g")
		IsCancel = CInt(IsCancel)
		goodsId = CLng(goodsId)
		Call OpenDataBase
		If IsCancel=1 Then
			Conn.Execute("delete from BL_s_favorites_info where goods_id="&goodsId&" and mem_id="&Session(G_SessionPre&"_Mem_ID"))
			Response.Write(10)
		Else
			Conn.Execute("insert into BL_s_favorites_info(goods_id,mem_id) values("&goodsId&","&Session(G_SessionPre&"_Mem_ID")&")")
			Response.Write(20)
		End If
		Call connClose
	End If
End If

If action=6 Then '获取详细资料里的扩展参数
	goodsId 	=Request.Form("g")
	retString="{"
	If goodsId="" Then
		Response.Write(2)'参数错误
		Response.End()
	End If
	goodsId 	=CLng(goodsId)
	Call OpenDataBase
	exeSql = "SELECT goods_itemName+Cast(goods_itemClass as varchar(1))+':'+Cast(goods_itemValue as varchar(1000)) FROM BL_s_goods_ext_info where goods_id="&goodsId &" order by goods_itemName desc,goods_itemValue desc"
	Set extRs=Conn.Execute(exeSql)
	Do While Not extRs.Eof
		retString = retString&extRs(0)&","
		extRs.MoveNext
	Loop
	extRs.Close
	Set extRs = Nothing
	If Session(G_SessionPre&"_Mem_ID")<>"" Then
		Set collectRs=Conn.Execute("select id from BL_s_favorites_info where mem_id="&Session(G_SessionPre&"_Mem_ID")&" and goods_id="&goodsId)
		If Not collectRs.Eof Then
			retString = retString &"collect:1"
		Else
			retString = retString &"collect:0"
		End If
		collectRs.Close
		Set collectRs = Nothing
	Else
		retString = retString &"collect:0"'拼格式凑数，没用
	End If
	Call connClose
	retString =retString&"}"
	Response.Write(retString)
End If
If action=7 Then '赞踩评论 
	If Session(G_SessionPre&"_Mem_ID")="" or IsNull(Session(G_SessionPre&"_Mem_ID")) Then
		Response.Write(1)'未登录
		Response.End()
	End If
	commId 	=Request.Form("c")
	zanCaiType 	=Request.Form("t")
	If commId="" Or zanCaiType="" Then
		Response.Write(2)'参数错误
		Response.End()
	End If
	commId 		=CLng(commId)
	zanCaiType 	=CLng(zanCaiType)
	Call OpenDataBase
	Set ZanRs=Conn.Execute("select id from BL_r_zan_cai_log where mem_id="&Session(G_SessionPre&"_Mem_ID")&" and comment_id="&commId)
	If Not ZanRs.Eof Then
		ZanRs.Close
		Set ZanRs = Nothing
		Response.Write(zanCaiType&"3")'已经赞过或者踩过
		Response.End()
	Else
		Conn.Execute("insert into BL_r_zan_cai_log(mem_id,comment_id,zan_cai) values("&Session(G_SessionPre&"_Mem_ID")&","&commId&","&zanCaiType&")")
		If zanCaiType=1 Then
			Conn.Execute("update BL_s_goods_comment_info set comment_zan=comment_zan+1 where id="&commId)
		Else
			Conn.Execute("update BL_s_goods_comment_info set comment_cai=comment_cai+1 where id="&commId)
		End If
	End If
	ZanRs.Close
	Set ZanRs = Nothing
	Call connClose
	Response.Write(zanCaiType &"0")
End If
If action=8 Then '提交黑榜评论
	reportId=Request.Form("i")
	commDesc=myReplace(Request.Form("c"))
	
	If reportId<>"" And commDesc<>"" Then
		Call OpenDataBase
		reportId =CLng(reportId)
		Conn.Execute("insert into BL_s_goods_comment_info(mem_id,goods_id,comment_desc) values("&Session(G_SessionPre&"_Mem_ID")&","&reportId&",'"&commDesc&"')")
		'黑帮评论增加一威望
		'Conn.Execute("update BL_m_member_info set mem_weiwang=mem_weiwang+1 where id="&Session(G_SessionPre&"_Mem_ID"))
		commId=Conn.Execute("select top 1 id from BL_s_goods_comment_info where mem_id="&Session(G_SessionPre&"_Mem_ID")&" and goods_id="&reportId &" order by id desc")(0)
		Response.Write("0|"&Session(G_SessionPre&"_Mem_ID")&"|"&commId)
		Call connClose
	Else
		Response.Write("1")
	End If
End If
If action=9 Then '检测是否签到

	Call OpenDataBase
	Set SIgnRs=Conn.Execute("select id from BL_r_sign_log where datediff(day,insert_time,getdate())=0 and mem_id="&Session(G_SessionPre&"_Mem_ID"))
	If Not SIgnRs.Eof Then
		retString ="1"
	Else
		retString ="0"
	End If
	SIgnRs.Close
	Set SIgnRs = Nothing
	Response.Write(retString)
	Call connClose
end If

If action=10 Then '检测是否签到

	If Session(G_SessionPre&"_Mem_ID")="" or IsNull(Session(G_SessionPre&"_Mem_ID")) Then
		retString ="0"
	Else
		retString ="1"
	End If
	Response.Write(retString)
End If
%>