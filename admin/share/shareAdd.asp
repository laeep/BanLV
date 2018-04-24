<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="../inc/const.asp"-->
<!--#include file="../inc/conn.asp"-->
<!--#include file="../session.asp"-->
<!--#include file="../inc/Function.asp" -->
<!--#include file="../inc/md5.asp" -->
<%
'If Not JudgePower("admin") Then Error1
Dim act,goodsId
goodsId = Request("id")
act=Request.Form("action")
If act="1" Then
	Dim goodsName,goodsQq,goodsTel,goodsWeixin,useTime,goodsZan,goodsCai,goodsOrderTime,price1P,pricePp,priceBy,priceBt,goodsImg,goodsExtAttr,isAd,adUrl
	dim allDanXuanArray,itemNum,itemClass,itemValue,maohaoIndex,userAddress
	goodsName 	= Request.Form("goodsName")
	goodsQq		= Request.Form("goodsQq")
	goodsTel 	= Request.Form("goodsTel")
	goodsWeixin = Request.Form("goodsWeixin")
	userAddress = Request.Form("userAddress")
	useTime		= Request.Form("useTime")
	goodsZan	= Request.Form("goodsZan")
	goodsCai	= Request.Form("goodsCai")
	goodsOrderTime 	= Request.Form("goodsOrderTime")
	price1P 	= Request.Form("price1P")
	pricePp 	= Request.Form("pricePp")
	priceBy 	= Request.Form("priceBy")
	priceBt 	= Request.Form("priceBt")
	goodsImg 	= Request.Form("goodsImg")
	isAd 		= Request.Form("isAd")
	adUrl 		= Request.Form("adUrl")
	goodsExtAttr=Request.Form("allExtAttr")

	If price1p="" Then price1p=0 Else price1p=CLNG(price1p)
	If pricePp="" Then pricePp=0 Else pricePp=CLNG(pricePp)
	If priceBy="" Then priceBy=0 Else priceBy=CLNG(priceBy)
	If priceBt="" Then priceBt=0 Else priceBt=CLNG(priceBt)
	If isAd="1" THen
		If adUrl="" THen
			Call ShowErrorInfo("广告必须输入链接地址！",0)
		End If
		If goodsName="" Then goodsName 	="广告"&GetRandomID10
		If goodsQq="" Then goodsQq 	=GetRandomID10
		price1P		=100
	End If
	If goodsName="" Then
		Call ShowErrorInfo("名字必须输入！",0)
	End IF
	If goodsImg="" Then
		Call ShowErrorInfo("照片必须选择！",0)
	End IF
	If goodsQq="" And goodsTel="" And goodsWeixin ="" Then
		Call ShowErrorInfo("QQ，电话，微信至少输入一个！",0)
	End IF
	If price1P="" And pricePp="" And priceBy ="" And priceBt="" Then
		Call ShowErrorInfo("价格至少输入一个！",0)
	End IF
	If Instr(1,goodsExtAttr,":_")>0 Then
		Call ShowErrorInfo("必须输入所有基本参数！",0)
	End If
	If Not IsDate(goodsOrderTime) Then
		Call ShowErrorInfo("排序 必须输入日期类型的数据！",0)
	End IF
	If Not IsDate(useTime) Then
		Call ShowErrorInfo("时间 必须输入日期类型的数据！",0)
	End IF
	If isAd="1" THen
		If adUrl="" THen
			Call ShowErrorInfo("广告必须输入链接地址！",0)
		End If
	End If
	'根据1P价格构造价格范围字符串写入扩展字段
	If price1p>0 Then
		If price1p<600 Then
			priceStr="price0:1_price1:0_price2:0"
		ElseIf price1p<1000 Then
			priceStr="price0:0_price1:1_price2:0"
		Else
			priceStr="price0:0_price1:0_price2:1"
		End If
	Else
		priceStr="price0:0_price1:0_price2:0"
	End If
	goodsExtAttr=goodsExtAttr &"_"& priceStr
	
	allDanXuanArray=split(goodsExtAttr,"_")

	Call OpenDataBase
	If goodsId="" Then
		
		Dim SelectWhere
		If goodsQq<>"" Then
			SelectWhere =SelectWhere &" or goods_qq='"&goodsQq&"'"
		End If
		If goodsWeixin<>"" Then
			SelectWhere =SelectWhere &" or goods_weixin='"&goodsWeixin&"'"
		End If
		If goodsTel<>"" Then
			SelectWhere =SelectWhere &" or goods_mobile='"&goodsTel&"'"
		End If
		SelectWhere =Right(SelectWhere,len(SelectWhere)-4)
		Set haveGooddRs=Conn.Execute("select id from BL_s_goods_info where " & SelectWhere)
		If Not haveGooddRs.Eof Then
			haveGooddRs.Close
			Set haveGooddRs = Nothing
			Call connClose
			Call ShowErrorInfo("你分享的资料系统内已经存在，谢谢您的参与！",0)
		End If
		haveGooddRs.Close
		Set haveGooddRs = Nothing
		
		StrSql="insert into BL_s_goods_info(goods_name,goods_qq,goods_weixin,goods_mobile,goods_address,goods_use_time,goods_photo_url,goods_1p,goods_pp,goods_by,goods_bt,goods_mem_id,goods_zan,goods_cai,goods_orderby_date,show_type,goods_ad_url) values('"&goodsName&"','"&goodsQq&"','"&goodsWeixin&"','"&goodsTel&"','"&userAddress&"','"&useTime&"','"&goodsImg&"',"&price1p&","&pricepp&","&priceby&","&pricebt&","&G_CommMemID&","&goodsZan&","&goodsCai&",'"&goodsOrderTime&"',"&isAd&",'"&adUrl&"')"
		'Response.Write(StrSql)
		Conn.Execute(StrSql)
		
		Set goodsRs=Conn.Execute("select top 1 id from BL_s_goods_info where goods_photo_url='"&goodsImg&"' order by id desc")
		'Response.Write(allDanXuan&"<br />")
		If Not goodsRs.Eof Then
			goodsId = goodsRs("id")
			'写单选评论
			For i = 0 to Ubound(allDanXuanArray)
				'Response.Write(allDanXuanArray(i)&"<br>")
				maohaoIndex =Instr(1,allDanXuanArray(i),":")
				itemClass 	= mid(allDanXuanArray(i),maohaoIndex-1,1)
				itemName	= left(allDanXuanArray(i),maohaoIndex-2)
				itemValue	= right(allDanXuanArray(i),len(allDanXuanArray(i))-maohaoIndex)
				'REsponse.Write(itemNum&"<br />")
				updateSql="insert into BL_s_goods_ext_info(goods_id,goods_itemName,goods_itemClass,goods_itemValue) values("&goodsId&",'"&itemName&"',"&itemClass&","&itemValue&")"
				'Response.Write(updateSql & "<br />")
				Conn.Execute(updateSql)
			Next
		End IF
		'Response.End()
		goodsRs.Close
		Set goodsRs = Nothing
		Call connClose
		Call ShowErrorInfo("添加成功，请审核！","shareList.asp")
	Else
		Set goodsRs = CreateObject("Adodb.RecordSet")
		updateRsSql="select * from BL_s_goods_info where id="&goodsId
		goodsRs.Open updateRsSql,Conn,1,3

		If Not goodsRs.Eof Then
			goodsRs("goods_name")		=goodsName
			goodsRs("goods_qq")			=goodsQq
			goodsRs("goods_weixin")		=goodsWeixin
			goodsRs("goods_mobile")		=goodsTel
			goodsRs("goods_address")	=userAddress
			goodsRs("goods_use_time")	=useTime
			goodsRs("goods_photo_url")	=goodsImg
			goodsRs("goods_1p")			=price1p
			goodsRs("goods_pp")			=pricepp
			goodsRs("goods_by")			=priceby
			goodsRs("goods_bt")			=pricebt
			goodsRs("goods_zan")		=goodsZan
			goodsRs("goods_cai")		=goodsCai
			goodsRs("goods_orderby_date")	=goodsOrderTime
			goodsRs("show_type")		=isAd
			goodsRs("goods_ad_url")		=adUrl
			goodsRs.Update
			goodsRs.Close
			Set goodsRs = Nothing

			'写单选评论
			For i = 0 to Ubound(allDanXuanArray)
				maohaoIndex =Instr(1,allDanXuanArray(i),":")
				itemClass 	= mid(allDanXuanArray(i),maohaoIndex-1,1)
				itemName	= left(allDanXuanArray(i),maohaoIndex-2)
				itemValue	= right(allDanXuanArray(i),len(allDanXuanArray(i))-maohaoIndex)
				updateSql="update BL_s_goods_ext_info set goods_itemValue="&itemValue&" where goods_id="&goodsId&" and goods_itemName='"&itemName&"' and goods_itemClass="&itemClass
				
				Conn.Execute(updateSql)
			Next
		End IF
		
		Call connClose
		Call ShowErrorInfo("修改成功！","shareList.asp")
	End If
Else
	If goodsId<>"" Then
		Call OpenDataBase
		Set goodsRs=Conn.Execute("select * from BL_s_goods_info where id=" & goodsId)
		If Not goodsRs.Eof Then
			goodsName 	= goodsRs("goods_name")
			goodsQq		= goodsRs("goods_qq")
			goodsTel 	= goodsRs("goods_mobile")
			goodsWeixin = goodsRs("goods_weixin")
			userAddress = goodsRs("goods_address")
			useTime		= goodsRs("goods_use_time")
			goodsZan	= goodsRs("goods_zan")
			goodsCai	= goodsRs("goods_cai")
			goodsOrderTime 	= goodsRs("goods_orderby_date")
			price1P 	= goodsRs("goods_1p")
			pricePp 	= goodsRs("goods_pp")
			priceBy 	= goodsRs("goods_by")
			priceBt 	= goodsRs("goods_bt")
			goodsImg 	= goodsRs("goods_photo_url")
			isAd	 	= goodsRs("show_type")
			adUrl	 	= goodsRs("goods_ad_url")
			pageTitle	="修改分享"
		Else
			Call ShowErrorInfo("非法操作！","memList.asp")
		End If
		goodsRs.Close
		Set goodsRs = Nothing
		Call connClose
	Else
		goodsZan	=0
		goodsCai	=0
		pageTitle	="添加分享"
		goodsOrderTime=Now()
		useTime 	=date()
		isAd		=0
		
	End If
End IF           
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>分享编辑</title>
<link href="../css/style.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" href="../css/styleMem.css"/>
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
					imageUrl : K('#goodsImg').val(),
					clickFn : function(url, title, width, height, border, align) {
						K('#goodsImg').val(url);
						editor.hideDialog();
					}
				});
			});
		});
		
	});
	showGoodsExt('<%=goodsId%>');
	if('<%=goodsId%>'==''){
		$(".extAtt").val("0");
	}
});
function tijiaoData(){
	var data="";
    $.each($("#formMem").find(".extAtt"), function() {

        var li=$(this).attr("id")+":"+$(this).val();
        data=data+"_" +li;
    });
	data=data.slice(1);
	console.log(data);
	$("#allExtAttr").val(data);
	$("#formMem").submit();
}

function showGoodsExt(f_goods){
	//console.log(f_goods);
	if(f_goods=="") return false;
	$.ajax({
	   type: "POST",
	   url: "../../Server.asp",
	   data: "a=6&g="+f_goods,
	   dataType:"text",
	   success: function(ret){
		   //alert(ret);
		   console.log(ret);
		   var maxValue=0;
		   var maxType="";
		   var preType ="";
		   var dataJson = eval('('+ret+')');
		   for(var p in dataJson){
			   if(p!="collect"){//判断是否显示收藏
				   if(p.substring(1,p.length-1)!=preType){
						$("#"+p).parent().addClass("active-num");
						$("#"+p).css("color","red");
				   }
				   $("#"+p).val(dataJson[p]);
				   preType =p.substring(1,p.length-1);
			   }
			   
		   }

	   }
	});
}
</script>
</head>

<body>
<div class="place"> <span>位置：</span>
  <ul class="placeul">
    <li>首页</li>
    <li>系统管理</li>
    <li><%=pageTitle%></li>
  </ul>
</div>
<div class="formbody">
  <div class="formtitle"><span><%=pageTitle%></span></div>
  <ul class="forminfo1">
    <form action="" method="post" id="formMem">
      <input type="hidden" name="action" value="1" />
      <input type="hidden" name="allExtAttr" id="allExtAttr"/>
      <li>
        <label>名字：</label>
        <input name="goodsName" id="goodsName" type="text" class="txt1" value="<%=goodsName%>" />
      </li>
      <li>
        <label>ＱＱ：</label>
        <input name="goodsQq" id="goodsQq" type="text" class="txt1" value="<%=goodsQq%>" />
      </li>
      <li>
        <label>TEL：</label>
        <input name="goodsTel" id="goodsTel" type="text" class="txt1" value="<%=goodsTel%>" />
      </li>
      <li>
        <label>微信：</label>
        <input name="goodsWeixin" id="goodsWeixin" type="text" class="txt1" value="<%=goodsWeixin%>" />
      </li>
      <li>
        <label>时间：</label>
        <input name="useTime" id="useTime" type="text" class="txt1" value="<%=useTime%>" />
      </li>
      <li>
        <label>点赞：</label>
        <input name="goodsZan" id="goodsZan" type="text" class="txt1" value="<%=goodsZan%>" />
      </li>
      <li>
        <label>点踩：</label>
        <input name="goodsCai" id="goodsCai" type="text" class="txt1" value="<%=goodsCai%>" />
      </li>
      <li>
        <label>排序：</label>
        <input name="goodsOrderTime" id="goodsOrderTime" type="text" class="txt1" value="<%=goodsOrderTime%>" />
      </li>
      <li>
        <label>地址：</label>
        <input name="userAddress" id="userAddress" type="text" class="txt1" value="<%=userAddress%>" />
      </li>
      <li>
        <label>图片：</label>
        <input name="goodsImg" id="goodsImg" type="text" class="txt1" value="<%=goodsImg%>" />
        &nbsp;
        <input type="button" id="image" value="选择图片" />
        </td>
      </li>
      <li>
        <label>类型</label>
        <cite>
        <input name="isAd" type="radio" value="0" <% If isAd=0 Then Response.Write("checked='checked'")%> />
        妹子&nbsp;&nbsp;&nbsp;&nbsp;
        <input name="isAd" type="radio" value="1" <% If isAd=1 Then Response.Write("checked='checked'")%> />
        广告&nbsp;&nbsp;&nbsp;&nbsp;
        <input name="adUrl" type="text" value="<%=adUrl%>" class="txt1" style="width:450px;" />
        </cite></li>
      <li>
      
      <li style="width:700px;" id="extLi">
        <div class="row flex margin-b10"> <span class="fz24">基本资料</span>
          <div class="fwsp-line"></div>
        </div>
        <div class="row">
          <div class="flex padding-t5 vert-mid">
            <label>类型：</label>
            <div class="rown">
              <div class="col-3">[1H]
                <input type="text" class="txt1 txt5" name="price1p" id="price1p" value="<%=price1P%>">
                RMB</div>
              <div class="col-3">[2H]
                <input type="text" class="txt1 txt5" name="pricePp" id="pricePp" value="<%=pricePp%>">
                RMB</div>
              <div class="col-3">[长时]
                <input type="text" class="txt1 txt5" name="priceBy" id="priceBy" value="<%=priceBy%>">
                RMB</div>
              <div class="col-3">[整天]
                <input type="text" class="txt1 txt5" name="priceBt" id="priceBt" value="<%=priceBt%>">
                RMB</div>
            </div>
          </div>
        </div>
        <div class="row">
          <div class="flex padding-t5 vert-mid">
            <label>照片：</label>
            <div class="rown">
              <div class="col-2">[真实]
                <input type="number" class="txt1 txt5 extAtt" id="zhaopian0">
              </div>
              <div class="col-2">[不真实]
                <input type="number" class="txt1 txt5 extAtt" id="zhaopian1">
              </div>
            </div>
          </div>
        </div>
        <div class="row">
          <div class="flex padding-t5 vert-mid">
            <label>位置：</label>
            <div class="rown">
              <div class="col-2">[市中心]
                <input type="number" class="txt1 txt5 extAtt" id="place0">
              </div>
              <div class="col-2">[东门]
                <input type="number" class="txt1 txt5 extAtt" id="place1">
              </div>
              <div class="col-2">[南门]
                <input type="number" class="txt1 txt5 extAtt" id="place2">
              </div>
              <div class="col-2">[西门]
                <input type="number" class="txt1 txt5 extAtt" id="place3">
              </div>
              <div class="col-2">[北门]
                <input type="number" class="txt1 txt5 extAtt" id="place4">
              </div>
            </div>
          </div>
        </div>
        <div class="row">
          <div class="flex padding-t5 vert-mid">
            <label>环境：</label>
            <div class="rown">
              <div class="col-2">[不好]
                <input type="number" class="txt1 txt5 extAtt" id="huanjing0">
              </div>
              <div class="col-2">[一般]
                <input type="number" class="txt1 txt5 extAtt" id="huanjing1">
              </div>
              <div class="col-2">[很好]
                <input type="number" class="txt1 txt5 extAtt" id="huanjing2">
              </div>
            </div>
          </div>
        </div>
        <div class="row">
          <div class="flex padding-t5 vert-mid">
            <label>年龄：</label>
            <div class="rown">
              <div class="col-2">[18-23]
                <input type="number" class="txt1 txt5 extAtt" id="age0">
              </div>
              <div class="col-2">[24-29]
                <input type="number" class="txt1 txt5 extAtt" id="age1">
              </div>
              <div class="col-2">[30+]
                <input type="number" class="txt1 txt5 extAtt" id="age2">
              </div>
            </div>
          </div>
        </div>
        <div class="row">
          <div class="flex padding-t5 vert-mid">
            <label>颜值：</label>
            <div class="rown">
              <div class="col-2">[差]
                <input type="number" class="txt1 txt5 extAtt" id="yanzhi0">
              </div>
              <div class="col-2">[中等]
                <input type="number" class="txt1 txt5 extAtt" id="yanzhi1">
              </div>
              <div class="col-2">[中上]
                <input type="number" class="txt1 txt5 extAtt" id="yanzhi2">
              </div>
              <div class="col-2">[极品]
                <input type="number" class="txt1 txt5 extAtt" id="yanzhi3">
              </div>
            </div>
          </div>
        </div>
        <div class="row">
          <div class="flex padding-t5 vert-mid">
            <label>身高：</label>
            <div class="rown">
              <div class="col-2">[1.5-]
                <input type="number" class="txt1 txt5 extAtt" id="shengao0">
              </div>
              <div class="col-2">[1.5-1.6]
                <input type="number" class="txt1 txt5 extAtt" id="shengao1">
              </div>
              <div class="col-2">[1.6-1.7]
                <input type="number" class="txt1 txt5 extAtt" id="shengao2">
              </div>
              <div class="col-2">[1.7+]
                <input type="number" class="txt1 txt5 extAtt" id="shengao3">
              </div>
            </div>
          </div>
        </div>
        <div class="row">
          <div class="flex padding-t5 vert-mid">
            <label>体型：</label>
            <div class="rown">
              <div class="col-2">[骨感]
                <input type="number" class="txt1 txt5 extAtt" id="tixing0">
              </div>
              <div class="col-2">[丰满]
                <input type="number" class="txt1 txt5 extAtt" id="tixing1">
              </div>
              <div class="col-2">[肥胖]
                <input type="number" class="txt1 txt5 extAtt" id="tixing2">
              </div>
            </div>
          </div>
        </div>
        <div class="row">
          <div class="flex padding-t5 vert-mid">
            <label>催单：</label>
            <div class="rown">
              <div class="col-2">[会]
                <input type="number" class="txt1 txt5 extAtt" id="cuidan0">
              </div>
              <div class="col-2">[不会]
                <input type="number" class="txt1 txt5 extAtt" id="cuidan1">
              </div>
            </div>
          </div>
        </div>
        <div class="row">
          <div class="flex padding-t5 vert-mid">
            <label>服务：</label>
            <div class="rown">
              <div class="col-2">[无]
                <input type="number" class="txt1 txt5 extAtt" id="service0">
              </div>
              <div class="col-2">[不好]
                <input type="number" class="txt1 txt5 extAtt" id="service1">
              </div>
              <div class="col-2">[一般]
                <input type="number" class="txt1 txt5 extAtt" id="service2">
              </div>
              <div class="col-2">[很好]
                <input type="number" class="txt1 txt5 extAtt" id="service3">
              </div>
            </div>
          </div>
        </div>
        <div class="row">
          <div class="flex padding-t5 vert-mid">
            <label>态度：</label>
            <div class="rown">
              <div class="col-2">[不好]
                <input type="number" class="txt1 txt5 extAtt" id="taidu0">
              </div>
              <div class="col-2">[一般]
                <input type="number" class="txt1 txt5 extAtt" id="taidu1">
              </div>
              <div class="col-2">[很好]
                <input type="number" class="txt1 txt5 extAtt" id="taidu2">
              </div>
            </div>
          </div>
        </div>
      </li>
      <li style="width:600px; text-align:center;">
        <label>&nbsp;</label>
        <span class="btn btn-success" onclick="tijiaoData();"> 保存 </span> </li>
    </form>
  </ul>
</div>
<%
If goodsId<>"" Then
%>
<div class="rightinfo">
  
  <table class="tablelist" style="width:800px;">
    <thead>
      <tr>
        <th>评论者</th>
        <th>评论内容</th>
        <th>评论时间</th>
        <th>操作</th>
      </tr>
    </thead>
    <tbody>
	<%
	Call OpenDataBase
	Set goodsRs=Conn.Execute("select a.*,b.mem_name from BL_s_goods_comment_info a,BL_m_member_info b where a.comment_desc<>'' and a.mem_id=b.id and a.goods_id=" & goodsId)


	Do While Not goodsRs.Eof
		
	%>
      <tr>
        <td><%=goodsRs("mem_name")%></td>
        <td><%=goodsRs("comment_desc")%></td>
        <td><%=goodsRs("comment_time")%></td>
        <td><a class='tablelink' href='commentEdit.asp?id=<%=goodsRs("id")%>'>修改</a></td>
      </tr>
      <%
     	goodsRs.MoveNext
	Loop

	goodsRs.Close
	Set goodsRs = Nothing
	Call connClose
    %>
    </tbody>
  </table>
</div>
<%
End If
%>
</body>
</html>
