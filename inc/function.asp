<%
Function ReplaceStar(f_str)
	If Len(f_str)<3 Then
		ReplaceStar = f_str
	Else
		ReplaceStar=Left(f_str,3)&"**"&right(f_str,2)
	End If
End Function

Function JInt(BigNum,SmallNum)
	Dim f_int
	f_int =BigNum\SmallNum
	If BigNum mod SmallNum >0 Then
		f_int=f_int +1
	End If
	JInt = f_int
End Function

Sub saveImg(f_path,f_content)
	Dim xml : Set xml=Server.CreateObject("MSXML2.DOMDocument")  
	Dim stm : Set stm=Server.CreateObject("ADODB.Stream") 
	xml.resolveExternals=False
	If InStr(1,f_content,",")>0 Then
		f_content1=split(f_content,",")
		content = f_content1(ubound(f_content1))
	Else
		content = f_content
	End If
	xml.loadXML("<?xml version=""1.0"" encoding=""gb2312""?><data><![CDATA["&content&"]]></data>")'    ‘’’’’加载xml文件中的内容，使用xml解析出
	xml.documentElement.setAttribute "xmlns:dt","urn:schemas-microsoft-com:datatypes"   
	xml.documentElement.dataType = "bin.base64"
	stm.Type=1 'adTypeBinary  
	stm.Open  
	stm.Write xml.documentElement.nodeTypedValue
	stm.SaveToFile Server.MapPath(f_path),2'   ‘’’’’文件保存到指定路径
	stm.Close  
	Set xml=Nothing  
	Set stm=Nothing 
End Sub 

Function CheckAccountOk(f_account)
	Dim OkStr,i
	f_account=LCase(f_account)
	CheckAccountOk=True
	OkStr="1234567890abcdefghijklmnopqrstuvwxyz"
	For i=1 to Len(f_account)
		If InStr(1,OkStr,LCase(Mid(f_account,i,1)))=0 Then
			CheckAccountOk=False
			Exit Function
		End If
	Next
	If InStr(1,"1234567890",left(f_account,1))>0 Then
		CheckAccountOk=False
		Exit Function
	End IF
End Function

Function CheckNumCharOK(f_str)
	Dim OkStr,i
	f_str=LCase(f_str)
	CheckNumCharOK=True
	OkStr="1234567890abcdefghijklmnopqrstuvwxyz"
	For i=1 to Len(f_str)
		If InStr(1,OkStr,LCase(Mid(f_str,i,1)))=0 Then
			CheckNumCharOK=False
			Exit Function
		End If
	Next
End Function

Function FullChinese(str) 
	'定义一个临时变量 
	Dim i 
	'取出整个字符串的长度，赋给这个变量 
	i=Len(str) 
	'判断一下字符串是不是空，如果是空，则直接返回"False"
	If i=0 Then 
		FullChinese=False 
		Exit Function 
	End If 
	'一个一个的取出字符串的每一个字符（从后往前取），循环判断取出的
	Do While i>0 
		'如果当前取出的字符的ASCW码小于256，那么我们就认为这个字符不是中文  
		'这个判断并不是完全准确的，但是对于一般的需求应该足够了 
		'如果字符串中有一个字符不是中文就返回"False" 
		'Response.Write(Mid(str,i,1) & "<br />")
		'Response.Write(AscW(Mid(str,i,1)) & "<br />")
		If AscW(Mid(str,i,1))<256 And AscW(Mid(str,i,1))>0 Then 
			FullChinese=False 
			Exit Function 
		End If 
		'如果当前取出的字符是中文，那么就把i减1，循环后去判断下一个字符 
	   	
		i=i-1 
	Loop 
	'如果全是中文，那么返回"True" 
	FullChinese=True 
End Function 
'Response.Write(FullChinese("是电饭啥电影和手段水利局时刻将奥斯卡进阿飞他要求全面被你们放辣椒反▲▲▲▲锅"))
Function IsIdCard(e)
	e=LCase(e)
	IsIdCard = true
	arrVerifyCode = Split("1,0,x,9,8,7,6,5,4,3,2", ",")
	Wi = Split("7,9,10,5,8,4,2,1,6,3,7,9,10,5,8,4,2", ",")
	Checker = Split("1,9,8,7,6,5,4,3,2,1,1", ",")
	If Len(e) <> 15 And Len(e) <> 18 Then
	'IDCheck= "身份证号共有 15 码或18位"
		IsIdCard = False
		Exit Function
	End If
	Dim Ai
	If Len(e) = 18 Then
		Ai = Mid(e, 1, 17)
	ElseIf Len(e) = 15 Then
		Ai = e
		Ai = Left(Ai, 6) & "19" & Mid(Ai, 7, 9)
	End If
	If Not IsNumeric(Ai) Then
	'IDCheck= "身份证除最后一位外，必须为数字！"
		IsIdCard = False
		Exit Function
	End If
	Dim strYear, strMonth, strDay
	strYear = CInt(Mid(Ai, 7, 4))
	strMonth = CInt(Mid(Ai, 11, 2))
	strDay = CInt(Mid(Ai, 13, 2))
	BirthDay = Trim(strYear) + "-" + Trim(strMonth) + "-" + Trim(strDay)
	If IsDate(BirthDay) Then
		If DateDiff("yyyy",Now,BirthDay)<-140 or cdate(BirthDay)>date() Then
		'IDCheck= "身份证输入错误！"
			IsIdCard = False
			Exit Function
		End If
		If strMonth > 12 Or strDay > 31 Then
			IsIdCard = False
			'IDCheck= "身份证输入错误！"
			Exit Function
		End If
	Else
		'IDCheck= "身份证输入错误！"
		IsIdCard = False
		Exit Function
	End If
	Dim i, TotalmulAiWi
	For i = 0 To 16
		TotalmulAiWi = TotalmulAiWi + CInt(Mid(Ai, i + 1, 1)) * Wi(i)
	Next
	Dim modValue
	modValue = TotalmulAiWi Mod 11
	Dim strVerifyCode
	strVerifyCode = arrVerifyCode(modValue)
	Ai = Ai & strVerifyCode
	IDCheck = Ai
	If Len(e) = 18 And e <> Ai Then
	'IDCheck= "身份证号码输入错误！"
		IsIdCard = False
		Exit Function
	End If
End Function

function IsValidEmail(email)
	dim names, name, i, c
	
	IsValidEmail = true
	names = Split(email, "@")
	if UBound(names) <> 1 then
	   IsValidEmail = false
	   exit function
	end if
	for each name in names
	   if Len(name) <= 0 then
		 IsValidEmail = false
		 exit function
	   end if
	   for i = 1 to Len(name)
		 c = Lcase(Mid(name, i, 1))
		 if InStr("abcdefghijklmnopqrstuvwxyz_-.", c) <= 0 and not IsNumeric(c) then
		   IsValidEmail = false
		   exit function
		 end if
	   next
	   if Left(name, 1) = "." or Right(name, 1) = "." then
		  IsValidEmail = false
		  exit function
	   end if
	next
	if InStr(names(1), ".") <= 0 then
	   IsValidEmail = false
	   exit function
	end if
	i = Len(names(1)) - InStrRev(names(1), ".")
	if i <> 2 and i <> 3 then
	   IsValidEmail = false
	   exit function
	end if
	if InStr(email, "..") > 0 then IsValidEmail = false
end function

Function IsOkMobileNo(f_m)
	IsOkMobileNo = True
	If f_m="" Then
		IsOkMobileNo = False
		Exit Function
	End If
	If Left(f_m,1)<>"1" Then
		IsOkMobileNo = False
		Exit Function
	End If
	If Len(f_m)<>11 Then
		IsOkMobileNo = False
		Exit Function
	End If
	If Not IsNum(f_m) Then
		IsOkMobileNo = False
		Exit Function
	End If
End Function

Function GetTitle(str,length)
	on error resume next         
    dim l,c,i,hz,en  
    l=len(str)  
    if l<length then  
        getSubString=str  
    else  
        hz=0  
        en=0  
        for i=1 to l  
            c=asc(mid(str,i,1))  
            if c>=128 or c<0 then   
                hz=hz+1  
            else  
                en=en+1  
            end if  
      
            if en/2+hz>=length then  
                exit for  
            end if  
        next          
        getSubString=left(str,i) & ".."  
    end if  
    if err.number<>0 then err.clear  
End function
Function GetStrLen(f_Str)
	Dim StrLen,t,i,c
	StrLen=len(f_Str)
	t=0
	StrLen=Clng(StrLen)
	for i=1 to StrLen
		c=Abs(Asc(Mid(f_Str,i,1)))
		if c>255 then
			t=t+2
		else
			t=t+1
		end if
	next
	GetStrLen = t
End Function
Function GetCustIp
	Dim f_CustIP
	f_CustIP = Request.ServerVariables("HTTP_X_FORWARDED_FOR")
	If f_CustIP="" Then
		f_CustIP = Request.ServerVariables("REMOTE_ADDR")
	End If
	GetCustIp = f_CustIP
End Function

Function GetRandomID18()
	Dim TempStr,NowTime
	NowTime = Now()
	TempStr = Right(CStr(Year(NowTime)),2)
	TempStr = TempStr &  Right("0"&CStr(Month(NowTime)),2)
	TempStr = TempStr &  Right("0"&CStr(Day(NowTime)),2)
	TempStr = TempStr &  Timer*100
	GetRandomID18 = TempStr
End Function

Function createRandomString(f_Num)
	Dim allowString,tmpString,rndNum
	'allowString="1234567890qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM~!@#$%^*()_+[]{}"
	allowString="23456789qwertyuipasdfghjkzxcvbnm"
	RANDOMIZE Timer
	For i = 1 to f_Num
		rndNum = int(Len(allowString)*rnd+1)
		tmpString =tmpString & mid(allowString,rndNum,1)
	Next
	createRandomString = tmpString
End Function
Function IsNum(f_num)
	IsNum=True
	If f_num="" Then
		IsNum=False
		Exit Function
	End If
	For i=1 to Len(f_num)
		If Asc(Mid(f_num,i,1))<48 Or Asc(Mid(f_num,i,1))>57 Then
			IsNum=False
			Exit Function
		End If
	Next
End Function

Sub ShowErrorInfo(f_Info,f_Url)
	Call connClose
	If f_Url ="0" Then
		Response.Write "<script language=javascript>alert('"&f_Info&"');history.back();</script>"
		Response.end
	ElseIf f_Url="1" Then
		Response.Write "<script language=javascript>alert('"&f_Info&"');window.opener=null;window.close();</script>"
		Response.end
	Else
		Response.Write "<script language=javascript>alert('"&f_Info&"');location.href='"&f_Url&"';</script>"
		Response.end
	End If
End Sub

Sub ExportDataToExcel(f_rs,f_fileName)
	Dim tempStr
	If Not f_rs.Eof Then
		set fs=server.CreateObject("Scripting.FileSystemObject")
		set fs_file=fs.OpenTextFile(server.MapPath(f_fileName),2,True,True)
		FieldsCount=f_rs.Fields.Count
		For i = 0 to FieldsCount-1
			tempStr=tempStr & f_rs.Fields(i).Name & ","
		Next
		fs_file.writeline Left(tempStr,len(tempStr)-1)
		tempStr = ""
		Do While Not f_rs.Eof
			For i = 0 to FieldsCount-1
				tempStr=tempStr & f_rs.Fields(i).Value & ","
			Next
			fs_file.writeline Left(tempStr,len(tempStr)-1)
			tempStr = ""
			f_rs.MoveNext
		Loop
		fs_file.close
		set fs_file=nothing
		set fs=nothing
		Response.Redirect(f_fileName)
	End IF
End Sub
sub WriteFile(f_FileName,f_Content)
	set fs=server.CreateObject("Scripting.FileSystemObject")
	set fs_file=fs.OpenTextFile(server.MapPath(f_FileName),8,True,True)
	fs_file.writeline "访问者IP："&GetCustIp&"-访问时间"& now()&"-" & f_Content 
	fs_file.close
	set fs_file=nothing
	set fs=nothing
End sub

Sub WriteOperLog(f_isOk,f_content)
	f_content = replace(f_content,"'","‘")
	Call OpenDataBase
	Conn.Execute("insert into G_Log_login(username,userip,loginok,opercontent) values('"&Session(G_SessionPre&"_Admin_Name")&"','"&GetCustIp&"',"&f_isOk&",'"&f_content&"')")
	conn.Close
	Set Conn =Nothing
End Sub
Function formatTimeOut
	dim y,m,d,h,mi,s,n
	n=Now()
	y = CStr(Year(n))
	m = Right("0"&CStr(month(n)),2)
	d = Right("0"&CStr(day(n)),2)
	h = Right("0"&CStr(hour(n)),2)
	mi= Right("0"&CStr(minute(n)),2)
	s = Right("0"&CStr(second(n)),2)
	formatTimeOut = y&"-"&m&"-"&d&" "&h&":"&mi&":"&s
End Function 

Function myReplace(myString)
   myString = Replace(myString,"&","&amp;")
   myString = Replace(myString,"<","&lt;")
   myString = Replace(myString,">","&gt;")
   myString = Replace(myString,"chr(","")
   myString = Replace(myString,"'","&apos;")
   'myString = Replace(myString,";","")
   myReplace = myString
End Function

Function lostDangerChar(myString)
	If myString="" Then 
		lostDangerChar=""
		Exit Function
	End If
	myString = Replace(myString,"&","")
	myString = Replace(myString,"<","")
	myString = Replace(myString,">","")
	myString = Replace(myString,"chr(","")
	myString = Replace(myString,"'","")
	myString = Replace(myString,";","")
	lostDangerChar = myString
End Function

Function CutString(byval A_strString,byval A_intLen,byval A_strAddString) 
	Dim trueLen,retString
	For i = 1 to len(A_strString)
		If AscW(Mid(A_strString,i,1))<256 And AscW(Mid(A_strString,i,1))>0 Then 
			trueLen =trueLen+1
		Else
			trueLen =trueLen+2
		End If
		If trueLen<=A_intLen Then
			retString =retString & Mid(A_strString,i,1)
		Else
			CutString = retString & A_strAddString
			Exit Function
		End IF
	Next
	CutString = retString

End function 

Class ImgWHInfo '获取图片宽度和高度的类，支持JPG，GIF，PNG，BMP 
    Dim ASO 
    Private Sub Class_Initialize 
        Set ASO=Server.CreateObject("ADODB.Stream") 
        ASO.Mode=3 
        ASO.Type=1 
        ASO.Open 
    End Sub 
    Private Sub Class_Terminate 
        Err.Clear 
        Set ASO=Nothing 
    End Sub  

    Private Function Bin2Str(Bin) 
        Dim I, Str 
        For I=1 To LenB(Bin) 
            clow=MidB(Bin,I,1) 
            If ASCB(clow)<128 Then 
                Str = Str & Chr(ASCB(clow)) 
            Else 
                I=I+1 
                If I <= LenB(Bin) Then Str = Str & Chr(ASCW(MidB(Bin,I,1)&clow)) 
            End If 
        Next 
        Bin2Str = Str 
    End Function 

    Private Function Num2Str(Num,Base,Lens) 
        Dim Ret 
        Ret = "" 
        While(Num>=Base) 
            Ret = (Num Mod Base) & Ret 
            Num = (Num - Num Mod Base)/Base 
        Wend 
        Num2Str = Right(String(Lens,"0") & Num & Ret,Lens) 
    End Function 

    Private Function Str2Num(Str,Base)  
        Dim Ret,I 
        Ret = 0  
        For I=1 To Len(Str)  
            Ret = Ret *base + Cint(Mid(Str,I,1))  
        Next  
        Str2Num=Ret  
    End Function  

    Private Function BinVal(Bin)  
        Dim Ret,I 
        Ret = 0  
        For I = LenB(Bin) To 1 Step -1  
            Ret = Ret *256 + AscB(MidB(Bin,I,1))  
        Next  
        BinVal=Ret  
    End Function  

    Private Function BinVal2(Bin)  
        Dim Ret,I 
        Ret = 0  
        For I = 1 To LenB(Bin)  
            Ret = Ret *256 + AscB(MidB(Bin,I,1))  
        Next  
        BinVal2=Ret  
    End Function  

    Private Function GetImageSize(filespec) 
        Dim bFlag 
        Dim Ret(3)  
        ASO.LoadFromFile(filespec)  
        bFlag=ASO.Read(3)  
        Select Case Hex(binVal(bFlag))  
        Case "4E5089":  
            ASO.Read(15)  
            ret(0)="PNG"  
            ret(1)=BinVal2(ASO.Read(2))  
            ASO.Read(2)  
            ret(2)=BinVal2(ASO.Read(2))  
        Case "464947":  
            ASO.read(3)  
            ret(0)="gif"  
            ret(1)=BinVal(ASO.Read(2))  
            ret(2)=BinVal(ASO.Read(2))  
        Case "535746":  
            ASO.read(5)  
            binData=ASO.Read(1)  
            sConv=Num2Str(ascb(binData),2 ,8)  
            nBits=Str2Num(left(sConv,5),2)  
            sConv=mid(sConv,6)  
            While(len(sConv)<nBits*4)  
                binData=ASO.Read(1)  
                sConv=sConv&Num2Str(AscB(binData),2 ,8)  
            Wend  
            ret(0)="SWF"  
            ret(1)=Int(Abs(Str2Num(Mid(sConv,1*nBits+1,nBits),2)-Str2Num(Mid(sConv,0*nBits+1,nBits),2))/20)  
            ret(2)=Int(Abs(Str2Num(Mid(sConv,3*nBits+1,nBits),2)-Str2Num(Mid(sConv,2*nBits+1,nBits),2))/20)  
        Case "FFD8FF":  
            Do   
                Do: p1=binVal(ASO.Read(1)): Loop While p1=255 And Not ASO.EOS  
                If p1>191 And p1<196 Then Exit Do Else ASO.read(binval2(ASO.Read(2))-2)  
                Do:p1=binVal(ASO.Read(1)):Loop While p1<255 And Not ASO.EOS  
            Loop While True  
            ASO.Read(3)  
            ret(0)="JPG"  
            ret(2)=binval2(ASO.Read(2))  
            ret(1)=binval2(ASO.Read(2))  
        Case Else:  
            If left(Bin2Str(bFlag),2)="BM" Then  
                ASO.Read(15)  
                ret(0)="BMP"  
                ret(1)=binval(ASO.Read(4))  
                ret(2)=binval(ASO.Read(4))  
            Else  
                ret(0)=""  
            End If  
        End Select  
        ret(3)="width=""" & ret(1) &""" height=""" & ret(2) &""""  
        getimagesize=ret  
    End Function  

    Public Function imgW(IMGPath) 
        Dim FSO,IMGFile,FileExt,Arr 
        Set FSO = Server.CreateObject("Scripting.FileSystemObject")  
        If (FSO.FileExists(IMGPath)) Then  
            Set IMGFile = FSO.GetFile(IMGPath)  
            FileExt=FSO.GetExtensionName(IMGPath)  
            Select Case FileExt  
            Case "gif","bmp","jpg","png":  
                Arr=GetImageSize(IMGFile.Path)  
                imgW = Arr(1)  
            End Select  
            Set IMGFile=Nothing  
        Else 
            imgW = 0 
        End If      
        Set FSO=Nothing  
    End Function  

    Public Function imgH(IMGPath) 
        Dim FSO,IMGFile,FileExt,Arr 
        Set FSO = server.CreateObject("Scripting.FileSystemObject")  
        If (FSO.FileExists(IMGPath)) Then  
            Set IMGFile = FSO.GetFile(IMGPath)  
            FileExt=FSO.GetExtensionName(IMGPath)  
            Select Case FileExt  
            Case "gif","bmp","jpg","png":  
                Arr=getImageSize(IMGFile.Path)  
                imgH = Arr(2)  
            End Select  
            Set IMGFile=Nothing  
        Else 
            imgH = 0  
        End If      
        Set FSO=Nothing  
    End Function  
End Class
%>