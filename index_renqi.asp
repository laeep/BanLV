<!--#include file="inc/Const.asp"-->
<!--#include file="inc/Conn.asp"-->
<!--#include file="inc/Function.asp"-->
<!--#include file="inc/Session.asp"-->
<%
'Call IsLogin
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width,initial-scale=1.0,user-scalable=no">
<meta name="format-detection" content="telephone=no">
<title>人气榜</title>
<link rel="stylesheet" type="text/css" href="css/style.css?v=1"/>
<script src="js/jquery-2.2.3.min.js"></script>
<script src="js/comm.js?v=11"></script>
<script src="js/waterfall.js?v=11"></script>
<script src="js/toTop.js"></script>

</head>
<body class="home-renqi">

<!--#include file="inc/top.asp"-->
<article class="main-search jubao index-tuijian index-renqi">
  <section>
    <nav class="nav-menu flex"> <a href="index_tuijian.asp">当月验证</a> <a href="index_renqi.asp" class="active2">人气榜</a> <a href="index_xinren.asp">新人榜</a> <a href="index_heibang.asp">黑榜</a> <a href="search.asp">搜索</a> </nav>
  </section>
  <section>
    <div class="user-pbl">
      <ul class="user-list" id="user-main">

      </ul>
    </div>
  </section>
</article>
<div style="display:none;"><script src="https://s22.cnzz.com/z_stat.php?id=1262562117&web_id=1262562117" language="JavaScript"></script></div>
</body>
</html>
