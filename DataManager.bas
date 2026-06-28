Attribute VB_Name = "DataManager"
Option Explicit

' Reconstructed VB6 source shell generated from decompiled output.
' Source reference: /opt/git/AlphaSeries_cracked/DECOMPILED/DataManager.bas
' Decompiled procedure bodies are intentionally not copied until they are understood and made valid VB6.

Public global_008291AC As String
Public global_00829050 As String
Public global_00829054 As Integer
Public global_00829068(1 To 5000) As Integer

' Original declaration: Private Sub Proc_8_0_804330
Public Function Proc_8_0_804330(ParamArray args() As Variant) As Variant
    On Error GoTo ReadFailed
    If UBound(args) < 0 Then
        Proc_8_0_804330 = vbNullString
    Else
        Proc_8_0_804330 = privSockHTTP.ReadHTTP(CStr(args(0)), GetOptionalColumnIndex(args, 1, 0))
    End If
    Exit Function

ReadFailed:
    Proc_8_0_804330 = vbNullString
End Function

' Original declaration: Private Sub Proc_8_1_804400
Public Function Proc_8_1_804400(ParamArray args() As Variant) As Variant
    On Error GoTo GenerateFailed
    If UBound(args) < 0 Then
        Proc_8_1_804400 = "0"
    Else
        Proc_8_1_804400 = CStr(CLng(Val(CStr(args(0)))) * CLng(Proc_10_4_809CA0(1, 4)))
    End If
    Exit Function

GenerateFailed:
    Proc_8_1_804400 = "0"
End Function

' Original declaration: Private Sub Proc_8_2_804490
Public Function Proc_8_2_804490(ParamArray args() As Variant) As Variant
    On Error GoTo GenerateFailed
    If UBound(args) < 0 Then
        Proc_8_2_804490 = "0"
    Else
        Proc_8_2_804490 = CStr(CLng(Val(CStr(args(0)))) * CLng(Proc_10_4_809CA0(60, 90)))
    End If
    Exit Function

GenerateFailed:
    Proc_8_2_804490 = "0"
End Function

' Original declaration: Private Sub Proc_8_3_804530
Public Function Proc_8_3_804530(ParamArray args() As Variant) As Variant
    Dim sourceValue As String
    Dim saltValue As Long
    Dim markerValue As Long
    Dim index As Long
    Dim tokenValue As String

    On Error GoTo BuildFailed
    If UBound(args) < 0 Then
        Proc_8_3_804530 = vbNullString
        Exit Function
    End If

    sourceValue = CStr(args(0))
    Randomize
    saltValue = CLng(Rnd * 100)
    If saltValue = 0 Then saltValue = 1
    markerValue = CLng(Proc_10_3_809B90(&H5A, &H41))

    tokenValue = CStr(Len(sourceValue) + saltValue) & Chr$(markerValue)
    For index = 1 To Len(sourceValue)
        tokenValue = tokenValue & Chr$(CLng(Proc_10_3_809B90(&H5A, &H41)))
        tokenValue = tokenValue & CStr(Asc(Mid$(sourceValue, index, 1)) * saltValue * markerValue)
    Next index

    Proc_8_3_804530 = tokenValue
    Exit Function

BuildFailed:
    Proc_8_3_804530 = vbNullString
End Function

' Original declaration: Private Sub Proc_8_4_804970
Public Function Proc_8_4_804970(ParamArray args() As Variant) As Variant
    On Error Resume Next
    Main.Hide
    MsgBox "Das Lizenzsystem ist zurzeit nicht erreichbar. Versuch es sp" & Chr$(228) & "ter wieder!", vbCritical
    End
    Proc_8_4_804970 = Empty
End Function

' Original declaration: Private  Proc_8_5_804AB0(arg_C) '804AB0
Public Function Proc_8_5_804AB0(ParamArray args() As Variant) As Variant
    Dim encodedValue As String
    Dim shiftValue As Long
    Dim index As Long
    Dim decodedValue As String

    On Error GoTo DecodeFailed
    If UBound(args) < 0 Then
        Proc_8_5_804AB0 = vbNullString
        Exit Function
    End If

    encodedValue = CStr(args(0))
    If Len(encodedValue) = 0 Then
        Proc_8_5_804AB0 = vbNullString
        Exit Function
    End If

    shiftValue = Asc(Mid$(encodedValue, 1, 1)) - 87
    encodedValue = Mid$(encodedValue, 2)

    For index = 1 To Len(encodedValue)
        decodedValue = decodedValue & Chr$(Asc(Mid$(encodedValue, index, 1)) - shiftValue)
    Next index

    Proc_8_5_804AB0 = decodedValue
    Exit Function

DecodeFailed:
    Proc_8_5_804AB0 = vbNullString
End Function

' Original declaration: Private Sub Proc_8_6_804D80
Public Function Proc_8_6_804D80(ParamArray args() As Variant) As Variant
    Dim keyName As String
    Dim marker As String
    Dim values() As String

    On Error GoTo LookupFailed
    If UBound(args) < 0 Then
        Proc_8_6_804D80 = 0
        Exit Function
    End If

    keyName = CStr(args(0))
    marker = vbCr & keyName & ":" & CStr(global_00829054) & "="
    If InStr(1, global_00829050, marker & "1", vbBinaryCompare) > 0 Then
        Proc_8_6_804D80 = 1
        Exit Function
    End If

    values = Split(CStr(Split(global_00829050, marker)(1)), vbCr)
    Proc_8_6_804D80 = CInt(Val(values(0)))
    Exit Function

LookupFailed:
    Proc_8_6_804D80 = 0
End Function

' Original declaration: Private Sub Proc_8_7_8051C0
Public Function Proc_8_7_8051C0(ParamArray args() As Variant) As Variant
    Dim timeFormat As String
    Dim productKeyValue As String
    Dim tokenSeed As String
    Dim requestUrl As String
    Dim responseText As String
    Dim blocks() As String
    Dim rankText As String
    Dim licenseBlock As String
    Dim licenseParts() As String
    Dim licenseCheck As Long
    Dim checksumSalt As Long
    Dim rankIndex As Long
    Dim messageText As String

    On Error GoTo LicenceFailed

    timeFormat = "yyyy-mm-dd_h-mm-ss"
    checksumSalt = CLng(Val(CStr(Proc_8_2_804490(7, &H5A)))) _
        + CLng(Val(CStr(Proc_8_1_804400(0)))) _
        + CLng(Val(CStr(Proc_8_2_804490(1, 10))))
    tokenSeed = CStr(Proc_10_3_809B90(&H9C4, &H3E8)) _
        & "/" & CStr(Proc_10_3_809B90(&H9C4, &H3E8)) _
        & "/" & CStr(Proc_10_3_809B90(&H9C4, &H3E8)) & "/L:"

    productKeyValue = Main.productKey.Caption
    requestUrl = "http://www.alpha-series.com/check_product_sep11?local_time=" _
        & CStr(Proc_10_3_809B90(&H9C4, &H3E8)) _
        & CStr(Proc_10_3_809B90(&H9C4, &H3E8)) _
        & Format$(Now, timeFormat) & ":"
    requestUrl = requestUrl & "&version=" & global_00829038 _
        & "&productKey=" & productKeyValue _
        & "&token=" & CStr(Proc_8_3_804530(tokenSeed))

    responseText = CStr(Proc_8_0_804330(requestUrl, 1, 0))
    If Len(responseText) = 0 Then GoTo LicenceFailed

    If InStr(1, responseText, "{BLOCKED ", vbBinaryCompare) > 0 Then
        Main.Hide
        messageText = Replace(responseText, "%20", " ", 1, -1, vbBinaryCompare)
        messageText = Replace(messageText, "{BLOCKED ", vbNullString, 1, -1, vbBinaryCompare)
        messageText = Replace(messageText, "}", vbNullString, 1, -1, vbBinaryCompare)
        MsgBox messageText, vbCritical
        End
    End If

    blocks = Split(responseText, timeFormat, -1, vbBinaryCompare)
    If UBound(blocks) >= 3 Then
        licenseBlock = Replace(CStr(blocks(3)), "--*-", vbCr, 1, -1, vbBinaryCompare)
        licenseBlock = Replace(licenseBlock, "*-*-", vbLf, 1, -1, vbBinaryCompare)
    ElseIf UBound(blocks) >= 1 Then
        licenseBlock = CStr(blocks(1))
    Else
        licenseBlock = responseText
    End If
    global_00829050 = vbCr & Replace(licenseBlock, vbLf, vbCr, 1, -1, vbBinaryCompare) & vbCr

    rankText = ExtractLicenceSetting(global_00829050, "rank")
    global_00829054 = CInt(Val(rankText))
    For rankIndex = 1 To 5000
        global_00829068(rankIndex) = CInt(Val(CStr(Proc_8_6_804D80(CStr(rankIndex)))))
    Next rankIndex

    licenseParts = Split(licenseBlock, "-", -1, vbBinaryCompare)
    If UBound(licenseParts) >= 2 And Len(licenseBlock) >= 14 Then
        licenseCheck = CLng(Val(CStr(licenseParts(2)))) _
            - CLng(Val(Mid$(licenseBlock, 9, 6))) _
            + CLng(Val(CStr(licenseParts(1)))) _
            - checksumSalt
        If licenseCheck <> 0 Then GoTo LicenceFailed
    End If

    Proc_8_7_8051C0 = True
    Exit Function

LicenceFailed:
    On Error Resume Next
    Proc_8_7_8051C0 = False
    Proc_8_4_804970 0, 0, 0
End Function

Private Function ExtractLicenceSetting(ByVal sourceText As String, ByVal keyName As String) As String
    Dim marker As String
    Dim parts() As String
    Dim values() As String

    On Error GoTo LookupFailed
    marker = vbCr & keyName & "="
    parts = Split(sourceText, marker, -1, vbBinaryCompare)
    If UBound(parts) < 1 Then
        marker = vbCr & keyName & ":"
        parts = Split(sourceText, marker, -1, vbBinaryCompare)
    End If
    If UBound(parts) < 1 Then GoTo LookupFailed

    values = Split(CStr(parts(1)), vbCr, -1, vbBinaryCompare)
    ExtractLicenceSetting = CStr(values(0))
    Exit Function

LookupFailed:
    ExtractLicenceSetting = vbNullString
End Function

' Original declaration: Private Sub Proc_8_8_806720
Public Function Proc_8_8_806720(ParamArray args() As Variant) As Variant
    Dim fileNo As Integer

    On Error GoTo FileMissing
    If UBound(args) < 0 Then
        Proc_8_8_806720 = False
        Exit Function
    End If

    fileNo = FreeFile
    Open CStr(args(0)) For Input As #fileNo
    Close #fileNo
    Proc_8_8_806720 = True
    Exit Function

FileMissing:
    On Error Resume Next
    If fileNo <> 0 Then Close #fileNo
    Proc_8_8_806720 = False
End Function

' Original declaration: Private  Proc_8_9_806810(arg_C) '806810
Public Function Proc_8_9_806810(ParamArray args() As Variant) As Variant
    Dim fileNo As Integer

    On Error GoTo AppendFailed
    If UBound(args) >= 1 Then
        fileNo = FreeFile
        Open CStr(args(0)) For Append As #fileNo
        Print #fileNo, CStr(args(1))
        Close #fileNo
    End If
    Proc_8_9_806810 = Empty
    Exit Function

AppendFailed:
    On Error Resume Next
    If fileNo <> 0 Then Close #fileNo
    Proc_8_9_806810 = Empty
End Function

' Original declaration: Private  Proc_8_10_8068E0(arg_C) '8068E0
Public Function Proc_8_10_8068E0(ParamArray args() As Variant) As Variant
    Dim fileNo As Integer

    On Error GoTo WriteFailed
    If UBound(args) >= 1 Then
        fileNo = FreeFile
        Open CStr(args(0)) For Output As #fileNo
        Print #fileNo, CStr(args(1))
        Close #fileNo
    End If
    Proc_8_10_8068E0 = Empty
    Exit Function

WriteFailed:
    On Error Resume Next
    If fileNo <> 0 Then Close #fileNo
    Proc_8_10_8068E0 = Empty
End Function

' Original declaration: Private Sub Proc_8_11_8069B0
Public Function Proc_8_11_8069B0(ParamArray args() As Variant) As Variant
    On Error GoTo LookupFailed
    If UBound(args) < 0 Then
        Proc_8_11_8069B0 = vbNullString
    Else
        Proc_8_11_8069B0 = GetNullDelimitedCacheField(global_008291AC, CStr(args(0)), GetOptionalColumnIndex(args, 1, 0))
    End If
    Exit Function

LookupFailed:
    Proc_8_11_8069B0 = vbNullString
End Function

' Original declaration: Private  Proc_8_12_806C30(arg_C) '806C30
Public Function Proc_8_12_806C30(ParamArray args() As Variant) As Variant
    On Error GoTo LookupFailed
    If UBound(args) < 1 Then
        Proc_8_12_806C30 = vbNullString
    Else
        Proc_8_12_806C30 = GetProductCacheCell(CLng(Val(CStr(args(0)))), CLng(Val(CStr(args(1)))))
    End If
    Exit Function

LookupFailed:
    Proc_8_12_806C30 = vbNullString
End Function

Private Function GetOptionalColumnIndex(ByRef args() As Variant, ByVal argumentIndex As Long, ByVal defaultValue As Long) As Long
    On Error GoTo UseDefault
    If UBound(args) >= argumentIndex Then
        If Len(CStr(args(argumentIndex))) > 0 Then
            GetOptionalColumnIndex = CLng(Val(CStr(args(argumentIndex))))
            Exit Function
        End If
    End If

UseDefault:
    GetOptionalColumnIndex = defaultValue
End Function

Private Function GetNullDelimitedCacheField(ByVal cacheText As String, ByVal keyName As String, ByVal columnIndex As Long) As String
    Dim marker As String
    Dim fields() As String

    If Len(cacheText) = 0 Or Len(keyName) = 0 Then Exit Function

    marker = Chr$(0) & keyName & Chr$(1)
    fields = Split(CStr(Split(cacheText, marker)(1)), Chr$(2))
    If columnIndex < LBound(fields) Or columnIndex > UBound(fields) Then Exit Function
    GetNullDelimitedCacheField = fields(columnIndex)
End Function

Private Function GetProductCacheCell(ByVal productId As Long, ByVal columnIndex As Long) As String
    Dim rowValue As String
    Dim columns() As String

    On Error GoTo LookupFailed
    If IsArray(global_008292BC) Then
        rowValue = CStr(global_008292BC(productId))
    Else
        rowValue = GetDelimitedProductRow(CStr(global_008292BC), productId)
    End If

    columns = Split(rowValue, Chr$(9))
    If columnIndex < LBound(columns) Or columnIndex > UBound(columns) Then Exit Function
    GetProductCacheCell = columns(columnIndex)
    Exit Function

LookupFailed:
    GetProductCacheCell = vbNullString
End Function

Private Function GetDelimitedProductRow(ByVal tableText As String, ByVal productId As Long) As String
    Dim rows() As String
    Dim rowIndex As Long
    Dim columns() As String

    If Len(tableText) = 0 Then Exit Function

    rows = Split(vbCr & tableText & vbCr, vbCr)
    For rowIndex = LBound(rows) To UBound(rows)
        If Len(rows(rowIndex)) > 0 Then
            columns = Split(rows(rowIndex), Chr$(9))
            If UBound(columns) >= 0 Then
                If CLng(Val(columns(0))) = productId Then
                    GetDelimitedProductRow = rows(rowIndex)
                    Exit Function
                End If
            End If
        End If
    Next rowIndex
End Function
