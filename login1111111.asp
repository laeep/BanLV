<!--#include file="inc/Const.asp"-->

<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8" />
		<meta name="viewport" content="width=device-width,initial-scale=1.0,user-scalable=no">
		<meta name="format-detection" content="telephone=no">
		<title>登录</title>
		<link rel="stylesheet" type="text/css" href="css/style.css"/>
		<link rel="stylesheet" type="text/css" href="css/index.css"/>
		<script src="js/jquery-2.2.3.min.js"></script>
	</head>
	<body>
		
		<header class="headtop">
			<img src="images/logo.png">
			<h3 class="pink" style="font-weight:400"><span class="fz16"><!--[ </span>有偿约会交友平台<span class="fz16"> ]</span>!--></h3>
		</header>
		
		<article>
			<form action="chkLogin.asp?a=1" method="post"><input type="hidden" name="url" value=<%=comeUrl%>>
				<div class="row">
					<ul class="login-box">
						<li><input type="text" placeholder="您的用户名" name="userName" /></li>
						<li><input type="password" placeholder="您的密码" name="userPass" /></li>
					</ul>
				</div>
				<div class="login-tcbox">
					<div class="login-mask"></div>
					<div class="login-tc">
						<div class="jinggao">警告：约会内容必须符合中国法律，严禁以约会为名实行卖淫嫖娼之实，一经发现网站将立即报警，并对违法账号封禁处理。</div>
						<div class="login-line"></div>
						<div class="login-btn"><input type="submit" value="我知道了"></div>
					</div>
				</div>
				<div class="row margin-tb20">
					<input type="button" value="登录" class="btn btn-success btn-block" id="login-btn" />
					<input type="button" value="注册" class="btn btn-default btn-block" onclick="location.href='reg.asp'" />
					<input type="button" value="游客模式" class="btn btn-default btn-block"  onclick="location.href='index_tuijian.asp'"/>
					<!--<div class="text-align"><a href="index_tuijian.asp" class="login-wsyk">游客模式</a></div> !-->
				</div>
				<div class="row">
					
				</div>
			</form>
		</article>
        <script>
			$('#login-btn').click(function(){
				$('.login-tcbox').show();
			})
			
		</script>
		<div style="display:none;"><script src="https://s22.cnzz.com/z_stat.php?id=1262562117&web_id=1262562117" language="JavaScript"></script></div>
	</body>
</html>