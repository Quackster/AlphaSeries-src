Attribute VB_Name = "Guardian"
Option Explicit

' Reconstructed VB6 source shell generated from decompiled output.
' Source reference: /opt/git/AlphaSeries_cracked/DECOMPILED/Guardian.bas
' Decompiled procedure bodies are intentionally not copied until they are understood and made valid VB6.

' Original declaration: Private  Proc_11_0_821190(arg_C) '821190
Public Function Proc_11_0_821190(ParamArray args() As Variant) As Variant
    On Error Resume Next
    If UBound(args) >= 0 Then
        MkDir CStr(args(0))
    End If
    Proc_11_0_821190 = Empty
End Function

' Original declaration: Private  Proc_11_1_821240(arg_C) '821240
Public Function Proc_11_1_821240(ParamArray args() As Variant) As Variant
    Dim fso As Object

    On Error Resume Next
    If UBound(args) >= 0 Then
        Set fso = CreateObject("Scripting.FileSystemObject")
        fso.DeleteFolder CStr(args(0)), True
        Set fso = Nothing
    End If
    Proc_11_1_821240 = Empty
End Function

' Original declaration: Private Sub Proc_11_2_821390
Public Function Proc_11_2_821390(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_11_2_821390 = Empty
End Function

' Original declaration: Private Sub Proc_11_3_821440
Public Function Proc_11_3_821440(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_11_3_821440 = Empty
End Function
