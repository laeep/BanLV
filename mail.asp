<%
'以下部分为系统配置，请勿更改



Set objMail=Server.CreateObject("CDO.Message")
Set objCDOSYSCon=Server.CreateObject("CDO.Configuration")
objCDOSYSCon.Fields("http://schemas.microsoft.com/cdo/configuration/smtpserverport")=25
objCDOSYSCon.Fields("http://schemas.microsoft.com/cdo/configuration/sendusing")=1
objCDOSYSCon.Fields("http://schemas.microsoft.com/cdo/configuration/smtpconnectiontimeout")=60
objCDOSYSCon.Fields("http://schemas.microsoft.com/cdo/configuration/smtpserverpickupdirectory")="c:\Inetpub\mailroot\Pickup"
objCDOSYSCon.Fields.Update
objMail.Configuration=objCDOSYSCon
'系统配置结束
'以下为用户自行更改部分，请由程序员进行修改
objMail.From="test@cdckdz.com"
objMail.Subject="发信组件测试"
'把下面的email改成自己的
objMail.To="lizhiping@shandagames.com"
objMail.TextBody="l可使肌肤克拉斯解放路卡设计费卡拉胶诶欧文 看风景阿娜女秘书你数据库"
objMail.Send
Set objMail=Nothing
Set objCDOSYSCon=Nothing
%>

<%="发送成功,ok!!!"%>