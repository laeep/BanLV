<%
Dim youkeShowString,memShowString

'读取广告
If Application("topAdLink")="" Or isNull(Application("topAdLink")) Then
	Call OpenDataBase
	Set adRs=Conn.Execute("select Top 1 * from BL_s_ad_info order by id desc")
	If Not adRs.Eof Then
		Application("topAdLink")=adRs("ad_link_url")
		Application("topAdUrl")=adRs("ad_img_url")
	End If
	Call connClose
End If
If IsNull(Session(G_SessionPre&"_Mem_ID")) Or Session(G_SessionPre&"_Mem_ID")="" Then
	youkeShowString =""
	memShowString =" hidden"
%>
<header class="headtop-sear row flex">
  <div class="logo"><a href="index_tuijian.asp"><img src="images/img/logo1.png"></a></div>
  <div class="name" style="padding-right: 0;"> <span class="mz">游客</span>
    <div style="font-size: 1.5rem; margin-top: 2px;"><a href="login.asp" class="color80">登录</a>&nbsp; <a href="reg.asp" class="color80">注册</a></div>
  </div>
</header>
<%
Else
	youkeShowString =" hidden"
	memShowString =""
%>
<header class="headtop-sear row flex">
  <div class="logo"><a href="index_tuijian.asp"><img src="images/img/logo1.png"></a></div>
  <div class="name"> <span class="mz"><%=Session(G_SessionPre&"_Mem_Nick")%></span><br>
    <span class="ch"><%=Session(G_SessionPre&"_Mem_Lable")%></span> </div>
  <div class="xtx"><a href="my_info.asp"><img src="<%=Session(G_SessionPre&"_Mem_Photo")%>"></a></div>
</header>
<%
End If
%>
<div><a href="<%=Application("topAdLink")%>" target="_blank"><img src="<%=Application("topAdUrl")%>" width="100%"></a> </div>