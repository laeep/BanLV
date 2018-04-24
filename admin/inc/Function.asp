<%
Function JInt(BigNum,SmallNum)
	Dim f_int
	f_int =BigNum \ SmallNum
	If BigNum mod SmallNum >0 Then
		f_int=f_int +1
	End If
	JInt = f_int
End Function


Function GetTitle(Str,StrLen)
	Dim l,t,c, i,LableStr,regEx,Match,Matches
	If StrLen=0 then
		GetTitle=""
		exit function
	End If
	if IsNull(Str) then 
		GetTitle = ""
		Exit Function
	end if
	if Str = "" then
		GetTitle=""
		Exit Function
	end if
	Str=Replace(Replace(Replace(Replace(Str,"&nbsp;"," "),"&quot;",Chr(34)),"&gt;",">"),"&lt;","<")
	Str=Replace(Str,"&amp;","&")
	l=len(str)
	t=0
	strlen=Clng(strLen)
	for i=1 to l
		c=Abs(Asc(Mid(str,i,1)))
		if c>255 then
			t=t+2
		else
			t=t+1
		end if
		if t>=strlen then
			GetTitle=left(str,i)&"…"
			exit for
		else
			GetTitle=str
		end if
	next
	GetTitle=Replace(GetTitle,"&","&amp;")
	GetTitle = Replace(Replace(Replace(Replace(GetTitle," ","&nbsp;"),Chr(34),"&quot;"),">","&gt;"),"<","&lt;")
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

Function GetRandomID10()
	Dim TempStr,NowTime
	NowTime = Now()
	TempStr = Right(CStr(Year(NowTime)),2)
	TempStr = TempStr &  Right("0"&CStr(Month(NowTime)),2)
	TempStr = TempStr &  Right("0"&CStr(Day(NowTime)),2)
	TempStr = TempStr &  Timer*100
	GetRandomID10 = TempStr
End Function

Function CreateRandomString(f_Num)
	Dim allowString,tmpString,rndNum
	'allowString="1234567890qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM~!@#$%^*()_+[]{}"
	allowString="1234567890"
	RANDOMIZE Timer
	For i = 1 to f_Num
		rndNum = int(Len(allowString)*rnd+1)
		tmpString =tmpString & mid(allowString,rndNum,1)
	Next
	CreateRandomString = tmpString
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
	Conn.Execute("insert into BL_G_Log_login(username,userip,loginok,opercontent) values('"&Session(G_SessionPre&"_Admin_Name")&"','"&GetCustIp&"',"&f_isOk&",'"&f_content&"')")
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