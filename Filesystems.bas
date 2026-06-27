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
    Dim socketIndex As Long
    Dim packetBuffer As String
    Dim packetLength As Long
    Dim packetPayload As String
    Dim packetCode As String

    On Error GoTo DispatchDone
    If UBound(args) < 1 Then GoTo DispatchDone

    socketIndex = CLng(Val(CStr(args(0))))
    packetBuffer = CStr(args(1))
    If Proc_11_2_821390(socketIndex, 0, 0) <> 1 Then GoTo DispatchDone

    If InStr(1, packetBuffer, Chr$(0), vbBinaryCompare) > 0 Then
        Proc_12_1_821AA0 socketIndex, BuildCrossDomainPolicy()
        GoTo DispatchDone
    End If

    Do While Len(packetBuffer) > 2
        packetBuffer = Mid$(packetBuffer, 2)
        packetLength = CLng(Val(CStr(Proc_3_4_6D3620(Mid$(packetBuffer, 1, 2)))))
        If packetLength <= 0 Or Len(packetBuffer) < packetLength + 2 Then Exit Do

        packetPayload = Mid$(packetBuffer, 3, packetLength)
        packetCode = Left$(packetPayload, 2)

        If global_00829190 Then
            Proc_2_0_6D1510 "[" & CStr(socketIndex) & "] " & packetPayload, "GAME", CStr(16711680)
        End If

        DispatchReadyPacket socketIndex, packetCode, packetPayload
        packetBuffer = Mid$(packetBuffer, packetLength + 3)
    Loop

DispatchDone:
    Proc_7_2_803D60 = Empty
End Function

Private Function BuildCrossDomainPolicy() As String
    BuildCrossDomainPolicy = "<?xml version=""1.0""?>" & vbCrLf & _
        "<!DOCTYPE cross-domain-policy SYSTEM ""/xml/dtds/cross-domain-policy.dtd"">" & vbCrLf & _
        "<cross-domain-policy>" & vbCrLf & _
        "<allow-access-from domain=""images.habbo.com"" to-ports=""1-50000"" />" & vbCrLf & _
        "<allow-access-from domain=""*"" to-ports=""1-50000"" />" & vbCrLf & _
        "</cross-domain-policy>" & Chr$(0)
End Function

Private Sub DispatchReadyPacket(ByVal socketIndex As Long, ByVal packetCode As String, ByVal packetPayload As String)
    Select Case packetCode
        Case "CN"
            Proc_6_162_7B3310 socketIndex, packetPayload, 0
        Case "F_"
            Proc_6_163_7B3480 socketIndex, packetPayload, 0
        Case "CD"
            ' Decompiled target was an unresolved Proc_7FA5A0 symbol; leave CD packets for a later exact mapping pass.
    End Select
End Sub

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
