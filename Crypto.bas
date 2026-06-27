Attribute VB_Name = "Crypto"
Option Explicit

' Reconstructed VB6 source shell generated from decompiled output.
' Source reference: /opt/git/AlphaSeries_cracked/DECOMPILED/Crypto.bas
' Decompiled procedure bodies are intentionally not copied until they are understood and made valid VB6.

' Original declaration: Private Sub Proc_3_0_6D2AF0
Public Function Proc_3_0_6D2AF0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_3_0_6D2AF0 = Empty
End Function

' Original declaration: Private  Proc_3_1_6D2E00(arg_C) '6D2E00
Public Function Proc_3_1_6D2E00(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_3_1_6D2E00 = Empty
End Function

' Original declaration: Private Sub Proc_3_2_6D30A0
Public Function Proc_3_2_6D30A0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_3_2_6D30A0 = Empty
End Function

' Original declaration: Private Sub Proc_3_3_6D3240
Public Function Proc_3_3_6D3240(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_3_3_6D3240 = Empty
End Function

' Original declaration: Private Sub Proc_3_4_6D3620
Public Function Proc_3_4_6D3620(ParamArray args() As Variant) As Variant
    Dim encodedValue As String
    Dim firstValue As Long
    Dim secondValue As Long

    On Error GoTo DecodeFailed
    If UBound(args) < 0 Then
        Proc_3_4_6D3620 = 0
        Exit Function
    End If

    encodedValue = CStr(args(0))
    If Len(encodedValue) = 1 Then
        encodedValue = "@" & encodedValue
    End If

    firstValue = Asc(Mid$(encodedValue, 1, 1)) - 64
    secondValue = Asc(Mid$(encodedValue, 2, 1)) - 64
    Proc_3_4_6D3620 = (firstValue * &H40&) + secondValue
    Exit Function

DecodeFailed:
    Proc_3_4_6D3620 = 0
End Function

' Original declaration: Private  Proc_3_5_6D3880(arg_C, arg_10, arg_14, arg_18, arg_1C) '6D3880
Public Function Proc_3_5_6D3880(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_3_5_6D3880 = Empty
End Function
