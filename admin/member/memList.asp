<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="../inc/const.asp"-->
<!--#include file="../inc/conn.asp"-->
<!--#include file="../Session.asp" -->
<!--#include file="../inc/Function.asp" -->
<%
If Not JudgePower("admin") Then Error1

Dim CurrPage,orderBy,orderByColumn
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
	Case 1'按最后登录时间
		orderByColumn="mem_last_login"
	Case 2'按会员积分
		orderByColumn="mem_points+mem_points_add"
	Case 0
		orderByColumn="id"
End Select


Dim memName,memMobile,sqlWhere,ssql
memName = Request.Form("memName")
memMobile = Request.Form("memMobile")

sqlWhere = Request("s")
If sqlWhere="" Then
	sqlWhere = " mem_is_del=0"
	If memName<>"" Then
		sqlWhere = sqlWhere & " and mem_name like '%"&memName&"%'"
	End If
	If memMobile<>"" Then
		sqlWhere = sqlWhere & " and mem_mobile='"&memMobile&"'"
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

Dim f_CountRecNum,f_PageNum,startIndex,endIndex
f_PageNum = 20

Call OpenDataBase  

f_CountRecNum = Conn.Execute("select count(id) from BL_m_member_info where"&sqlWhere)(0)
f_CountPageNum = JInt(f_CountRecNum,f_PageNum)

startIndex 	= (CurrPage-1)*f_PageNum+1
endIndex	= CurrPage*f_PageNum
ssql="select * from ( select row_number() over(order by "&orderByColumn&" desc) as rowNum,* from BL_m_member_info where "&sqlWhere &") a where rowNum between "&startIndex&" and " &  endIndex
'If CurrPage = 1 Then
'	ssql = "select top "&f_PageNum&" * from BL_m_member_info where "&sqlWhere&" order by "&orderByColumn&" desc"
'Else
'	ssql = "select top "&f_PageNum&" * from BL_m_member_info where "&orderByColumn&"<(select min("&orderByColumn&") from (select top "&Cstr(f_PageNum*(CurrPage-1))&" "&orderBy&" from BL_m_member_info where "&sqlWhere&" order by "&orderBy&" desc) as t) and "&sqlWhere&" order by "&orderBy&" desc"
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
<title>会员列表</title>
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
	location.href='memDel.asp?id='+f_Id+'&p='+f_page;
}

var sendState=false;
function sendRecCode(mem_id){
	if(sendState){
		return false;
	}
	sendState=true;
	var sendNum=$("#recNum"+mem_id).val();
	if(sendNum==''){
		alert("请输入你要发放的推荐码的数量！");
		sendState =false;
		return false;
	}
	$.ajax({
		   type: "POST",
		   url: "memServer.asp",
		   data: "a=1&i="+mem_id+"&n="+sendNum,
		   dataType:"text",
		   success: function(data){
				//alert(data);
				switch (data){
						case "0":
							alert("发放推荐码成功！");
							sendState =false;
							break;
						case "-1":
							alert("数量输入错误！");
							break;
						default :
							alert("异常错误！"+data);
				}
		   }, 
			error:function(XMLHttpRequest, textStatus, errorThrown){ 
			   alert("操作失败！");
			}
		});
}


var setPointsState=false;
function setPoints(mem_id){
	if(setPointsState){
		return false;
	}
	setPointsState=true;
	var pointsNum=$("#pointsNum"+mem_id).val();
	if(pointsNum==''){
		alert("请输入你要设置的积分！");
		setPointsState =false;
		return false;
	}
	$.ajax({
		   type: "POST",
		   url: "memServer.asp",
		   data: "a=3&i="+mem_id+"&n="+pointsNum,
		   dataType:"text",
		   success: function(data){
				//alert(data);
				switch (data){
						case "0":
							alert("设置成功！");
							setPointsState =false;
							break;
						case "-1":
							alert("积分输入错误！");
							break;
						default :
							alert("异常错误！"+data);
				}
		   }
		});
}

function setMemDate(mem_id){
	if(sendState){
		return false;
	}
	sendState=true;
	var sendNum=$("#setDate"+mem_id).val();
	if(sendNum==''){
		alert("请输入会员到期日期！");
		sendState =false;
		return false;
	}
	$.ajax({
		   type: "POST",
		   url: "memServer.asp",
		   data: "a=2&i="+mem_id+"&t="+sendNum,
		   dataType:"text",
		   success: function(data){
				//alert(data);
				switch (data){
						case "0":
							alert("设置成功！");
							sendState =false;
							break;
						case "-1":
							alert("日期输入错误！");
							break;
						default :
							alert("异常错误！"+data);
				}
		   }, 
			error:function(XMLHttpRequest, textStatus, errorThrown){ 
			   alert("操作失败！");
			}
		});
}
</script>
</head>
<style>

</style>
<body>
<div class="place"> <span>位置：</span>
  <ul class="placeul">
    <li>首页</li>
    <li>系统管理</li>
    <li>会员列表</li>
  </ul>
</div>
<div class="rightinfo">

  <form method="POST" action="?t=<%=countType%>" align="center">
    <ul class="prosearch">
      <li>
        <label>查询：</label>
        <i>会员账号</i><a>
        <input id="memName" name="memName" type="text" class="scinput" value="<%=memName%>" />
        </a> <i>会员手机</i><a>
        <input id="memMobile" name="memMobile" type="text" class="scinput" value="<%=memMobile%>" />
        </a> <a>
        <input name="" type="submit" class="sure" value="查询"/>
        </a></li>
    </ul>
  </form>
  
  <table class="tablelist1">
    <thead>
      <tr>
       	<th>会员ID</th>
        <th>会员账号</th>
        <th>会员昵称</th>
        <th>会员手机</th>
        <th><a href="memlist.asp?o=2">综合积分</a></th>
        <th>附加积分</th>
        <th>会员邮件</th>
        <th>会员头衔</th>
        <th>会员注册时间</th>
        <th><a href="memlist.asp?o=1">最后登录时间</a></th>
        <th>发推荐码</th>
        <th>设置会员到期日</th>
        <th>操作</th>
      </tr>
    </thead>
    <tbody>
      <%
	  Dim showEndTime,showColorClass
	Do While Not rec.Eof
		If datediff("d",rec("mem_end_time"),"2000-1-1")>0 Then
			showEndTime=""
			showColorClass=""
		Else
			showEndTime = rec("mem_end_time")
			If datediff("s",rec("mem_end_time"),Now())>0 Then
				showColorClass="bgyellow"
			ElseIf datediff("d",Now(),rec("mem_end_time"))<7 Then
				showColorClass="bgred"
			else
				showColorClass=""
			End If
		End If
		
		
		
	%>
      <tr>
       	<td><%=rec("id")%></td>	
        <td><%=rec("mem_name")%></td>
        <td><%=rec("mem_nick")%></td>
        <td><%=rec("mem_mobile")%></td>
        <td><%=rec("mem_points")%></td>
        <td><a class='tablelink' href='javascript:setPoints(<%=rec("id")%>);'> 设置 </a> <input class="numinput" id="pointsNum<%=rec("id")%>" type="text" maxlength="6" value="<%=rec("mem_points_add")%>" /></td>
        <td><%=rec("mem_email")%></td>
        <td><%=rec("mem_label")%></td>
        <td><%=rec("mem_join_time")%></td>
        <td><%=rec("mem_last_login")%></td>
        <td><a class='tablelink' href='javascript:sendRecCode(<%=rec("id")%>);'> 发推荐码 </a> <input class="numinput" id="recNum<%=rec("id")%>" type="text" value="1" maxlength="3" />个</td>
        <td>日期：<input class="numinput <%=showColorClass%>" id="setDate<%=rec("id")%>" type="text" value="<%=showEndTime%>" maxlength="20" style="width:150px;" /><a class='tablelink' href='javascript:setMemDate(<%=rec("id")%>);'> 设置 </a> </td>
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
	  If orderBy="id" Then orderBy=""
	 if CurrPage <> 1 then
	     response.write "<li class=""paginItem""><a href=memlist.asp?o="&orderBy&"&s="&sqlWhere&"&page=1>第一页</a>&nbsp;&nbsp;</li>"
	     response.write "<li class=""paginItem""><a href=memlist.asp?o="&orderBy&"&s="&sqlWhere&"&page="&(CurrPage-1)&">上一页</a>&nbsp;&nbsp;</li"
	 end if
	 if CurrPage <> f_CountPageNum then
	     response.write "<li class=""paginItem""><a href=memlist.asp?o="&orderBy&"&s="&sqlWhere&"&page="&(CurrPage+1)&">下一页</a>&nbsp;&nbsp;</li>"
	     response.write "<li class=""paginItem""><a href=memlist.asp?o="&orderBy&"&s="&sqlWhere&"&page="&f_CountPageNum&">最后一页</a>&nbsp;&nbsp;</li>"
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
    <p>是否确认对此会员进行删除？删除后无法恢复！</p>
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
