Attribute VB_Name = "Licence"
Option Explicit

' Reconstructed VB6 source shell generated from decompiled output.
' Source reference: /opt/git/AlphaSeries_cracked/DECOMPILED/Licence.bas
' Decompiled procedure bodies are intentionally not copied until they are understood and made valid VB6.

Public global_008292BC As Variant
Public global_008292C0 As Variant
Public global_00829258 As String
Public global_00829268 As String

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
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_9_6_808080 = Empty
End Function

' Original declaration: Private  Proc_9_7_808320(arg_C) '808320
Public Function Proc_9_7_808320(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_9_7_808320 = Empty
End Function

' Original declaration: Private Sub Proc_9_8_8086A0
Public Function Proc_9_8_8086A0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_9_8_8086A0 = Empty
End Function

' Original declaration: Private Sub Proc_9_9_808AC0
Public Function Proc_9_9_808AC0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_9_9_808AC0 = Empty
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
