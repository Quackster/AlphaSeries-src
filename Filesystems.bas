Attribute VB_Name = "Filesystems"
Option Explicit

' Reconstructed VB6 source shell generated from decompiled output.
' Source reference: /opt/git/AlphaSeries_cracked/DECOMPILED/Filesystems.bas
' Decompiled procedure bodies are intentionally not copied until they are understood and made valid VB6.

' Original declaration: Private Sub Proc_7_0_8034A0
Public Function Proc_7_0_8034A0(ParamArray args() As Variant) As Variant
    Dim payload As String

    On Error GoTo BroadcastFailed
    If UBound(args) < 0 Then
        Proc_7_0_8034A0 = 0
        Exit Function
    End If

    payload = CStr(args(0))
    Proc_7_0_8034A0 = BroadcastToActiveSessions(payload, vbNullString)
    Exit Function

BroadcastFailed:
    Proc_7_0_8034A0 = 0
End Function

' Original declaration: Private  Proc_7_1_8038A0(arg_C) '8038A0
Public Function Proc_7_1_8038A0(ParamArray args() As Variant) As Variant
    Dim userName As String
    Dim payload As String

    On Error GoTo SendFailed
    If UBound(args) < 1 Then
        Proc_7_1_8038A0 = 0
        Exit Function
    End If

    userName = LCase$(CStr(args(0)))
    payload = CStr(args(1))
    Proc_7_1_8038A0 = BroadcastToActiveSessions(payload, userName)
    Exit Function

SendFailed:
    Proc_7_1_8038A0 = 0
End Function

' Original declaration: Private  Proc_7_2_803D60(arg_C) '803D60
Public Function Proc_7_2_803D60(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_7_2_803D60 = Empty
End Function

Private Function BroadcastToActiveSessions(ByVal payload As String, ByVal onlyUserName As String) As Long
    Dim records() As String
    Dim recordIndex As Long
    Dim recordText As String
    Dim payloadStart As Long
    Dim payloadEnd As Long
    Dim fields() As String
    Dim userName As String
    Dim socketIndex As Integer
    Dim sentCount As Long

    On Error GoTo BroadcastDone
    If Len(global_00829268) = 0 Then GoTo BroadcastDone

    records = Split(global_00829268, "[")
    For recordIndex = LBound(records) To UBound(records)
        recordText = records(recordIndex)
        If Left$(recordText, 2) = "1:" Then
            payloadStart = InStr(1, recordText, Chr$(1), vbBinaryCompare)
            If payloadStart > 0 Then
                payloadEnd = InStr(payloadStart + 1, recordText, "]", vbBinaryCompare)
                If payloadEnd = 0 Then payloadEnd = Len(recordText) + 1

                fields = Split(Mid$(recordText, payloadStart + 1, payloadEnd - payloadStart - 1), Chr$(2))
                If UBound(fields) >= 1 Then
                    userName = LCase$(CStr(fields(0)))
                    If Len(onlyUserName) = 0 Or userName = onlyUserName Then
                        socketIndex = CInt(Val(CStr(fields(1))))
                        Proc_12_1_821AA0 socketIndex, payload
                        sentCount = sentCount + 1
                    End If
                End If
            End If
        End If
    Next recordIndex

BroadcastDone:
    BroadcastToActiveSessions = sentCount
End Function
