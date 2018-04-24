<!--#include file="inc/Const.asp"-->
<!--#include file="inc/Conn.asp"-->
<!--#include file="inc/Session.asp"-->
<%
Call IsLogin
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width,initial-scale=1.0,user-scalable=no">
<meta name="format-detection" content="telephone=no">
<title>会员定制</title>
<link rel="stylesheet" type="text/css" href="css/style.css"/>
<script src="js/jquery-2.2.3.min.js"></script>
<script type="text/javascript" src="js/dingzhi.js?V=1"></script>
</head>
<body style="background: #FFFFFF;">
<header class="header-dingzhi">
          <div class="row margin-b10 text-align"> 尊敬的 <%=Session(G_SessionPre&"_Mem_Name")%> ，请选择您感兴趣的推荐条件 </div>
        </header>
<section>
          <div id="search-form">
    <div class="row">
              <div class="flex padding-t5 vert-mid">
        <label class="lab1">位置：</label>
        <div class="rown">
                  <div class="col-4"><span attr="place0">[市中心]</span></div>
                  <div class="col-4"><span attr="place1">[东门]</span></div>
                  <div class="col-4"><span attr="place2">[南门]</span></div>
                  <div class="col-4"><span attr="place3">[西门]</span></div>
                  <div class="col-4"><span attr="place4">[北门]</span></div>
                </div>
      </div>
            </div>
    <div class="row">
              <div class="flex padding-t5 vert-mid">
        <label class="lab1">价格：</label>
        <div class="rown">
                  <div class="col-4"><span attr="price0">[600以下]</span></div>
                  <div class="col-4"><span attr="price1">[600-1000]</span></div>
                  <div class="col-4"><span attr="price2">[1000以上]</span></div>
                </div>
      </div>
            </div>
    <div class="row">
              <div class="flex padding-t5 vert-mid">
        <label class="lab1">服务：</label>
        <div class="rown">
                  <div class="col-6"><span attr="service0">[无]</span></div>
                  <div class="col-6"><span attr="service1">[不好]</span></div>
                  <div class="col-6"><span attr="service2">[一般]</span></div>
                  <div class="col-6"><span attr="service3">[很好]</span></div>
                </div>
      </div>
            </div>
    <div class="row">
              <div class="flex padding-t5 vert-mid">
        <label class="lab1">环境：</label>
        <div class="rown">
                  <div class="col-4"><span attr="huanjing0">[不好]</span></div>
                  <div class="col-4"><span attr="huanjing1">[一般]</span></div>
                  <div class="col-4"><span attr="huanjing2">[很好]</span></div>
                </div>
      </div>
            </div>
    <div class="row">
              <div class="flex padding-t5 vert-mid">
        <label class="lab1">年龄：</label>
        <div class="rown">
                  <div class="col-4"><span attr="age0">[18-23]</span></div>
                  <div class="col-4"><span attr="age1">[24-29]</span></div>
                  <div class="col-4"><span attr="age2">[30+]</span></div>
                </div>
      </div>
            </div>
    <div class="row">
              <div class="flex padding-t5 vert-mid">
        <label class="lab1">颜值：</label>
        <div class="rown">
                  <div class="col-6"><span attr="yanzhi0">[差]</span></div>
                  <div class="col-6"><span attr="yanzhi1">[中等]</span></div>
                  <div class="col-6"><span attr="yanzhi2">[中上]</span></div>
                  <div class="col-6"><span attr="yanzhi3">[极品]</span></div>
                </div>
      </div>
            </div>
    <div class="row">
              <div class="flex padding-t5 vert-mid">
        <label class="lab1">身高：</label>
        <div class="rown">
                  <div class="col-6"><span attr="shengao0">[1.5-]</span></div>
                  <div class="col-6"><span attr="shengao1">[1.5-1.6]</span></div>
                  <div class="col-6"><span attr="shengao2">[1.6-1.7]</span></div>
                  <div class="col-6"><span attr="shengao3">[1.7+]</span></div>
                </div>
      </div>
            </div>
    <div class="row">
              <div class="flex padding-t5 vert-mid">
        <label class="lab1">体型：</label>
        <div class="rown">
                  <div class="col-4"><span attr="tixing0">[骨感]</span></div>
                  <div class="col-4"><span attr="tixing1">[丰满]</span></div>
                  <div class="col-4"><span attr="tixing2">[肥胖]</span></div>
                </div>
      </div>
            </div>
    <hr style="margin-bottom: 10px;">
    <div class="row text-align"> <span class="btn btn-success" onClick="tijiao();">确认</span></div>
  </div>
        </section>
</article>
<div style="display:none;"><script src="https://s22.cnzz.com/z_stat.php?id=1262562117&web_id=1262562117" language="JavaScript"></script></div>

</body>
</html>
