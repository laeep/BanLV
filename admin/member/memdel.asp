<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="../inc/const.asp"-->
<!--#include file="../inc/conn.asp"-->
<!--#include file="../Session.asp" -->
<!--#include file="../inc/Function.asp" -->
<%
If Not JudgePower("admin") Then Error1


Dim memid,page
memid	= Request.QueryString("id")
page	= Request.QueryString("p")

Call OpenDataBase 
Conn.Execute("update BL_m_member_info set mem_is_del=1 where id="&memid)
 
'删除会员基本信息
'Conn.execute("delete from BL_m_member_info where id="&memid)   
'删除会员所属组的关联信息
'Conn.Execute("delete from BL_m_member_group where mem_id="&memid)
'删除会员分享信息
'Conn.Execute("delete from BL_s_goods_info where goods_mem_id="&memid)
'删除会员举报信息
'Conn.Execute("delete from BL_s_report_info where report_mem_id="&memid)
'删除会员定制信息
'Conn.Execute("delete from BL_m_member_dingzhi_info where mem_id="&memid)
'删除会员收藏信息
'Conn.Execute("delete from BL_s_favorites_info where mem_id="&memid)
'删除会员评论信息
'Conn.Execute("delete from BL_s_goods_comment_info where mem_id="&memid)
'删除赞顶踩记录
'Conn.Execute("delete from BL_r_zan_cai_log where mem_id="&memid)
'删除签到记录
'Conn.Execute("delete from BL_r_sign_log where mem_id="&memid)
Call connClose
Response.Redirect("memlist.asp?page="&page)

%>
