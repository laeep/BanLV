<!--#include file="inc/Const.asp"-->
<!--#include file="inc/Conn.asp"-->
<!--#include file="inc/Session.asp"-->
<!--#include file="inc/function.asp"-->
<%
Call IsLogin
If Not JudgePower("P000013") Then Error1("您没有提交报告的权限！")
Dim action
action = Request.Form("action")
If action="1" Then
	Dim allDanXuan,userName,userQq,userWeixin,userTel,userAddress,useTime,price1p,pricePp,priceBy,priceBt,dianping,imgBase64
	userName 	= myReplace(Request.Form("userName"))
	userQq 		= myReplace(Request.Form("userQq"))
	userTel 	= myReplace(Request.Form("userTel"))
	userWeixin 	= myReplace(Request.Form("userWeixin"))
	userAddress = myReplace(Request.Form("userAddress"))
	useTime 	= myReplace(Request.Form("useTime"))
	price1p 	= myReplace(Request.Form("price1p"))
	pricePp 	= myReplace(Request.Form("pricePp"))
	priceBy 	= myReplace(Request.Form("priceBy"))
	priceBt 	= myReplace(Request.Form("priceBt"))
	allDanXuan	= myReplace(Request.Form("allDanXuan"))
	dianping	= myReplace(Request.Form("dianping"))
	imgBase64 	= Request.Form("ImgBase64")
	If userName="" THen
		Call ShowErrorInfo("名字必须输入，请返回输入！",0)
	End If
	If userQq="" and userTel="" and userWeixin="" Then
		Call ShowErrorInfo("ＱＱ、ＴＥＬ、微信至少输入一项，请返回输入！",0)
	End If
	If price1p="" and pricePp="" and priceBy="" and priceBt="" Then
		Call ShowErrorInfo("１H、2H、长时、整天价格至少输入一项，请返回输入！",0)
	End If
	If useTime="" THen
		Call ShowErrorInfo("请选择体验时间，点确定返回！",0)
	End If
	If price1p="" Then price1p=0 Else price1p=CLNG(price1p)
	If pricePp="" Then pricePp=0 Else pricePp=CLNG(pricePp)
	If priceBy="" Then priceBy=0 Else priceBy=CLNG(priceBy)
	If priceBt="" Then priceBt=0 Else priceBt=CLNG(priceBt)
	If imgBase64="" Then
		Call ShowErrorInfo("请选择照片，返回！",0)
	End If
	Dim path
	If Instr(1,Lcase(imgBase64),"base64")>0 Then
		path=Replace(Now()," ","")
		path=Replace(path,"/","")
		path=Replace(path,"-","")
		path=Replace(path,":","")
		path= G_Website_Dir&"/goodsPhoto/" & Session(G_SessionPre&"_Mem_ID") & path &  ".jpg"'    ‘’‘’‘图片保存路径
		'Call WriteFile("2222.txt",imgBase64)
		Call saveImg(path,imgBase64)
		'Conn.Execute("update BL_m_member_info set mem_photo='"&path&"' where id="& Session(G_SessionPre&"_Mem_ID"))
	End If
	Call OpenDataBase
	'检测是否有重复提交
	Dim SelectWhere
	'SelectWhere = " where 1=1"
	If userQq<>"" Then
		SelectWhere =SelectWhere &" or goods_qq='"&userQq&"'"
	End If
	If userWeixin<>"" Then
		SelectWhere =SelectWhere &" or goods_weixin='"&userWeixin&"'"
	End If
	If userTel<>"" Then
		SelectWhere =SelectWhere &" or goods_mobile='"&userTel&"'"
	End If
	SelectWhere =Right(SelectWhere,len(SelectWhere)-4)
	Set haveGooddRs=Conn.Execute("select id from BL_s_goods_info where " & SelectWhere)
	If Not haveGooddRs.Eof Then
		haveGooddRs.Close
		Set haveGooddRs = Nothing
		Call connClose
		Call ShowErrorInfo("你分享的资料系统内已经存在，谢谢您的参与！","share.asp")
	End If
	haveGooddRs.Close
	Set haveGooddRs = Nothing
		
	StrSql="insert into BL_s_goods_info(goods_name,goods_qq,goods_weixin,goods_mobile,show_type,goods_address,goods_use_time,goods_photo_url,goods_1p,goods_pp,goods_by,goods_bt,goods_mem_id) values('"&userName&"','"&userQq&"','"&userWeixin&"','"&userTel&"',0,'"&userAddress&"','"&useTime&"','"&path&"',"&price1p&","&pricepp&","&priceby&","&pricebt&","&Session(G_SessionPre&"_Mem_ID")&")"
	'Response.Write(StrSql)
	Conn.Execute(StrSql)
	Dim goodsId
	Set goodsRs=Conn.Execute("select top 1 id from BL_s_goods_info where goods_photo_url='"&path&"' order by id desc")
	'Response.Write(allDanXuan&"<br />")
	If Not goodsRs.Eof Then
		goodsId = goodsRs("id")
		dim allDanXuanArray,itemNum,itemClass,itemValue
		
		'根据1P价格构造价格范围字符串写入扩展字段
		If price1p>0 Then
			If price1p<600 Then
				priceStr="price30"
			ElseIf price1p<1000 Then
				priceStr="price31"
			Else
				priceStr="price33"
			End If
		Else
			priceStr="price34"
		End If
		allDanXuan=allDanXuan &"_"& priceStr
		
		allDanXuanArray=split(allDanXuan,"_")
		'写单选评论
		For i = 0 to Ubound(allDanXuanArray)
			'Response.Write(allDanXuanArray(i)&"<br />")
			itemNum 	= mid(allDanXuanArray(i),len(allDanXuanArray(i))-1,1)
			itemName	= left(allDanXuanArray(i),len(allDanXuanArray(i))-2)
			itemClass	= right(allDanXuanArray(i),1)
			'REsponse.Write(itemNum&"<br />")
			for j=0 to itemNum-1
				If j=CInt(itemClass) Then
					itemValue=1
				Else
					itemValue=0
				End IF
				Conn.Execute("insert into BL_s_goods_ext_info(goods_id,goods_itemName,goods_itemClass,goods_itemValue) values("&goodsId&",'"&itemName&"',"&j&","&itemValue&")")
			Next
			'conn.Execute("update BL_s_goods_ext_info set goods_itemValue=goods_itemValue+1 where ")
		Next
		
		'写点评
		If dianping<>"" Then
			Conn.Execute("insert into BL_s_goods_comment_info(mem_id,goods_id,comment_desc) values("&Session(G_SessionPre&"_Mem_ID")&","&goodsId&",'"&dianping&"')")
			'更新评论次数
			Conn.Execute("update BL_s_goods_info set goods_comment_num=goods_comment_num+1 where id="&goodsId)

		End If
		'分享给贡献值
		'Conn.Execute("update BL_m_member_info set mem_gongxian=mem_gongxian+1 where id="&Session(G_SessionPre&"_Mem_ID"))   
	End IF
	goodsRs.Close
	Set goodsRs = Nothing
	Call connClose
	Call ShowErrorInfo("分享成功，请等待审核！","my_info.asp")
End If
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width,initial-scale=1.0,user-scalable=no">
<meta name="format-detection" content="telephone=no">
<title>分享</title>
<link rel="stylesheet" type="text/css" href="css/style.css"/>
<script src="js/jquery-2.2.3.min.js"></script>
<script src="js/iscroll-zoom.js"></script>
<script src="js/hammer.min.js"></script>
<script src="js/lrz.all.bundle.js"></script>
<script src="js/PhotoClip.js"></script>
<script type="text/javascript" src="js/share.js?v=2" ></script>
</head>
<body>
<article class="jubao" id="comment">
  <form action="share.asp" method="post" id="shareForm"><input value="" id="allDanXuan" name="allDanXuan" type="hidden">
  <input type="hidden" name="action" value="1"><textarea id="ImgBase64" name="ImgBase64" style="display:none;"></textarea>
    <div class="row margin-t15 margin-b10">
      <div class="text-align comment-img"> <img src="images/jia.png" id="okbtn"> </div>
    </div>
    <div class="row flex">
      <div class="col-6">
        <div class="flex padding-t5">
          <label class="lab1">名字：</label>
          <input type="text" class="txt1" name="userName" id="userName">
        </div>
      </div>
      <div class="col-6">
        <div class="flex padding-t5">
          <label class="lab1">Q Q：</label>
          <input type="number" class="txt1" name="userQq" id="userQq" maxlength="20">
        </div>
      </div>
    </div>
    <div class="row flex">
      <div class="col-6">
        <div class="flex padding-t5">
          <label class="lab1">Tel：</label>
          <input type="tel" class="txt1" name="userTel" id="userTel" maxlength="11">
        </div>
      </div>
      <div class="col-6">
        <div class="flex padding-t5">
          <label class="lab1">微信：</label>
          <input type="text" class="txt1" name="userWeixin" id="userWeixin">
        </div>
      </div>
    </div>
    <div class="row margin-b10">
    <div class="col-6">
      <div class="col-12 flex padding-t5">
        <label class="lab1">时间：</label>
        <input type="date" class="txt1 txt2" name="useTime" id="useTime">
      </div>
      </div>
      <div class="col-6">
       <div class="col-12 flex padding-t5">
        <label class="lab1">地址：</label>
        <input type="text" class="txt1" name="userAddress" id="userAddress">
      </div>
      </div>
    </div>
    <div class="row">
      <div class="flex padding-t5">
        <label class="lab1">类型：</label>
        <div class="rown">
            <div class="col-6"><label class="color80">[1H]</label>&nbsp;&nbsp;<input type="number" class="txt1 txt5" name="price1p" id="price1p">&nbsp;&nbsp;<label class="color80" style="padding-top: 2px;">RMB</label></div>
            <div class="col-6"><label class="color80">[2H]</label>&nbsp;&nbsp;<input type="number" class="txt1 txt5" name="pricePp" id="pricePp">&nbsp;&nbsp;<label class="color80" style="padding-top: 2px;">RMB</label></div>
            <div class="col-6"><label class="color80">[长时]</label>&nbsp;&nbsp;<input type="number" class="txt1 txt5" name="priceBy" id="priceBy">&nbsp;&nbsp;<label class="color80" style="padding-top: 2px;">RMB</label></div>
            <div class="col-6"><label class="color80">[整天]</label>&nbsp;&nbsp;<input type="number" class="txt1 txt5" name="priceBt" id="priceBt">&nbsp;&nbsp;<label class="color80" style="padding-top: 2px;">RMB</label></div>
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
            <input type="radio" name="weizhi" id="place54">
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
<div id="photo-main">
  <div id="clipArea"></div>
  <div class="photo-foot">
    <div class="uploader1 blue"> <a href="javascript:;" class="button" name="file">打开</a>
      <input id="file" type="file" accept="image/*" multiple  />
    </div>
    <a href="javascript:;" class="button2" id="cancelBtn">返回</a>
    <a href="javascript:;" class="button" id="clipBtn">截取</a> </div>
  <!--<img src="" id="view11">--> 
</div>
<div style="display:none;"><script src="https://s22.cnzz.com/z_stat.php?id=1262562117&web_id=1262562117" language="JavaScript"></script></div>
</body>
</html>
