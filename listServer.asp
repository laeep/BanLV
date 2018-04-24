<!--#include file="inc/Const.asp"-->
<!--#include file="inc/Conn.asp"-->
<!--#include file="inc/Session.asp"-->
<!--#include file="inc/function.asp"-->
<%
Dim action
Dim retString,priceString
Dim exeSql
Dim pagesSize,pagesIndex,startIndex,endIndex
Dim dingWhere
Dim W,H,collectIdList,collectState
Set PP = New ImgWHInfo
action = Request("a")
'新人榜
If action=1 Then
	
	pagesSize = 9
	pagesIndex =Request.Form("i")
	If pagesIndex="" Then pagesIndex=1
	startIndex 	= (pagesIndex-1)*pagesSize
	endIndex	= pagesIndex*pagesSize
	
	Call OpenDataBase

	If Session(G_SessionPre&"_Mem_ID")="" Or IsNull(Session(G_SessionPre&"_Mem_ID")) Then
		collectIdList=""
	Else
		collectIdList= Conn.Execute("select a=(SELECT ',' + isnull(CAST(goods_id AS VARCHAR(MAX)),'')  FROM [BL_s_favorites_info] where mem_id="&Session(G_SessionPre&"_Mem_ID")&" FOR XML PATH (''))")(0)&","
	End If
	Set goodsRs=Conn.Execute("select * from (select row_number() over(order by goods_orderby_date desc,id desc) as rowNum,* from BL_V_goods_xinren) a where rowNum>"&startIndex&" and rowNum<="&endIndex)
	orderIndex=0
	Do While Not goodsRs.Eof
		
		If Cint(GoodsRs("rowNum"))<4 Then
			showLableNewString = "<div class=""xr-fh xr-fh1"">新</div>"
		Else
			showLableNewString =""
		End If
		
		priceString = Replace(GoodsRs("price"),"8888.66","-")
		priceString = Replace(priceString,"/","M/") & "M"
		priceString = Replace(priceString,"-M","-")
		priceString = Replace(priceString,"M","")
		If goodsRs("mem_photo")="" or isnull(goodsRs("mem_photo")) Then
			faceUrl="images/img/noFace.jpg"
		Else
			faceUrl=goodsRs("mem_photo")
		End If
		
		W = PP.imgW(Server.Mappath(goodsRs("goods_photo_url")))   
		H = PP.imgH(Server.Mappath(goodsRs("goods_photo_url")))  
		If W=0 or H=0 Then
			W=440
			H=540
		End If
		If InStr(1,collectIdList,","&goodsRs("id")&",")>0 Then
			collectState =1
		Else
			collectState =0
		End If
		placeString=createPlaceString(goodsRs("id"),goodsRs("goods_address"),goodsRs("goods_mobile"),goodsRs("goods_weixin"),0)
		retString= retString &"{'place':'"&placeString&"','C':'"&collectState&"','W':'"&W&"','H':'"&H&"','isad':'"&goodsRs("show_type")&"','adurl':'"&goodsRs("goods_ad_url")&"','lable_flag':'"&showLableNewString&"','id':'"&goodsRs("id")&"','src':'"&goodsRs("goods_photo_url")&"','name':'"&goodsRs("goods_name")&"','price':'"&priceString&"','memName':'"&CutString(GoodsRs("mem_name"),6,"..")&"','memphoto':'"&faceUrl&"','zan':'"&goodsRs("goods_zan")&"','cai':'"&goodsRs("goods_cai")&"','memid':'"&goodsRs("mem_id")&"'},"
		goodsRs.MoveNext
	Loop
	If retString<>"" Then
		retString =Left(retString,Len(retString)-1)
		retString ="{'data':[" &retString&"]}"
	End If
	Response.Write(retString)
	Call connClose
	
End If

If action=2 Then'人气榜
	pagesSize = 9
	pagesIndex =Request.Form("i")
	If pagesIndex="" Then pagesIndex=1
	startIndex 	= (pagesIndex-1)*pagesSize
	endIndex	= pagesIndex*pagesSize
	
	Call OpenDataBase
	If Session(G_SessionPre&"_Mem_ID")="" Or IsNull(Session(G_SessionPre&"_Mem_ID")) Then
		collectIdList=""
	Else
		collectIdList= Conn.Execute("select a=(SELECT ',' + isnull(CAST(goods_id AS VARCHAR(MAX)),'')  FROM [BL_s_favorites_info] where mem_id="&Session(G_SessionPre&"_Mem_ID")&" FOR XML PATH (''))")(0)&","
	End If
	Set goodsRs=Conn.Execute("select * from (select row_number() over(order by goods_zan desc,goods_cai asc,goods_orderby_date desc) as rowNum,* from dbo.BL_V_goods_list) a where rowNum>"&startIndex&" and rowNum<="&endIndex)
	Do While Not goodsRs.Eof
		'标签处理
		Dim lableStr

		IF Cint(GoodsRs("rowNum"))<11 Then
			If Cint(GoodsRs("rowNum"))<4 Then
				lableStr = "<div class=""xr-fh xr-fh"&GoodsRs("rowNum")&""">"&GoodsRs("rowNum")&"</div>"
			Else
				lableStr = "<div class=""xr-fh xr-fh4"">"&GoodsRs("rowNum")&"</div>"
			End If
		Else
			lableStr = ""
		End If
		priceString = Replace(GoodsRs("price"),"8888.66","-")
		priceString = Replace(priceString,"/","M/") & "M"
		priceString = Replace(priceString,"-M","-")
		priceString = Replace(priceString,"M","")
		If goodsRs("mem_photo")="" or isnull(goodsRs("mem_photo")) Then
			faceUrl="images/img/noFace.jpg"
		Else
			faceUrl=goodsRs("mem_photo")
		End If
		W = PP.imgW(Server.Mappath(goodsRs("goods_photo_url")))   
		H = PP.imgH(Server.Mappath(goodsRs("goods_photo_url")))  
		If W=0 or H=0 Then
			W=440
			H=540
		End If
		If InStr(1,collectIdList,","&goodsRs("id")&",")>0 Then
			collectState =1
		Else
			collectState =0
		End If
		placeString=createPlaceString(goodsRs("id"),goodsRs("goods_address"),goodsRs("goods_mobile"),goodsRs("goods_weixin"),0)
		retString= retString &"{'place':'"&placeString&"','C':'"&collectState&"','W':'"&W&"','H':'"&H&"','isad':'"&goodsRs("show_type")&"','adurl':'"&goodsRs("goods_ad_url")&"','lable_flag':'"&lableStr&"','id':'"&goodsRs("id")&"','src':'"&goodsRs("goods_photo_url")&"','name':'"&goodsRs("goods_name")&"','price':'"&priceString&"','memName':'"&CutString(GoodsRs("mem_name"),6,"..")&"','memphoto':'"&faceUrl&"','zan':'"&goodsRs("goods_zan")&"','cai':'"&goodsRs("goods_cai")&"','memid':'"&goodsRs("mem_id")&"'},"
		goodsRs.MoveNext
	Loop
	If retString<>"" Then
		retString =Left(retString,Len(retString)-1)
		retString ="{'data':[" &retString&"]}"
	End If
	Response.Write(retString)
	Call connClose
	
End If

If action=3 Then'推荐榜
	pagesSize = 9
	pagesIndex =Request.Form("i")
	If pagesIndex="" Then pagesIndex=1
	startIndex 	= (pagesIndex-1)*pagesSize
	endIndex	= pagesIndex*pagesSize
	
	Call OpenDataBase
	If Session(G_SessionPre&"_Mem_ID")="" Or IsNull(Session(G_SessionPre&"_Mem_ID")) Then
		collectIdList=""
	Else
		collectIdList= Conn.Execute("select a=(SELECT ',' + isnull(CAST(goods_id AS VARCHAR(MAX)),'')  FROM [BL_s_favorites_info] where mem_id="&Session(G_SessionPre&"_Mem_ID")&" FOR XML PATH (''))")(0)&","
	End If
	Set goodsRs=Conn.Execute("select * from (select row_number() over(order by goods_orderby_date desc,id desc) as rowNum,* from dbo.BL_V_goods_list where goods_rec_state=1) a where rowNum>"&startIndex&" and rowNum<="&endIndex)
	Do While Not goodsRs.Eof
		
		
		'特殊标签处理
		If GoodsRs("goods_guan")=1 Then
			showLableNewString = "<div class=""xr-fh xr-fh5"">评</div>"
		Else
			showLableNewString =""
		End If
		If goodsRs("mem_photo")="" or isnull(goodsRs("mem_photo")) Then
			faceUrl="images/img/noFace.jpg"
		Else
			faceUrl=goodsRs("mem_photo")
		End If
		priceString = Replace(GoodsRs("price"),"8888.66","-")
		priceString = Replace(priceString,"/","M/") & "M"
		priceString = Replace(priceString,"-M","-")
		priceString = Replace(priceString,"M","")
		W = PP.imgW(Server.Mappath(goodsRs("goods_photo_url")))   
		H = PP.imgH(Server.Mappath(goodsRs("goods_photo_url")))  
		If W=0 or H=0 Then
			W=440
			H=540
		End If
		If InStr(1,collectIdList,","&goodsRs("id")&",")>0 Then
			collectState =1
		Else
			collectState =0
		End If
		placeString=createPlaceString(goodsRs("id"),goodsRs("goods_address"),goodsRs("goods_mobile"),goodsRs("goods_weixin"),0)
		retString= retString &"{'place':'"&placeString&"','C':'"&collectState&"','W':'"&W&"','H':'"&H&"','isad':'"&goodsRs("show_type")&"','adurl':'"&goodsRs("goods_ad_url")&"','lable_flag':'"&showLableNewString&"','id':'"&goodsRs("id")&"','src':'"&goodsRs("goods_photo_url")&"','name':'"&goodsRs("goods_name")&"','price':'"&priceString&"','memName':'"&CutString(GoodsRs("mem_name"),6,"..")&"','memphoto':'"&faceUrl&"','zan':'"&goodsRs("goods_zan")&"','cai':'"&goodsRs("goods_cai")&"','memid':'"&goodsRs("mem_id")&"'},"
		goodsRs.MoveNext
	Loop
	If retString<>"" Then
		retString =Left(retString,Len(retString)-1)
		retString ="{'data':[" &retString&"]}"
	End If
	Response.Write(retString)
	Call connClose
	
End If

If action=4 Then '定制列表
	If Not JudgePower("P010002") Then
		Response.Write("{'data':[]}")'没有权限,返回空
		Response.End()
	End If
	
	Call OpenDataBase
	Set DingRs=Conn.Execute("select * from BL_m_member_dingzhi_info where mem_id="&Session(G_SessionPre&"_Mem_ID"))
	If Not DingRs.Eof Then
		dingWhere = " where"
		Dim i 
		Do While Not DingRs.Eof
			i=i+1
			dingWhere = dingWhere &" or (goods_itemName='"&DingRs("goods_itemName")&"' and goods_itemClass="&DingRs("goods_itemClass")&")"
			DingRs.MoveNext
		Loop
		dingWhere = Replace(dingWhere,"where or","where")
	Else
		retString=""
	End If
	If Len(dingWhere)>30 Then
		exeSql = "select top 6 * from  BL_V_goods_list where id in(select goods_id from (SELECT goods_id FROM [BL_V_goods_ext_max] "&dingWhere&") b group by goods_id having count(goods_id)="&i&") and show_type=0 order by newid()"
		'Response.Write(exeSql)
		'Response.End()
		Set goodsRs=Conn.Execute(exeSql)
		Do While Not goodsRs.Eof
		
			priceString = Replace(GoodsRs("price"),"8888.66","-")
			priceString = Replace(priceString,"/","M/") & "M"
			priceString = Replace(priceString,"-M","-")
			priceString = Replace(priceString,"M","")
			If goodsRs("mem_photo")="" or isnull(goodsRs("mem_photo")) Then
				faceUrl="images/img/noFace.jpg"
			Else
				faceUrl=goodsRs("mem_photo")
			End If
			placeString=createPlaceString(goodsRs("id"),goodsRs("goods_address"),goodsRs("goods_mobile"),goodsRs("goods_weixin"),1)

			retString= retString &"{'place':'"&placeString&"','id':'"&goodsRs("id")&"','src':'"&goodsRs("goods_photo_url")&"','name':'"&CutString(goodsRs("goods_name"),10,"")&"','price':'"&priceString&"','memName':'"&CutString(goodsRs("mem_name"),6,"..")&"','memphoto':'"&faceUrl&"','zan':'"&goodsRs("goods_zan")&"','cai':'"&goodsRs("goods_cai")&"','memid':'"&goodsRs("mem_id")&"'},"
			goodsRs.MoveNext
		Loop
		If retString<>"" Then
			retString =Left(retString,Len(retString)-1)
			retString ="{'data':[" &retString&"]}"
		End If
	Else
		retString ="{'data':[]}"
	End If
	Response.Write(retString)
	Call connClose
End If

If action=5 Then '显示收藏列表
	exeSql = "select a.* from BL_V_goods_list a,BL_s_favorites_info b where a.id=b.goods_id and b.mem_id ="&Session(G_SessionPre&"_Mem_ID")&" order by b.add_time desc"
	'Response.Write(exeSql)
	'Response.End()
	Call OpenDataBase
	Set goodsRs=Conn.Execute(exeSql)
	Do While Not goodsRs.Eof

		priceString = Replace(GoodsRs("price"),"8888.66","-")
		priceString = Replace(priceString,"/","M/") & "M"
		priceString = Replace(priceString,"-M","-")
		priceString = Replace(priceString,"M","")
		If goodsRs("mem_photo")="" or isnull(goodsRs("mem_photo")) Then
			faceUrl="images/img/noFace.jpg"
		Else
			faceUrl=goodsRs("mem_photo")
		End If
		placeString=createPlaceString(goodsRs("id"),goodsRs("goods_address"),goodsRs("goods_mobile"),goodsRs("goods_weixin"),1)

		retString= retString &"{'place':'"&placeString&"','id':'"&goodsRs("id")&"','src':'"&goodsRs("goods_photo_url")&"','name':'"&goodsRs("goods_name")&"','price':'"&priceString&"','memName':'"&CutString(goodsRs("mem_name"),6,"..")&"','memphoto':'"&faceUrl&"','zan':'"&goodsRs("goods_zan")&"','cai':'"&goodsRs("goods_cai")&"','memid':'"&goodsRs("mem_id")&"'},"
		goodsRs.MoveNext
	Loop
	If retString<>"" Then
		retString =Left(retString,Len(retString)-1)
		retString ="{'data':[" &retString&"]}"
	End If
	Response.Write(retString)
	Call connClose
End If

If action=6 Then '复杂搜索

	Dim allDanXuan
	allDanXuan = Request.Form("d")
	
	allDanXuanArray=split(allDanXuan,"_")
	dingWhere = " where"
	For i = 0 to Ubound(allDanXuanArray)
		'Response.Write(allDanXuanArray(i)&"<br />")
		itemName	= left(allDanXuanArray(i),len(allDanXuanArray(i))-1)
		itemClass	= right(allDanXuanArray(i),1)
		dingWhere = dingWhere &" or (goods_itemName='"&itemName&"' and goods_itemClass="&itemClass&")"
	Next
	
	dingWhere = Replace(dingWhere,"where or","where")

	Call OpenDataBase
	If Session(G_SessionPre&"_Mem_ID")="" Or IsNull(Session(G_SessionPre&"_Mem_ID")) Then
		collectIdList=""
	Else
		collectIdList= Conn.Execute("select a=(SELECT ',' + isnull(CAST(goods_id AS VARCHAR(MAX)),'')  FROM [BL_s_favorites_info] where mem_id="&Session(G_SessionPre&"_Mem_ID")&" FOR XML PATH (''))")(0)&","
	End If
	exeSql = "select * from  BL_V_goods_list where id in(select goods_id from (SELECT goods_id FROM [BL_V_goods_ext_max] "&dingWhere&") b group by goods_id having count(goods_id)="&Ubound(allDanXuanArray)+1&") and show_type=0 order by goods_zan desc,goods_cai asc,goods_orderby_date desc"
	'Response.Write(exeSql)
	'Response.End()
	Set goodsRs=Conn.Execute(exeSql)
	
	Do While Not goodsRs.Eof
	
		priceString = Replace(GoodsRs("price"),"8888.66","-")
		priceString = Replace(priceString,"/","M/") & "M"
		priceString = Replace(priceString,"-M","-")
		priceString = Replace(priceString,"M","")
		If goodsRs("mem_photo")="" or isnull(goodsRs("mem_photo")) Then
			faceUrl="images/img/noFace.jpg"
		Else
			faceUrl=goodsRs("mem_photo")
		End If
		W = PP.imgW(Server.Mappath(goodsRs("goods_photo_url")))   
		H = PP.imgH(Server.Mappath(goodsRs("goods_photo_url")))  
		If W=0 or H=0 Then
			W=440
			H=540
		End If
		If InStr(1,collectIdList,","&goodsRs("id")&",")>0 Then
			collectState =1
		Else
			collectState =0
		End If
		placeString=createPlaceString(goodsRs("id"),goodsRs("goods_address"),goodsRs("goods_mobile"),goodsRs("goods_weixin"),0)
		retString= retString &"{'place':'"&placeString&"','C':'"&collectState&"','W':'"&W&"','H':'"&H&"','id':'"&goodsRs("id")&"','src':'"&goodsRs("goods_photo_url")&"','name':'"&goodsRs("goods_name")&"','price':'"&priceString&"','memName':'"&CutString(goodsRs("mem_name"),6,"..")&"','memphoto':'"&faceUrl&"','zan':'"&goodsRs("goods_zan")&"','cai':'"&goodsRs("goods_cai")&"','memid':'"&goodsRs("mem_id")&"'},"
		goodsRs.MoveNext
	Loop
	
	If retString<>"" Then
		retString =Left(retString,Len(retString)-1)
		retString ="{'data':[" &retString&"]}"
	End If
	Response.Write(retString)
	Call connClose
End If

If action=7 Then '简单搜索
	searchStr=Request.Form("i")
	searchStr=lostDangerChar(searchStr)
	If searchStr="" Then
		Response.End()
	End If
	Call OpenDataBase
	If Session(G_SessionPre&"_Mem_ID")="" Or IsNull(Session(G_SessionPre&"_Mem_ID")) Then
		collectIdList=""
	Else
		collectIdList= Conn.Execute("select a=(SELECT ',' + isnull(CAST(goods_id AS VARCHAR(MAX)),'')  FROM [BL_s_favorites_info] where mem_id="&Session(G_SessionPre&"_Mem_ID")&" FOR XML PATH (''))")(0)&","
	End If
	exeSql = "select * from  BL_V_goods_list where (goods_qq like'%"&searchStr&"%' or goods_name like '%"&searchStr&"%' or goods_mobile like '%"&searchStr&"%') and show_type=0 order by goods_zan desc,goods_cai asc"
	'Response.Write(exeSql)
	'Response.End()
	Set goodsRs=Conn.Execute(exeSql)
	Do While Not goodsRs.Eof
		priceString = Replace(GoodsRs("price"),"8888.66","-")
		priceString = Replace(priceString,"/","M/") & "M"
		priceString = Replace(priceString,"-M","-")
		priceString = Replace(priceString,"M","")
		If goodsRs("mem_photo")="" or isnull(goodsRs("mem_photo")) Then
			faceUrl="images/img/noFace.jpg"
		Else
			faceUrl=goodsRs("mem_photo")
		End If
		W = PP.imgW(Server.Mappath(goodsRs("goods_photo_url")))   
		H = PP.imgH(Server.Mappath(goodsRs("goods_photo_url")))  
		If W=0 or H=0 Then
			W=440
			H=540
		End If
		If InStr(1,collectIdList,","&goodsRs("id")&",")>0 Then
			collectState =1
		Else
			collectState =0
		End If
		placeString=createPlaceString(goodsRs("id"),goodsRs("goods_address"),goodsRs("goods_mobile"),goodsRs("goods_weixin"),0)

		retString= retString &"{'place':'"&placeString&"','C':'"&collectState&"','W':'"&W&"','H':'"&H&"','id':'"&goodsRs("id")&"','src':'"&goodsRs("goods_photo_url")&"','name':'"&goodsRs("goods_name")&"','price':'"&priceString&"','memName':'"&CutString(goodsRs("mem_name"),6,"..")&"','memphoto':'"&faceUrl&"','zan':'"&goodsRs("goods_zan")&"','cai':'"&goodsRs("goods_cai")&"','memid':'"&goodsRs("mem_id")&"'},"
		goodsRs.MoveNext
	Loop
	If retString<>"" Then
		retString =Left(retString,Len(retString)-1)
		retString ="{'data':[" &retString&"]}"
	End If
	Response.Write(retString)
	Call connClose
End If

If action=8 Then'黑榜
	pagesSize = 9
	pagesIndex =Request.Form("i")
	If pagesIndex="" Then pagesIndex=1
	startIndex 	= (pagesIndex-1)*pagesSize
	endIndex	= pagesIndex*pagesSize
	
	Call OpenDataBase
	Set goodsRs=Conn.Execute("select * from (select row_number() over(order by report_order_by_time desc,id desc) as rowNum,* from dbo.BL_V_report_list) a where rowNum>"&startIndex&" and rowNum<="&endIndex)
	Do While Not goodsRs.Eof
		If goodsRs("mem_photo")="" or isnull(goodsRs("mem_photo")) Then
			faceUrl="images/img/noFace.jpg"
		Else
			faceUrl=goodsRs("mem_photo")
		End If
		
		W = PP.imgW(Server.Mappath(goodsRs("report_goods_photo")))   
		H = PP.imgH(Server.Mappath(goodsRs("report_goods_photo")))  
		If W=0 or H=0 Then
			W=440
			H=540
		End If
		
		retString= retString &"{'W':'"&W&"','H':'"&H&"','id':'"&goodsRs("id")&"','src':'"&goodsRs("report_goods_photo")&"','name':'"&goodsRs("report_goods_name")&"','qq':'"&goodsRs("report_goods_qq")&"','memName':'"&CutString(GoodsRs("mem_name"),6,"..")&"','memphoto':'"&faceUrl&"','tel':'"&goodsRs("report_goods_tel")&"','cai':'"&goodsRs("report_goods_cai")&"','memid':'"&goodsRs("mem_id")&"'},"
		goodsRs.MoveNext
	Loop
	If retString<>"" Then
		retString =Left(retString,Len(retString)-1)
		retString ="{'data':[" &retString&"]}"
	End If
	Response.Write(retString)
	Call connClose
End If
Set pp = Nothing  


Function createPlaceString(f_id,f_address,f_mobile,f_weixin,f_mustOut)
	lableStr2 =""
	lableStr1 =""
	'检测评
	ext_para_num=Conn.execute("select count(0) from (SELECT [goods_itemName] FROM [BL_s_goods_ext_info] where goods_itemValue>0 and goods_id="&f_id&" group by goods_itemName) t")(0)
	If ext_para_num=11 Then
		lableStr2="<img src=""images/new_ping.png"">"
	End IF
	
	If f_address<>"" Then
		lableStr1="<div class=""icon-weizhi""><img src=""images/new_weizhi.png""> "&CutString(f_address,12,"")&"</div>"
	Else
		If f_mustOut=1 Then
			lableStr1="<div class=""icon-weizhi""><img src=""images/new_weizhi.png""> &nbsp;</div>"
		Else
			lableStr1 =""
		End If
	End If
	
	If f_mobile<>"" Then
		lableStr2=lableStr2 & "<img src=""images/new_tel.png"">"	
	End If
	If f_weixin<>"" Then
		lableStr2=lableStr2 & "<img src=""images/new_wx.png"">"	
	End If
	If lableStr2<>"" Then
		lableStr2 = "<div class=""icon-ping"">" &lableStr2& "</div>"
	Else
		If f_mustOut=1 Then
			lableStr2 = "<div class=""icon-ping"">&nbsp;</div>"
		End If 
	End If
	createPlaceString = lableStr1 & lableStr2
End Function
%>