<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="../inc/const.asp"-->
<!--#include file="../inc/conn.asp"-->
<!--#include file="../Session.asp" -->
<!--#include file="../inc/Function.asp" -->
<%
If Not JudgePower("admin") Then Error1

Dim CurrPage,orderBy,orderByColumn,startIndex,endIndex
CurrPage=Request.QueryString("page")
If(Instr(1,CurrPage,"<")>0) Then
	Response.End
End If
If CurrPage="" Then 
	CurrPage=1
Else
	CurrPage = Cint(CurrPage)
	If CurrPage<1 Then
		CurrPage=1
	End If
End IF

orderBy	=Request.QueryString("o")
If orderBy="" Then orderBy=0
Select Case orderBy
	Case 1'按点赞
		orderByColumn="a.goods_zan"
	Case 2'按点踩
		orderByColumn="a.goods_cai"
	Case 3'按评论数
		orderByColumn="a.goods_comment_num"
	Case 4'按评论数
		orderByColumn="a.comment_last_time"
	Case 0
		orderByColumn="a.id"
End Select

Dim goodsName,goodsQQ_TEL_WX,sqlWhere,ssql
goodsName = Request.Form("goodsName")
goodsQQ_TEL_WX = Request.Form("goodsQQ_TEL_WX")

sqlWhere = Request("s")
If sqlWhere="" Then
	sqlWhere = " 1=1"
	If goodsName<>"" Then
		sqlWhere = sqlWhere & " and goods_name like '%"&goodsName&"%'"
	End If
	If goodsQQ_TEL_WX<>"" Then
		sqlWhere = sqlWhere & " and (goods_mobile='"&goodsQQ_TEL_WX&"' or goods_weixin='"&goodsQQ_TEL_WX&"' or goods_qq='"&goodsQQ_TEL_WX&"')"
	End If
End IF

sqlWhere=replace(sqlWhere,"_kongge_"," ")
sqlWhere=replace(sqlWhere,"_dian_",".")
sqlWhere=replace(sqlWhere,"_douhao_",",")
sqlWhere=replace(sqlWhere,"_dengyuhao_","=")
sqlWhere=replace(sqlWhere,"_baifenhao_","%")
sqlWhere=replace(sqlWhere,"_dayuhao_",">")
sqlWhere=replace(sqlWhere,"_xiaoyuhao_","<")
sqlWhere=replace(sqlWhere,"_danyinhao_","'")

Dim f_CountRecNum,f_PageNum
f_PageNum = 20

Call OpenDataBase  

f_CountRecNum = Conn.Execute("select count(id) from BL_s_goods_info where"&sqlWhere)(0)
f_CountPageNum = JInt(f_CountRecNum,f_PageNum)


startIndex 	= (CurrPage-1)*f_PageNum+1
endIndex	= CurrPage*f_PageNum

ssql ="select * from (select row_number() over(order by "&orderByColumn&" desc) as rowNum,a.*,b.mem_name from BL_s_goods_info a,BL_m_member_info b where "&sqlWhere&" and a.goods_mem_id=b.id) a where rowNum between "&startIndex&" and " &  endIndex
'If CurrPage = 1 Then
'	ssql = "select top "&f_PageNum&" a.*,b.mem_name from BL_s_goods_info a,BL_m_member_info b where "&sqlWhere&" and a.goods_mem_id=b.id order by a.id desc"
'Else
'	ssql = "select top "&f_PageNum&" a.*,b.mem_name from BL_s_goods_info a,BL_m_member_info b where a.id<(select min(id) from (select top "&Cstr(f_PageNum*(CurrPage-1))&" id from BL_s_goods_info where "&sqlWhere&" order by id desc) as t) and "&sqlWhere&" and a.goods_mem_id=b.id order by a.id desc"
'End If
'Response.Write(ssql)
Set rec= Conn.execute(ssql)   
     
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<META HTTP-EQUIV="Pragma"  CONTENT="no-cache">    
<META HTTP-EQUIV="Cache-Control" CONTENT="no-cache">    
<META HTTP-EQUIV="Expires" CONTENT="0">  
<title>列表</title>
<link href="../css/style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="../js/jquery.js"></script>
<script language="javascript">
$(document).ready(function(){
	$(".cancel").click(function(){
  		$(".tip").fadeOut(100);
	});
	$(".tiptop a").click(function(){
	  $(".tip").fadeOut(200);
	});
});
function delInfoSure(f_Id,f_page){
	$("#Id").val(f_Id);
	$("#page").val(f_page);
	$(".tip").fadeIn(200);
}
function delInfoOk(){
	var f_Id=$("#Id").val();
	var f_page =$("#page").val();
	location.href='shareDel.asp?id='+f_Id+'&p='+f_page;
}
</script>
</head>

<body>
<div class="place"> <span>位置：</span>
  <ul class="placeul">
    <li>首页</li>
    <li>系统管理</li>
    <li>列表</li>
  </ul>
</div>
<div class="rightinfo">

  <form method="POST" action="" align="center">
    <ul class="prosearch">
      <li>
        <label>查询：</label>
        <i>名字</i><a>
        <input id="goodsName" name="goodsName" type="text" class="scinput" value="<%=goodsName%>" />
        </a> <i>手机、微信、ＱＱ</i><a>
        <input id="goodsQQ_TEL_WX" name="goodsQQ_TEL_WX" type="text" class="scinput" value="<%=memMobile%>" />
        </a> <a>
        <input name="" type="submit" class="sure" value="查询"/>
        </a></li>
    </ul>
  </form>
  
  <table class="tablelist1">
    <thead>
      <tr>
       	<th>编号</th>
        <th>名字</th>
        <th>分享者</th>
        <th>微信</th>
        <th>手机</th>
        <th>ＱＱ</th>
        <th>图片</th>
        <th><a href="sharelist.asp?o=1">赞数</a></th>
        <th><a href="sharelist.asp?o=2">踩数</a></th>
        <th><a href="sharelist.asp?o=3">评论数</a></th>
        <th><a href="sharelist.asp?o=4">最近评论时间</a></th>
        <th>分享时间</th>
        <th>类型</th>
        <th>１Ｐ</th>
        <th>ＰＰ</th>
        <th>ＢＹ</th>
        <th>ＢＴ</th>
        <th>审核状态</th>
        <th>推荐状态</th>
        <th>"官"标签</th>
        <th colspan="2">操作</th>
      </tr>
    </thead>
    <tbody>
      <%
	  Dim showType,checkState,recState
	Do While Not rec.Eof
		If rec("show_type")=0 Then
			showType="图片"
		Else
			showType="广告"
		End If
		If rec("recheck_state")=0 Then
			checkState = "<a class='tablelink' href='shareCheck.asp?id="&rec("id")&"&p="&CurrPage&"&t=0'>审核</a>"
		Else
			checkState = "<a class='tablelink' href='shareCheck.asp?id="&rec("id")&"&p="&CurrPage&"&t=1'>取消审核</a>"
		End If
		If rec("goods_rec_state")=0 Then
			recState = "<a class='tablelink' href='shareRec.asp?id="&rec("id")&"&p="&CurrPage&"&t=0'>推荐</a>"
		Else
			recState = "<a class='tablelink' href='shareRec.asp?id="&rec("id")&"&p="&CurrPage&"&t=1'>取消推荐</a>"
		End If
		If rec("goods_guan")=0 Then
			guanState = "<a class='tablelink' href='shareguan.asp?id="&rec("id")&"&p="&CurrPage&"&t=0'>加“官”</a>"
		Else
			guanState = "<a class='tablelink' href='shareguan.asp?id="&rec("id")&"&p="&CurrPage&"&t=1'>去“官”</a>"
		End If
	%>
      <tr>
      	<td><%=rec("ID")%></td>
        <td><%=rec("goods_name")%></td>
        <td><%=rec("mem_name")%></td>
        <td><%=rec("goods_weixin")%></td>
        <td><%=rec("goods_mobile")%></td>
        <td><%=rec("goods_qq")%></td>
        <td><a class='tablelink' href="<%=rec("goods_photo_url")%>" target="_blank">查看图片</a></td>
        <td><%=rec("goods_zan")%></td>
        <td><%=rec("goods_cai")%></td>
        <td><%=rec("goods_comment_num")%></td>
        <td><%=rec("comment_last_time")%></td>
        <td><%=rec("goods_add_time")%></td>
        <td><%=showType%></td>
        <td><%=rec("goods_1p")%></td>
        <td><%=rec("goods_pp")%></td>
        <td><%=rec("goods_by")%></td>
        <td><%=rec("goods_bt")%></td>
        <td><%=checkState%></td>
        <td><%=recState%></td>
        <td><%=guanState%></td>
        <td><a class='tablelink' href='shareadd.asp?id=<%=rec("id")%>'>编辑</a></td>
        <td><a class='tablelink' href='javascript:delInfoSure(<%=rec("id")%>,<%=CurrPage%>);'>删除</a></td>
      </tr>
      <%
     	rec.MoveNext
	Loop
    %>
    </tbody>
  </table>
  <div class="pagin">
    <div class="message">共<i class="blue"><%=f_CountRecNum%></i>条记录，当前显示第&nbsp;<i class="blue"><%=CurrPage%>&nbsp;</i>页/共<i class="blue"><%=f_CountPageNum%></i>页</div>
    <ul class="paginList">
      
      <%
	  sqlWhere=replace(sqlWhere," ","_kongge_")
	  sqlWhere=replace(sqlWhere,".","_dian_")
	  sqlWhere=replace(sqlWhere,",","_douhao_")
	  sqlWhere=replace(sqlWhere,"=","_dengyuhao_")
	  sqlWhere=replace(sqlWhere,"%","_baifenhao_")
	  sqlWhere=replace(sqlWhere,">","_dayuhao_")
	  sqlWhere=replace(sqlWhere,"<","_xiaoyuhao_")
	  sqlWhere=replace(sqlWhere,"'","_danyinhao_")
	 if CurrPage <> 1 then
	     response.write "<li class=""paginItem""><a href=sharelist.asp?o="&orderBy&"&s="&sqlWhere&"&page=1>第一页</a>&nbsp;&nbsp;</li>"
	     response.write "<li class=""paginItem""><a href=sharelist.asp?o="&orderBy&"&s="&sqlWhere&"&page="&(CurrPage-1)&">上一页</a>&nbsp;&nbsp;</li"
	 end if
	 if CurrPage <> f_CountPageNum then
	     response.write "<li class=""paginItem""><a href=sharelist.asp?o="&orderBy&"&s="&sqlWhere&"&page="&(CurrPage+1)&">下一页</a>&nbsp;&nbsp;</li>"
	     response.write "<li class=""paginItem""><a href=sharelist.asp?o="&orderBy&"&s="&sqlWhere&"&page="&f_CountPageNum&">最后一页</a>&nbsp;&nbsp;</li>"
	 end if
	  %>
      
    </ul>
  </div>
</div>
<div class="tip">
    <div class="tiptop"><span>提示信息</span><a></a></div>
    
  <div class="tipinfo">
    <span><img src="../images/ticon.png" /></span>
    <div class="tipright">
    <p>确认对此分享信息进行删除？删除后无法恢复！</p>
    <cite>如果是请点击确定按钮 ，否则请点取消。</cite>
    </div>
    </div>
    
    <div class="tipbtn">
    <input name="Id" id="Id" type="hidden"  value="" /><input name="page" id="page" type="hidden"  value="" />
    <input name="" type="button"  class="sure" value="确定"  onclick="delInfoOk()"/>&nbsp;
    <input name="" type="button"  class="cancel" value="取消" />
    </div>

</div>
<script type="text/javascript">
	$('.tablelist1 tbody tr:odd').addClass('odd');
	</script>
</body>
</html>
<%
rec.close
set rec=nothing
Call connClose
%>
