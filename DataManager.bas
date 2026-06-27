Attribute VB_Name = "DataManager"
Option Explicit

' Reconstructed VB6 source shell generated from decompiled output.
' Source reference: /opt/git/AlphaSeries_cracked/DECOMPILED/DataManager.bas
' Decompiled procedure bodies are intentionally not copied until they are understood and made valid VB6.

Public global_008291AC As String

' Original declaration: Private Sub Proc_8_0_804330
Public Function Proc_8_0_804330(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_8_0_804330 = Empty
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
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_8_3_804530 = Empty
End Function

' Original declaration: Private Sub Proc_8_4_804970
Public Function Proc_8_4_804970(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
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
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_8_6_804D80 = Empty
End Function

' Original declaration: Private Sub Proc_8_7_8051C0
Public Function Proc_8_7_8051C0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_8_7_8051C0 = Empty
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
