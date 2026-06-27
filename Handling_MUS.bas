Attribute VB_Name = "Handling_MUS"
Option Explicit

' Reconstructed VB6 source shell generated from decompiled output.
' Source reference: /opt/git/AlphaSeries_cracked/DECOMPILED/Handling_MUS.bas
' Decompiled procedure bodies are intentionally not copied until they are understood and made valid VB6.

' Original declaration: Private Sub Proc_12_0_8218C0
Public Function Proc_12_0_8218C0(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim payload As String

    On Error GoTo ShutdownFailed
    socketIndex = MusSocketIndex(args)
    payload = "SHUTDOWN" & Chr$(6) & CStr(socketIndex) & Chr$(7)
    SendMusPayload socketIndex, payload

ShutdownFailed:
    Proc_12_0_8218C0 = Empty
End Function

' Original declaration: Private  Proc_12_1_821AA0(arg_C) '821AA0
Public Function Proc_12_1_821AA0(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim payload As String
    Dim messageText As String

    On Error GoTo DataFailed
    socketIndex = MusSocketIndex(args)
    If UBound(args) >= 1 Then messageText = CStr(args(1))

    payload = "DATA" & Chr$(6) & CStr(socketIndex) & Chr$(6) & messageText & Chr$(7)
    SendMusPayload socketIndex, payload

DataFailed:
    Proc_12_1_821AA0 = Empty
End Function

Private Function MusSocketIndex(ByRef args() As Variant) As Integer
    On Error GoTo DefaultIndex
    If UBound(args) >= 0 Then
        MusSocketIndex = CInt(Val(CStr(args(0))))
        Exit Function
    End If

DefaultIndex:
    MusSocketIndex = 0
End Function

Private Sub SendMusPayload(ByVal socketIndex As Integer, ByVal payload As String)
    On Error Resume Next
    Main.musServer(socketIndex).SendData payload
End Sub
