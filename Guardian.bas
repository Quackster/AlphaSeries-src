Attribute VB_Name = "Guardian"
Option Explicit

' Reconstructed VB6 source shell generated from decompiled output.
' Source reference: /opt/git/AlphaSeries_cracked/DECOMPILED/Guardian.bas
' Decompiled procedure bodies are intentionally not copied until they are understood and made valid VB6.

Private Const WinsockConnectedState As Long = 7
Private Const SocketIndexStart As String = "["
Private Const SocketIndexEnd As String = "]"

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
    Dim socketIndex As Long

    On Error GoTo NotConnected

    If Main.gameServer.State = WinsockConnectedState Then
        Proc_11_2_821390 = 1
        Exit Function
    End If

    If UBound(args) >= 0 Then
        socketIndex = CLng(Val(CStr(args(0))))
        If Main.musServer(socketIndex).State = WinsockConnectedState Then
            Proc_11_2_821390 = 1
            Exit Function
        End If
    End If

NotConnected:
    Proc_11_2_821390 = 0
End Function

' Original declaration: Private Sub Proc_11_3_821440
Public Function Proc_11_3_821440(ParamArray args() As Variant) As Variant
    Dim socketIndex As Long
    Dim marker As String

    On Error GoTo ListenFailed
    If UBound(args) < 0 Then GoTo ListenFailed

    socketIndex = CLng(Val(CStr(args(0))))
    If socketIndex < 0 Or socketIndex = 2500 Then GoTo ListenFailed

    marker = SocketIndexStart & CStr(socketIndex) & SocketIndexEnd
    If InStr(1, global_008291A0, marker, vbBinaryCompare) = 0 Then
        EnsureSocketControlsLoaded socketIndex
        global_008291A0 = global_008291A0 & marker
        If socketIndex > global_0082919C Then global_0082919C = socketIndex
    Else
        global_008291A0 = Replace(global_008291A0, marker, vbNullString, 1, -1, vbBinaryCompare)
    End If

    If Main.musServer(socketIndex).State <> 0 Then
        Main.musServer(socketIndex).Close
    End If

    Main.DataProcess(socketIndex).Enabled = True
    Proc_11_3_821440 = Empty

    Exit Function

ListenFailed:
    Proc_11_3_821440 = Empty
End Function

Private Sub EnsureSocketControlsLoaded(ByVal socketIndex As Long)
    Dim controlIndex As Long

    On Error Resume Next
    For controlIndex = 1 To socketIndex
        Load Main.musServer(controlIndex)
        Load Main.DataProcess(controlIndex)
    Next controlIndex
End Sub
