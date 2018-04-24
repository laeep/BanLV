<!--#include file="inc/Const.asp"-->
<!--#include file="inc/Conn.asp"-->
<%
Dim goodsId,priceString
goodsId =Request.QueryString("id")
If goodsId="" THen
	Response.Write("非法访问1！")
	Response.End()
Else
	goodsId =CLng(goodsId)
End If

Call OpenDataBase
Set goodsRs=Conn.Execute("select goods_name,price,id,goods_zan,goods_cai,goods_photo_url,goods_mobile,goods_weixin,goods_qq from BL_V_goods_list where id="&goodsId)
If goodsRs.Eof Then
	goodsRs.Close
	Set goodsRs = Nothing
	Call connClose
	Response.Write("非法访问2！")
	Response.End()
End If
priceString = Replace(GoodsRs("price"),"8888.66","-")
priceString = Replace(priceString,"/","M/") & "M"
priceString = Replace(priceString,"-M","-")


%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8" />
		<meta name="viewport" content="width=device-width,initial-scale=1.0,user-scalable=no">
		<meta name="format-detection" content="telephone=no">
		<title>游客模式</title>
		<link rel="stylesheet" type="text/css" href="css/style.css"/>
		<script src="js/jquery-2.2.3.min.js"></script>
        <script src="js/comm.js"></script>
        <script language="javascript">
		$(function(){
			//showGoodsExt();
		});
		</script>
	</head>
	<body>

		<header class="headtop-sear row flex">
			<div class="logo"><a href="index_tuijian.asp"><img src="images/img/logo1.png"></a></div>
			<div class="name" style="padding-right: 0;">
				<span class="mz">游客</span>
				<div style="font-size: 1.5rem; margin-top: 2px;"><a href="login.asp" class="color80">登录</a>&nbsp; <a href="reg.asp" class="color80">注册</a></div>
			</div>
		</header>
		
		<article class="jubao">
			
				<div class="row showtoux flex">
					
					<div class="showtoux-co1">
						<span class="icon icon-zan2"><%=goodsRs("goods_zan")%></span><span id="f_goods_id" style="display:none;"><%=goodsRs("id")%></span>
					</div>
					<div class="showtoux-co2">
						<div class="text-align" style="background: #FFF;"><img src="<%=goodsRs("goods_photo_url")%>" width="100%" class="filter"></div>
						<div class="tx-txt">
							<div class="fz16"><%=goodsRs("goods_name")%></div>
							<div><%=priceString%></div>
						</div>
					</div>
					<div class="showtoux-co1 float-left">
						<span class="icon icon-cai2"><%=goodsRs("goods_cai")%></span>
					</div>
					
				</div>
				<%
				goodsRs.Close
				Set goodsRs = Nothing
				Call connClose
				%>
			
				<div class="row flex margin-b10">
					<span class="fz24">基本资料</span><div class="fwsp-line"></div>
				</div>
				<div class="row">
					<div class="flex padding-t5 vert-mid">
						<label class="lab1">照片：</label>
						<div class="rown">
							<div class="col-6">[真实]<span class="num-line" id="zhaopian0">-</span></div>
							<div class="col-6">[不真实]<span class="num-line" id="zhaopian1">-</span></div>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="flex padding-t5 vert-mid">
						<label class="lab1">位置：</label>
						<div class="rown">
							<div class="col-4">[市中心]<span class="num-line" id="place0">-</span></div>
							<div class="col-4">[东门]<span class="num-line" id="place1">-</span></div>
							<div class="col-4">[南门]<span class="num-line" id="place2">-</span></div>
							<div class="col-4">[西门]<span class="num-line" id="place3">-</span></div>
							<div class="col-4">[北门]<span class="num-line" id="place4">-</span></div>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="flex padding-t5 vert-mid">
						<label class="lab1">环境：</label>
						<div class="rown">
							<div class="col-4">[不好]<span class="num-line" id="huanjing0">-</span></div>
							<div class="col-4">[一般]<span class="num-line" id="huanjing1">-</span></div>
							<div class="col-4">[很好]<span class="num-line" id="huanjing2">-</span></div>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="flex padding-t5 vert-mid">
						<label class="lab1">年龄：</label>
						<div class="rown">
							<div class="col-4">[18-23]<span class="num-line" id="age0">-</span></div>
							<div class="col-4">[24-29]<span class="num-line" id="age1">-</span></div>
							<div class="col-4">[30+]<span class="num-line" id="age2">-</span></div>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="flex padding-t5 vert-mid">
						<label class="lab1">颜值：</label>
						<div class="rown">
							<div class="col-6">[差]<span class="num-line" id="yanzhi0">-</span></div>
							<div class="col-6">[中等]<span class="num-line" id="yanzhi1">-</span></div>
							<div class="col-6">[中上]<span class="num-line" id="yanzhi2">-</span></div>
							<div class="col-6">[极品]<span class="num-line" id="yanzhi3">-</span></div>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="flex padding-t5 vert-mid">
						<label class="lab1">身高：</label>
						<div class="rown">
							<div class="col-6">[1.5-]<span class="num-line" id="shengao0">-</span></div>
							<div class="col-6">[1.5-1.6]<span class="num-line" id="shengao1">-</span></div>
							<div class="col-6">[1.6-1.7]<span class="num-line" id="shengao2">-</span></div>
							<div class="col-6">[1.7+]<span class="num-line" id="shengao3">-</span></div>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="flex padding-t5 vert-mid">
						<label class="lab1">体型：</label>
						<div class="rown">
							<div class="col-4">[骨感]<span class="num-line" id="tixing0">-</span></div>
							<div class="col-4">[丰满]<span class="num-line" id="tixing1">-</span></div>
							<div class="col-4">[肥胖]<span class="num-line" id="tixing2">-</span></div>
						</div>
					</div>
				</div>
				
				<div class="row text-align">
					<div style="margin: 0 0 10px 0; color: #D10101;">很抱歉，现在是游客模式，无法查看更多信息</div>
				</div>
				
				<div class="details-bg"></div>
				
				<div class="row flex margin-b10">
					<span class="fz24">用户评论</span><div class="fwsp-line"></div>
				</div>
				
				
			
		</article>
		<div style="display:none;"><script src="https://s22.cnzz.com/z_stat.php?id=1262562117&web_id=1262562117" language="JavaScript"></script></div>
	</body>
</html>
