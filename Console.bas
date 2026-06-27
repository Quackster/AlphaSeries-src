Attribute VB_Name = "Console"
Option Explicit

' Reconstructed VB6 source shell generated from decompiled output.
' Source reference: /opt/git/AlphaSeries_cracked/DECOMPILED/Console.bas
' Decompiled procedure bodies are intentionally not copied until they are understood and made valid VB6.

' Original declaration: Private  Proc_2_0_6D1510(arg_C, arg_10) '6D1510
Public Function Proc_2_0_6D1510(ParamArray args() As Variant) As Variant
    Dim messageText As String
    Dim sourceName As String
    Dim foreColor As Long

    On Error GoTo AppendDone
    If UBound(args) >= 0 Then messageText = CStr(args(0))
    If UBound(args) >= 1 Then sourceName = CStr(args(1))
    If UBound(args) >= 2 Then foreColor = CLng(Val(CStr(args(2)))) Else foreColor = vbWhite

    AppendConsoleLine "[" & sourceName & "] " & messageText, foreColor

AppendDone:
    Proc_2_0_6D1510 = Empty
End Function

' Original declaration: Private  Proc_2_1_6D1B60(arg_C, arg_10, arg_14) '6D1B60
Public Function Proc_2_1_6D1B60(ParamArray args() As Variant) As Variant
    Dim messageText As String
    Dim foreColor As Long

    On Error GoTo AppendDone
    If UBound(args) >= 0 Then messageText = CStr(args(0))
    If UBound(args) >= 2 Then foreColor = CLng(Val(CStr(args(2)))) Else foreColor = vbWhite

    AppendConsoleLine messageText, foreColor

AppendDone:
    Proc_2_1_6D1B60 = Empty
End Function

' Original declaration: Private  Proc_2_2_6D21D0(arg_C, arg_10) '6D21D0
Public Function Proc_2_2_6D21D0(ParamArray args() As Variant) As Variant
    Dim messageText As String
    Dim sourceName As String
    Dim foreColor As Long

    On Error GoTo AppendDone
    If UBound(args) >= 0 Then messageText = CStr(args(0))
    If UBound(args) >= 1 Then sourceName = CStr(args(1))
    If UBound(args) >= 2 Then foreColor = CLng(Val(CStr(args(2)))) Else foreColor = vbWhite

    If Len(sourceName) > 0 And UCase$(sourceName) <> "HIDDEN" Then
        AppendConsoleLine "[" & sourceName & "] " & messageText, foreColor
    Else
        AppendConsoleLine messageText, foreColor
    End If

AppendDone:
    Proc_2_2_6D21D0 = Empty
End Function

' Original declaration: Private Sub Proc_2_3_6D27D0
Public Function Proc_2_3_6D27D0(ParamArray args() As Variant) As Variant
    Dim secondsToWait As Single
    Dim startTime As Single

    On Error GoTo DelayDone
    If UBound(args) < 0 Then GoTo DelayDone

    secondsToWait = CSng(args(0))
    startTime = Timer
    Do While ElapsedSeconds(startTime, Timer) < secondsToWait
        DoEvents
    Loop

DelayDone:
    Proc_2_3_6D27D0 = Empty
End Function

' Original declaration: Private Sub Proc_2_4_6D28B0
Public Function Proc_2_4_6D28B0(ParamArray args() As Variant) As Variant
    Dim value As Long
    Dim highValue As Long
    Dim lowValue As Long

    On Error GoTo EncodeFailed
    If UBound(args) < 0 Then
        Proc_2_4_6D28B0 = "@@"
        Exit Function
    End If

    value = CLng(args(0))
    If value < 0 Then value = 0

    highValue = value \ &H40&
    lowValue = value Mod &H40&
    Proc_2_4_6D28B0 = Chr$(highValue + 64) & Chr$(lowValue + 64)
    Exit Function

EncodeFailed:
    Proc_2_4_6D28B0 = "@@"
End Function

Private Function ElapsedSeconds(ByVal startTime As Single, ByVal endTime As Single) As Single
    If endTime < startTime Then
        ElapsedSeconds = (86400! - startTime) + endTime
    Else
        ElapsedSeconds = endTime - startTime
    End If
End Function

Private Sub AppendConsoleLine(ByVal lineText As String, ByVal foreColor As Long)
    On Error Resume Next

    With Main.txtLog
        .SelStart = Len(.Text)
        If Len(.Text) > 0 Then .SelText = vbCrLf
        .SelStart = Len(.Text)
        .SelColor = foreColor
        .SelText = lineText
        .SelStart = Len(.Text)
    End With
End Sub
