<!--#include file="inc/Const.asp"-->
<!--#include file="inc/Conn.asp"-->
<!--#include file="inc/Session.asp"-->
<!--#include file="inc/function.asp"-->
<%
Call IsLogin
If Not JudgePower("P030000") Then
	Call OpenDataBase
	dianpingNum=Conn.Execute("select Count(id) from BL_s_goods_comment_info where mem_id="&Session(G_SessionPre&"_Mem_ID"))(0)
	Call connClose
	If Not JudgePower("P030005") Then
		If dianpingNum>=5 Then
			Error1("您的点评次数已经超过每日上限！")
		Else
			If Not JudgePower("P030001") Then
				Error1("您的点评次数已经超过每日上限！")
			Else
				If dianpingNum>=1 Then
					Error1("您的点评次数已经超过每日上限！")
				End If
			End If
		End If
	End If
End If
Dim action,goodsId
action = Request.Form("action")
If action="1" Then
	Dim allDanXuan,useTime,price1p,pricePp,priceBy,priceBt,dianping
	
	
	
	goodsId		= myReplace(Request.Form("goodsId"))
	useTime 	= myReplace(Request.Form("useTime"))
	price1p 	= myReplace(Request.Form("price1p"))
	pricePp 	= myReplace(Request.Form("pricePp"))
	priceBy 	= myReplace(Request.Form("priceBy"))
	priceBt 	= myReplace(Request.Form("priceBt"))
	allDanXuan	= myReplace(Request.Form("allDanXuan"))
	dianping	= myReplace(Request.Form("dianping"))

	If price1p="" and pricePp="" and priceBy="" and priceBt="" Then
		Call ShowErrorInfo("１Ｐ、ＰＰ、ＢＹ、ＢＴ价格至少输入一项，请返回输入！",0)
	End If
	If useTime="" THen
		Call ShowErrorInfo("请选择体验时间，点确定返回！",0)
	End If
	If price1p="" Then price1p=0
	If pricePp="" Then pricePp=0
	If priceBy="" Then priceBy=0
	If priceBt="" Then priceBt=0
	
	Call OpenDataBase

	'检测是否已经点评过此妹子20171207
	Set goodsRs1=Conn.Execute("select ID from BL_s_goods_comment_info where mem_id="&Session(G_SessionPre&"_Mem_ID")&" and goods_id="&goodsId)
	If Not goodsRs1.Eof Then
		goodsRs1.CLose
		Set goodsRs1 = Nothing
		Call connClose
		Call ShowErrorInfo("你已经点评过她！",0)
	End If
	goodsRs1.CLose
	Set goodsRs1 = Nothing

	
	
	dim allDanXuanArray,itemNum,itemClass,itemValue
	
	If price1p<>0 Then
		If price1p<600 Then
			priceStr="price30"
		ElseIf price1p<1000 Then
			priceStr="price31"
		Else
			priceStr="price33"
		End If
		allDanXuan=allDanXuan &"_"& priceStr
	End If
		
	allDanXuanArray=split(allDanXuan,"_")
	'写单选评论
	For i = 0 to Ubound(allDanXuanArray)
		'Response.Write(allDanXuanArray(i)&"<br />")
		itemName	= left(allDanXuanArray(i),len(allDanXuanArray(i))-2)
		itemClass	= right(allDanXuanArray(i),1)
		Conn.Execute("update BL_s_goods_ext_info set goods_itemValue=goods_itemValue+1 where goods_id="&goodsId &" and goods_itemName='"&itemName&"' and goods_itemClass="&itemClass)
	Next
	'写点评
	
	Conn.Execute("insert into BL_s_goods_comment_info(mem_id,goods_id,comment_desc) values("&Session(G_SessionPre&"_Mem_ID")&","&goodsId&",'"&dianping&"')")
	'更新评论次数
	Conn.Execute("update BL_s_goods_info set goods_comment_num=goods_comment_num+1,comment_last_time=getdate() where id="&goodsId)
	'评论一次加一威望
	Conn.Execute("update BL_m_member_info set mem_weiwang=mem_weiwang+1 where id="&Session(G_SessionPre&"_Mem_ID"))
	Conn.execute("update BL_m_member_info set mem_comment_num=mem_comment_num+1 where id="&Session(G_SessionPre&"_Mem_ID"))
	Call ShowErrorInfo("点评成功，点确定返回！","showDetails.asp?id="&goodsId)
Else
	
	goodsId=Request.QueryString("id")
	If goodsId="" Then
		Call ShowErrorInfo("非法操作！",0)
	Else
		goodsId=Cint(goodsId)
		Call OpenDataBase
		Set goodsRs=Conn.Execute("select goods_name,goods_photo_url,goods_mem_id from BL_s_goods_info where recheck_state=1 and id="&goodsId)
		If goodsRs.Eof Then
			goodsRs.CLose
			Set goodsRs = Nothing
			Call connClose
			Call ShowErrorInfo("非法操作！",0)
		Else
			If goodsRs("goods_mem_id")=Session(G_SessionPre&"_Mem_ID") Then
				goodsRs.CLose
				Set goodsRs = Nothing
				Call connClose
				Call ShowErrorInfo("您不能点评你自己分享的内容！",0)
			End If
		End If
		'goodsRs.CLose
		'Set goodsRs = Nothing
		'检测是否已经点评过此妹子20170715
		Set goodsRs1=Conn.Execute("select ID from BL_s_goods_comment_info where mem_id="&Session(G_SessionPre&"_Mem_ID")&" and goods_id="&goodsId)
		If Not goodsRs1.Eof Then
			goodsRs1.CLose
			Set goodsRs1 = Nothing
			Call connClose
			Call ShowErrorInfo("你已经点评过她！",0)
		End If
		goodsRs1.CLose
		Set goodsRs1 = Nothing
	End IF
End If
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width,initial-scale=1.0,user-scalable=no">
<meta name="format-detection" content="telephone=no">
<title>评论</title>
<link rel="stylesheet" type="text/css" href="css/style.css"/>
<script src="js/jquery-2.2.3.min.js"></script>
<script type="text/javascript" src="js/comment.js" ></script>
</head>
<body>
<article class="jubao" id="comment">
  <div class="row showtoux flex showtoux1">
    <div class="showtoux-co1"> </div>
    <div class="showtoux-co2">
      <div class="text-align"><img src="<%=goodsRs("goods_photo_url")%>" width="100%"></div>
      <div class="tx-txt">
        <div class="fz16"><%=goodsRs("goods_name")%></div>
      </div>
    </div>
    <div class="showtoux-co1"> </div>
  </div>
  <form action="" method="post" id="commentForm">
  <input type="hidden" name="goodsId" value="<%=goodsId%>">
  <input name="action" value="1" type="hidden">
  <input value="" id="allDanXuan" name="allDanXuan" type="hidden">
    <div class="row margin-b5">
      <div class="col-12 flex padding-t5">
        <label class="lab1">时间：</label>
        <input type="date" name="useTime" class="txt1 txt2" id="useTime">
      </div>
    </div>
    <div class="row">
      <div class="flex padding-t5">
        <label class="lab1">类型：</label>
        <div class="rown">
            <div class="col-6"><label class="lab2">[1H]</label>&nbsp;&nbsp;<input type="number" class="txt1 txt5" name="price1p" id="price1p">&nbsp;&nbsp;<label style="padding-top: 2px;">RMB</label></div>
            <div class="col-6"><label class="lab2">[2H]</label>&nbsp;&nbsp;<input type="number" class="txt1 txt5" name="pricePp" id="pricePp">&nbsp;&nbsp;<label style="padding-top: 2px;">RMB</label></div>
            <div class="col-6"><label class="lab2">[长时]</label>&nbsp;&nbsp;<input type="number" class="txt1 txt5" name="priceBy" id="priceBy">&nbsp;&nbsp;<label style="padding-top: 2px;">RMB</label></div>
            <div class="col-6"><label class="lab2">[整天]</label>&nbsp;&nbsp;<input type="number" class="txt1 txt5" name="priceBt" id="priceBt">&nbsp;&nbsp;<label style="padding-top: 2px;">RMB</label></div>
        </div>

      </div>
    </div>
    <hr>
    <div class="row margin-tb5">
      <div class="flex padding-t5 vert-mid">
        <label class="lab1">照片：</label>
        <div class="rown">
          <div class="col-6">
            <input type="radio" name="zhaopian" id="zhaopian20" />
            <label class="lab2" for="zhaopian20">[真实]</label>
          </div>
          <div class="col-6">
            <input type="radio" name="zhaopian" id="zhaopian21" />
            <label class="lab2" for="zhaopian21">[不真实]</label>
          </div>
        </div>
      </div>
    </div>
    <div class="row">
      <div class="flex padding-t5 vert-mid">
        <label class="lab1">位置：</label>
        <div class="rown">
          <div class="col-4">
            <input type="radio" name="place" id="place50">
            <label class="lab2" for="place50">[市中心]</label>
          </div>
          <div class="col-4">
            <input type="radio" name="place" id="place51">
            <label class="lab2" for="place51">[东门]</label>
          </div>
          <div class="col-4">
            <input type="radio" name="place" id="place52">
            <label class="lab2" for="place52">[南门]</label>
          </div>
          <div class="col-4">
            <input type="radio" name="place" id="place53">
            <label class="lab2" for="place53">[西门]</label>
          </div>
          <div class="col-4">
            <input type="radio" name="place" id="place54">
            <label class="lab2" for="place54">[北门]</label>
          </div>
        </div>
      </div>
    </div>
    <div class="row">
      <div class="flex padding-t5 vert-mid">
        <label class="lab1">环境：</label>
        <div class="rown">
          <div class="col-4">
            <input type="radio" name="huanjing" id="huanjing30" />
            <label class="lab2" for="huanjing30">[不好]</label>
          </div>
          <div class="col-4">
            <input type="radio" name="huanjing" id="huanjing31" />
            <label class="lab2" for="huanjing31">[一般]</label>
          </div>
          <div class="col-4">
            <input type="radio" name="huanjing" id="huanjing32" />
            <label class="lab2" for="huanjing32">[很好]</label>
          </div>
        </div>
      </div>
    </div>
    <div class="row">
      <div class="flex padding-t5 vert-mid">
        <label class="lab1">年龄：</label>
        <div class="rown">
          <div class="col-4">
            <input type="radio" name="age" id="age30" />
            <label class="lab2" for="age30">[18-23]</label>
          </div>
          <div class="col-4">
            <input type="radio" name="age" id="age31" />
            <label class="lab2" for="age31">[24-29]</label>
          </div>
          <div class="col-4">
            <input type="radio" name="age" id="age32" />
            <label class="lab2" for="age32">[30+]</label>
          </div>
        </div>
      </div>
    </div>
    <div class="row">
      <div class="flex padding-t5 vert-mid">
        <label class="lab1">颜值：</label>
        <div class="rown">
          <div class="col-6">
            <input type="radio" name="yanzhi" id="yanzhi40" />
            <label class="lab2" for="yanzhi40">[差]</label>
          </div>
          <div class="col-6">
            <input type="radio" name="yanzhi" id="yanzhi41" />
            <label class="lab2" for="yanzhi41">[中等]</label>
          </div>
          <div class="col-6">
            <input type="radio" name="yanzhi" id="yanzhi42" />
            <label class="lab2" for="yanzhi42">[中上]</label>
          </div>
          <div class="col-6">
            <input type="radio" name="yanzhi" id="yanzhi43" />
            <label class="lab2" for="yanzhi43">[极品]</label>
          </div>
        </div>
      </div>
    </div>
    <div class="row">
      <div class="flex padding-t5 vert-mid">
        <label class="lab1">身高：</label>
        <div class="rown">
          <div class="col-6">
            <input type="radio" name="shengao" id="shengao40" />
            <label class="lab2" for="shengao40">[1.5-]</label>
          </div>
          <div class="col-6">
            <input type="radio" name="shengao" id="shengao41" />
            <label class="lab2" for="shengao41">[1.5-1.6]</label>
          </div>
          <div class="col-6">
            <input type="radio" name="shengao" id="shengao42" />
            <label class="lab2" for="shengao42">[1.6-1.7]</label>
          </div>
          <div class="col-6">
            <input type="radio" name="shengao" id="shengao43" />
            <label class="lab2" for="shengao43">[1.7+]</label>
          </div>
        </div>
      </div>
    </div>
    <div class="row">
      <div class="flex padding-t5 vert-mid">
        <label class="lab1">体型：</label>
        <div class="rown">
          <div class="col-4">
            <input type="radio" name="tixing" id="tixing30" />
            <label class="lab2" for="tixing30">[骨感]</label>
          </div>
          <div class="col-4">
            <input type="radio" name="tixing" id="tixing31" />
            <label class="lab2" for="tixing31">[丰满]</label>
          </div>
          <div class="col-4">
            <input type="radio" name="tixing" id="tixing32" />
            <label class="lab2" for="tixing32">[肥胖]</label>
          </div>
        </div>
      </div>
    </div>
    <div class="row">
      <div class="flex padding-t5 vert-mid">
        <label class="lab1">催单：</label>
        <div class="rown">
          <div class="col-6">
            <input type="radio" name="cuidan" id="cuidan20" />
            <label class="lab2" for="cuidan20">[会]</label>
          </div>
          <div class="col-6">
            <input type="radio" name="cuidan" id="cuidan21" />
            <label class="lab2" for="cuidan21">[不会]</label>
          </div>
        </div>
      </div>
    </div>
    <div class="row">
      <div class="flex padding-t5 vert-mid">
        <label class="lab1">服务：</label>
        <div class="rown">
          
          <div class="col-4">
            <input type="radio" name="service" id="service40" />
            <label class="lab2" for="service40">[无]</label>
          </div>
          <div class="col-4">
            <input type="radio" name="service" id="service41" />
            <label class="lab2" for="service41">[不好]</label>
          </div>
          <div class="col-4">
            <input type="radio" name="service" id="service42" />
            <label class="lab2" for="service42">[一般]</label>
          </div>
          <div class="col-4">
            <input type="radio" name="service" id="service43" />
            <label class="lab2" for="service43">[很好]</label>
          </div>
        </div>
      </div>
    </div>
    <div class="row">
      <div class="flex padding-t5 vert-mid">
        <label class="lab1">态度：</label>
        <div class="rown">
          <div class="col-4">
            <input type="radio" name="taidu" id="taidu30" />
            <label class="lab2" for="taidu30">[不好]</label>
          </div>
          <div class="col-4">
            <input type="radio" name="taidu" id="taidu31" />
            <label class="lab2" for="taidu31">[一般]</label>
          </div>
          <div class="col-4">
            <input type="radio" name="taidu" id="taidu32" />
            <label class="lab2" for="taidu32">[很好]</label>
          </div>
        </div>
      </div>
    </div>
    <hr>
    <div class="row">
      <div>
        <label class="color80">补充点评</label>
      </div>
      <div style="padding: 0 36px;">
        <textarea class="text-area" name="dianping"></textarea>
      </div>
    </div>
    <div class="row text-align">
      <input type="button" value="提交" class="btn btn-success" onclick="upLoad();" />
    </div>
  </form>
</article>
<div style="display:none;"><script src="https://s22.cnzz.com/z_stat.php?id=1262562117&web_id=1262562117" language="JavaScript"></script></div>

</body>
</html>
<%
goodsRs.Close
Set goodsRs = Nothing
Call connClose
%>
