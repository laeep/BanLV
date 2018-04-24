<!--#include file="inc/Const.asp"-->
<!--#include file="inc/Conn.asp"-->
<!--#include file="inc/Session.asp"-->

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width,initial-scale=1.0,user-scalable=no">
<meta name="format-detection" content="telephone=no">
<title>搜索</title>
<link rel="stylesheet" type="text/css" href="css/style.css?v=1"/>
<script src="js/jquery-2.2.3.min.js"></script>
<script src="js/comm.js"></script>
<script src="js/waterfall-search.js?v=11"></script>
<script src="js/toTop.js"></script>
</head>
<body style="background: #E2E2E2;">
<!--#include file="inc/top.asp"-->
<article class="main-search jubao index-tuijian index-search" id="index-search">
  <section>
    <nav class="nav-menu flex"> <a href="index_tuijian.asp">当月验证</a> <a href="index_renqi.asp">人气榜</a> <a href="index_xinren.asp">新人榜</a> <a href="index_heibang.asp">黑榜</a> <a href="search.asp" class="active5">搜索</a> </nav>
  </section>
  <section>
    <div class="row<%=youkeShowString%>">
      <div class="sorry color80">很抱歉，现在是游客模式，无法搜索</div>
    </div>
    <div class="search-form<%=memShowString%>">
      <div class="row margin-b10">
        <div class="sear-box margin-tb10 flex">
          <input type="text" placeholder="搜索名字/QQ/电话" class="search-txt" id="iSimpleSearch"/>
          <input type="button" value="" class="serach-btn" onClick="simpleSearch();" />
        </div>
      </div>
      <hr />
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
      <div class="row">
        <div class="flex padding-t5 vert-mid">
          <label class="lab1">态度：</label>
          <div class="rown">
            <div class="col-4"><span attr="taidu0">[不好]</span></div>
            <div class="col-4"><span attr="taidu1">[一般]</span></div>
            <div class="col-4"><span attr="taidu2">[很好]</span></div>
          </div>
        </div>
      </div>
      <hr>
      <div class="row text-align margin-t5"> <span class="btn btn-success" style="margin-bottom:0" onClick="dingzhiSearch();">搜索</span> </div>
    </div>
    <div class="user-pbl" id="user-pbl">
      <ul class="user-list" id="user-main">
      </ul>
    </div>
    <div id="reset-con" style="display:none; clear: both; overflow: hidden;">
      <div class="margin-t15"></div>
      <hr>
      <div class="row text-align margin-t5"> <span id="noData" style="display:none;">没有数据<br><br></span></span><span id="searching" style="display:none;">正在搜索，请稍后……<br><br></span><span class="btn btn-success" style="margin-bottom:0" id="reset-search">重新搜索</span> </div>
    </div>
  </section>
</article>
<div style="display:none;"><script src="https://s22.cnzz.com/z_stat.php?id=1262562117&web_id=1262562117" language="JavaScript"></script></div>
</body>
</html>
