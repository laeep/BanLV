<!--#include file="inc/Const.asp"-->
<!--#include file="inc/Conn.asp"-->
<!--#include file="inc/Function.asp"-->
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width,initial-scale=1.0,user-scalable=no">
<meta name="format-detection" content="telephone=no">
<title>黑榜</title>
<link rel="stylesheet" type="text/css" href="css/style.css"/>
<script src="js/jquery-2.2.3.min.js"></script>
<script src="js/comm.js"></script>
<script src="js/waterfall-heibang.js"></script>
<script src="js/toTop.js"></script>
</head>
<body class="home-heibang">

<!--#include file="inc/top.asp"-->

<article class="main-search jubao index-tuijian index-heibang" id="index-heibang">
  <section>
    <nav class="nav-menu flex"> <a href="index_tuijian.asp">当月验证</a> <a href="index_renqi.asp">人气榜</a> <a href="index_xinren.asp">新人榜</a> <a href="index_heibang.asp" class="active4">黑榜</a> <a href="search.asp">搜索</a> </nav>
  </section>
  <section>
    <div class="row<%=youkeShowString%>">
      <div class="sorry color80" style="color: #003D38;">很抱歉，现在是游客模式，无法查看更多信息</div>
    </div>
    <div class="user-pbl<%=memShowString%>">
      <ul class="user-list" id="user-main">
        
      </ul>
    </div>
  </section>
</article>
<div style="display:none;"><script src="https://s22.cnzz.com/z_stat.php?id=1262562117&web_id=1262562117" language="JavaScript"></script></div>
</body>
</html>
