Attribute VB_Name = "Licence"
Option Explicit

' Reconstructed VB6 source shell generated from decompiled output.
' Source reference: /opt/git/AlphaSeries_cracked/DECOMPILED/Licence.bas
' Decompiled procedure bodies are intentionally not copied until they are understood and made valid VB6.

Public global_008292BC As Variant
Public global_008292C0 As Variant
Public global_008292C8 As Long
Public global_008292CC As Variant
Public global_008292D0 As Variant
Public global_008292D8 As Variant
Public global_008291E4 As String
Public global_008291E8 As Variant
Public global_0082927C As Variant
Public global_0082912C As String
Public global_0082911C As Variant
Public global_00829128 As Long
Public global_00829140 As Variant
Public global_0082915C As Variant
Public global_00829168 As Long
Public global_00829178 As String
Public global_0082917C As String
Public global_00829258 As String
Public global_0082916C As Long
Public global_008291EC As String
Public global_00829078 As String
Public global_0082907C As String
Public global_00829084 As String
Public global_00829094 As String
Public global_008290A0 As String
Public global_008290A4 As Long
Public global_008290A8 As Long
Public global_0082925C As String
Public global_00829260 As String
Public global_00829268 As String
Public global_00829204 As String
Public global_00829208 As String
Public global_0082920C As Variant
Public global_00829210 As Variant
Public global_00829224 As Variant
Public global_00829230 As String
Public global_00829244 As Variant
Public global_008291D4 As Variant
Public global_008291D8 As Long
Public global_0082919C As Long
Public global_008291A0 As String
Public global_00829190 As Boolean
Public global_0082904C As Long
Public global_00829038 As String
Public global_0082903C As Long
Public global_00829034 As Boolean
Public global_008290AC As Long
Public global_00829040 As String
Public global_00829044 As String
Public global_00829080 As String
Public global_00829098 As String
Public global_0082909C As String
Public global_0082934C As Variant
Public global_00829350 As String
Public global_00829354 As String

' Original declaration: Private  Proc_9_0_806F70(arg_C) '806F70
Public Function Proc_9_0_806F70(ParamArray args() As Variant) As Variant
    On Error GoTo LookupFailed
    If UBound(args) < 1 Then
        Proc_9_0_806F70 = 0
    Else
        Proc_9_0_806F70 = CLng(Val(GetTableCell(global_008292BC, CLng(Val(CStr(args(0)))), CLng(Val(CStr(args(1)))))))
    End If
    Exit Function

LookupFailed:
    Proc_9_0_806F70 = 0
End Function

' Original declaration: Private  Proc_9_1_8072B0(arg_C) '8072B0
Public Function Proc_9_1_8072B0(ParamArray args() As Variant) As Variant
    On Error GoTo LookupFailed
    If UBound(args) < 1 Then
        Proc_9_1_8072B0 = vbNullString
    Else
        Proc_9_1_8072B0 = GetTableCell(global_008292C0, CLng(Val(CStr(args(0)))), CLng(Val(CStr(args(1)))))
    End If
    Exit Function

LookupFailed:
    Proc_9_1_8072B0 = vbNullString
End Function

' Original declaration: Private  Proc_9_2_8075F0(arg_C) '8075F0
Public Function Proc_9_2_8075F0(ParamArray args() As Variant) As Variant
    On Error GoTo LookupFailed
    If UBound(args) < 1 Then
        Proc_9_2_8075F0 = 0
    Else
        Proc_9_2_8075F0 = CLng(Val(GetTableCell(global_008292C0, CLng(Val(CStr(args(0)))), CLng(Val(CStr(args(1)))))))
    End If
    Exit Function

LookupFailed:
    Proc_9_2_8075F0 = 0
End Function

' Original declaration: Private Sub Proc_9_3_807930
Public Function Proc_9_3_807930(ParamArray args() As Variant) As Variant
    On Error GoTo LookupFailed
    If UBound(args) < 0 Then
        Proc_9_3_807930 = vbNullString
    Else
        Proc_9_3_807930 = GetTableRow(global_008292BC, CLng(Val(CStr(args(0)))))
    End If
    Exit Function

LookupFailed:
    Proc_9_3_807930 = vbNullString
End Function

' Original declaration: Private Sub Proc_9_4_807B90
Public Function Proc_9_4_807B90(ParamArray args() As Variant) As Variant
    On Error GoTo LookupFailed
    If UBound(args) < 0 Then
        Proc_9_4_807B90 = vbNullString
    Else
        Proc_9_4_807B90 = GetTableRow(global_008292C0, CLng(Val(CStr(args(0)))))
    End If
    Exit Function

LookupFailed:
    Proc_9_4_807B90 = vbNullString
End Function

' Original declaration: Private Sub Proc_9_5_807DF0
Public Function Proc_9_5_807DF0(ParamArray args() As Variant) As Variant
    On Error GoTo LookupFailed
    If UBound(args) < 0 Then
        Proc_9_5_807DF0 = vbNullString
    Else
        Proc_9_5_807DF0 = GetDelimitedRow(global_00829258, CLng(Val(CStr(args(0)))))
    End If
    Exit Function

LookupFailed:
    Proc_9_5_807DF0 = vbNullString
End Function

' Original declaration: Private  Proc_9_6_808080(arg_C) '808080
Public Function Proc_9_6_808080(ParamArray args() As Variant) As Variant
    On Error GoTo LookupFailed
    If UBound(args) < 0 Then
        Proc_9_6_808080 = vbNullString
    Else
        Proc_9_6_808080 = GetSessionRecordField("0:", CStr(args(0)), GetOptionalColumnIndex(args, 1, 0))
    End If
    Exit Function

LookupFailed:
    Proc_9_6_808080 = vbNullString
End Function

' Original declaration: Private  Proc_9_7_808320(arg_C) '808320
Public Function Proc_9_7_808320(ParamArray args() As Variant) As Variant
    On Error GoTo LookupFailed
    If UBound(args) < 0 Then
        Proc_9_7_808320 = 0
    Else
        Proc_9_7_808320 = CLng(Val(GetSessionRecordField("1:", CStr(args(0)), GetOptionalColumnIndex(args, 1, 1))))
    End If
    Exit Function

LookupFailed:
    Proc_9_7_808320 = 0
End Function

' Original declaration: Private Sub Proc_9_8_8086A0
Public Function Proc_9_8_8086A0(ParamArray args() As Variant) As Variant
    On Error GoTo LookupFailed
    If UBound(args) < 0 Then
        Proc_9_8_8086A0 = 0
    Else
        Proc_9_8_8086A0 = CLng(Val(GetSessionLinkedValue(CStr(args(0)), True)))
    End If
    Exit Function

LookupFailed:
    Proc_9_8_8086A0 = 0
End Function

' Original declaration: Private Sub Proc_9_9_808AC0
Public Function Proc_9_9_808AC0(ParamArray args() As Variant) As Variant
    On Error GoTo LookupFailed
    If UBound(args) < 0 Then
        Proc_9_9_808AC0 = 0
    Else
        Proc_9_9_808AC0 = CLng(Val(GetSessionLinkedValue(CStr(args(0)), False)))
    End If
    Exit Function

LookupFailed:
    Proc_9_9_808AC0 = 0
End Function

' Original declaration: Private Sub Proc_9_10_808F30
Public Function Proc_9_10_808F30(ParamArray args() As Variant) As Variant
    On Error GoTo LookupFailed
    Proc_9_10_808F30 = CLng(Val(GetSessionCacheField(CStr(args(0)), GetOptionalColumnIndex(args, 1, 0))))
    Exit Function

LookupFailed:
    Proc_9_10_808F30 = 0
End Function

' Original declaration: Private Sub Proc_9_11_809220
Public Function Proc_9_11_809220(ParamArray args() As Variant) As Variant
    On Error GoTo LookupFailed
    Proc_9_11_809220 = CLng(Val(GetSessionCacheField(CStr(args(0)), GetOptionalColumnIndex(args, 1, 0))))
    Exit Function

LookupFailed:
    Proc_9_11_809220 = 0
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

Private Function GetSessionCacheField(ByVal keyName As String, ByVal columnIndex As Long) As String
    Dim lowerCache As String
    Dim marker As String
    Dim markerAt As Long
    Dim valueText As String
    Dim fields() As String

    If Len(keyName) = 0 Or Len(global_00829268) = 0 Then Exit Function

    lowerCache = LCase$(global_00829268)
    marker = "[" & LCase$(keyName) & Chr$(1)
    markerAt = InStr(1, lowerCache, marker, vbBinaryCompare)
    If markerAt = 0 Then Exit Function

    valueText = Mid$(global_00829268, markerAt + Len(marker))
    fields = Split(valueText, Chr$(2))
    If columnIndex < LBound(fields) Or columnIndex > UBound(fields) Then Exit Function
    GetSessionCacheField = fields(columnIndex)
End Function

Private Function GetSessionRecordField(ByVal recordPrefix As String, ByVal recordId As String, ByVal columnIndex As Long) As String
    Dim payload As String
    Dim fields() As String
    Dim valueParts() As String

    payload = GetSessionRecordPayload(recordPrefix, recordId)
    If Len(payload) = 0 Then Exit Function

    fields = Split(payload, Chr$(2))
    If columnIndex < LBound(fields) Or columnIndex > UBound(fields) Then Exit Function

    valueParts = Split(fields(columnIndex), "]")
    GetSessionRecordField = valueParts(0)
End Function

Private Function GetSessionRecordPayload(ByVal recordPrefix As String, ByVal recordId As String) As String
    Dim marker As String
    Dim markerAt As Long
    Dim payloadStart As Long
    Dim payloadEnd As Long

    If Len(global_00829268) = 0 Then Exit Function

    marker = "[" & recordPrefix & recordId & Chr$(1)
    markerAt = InStr(1, global_00829268, marker, vbTextCompare)
    If markerAt = 0 Then Exit Function

    payloadStart = markerAt + Len(marker)
    payloadEnd = InStr(payloadStart, global_00829268, "]", vbBinaryCompare)
    If payloadEnd = 0 Then payloadEnd = Len(global_00829268) + 1
    GetSessionRecordPayload = Mid$(global_00829268, payloadStart, payloadEnd - payloadStart)
End Function

Private Function GetSessionLinkedValue(ByVal recordId As String, ByVal useBracketCount As Boolean) As String
    Dim marker As String
    Dim parts() As String
    Dim sectionText As String
    Dim bracketParts() As String
    Dim valueParts() As String
    Dim targetIndex As Long

    If Len(global_00829268) = 0 Then Exit Function

    marker = Chr$(2) & recordId & "]"
    parts = Split(global_00829268, marker)
    If UBound(parts) < 1 Then Exit Function

    sectionText = parts(UBound(parts))
    bracketParts = Split(sectionText, "[")
    targetIndex = UBound(bracketParts)

    If useBracketCount Then
        valueParts = Split(sectionText, Chr$(1))
    Else
        valueParts = Split(sectionText, Chr$(0))
    End If

    If targetIndex < LBound(valueParts) Or targetIndex > UBound(valueParts) Then Exit Function
    GetSessionLinkedValue = valueParts(targetIndex)
End Function

Private Function GetTableCell(ByRef tableCache As Variant, ByVal rowId As Long, ByVal columnIndex As Long) As String
    Dim rowValue As String
    Dim columns() As String

    rowValue = GetTableRow(tableCache, rowId)
    If Len(rowValue) = 0 Then Exit Function

    columns = Split(rowValue, Chr$(9))
    If columnIndex < LBound(columns) Or columnIndex > UBound(columns) Then Exit Function
    GetTableCell = columns(columnIndex)
End Function

Private Function GetTableRow(ByRef tableCache As Variant, ByVal rowId As Long) As String
    On Error GoTo LookupFailed
    If rowId < 0 Then Exit Function

    If IsArray(tableCache) Then
        GetTableRow = CStr(tableCache(rowId))
    Else
        GetTableRow = GetDelimitedRow(CStr(tableCache), rowId)
    End If
    Exit Function

LookupFailed:
    GetTableRow = vbNullString
End Function

Private Function GetDelimitedRow(ByVal tableText As String, ByVal rowId As Long) As String
    Dim rows() As String
    Dim rowIndex As Long
    Dim rowText As String
    Dim columns() As String

    If Len(tableText) = 0 Then Exit Function

    rows = Split(vbCr & tableText & vbCr, vbCr)
    For rowIndex = LBound(rows) To UBound(rows)
        rowText = rows(rowIndex)
        If Len(rowText) > 0 Then
            columns = Split(rowText, Chr$(9))
            If UBound(columns) >= 0 Then
                If CLng(Val(columns(0))) = rowId Then
                    GetDelimitedRow = rowText
                    Exit Function
                End If
            End If
        End If
    Next rowIndex
End Function
