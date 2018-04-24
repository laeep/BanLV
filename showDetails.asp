<!--#include file="inc/Const.asp"-->
<!--#include file="inc/Conn.asp"-->
<!--#include file="inc/Session.asp"-->
<%
Dim goodsId,priceString,QQ,Weixin,Tel
goodsId =Request.QueryString("id")
If goodsId="" THen
	Response.Write("非法访问1！")
	Response.End()
Else
	goodsId =CLng(goodsId)
End If
If IsNull(Session(G_SessionPre&"_Mem_ID")) Or Session(G_SessionPre&"_Mem_ID")="" Then
	Response.Redirect("showDetails_youke.asp?id="&goodsId)
End If
'判断浏览权限
If Not JudgePower("P020000") Then
	Call OpenDataBase
	browseNum=Conn.Execute("select Count(id) from BL_r_browse_log where datediff(day,insert_time,getdate())=0 and mem_id="&Session(G_SessionPre&"_Mem_ID"))(0)
	Call connClose
	
	If Not JudgePower("P020010") Then
		Error1("您的浏览次数已经超过每日上限！请提升浏览权限！")
	Else
		If browseNum>=3 Then
			Error1("您的浏览次数已经超过每日上限！请提升浏览权限！")
		End If
	End If
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
If goodsRs("goods_qq")="" then QQ="-" else QQ=goodsRs("goods_qq")
If goodsRs("goods_mobile")="" then Tel="-" else Tel=goodsRs("goods_mobile")
If goodsRs("goods_weixin")="" then Weixin="-" else Weixin=goodsRs("goods_weixin")
%>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8" />
		<meta name="viewport" content="width=device-width,initial-scale=1.0,user-scalable=no">
		<meta name="format-detection" content="telephone=no">
		<title>详情界面</title>
		<link rel="stylesheet" type="text/css" href="css/style.css"/>
		<link rel="stylesheet" href="css/index.css" />
		<script src="js/jquery-2.2.3.min.js"></script>
        <script src="js/comm.js?v=2"></script>
        <script src="js/showDetail.js"></script>
	</head>
	<body>
    <div class="login-tcbox">
        <div class="login-mask" style="background:rgba(0,0,0,0.5);"></div>
        <div class="login-tc">
            <div class="jinggao">特约倡导文明的有偿约会活动，加强人与人之间的真诚交流，严禁卖淫嫖娼等非法目的的约会。如果对方像您提出非法要求，请联系网站管理进行举报，我们会严肃处理，谢谢！
</div>
            <div class="login-line"></div>
            <div class="login-btn"><a href="javascript:;" class="tel-close">我知道了</a></div>
        </div>
    </div>
    
    <div class="tc-fx-mask hidden">
    <div class="tc-fx-box">
			<a class="fxclose"><img src="images/close.png" width="32"></a>
			<div class="tc-fx-box2">
				<h3>您的分享链接已经生成</h3>
				<div class="fx1">请手动选择链接后复制</div>
				<div class="fx2"></div>
			</div>
		</div>
    </div>
		
		<article class="jubao">
			
				<div class="row showtoux flex showtoux1">
					<a class="home02" href="index_tuijian.asp"><img src="images/home02.png" width="32" height="32"></a>
					<div class="showtoux-co1"><span id="f_goods_id" style="display:none;"><%=goodsRs("id")%></span>
						<span class="icon icon-zan" attr="1a<%=goodsRs("id")%>" onClick="zancai(1,<%=goodsRs("id")%>)"><%=goodsRs("goods_zan")%></span>
                        <span class="icon icon-love" id="collect0" style="display:none;" onClick="collectGoods(0,<%=goodsRs("id")%>);">收藏</span><span class="icon icon-nolove" id="collect1" style="display: none;" onClick="collectGoods(1,<%=goodsRs("id")%>);">取消</span>
					</div>
					<div class="showtoux-co2">
						<div class="text-align"><img src="<%=goodsRs("goods_photo_url")%>" width="100%"></div>
						<div class="tx-txt">
							<div class="fz16"><%=goodsRs("goods_name")%></div><div><%=priceString%></div>
                            <div class="show-tc-btn">
                                <div class="tel-txt">
                                    <span>QQ:<%=QQ%></span>  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                    <%
                                    If Not JudgePower("P000017") Then
                                    %>
                                    <span style="line-height: 1.5;">
                                        <span class="tel2"><%=Tel%></span>
                                    </span>
                                    <%Else%>
                                    <span style="line-height: 1.5;">
                                        <a href="tel:<%=Tel%>"><span class="tel1"><%=Tel%></span></a>
                                    </span>
                                    <%End If%>
                                </div>
                                <div>微信：<%=Weixin%></div>
							</div>
						</div>
					</div>
					<div class="showtoux-co1 float-left">
						<span class="icon icon-cai" attr="2a<%=goodsRs("id")%>" onClick="zancai(2,<%=goodsRs("id")%>)"><%=goodsRs("goods_cai")%></span>
						<span class="icon icon-share" id="share">分享</span>
					</div>
					
				</div>
				
			
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
				
				<div class="row">
					<div class="flex padding-t5 vert-mid">
						<label class="lab1">催单：</label>
						<div class="rown">
							<div class="col-6">[会]<span class="num-line" id="cuidan0">-</span></div>
							<div class="col-6">[不会]<span class="num-line" id="cuidan1">-</span></div>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="flex padding-t5 vert-mid">
						<label class="lab1">服务：</label>
						<div class="rown">
                        	<div class="col-4">[无]<span class="num-line" id="service0">-</span></div>
							<div class="col-4">[不好]<span class="num-line" id="service1">-</span></div>
							<div class="col-4">[一般]<span class="num-line" id="service2">-</span></div>
							<div class="col-4">[很好]<span class="num-line" id="service3">-</span></div>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="flex padding-t5 vert-mid">
						<label class="lab1">态度：</label>
						<div class="rown">
							<div class="col-4">[不好]<span class="num-line" id="taidu0">-</span></div>
							<div class="col-4">[一般]<span class="num-line" id="taidu1">-</span></div>
							<div class="col-4">[很好]<span class="num-line" id="taidu2">-</span></div>
						</div>
					</div>
				</div>
				
				
				<div class="details-bg"></div>
				
				<div class="row flex">
					<span class="fz24">用户评论</span><div class="fwsp-line"></div>&nbsp;<div class="fuwu-show"><span>展开</span>&nbsp;<img src="images/arrow-down.png" height="6"></div>
				</div>
				
				<div class="fuwu-con" style="display: none;">
				
					<%
					goodsRs.Close
					Set goodsRs = Nothing
					Call OpenDataBase
					Set CommentRs=Conn.Execute("select a.*,b.mem_name from BL_s_goods_comment_info a,BL_m_member_info b where a.mem_id=b.id and a.comment_desc<>'' and a.goods_id="&goodsId)
					Do While Not CommentRs.Eof
					
					%>
                    
                    <div class="row padding-lr20">
						<!--span class="color80">用户 <%=CommentRs("mem_name")%>：</span-->
						<div class="comment-item row">
							<div>
								 <%=CommentRs("comment_desc")%>
							</div>
							<div class="dingcai"><span onClick="zancaiComment(1,<%=CommentRs("id")%>)"> 顶 </span><span id="a<%=CommentRs("id")%>">[<%=CommentRs("comment_zan")%>]</span><span onClick="zancaiComment(2,<%=CommentRs("id")%>)"> 踩 </span><span id="b<%=CommentRs("id")%>">[<%=CommentRs("comment_cai")%>]</span></div>
						</div>
					</div>
                    <%
						CommentRs.MoveNext
					Loop
					CommentRs.Close
					Set CommentRs = Nothing
					'写浏览日志
					Conn.Execute("insert into BL_r_browse_log(mem_id,goods_id) values("&Session(G_SessionPre&"_Mem_ID")&","&goodsId&")")
					
					Call connClose
					%>
					
					
				</div>
				
				
				<div class="row text-align margin-t5">
					<input type="button" value="参与点评" class="btn btn-success" onclick="location.href='comment.asp?id=<%=goodsId%>'" />
				</div>
			
		</article>
		
		<section class="screenW">
        <div class="subW">
            <div class="info">
                <div class="shareBox">
                    <h2>请选择您的分享方式：</h2>
                    <div class="bdsharebuttonbox">
                        <a href="#" class="bds_qzone" data-cmd="qzone" title="分享到QQ空间">QQ空间</a>
                        <a href="#" class="bds_tsina" data-cmd="tsina" title="分享到新浪微博">新浪微博</a>
                        <a href="#" class="bds_sqq" data-cmd="sqq" title="分享到QQ好友">QQ</a>
                        <a href="#" class="bds_tqq" data-cmd="tqq" title="分享到腾讯微博">腾讯微博</a>
                    </div>
                    <div class="bdsharebuttonbox">
                        <a href="#" onclick="return false;" class="popup_more" data-cmd="more"></a>
                    </div>
                </div>
            </div>
            <div class="close">关闭</div>
        </div>
    </section>
    <script>
		$('.tel-close').click(function(){
			$(this).parents('.login-tcbox').hide();
		});
		$('.show-tc-btn').one('click',function(){
			$('.login-tcbox').show();
		});
	</script>
<div style="display:none;"><script src="https://s22.cnzz.com/z_stat.php?id=1262562117&web_id=1262562117" language="JavaScript"></script></div>
	</body>
</html>
