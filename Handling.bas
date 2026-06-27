Attribute VB_Name = "Handling"
Option Explicit

' Reconstructed VB6 source shell generated from decompiled output.
' Source reference: /opt/git/AlphaSeries_cracked/DECOMPILED/Handling.bas
' Decompiled procedure bodies are intentionally not copied until they are understood and made valid VB6.

' Original declaration: Private Sub Proc_6_0_6D7FF0
Public Function Proc_6_0_6D7FF0(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim requestPayload As String
    Dim callerUserId As String
    Dim targetUserId As String
    Dim userRow As String
    Dim userFields() As String
    Dim offset As Long
    Dim payload As String

    On Error GoTo SummaryFailed

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    If Len(packetPayload) = 0 And UBound(args) >= 1 Then packetPayload = CStr(args(1))

    requestPayload = packetPayload
    If Left$(requestPayload, 2) = "GF" Then requestPayload = Mid$(requestPayload, 3)

    targetUserId = CStr(Val(CStr(Proc_10_6_809F10(requestPayload, 0, 0))))
    If Len(targetUserId) = 0 Or targetUserId = "0" Then
        offset = 1
        targetUserId = CStr(ReadWireLong(requestPayload, offset))
    End If
    If Len(targetUserId) = 0 Or targetUserId = "0" Then GoTo SummaryFailed

    callerUserId = HandlingUserIdFromSocket(socketIndex)
    If Len(callerUserId) = 0 Or callerUserId = "0" Then GoTo SummaryFailed
    If Not HandlingUserHasPermission(callerUserId, "fuse_mod") Then GoTo SummaryFailed

    userRow = CStr(Proc_5_2_6D4690("SELECT users.id,users.name,ROUND((UNIX_TIMESTAMP()-users.create_time)/60,0),ROUND((UNIX_TIMESTAMP()-users.lastonline_time)/60,0),users.id_socket FROM users WHERE users.id='" & _
        Proc_10_11_80A9C0(targetUserId, 0, 0) & "' LIMIT 1", 0, 0))
    If Len(userRow) = 0 Then GoTo SummaryFailed

    userFields = Split(userRow, Chr$(9))
    payload = StaffUserSummaryPayload(userFields)
    If Len(payload) > 0 Then Proc_6_244_801E80 socketIndex, payload, 0

SummaryFailed:
    Proc_6_0_6D7FF0 = Empty
End Function

' Original declaration: Private Sub Proc_6_1_6D8B70
Public Function Proc_6_1_6D8B70(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim requestPayload As String
    Dim callerUserId As String
    Dim targetUserId As String
    Dim targetSocketIndex As Integer
    Dim currentRoomId As Long
    Dim alertMessage As String
    Dim offset As Long

    On Error GoTo AlertFailed

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    If Len(packetPayload) = 0 And UBound(args) >= 1 Then packetPayload = CStr(args(1))

    requestPayload = packetPayload
    If Left$(requestPayload, 2) = "GM" Then requestPayload = Mid$(requestPayload, 3)

    offset = 1
    targetUserId = CStr(ReadWireLong(requestPayload, offset))
    If Len(targetUserId) = 0 Or targetUserId = "0" Then targetUserId = CStr(Val(CStr(Proc_10_6_809F10(requestPayload, 0, 0))))
    If Len(targetUserId) = 0 Or targetUserId = "0" Then GoTo AlertFailed

    alertMessage = ReadWireString(requestPayload, offset)
    If Len(alertMessage) = 0 Then alertMessage = CStr(Proc_10_7_80A190(requestPayload, 0, 0))
    If Len(alertMessage) = 0 Then GoTo AlertFailed

    callerUserId = HandlingUserIdFromSocket(socketIndex)
    If Len(callerUserId) = 0 Or callerUserId = "0" Then GoTo AlertFailed
    If Not HandlingUserHasPermission(callerUserId, "fuse_mod") Then GoTo AlertFailed
    If Not HandlingUserHasPermission(callerUserId, "fuse_alert") Then GoTo AlertFailed
    If ContainsUnsafeStaffAlert(alertMessage) Then GoTo AlertFailed

    currentRoomId = HandlingCurrentRoomId(socketIndex, callerUserId)
    Proc_5_1_6D4110 "INSERT INTO logs_moderation(id_type,id_user,id_target,id_target_2,timestamp,message,id_session) VALUES('4','" & _
        Proc_10_11_80A9C0(callerUserId, 0, 0) & "','" & Proc_10_11_80A9C0(targetUserId, 0, 0) & "','" & CStr(currentRoomId) & "',UNIX_TIMESTAMP(),'" & _
        Proc_10_11_80A9C0(alertMessage, 0, 0) & "','" & CStr(socketIndex) & "')", 0, 0

    targetSocketIndex = HandlingSocketFromUserId(targetUserId)
    If targetSocketIndex > 0 Then Proc_6_244_801E80 targetSocketIndex, "Ba" & alertMessage & Chr$(2), 0

    Proc_5_0_6D3CD0 "INSERT INTO users_cautions(id_user,id_partner,message,timestamp_submit) VALUES('" & _
        Proc_10_11_80A9C0(targetUserId, 0, 0) & "','" & Proc_10_11_80A9C0(callerUserId, 0, 0) & "','" & Proc_10_11_80A9C0(alertMessage, 0, 0) & "',UNIX_TIMESTAMP())", 0, 0

AlertFailed:
    Proc_6_1_6D8B70 = Empty
End Function

' Original declaration: Private Sub Proc_6_2_6D9880
Public Function Proc_6_2_6D9880(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim requestPayload As String
    Dim callerUserId As String
    Dim targetUserId As String
    Dim targetSocketIndex As Integer
    Dim currentRoomId As Long
    Dim kickMessage As String
    Dim offset As Long

    On Error GoTo KickFailed

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    If Len(packetPayload) = 0 And UBound(args) >= 1 Then packetPayload = CStr(args(1))

    requestPayload = packetPayload
    If Left$(requestPayload, 2) = "GO" Then requestPayload = Mid$(requestPayload, 3)

    offset = 1
    targetUserId = CStr(ReadWireLong(requestPayload, offset))
    If Len(targetUserId) = 0 Or targetUserId = "0" Then targetUserId = CStr(Val(CStr(Proc_10_6_809F10(requestPayload, 0, 0))))
    If Len(targetUserId) = 0 Or targetUserId = "0" Then GoTo KickFailed

    kickMessage = ReadWireString(requestPayload, offset)
    If Len(kickMessage) = 0 Then kickMessage = CStr(Proc_10_7_80A190(requestPayload, 0, 0))
    If Len(kickMessage) = 0 Then GoTo KickFailed

    callerUserId = HandlingUserIdFromSocket(socketIndex)
    If Len(callerUserId) = 0 Or callerUserId = "0" Then GoTo KickFailed
    If Not HandlingUserHasPermission(callerUserId, "fuse_mod") Then GoTo KickFailed
    If Not HandlingUserHasPermission(callerUserId, "fuse_kick") Then GoTo KickFailed
    If ContainsUnsafeStaffAlert(kickMessage) Then GoTo KickFailed

    targetSocketIndex = HandlingSocketFromUserId(targetUserId)
    If targetSocketIndex <= 0 Then GoTo KickFailed

    currentRoomId = HandlingCurrentRoomId(socketIndex, callerUserId)
    Proc_5_1_6D4110 "INSERT INTO logs_moderation(id_type,id_user,id_target,id_target_2,timestamp,message,id_session) VALUES('5','" & _
        Proc_10_11_80A9C0(callerUserId, 0, 0) & "','" & Proc_10_11_80A9C0(targetUserId, 0, 0) & "','" & CStr(currentRoomId) & "',UNIX_TIMESTAMP(),'" & _
        Proc_10_11_80A9C0(kickMessage, 0, 0) & "','" & CStr(socketIndex) & "')", 0, 0

    Proc_6_244_801E80 targetSocketIndex, "Ba" & kickMessage & Chr$(2), 0
    Proc_6_53_718E00 targetSocketIndex, 0, 0

KickFailed:
    Proc_6_2_6D9880 = Empty
End Function

' Original declaration: Private Sub Proc_6_3_6DA490
Public Function Proc_6_3_6DA490(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim requestPayload As String
    Dim callerUserId As String
    Dim targetUserId As String
    Dim targetSocketIndex As Integer
    Dim currentRoomId As Long
    Dim banMessage As String
    Dim banHours As Long
    Dim banSeconds As Long
    Dim targetIpAddress As String
    Dim offset As Long

    On Error GoTo BanFailed

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    If Len(packetPayload) = 0 And UBound(args) >= 1 Then packetPayload = CStr(args(1))

    requestPayload = packetPayload
    If Left$(requestPayload, 2) = "GP" Then requestPayload = Mid$(requestPayload, 3)

    offset = 1
    targetUserId = CStr(ReadWireLong(requestPayload, offset))
    If Len(targetUserId) = 0 Or targetUserId = "0" Then targetUserId = CStr(Val(CStr(Proc_10_6_809F10(requestPayload, 0, 0))))
    If Len(targetUserId) = 0 Or targetUserId = "0" Then GoTo BanFailed

    banMessage = CStr(Proc_10_10_80A7F0(ReadWireString(requestPayload, offset), 0, 0))
    If Len(banMessage) = 0 Then banMessage = CStr(Proc_10_10_80A7F0(Proc_10_7_80A190(requestPayload, 0, 0), 0, 0))
    If Len(banMessage) = 0 Then GoTo BanFailed

    banHours = ReadWireLong(requestPayload, offset)
    If banHours <= 0 Then banHours = CLng(Val(CStr(Proc_10_6_809F10(Mid$(requestPayload, offset), 0, 0))))
    If banHours <= 0 Then GoTo BanFailed
    banSeconds = banHours * 60 * 60

    callerUserId = HandlingUserIdFromSocket(socketIndex)
    If Len(callerUserId) = 0 Or callerUserId = "0" Then GoTo BanFailed
    If Not HandlingUserHasPermission(callerUserId, "fuse_mod") Then GoTo BanFailed
    If Not HandlingUserHasPermission(callerUserId, "fuse_alert") Then GoTo BanFailed
    If ContainsUnsafeStaffAlert(banMessage) Then GoTo BanFailed

    currentRoomId = HandlingCurrentRoomId(socketIndex, callerUserId)
    Proc_5_1_6D4110 "INSERT INTO logs_moderation(id_type,id_user,id_target,id_target_2,timestamp,message,id_session) VALUES('6','" & _
        Proc_10_11_80A9C0(callerUserId, 0, 0) & "','" & Proc_10_11_80A9C0(targetUserId, 0, 0) & "','" & CStr(currentRoomId) & "',UNIX_TIMESTAMP(),'" & _
        Proc_10_11_80A9C0(banMessage, 0, 0) & "','" & CStr(socketIndex) & "')", 0, 0

    targetIpAddress = CStr(Proc_5_2_6D4690("SELECT ip_last FROM users WHERE id='" & Proc_10_11_80A9C0(targetUserId, 0, 0) & "' LIMIT 1", 0, 0))
    If Len(targetIpAddress) > 0 Then
        Proc_5_0_6D3CD0 "INSERT INTO users_bans(id_user,id_partner,message,timestamp_expire,timestamp_submit,ipaddress) VALUES('" & _
            Proc_10_11_80A9C0(targetUserId, 0, 0) & "','" & Proc_10_11_80A9C0(callerUserId, 0, 0) & "','" & _
            Proc_10_11_80A9C0(banMessage, 0, 0) & "',UNIX_TIMESTAMP()+" & CStr(banSeconds) & ",UNIX_TIMESTAMP(),'" & _
            Proc_10_11_80A9C0(targetIpAddress, 0, 0) & "')", 0, 0
    Else
        Proc_5_0_6D3CD0 "INSERT INTO users_bans(id_user,id_partner,message,timestamp_expire,timestamp_submit) VALUES('" & _
            Proc_10_11_80A9C0(targetUserId, 0, 0) & "','" & Proc_10_11_80A9C0(callerUserId, 0, 0) & "','" & _
            Proc_10_11_80A9C0(banMessage, 0, 0) & "',UNIX_TIMESTAMP()+" & CStr(banSeconds) & ",UNIX_TIMESTAMP())", 0, 0
    End If

    Proc_5_0_6D3CD0 "UPDATE users SET login_session=NULL WHERE id='" & Proc_10_11_80A9C0(targetUserId, 0, 0) & "'", 0, 0

    targetSocketIndex = HandlingSocketFromUserId(targetUserId)
    If targetSocketIndex > 0 Then
        Proc_6_244_801E80 targetSocketIndex, "@c" & banMessage & Chr$(2), 0
        Proc_6_243_7FFEB0 targetSocketIndex, 0, 0
    End If

BanFailed:
    Proc_6_3_6DA490 = Empty
End Function

' Original declaration: Private Sub Proc_6_4_6DAFB0
Public Function Proc_6_4_6DAFB0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_4_6DAFB0 = Empty
End Function

' Original declaration: Private  Proc_6_5_6DC340(arg_C) '6DC340
Public Function Proc_6_5_6DC340(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_5_6DC340 = Empty
End Function

' Original declaration: Private Sub Proc_6_6_6DC9D0
Public Function Proc_6_6_6DC9D0(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim requestPayload As String
    Dim callerUserId As String
    Dim whereClause As String
    Dim offset As Long

    On Error GoTo PickFailed

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    If Len(packetPayload) = 0 And UBound(args) >= 1 Then packetPayload = CStr(args(1))

    requestPayload = packetPayload
    If Left$(requestPayload, 2) = "GB" Then requestPayload = Mid$(requestPayload, 3)

    callerUserId = HandlingUserIdFromSocket(socketIndex)
    If Len(callerUserId) = 0 Or callerUserId = "0" Then GoTo PickFailed
    If Not HandlingUserHasPermission(callerUserId, "fuse_mod") Then GoTo PickFailed
    If Not HandlingUserHasPermission(callerUserId, "fuse_receive_calls_for_help") Then GoTo PickFailed

    offset = 1
    whereClause = StaffCallForHelpWhereClause(requestPayload, offset)
    If Len(whereClause) = 0 Then GoTo PickFailed

    Proc_5_0_6D3CD0 "UPDATE staff_cfh SET id_tab='2',id_picker='" & Proc_10_11_80A9C0(callerUserId, 0, 0) & "',timestamp_picked=UNIX_TIMESTAMP() WHERE " & whereClause, 0, 0

PickFailed:
    Proc_6_6_6DC9D0 = Empty
End Function

' Original declaration: Private Sub Proc_6_7_6DD0E0
Public Function Proc_6_7_6DD0E0(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim requestPayload As String
    Dim callerUserId As String
    Dim closeState As Long
    Dim callForHelpId As Long
    Dim reporterUserId As String
    Dim reporterSocketIndex As Integer
    Dim offset As Long

    On Error GoTo CloseFailed

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    If Len(packetPayload) = 0 And UBound(args) >= 1 Then packetPayload = CStr(args(1))

    requestPayload = packetPayload
    If Left$(requestPayload, 2) = "GD" Then requestPayload = Mid$(requestPayload, 3)

    callerUserId = HandlingUserIdFromSocket(socketIndex)
    If Len(callerUserId) = 0 Or callerUserId = "0" Then GoTo CloseFailed
    If Not HandlingUserHasPermission(callerUserId, "fuse_mod") Then GoTo CloseFailed
    If Not HandlingUserHasPermission(callerUserId, "fuse_receive_calls_for_help") Then GoTo CloseFailed

    offset = 1
    closeState = ReadWireLong(requestPayload, offset)
    If closeState < 1 Or closeState > 3 Then GoTo CloseFailed

    callForHelpId = ReadWireLong(requestPayload, offset)
    If callForHelpId <= 0 Then callForHelpId = ReadWireLong(requestPayload, offset)
    If callForHelpId <= 0 Then GoTo CloseFailed

    reporterUserId = CStr(Val(CStr(Proc_5_2_6D4690("SELECT id_user FROM staff_cfh WHERE id='" & CStr(callForHelpId) & "' LIMIT 1", 0, 0))))
    reporterSocketIndex = HandlingSocketFromUserId(reporterUserId)
    If reporterSocketIndex > 0 Then Proc_6_244_801E80 reporterSocketIndex, CStr(Proc_3_0_6D2AF0(closeState, Empty, "H\")), 0

    Proc_5_0_6D3CD0 "UPDATE staff_cfh SET id_closed='" & CStr(closeState) & "',id_tab='0' WHERE id='" & CStr(callForHelpId) & "'", 0, 0

CloseFailed:
    Proc_6_7_6DD0E0 = Empty
End Function

' Original declaration: Private Sub Proc_6_8_6DD790
Public Function Proc_6_8_6DD790(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim requestPayload As String
    Dim callerUserId As String
    Dim whereClause As String
    Dim offset As Long

    On Error GoTo ReleaseFailed

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    If Len(packetPayload) = 0 And UBound(args) >= 1 Then packetPayload = CStr(args(1))

    requestPayload = packetPayload
    If Left$(requestPayload, 2) = "GC" Then requestPayload = Mid$(requestPayload, 3)

    callerUserId = HandlingUserIdFromSocket(socketIndex)
    If Len(callerUserId) = 0 Or callerUserId = "0" Then GoTo ReleaseFailed
    If Not HandlingUserHasPermission(callerUserId, "fuse_mod") Then GoTo ReleaseFailed
    If Not HandlingUserHasPermission(callerUserId, "fuse_receive_calls_for_help") Then GoTo ReleaseFailed

    offset = 1
    whereClause = StaffCallForHelpWhereClause(requestPayload, offset)
    If Len(whereClause) = 0 Then GoTo ReleaseFailed

    Proc_5_0_6D3CD0 "UPDATE staff_cfh SET id_tab='1',id_picker=0,timestamp_picked=NULL WHERE " & whereClause, 0, 0

ReleaseFailed:
    Proc_6_8_6DD790 = Empty
End Function

' Original declaration: Private Sub Proc_6_9_6DDD70
Public Function Proc_6_9_6DDD70(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_9_6DDD70 = Empty
End Function

' Original declaration: Private Sub Proc_6_10_6DE1D0
Public Function Proc_6_10_6DE1D0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_10_6DE1D0 = Empty
End Function

' Original declaration: Private Sub Proc_6_11_6DF4A0
Public Function Proc_6_11_6DF4A0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_11_6DF4A0 = Empty
End Function

' Original declaration: Private Sub Proc_6_12_6DFE90
Public Function Proc_6_12_6DFE90(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_12_6DFE90 = Empty
End Function

' Original declaration: Private Sub Proc_6_13_6E0A80
Public Function Proc_6_13_6E0A80(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_13_6E0A80 = Empty
End Function

' Original declaration: Private Sub Proc_6_14_6E10C0
Public Function Proc_6_14_6E10C0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_14_6E10C0 = Empty
End Function

' Original declaration: Private Sub Proc_6_15_6E1900
Public Function Proc_6_15_6E1900(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_15_6E1900 = Empty
End Function

' Original declaration: Private Sub Proc_6_16_6E2320
Public Function Proc_6_16_6E2320(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_16_6E2320 = Empty
End Function

' Original declaration: Private Sub Proc_6_17_6E48D0
Public Function Proc_6_17_6E48D0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_17_6E48D0 = Empty
End Function

' Original declaration: Private Sub Proc_6_18_6E7480
Public Function Proc_6_18_6E7480(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_18_6E7480 = Empty
End Function

' Original declaration: Private Sub Proc_6_19_6E8040
Public Function Proc_6_19_6E8040(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_19_6E8040 = Empty
End Function

' Original declaration: Private Sub Proc_6_20_6E88E0
Public Function Proc_6_20_6E88E0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_20_6E88E0 = Empty
End Function

' Original declaration: Private Sub Proc_6_21_6E8BA0
Public Function Proc_6_21_6E8BA0(ParamArray args() As Variant) As Variant
    Dim messageText As String
    Dim words() As String
    Dim wordIndex As Long
    Dim candidate As String
    Dim lowered As String
    Dim urlList As String

    On Error GoTo ExtractFailed
    If UBound(args) < 0 Then GoTo ExtractFailed

    messageText = CStr(args(0))
    words = Split(messageText, " ")

    For wordIndex = LBound(words) To UBound(words)
        candidate = Trim$(CStr(words(wordIndex)))
        lowered = LCase$(candidate)
        If Len(candidate) > 0 Then
            If Left$(lowered, 4) = "www." And InStr(5, lowered, ".", vbBinaryCompare) > 0 Then
                urlList = urlList & candidate & ";"
            ElseIf Left$(lowered, 7) = "http://" Then
                urlList = urlList & candidate & ";"
            ElseIf Left$(lowered, 8) = "https://" Then
                urlList = urlList & candidate & ";"
            End If
        End If
    Next wordIndex

    Proc_6_21_6E8BA0 = urlList
    Exit Function

ExtractFailed:
    Proc_6_21_6E8BA0 = vbNullString
End Function

' Original declaration: Private Sub Proc_6_22_6E9300
Public Function Proc_6_22_6E9300(ParamArray args() As Variant) As Variant
    Dim messageText As String
    Dim filteredText As String
    Dim filterEnabled As Boolean
    Dim replacementText As String
    Dim rows() As String
    Dim rowIndex As Long
    Dim blockedWord As String

    On Error GoTo FilterFailed
    If UBound(args) < 0 Then GoTo FilterFailed

    messageText = CStr(args(0))
    filteredText = messageText
    filterEnabled = (CLng(Val(CStr(Proc_10_0_809570("com.client.chat.filter.enabled", 0, 0)))) <> 0)

    If filterEnabled And Len(global_00829290) > 0 Then
        replacementText = CStr(Proc_10_0_809570("com.client.chat.filter.replacement", vbNullString, 0))
        rows = Split(global_00829290, Chr$(13))
        For rowIndex = LBound(rows) To UBound(rows)
            blockedWord = Trim$(Split(CStr(rows(rowIndex)), Chr$(9))(0))
            If Len(blockedWord) > 0 Then
                If Len(blockedWord) > 3 Then
                    If InStr(1, filteredText, blockedWord, vbTextCompare) > 0 Then
                        filteredText = Replace(filteredText, blockedWord, replacementText, 1, -1, vbTextCompare)
                    End If
                ElseIf StrComp(filteredText, blockedWord, vbTextCompare) = 0 Then
                    filteredText = replacementText
                End If
            End If
        Next rowIndex
    End If

    Proc_6_22_6E9300 = filteredText
    Exit Function

FilterFailed:
    Proc_6_22_6E9300 = vbNullString
End Function

' Original declaration: Private Sub Proc_6_23_6E9A90
Public Function Proc_6_23_6E9A90(ParamArray args() As Variant) As Variant
    Dim messageText As String
    Dim gestureEnabled As Boolean
    Dim words() As String
    Dim rows() As String
    Dim fields() As String
    Dim wordIndex As Long
    Dim rowIndex As Long
    Dim token As String
    Dim smiley As String

    On Error GoTo GestureFailed
    If UBound(args) < 0 Then GoTo GestureFailed

    messageText = CStr(args(0))
    gestureEnabled = (CLng(Val(CStr(Proc_10_0_809570("com.client.chat.gesture.enabled", 0, 0)))) <> 0)
    If Not gestureEnabled Or Len(global_00829294) = 0 Then GoTo GestureFailed

    words = Split(messageText, " ")
    rows = Split(global_00829294, Chr$(13))

    For wordIndex = LBound(words) To UBound(words)
        token = Trim$(CStr(words(wordIndex)))
        If Len(token) > 0 Then
            For rowIndex = LBound(rows) To UBound(rows)
                If Len(rows(rowIndex)) > 0 Then
                    fields = Split(CStr(rows(rowIndex)), Chr$(9))
                    If UBound(fields) >= 1 Then
                        smiley = CStr(fields(0))
                        If StrComp(token, smiley, vbTextCompare) = 0 Then
                            Proc_6_23_6E9A90 = CInt(Val(CStr(fields(1))))
                            Exit Function
                        End If
                    End If
                End If
            Next rowIndex
        End If
    Next wordIndex

GestureFailed:
    Proc_6_23_6E9A90 = 0
End Function

' Original declaration: Private  Proc_6_24_6EA010(arg_C) '6EA010
Public Function Proc_6_24_6EA010(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_24_6EA010 = Empty
End Function

' Original declaration: Private  Proc_6_25_6EEAC0(arg_C) '6EEAC0
Public Function Proc_6_25_6EEAC0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_25_6EEAC0 = Empty
End Function

' Original declaration: Private Sub Proc_6_26_7034C0
Public Function Proc_6_26_7034C0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_26_7034C0 = Empty
End Function

' Original declaration: Private Sub Proc_6_27_706920
Public Function Proc_6_27_706920(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_27_706920 = Empty
End Function

' Original declaration: Private Sub Proc_6_28_709DA0
Public Function Proc_6_28_709DA0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_28_709DA0 = Empty
End Function

' Original declaration: Private  Proc_6_29_70D800(arg_C, arg_10, arg_14, arg_18, arg_1C, arg_20, arg_24, arg_28, arg_2C, arg_30, arg_34) '70D800
Public Function Proc_6_29_70D800(ParamArray args() As Variant) As Variant
    Dim baseValue As Long
    Dim firstValue As Long
    Dim secondValue As Long
    Dim thirdValue As Long
    Dim fourthValue As String
    Dim fifthValue As Long
    Dim sixthValue As String
    Dim seventhValue As String
    Dim eighthValue As Long
    Dim ninthValue As String
    Dim tenthValue As Long
    Dim eleventhValue As String
    Dim payload As String

    On Error GoTo BuildFailed
    If UBound(args) < 11 Then GoTo BuildFailed

    baseValue = CLng(Val(CStr(args(0))))
    firstValue = CLng(Val(CStr(args(1))))
    secondValue = CLng(Val(CStr(args(2))))
    thirdValue = CLng(Val(CStr(args(3))))
    fourthValue = CStr(args(4))
    fifthValue = CLng(Val(CStr(args(5))))
    sixthValue = CStr(args(6))
    seventhValue = CStr(args(7))
    eighthValue = CLng(Val(CStr(args(8))))
    ninthValue = CStr(args(9))
    tenthValue = CLng(Val(CStr(args(10))))
    eleventhValue = CStr(args(11))

    payload = CStr(Proc_3_0_6D2AF0(baseValue, Empty, "0"))
    payload = CStr(Proc_3_0_6D2AF0(firstValue, Empty, payload)) & "H"
    payload = "0" & CStr(Proc_3_0_6D2AF0(secondValue, Empty, payload)) & "H"
    payload = CStr(Proc_3_0_6D2AF0(baseValue, Empty, payload))
    payload = CStr(Proc_3_0_6D2AF0(thirdValue, Empty, payload)) & fourthValue & Chr$(2)
    payload = CStr(Proc_3_0_6D2AF0(fifthValue, Empty, payload)) & sixthValue & Chr$(2)
    payload = CStr(Proc_3_0_6D2AF0(eighthValue, Empty, payload)) & ninthValue & Chr$(2) & seventhValue & Chr$(2)
    Proc_6_29_70D800 = CStr(Proc_3_0_6D2AF0(tenthValue, Empty, payload)) & eleventhValue & Chr$(2)
    Exit Function

BuildFailed:
    Proc_6_29_70D800 = vbNullString
End Function

' Original declaration: Private Sub Proc_6_30_70DC90
Public Function Proc_6_30_70DC90(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim userId As String
    Dim cfhId As Long
    Dim queryText As String

    On Error GoTo CancelFailed

    socketIndex = HandlingSocketIndex(args)
    userId = HandlingUserIdFromSocket(socketIndex)
    If Len(userId) = 0 Then GoTo CancelFailed

    queryText = "SELECT id FROM staff_cfh WHERE id_user='" & Proc_10_11_80A9C0(userId, 0, 0) & "' AND id_closed='0' AND timestamp_sent > UNIX_TIMESTAMP()-600 ORDER BY id DESC LIMIT 1"
    cfhId = CLng(Val(CStr(Proc_5_2_6D4690(queryText, 0, 0))))
    If cfhId > 0 Then
        Proc_5_0_6D3CD0 "DELETE FROM staff_cfh WHERE id='" & CStr(cfhId) & "'", 0, 0
        Proc_6_244_801E80 socketIndex, "E@", 0
    End If

CancelFailed:
    Proc_6_30_70DC90 = Empty
End Function

' Original declaration: Private Sub Proc_6_31_70DE80
Public Function Proc_6_31_70DE80(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim userId As String
    Dim rankIndex As Long
    Dim hcLevel As Long
    Dim staffPayload As String
    Dim rowText As String
    Dim rows() As String
    Dim fields() As String
    Dim rowIndex As Long
    Dim queryText As String

    On Error GoTo ListFailed

    socketIndex = HandlingSocketIndex(args)
    userId = HandlingUserIdFromSocket(socketIndex)
    If Len(userId) = 0 Or userId = "0" Then GoTo ListFailed

    rankIndex = HandlingUserRank(userId)
    hcLevel = HandlingUserHcLevel(userId)
    If Not CBool(Proc_10_1_809790(rankIndex, vbNullString, "fuse_mod", hcLevel)) Then GoTo ListFailed

    staffPayload = StaffModerationPayload(rankIndex, hcLevel)
    Proc_6_244_801E80 socketIndex, CStr(Proc_3_0_6D2AF0(0, Empty, "HS")) & CStr(Proc_3_0_6D2AF0(0, Empty, vbNullString)) & staffPayload, 0

    queryText = "SELECT staff_cfh.id,staff_cfh.id_tab,users.id,users.name,staff_cfh.id_partner,staff_cfh.id_room,staff_cfh.id_category,staff_cfh.description,rooms.id,rooms.name,staff_cfh.id_picker FROM staff_cfh,users,rooms WHERE staff_cfh.id_closed!='3' AND staff_cfh.timestamp_sent > UNIX_TIMESTAMP()-43200 AND users.id=staff_cfh.id_user AND users.id_socket IS NOT NULL AND rooms.id=staff_cfh.id_room LIMIT 1000"
    rowText = CStr(Proc_5_2_6D4690(queryText, 0, 0))
    If Len(rowText) > 0 Then
        rows = Split(rowText, Chr$(13))
        For rowIndex = LBound(rows) To UBound(rows)
            If Len(rows(rowIndex)) > 0 Then
                fields = Split(rows(rowIndex), Chr$(9))
                Proc_6_244_801E80 socketIndex, "HR" & CallForHelpRowPayload(fields), 0
            End If
        Next rowIndex
    End If

ListFailed:
    Proc_6_31_70DE80 = Empty
End Function

' Original declaration: Private Sub Proc_6_32_70EAB0
Public Function Proc_6_32_70EAB0(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim requestPayload As String
    Dim descriptionText As String
    Dim categoryId As Long
    Dim partnerUserId As Long
    Dim userId As String
    Dim roomId As Long
    Dim lastClosedState As String
    Dim cfhId As Long
    Dim offset As Long

    On Error GoTo SubmitFailed

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    If Len(packetPayload) >= 3 Then
        requestPayload = Mid$(packetPayload, 3)
    ElseIf UBound(args) >= 1 Then
        requestPayload = CStr(args(1))
    End If

    userId = HandlingUserIdFromSocket(socketIndex)
    If Len(userId) = 0 Or userId = "0" Then GoTo SubmitFailed

    lastClosedState = CStr(Proc_5_2_6D4690("SELECT id_closed FROM staff_cfh WHERE id_user='" & Proc_10_11_80A9C0(userId, 0, 0) & "' AND timestamp_sent > UNIX_TIMESTAMP()-600 ORDER BY id DESC LIMIT 1", 0, 0))
    If Len(lastClosedState) > 0 And CLng(Val(lastClosedState)) = 0 Then GoTo SubmitFailed

    offset = 1
    descriptionText = CStr(Proc_10_10_80A7F0(ReadWireString(requestPayload, offset), 0, 0))
    If Len(descriptionText) < 30 Then GoTo SubmitFailed

    categoryId = ReadWireLong(requestPayload, offset)
    If categoryId <= 0 Then categoryId = ReadWireLong(requestPayload, offset)
    partnerUserId = ReadWireLong(requestPayload, offset)
    If partnerUserId = CLng(Val(userId)) Then partnerUserId = 0

    roomId = HandlingCurrentRoomId(socketIndex, userId)
    If roomId <= 0 Then GoTo SubmitFailed

    Proc_5_0_6D3CD0 "INSERT INTO staff_cfh(id_user,id_room,id_category,id_partner,description,timestamp_sent) VALUES('" & Proc_10_11_80A9C0(userId, 0, 0) & "','" & CStr(roomId) & "','" & CStr(categoryId) & "','" & CStr(partnerUserId) & "','" & Proc_10_11_80A9C0(descriptionText, 0, 0) & "',UNIX_TIMESTAMP())", 0, 0

    cfhId = CLng(Val(CStr(Proc_5_2_6D4690("SELECT MAX(id) FROM staff_cfh", 0, 0))))
    Proc_6_244_801E80 socketIndex, CStr(Proc_3_0_6D2AF0(cfhId, Empty, "EA")), 0

SubmitFailed:
    Proc_6_32_70EAB0 = Empty
End Function

' Original declaration: Private Sub Proc_6_33_70F4F0
Public Function Proc_6_33_70F4F0(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer

    On Error GoTo SendFailed
    socketIndex = HandlingSocketIndex(args)
    Proc_6_244_801E80 socketIndex, "HF" & global_00829204, 0

SendFailed:
    Proc_6_33_70F4F0 = Empty
End Function

' Original declaration: Private Sub Proc_6_34_70F590
Public Function Proc_6_34_70F590(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer

    On Error GoTo SendFailed
    socketIndex = HandlingSocketIndex(args)
    Proc_6_244_801E80 socketIndex, "HG" & global_00829208, 0

SendFailed:
    Proc_6_34_70F590 = Empty
End Function

' Original declaration: Private Sub Proc_6_35_70F630
Public Function Proc_6_35_70F630(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim categoryId As Long
    Dim categoryPayload As String
    Dim responsePayload As String

    On Error GoTo SendFailed

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    If Len(packetPayload) >= 3 Then
        categoryId = CLng(Val(CStr(Proc_3_3_6D3240(Mid$(packetPayload, 3), 0, 0))))
    End If

    If IsArray(global_0082920C) Then
        If categoryId >= LBound(global_0082920C) And categoryId <= UBound(global_0082920C) Then
            categoryPayload = CStr(global_0082920C(categoryId))
        End If
    End If

    responsePayload = CStr(Proc_3_0_6D2AF0(categoryId, Empty, "HJ")) & Chr$(2) & categoryPayload
    Proc_6_244_801E80 socketIndex, responsePayload, 0

SendFailed:
    Proc_6_35_70F630 = Empty
End Function

' Original declaration: Private Sub Proc_6_36_70F7B0
Public Function Proc_6_36_70F7B0(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim searchText As String
    Dim rows() As String
    Dim fields() As String
    Dim rowIndex As Long
    Dim resultCount As Long
    Dim resultPayload As String
    Dim responsePayload As String

    On Error GoTo SearchFailed

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    If Len(packetPayload) >= 3 Then
        searchText = CStr(Proc_10_7_80A190(Mid$(packetPayload, 3), 0, 0))
        searchText = CStr(Proc_10_11_80A9C0(searchText, 0, 0))
    End If

    If Len(searchText) < 3 Then
        Proc_6_243_7FFEB0 socketIndex, 0, 0
        GoTo SearchDone
    End If

    rows = Split(CStr(Proc_5_2_6D4690("SELECT id,name FROM faq WHERE name LIKE '" & Chr$(37) & searchText & Chr$(37) & "' LIMIT 25", 0, 0)), Chr$(13))
    For rowIndex = LBound(rows) To UBound(rows)
        If Len(rows(rowIndex)) > 0 Then
            fields = Split(rows(rowIndex), Chr$(9))
            If UBound(fields) >= 1 Then
                resultPayload = CStr(Proc_3_0_6D2AF0(CLng(Val(CStr(fields(0)))), Empty, resultPayload)) & CStr(fields(1)) & Chr$(2)
                resultCount = resultCount + 1
            End If
        End If
    Next rowIndex

    responsePayload = CStr(Proc_3_0_6D2AF0(resultCount, Empty, "HI")) & resultPayload
    Proc_6_244_801E80 socketIndex, responsePayload, 0

SearchDone:

SearchFailed:
    Proc_6_36_70F7B0 = Empty
End Function

' Original declaration: Private Sub Proc_6_37_70FC20
Public Function Proc_6_37_70FC20(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim faqId As Long
    Dim faqPayload As String

    On Error GoTo SendFailed

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    If Len(packetPayload) >= 3 Then
        faqId = CLng(Val(CStr(Proc_10_6_809F10(Mid$(packetPayload, 3), 0, 0))))
        If faqId = 0 Then faqId = CLng(Val(CStr(Proc_3_3_6D3240(Mid$(packetPayload, 3), 0, 0))))
    End If

    If IsArray(global_00829210) Then
        If faqId >= LBound(global_00829210) And faqId <= UBound(global_00829210) Then
            faqPayload = CStr(global_00829210(faqId))
        End If
    End If

    Proc_6_244_801E80 socketIndex, "HH" & faqPayload, 0

SendFailed:
    Proc_6_37_70FC20 = Empty
End Function

' Original declaration: Private Sub Proc_6_38_70FD10
Public Function Proc_6_38_70FD10(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_38_70FD10 = Empty
End Function

' Original declaration: Private Sub Proc_6_39_711650
Public Function Proc_6_39_711650(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_39_711650 = Empty
End Function

' Original declaration: Private  Proc_6_40_711770(arg_C, arg_10) '711770
Public Function Proc_6_40_711770(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_40_711770 = Empty
End Function

' Original declaration: Private  Proc_6_41_712730(arg_C) '712730
Public Function Proc_6_41_712730(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_41_712730 = Empty
End Function

' Original declaration: Private  Proc_6_42_712FB0(arg_C) '712FB0
Public Function Proc_6_42_712FB0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_42_712FB0 = Empty
End Function

' Original declaration: Private Sub Proc_6_43_713680
Public Function Proc_6_43_713680(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_43_713680 = Empty
End Function

' Original declaration: Private Sub Proc_6_44_7145E0
Public Function Proc_6_44_7145E0(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim userId As String
    Dim roomId As Long
    Dim iconPayload As String
    Dim queryTail As String

    On Error GoTo IconFailed

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 2 Then
        packetPayload = CStr(args(2))
    ElseIf UBound(args) >= 1 Then
        packetPayload = CStr(args(1))
    End If
    If Left$(packetPayload, 2) = "FB" Then packetPayload = Mid$(packetPayload, 3)

    userId = HandlingUserIdFromSocket(socketIndex)
    If Len(userId) = 0 Or userId = "0" Then GoTo IconFailed

    roomId = HandlingCurrentRoomId(socketIndex, userId)
    If roomId <= 0 Then GoTo IconFailed

    iconPayload = RoomIconPayloadFromWire(packetPayload)
    If Len(iconPayload) = 0 Then GoTo IconFailed

    Proc_5_0_6D3CD0 "UPDATE rooms SET icon='" & Proc_10_11_80A9C0(iconPayload, 0, 0) & "' WHERE id='" & CStr(roomId) & "'", 0, 0
    queryTail = "users,rooms,rooms_categories WHERE rooms.id='" & CStr(roomId) & "' AND users.id=rooms.id_owner AND rooms_categories.id=rooms.id_category LIMIT 1"
    Proc_6_247_8027E0 socketIndex, CStr(Proc_6_112_74E0C0(socketIndex, queryTail, "GF")), 0
    Proc_6_244_801E80 socketIndex, CStr(Proc_3_0_6D2AF0(roomId, Empty, "GI")) & Chr$(2), 0
    Proc_6_244_801E80 socketIndex, CStr(Proc_3_0_6D2AF0(roomId, Empty, "GH")), 0

IconFailed:
    Proc_6_44_7145E0 = Empty
End Function

' Original declaration: Private Sub Proc_6_45_714B60
Public Function Proc_6_45_714B60(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim userId As String
    Dim roomId As Long

    On Error GoTo DeleteFailed

    socketIndex = HandlingSocketIndex(args)
    userId = HandlingUserIdFromSocket(socketIndex)
    If Len(userId) = 0 Or userId = "0" Then GoTo DeleteFailed

    roomId = HandlingCurrentRoomId(socketIndex, userId)
    If roomId <= 0 Then GoTo DeleteFailed

    Proc_5_0_6D3CD0 "DELETE FROM rooms_events WHERE id_room='" & CStr(roomId) & "'", 0, 0
    Proc_6_244_801E80 socketIndex, "Er-1" & Chr$(2), 0

DeleteFailed:
    Proc_6_45_714B60 = Empty
End Function

' Original declaration: Private Sub Proc_6_46_714D50
Public Function Proc_6_46_714D50(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim userId As String
    Dim roomId As Long
    Dim doorStatus As Long

    On Error GoTo RoomDoorFailed

    socketIndex = HandlingSocketIndex(args)
    userId = HandlingUserIdFromSocket(socketIndex)
    If Len(userId) = 0 Or userId = "0" Then GoTo RoomDoorFailed

    roomId = HandlingCurrentRoomId(socketIndex, userId)
    If roomId <= 0 Then GoTo RoomDoorFailed

    doorStatus = CLng(Val(CStr(Proc_5_2_6D4690("SELECT status_door FROM rooms WHERE id='" & CStr(roomId) & "' LIMIT 1", 0, 0))))
    If doorStatus <> 0 Then
        Proc_6_244_801E80 socketIndex, "EoHK", 0
    Else
        Proc_6_244_801E80 socketIndex, "EoIH", 0
    End If

RoomDoorFailed:
    Proc_6_46_714D50 = Empty
End Function

' Original declaration: Private Sub Proc_6_47_714F60
Public Function Proc_6_47_714F60(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim roomId As Long
    Dim userId As String

    On Error GoTo HomeRoomFailed

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 2 Then
        packetPayload = CStr(args(2))
    ElseIf UBound(args) >= 1 Then
        packetPayload = CStr(args(1))
    End If

    If Len(packetPayload) > 2 Then packetPayload = Mid$(packetPayload, 3)
    roomId = CLng(Val(CStr(Proc_3_3_6D3240(packetPayload, 0, 0))))
    If roomId <= 0 Then GoTo HomeRoomFailed

    userId = HandlingUserIdFromSocket(socketIndex)
    If Len(userId) = 0 Or userId = "0" Then GoTo HomeRoomFailed

    Proc_5_0_6D3CD0 "UPDATE users SET homeroom='" & CStr(roomId) & "' WHERE id='" & Proc_10_11_80A9C0(userId, 0, 0) & "'", 0, 0
    Proc_6_244_801E80 socketIndex, CStr(Proc_3_0_6D2AF0(roomId, Empty, "GG")), 0

HomeRoomFailed:
    Proc_6_47_714F60 = Empty
End Function

' Original declaration: Private Sub Proc_6_48_7151E0
Public Function Proc_6_48_7151E0(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim userId As String
    Dim roomId As Long
    Dim doorStatus As Long
    Dim categoryId As Long
    Dim categoryName As String
    Dim eventName As String
    Dim eventDescription As String
    Dim tagOne As String
    Dim tagTwo As String
    Dim queryText As String

    On Error GoTo CreateFailed

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 2 Then
        packetPayload = CStr(args(2))
    ElseIf UBound(args) >= 1 Then
        packetPayload = CStr(args(1))
    End If
    If Left$(packetPayload, 2) = "EZ" Then packetPayload = Mid$(packetPayload, 3)

    userId = HandlingUserIdFromSocket(socketIndex)
    If Len(userId) = 0 Or userId = "0" Then GoTo CreateFailed

    roomId = HandlingCurrentRoomId(socketIndex, userId)
    If roomId <= 0 Then GoTo CreateFailed

    doorStatus = CLng(Val(CStr(Proc_5_2_6D4690("SELECT status_door FROM rooms WHERE id='" & CStr(roomId) & "' LIMIT 1", 0, 0))))
    If doorStatus <> 0 Then
        Proc_6_244_801E80 socketIndex, "EoHK", 0
        GoTo CreateFailed
    End If

    If Not RoomEventCreatePayloadFromWire(packetPayload, categoryId, categoryName, eventName, eventDescription, tagOne, tagTwo) Then GoTo CreateFailed

    queryText = "INSERT INTO rooms_events(id_room,id_user,name,description,id_category,tag_1,tag_2,timestamp,name_category) VALUES('"
    queryText = queryText & CStr(roomId) & "','" & Proc_10_11_80A9C0(userId, 0, 0) & "','"
    queryText = queryText & Proc_10_11_80A9C0(eventName, 0, 0) & "','"
    queryText = queryText & Proc_10_11_80A9C0(eventDescription, 0, 0) & "','"
    queryText = queryText & CStr(categoryId) & "',"
    queryText = queryText & NullableSqlText(tagOne) & "," & NullableSqlText(tagTwo)
    queryText = queryText & ",UNIX_TIMESTAMP(),'" & Proc_10_11_80A9C0(categoryName, 0, 0) & "')"

    Proc_5_0_6D3CD0 queryText, 0, 0
    Proc_6_247_8027E0 socketIndex, "Er" & CStr(Proc_6_51_716AC0(roomId)), 0

CreateFailed:
    Proc_6_48_7151E0 = Empty
End Function

' Original declaration: Private Sub Proc_6_49_715D30
Public Function Proc_6_49_715D30(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim userId As String
    Dim roomId As Long
    Dim eventName As String
    Dim eventDescription As String
    Dim tagOne As String
    Dim tagTwo As String
    Dim queryText As String

    On Error GoTo EditFailed

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 2 Then
        packetPayload = CStr(args(2))
    ElseIf UBound(args) >= 1 Then
        packetPayload = CStr(args(1))
    End If
    If Left$(packetPayload, 2) = "E\" Then packetPayload = Mid$(packetPayload, 3)

    userId = HandlingUserIdFromSocket(socketIndex)
    If Len(userId) = 0 Or userId = "0" Then GoTo EditFailed

    roomId = HandlingCurrentRoomId(socketIndex, userId)
    If roomId <= 0 Then GoTo EditFailed

    If Not RoomEventEditPayloadFromWire(packetPayload, eventName, eventDescription, tagOne, tagTwo) Then GoTo EditFailed

    queryText = "UPDATE rooms_events SET id_user='" & Proc_10_11_80A9C0(userId, 0, 0) & "',name='"
    queryText = queryText & Proc_10_11_80A9C0(eventName, 0, 0) & "',description='"
    queryText = queryText & Proc_10_11_80A9C0(eventDescription, 0, 0) & "'"
    queryText = queryText & ",tag_1=" & NullableSqlText(tagOne)
    queryText = queryText & ",tag_2=" & NullableSqlText(tagTwo)
    queryText = queryText & " WHERE id_room='" & CStr(roomId) & "'"

    Proc_5_0_6D3CD0 queryText, 0, 0
    Proc_6_247_8027E0 socketIndex, "Er" & CStr(Proc_6_51_716AC0(roomId)), 0

EditFailed:
    Proc_6_49_715D30 = Empty
End Function

' Original declaration: Private Sub Proc_6_50_7166B0
Public Function Proc_6_50_7166B0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_50_7166B0 = Empty
End Function

' Original declaration: Private Sub Proc_6_51_716AC0
Public Function Proc_6_51_716AC0(ParamArray args() As Variant) As Variant
    Dim roomId As Long
    Dim rowText As String
    Dim fields() As String
    Dim timeFormat As String
    Dim payload As String
    Dim fieldIndex As Long

    On Error GoTo BuildFailed
    If UBound(args) < 0 Then GoTo BuildFailed

    roomId = CLng(Val(CStr(args(0))))
    If roomId <= 0 Then GoTo BuildFailed

    timeFormat = CStr(Proc_10_0_809570("com.mysql.format.time", "%H:%i", 0))
    rowText = CStr(Proc_5_2_6D4690("SELECT users.id,users.name,rooms_events.id_room,rooms_events.id_category,rooms_events.name,rooms_events.description,DATE_FORMAT(FROM_UNIXTIME(rooms_events.timestamp), '" & timeFormat & "'),rooms_events.tag_1,rooms_events.tag_2 FROM rooms_events,users WHERE rooms_events.id_room='" & CStr(roomId) & "' AND users.id=rooms_events.id_user LIMIT 1", 0, 0))

    If Len(rowText) = 0 Then
        Proc_6_51_716AC0 = "-1" & Chr$(2)
        Exit Function
    End If

    fields = Split(rowText, Chr$(9))
    If UBound(fields) < 8 Then GoTo BuildFailed

    For fieldIndex = 4 To 8
        payload = payload & CStr(fields(fieldIndex)) & Chr$(2)
    Next fieldIndex

    payload = CStr(Proc_3_0_6D2AF0(CLng(Val(CStr(fields(0)))), Empty, payload))
    payload = CStr(Proc_3_0_6D2AF0(CLng(Val(CStr(fields(2)))), Empty, payload))
    payload = CStr(Proc_3_0_6D2AF0(CLng(Val(CStr(fields(3)))), Empty, payload))
    Proc_6_51_716AC0 = payload
    Exit Function

BuildFailed:
    Proc_6_51_716AC0 = "-1" & Chr$(2)
End Function

' Original declaration: Private Sub Proc_6_52_7172B0
Public Function Proc_6_52_7172B0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_52_7172B0 = Empty
End Function

' Original declaration: Private Sub Proc_6_53_718E00
Public Function Proc_6_53_718E00(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer

    On Error GoTo ReadyFailed

    socketIndex = HandlingSocketIndex(args)
    If socketIndex <= 0 Then GoTo ReadyFailed

    Proc_6_244_801E80 socketIndex, "@R", 0
    Proc_6_165_7BE0B0 socketIndex, 0, 0

ReadyFailed:
    Proc_6_53_718E00 = Empty
End Function

' Original declaration: Private  Proc_6_54_719050(arg_C, arg_10) '719050
Public Function Proc_6_54_719050(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_54_719050 = Empty
End Function

' Original declaration: Private Sub Proc_6_55_71A6E0
Public Function Proc_6_55_71A6E0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_55_71A6E0 = Empty
End Function

' Original declaration: Private  Proc_6_56_71E730(arg_10) '71E730
Public Function Proc_6_56_71E730(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim roomMode As Long

    On Error GoTo BootstrapFailed

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 1 Then roomMode = CLng(Val(CStr(args(1))))

    Proc_6_244_801E80 socketIndex, "@S", 0
    Proc_6_244_801E80 socketIndex, "Bf" & "/client.php" & Chr$(2), 0
    If roomMode = 0 Then
        Proc_6_244_801E80 socketIndex, "@i", 0
    Else
        Proc_6_79_72A430 socketIndex, "@{", 0
    End If

BootstrapFailed:
    Proc_6_56_71E730 = Empty
End Function

' Original declaration: Private  Proc_6_57_71E8F0(arg_C, arg_10) '71E8F0
Public Function Proc_6_57_71E8F0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_57_71E8F0 = Empty
End Function

' Original declaration: Private Sub Proc_6_58_71FCA0
Public Function Proc_6_58_71FCA0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_58_71FCA0 = Empty
End Function

' Original declaration: Private Sub Proc_6_59_71FEE0
Public Function Proc_6_59_71FEE0(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim advertisementIndex As Long
    Dim advertisementPayload As String

    On Error GoTo SendFailed

    socketIndex = HandlingSocketIndex(args)
    advertisementPayload = Chr$(2) & Chr$(2)

    If global_008291D8 > 0 And IsArray(global_008291D4) Then
        advertisementIndex = CLng(Val(CStr(Proc_10_3_809B90(global_008291D8, 1, 0))))
        If advertisementIndex >= LBound(global_008291D4) And advertisementIndex <= UBound(global_008291D4) Then
            If Len(CStr(global_008291D4(advertisementIndex))) > 0 Then
                advertisementPayload = CStr(global_008291D4(advertisementIndex))
            End If
        End If
    End If

    Proc_6_244_801E80 socketIndex, "DB" & advertisementPayload, 0

SendFailed:
    Proc_6_59_71FEE0 = Empty
End Function

' Original declaration: Private Sub Proc_6_60_720060
Public Function Proc_6_60_720060(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim requestPayload As String
    Dim offset As Long
    Dim requestMode As Long
    Dim detailFlag As Long
    Dim roomId As Long
    Dim queryTail As String
    Dim roomPayload As String

    On Error GoTo SendFailed

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    If Len(packetPayload) = 0 And UBound(args) >= 1 Then packetPayload = CStr(args(1))

    requestPayload = packetPayload
    If Left$(requestPayload, 2) = "FA" Then requestPayload = Mid$(requestPayload, 3)

    offset = 1
    requestMode = ReadWireLong(requestPayload, offset)
    detailFlag = ReadWireLong(requestPayload, offset)

    If detailFlag = 1 Then
        roomId = ReadWireLong(requestPayload, offset)
        If roomId <= 0 Then GoTo SendFailed

        queryTail = "users,rooms,rooms_categories WHERE rooms.id='" & CStr(roomId) & "' AND users.id=rooms.id_owner AND rooms_categories.id=rooms.id_category LIMIT 1"
        roomPayload = SingleNavigatorRoomPayload(queryTail)
        Proc_6_244_801E80 socketIndex, CStr(Proc_3_0_6D2AF0(0, Empty, "GF")) & roomPayload, 0
    ElseIf requestMode > 0 Then
        ' The original fallback reads the current room id from global_0082934C session offsets B4/BE/70.
        ' Leave it deferred until those fields are represented instead of guessing their layout.
    End If

SendFailed:
    Proc_6_60_720060 = Empty
End Function

' Original declaration: Private Sub Proc_6_61_720490
Public Function Proc_6_61_720490(ParamArray args() As Variant) As Variant
    Proc_6_61_720490 = RoomKickOrBanUser(args, False)
End Function

' Original declaration: Private Sub Proc_6_62_7209F0
Public Function Proc_6_62_7209F0(ParamArray args() As Variant) As Variant
    Proc_6_62_7209F0 = RoomKickOrBanUser(args, True)
End Function

' Original declaration: Private Sub Proc_6_63_721050
Public Function Proc_6_63_721050(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim requestPayload As String
    Dim userId As String
    Dim roomId As Long
    Dim voteValue As Long
    Dim existingVoteUserId As String
    Dim roomRate As Long
    Dim offset As Long

    On Error GoTo RateFailed

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    If Len(packetPayload) = 0 And UBound(args) >= 1 Then packetPayload = CStr(args(1))

    requestPayload = packetPayload
    If Left$(requestPayload, 2) = "DE" Then requestPayload = Mid$(requestPayload, 3)

    offset = 1
    voteValue = ReadWireLong(requestPayload, offset)
    If voteValue <> 1 Then GoTo RateFailed

    userId = HandlingUserIdFromSocket(socketIndex)
    If Len(userId) = 0 Or userId = "0" Then GoTo RateFailed

    roomId = HandlingCurrentRoomId(socketIndex, userId)
    If roomId <= 0 Then GoTo RateFailed

    existingVoteUserId = CStr(Proc_5_2_6D4690("SELECT id_user FROM rooms_rates WHERE id_user='" & Proc_10_11_80A9C0(userId, 0, 0) & "' AND id_room='" & CStr(roomId) & "' LIMIT 1", 0, 0))
    If Len(existingVoteUserId) > 0 Then GoTo RateFailed

    Proc_5_0_6D3CD0 "INSERT INTO rooms_rates(id_user,id_room,timestamp) VALUES('" & Proc_10_11_80A9C0(userId, 0, 0) & "','" & CStr(roomId) & "',UNIX_TIMESTAMP())", 0, 0

    roomRate = CLng(Val(CStr(Proc_5_2_6D4690("SELECT rate FROM rooms WHERE id='" & CStr(roomId) & "' LIMIT 1", 0, 0))))
    If roomRate < 0 Then roomRate = 0
    roomRate = roomRate + 1
    Proc_5_0_6D3CD0 "UPDATE rooms SET rate='" & CStr(roomRate) & "' WHERE id='" & CStr(roomId) & "'", 0, 0
    Proc_6_244_801E80 socketIndex, CStr(Proc_3_0_6D2AF0(roomRate, Empty, "EY")), 0

RateFailed:
    Proc_6_63_721050 = Empty
End Function

' Original declaration: Private Sub Proc_6_64_721650
Public Function Proc_6_64_721650(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim requestPayload As String
    Dim callerUserId As String
    Dim targetName As String
    Dim targetUserId As String
    Dim roomId As Long
    Dim offset As Long

    On Error GoTo RevokeFailed

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    If Len(packetPayload) = 0 And UBound(args) >= 1 Then packetPayload = CStr(args(1))

    requestPayload = packetPayload
    If Left$(requestPayload, 2) = "D" & Chr$(127) Then requestPayload = Mid$(requestPayload, 3)

    offset = 1
    targetName = CStr(Proc_10_11_80A9C0(ReadWireString(requestPayload, offset), 0, 0))
    If Len(targetName) = 0 Then GoTo RevokeFailed

    callerUserId = HandlingUserIdFromSocket(socketIndex)
    If Len(callerUserId) = 0 Or callerUserId = "0" Then GoTo RevokeFailed

    roomId = HandlingCurrentRoomId(socketIndex, callerUserId)
    If roomId <= 0 Then GoTo RevokeFailed
    If Not HandlingUserHasRoomRight(callerUserId, roomId) Then GoTo RevokeFailed

    targetUserId = CStr(Val(CStr(Proc_5_2_6D4690("SELECT id FROM users WHERE name='" & targetName & "' LIMIT 1", 0, 0))))
    If Len(targetUserId) = 0 Or targetUserId = "0" Then GoTo RevokeFailed

    Proc_5_0_6D3CD0 "DELETE FROM rooms_rights WHERE id_user='" & Proc_10_11_80A9C0(targetUserId, 0, 0) & "' AND id_room='" & CStr(roomId) & "'", 0, 0
    Proc_6_244_801E80 socketIndex, CStr(Proc_3_0_6D2AF0(0, Empty, "Fc")), 0

RevokeFailed:
    Proc_6_64_721650 = Empty
End Function

' Original declaration: Private Sub Proc_6_65_721A10
Public Function Proc_6_65_721A10(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim requestPayload As String
    Dim callerUserId As String
    Dim targetUserId As String
    Dim roomId As Long
    Dim targetSocketIndex As Integer
    Dim offset As Long

    On Error GoTo GrantFailed

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    If Len(packetPayload) = 0 And UBound(args) >= 1 Then packetPayload = CStr(args(1))

    requestPayload = packetPayload
    If Left$(requestPayload, 2) = "A`" Then requestPayload = Mid$(requestPayload, 3)

    offset = 1
    targetUserId = CStr(ReadWireLong(requestPayload, offset))
    If Len(targetUserId) = 0 Or targetUserId = "0" Then GoTo GrantFailed

    callerUserId = HandlingUserIdFromSocket(socketIndex)
    If Len(callerUserId) = 0 Or callerUserId = "0" Then GoTo GrantFailed

    roomId = HandlingCurrentRoomId(socketIndex, callerUserId)
    If roomId <= 0 Then GoTo GrantFailed
    If Not HandlingUserHasRoomRight(callerUserId, roomId) Then GoTo GrantFailed

    targetSocketIndex = HandlingSocketFromUserId(targetUserId)
    If targetSocketIndex <= 0 Then GoTo GrantFailed

    Proc_5_0_6D3CD0 "INSERT IGNORE INTO rooms_rights(id_user,id_room) VALUES('" & Proc_10_11_80A9C0(targetUserId, 0, 0) & "','" & CStr(roomId) & "')", 0, 0
    Proc_6_244_801E80 targetSocketIndex, "@j", 0

GrantFailed:
    Proc_6_65_721A10 = Empty
End Function

' Original declaration: Private Sub Proc_6_66_721D60
Public Function Proc_6_66_721D60(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_66_721D60 = Empty
End Function

' Original declaration: Private Sub Proc_6_67_722940
Public Function Proc_6_67_722940(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_67_722940 = Empty
End Function

' Original declaration: Private Sub Proc_6_68_723170
Public Function Proc_6_68_723170(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_68_723170 = Empty
End Function

' Original declaration: Private Sub Proc_6_69_723630
Public Function Proc_6_69_723630(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_69_723630 = Empty
End Function

' Original declaration: Private Sub Proc_6_70_724190
Public Function Proc_6_70_724190(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_70_724190 = Empty
End Function

' Original declaration: Private Sub Proc_6_71_724CF0
Public Function Proc_6_71_724CF0(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim callerUserId As String
    Dim roomId As Long
    Dim socketRows As String
    Dim socketValues() As String
    Dim socketIndexText As Variant
    Dim targetSocketIndex As Integer

    On Error GoTo ClearFailed

    socketIndex = HandlingSocketIndex(args)
    callerUserId = HandlingUserIdFromSocket(socketIndex)
    If Len(callerUserId) = 0 Or callerUserId = "0" Then GoTo ClearFailed

    roomId = HandlingCurrentRoomId(socketIndex, callerUserId)
    If roomId <= 0 Then GoTo ClearFailed
    If Not HandlingUserOwnsRoom(callerUserId, roomId) Then GoTo ClearFailed

    socketRows = CStr(Proc_5_2_6D4690("SELECT users.id_socket FROM rooms_rights,users WHERE rooms_rights.id_room='" & CStr(roomId) & "' AND users.id=rooms_rights.id_user AND users.id_socket IS NOT NULL", 0, 0))
    Proc_5_0_6D3CD0 "DELETE FROM rooms_rights WHERE id_room='" & CStr(roomId) & "'", 0, 0

    If Len(socketRows) > 0 Then
        socketValues = Split(socketRows, Chr$(13))
        For Each socketIndexText In socketValues
            targetSocketIndex = CInt(Val(CStr(socketIndexText)))
            If targetSocketIndex > 0 Then Proc_6_244_801E80 targetSocketIndex, "@k", 0
        Next socketIndexText
    End If

ClearFailed:
    Proc_6_71_724CF0 = Empty
End Function

' Original declaration: Private Sub Proc_6_72_7250D0
Public Function Proc_6_72_7250D0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_72_7250D0 = Empty
End Function

' Original declaration: Private Sub Proc_6_73_725540
Public Function Proc_6_73_725540(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_73_725540 = Empty
End Function

' Original declaration: Private Sub Proc_6_74_7265B0
Public Function Proc_6_74_7265B0(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim requestPayload As String
    Dim callerUserId As String
    Dim targetUserId As String
    Dim roomId As Long
    Dim targetSocketIndex As Integer
    Dim offset As Long
    Dim revokeCount As Long
    Dim revokeIndex As Long

    On Error GoTo RevokeFailed

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    If Len(packetPayload) = 0 And UBound(args) >= 1 Then packetPayload = CStr(args(1))

    requestPayload = packetPayload
    If Left$(requestPayload, 2) = "Aa" Then requestPayload = Mid$(requestPayload, 3)

    callerUserId = HandlingUserIdFromSocket(socketIndex)
    If Len(callerUserId) = 0 Or callerUserId = "0" Then GoTo RevokeFailed

    roomId = HandlingCurrentRoomId(socketIndex, callerUserId)
    If roomId <= 0 Then GoTo RevokeFailed
    If Not HandlingUserHasRoomRight(callerUserId, roomId) Then GoTo RevokeFailed

    offset = 1
    revokeCount = ReadWireLong(requestPayload, offset)
    If revokeCount < 1 Or revokeCount > 150 Then GoTo RevokeFailed

    For revokeIndex = 1 To revokeCount
        targetUserId = CStr(ReadWireLong(requestPayload, offset))
        If Len(targetUserId) > 0 And targetUserId <> "0" Then
            Proc_5_0_6D3CD0 "DELETE FROM rooms_rights WHERE id_user='" & Proc_10_11_80A9C0(targetUserId, 0, 0) & "' AND id_room='" & CStr(roomId) & "'", 0, 0

            targetSocketIndex = HandlingSocketFromUserId(targetUserId)
            If targetSocketIndex > 0 Then
                Proc_6_244_801E80 targetSocketIndex, "@k", 0
            End If
        End If
    Next revokeIndex

RevokeFailed:
    Proc_6_74_7265B0 = Empty
End Function

' Original declaration: Private Sub Proc_6_75_7269D0
Public Function Proc_6_75_7269D0(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim requestPayload As String
    Dim callerUserId As String
    Dim targetName As String
    Dim targetUserId As String
    Dim roomId As Long
    Dim offset As Long

    On Error GoTo RevokeFailed

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    If Len(packetPayload) = 0 And UBound(args) >= 1 Then packetPayload = CStr(args(1))

    requestPayload = packetPayload
    If Left$(requestPayload, 2) = "EB" Then requestPayload = Mid$(requestPayload, 3)

    offset = 1
    targetName = CStr(Proc_10_11_80A9C0(ReadWireString(requestPayload, offset), 0, 0))
    If Len(targetName) = 0 Then GoTo RevokeFailed

    callerUserId = HandlingUserIdFromSocket(socketIndex)
    If Len(callerUserId) = 0 Or callerUserId = "0" Then GoTo RevokeFailed

    roomId = HandlingCurrentRoomId(socketIndex, callerUserId)
    If roomId <= 0 Then GoTo RevokeFailed
    If Not HandlingUserHasRoomRight(callerUserId, roomId) Then GoTo RevokeFailed

    targetUserId = CStr(Val(CStr(Proc_5_2_6D4690("SELECT id FROM users WHERE name='" & targetName & "' LIMIT 1", 0, 0))))
    If Len(targetUserId) = 0 Or targetUserId = "0" Then GoTo RevokeFailed

    Proc_5_0_6D3CD0 "DELETE FROM rooms_rights WHERE id_user='" & Proc_10_11_80A9C0(targetUserId, 0, 0) & "' AND id_room='" & CStr(roomId) & "'", 0, 0
    Proc_6_244_801E80 socketIndex, CStr(Proc_3_0_6D2AF0(0, Empty, "Fc")), 0

RevokeFailed:
    Proc_6_75_7269D0 = Empty
End Function

' Original declaration: Private Sub Proc_6_76_726CE0
Public Function Proc_6_76_726CE0(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim requestPayload As String
    Dim giverUserId As String
    Dim targetUserId As String
    Dim targetSocketIndex As Integer
    Dim respectAmount As Long
    Dim respectReceived As Long
    Dim offset As Long

    On Error GoTo RespectFailed

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    If Len(packetPayload) = 0 And UBound(args) >= 1 Then packetPayload = CStr(args(1))

    requestPayload = packetPayload
    If Left$(requestPayload, 2) = "Es" Then requestPayload = Mid$(requestPayload, 3)

    offset = 1
    targetUserId = CStr(ReadWireLong(requestPayload, offset))
    If Len(targetUserId) = 0 Or targetUserId = "0" Then GoTo RespectFailed

    giverUserId = HandlingUserIdFromSocket(socketIndex)
    If Len(giverUserId) = 0 Or giverUserId = "0" Then GoTo RespectFailed
    If giverUserId = targetUserId Then GoTo RespectFailed

    targetSocketIndex = HandlingSocketFromUserId(targetUserId)
    If targetSocketIndex <= 0 Then GoTo RespectFailed

    respectAmount = CLng(Val(CStr(Proc_5_2_6D4690("SELECT respect_amount FROM users WHERE id='" & Proc_10_11_80A9C0(giverUserId, 0, 0) & "' LIMIT 1", 0, 0))))
    If respectAmount <= 0 Then GoTo RespectFailed

    Proc_5_0_6D3CD0 "UPDATE users SET respect_amount=respect_amount-1,respect_given=respect_given+1 WHERE id='" & Proc_10_11_80A9C0(giverUserId, 0, 0) & "'", 0, 0
    Proc_5_0_6D3CD0 "UPDATE users SET respect_received=respect_received+1 WHERE id='" & Proc_10_11_80A9C0(targetUserId, 0, 0) & "'", 0, 0

    respectReceived = CLng(Val(CStr(Proc_5_2_6D4690("SELECT respect_received FROM users WHERE id='" & Proc_10_11_80A9C0(targetUserId, 0, 0) & "' LIMIT 1", 0, 0))))
    Proc_6_247_8027E0 socketIndex, CStr(Proc_3_0_6D2AF0(targetUserId, Empty, "Fx")) & CStr(Proc_3_0_6D2AF0(respectReceived, Empty, vbNullString)), 0

RespectFailed:
    Proc_6_76_726CE0 = Empty
End Function

' Original declaration: Private Sub Proc_6_77_727590
Public Function Proc_6_77_727590(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim requestPayload As String
    Dim roomId As Long
    Dim rowText As String
    Dim fields() As String
    Dim requiredFiles As String
    Dim roomCaption As String
    Dim payload As String
    Dim offset As Long

    On Error GoTo SendFailed

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    If Len(packetPayload) = 0 And UBound(args) >= 1 Then packetPayload = CStr(args(1))

    requestPayload = packetPayload
    If Left$(requestPayload, 2) = "FD" Then requestPayload = Mid$(requestPayload, 3)

    offset = 1
    roomId = ReadWireLong(requestPayload, offset)
    If roomId <= 0 Then GoTo SendFailed

    rowText = CStr(Proc_5_2_6D4690("SELECT rooms.id,rooms_official.id,models.required_files,rooms_official.caption FROM rooms_official,rooms,models WHERE rooms.id='" & CStr(roomId) & "' AND rooms_official.id_room=rooms.id AND models.id=rooms.id_model AND models.type='1' LIMIT 1", 0, 0))
    If Len(rowText) = 0 Then GoTo SendFailed

    fields = Split(rowText, Chr$(9))
    requiredFiles = HandlingField(fields, 2)
    roomCaption = HandlingField(fields, 3)

    payload = CStr(Proc_3_0_6D2AF0(roomId, Empty, "GE"))
    payload = payload & requiredFiles & Chr$(2)
    payload = CStr(Proc_3_0_6D2AF0(roomId, Empty, payload))
    payload = payload & roomCaption & Chr$(2)
    Proc_6_244_801E80 socketIndex, payload, 0

SendFailed:
    Proc_6_77_727590 = Empty
End Function

' Original declaration: Private Sub Proc_6_78_7279A0
Public Function Proc_6_78_7279A0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_78_7279A0 = Empty
End Function

' Original declaration: Private Sub Proc_6_79_72A430
Public Function Proc_6_79_72A430(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_79_72A430 = Empty
End Function

' Original declaration: Private Sub Proc_6_80_72EB60
Public Function Proc_6_80_72EB60(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_80_72EB60 = Empty
End Function

' Original declaration: Private Sub Proc_6_81_730010
Public Function Proc_6_81_730010(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_81_730010 = Empty
End Function

' Original declaration: Private Sub Proc_6_82_731070
Public Function Proc_6_82_731070(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_82_731070 = Empty
End Function

' Original declaration: Private  Proc_6_83_732640(arg_C) '732640
Public Function Proc_6_83_732640(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_83_732640 = Empty
End Function

' Original declaration: Private Sub Proc_6_84_733600
Public Function Proc_6_84_733600(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_84_733600 = Empty
End Function

' Original declaration: Private Sub Proc_6_85_73A8E0
Public Function Proc_6_85_73A8E0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_85_73A8E0 = Empty
End Function

' Original declaration: Private Sub Proc_6_86_73B0D0
Public Function Proc_6_86_73B0D0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_86_73B0D0 = Empty
End Function

' Original declaration: Private Sub Proc_6_87_73C120
Public Function Proc_6_87_73C120(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_87_73C120 = Empty
End Function

' Original declaration: Private Sub Proc_6_88_73E4F0
Public Function Proc_6_88_73E4F0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_88_73E4F0 = Empty
End Function

' Original declaration: Private Sub Proc_6_89_73EA10
Public Function Proc_6_89_73EA10(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_89_73EA10 = Empty
End Function

' Original declaration: Private Sub Proc_6_90_742E80
Public Function Proc_6_90_742E80(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_90_742E80 = Empty
End Function

' Original declaration: Private Sub Proc_6_91_743480
Public Function Proc_6_91_743480(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_91_743480 = Empty
End Function

' Original declaration: Private Sub Proc_6_92_744870
Public Function Proc_6_92_744870(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_92_744870 = Empty
End Function

' Original declaration: Private Sub Proc_6_93_745D90
Public Function Proc_6_93_745D90(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_93_745D90 = Empty
End Function

' Original declaration: Private Sub Proc_6_94_746990
Public Function Proc_6_94_746990(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_94_746990 = Empty
End Function

' Original declaration: Private Sub Proc_6_95_746CD0
Public Function Proc_6_95_746CD0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_95_746CD0 = Empty
End Function

' Original declaration: Private Sub Proc_6_96_747000
Public Function Proc_6_96_747000(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_96_747000 = Empty
End Function

' Original declaration: Private Sub Proc_6_97_747640
Public Function Proc_6_97_747640(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_97_747640 = Empty
End Function

' Original declaration: Private Sub Proc_6_98_747D80
Public Function Proc_6_98_747D80(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_98_747D80 = Empty
End Function

' Original declaration: Private Sub Proc_6_99_748460
Public Function Proc_6_99_748460(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_99_748460 = Empty
End Function

' Original declaration: Private Sub Proc_6_100_748C80
Public Function Proc_6_100_748C80(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_100_748C80 = Empty
End Function

' Original declaration: Private Sub Proc_6_101_749540
Public Function Proc_6_101_749540(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_101_749540 = Empty
End Function

' Original declaration: Private Sub Proc_6_102_749C50
Public Function Proc_6_102_749C50(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_102_749C50 = Empty
End Function

' Original declaration: Private Sub Proc_6_103_74A510
Public Function Proc_6_103_74A510(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_103_74A510 = Empty
End Function

' Original declaration: Private Sub Proc_6_104_74AB60
Public Function Proc_6_104_74AB60(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim userId As String
    Dim maxOwnedRooms As Long
    Dim ownedRoomCount As Long
    Dim payload As String

    On Error GoTo RoomLimitFailed

    socketIndex = HandlingSocketIndex(args)
    userId = HandlingUserIdFromSocket(socketIndex)
    maxOwnedRooms = CLng(Val(CStr(Proc_10_0_809570("com.server.socket.game.rooms.own.max", 0, 0))))
    ownedRoomCount = CLng(Val(CStr(Proc_5_2_6D4690("SELECT COUNT(id) FROM rooms WHERE id_owner='" & Proc_10_11_80A9C0(userId, 0, 0) & "'", 0, 0))))

    payload = CStr(Proc_3_0_6D2AF0(maxOwnedRooms, Empty, "H@"))
    payload = CStr(Proc_3_0_6D2AF0(ownedRoomCount, Empty, payload))
    Proc_6_244_801E80 socketIndex, payload, 0

RoomLimitFailed:
    Proc_6_104_74AB60 = Empty
End Function

' Original declaration: Private Sub Proc_6_105_74AD50
Public Function Proc_6_105_74AD50(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_105_74AD50 = Empty
End Function

' Original declaration: Private Sub Proc_6_106_74B750
Public Function Proc_6_106_74B750(ParamArray args() As Variant) As Variant
    On Error Resume Next
    If UBound(args) >= 0 Then Kill CStr(args(0))
    Proc_6_106_74B750 = Empty
End Function

' Original declaration: Private Sub Proc_6_107_74B7E0
Public Function Proc_6_107_74B7E0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_107_74B7E0 = Empty
End Function

' Original declaration: Private Sub Proc_6_108_74D800
Public Function Proc_6_108_74D800(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim userId As String
    Dim maxFavorites As Long
    Dim rows() As String
    Dim rowText As String
    Dim roomIds As String
    Dim roomCount As Long
    Dim rowIndex As Long

    On Error GoTo FavouritesFailed

    socketIndex = HandlingSocketIndex(args)
    userId = HandlingUserIdFromSocket(socketIndex)
    maxFavorites = CLng(Val(CStr(Proc_10_0_809570("com.server.socket.game.rooms.favourites.max", 30, 0))))
    If maxFavorites <= 0 Then maxFavorites = 30

    rowText = CStr(Proc_5_2_6D4690("SELECT id_room FROM rooms_favourites WHERE id_user='" & Proc_10_11_80A9C0(userId, 0, 0) & "' LIMIT " & CStr(maxFavorites), 0, 0))
    If Len(rowText) > 0 Then
        rows = Split(rowText, Chr$(13))
        For rowIndex = LBound(rows) To UBound(rows)
            If Len(rows(rowIndex)) > 0 Then
                roomIds = CStr(Proc_3_0_6D2AF0(CLng(Val(rows(rowIndex))), Empty, roomIds))
                roomCount = roomCount + 1
            End If
        Next rowIndex
    End If

    Proc_6_244_801E80 socketIndex, CStr(Proc_3_0_6D2AF0(roomCount, Empty, CStr(Proc_3_0_6D2AF0(maxFavorites, Empty, "GJ")))) & roomIds, 0

FavouritesFailed:
    Proc_6_108_74D800 = Empty
End Function

' Original declaration: Private Sub Proc_6_109_74DBD0
Public Function Proc_6_109_74DBD0(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim userId As String
    Dim roomId As Long

    On Error GoTo FavouriteFailed

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    Proc_10_5_809D80 packetPayload, 3, 0
    roomId = CLng(Val(CStr(Proc_10_6_809F10(packetPayload, 0, 0))))
    userId = HandlingUserIdFromSocket(socketIndex)

    Proc_5_0_6D3CD0 "DELETE FROM rooms_favourites WHERE id_room='" & CStr(roomId) & "' AND id_user='" & Proc_10_11_80A9C0(userId, 0, 0) & "'", 0, 0
    Proc_6_244_801E80 socketIndex, CStr(Proc_3_0_6D2AF0(roomId, Empty, "GK")) & "H", 0

FavouriteFailed:
    Proc_6_109_74DBD0 = Empty
End Function

' Original declaration: Private Sub Proc_6_110_74DDA0
Public Function Proc_6_110_74DDA0(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim userId As String
    Dim roomId As Long

    On Error GoTo FavouriteFailed

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    Proc_10_5_809D80 packetPayload, 3, 0
    roomId = CLng(Val(CStr(Proc_10_6_809F10(packetPayload, 0, 0))))
    userId = HandlingUserIdFromSocket(socketIndex)

    Proc_5_0_6D3CD0 "INSERT INTO rooms_favourites(id_user,id_room,timestamp) VALUES('" & Proc_10_11_80A9C0(userId, 0, 0) & "','" & CStr(roomId) & "',UNIX_TIMESTAMP())", 0, 0
    Proc_6_244_801E80 socketIndex, CStr(Proc_3_0_6D2AF0(roomId, Empty, "GK")) & Chr$(32), 0

FavouriteFailed:
    Proc_6_110_74DDA0 = Empty
End Function

' Original declaration: Private Sub Proc_6_111_74DF70
Public Function Proc_6_111_74DF70(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim rankIndex As Long
    Dim hcLevel As Long
    Dim responsePayload As String

    On Error GoTo SendFailed

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 3 Then rankIndex = CLng(Val(CStr(args(3))))
    If UBound(args) >= 4 Then hcLevel = CLng(Val(CStr(args(4))))

    If rankIndex < 0 Then rankIndex = 0
    If rankIndex > 20 Then rankIndex = 20
    If hcLevel < 0 Then hcLevel = 0
    If hcLevel > 2 Then hcLevel = 2

    If IsArray(global_00829244) Then
        responsePayload = CStr(global_00829244(rankIndex, hcLevel))
    End If

    Proc_6_244_801E80 socketIndex, "C]" & responsePayload, 0

SendFailed:
    Proc_6_111_74DF70 = Empty
End Function

' Original declaration: Private  Proc_6_112_74E0C0(arg_C) '74E0C0
Public Function Proc_6_112_74E0C0(ParamArray args() As Variant) As Variant
    Dim queryTail As String

    On Error GoTo BuildFailed
    If UBound(args) < 0 Then GoTo BuildFailed

    queryTail = CStr(args(0))
    Proc_6_112_74E0C0 = NavigatorRoomListPayload(queryTail, False)
    Exit Function

BuildFailed:
    Proc_6_112_74E0C0 = vbNullString
End Function

' Original declaration: Private  Proc_6_113_74EE70(arg_C, arg_10) '74EE70
Public Function Proc_6_113_74EE70(ParamArray args() As Variant) As Variant
    Dim eventQueryTail As String
    Dim roomQueryTail As String

    On Error GoTo BuildFailed
    If UBound(args) < 1 Then GoTo BuildFailed

    eventQueryTail = CStr(args(0))
    roomQueryTail = CStr(args(1))
    Proc_6_113_74EE70 = NavigatorCombinedRoomListPayload(eventQueryTail, roomQueryTail)
    Exit Function

BuildFailed:
    Proc_6_113_74EE70 = vbNullString
End Function

' Original declaration: Private  Proc_6_114_750550(arg_C) '750550
Public Function Proc_6_114_750550(ParamArray args() As Variant) As Variant
    Dim queryTail As String

    On Error GoTo BuildFailed
    If UBound(args) < 0 Then GoTo BuildFailed

    queryTail = CStr(args(0))
    Proc_6_114_750550 = NavigatorEventListPayload(queryTail)
    Exit Function

BuildFailed:
    Proc_6_114_750550 = vbNullString
End Function

' Original declaration: Private Sub Proc_6_115_751220
Public Function Proc_6_115_751220(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim categoryId As Long
    Dim categoryFilter As String
    Dim limitValue As Long
    Dim queryTail As String
    Dim randomTree As Long

    On Error GoTo NavigatorFailed

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    Proc_10_5_809D80 packetPayload, 3, 0
    categoryId = CLng(Val(CStr(Proc_10_7_80A190(packetPayload, 0, 0))))
    If categoryId > 1 Then categoryFilter = " rooms_events.id_category='" & CStr(categoryId) & "' AND"

    limitValue = NavigatorListLimit()
    queryTail = "rooms_events,users,rooms,rooms_categories WHERE" & categoryFilter & " rooms.id=rooms_events.id_room AND rooms_categories.id=rooms.id_category AND users.id=rooms.id_owner GROUP BY rooms_events.id ORDER BY rooms_events.id ASC LIMIT " & CStr(limitValue)
    randomTree = CLng(Val(CStr(Proc_10_4_809CA0(1, global_00829128, 0))))
    Proc_6_244_801E80 socketIndex, "GCPC" & CStr(categoryId) & Chr$(2) & CStr(Proc_3_0_6D2AF0(limitValue, Empty, vbNullString)) & Proc_6_112_74E0C0(queryTail, 0, 0) & RecommendedRoomPayload(randomTree), 0

NavigatorFailed:
    Proc_6_115_751220 = Empty
End Function

' Original declaration: Private Sub Proc_6_116_751550
Public Function Proc_6_116_751550(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim categoryId As Long
    Dim categoryFilter As String
    Dim limitValue As Long
    Dim queryTail As String
    Dim randomTree As Long

    On Error GoTo NavigatorFailed

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    Proc_10_5_809D80 packetPayload, 3, 0
    categoryId = CLng(Val(CStr(Proc_10_7_80A190(packetPayload, 0, 0))))
    If categoryId > 1 Then categoryFilter = " rooms.id_category='" & CStr(categoryId) & "' AND"

    limitValue = NavigatorListLimit()
    queryTail = "users,rooms,rooms_categories WHERE" & categoryFilter & " rooms.visitors_now > 0 AND users.id=rooms.id_owner AND rooms_categories.id=rooms.id_category GROUP BY rooms.id ORDER BY rooms.visitors_now DESC LIMIT " & CStr(limitValue)
    randomTree = CLng(Val(CStr(Proc_10_4_809CA0(1, global_00829128, 0))))
    Proc_6_244_801E80 socketIndex, "GC" & Chr$(32) & CStr(categoryId) & Chr$(2) & CStr(Proc_3_0_6D2AF0(limitValue, Empty, vbNullString)) & Proc_6_112_74E0C0(queryTail, 0, 0) & RecommendedRoomPayload(randomTree), 0

NavigatorFailed:
    Proc_6_116_751550 = Empty
End Function

' Original declaration: Private Sub Proc_6_117_751880
Public Function Proc_6_117_751880(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim userId As String
    Dim limitValue As Long
    Dim queryTail As String

    On Error GoTo NavigatorFailed

    socketIndex = HandlingSocketIndex(args)
    userId = HandlingUserIdFromSocket(socketIndex)
    limitValue = NavigatorListLimit()
    queryTail = "friendships,logs_visitedrooms,users,rooms,rooms_categories WHERE friendships.id_user='" & Proc_10_11_80A9C0(userId, 0, 0) & "' AND logs_visitedrooms.id_user=friendships.id_friend AND logs_visitedrooms.timestamp_left IS NULL AND rooms.id=logs_visitedrooms.id_room AND rooms_categories.id=rooms.id_category AND users.id=rooms.id_owner GROUP BY rooms.id ORDER BY rooms.id DESC LIMIT " & CStr(limitValue)
    Proc_6_244_801E80 socketIndex, "GCQA" & Chr$(2) & CStr(Proc_3_0_6D2AF0(limitValue, Empty, vbNullString)) & Proc_6_112_74E0C0(queryTail, 0, 0), 0

NavigatorFailed:
    Proc_6_117_751880 = Empty
End Function

' Original declaration: Private Sub Proc_6_118_751A80
Public Function Proc_6_118_751A80(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim userId As String
    Dim limitValue As Long
    Dim queryTail As String

    On Error GoTo NavigatorFailed

    socketIndex = HandlingSocketIndex(args)
    userId = HandlingUserIdFromSocket(socketIndex)
    limitValue = NavigatorListLimit()
    queryTail = "friendships,users,rooms,rooms_categories WHERE friendships.id_user='" & Proc_10_11_80A9C0(userId, 0, 0) & "' AND users.id=friendships.id_friend AND rooms_categories.id=rooms.id_category AND users.id=rooms.id_owner GROUP BY rooms.id ORDER BY rooms.visitors_now DESC LIMIT " & CStr(limitValue)
    Proc_6_244_801E80 socketIndex, "GC" & Chr$(0) & Chr$(2) & CStr(Proc_3_0_6D2AF0(limitValue, Empty, vbNullString)) & Proc_6_112_74E0C0(queryTail, 0, 0), 0

NavigatorFailed:
    Proc_6_118_751A80 = Empty
End Function

' Original declaration: Private Sub Proc_6_119_751C80
Public Function Proc_6_119_751C80(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim userId As String
    Dim limitValue As Long
    Dim queryTail As String

    On Error GoTo NavigatorFailed

    socketIndex = HandlingSocketIndex(args)
    userId = HandlingUserIdFromSocket(socketIndex)
    limitValue = NavigatorListLimit()
    queryTail = "rooms_favourites,users,rooms,rooms_categories WHERE rooms_favourites.id_user='" & Proc_10_11_80A9C0(userId, 0, 0) & "' AND rooms.id=rooms_favourites.id_room AND rooms_categories.id=rooms.id_category AND users.id=rooms.id_owner GROUP BY rooms.id ORDER BY rooms.visitors_now DESC LIMIT " & CStr(limitValue)
    Proc_6_244_801E80 socketIndex, "GCRA" & Chr$(2) & CStr(Proc_3_0_6D2AF0(limitValue, Empty, vbNullString)) & Proc_6_112_74E0C0(queryTail, 0, 0), 0

NavigatorFailed:
    Proc_6_119_751C80 = Empty
End Function

' Original declaration: Private Sub Proc_6_120_751E80
Public Function Proc_6_120_751E80(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim userId As String
    Dim limitValue As Long
    Dim queryTail As String

    On Error GoTo NavigatorFailed

    socketIndex = HandlingSocketIndex(args)
    userId = HandlingUserIdFromSocket(socketIndex)
    limitValue = NavigatorListLimit()
    queryTail = "logs_visitedrooms,users,rooms,rooms_categories WHERE logs_visitedrooms.id_user='" & Proc_10_11_80A9C0(userId, 0, 0) & "' AND rooms.id=logs_visitedrooms.id_room AND rooms_categories.id=rooms.id_category AND users.id=rooms.id_owner GROUP BY rooms.id ORDER BY rooms.id DESC LIMIT " & CStr(limitValue)
    Proc_6_244_801E80 socketIndex, "GCSA" & Chr$(2) & CStr(Proc_3_0_6D2AF0(limitValue, Empty, vbNullString)) & Proc_6_112_74E0C0(queryTail, 0, 0), 0

NavigatorFailed:
    Proc_6_120_751E80 = Empty
End Function

' Original declaration: Private Sub Proc_6_121_752080
Public Function Proc_6_121_752080(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim userId As String
    Dim limitValue As Long
    Dim queryTail As String

    On Error GoTo NavigatorFailed

    socketIndex = HandlingSocketIndex(args)
    userId = HandlingUserIdFromSocket(socketIndex)
    limitValue = NavigatorListLimit()
    queryTail = "users,rooms,rooms_categories WHERE rooms.id_owner='" & Proc_10_11_80A9C0(userId, 0, 0) & "' AND rooms_categories.id=rooms.id_category AND users.id=rooms.id_owner GROUP BY rooms.id ORDER BY rooms.visitors_now DESC LIMIT " & CStr(limitValue)
    Proc_6_244_801E80 socketIndex, "GCQA" & Chr$(2) & CStr(Proc_3_0_6D2AF0(limitValue, Empty, vbNullString)) & Proc_6_112_74E0C0(queryTail, 0, 0), 0

NavigatorFailed:
    Proc_6_121_752080 = Empty
End Function

' Original declaration: Private  Proc_6_122_752280(arg_C) '752280
Public Function Proc_6_122_752280(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_122_752280 = Empty
End Function

' Original declaration: Private Sub Proc_6_123_754020
Public Function Proc_6_123_754020(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_123_754020 = Empty
End Function

' Original declaration: Private Sub Proc_6_124_754D90
Public Function Proc_6_124_754D90(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim limitValue As Long
    Dim queryText As String
    Dim rowText As String
    Dim rows() As String
    Dim fields() As String
    Dim rowIndex As Long
    Dim payload As String

    On Error GoTo NavigatorFailed

    socketIndex = HandlingSocketIndex(args)
    limitValue = NavigatorListLimit()
    queryText = "SELECT SUM(get_one) as get_one,get_two FROM (SELECT SUM(rooms.visitors_now) as get_one,rooms.tag_1 as get_two FROM rooms,users WHERE rooms.tag_1 != '' AND rooms.visitors_max > 0 AND users.id=rooms.id_owner GROUP BY 2 UNION ALL SELECT SUM(rooms.visitors_now) as get_one,rooms.tag_2 as get_two FROM rooms,users WHERE rooms.tag_2 != '' AND rooms.visitors_max > 0 AND users.id=rooms.id_owner GROUP BY 2) as a GROUP BY get_two ORDER BY 1 DESC LIMIT " & CStr(limitValue)
    rowText = CStr(Proc_5_2_6D4690(queryText, 0, 0))

    If Len(rowText) > 0 Then
        rows = Split(rowText, Chr$(13))
        For rowIndex = LBound(rows) To UBound(rows)
            If Len(rows(rowIndex)) > 0 Then
                fields = Split(rows(rowIndex), Chr$(9))
                payload = payload & CStr(Proc_3_0_6D2AF0(CLng(Val(NavigatorField(fields, 0))), Empty, vbNullString)) & NavigatorField(fields, 1) & Chr$(2)
            End If
        Next rowIndex
    End If

    Proc_6_244_801E80 socketIndex, "GD" & payload, 0

NavigatorFailed:
    Proc_6_124_754D90 = Empty
End Function

' Original declaration: Private Sub Proc_6_125_755650
Public Function Proc_6_125_755650(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim tagText As String
    Dim limitValue As Long
    Dim eventQueryTail As String
    Dim roomQueryTail As String

    On Error GoTo NavigatorFailed

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    Proc_10_5_809D80 packetPayload, 3, 0
    tagText = CStr(Proc_10_11_80A9C0(Proc_10_7_80A190(packetPayload, 0, 0), 0, 0))
    limitValue = NavigatorListLimit()

    eventQueryTail = "rooms_events,users,rooms,rooms_categories WHERE (rooms_events.name_category='" & tagText & "' OR rooms_events.tag_1='" & tagText & "' OR rooms_events.tag_2='" & tagText & "') AND rooms.id=rooms_events.id_room AND rooms_categories.id=rooms.id_category AND users.id=rooms.id_owner GROUP BY rooms_events.id ORDER BY rooms_events.id ASC LIMIT " & CStr(limitValue)
    roomQueryTail = "users,rooms,rooms_categories WHERE (rooms.tag_1 = '" & tagText & "' OR rooms.tag_2 = '" & tagText & "') AND users.id=rooms.id_owner AND rooms_categories.id=rooms.id_category GROUP BY rooms.id ORDER BY rooms.visitors_now DESC LIMIT " & CStr(limitValue)

    Proc_6_244_801E80 socketIndex, "GCSA" & tagText & Chr$(2) & CStr(Proc_3_0_6D2AF0(limitValue, Empty, vbNullString)) & Proc_6_113_74EE70(eventQueryTail, roomQueryTail, 0), 0

NavigatorFailed:
    Proc_6_125_755650 = Empty
End Function

' Original declaration: Private Sub Proc_6_126_755B40
Public Function Proc_6_126_755B40(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim limitValue As Long
    Dim queryTail As String

    On Error GoTo NavigatorFailed

    socketIndex = HandlingSocketIndex(args)
    limitValue = NavigatorListLimit()
    queryTail = "users,rooms,rooms_categories WHERE rooms.rate > 0 AND users.id=rooms.id_owner AND rooms_categories.id=rooms.id_category GROUP BY rooms.id ORDER BY rooms.rate DESC LIMIT " & CStr(limitValue)
    Proc_6_244_801E80 socketIndex, "GC" & Chr$(8) & Chr$(2) & CStr(Proc_3_0_6D2AF0(limitValue, Empty, vbNullString)) & Proc_6_112_74E0C0(queryTail, 0, 0), 0

NavigatorFailed:
    Proc_6_126_755B40 = Empty
End Function

' Original declaration: Private Sub Proc_6_127_755D30
Public Function Proc_6_127_755D30(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim searchText As String
    Dim limitValue As Long
    Dim roomPredicate As String
    Dim eventQueryTail As String
    Dim roomQueryTail As String

    On Error GoTo NavigatorFailed

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    Proc_10_5_809D80 packetPayload, 3, 0
    searchText = NavigatorSearchTerm(CStr(Proc_10_7_80A190(packetPayload, 0, 0)))
    If Len(searchText) > 2 Then
        roomPredicate = "(users.name LIKE '" & searchText & "%' OR rooms.name LIKE '" & searchText & "%')"
    Else
        roomPredicate = "(users.name = '" & searchText & "' OR rooms.name = '" & searchText & "')"
    End If

    limitValue = NavigatorListLimit()
    roomQueryTail = "users,rooms,rooms_categories WHERE " & roomPredicate & " AND users.id=rooms.id_owner AND rooms_categories.id=rooms.id_category GROUP BY rooms.id ORDER BY rooms.visitors_now DESC LIMIT " & CStr(limitValue)
    eventQueryTail = "rooms_events,users,rooms,rooms_categories WHERE (users.name='" & searchText & "' AND rooms_events.id_user=users.id OR rooms_events.name LIKE '" & searchText & "%' AND users.id=rooms.id_owner) AND rooms.id=rooms_events.id_room AND rooms_categories.id=rooms.id_category GROUP BY rooms_events.id ORDER BY rooms_events.id ASC LIMIT " & CStr(limitValue)

    Proc_6_244_801E80 socketIndex, "GCSA" & searchText & Chr$(2) & CStr(Proc_3_0_6D2AF0(limitValue, Empty, vbNullString)) & Proc_6_113_74EE70(eventQueryTail, roomQueryTail, 0), 0

NavigatorFailed:
    Proc_6_127_755D30 = Empty
End Function

' Original declaration: Private Sub Proc_6_128_756190
Public Function Proc_6_128_756190(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_128_756190 = Empty
End Function

' Original declaration: Private  Proc_6_129_7583C0(arg_C, arg_10) '7583C0
Public Function Proc_6_129_7583C0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_129_7583C0 = Empty
End Function

' Original declaration: Private Sub Proc_6_130_75B770
Public Function Proc_6_130_75B770(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_130_75B770 = Empty
End Function

' Original declaration: Private Sub Proc_6_131_75C700
Public Function Proc_6_131_75C700(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_131_75C700 = Empty
End Function

' Original declaration: Private Sub Proc_6_132_75D4A0
Public Function Proc_6_132_75D4A0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_132_75D4A0 = Empty
End Function

' Original declaration: Private  Proc_6_133_760400(arg_C, arg_10, arg_14) '760400
Public Function Proc_6_133_760400(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_133_760400 = Empty
End Function

' Original declaration: Private Sub Proc_6_134_765B90
Public Function Proc_6_134_765B90(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim itemId As Long
    Dim giftEnabled As Long
    Dim itemType As Long
    Dim responsePayload As String

    On Error GoTo CatalogGiftFailed
    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))

    Proc_10_5_809D80 packetPayload, 3, 0
    itemId = CLng(Val(CStr(Proc_10_6_809F10(packetPayload, 0, 0))))
    itemType = CLng(Val(CStr(Proc_9_1_8072B0(itemId, 9, 0))))
    If itemType = 1 Then
        giftEnabled = CLng(Val(CStr(Proc_10_0_809570("com.client.catalog.gifts.enabled", 0, 0))))
    End If

    responsePayload = CStr(Proc_3_0_6D2AF0(itemId, Empty, "In"))
    responsePayload = CStr(Proc_3_0_6D2AF0(giftEnabled, Empty, responsePayload)) & Chr$(2)
    Proc_6_244_801E80 socketIndex, responsePayload, 0

CatalogGiftFailed:
    Proc_6_134_765B90 = Empty
End Function

' Original declaration: Private Sub Proc_6_135_765D80
Public Function Proc_6_135_765D80(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim defaultPayload As String
    Dim giftWrapPrice As Long
    Dim responsePayload As String

    On Error GoTo CatalogWrapFailed
    socketIndex = HandlingSocketIndex(args)
    defaultPayload = "0" & CStr(Proc_3_0_6D2AF0(CLng(Val(CStr(Proc_10_0_809570("com.client.catalog.gifts.wrap.enabled", 0, 0)))), Empty, "Il"))
    giftWrapPrice = CLng(Val(CStr(Proc_10_0_809570("com.client.catalog.gifts.wrap.price", defaultPayload, 0))))

    responsePayload = CStr(Proc_3_0_6D2AF0(giftWrapPrice, Empty, vbNullString)) & global_00829260
    Proc_6_244_801E80 socketIndex, responsePayload, 0

CatalogWrapFailed:
    Proc_6_135_765D80 = Empty
End Function

' Original declaration: Private Sub Proc_6_136_765F10
Public Function Proc_6_136_765F10(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim requestPayload As String
    Dim pageId As Long
    Dim pagePayload As String
    Dim responsePayload As String

    On Error GoTo CatalogPageFailed

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    If Len(packetPayload) >= 3 Then requestPayload = CStr(Proc_10_5_809D80(packetPayload, 3, 0))
    pageId = CLng(Val(CStr(Proc_10_6_809F10(requestPayload, 0, 0))))

    If IsArray(global_00829308) Then
        If pageId >= LBound(global_00829308) And pageId <= UBound(global_00829308) Then
            pagePayload = CStr(global_00829308(pageId))
        End If
    End If

    If Len(pagePayload) > 0 Then
        responsePayload = "A" & Chr$(127) & CStr(Proc_3_0_6D2AF0(pageId, Empty, vbNullString)) & pagePayload
        Proc_6_244_801E80 socketIndex, responsePayload, 0
    End If

CatalogPageFailed:
    Proc_6_136_765F10 = Empty
End Function

' Original declaration: Private Sub Proc_6_137_766470
Public Function Proc_6_137_766470(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim requestPayload As String
    Dim voucherCode As String
    Dim voucherRows As String
    Dim fields() As String
    Dim userId As String
    Dim productSprite As String
    Dim creditsValue As Long
    Dim shellsValue As Long
    Dim productId As Long
    Dim rewardPayload As String

    On Error GoTo VoucherFailed

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    If Len(packetPayload) >= 3 Then requestPayload = CStr(Proc_10_5_809D80(packetPayload, 3, 0))
    voucherCode = Replace(CStr(Proc_10_7_80A190(packetPayload, 0, 0)), Chr$(32), "0", 1, -1, vbBinaryCompare)
    If Len(voucherCode) = 0 Then voucherCode = Replace(CStr(Proc_10_7_80A190(requestPayload, 0, 0)), Chr$(32), "0", 1, -1, vbBinaryCompare)
    If Len(voucherCode) = 0 Then voucherCode = Replace(requestPayload, Chr$(32), "0", 1, -1, vbBinaryCompare)
    If Len(voucherCode) <> 8 Then GoTo VoucherInvalid

    voucherRows = CStr(Proc_5_2_6D4690("SELECT contain_product,contain_credits,contain_shells FROM vouchers WHERE name='" & Proc_10_11_80A9C0(voucherCode, 0, 0) & "' LIMIT 1", 0, 0))
    If Len(voucherRows) = 0 Then GoTo VoucherInvalid

    fields = Split(voucherRows, Chr$(9))
    If UBound(fields) < 2 Then GoTo VoucherInvalid

    userId = HandlingUserIdFromSocket(socketIndex)
    If Len(userId) = 0 Then GoTo VoucherInvalid

    productSprite = CStr(fields(0))
    creditsValue = CLng(Val(CStr(fields(1))))
    shellsValue = CLng(Val(CStr(fields(2))))

    If Len(productSprite) > 2 Then
        productId = CLng(Val(CStr(Proc_5_2_6D4690("SELECT id_product FROM catalog_products WHERE sprite='" & Proc_10_11_80A9C0(productSprite, 0, 0) & "' LIMIT 1", 0, 0))))
        If productId <> 0 Then
            rewardPayload = CStr(Proc_8_12_806C30(productId, 13, 0)) & Chr$(2) & CStr(Proc_8_12_806C30(productId, 14, 0)) & Chr$(2)
        End If
    End If

    If creditsValue <> 0 Then
        Proc_5_0_6D3CD0 "UPDATE users SET credits=credits+" & CStr(creditsValue) & " WHERE id='" & Proc_10_11_80A9C0(userId, 0, 0) & "'", 0, 0
        Proc_10_16_80C480 userId, 0, 0
    End If

    If shellsValue <> 0 Then
        Proc_5_0_6D3CD0 "UPDATE users SET activitypoints_0=activitypoints_0+" & CStr(shellsValue) & " WHERE id='" & Proc_10_11_80A9C0(userId, 0, 0) & "'", 0, 0
        Proc_10_17_80C6B0 userId, 0, 0
    End If

    Proc_5_0_6D3CD0 "DELETE FROM vouchers WHERE name='" & Proc_10_11_80A9C0(voucherCode, 0, 0) & "' LIMIT 1", 0, 0
    Proc_6_244_801E80 socketIndex, "CT" & rewardPayload, 0
    Proc_6_137_766470 = Empty
    Exit Function

VoucherInvalid:
    Proc_6_244_801E80 socketIndex, "CU" & voucherCode & Chr$(2), 0

VoucherFailed:
    Proc_6_137_766470 = Empty
End Function

' Original declaration: Private  Proc_6_138_7678A0(arg_C, arg_10, arg_14, arg_18) '7678A0
Public Function Proc_6_138_7678A0(ParamArray args() As Variant) As Variant
    Dim itemId As Long
    Dim productId As Long
    Dim itemData As String
    Dim extraValue As Long
    Dim productFields() As String
    Dim productType As Long
    Dim itemClass As String
    Dim productName As String
    Dim productDescription As String
    Dim productSprite As String
    Dim payload As String

    On Error GoTo BuildFailed
    If UBound(args) < 1 Then GoTo BuildFailed

    itemId = CLng(Val(CStr(args(0))))
    productId = CLng(Val(CStr(args(1))))
    If UBound(args) >= 2 Then itemData = Replace(CStr(args(2)), Chr$(8), Chr$(9), 1, -1, vbBinaryCompare)
    If UBound(args) >= 3 Then extraValue = CLng(Val(CStr(args(3))))

    productFields = Split(CStr(Proc_9_3_807930(productId, 0, 0)), Chr$(9))
    If UBound(productFields) >= 18 Then
        productType = CLng(Val(CStr(productFields(1))))
        productName = CStr(productFields(14))
        productDescription = CStr(productFields(15))
        productSprite = CStr(productFields(18))
    End If

    itemClass = "S"
    If productType = 9 Then itemClass = "I"

    payload = CStr(Proc_3_0_6D2AF0(itemId, Empty, "0")) & itemClass & Chr$(2)
    payload = payload & CStr(Proc_3_0_6D2AF0(itemId, Empty, vbNullString))
    payload = payload & CStr(Proc_3_0_6D2AF0(productId, Empty, vbNullString))
    payload = payload & CStr(Proc_3_0_6D2AF0(productType, Empty, vbNullString))
    payload = payload & itemData & Chr$(2)
    payload = payload & CStr(Proc_3_0_6D2AF0(extraValue, Empty, vbNullString))
    payload = payload & productName & Chr$(2)
    payload = payload & productDescription & Chr$(2)
    payload = payload & productSprite & Chr$(2)
    payload = payload & "M" & Chr$(2)
    payload = payload & CStr(Proc_3_0_6D2AF0(extraValue, Empty, vbNullString))

    Proc_6_138_7678A0 = payload
    Exit Function

BuildFailed:
    Proc_6_138_7678A0 = vbNullString
End Function

' Original declaration: Private Sub Proc_6_139_768100
Public Function Proc_6_139_768100(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_139_768100 = Empty
End Function

' Original declaration: Private Sub Proc_6_140_769400
Public Function Proc_6_140_769400(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_140_769400 = Empty
End Function

' Original declaration: Private Sub Proc_6_141_76A670
Public Function Proc_6_141_76A670(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_141_76A670 = Empty
End Function

' Original declaration: Private Sub Proc_6_142_76B310
Public Function Proc_6_142_76B310(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_142_76B310 = Empty
End Function

' Original declaration: Private Sub Proc_6_143_76BB80
Public Function Proc_6_143_76BB80(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_143_76BB80 = Empty
End Function

' Original declaration: Private Sub Proc_6_144_76BE70
Public Function Proc_6_144_76BE70(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_144_76BE70 = Empty
End Function

' Original declaration: Private  Proc_6_145_76CA20(arg_C, arg_10, arg_14) '76CA20
Public Function Proc_6_145_76CA20(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_145_76CA20 = Empty
End Function

' Original declaration: Private  Proc_6_146_76D300(arg_C, arg_10) '76D300
Public Function Proc_6_146_76D300(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_146_76D300 = Empty
End Function

' Original declaration: Private  Proc_6_147_76E910(arg_C, arg_10) '76E910
Public Function Proc_6_147_76E910(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_147_76E910 = Empty
End Function

' Original declaration: Private  Proc_6_148_7756D0(arg_C, arg_10, arg_14) '7756D0
Public Function Proc_6_148_7756D0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_148_7756D0 = Empty
End Function

' Original declaration: Private Sub Proc_6_149_775C10
Public Function Proc_6_149_775C10(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_149_775C10 = Empty
End Function

' Original declaration: Private Sub Proc_6_150_777FA0
Public Function Proc_6_150_777FA0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_150_777FA0 = Empty
End Function

' Original declaration: Private  Proc_6_151_78AC20(arg_C, arg_10) '78AC20
Public Function Proc_6_151_78AC20(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_151_78AC20 = Empty
End Function

' Original declaration: Private  Proc_6_152_78C2F0(arg_C, arg_10) '78C2F0
Public Function Proc_6_152_78C2F0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_152_78C2F0 = Empty
End Function

' Original declaration: Private  Proc_6_153_78D980(arg_C, arg_10) '78D980
Public Function Proc_6_153_78D980(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_153_78D980 = Empty
End Function

' Original declaration: Private  Proc_6_154_78F040(arg_C, arg_10) '78F040
Public Function Proc_6_154_78F040(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_154_78F040 = Empty
End Function

' Original declaration: Private Sub Proc_6_155_795C90
Public Function Proc_6_155_795C90(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_155_795C90 = Empty
End Function

' Original declaration: Private  Proc_6_156_7972B0(arg_C, arg_10, arg_14, arg_18) '7972B0
Public Function Proc_6_156_7972B0(ParamArray args() As Variant) As Variant
    Dim baseValue As Long
    Dim firstValue As Long
    Dim secondValue As String
    Dim thirdValue As String
    Dim fourthValue As Long
    Dim payload As String

    On Error GoTo BuildFailed
    If UBound(args) < 0 Then GoTo BuildFailed

    baseValue = CLng(Val(CStr(args(0))))
    If UBound(args) >= 1 Then firstValue = CLng(Val(CStr(args(1))))
    If UBound(args) >= 2 Then secondValue = CStr(args(2))
    If UBound(args) >= 3 Then thirdValue = CStr(args(3))
    If UBound(args) >= 4 Then fourthValue = CLng(Val(CStr(args(4))))

    payload = Proc_3_0_6D2AF0(firstValue, Empty, CStr(baseValue) & Chr$(2)) & secondValue & Chr$(2) & thirdValue & Chr$(2)
    Proc_6_156_7972B0 = "0" & CStr(Proc_3_0_6D2AF0(fourthValue, Empty, payload))
    Exit Function

BuildFailed:
    Proc_6_156_7972B0 = vbNullString
End Function

' Original declaration: Private  Proc_6_157_7974B0(arg_C, arg_10, arg_14) '7974B0
Public Function Proc_6_157_7974B0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_157_7974B0 = Empty
End Function

' Original declaration: Private  Proc_6_158_7987C0(arg_C, arg_10, arg_14, arg_18, arg_1C, arg_20) '7987C0
Public Function Proc_6_158_7987C0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_158_7987C0 = Empty
End Function

' Original declaration: Private Sub Proc_6_159_79FCD0
Public Function Proc_6_159_79FCD0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_159_79FCD0 = Empty
End Function

' Original declaration: Private  Proc_6_160_7A71A0(arg_C, arg_10, arg_14) '7A71A0
Public Function Proc_6_160_7A71A0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_160_7A71A0 = Empty
End Function

' Original declaration: Private  Proc_6_161_7B2EE0(arg_C, arg_10, arg_14, arg_18, arg_1C, arg_20, arg_24, arg_28) '7B2EE0
Public Function Proc_6_161_7B2EE0(ParamArray args() As Variant) As Variant
    Dim baseValue As Long
    Dim firstValue As Long
    Dim secondValue As Long
    Dim thirdValue As Long
    Dim fourthValue As Long
    Dim fifthValue As String
    Dim sixthValue As String
    Dim seventhValue As Long
    Dim eighthValue As Long
    Dim payload As String
    Dim encodedBase As String

    On Error GoTo BuildFailed
    If UBound(args) < 0 Then GoTo BuildFailed

    baseValue = CLng(Val(CStr(args(0))))
    If UBound(args) >= 1 Then firstValue = CLng(Val(CStr(args(1))))
    If UBound(args) >= 2 Then secondValue = CLng(Val(CStr(args(2))))
    If UBound(args) >= 3 Then thirdValue = CLng(Val(CStr(args(3))))
    If UBound(args) >= 4 Then fourthValue = CLng(Val(CStr(args(4))))
    If UBound(args) >= 5 Then fifthValue = CStr(args(5))
    If UBound(args) >= 6 Then sixthValue = CStr(args(6))
    If UBound(args) >= 7 Then seventhValue = CLng(Val(CStr(args(7))))
    If UBound(args) >= 8 Then eighthValue = CLng(Val(CStr(args(8))))

    sixthValue = Replace(sixthValue, Chr$(8), Chr$(9), 1, -1, vbBinaryCompare)
    sixthValue = Replace(sixthValue, "{{9}}", Chr$(9), 1, -1, vbBinaryCompare)

    encodedBase = CStr(Proc_3_0_6D2AF0(baseValue, Empty, "0"))
    payload = CStr(Proc_3_0_6D2AF0(firstValue, Empty, encodedBase))
    payload = "0" & CStr(Proc_3_0_6D2AF0(secondValue, Empty, payload))
    payload = "0" & CStr(Proc_3_0_6D2AF0(thirdValue, Empty, payload))
    payload = CStr(Proc_3_0_6D2AF0(fourthValue, Empty, payload)) & fifthValue & Chr$(2)
    payload = CStr(Proc_3_0_6D2AF0(seventhValue, Empty, payload)) & sixthValue & Chr$(2) & "M"
    Proc_6_161_7B2EE0 = CStr(Proc_3_0_6D2AF0(eighthValue, Empty, payload))
    Exit Function

BuildFailed:
    Proc_6_161_7B2EE0 = vbNullString
End Function

' Original declaration: Private Sub Proc_6_162_7B3310
Public Function Proc_6_162_7B3310(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim dateFormat As String
    Dim payload As String

    On Error GoTo HandshakeFailed
    socketIndex = HandlingSocketIndex(args)
    dateFormat = CStr(Proc_10_0_809570("com.system.format.date", "DAQBHHIIKHJHPAHQA", 0))
    If Len(dateFormat) = 0 Then dateFormat = "DAQBHHIIKHJHPAHQA"

    payload = "0" & dateFormat & Chr$(2) & "SAHPB" & "http://www.alpha-series.com/" & Chr$(2) & "QBH"
    Proc_6_244_801E80 socketIndex, payload, 0

HandshakeFailed:
    Proc_6_162_7B3310 = Empty
End Function

' Original declaration: Private Sub Proc_6_163_7B3480
Public Function Proc_6_163_7B3480(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_163_7B3480 = Empty
End Function

' Original declaration: Private Sub Proc_6_164_7BC820
Public Function Proc_6_164_7BC820(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_164_7BC820 = Empty
End Function

' Original declaration: Private Sub Proc_6_165_7BE0B0
Public Function Proc_6_165_7BE0B0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_165_7BE0B0 = Empty
End Function

' Original declaration: Private  Proc_6_166_7BE940(arg_C, arg_10, arg_14, arg_18, arg_1C, arg_20, arg_24, arg_28) '7BE940
Public Function Proc_6_166_7BE940(ParamArray args() As Variant) As Variant
    Dim userId As Long
    Dim userName As String
    Dim motto As String
    Dim figure As String
    Dim rankValue As Long
    Dim followCount As Long
    Dim isOnline As Long
    Dim lastOnlineText As String
    Dim relationshipState As Long
    Dim followEnabled As Long
    Dim payload As String

    On Error GoTo BuildFailed
    If UBound(args) >= 0 Then userId = CLng(Val(CStr(args(0))))
    If UBound(args) >= 1 Then userName = CStr(args(1))
    If UBound(args) >= 2 Then motto = CStr(args(2))
    If UBound(args) >= 3 Then figure = CStr(args(3))
    If UBound(args) >= 4 Then rankValue = CLng(Val(CStr(args(4))))
    If UBound(args) >= 5 Then followCount = CLng(Val(CStr(args(5))))
    If UBound(args) >= 6 Then isOnline = CLng(Val(CStr(args(6))))
    If UBound(args) >= 7 Then lastOnlineText = CStr(args(7))
    If UBound(args) >= 8 Then relationshipState = CLng(Val(CStr(args(8))))

    followEnabled = CLng(Val(CStr(Proc_10_0_809570("com.client.messenger.follow.enabled", 0, 0))))

    payload = CStr(Proc_3_0_6D2AF0(userId, Empty, "0")) & userName & Chr$(2)
    payload = CStr(Proc_3_0_6D2AF0(rankValue, Empty, payload))
    payload = CStr(Proc_3_0_6D2AF0(isOnline, Empty, payload))

    If isOnline = 1 Then
        payload = CStr(Proc_3_0_6D2AF0(IIf(followEnabled <> 0 And followCount > isOnline, 1, 0), Empty, payload)) & motto
    ElseIf isOnline = 0 Then
        payload = payload & Chr$(2) & "H" & figure & Chr$(2) & relationshipState
    End If

    Proc_6_166_7BE940 = payload & Chr$(2) & lastOnlineText & Chr$(2) & Chr$(2)
    Exit Function

BuildFailed:
    Proc_6_166_7BE940 = vbNullString
End Function

' Original declaration: Private Sub Proc_6_167_7BECA0
Public Function Proc_6_167_7BECA0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_167_7BECA0 = Empty
End Function

' Original declaration: Private Sub Proc_6_168_7C05F0
Public Function Proc_6_168_7C05F0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_168_7C05F0 = Empty
End Function

' Original declaration: Private Sub Proc_6_169_7C0DC0
Public Function Proc_6_169_7C0DC0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_169_7C0DC0 = Empty
End Function

' Original declaration: Private Sub Proc_6_170_7C1100
Public Function Proc_6_170_7C1100(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_170_7C1100 = Empty
End Function

' Original declaration: Private Sub Proc_6_171_7C1520
Public Function Proc_6_171_7C1520(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_171_7C1520 = Empty
End Function

' Original declaration: Private Sub Proc_6_172_7C25B0
Public Function Proc_6_172_7C25B0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_172_7C25B0 = Empty
End Function

' Original declaration: Private Sub Proc_6_173_7C3430
Public Function Proc_6_173_7C3430(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_173_7C3430 = Empty
End Function

' Original declaration: Private Sub Proc_6_174_7C3BC0
Public Function Proc_6_174_7C3BC0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_174_7C3BC0 = Empty
End Function

' Original declaration: Private Sub Proc_6_175_7C4800
Public Function Proc_6_175_7C4800(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_175_7C4800 = Empty
End Function

' Original declaration: Private Sub Proc_6_176_7C4EE0
Public Function Proc_6_176_7C4EE0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_176_7C4EE0 = Empty
End Function

' Original declaration: Private Sub Proc_6_177_7C6580
Public Function Proc_6_177_7C6580(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_177_7C6580 = Empty
End Function

' Original declaration: Private Sub Proc_6_178_7C6E60
Public Function Proc_6_178_7C6E60(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_178_7C6E60 = Empty
End Function

' Original declaration: Private Sub Proc_6_179_7C7790
Public Function Proc_6_179_7C7790(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_179_7C7790 = Empty
End Function

' Original declaration: Private  Proc_6_180_7C96F0(arg_C) '7C96F0
Public Function Proc_6_180_7C96F0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_180_7C96F0 = Empty
End Function

' Original declaration: Private Sub Proc_6_181_7CA920
Public Function Proc_6_181_7CA920(ParamArray args() As Variant) As Variant
    Dim candidateName As String
    Dim index As Long
    Dim characterCode As Long

    On Error GoTo ValidationFailed
    If UBound(args) < 0 Then GoTo InvalidName

    candidateName = CStr(args(0))
    If Len(candidateName) > 30 Then
        Proc_6_181_7CA920 = 1
        Exit Function
    End If
    If Len(candidateName) < 1 Then GoTo InvalidName

    For index = 1 To Len(candidateName)
        characterCode = Asc(Mid$(candidateName, index, 1))
        If Not ((characterCode >= 65 And characterCode <= 90) Or (characterCode >= 97 And characterCode <= 122)) Then
            GoTo InvalidName
        End If
    Next index

    Proc_6_181_7CA920 = 0
    Exit Function

InvalidName:
    Proc_6_181_7CA920 = 2
    Exit Function

ValidationFailed:
    Proc_6_181_7CA920 = 2
End Function

' Original declaration: Private Sub Proc_6_182_7CAAD0
Public Function Proc_6_182_7CAAD0(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim requestedName As String
    Dim validationCode As Long

    On Error GoTo CheckFailed
    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))

    Proc_10_5_809D80 packetPayload, 3, 0
    requestedName = CStr(Proc_10_7_80A190(packetPayload, 0, 0))
    requestedName = CStr(Proc_10_11_80A9C0(Proc_10_10_80A7F0(requestedName), 0, 0))
    validationCode = CLng(Val(CStr(Proc_6_181_7CA920(requestedName, 0, 0))))
    Proc_6_244_801E80 socketIndex, CStr(Proc_3_0_6D2AF0(validationCode, Empty, "@d")), 0

CheckFailed:
    Proc_6_182_7CAAD0 = Empty
End Function

' Original declaration: Private Sub Proc_6_183_7CABF0
Public Function Proc_6_183_7CABF0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_183_7CABF0 = Empty
End Function

' Original declaration: Private  Proc_6_184_7CBDA0(arg_C) '7CBDA0
Public Function Proc_6_184_7CBDA0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_184_7CBDA0 = Empty
End Function

' Original declaration: Private  Proc_6_185_7CC2D0(arg_C) '7CC2D0
Public Function Proc_6_185_7CC2D0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_185_7CC2D0 = Empty
End Function

' Original declaration: Private Sub Proc_6_186_7CD040
Public Function Proc_6_186_7CD040(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_186_7CD040 = Empty
End Function

' Original declaration: Private  Proc_6_187_7CD700(arg_C) '7CD700
Public Function Proc_6_187_7CD700(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_187_7CD700 = Empty
End Function

' Original declaration: Private Sub Proc_6_188_7CF3C0
Public Function Proc_6_188_7CF3C0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_188_7CF3C0 = Empty
End Function

' Original declaration: Private Sub Proc_6_189_7D0630
Public Function Proc_6_189_7D0630(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_189_7D0630 = Empty
End Function

' Original declaration: Private Sub Proc_6_190_7D11D0
Public Function Proc_6_190_7D11D0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_190_7D11D0 = Empty
End Function

' Original declaration: Private Sub Proc_6_191_7D18B0
Public Function Proc_6_191_7D18B0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_191_7D18B0 = Empty
End Function

' Original declaration: Private Sub Proc_6_192_7D1B80
Public Function Proc_6_192_7D1B80(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_192_7D1B80 = Empty
End Function

' Original declaration: Private Sub Proc_6_193_7D2BB0
Public Function Proc_6_193_7D2BB0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_193_7D2BB0 = Empty
End Function

' Original declaration: Private Sub Proc_6_194_7D3180
Public Function Proc_6_194_7D3180(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_194_7D3180 = Empty
End Function

' Original declaration: Private Sub Proc_6_195_7D38D0
Public Function Proc_6_195_7D38D0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_195_7D38D0 = Empty
End Function

' Original declaration: Private Sub Proc_6_196_7D3ED0
Public Function Proc_6_196_7D3ED0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_196_7D3ED0 = Empty
End Function

' Original declaration: Private Sub Proc_6_197_7D43C0
Public Function Proc_6_197_7D43C0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_197_7D43C0 = Empty
End Function

' Original declaration: Private Sub Proc_6_198_7D4B70
Public Function Proc_6_198_7D4B70(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_198_7D4B70 = Empty
End Function

' Original declaration: Private Sub Proc_6_199_7D54E0
Public Function Proc_6_199_7D54E0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_199_7D54E0 = Empty
End Function

' Original declaration: Private Sub Proc_6_200_7D5770
Public Function Proc_6_200_7D5770(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_200_7D5770 = Empty
End Function

' Original declaration: Private Sub Proc_6_201_7D5AC0
Public Function Proc_6_201_7D5AC0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_201_7D5AC0 = Empty
End Function

' Original declaration: Private Sub Proc_6_202_7D6760
Public Function Proc_6_202_7D6760(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_202_7D6760 = Empty
End Function

' Original declaration: Private Sub Proc_6_203_7D7F80
Public Function Proc_6_203_7D7F80(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim enabledValue As Long
    Dim remainingBlockTime As Long
    Dim payload As String

    On Error GoTo RecycleStatusFailed

    socketIndex = HandlingSocketIndex(args)
    enabledValue = CLng(Val(CStr(Proc_10_0_809570("com.client.catalog.recycler.enabled", 0, 0))))
    If enabledValue <> 0 Then enabledValue = 1

    ' The original subtracts com.client.catalog.recycler.block.time from a per-session
    ' recycle timestamp field. That field is still unrecovered, so report no cooldown.
    remainingBlockTime = 0
    payload = CStr(Proc_3_0_6D2AF0(enabledValue, Empty, "G{"))
    payload = CStr(Proc_3_0_6D2AF0(remainingBlockTime, Empty, payload))
    Proc_6_244_801E80 socketIndex, payload, 0

RecycleStatusFailed:
    Proc_6_203_7D7F80 = Empty
End Function

' Original declaration: Private  Proc_6_204_7D82E0(arg_C, arg_10) '7D82E0
Public Function Proc_6_204_7D82E0(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim userId As String
    Dim achievementIndex As Long
    Dim achievementId As Long
    Dim badgePrefix As String
    Dim badgeLevel As Long
    Dim badgeId As String
    Dim badgeRowId As Long
    Dim rewardIncrease As Long
    Dim scoreIncrease As Long
    Dim rewardType As Long
    Dim payload As String

    On Error GoTo RewardFailed
    If UBound(args) < 1 Then GoTo RewardFailed

    socketIndex = HandlingSocketIndex(args)
    userId = HandlingUserIdFromSocket(socketIndex)
    achievementIndex = CLng(Val(CStr(args(1))))
    If UBound(args) >= 2 Then
        badgeLevel = CLng(Val(CStr(args(2))))
    Else
        badgeLevel = 1
    End If
    If badgeLevel <= 0 Then badgeLevel = 1

    If Len(userId) = 0 Then GoTo RewardFailed
    If Not IsArray(global_008291E8) Then GoTo RewardFailed
    If achievementIndex < LBound(global_008291E8, 1) Or achievementIndex > UBound(global_008291E8, 1) Then GoTo RewardFailed

    achievementId = CLng(Val(CStr(global_008291E8(achievementIndex, 0))))
    badgePrefix = CStr(global_008291E8(achievementIndex, 1))
    rewardIncrease = CLng(Val(CStr(global_008291E8(achievementIndex, 3))))
    scoreIncrease = CLng(Val(CStr(global_008291E8(achievementIndex, 5))))
    rewardType = CLng(Val(CStr(global_008291E8(achievementIndex, 6))))
    If achievementId = 0 Or Len(badgePrefix) = 0 Then GoTo RewardFailed

    badgeId = badgePrefix & CStr(badgeLevel)
    Proc_5_0_6D3CD0 "DELETE FROM users_badges WHERE id_user='" & Proc_10_11_80A9C0(userId, 0, 0) & "' AND id_badge LIKE '" & Proc_10_11_80A9C0(badgePrefix, 0, 0) & "%' LIMIT 1", 0, 0
    Proc_5_0_6D3CD0 "INSERT INTO users_badges(id_user,id_badge) VALUES('" & Proc_10_11_80A9C0(userId, 0, 0) & "','" & Proc_10_11_80A9C0(badgeId, 0, 0) & "')", 0, 0

    badgeRowId = CLng(Val(CStr(Proc_5_2_6D4690("SELECT id FROM users_badges WHERE id_user='" & Proc_10_11_80A9C0(userId, 0, 0) & "' AND id_badge='" & Proc_10_11_80A9C0(badgeId, 0, 0) & "' ORDER BY id DESC LIMIT 1", 0, 0))))
    payload = CStr(Proc_3_0_6D2AF0(achievementIndex, Empty, "Fu"))
    payload = CStr(Proc_3_0_6D2AF0(achievementId, Empty, payload))
    payload = CStr(Proc_3_0_6D2AF0(badgeRowId, Empty, payload)) & badgeId & Chr$(2)
    payload = CStr(Proc_3_0_6D2AF0(rewardIncrease, Empty, CStr(Proc_3_0_6D2AF0(scoreIncrease, Empty, payload)))) & "HHH" & Chr$(2) & CStr(global_008291E8(achievementIndex, 4)) & Chr$(2)
    Proc_6_244_801E80 socketIndex, payload, 0

    If rewardIncrease <> 0 Or scoreIncrease <> 0 Then
        Proc_5_0_6D3CD0 "UPDATE users SET activitypoints_" & CStr(rewardType) & "=activitypoints_" & CStr(rewardType) & "+" & CStr(rewardIncrease) & ",achievement_score=achievement_score+" & CStr(scoreIncrease) & " WHERE id='" & Proc_10_11_80A9C0(userId, 0, 0) & "'", 0, 0
        Proc_6_244_801E80 socketIndex, CStr(Proc_3_0_6D2AF0(rewardType, Empty, CStr(Proc_3_0_6D2AF0(rewardIncrease, Empty, CStr(Proc_3_0_6D2AF0(scoreIncrease, Empty, "Fv")))))), 0
    End If

RewardFailed:
    Proc_6_204_7D82E0 = Empty
End Function

' Original declaration: Private  Proc_6_205_7D9780(arg_C, arg_10) '7D9780
Public Function Proc_6_205_7D9780(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_205_7D9780 = Empty
End Function

' Original declaration: Private Sub Proc_6_206_7DA450
Public Function Proc_6_206_7DA450(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_206_7DA450 = Empty
End Function

' Original declaration: Private  Proc_6_207_7DB0D0(arg_C, arg_10, arg_14, arg_18, arg_1C) '7DB0D0
Public Function Proc_6_207_7DB0D0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_207_7DB0D0 = Empty
End Function

' Original declaration: Private  Proc_6_208_7DC030(arg_C, arg_10) '7DC030
Public Function Proc_6_208_7DC030(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_208_7DC030 = Empty
End Function

' Original declaration: Private  Proc_6_209_7DE480(arg_C, arg_10) '7DE480
Public Function Proc_6_209_7DE480(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_209_7DE480 = Empty
End Function

' Original declaration: Private Sub Proc_6_210_7E1DC0
Public Function Proc_6_210_7E1DC0(ParamArray args() As Variant) As Variant
    ' Recovered empty procedure.
    Proc_6_210_7E1DC0 = Empty
End Function

' Original declaration: Private  Proc_6_211_7E1E40(arg_C) '7E1E40
Public Function Proc_6_211_7E1E40(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_211_7E1E40 = Empty
End Function

' Original declaration: Private  Proc_6_212_7E36C0(arg_C) '7E36C0
Public Function Proc_6_212_7E36C0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_212_7E36C0 = Empty
End Function

' Original declaration: Private  Proc_6_213_7E3FA0(arg_C) '7E3FA0
Public Function Proc_6_213_7E3FA0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_213_7E3FA0 = Empty
End Function

' Original declaration: Private  Proc_6_214_7E60C0(arg_C) '7E60C0
Public Function Proc_6_214_7E60C0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_214_7E60C0 = Empty
End Function

' Original declaration: Private  Proc_6_215_7E6770(arg_C) '7E6770
Public Function Proc_6_215_7E6770(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_215_7E6770 = Empty
End Function

' Original declaration: Private  Proc_6_216_7E8120(arg_C) '7E8120
Public Function Proc_6_216_7E8120(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_216_7E8120 = Empty
End Function

' Original declaration: Private  Proc_6_217_7E9780(arg_C) '7E9780
Public Function Proc_6_217_7E9780(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_217_7E9780 = Empty
End Function

' Original declaration: Private  Proc_6_218_7EA200(arg_C) '7EA200
Public Function Proc_6_218_7EA200(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_218_7EA200 = Empty
End Function

' Original declaration: Private Sub Proc_6_219_7EA390
Public Function Proc_6_219_7EA390(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_219_7EA390 = Empty
End Function

' Original declaration: Private Sub Proc_6_220_7EBA50
Public Function Proc_6_220_7EBA50(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_220_7EBA50 = Empty
End Function

' Original declaration: Private Sub Proc_6_221_7ED1E0
Public Function Proc_6_221_7ED1E0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_221_7ED1E0 = Empty
End Function

' Original declaration: Private Sub Proc_6_222_7ED710
Public Function Proc_6_222_7ED710(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_222_7ED710 = Empty
End Function

' Original declaration: Private Sub Proc_6_223_7EEDD0
Public Function Proc_6_223_7EEDD0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_223_7EEDD0 = Empty
End Function

' Original declaration: Private Sub Proc_6_224_7EF5A0
Public Function Proc_6_224_7EF5A0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_224_7EF5A0 = Empty
End Function

' Original declaration: Private Sub Proc_6_225_7EFBD0
Public Function Proc_6_225_7EFBD0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_225_7EFBD0 = Empty
End Function

' Original declaration: Private Sub Proc_6_226_7F0B20
Public Function Proc_6_226_7F0B20(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_226_7F0B20 = Empty
End Function

' Original declaration: Private Sub Proc_6_227_7F2400
Public Function Proc_6_227_7F2400(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_227_7F2400 = Empty
End Function

' Original declaration: Private Sub Proc_6_228_7F2AF0
Public Function Proc_6_228_7F2AF0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_228_7F2AF0 = Empty
End Function

' Original declaration: Private Sub Proc_6_229_7F3070
Public Function Proc_6_229_7F3070(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_229_7F3070 = Empty
End Function

' Original declaration: Private Sub Proc_6_230_7F3D20
Public Function Proc_6_230_7F3D20(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_230_7F3D20 = Empty
End Function

' Original declaration: Private Sub Proc_6_231_7F4510
Public Function Proc_6_231_7F4510(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer

    On Error GoTo SendFailed
    socketIndex = HandlingSocketIndex(args)
    Proc_6_244_801E80 socketIndex, "Ic" & "IQA", 0

SendFailed:
    Proc_6_231_7F4510 = Empty
End Function

' Original declaration: Private Sub Proc_6_232_7F45A0
Public Function Proc_6_232_7F45A0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_232_7F45A0 = Empty
End Function

' Original declaration: Private Sub Proc_6_233_7F5D60
Public Function Proc_6_233_7F5D60(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_233_7F5D60 = Empty
End Function

' Original declaration: Private Sub Proc_6_234_7F75C0
Public Function Proc_6_234_7F75C0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_234_7F75C0 = Empty
End Function

' Original declaration: Private Sub Proc_6_235_7F77E0
Public Function Proc_6_235_7F77E0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_235_7F77E0 = Empty
End Function

' Original declaration: Private Sub Proc_6_236_7F8540
Public Function Proc_6_236_7F8540(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_236_7F8540 = Empty
End Function

' Original declaration: Private Sub Proc_6_237_7F9ED0
Public Function Proc_6_237_7F9ED0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_237_7F9ED0 = Empty
End Function

' Original declaration: Private Sub Proc_6_238_7FA670
Public Function Proc_6_238_7FA670(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_238_7FA670 = Empty
End Function

' Original declaration: Private Sub Proc_6_239_7FC170
Public Function Proc_6_239_7FC170(ParamArray args() As Variant) As Variant
    Dim filePath As String
    Dim fileNumber As Integer

    On Error GoTo ReadFailed
    If UBound(args) < 0 Then GoTo ReadFailed

    filePath = CStr(args(0))
    If Len(filePath) = 0 Or Len(Dir$(filePath)) = 0 Then GoTo ReadFailed

    fileNumber = FreeFile
    Open filePath For Binary As #fileNumber
    Proc_6_239_7FC170 = Space$(LOF(fileNumber))
    Get #fileNumber, , Proc_6_239_7FC170
    Close #fileNumber
    Exit Function

ReadFailed:
    On Error Resume Next
    If fileNumber <> 0 Then Close #fileNumber
    Proc_6_239_7FC170 = vbNullString
End Function

' Original declaration: Private  Proc_6_240_7FC2B0(arg_C) '7FC2B0
Public Function Proc_6_240_7FC2B0(ParamArray args() As Variant) As Variant
    Dim filePath As String
    Dim fileText As String
    Dim fileNumber As Integer

    On Error GoTo WriteFailed
    If UBound(args) < 1 Then GoTo WriteFailed

    filePath = CStr(args(0))
    fileText = CStr(args(1))
    fileNumber = FreeFile
    Open filePath For Output As #fileNumber
    Print #fileNumber, fileText
    Close #fileNumber
    Proc_6_240_7FC2B0 = Empty
    Exit Function

WriteFailed:
    On Error Resume Next
    If fileNumber <> 0 Then Close #fileNumber
    Proc_6_240_7FC2B0 = Empty
End Function

' Original declaration: Private  Proc_6_241_7FC380(arg_C) '7FC380
Public Function Proc_6_241_7FC380(ParamArray args() As Variant) As Variant
    Dim socketIndex As Long
    Dim packetBuffer As String
    Dim packetLength As Long
    Dim packetPayload As String
    Dim packetCode As String

    On Error GoTo DispatchDone
    If UBound(args) < 1 Then GoTo DispatchDone

    socketIndex = CLng(Val(CStr(args(0))))
    packetBuffer = CStr(Proc_10_9_80A680(CStr(args(1)), 0, 0))
    If Proc_11_2_821390(socketIndex, 0, 0) <> 1 Then GoTo DispatchDone

    Do While Len(packetBuffer) > 2
        packetBuffer = Mid$(packetBuffer, 2)
        packetLength = CLng(Val(CStr(Proc_3_4_6D3620(Mid$(packetBuffer, 1, 2)))))
        If packetLength <= 0 Or Len(packetBuffer) < packetLength + 2 Then Exit Do

        packetPayload = Mid$(packetBuffer, 3, packetLength)
        packetCode = Left$(packetPayload, 2)

        If global_00829190 And Not global_00829034 Then
            Proc_2_0_6D1510 "[" & CStr(socketIndex) & "] " & packetPayload, "GAME", CStr(16711680)
        End If

        DispatchPreReadyPacket socketIndex, packetCode, packetPayload
        packetBuffer = Mid$(packetBuffer, packetLength + 3)
    Loop

DispatchDone:
    Proc_6_241_7FC380 = Empty
End Function

Private Sub DispatchPreReadyPacket(ByVal socketIndex As Long, ByVal packetCode As String, ByVal packetPayload As String)
    Select Case packetCode
        Case "oD"
            Proc_6_231_7F4510 socketIndex, packetPayload, 0
        Case "Gd"
            Proc_6_230_7F3D20 socketIndex, packetPayload, 0
        Case "C]"
            Proc_6_223_7EEDD0 socketIndex, packetPayload, 0
        Case "C" & Chr$(127)
            Proc_6_225_7EFBD0 socketIndex, packetPayload, 0
        Case "D@"
            Proc_6_226_7F0B20 socketIndex, packetPayload, 0
        Case "DC"
            Proc_6_227_7F2400 socketIndex, packetPayload, 0
            Proc_6_228_7F2AF0 socketIndex, packetPayload, 0
        Case "pa"
            Proc_6_244_801E80 socketIndex, "J|H", 0
        Case "pb"
            Proc_6_234_7F75C0 socketIndex, "pb", packetPayload
        Case "p^"
            Proc_6_232_7F45A0 socketIndex, "p^", packetPayload
        Case "pc"
            Proc_6_233_7F5D60 socketIndex, "pc", packetPayload
        Case "p]"
            Proc_6_236_7F8540 socketIndex, "p]", packetPayload
        Case "GV"
            Proc_6_38_70FD10 socketIndex, "GV", packetPayload
        Case "GW"
            Proc_6_39_711650 socketIndex, "GW", packetPayload
        Case "F]"
            Proc_6_203_7D7F80 socketIndex, "F]", packetPayload
        Case "F^"
            Proc_6_202_7D6760 socketIndex, "F^", packetPayload
        Case "EW"
            Proc_6_99_748460 socketIndex, "EW", packetPayload
        Case "EV"
            Proc_6_100_748C80 socketIndex, "EV", packetPayload
        Case "EU"
            Proc_6_98_747D80 socketIndex, "EU", packetPayload
        Case "Er"
            Proc_6_206_7DA450 socketIndex, "Er", packetPayload
        Case "@G"
            Proc_6_237_7F9ED0 socketIndex, "@G", packetPayload
        Case "Cd"
            Proc_6_101_749540 socketIndex, "EA", packetPayload
        Case "@Z"
            Proc_6_19_6E8040 socketIndex, global_0082912C, "Gz"
        Case "oW"
            Proc_6_18_6E7480 socketIndex, "GY", packetPayload
        Case "GE"
            Proc_6_32_70EAB0 socketIndex, "GE", packetPayload
        Case "F`"
            Proc_6_33_70F4F0 socketIndex
        Case "Fa"
            Proc_6_34_70F590 socketIndex
        Case "Fb"
            Proc_6_37_70FC20 socketIndex, "Fb", packetPayload
        Case "Fc"
            Proc_6_36_70F7B0 socketIndex, "Fc", packetPayload
        Case "Fd"
            Proc_6_35_70F630 socketIndex, "Fd", packetPayload
        Case "FC"
            Proc_6_104_74AB60 socketIndex, "FC", packetPayload
        Case "Af"
            Proc_6_136_765F10 socketIndex, "Af", packetPayload
        Case "oC"
            Proc_6_135_765D80 socketIndex, "oC", packetPayload
        Case "oV"
            Proc_6_134_765B90 socketIndex, "oV", packetPayload
        Case "Ad"
            Proc_6_128_756190 socketIndex, "Ad", packetPayload
        Case "GX"
            Proc_6_132_75D4A0 socketIndex, "GX", packetPayload
        Case "GZ"
            Proc_6_131_75C700 socketIndex, "GZ", packetPayload
        Case "G["
            Proc_6_130_75B770 socketIndex, "G[", packetPayload
        Case "Gc"
            Proc_6_107_74B7E0 socketIndex, "Gc", packetPayload
        Case "GG"
            Proc_6_47_714F60 socketIndex, "GG", packetPayload
        Case "FB"
            Proc_6_44_7145E0 socketIndex, "FB", packetPayload
        Case "EZ"
            Proc_6_48_7151E0 socketIndex, "EZ", packetPayload
        Case "E\"
            Proc_6_49_715D30 socketIndex, "E\", packetPayload
        Case "@H"
            Proc_6_108_74D800 socketIndex, "@H", packetPayload
        Case "@S"
            Proc_6_110_74DDA0 socketIndex, "@S", packetPayload
        Case "@T"
            Proc_6_109_74DBD0 socketIndex, "@T", packetPayload
        Case "BW"
            Proc_6_111_74DF70 socketIndex, "BW", packetPayload
        Case "GI"
            Proc_5_4_6D55E0 socketIndex, "GI", packetPayload
        Case "GH"
            Proc_5_5_6D64D0 socketIndex, "GH", packetPayload
        Case "GK"
            Proc_5_6_6D7090 socketIndex, "GK", packetPayload
        Case "GF"
            Proc_6_0_6D7FF0 socketIndex, "GF", packetPayload
        Case "GM"
            Proc_6_1_6D8B70 socketIndex, "GM", packetPayload
        Case "GO"
            Proc_6_2_6D9880 socketIndex, "GO", packetPayload
        Case "GP"
            Proc_6_3_6DA490 socketIndex, "GP", packetPayload
        Case "GB"
            Proc_6_6_6DC9D0 socketIndex, "GB", packetPayload
        Case "GC"
            Proc_6_8_6DD790 socketIndex, "GC", packetPayload
        Case "GD"
            Proc_6_7_6DD0E0 socketIndex, "GD", packetPayload
        Case "Fw"
            Proc_6_115_751220 socketIndex, "Fw", packetPayload
        Case "Fn"
            Proc_6_116_751550 socketIndex, "Fn", packetPayload
        Case "Fr"
            Proc_6_121_752080 socketIndex, "Fr", packetPayload
        Case "Fq"
            Proc_6_117_751880 socketIndex, "Fq", packetPayload
        Case "Fp"
            Proc_6_118_751A80 socketIndex, "Fp", packetPayload
        Case "Fs"
            Proc_6_119_751C80 socketIndex, "Fs", packetPayload
        Case "Fo"
            Proc_6_126_755B40 socketIndex, "Fo", packetPayload
        Case "Ft"
            Proc_6_120_751E80 socketIndex, "Ft", packetPayload
        Case "E|"
            Proc_6_123_754020 socketIndex, "E|", packetPayload
        Case "Fu"
            Proc_6_127_755D30 socketIndex, "Fu", packetPayload
        Case "E~"
            Proc_6_124_754D90 socketIndex, "E~", packetPayload
        Case "EY"
            Proc_6_46_714D50 socketIndex, "EY", packetPayload
        Case "E["
            Proc_6_45_714B60 socketIndex, "E[", packetPayload
        Case "A_"
            Proc_6_61_720490 socketIndex, "A_", packetPayload
        Case "E@"
            Proc_6_62_7209F0 socketIndex, "E@", packetPayload
        Case "DE"
            Proc_6_63_721050 socketIndex, "DE", packetPayload
        Case "D" & Chr$(127)
            Proc_6_64_721650 socketIndex, "D" & Chr$(127), packetPayload
        Case "EB"
            Proc_6_75_7269D0 socketIndex, "EB", packetPayload
        Case "Aa"
            Proc_6_74_7265B0 socketIndex, "Aa", packetPayload
        Case "B["
            Proc_6_71_724CF0 socketIndex, "B[", packetPayload
        Case "Es"
            Proc_6_76_726CE0 socketIndex, "Es", packetPayload
        Case "FD"
            Proc_6_77_727590 socketIndex, "FD", packetPayload
        Case "A`"
            Proc_6_65_721A10 socketIndex, "A`", packetPayload
        Case "FA"
            Proc_6_60_720060 socketIndex, "FA", packetPayload
        Case "oL", "CD"
            ' Decompiled targets Proc_7F44D0 and Proc_7FA5A0 were not generated as valid symbols.
    End Select
End Sub

' Original declaration: Private Sub Proc_6_242_7FF0D0
Public Function Proc_6_242_7FF0D0(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim userId As String

    On Error GoTo CleanupFailed

    socketIndex = HandlingSocketIndex(args)
    userId = HandlingUserIdFromSocket(socketIndex)
    If Len(userId) > 0 And userId <> "0" Then
        Proc_5_0_6D3CD0 "UPDATE users SET id_socket=null WHERE id = '" & Proc_10_11_80A9C0(userId, 0, 0) & "'", 0, 0
    End If

CleanupFailed:
    Proc_6_242_7FF0D0 = Empty
End Function

' Original declaration: Private Sub Proc_6_243_7FFEB0
Public Function Proc_6_243_7FFEB0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_243_7FFEB0 = Empty
End Function

' Original declaration: Private  Proc_6_244_801E80(arg_C) '801E80
Public Function Proc_6_244_801E80(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim payload As String

    On Error GoTo SendFailed
    If UBound(args) < 1 Then GoTo SendFailed

    socketIndex = CInt(Val(CStr(args(0))))
    If socketIndex = 0 Then GoTo SendFailed
    If Proc_11_2_821390(socketIndex, 0, 0) <> 1 Then GoTo SendFailed
    If IsSocketMarkedBusy(socketIndex) Then GoTo SendFailed

    payload = CStr(args(1)) & Chr$(1)
    Proc_12_1_821AA0 socketIndex, payload, 0

SendFailed:
    Proc_6_244_801E80 = Empty
End Function

' Original declaration: Private  Proc_6_245_801FA0(arg_C) '801FA0
Public Function Proc_6_245_801FA0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_245_801FA0 = Empty
End Function

' Original declaration: Private  Proc_6_246_8024C0(arg_C) '8024C0
Public Function Proc_6_246_8024C0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_246_8024C0 = Empty
End Function

' Original declaration: Private  Proc_6_247_8027E0(arg_C) '8027E0
Public Function Proc_6_247_8027E0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_247_8027E0 = Empty
End Function

' Original declaration: Private  Proc_6_248_802B80(arg_C) '802B80
Public Function Proc_6_248_802B80(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_248_802B80 = Empty
End Function

' Original declaration: Private Sub Proc_6_249_802F10
Public Function Proc_6_249_802F10(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_249_802F10 = Empty
End Function

Private Function HandlingSocketIndex(ByRef args() As Variant) As Integer
    On Error GoTo DefaultIndex
    If UBound(args) >= 0 Then
        HandlingSocketIndex = CInt(Val(CStr(args(0))))
        Exit Function
    End If

DefaultIndex:
    HandlingSocketIndex = 0
End Function

Private Function HandlingUserIdFromSocket(ByVal socketIndex As Integer) As String
    Dim recordText As String
    Dim marker As String
    Dim startAt As Long
    Dim endAt As Long
    Dim fields() As String

    On Error GoTo LookupFailed

    If Len(global_00829268) > 0 Then
        marker = "[1:" & CStr(socketIndex) & Chr$(1)
        startAt = InStr(1, global_00829268, marker, vbTextCompare)
        If startAt > 0 Then
            startAt = startAt + Len(marker)
            endAt = InStr(startAt, global_00829268, "]", vbBinaryCompare)
            If endAt = 0 Then endAt = Len(global_00829268) + 1

            recordText = Mid$(global_00829268, startAt, endAt - startAt)
            fields = Split(recordText, Chr$(2))
            If UBound(fields) >= 0 Then
                HandlingUserIdFromSocket = CStr(Val(CStr(fields(0))))
                If Len(HandlingUserIdFromSocket) > 0 And HandlingUserIdFromSocket <> "0" Then Exit Function
            End If
        End If
    End If

    HandlingUserIdFromSocket = CStr(Val(CStr(Proc_5_2_6D4690("SELECT id FROM users WHERE id_socket='" & CStr(socketIndex) & "' LIMIT 1", 0, 0))))
    Exit Function

LookupFailed:
    HandlingUserIdFromSocket = vbNullString
End Function

Private Function RoomKickOrBanUser(ByRef args() As Variant, ByVal addRoomBan As Boolean) As Variant
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim requestPayload As String
    Dim callerUserId As String
    Dim targetUserId As String
    Dim callerRoomId As Long
    Dim targetRoomId As Long
    Dim targetSocketIndex As Integer
    Dim offset As Long

    On Error GoTo KickFailed

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    If Len(packetPayload) = 0 And UBound(args) >= 1 Then packetPayload = CStr(args(1))

    requestPayload = packetPayload
    If Left$(requestPayload, 2) = "A_" Or Left$(requestPayload, 2) = "E@" Then requestPayload = Mid$(requestPayload, 3)

    offset = 1
    targetUserId = CStr(ReadWireLong(requestPayload, offset))
    If Len(targetUserId) = 0 Or targetUserId = "0" Then GoTo KickFailed

    callerUserId = HandlingUserIdFromSocket(socketIndex)
    If Len(callerUserId) = 0 Or callerUserId = "0" Then GoTo KickFailed

    callerRoomId = HandlingCurrentRoomId(socketIndex, callerUserId)
    If callerRoomId <= 0 Then GoTo KickFailed

    targetSocketIndex = HandlingSocketFromUserId(targetUserId)
    If targetSocketIndex <= 0 Then GoTo KickFailed

    targetRoomId = HandlingCurrentRoomId(targetSocketIndex, targetUserId)
    If targetRoomId <> callerRoomId Then GoTo KickFailed

    If Not HandlingUserHasPermission(callerUserId, "fuse_kick") Then GoTo KickFailed
    If HandlingUserHasPermission(targetUserId, "fuse_unkickable") Then GoTo KickFailed

    Proc_6_244_801E80 targetSocketIndex, "@a" & "XjO", 0
    Proc_6_53_718E00 targetSocketIndex, "@a" & "XjO", 0

    If addRoomBan Then
        Proc_5_0_6D3CD0 "INSERT IGNORE INTO rooms_bans(id_room,id_user,timestamp_expire) VALUES('" & CStr(callerRoomId) & "','" & Proc_10_11_80A9C0(targetUserId, 0, 0) & "',UNIX_TIMESTAMP()+900)", 0, 0
    End If

KickFailed:
    RoomKickOrBanUser = Empty
End Function

Private Function HandlingCurrentRoomId(ByVal socketIndex As Integer, ByVal userId As String) As Long
    Dim roomId As Long

    On Error GoTo LookupFailed

    roomId = CLng(Val(CStr(Proc_9_10_808F30(CStr(socketIndex), 1, 0))))
    If roomId > 0 Then
        HandlingCurrentRoomId = roomId
        Exit Function
    End If

    roomId = CLng(Val(CStr(Proc_5_2_6D4690("SELECT id_room FROM logs_visitedrooms WHERE id_user='" & Proc_10_11_80A9C0(userId, 0, 0) & "' AND timestamp_left IS NULL ORDER BY timestamp_enter DESC LIMIT 1", 0, 0))))
    If roomId <= 0 Then roomId = CLng(Val(CStr(Proc_5_2_6D4690("SELECT id FROM rooms WHERE id_slot='" & CStr(socketIndex) & "' LIMIT 1", 0, 0))))

    HandlingCurrentRoomId = roomId
    Exit Function

LookupFailed:
    HandlingCurrentRoomId = 0
End Function

Private Function HandlingSocketFromUserId(ByVal userId As String) As Integer
    Dim socketIndex As Integer

    On Error GoTo LookupFailed

    socketIndex = CInt(Val(CStr(Proc_9_8_8086A0(userId, 0, 0))))
    If socketIndex <= 0 Then
        socketIndex = CInt(Val(CStr(Proc_5_2_6D4690("SELECT id_socket FROM users WHERE id='" & Proc_10_11_80A9C0(userId, 0, 0) & "' LIMIT 1", 0, 0))))
    End If

    HandlingSocketFromUserId = socketIndex
    Exit Function

LookupFailed:
    HandlingSocketFromUserId = 0
End Function

Private Function HandlingUserHasRoomRight(ByVal userId As String, ByVal roomId As Long) As Boolean
    Dim rightUserId As String

    On Error GoTo CheckFailed
    If Len(userId) = 0 Or userId = "0" Or roomId <= 0 Then GoTo CheckFailed

    rightUserId = CStr(Proc_5_2_6D4690("SELECT id_owner FROM rooms WHERE id='" & CStr(roomId) & "' AND id_owner='" & Proc_10_11_80A9C0(userId, 0, 0) & "' LIMIT 1", 0, 0))
    If Len(rightUserId) > 0 Then
        HandlingUserHasRoomRight = True
        Exit Function
    End If

    rightUserId = CStr(Proc_5_2_6D4690("SELECT id_user FROM rooms_rights WHERE id_user='" & Proc_10_11_80A9C0(userId, 0, 0) & "' AND id_room='" & CStr(roomId) & "' LIMIT 1", 0, 0))
    HandlingUserHasRoomRight = (Len(rightUserId) > 0)
    Exit Function

CheckFailed:
    HandlingUserHasRoomRight = False
End Function

Private Function HandlingUserOwnsRoom(ByVal userId As String, ByVal roomId As Long) As Boolean
    Dim ownerUserId As String

    On Error GoTo CheckFailed
    If Len(userId) = 0 Or userId = "0" Or roomId <= 0 Then GoTo CheckFailed

    ownerUserId = CStr(Proc_5_2_6D4690("SELECT id_owner FROM rooms WHERE id='" & CStr(roomId) & "' AND id_owner='" & Proc_10_11_80A9C0(userId, 0, 0) & "' LIMIT 1", 0, 0))
    HandlingUserOwnsRoom = (Len(ownerUserId) > 0)
    Exit Function

CheckFailed:
    HandlingUserOwnsRoom = False
End Function

Private Function HandlingUserRank(ByVal userId As String) As Long
    On Error GoTo LookupFailed
    HandlingUserRank = CLng(Val(CStr(Proc_5_2_6D4690("SELECT level FROM users WHERE id='" & Proc_10_11_80A9C0(userId, 0, 0) & "' LIMIT 1", 0, 0))))
    If HandlingUserRank < 0 Then HandlingUserRank = 0
    If HandlingUserRank > 20 Then HandlingUserRank = 20
    Exit Function

LookupFailed:
    HandlingUserRank = 0
End Function

Private Function HandlingUserHcLevel(ByVal userId As String) As Long
    On Error GoTo LookupFailed
    HandlingUserHcLevel = CLng(Val(CStr(Proc_5_2_6D4690("SELECT level_hc FROM users WHERE id='" & Proc_10_11_80A9C0(userId, 0, 0) & "' LIMIT 1", 0, 0))))
    If HandlingUserHcLevel < 0 Then HandlingUserHcLevel = 0
    If HandlingUserHcLevel > 2 Then HandlingUserHcLevel = 2
    Exit Function

LookupFailed:
    HandlingUserHcLevel = 0
End Function

Private Function HandlingUserHasPermission(ByVal userId As String, ByVal permissionName As String) As Boolean
    Dim rankIndex As Long
    Dim hcLevel As Long

    On Error GoTo CheckFailed

    rankIndex = HandlingUserRank(userId)
    hcLevel = HandlingUserHcLevel(userId)
    HandlingUserHasPermission = CBool(Proc_10_1_809790(rankIndex, vbNullString, permissionName, hcLevel))
    Exit Function

CheckFailed:
    HandlingUserHasPermission = False
End Function

Private Function StaffModerationPayload(ByVal rankIndex As Long, ByVal hcLevel As Long) As String
    On Error GoTo MissingPayload
    If rankIndex < 0 Then rankIndex = 0
    If rankIndex > 20 Then rankIndex = 20
    If hcLevel < 0 Then hcLevel = 0
    If hcLevel > 2 Then hcLevel = 2
    If IsArray(global_008292D8) Then StaffModerationPayload = CStr(global_008292D8(rankIndex, hcLevel))
    Exit Function

MissingPayload:
    StaffModerationPayload = vbNullString
End Function

Private Function CallForHelpRowPayload(ByRef fields() As String) As String
    Dim cfhId As Long
    Dim callerId As Long
    Dim partnerId As Long
    Dim roomId As Long
    Dim categoryId As Long
    Dim pickerId As Long
    Dim callerName As String
    Dim partnerName As String
    Dim roomName As String
    Dim descriptionText As String
    Dim pickerName As String

    On Error GoTo BuildFailed

    cfhId = CLng(Val(HandlingField(fields, 0)))
    callerId = CLng(Val(HandlingField(fields, 2)))
    callerName = HandlingField(fields, 3)
    partnerId = CLng(Val(HandlingField(fields, 4)))
    roomId = CLng(Val(HandlingField(fields, 5)))
    categoryId = CLng(Val(HandlingField(fields, 6)))
    descriptionText = HandlingField(fields, 7)
    roomName = HandlingField(fields, 9)
    pickerId = CLng(Val(HandlingField(fields, 10)))

    If partnerId > 0 Then partnerName = CStr(Proc_5_2_6D4690("SELECT name FROM users WHERE id='" & CStr(partnerId) & "' LIMIT 1", 0, 0))
    If pickerId > 0 Then pickerName = CStr(Proc_5_2_6D4690("SELECT name FROM users WHERE id='" & CStr(pickerId) & "' LIMIT 1", 0, 0))

    CallForHelpRowPayload = CStr(Proc_6_29_70D800(0, 0, categoryId, callerId, callerName, partnerId, partnerName, descriptionText, roomId, roomName, cfhId, pickerName))
    Exit Function

BuildFailed:
    CallForHelpRowPayload = vbNullString
End Function

Private Function StaffCallForHelpWhereClause(ByVal packetPayload As String, ByRef offset As Long) As String
    Dim requestedCount As Long
    Dim index As Long
    Dim callForHelpId As Long
    Dim whereClause As String

    On Error GoTo BuildFailed

    requestedCount = ReadWireLong(packetPayload, offset)
    If requestedCount < 1 Or requestedCount > 150 Then GoTo BuildFailed

    For index = 1 To requestedCount
        callForHelpId = ReadWireLong(packetPayload, offset)
        If callForHelpId > 0 Then
            If Len(whereClause) > 0 Then whereClause = whereClause & " OR "
            whereClause = whereClause & "id='" & CStr(callForHelpId) & "'"
        End If
    Next index

    StaffCallForHelpWhereClause = whereClause
    Exit Function

BuildFailed:
    StaffCallForHelpWhereClause = vbNullString
End Function

Private Function StaffUserSummaryPayload(ByRef fields() As String) As String
    Dim userId As Long
    Dim userName As String
    Dim createdMinutes As Long
    Dim lastOnlineMinutes As Long
    Dim socketIndex As Long
    Dim callForHelpCount As Long
    Dim pickedCallForHelpCount As Long
    Dim cautionCount As Long
    Dim banCount As Long
    Dim payload As String

    On Error GoTo BuildFailed

    userId = CLng(Val(HandlingField(fields, 0)))
    userName = HandlingField(fields, 1)
    createdMinutes = CLng(Val(HandlingField(fields, 2)))
    lastOnlineMinutes = CLng(Val(HandlingField(fields, 3)))
    socketIndex = CLng(Val(HandlingField(fields, 4)))

    callForHelpCount = CLng(Val(CStr(Proc_5_2_6D4690("SELECT COUNT(id) FROM staff_cfh WHERE id_user='" & CStr(userId) & "'", 0, 0))))
    pickedCallForHelpCount = CLng(Val(CStr(Proc_5_2_6D4690("SELECT COUNT(id) FROM staff_cfh WHERE id_user='" & CStr(userId) & "' AND id_closed='2'", 0, 0))))
    cautionCount = CLng(Val(CStr(Proc_5_2_6D4690("SELECT COUNT(id) FROM users_cautions WHERE id_user='" & CStr(userId) & "'", 0, 0))))
    banCount = CLng(Val(CStr(Proc_5_2_6D4690("SELECT COUNT(id) FROM users_bans WHERE id_user='" & CStr(userId) & "'", 0, 0))))

    payload = CStr(Proc_3_0_6D2AF0(userId, Empty, "HU")) & userName & Chr$(2)
    payload = CStr(Proc_3_0_6D2AF0(createdMinutes, Empty, payload))
    payload = CStr(Proc_3_0_6D2AF0(lastOnlineMinutes, Empty, payload))
    payload = CStr(Proc_3_0_6D2AF0(IIf(socketIndex > 0, 1, 0), Empty, payload))
    payload = CStr(Proc_3_0_6D2AF0(callForHelpCount, Empty, payload))
    payload = CStr(Proc_3_0_6D2AF0(pickedCallForHelpCount, Empty, payload))
    payload = CStr(Proc_3_0_6D2AF0(cautionCount, Empty, payload))
    StaffUserSummaryPayload = CStr(Proc_3_0_6D2AF0(banCount, Empty, payload))
    Exit Function

BuildFailed:
    StaffUserSummaryPayload = vbNullString
End Function

Private Function ContainsUnsafeStaffAlert(ByVal messageText As String) As Boolean
    Dim lowered As String

    lowered = LCase$(messageText)
    ContainsUnsafeStaffAlert = (InStr(1, lowered, "cookie", vbBinaryCompare) > 0 And InStr(1, lowered, "javascript:", vbBinaryCompare) > 0)
End Function

Private Function HandlingField(ByRef fields() As String, ByVal fieldIndex As Long) As String
    On Error GoTo MissingField
    If fieldIndex < LBound(fields) Or fieldIndex > UBound(fields) Then GoTo MissingField
    HandlingField = CStr(fields(fieldIndex))
    Exit Function

MissingField:
    HandlingField = vbNullString
End Function

Private Function ReadWireString(ByVal packetPayload As String, ByRef offset As Long) As String
    Dim fieldLength As Long

    On Error GoTo ReadFailed
    If offset < 1 Then offset = 1
    If offset + 1 > Len(packetPayload) Then GoTo ReadFailed

    fieldLength = CLng(Proc_3_4_6D3620(Mid$(packetPayload, offset), 0, 0))
    If fieldLength <= 0 Then GoTo ReadFailed

    ReadWireString = Mid$(packetPayload, offset + 2, fieldLength)
    offset = offset + 2 + fieldLength
    Exit Function

ReadFailed:
    ReadWireString = vbNullString
End Function

Private Function ReadWireLong(ByVal packetPayload As String, ByRef offset As Long) As Long
    Dim remainingPayload As String
    Dim encodedLengthSize As Long

    On Error GoTo ReadFailed
    If offset < 1 Then offset = 1
    If offset > Len(packetPayload) Then GoTo ReadFailed

    remainingPayload = Mid$(packetPayload, offset)
    encodedLengthSize = CLng(Proc_3_2_6D30A0(remainingPayload, 0, 0))
    If encodedLengthSize <= 0 Then GoTo ReadFailed

    ReadWireLong = CLng(Val(CStr(Proc_3_3_6D3240(remainingPayload, 0, 0))))
    offset = offset + encodedLengthSize
    Exit Function

ReadFailed:
    ReadWireLong = 0
End Function

Private Function RoomIconPayloadFromWire(ByVal packetPayload As String) As String
    Dim offset As Long
    Dim backgroundId As Long
    Dim foregroundId As Long
    Dim itemCount As Long
    Dim itemIndex As Long
    Dim itemType As Long
    Dim itemPosition As Long
    Dim payload As String
    Dim previousOffset As Long

    On Error GoTo BuildFailed

    offset = 1
    previousOffset = offset
    backgroundId = ReadWireLong(packetPayload, offset)
    If offset <= previousOffset Then GoTo BuildFailed
    If backgroundId < 0 Or backgroundId > 24 Then GoTo BuildFailed

    previousOffset = offset
    foregroundId = ReadWireLong(packetPayload, offset)
    If offset <= previousOffset Then GoTo BuildFailed
    If foregroundId < 0 Or foregroundId > 11 Then GoTo BuildFailed

    previousOffset = offset
    itemCount = ReadWireLong(packetPayload, offset)
    If offset <= previousOffset Then GoTo BuildFailed
    If itemCount < 0 Or itemCount > 12 Then GoTo BuildFailed

    payload = CStr(Proc_3_0_6D2AF0(backgroundId, Empty, vbNullString))
    payload = CStr(Proc_3_0_6D2AF0(foregroundId, Empty, payload))
    payload = CStr(Proc_3_0_6D2AF0(itemCount, Empty, payload))

    For itemIndex = 1 To itemCount
        previousOffset = offset
        itemType = ReadWireLong(packetPayload, offset)
        If offset <= previousOffset Then GoTo BuildFailed
        If itemType < 0 Then GoTo BuildFailed

        previousOffset = offset
        itemPosition = ReadWireLong(packetPayload, offset)
        If offset <= previousOffset Then GoTo BuildFailed
        If itemPosition < 0 Then GoTo BuildFailed

        payload = CStr(Proc_3_0_6D2AF0(itemType, Empty, payload))
        payload = CStr(Proc_3_0_6D2AF0(itemPosition, Empty, payload))
    Next itemIndex

    RoomIconPayloadFromWire = payload
    Exit Function

BuildFailed:
    RoomIconPayloadFromWire = vbNullString
End Function

Private Function RoomEventCreatePayloadFromWire(ByVal packetPayload As String, ByRef categoryId As Long, ByRef categoryName As String, ByRef eventName As String, ByRef eventDescription As String, ByRef tagOne As String, ByRef tagTwo As String) As Boolean
    Dim offset As Long
    Dim tagCount As Long
    Dim tagIndex As Long
    Dim tagText As String

    On Error GoTo ParseFailed

    offset = 1
    categoryId = ReadWireLong(packetPayload, offset)
    If categoryId < 1 Then GoTo ParseFailed

    categoryName = CStr(Proc_8_11_8069B0(categoryId, 0, 0))
    If Len(categoryName) = 0 Then GoTo ParseFailed

    eventName = CStr(Proc_10_10_80A7F0(ReadWireString(packetPayload, offset), 0, 0))
    If Len(eventName) < 3 Then GoTo ParseFailed

    eventDescription = CStr(Proc_10_10_80A7F0(ReadWireString(packetPayload, offset), 0, 0))
    If Len(eventDescription) < 3 Then GoTo ParseFailed

    tagCount = ReadWireLong(packetPayload, offset)
    If tagCount < 0 Or tagCount > 2 Then GoTo ParseFailed

    For tagIndex = 1 To tagCount
        tagText = LCase$(Left$(CStr(Proc_10_10_80A7F0(ReadWireString(packetPayload, offset), 0, 0)), 30))
        If tagIndex = 1 Then
            tagOne = tagText
        ElseIf tagIndex = 2 Then
            tagTwo = tagText
        End If
    Next tagIndex

    RoomEventCreatePayloadFromWire = True
    Exit Function

ParseFailed:
    RoomEventCreatePayloadFromWire = False
End Function

Private Function RoomEventEditPayloadFromWire(ByVal packetPayload As String, ByRef eventName As String, ByRef eventDescription As String, ByRef tagOne As String, ByRef tagTwo As String) As Boolean
    Dim offset As Long
    Dim tagCount As Long
    Dim tagIndex As Long
    Dim tagText As String

    On Error GoTo ParseFailed

    offset = 1
    eventName = CStr(Proc_10_10_80A7F0(ReadWireString(packetPayload, offset), 0, 0))
    If Len(eventName) < 3 Then GoTo ParseFailed

    eventDescription = CStr(Proc_10_10_80A7F0(ReadWireString(packetPayload, offset), 0, 0))
    If Len(eventDescription) < 3 Then GoTo ParseFailed

    tagCount = ReadWireLong(packetPayload, offset)
    If tagCount < 0 Or tagCount > 2 Then GoTo ParseFailed

    For tagIndex = 1 To tagCount
        tagText = LCase$(Left$(CStr(Proc_10_10_80A7F0(ReadWireString(packetPayload, offset), 0, 0)), 30))
        If tagIndex = 1 Then
            tagOne = tagText
        ElseIf tagIndex = 2 Then
            tagTwo = tagText
        End If
    Next tagIndex

    RoomEventEditPayloadFromWire = True
    Exit Function

ParseFailed:
    RoomEventEditPayloadFromWire = False
End Function

Private Function NullableSqlText(ByVal valueText As String) As String
    If Len(valueText) = 0 Then
        NullableSqlText = "null"
    Else
        NullableSqlText = "'" & Proc_10_11_80A9C0(valueText, 0, 0) & "'"
    End If
End Function

Private Function NavigatorListLimit() As Long
    NavigatorListLimit = CLng(Val(CStr(Proc_10_0_809570("com.client.navigator.list.limit", 50, 0))))
    If NavigatorListLimit <= 0 Then NavigatorListLimit = 50
End Function

Private Function NavigatorSearchTerm(ByVal rawText As String) As String
    Dim escapedText As String

    escapedText = CStr(Proc_10_11_80A9C0(rawText, 0, 0))
    NavigatorSearchTerm = Replace(escapedText, "%", vbNullString)
End Function

Private Function RecommendedRoomPayload(ByVal treeIndex As Long) As String
    On Error GoTo NoPayload

    If Not IsArray(global_0082911C) Then GoTo NoPayload
    If treeIndex > 0 Then treeIndex = treeIndex - 1
    If treeIndex < LBound(global_0082911C) Or treeIndex > UBound(global_0082911C) Then GoTo NoPayload

    RecommendedRoomPayload = CStr(global_0082911C(treeIndex))
    Exit Function

NoPayload:
    RecommendedRoomPayload = vbNullString
End Function

Private Function NavigatorRoomListPayload(ByVal queryTail As String, ByVal includeEventTime As Boolean) As String
    Dim queryText As String
    Dim rowText As String
    Dim rows() As String
    Dim fields() As String
    Dim rowIndex As Long
    Dim roomCount As Long
    Dim payload As String

    On Error GoTo BuildFailed

    If Len(queryTail) = 0 Then GoTo BuildDone
    queryText = "SELECT rooms.id,rooms.name,users.name,rooms.status_door,rooms.visitors_now,rooms.visitors_max,rooms.description,rooms_categories.has_trading,NULL,rooms.rate,rooms.id_category,rooms.icon,rooms.tag_1,rooms.tag_2,rooms.allow_otherspets,rooms.is_staff_picked FROM " & queryTail
    rowText = CStr(Proc_5_2_6D4690(queryText, 0, 0))
    If Len(rowText) = 0 Then GoTo BuildDone

    rows = Split(rowText, Chr$(13))
    For rowIndex = LBound(rows) To UBound(rows)
        If Len(rows(rowIndex)) > 0 Then
            fields = Split(rows(rowIndex), Chr$(9))
            payload = payload & NavigatorRoomFragment(fields)
            roomCount = roomCount + 1
        End If
    Next rowIndex

BuildDone:
    NavigatorRoomListPayload = CStr(Proc_3_0_6D2AF0(roomCount, Empty, payload))
    Exit Function

BuildFailed:
    NavigatorRoomListPayload = CStr(Proc_3_0_6D2AF0(0, Empty, vbNullString))
End Function

Private Function SingleNavigatorRoomPayload(ByVal queryTail As String) As String
    Dim listPayload As String
    Dim singleCountPrefix As String

    On Error GoTo BuildFailed

    listPayload = NavigatorRoomListPayload(queryTail, False)
    singleCountPrefix = CStr(Proc_3_0_6D2AF0(1, Empty, vbNullString))
    If Left$(listPayload, Len(singleCountPrefix)) = singleCountPrefix Then
        SingleNavigatorRoomPayload = Mid$(listPayload, Len(singleCountPrefix) + 1)
    Else
        SingleNavigatorRoomPayload = vbNullString
    End If
    Exit Function

BuildFailed:
    SingleNavigatorRoomPayload = vbNullString
End Function

Private Function NavigatorEventListPayload(ByVal queryTail As String) As String
    Dim queryText As String
    Dim rowText As String
    Dim rows() As String
    Dim fields() As String
    Dim rowIndex As Long
    Dim eventCount As Long
    Dim payload As String

    On Error GoTo BuildFailed

    If Len(queryTail) = 0 Then GoTo BuildDone
    queryText = "SELECT rooms.id,rooms_events.name,users.name,rooms.status_door,rooms.visitors_now,rooms.visitors_max,rooms_events.description,rooms_categories.has_trading,NULL,rooms.rate,rooms_events.id_category,rooms.icon,rooms_events.tag_1,rooms_events.tag_2,DATE_FORMAT(FROM_UNIXTIME(rooms_events.timestamp), '" & CStr(Proc_10_0_809570("com.mysql.format.time", "%H:%i", 0)) & "') FROM " & queryTail
    rowText = CStr(Proc_5_2_6D4690(queryText, 0, 0))
    If Len(rowText) = 0 Then GoTo BuildDone

    rows = Split(rowText, Chr$(13))
    For rowIndex = LBound(rows) To UBound(rows)
        If Len(rows(rowIndex)) > 0 Then
            fields = Split(rows(rowIndex), Chr$(9))
            payload = payload & NavigatorEventFragment(fields)
            eventCount = eventCount + 1
        End If
    Next rowIndex

BuildDone:
    NavigatorEventListPayload = CStr(Proc_3_0_6D2AF0(eventCount, Empty, payload))
    Exit Function

BuildFailed:
    NavigatorEventListPayload = CStr(Proc_3_0_6D2AF0(0, Empty, vbNullString))
End Function

Private Function NavigatorCombinedRoomListPayload(ByVal eventQueryTail As String, ByVal roomQueryTail As String) As String
    Dim eventQueryText As String
    Dim roomQueryText As String
    Dim rowText As String
    Dim rows() As String
    Dim fields() As String
    Dim rowIndex As Long
    Dim itemCount As Long
    Dim payload As String

    On Error GoTo BuildFailed

    If Len(eventQueryTail) > 0 Then
        eventQueryText = "SELECT rooms.id,rooms_events.name,users.name,rooms.status_door,rooms.visitors_now,rooms.visitors_max,rooms_events.description,rooms_categories.has_trading,rooms.allow_otherspets,rooms.rate,rooms_events.id_category,rooms.icon,rooms_events.tag_1,rooms_events.tag_2,DATE_FORMAT(FROM_UNIXTIME(rooms_events.timestamp), '" & CStr(Proc_10_0_809570("com.mysql.format.time", "%H:%i", 0)) & "') FROM " & eventQueryTail
        rowText = CStr(Proc_5_2_6D4690(eventQueryText, 0, 0))
        If Len(rowText) > 0 Then
            rows = Split(rowText, Chr$(13))
            For rowIndex = LBound(rows) To UBound(rows)
                If Len(rows(rowIndex)) > 0 Then
                    fields = Split(rows(rowIndex), Chr$(9))
                    payload = payload & NavigatorEventFragment(fields)
                    itemCount = itemCount + 1
                End If
            Next rowIndex
        End If
    End If

    If Len(roomQueryTail) > 0 Then
        roomQueryText = "SELECT rooms.id,rooms.name,users.name,rooms.status_door,rooms.visitors_now,rooms.visitors_max,rooms.description,rooms_categories.has_trading,rooms.allow_otherspets,rooms.rate,rooms.id_category,rooms.icon,rooms.tag_1,rooms.tag_2 FROM " & roomQueryTail
        rowText = CStr(Proc_5_2_6D4690(roomQueryText, 0, 0))
        If Len(rowText) > 0 Then
            rows = Split(rowText, Chr$(13))
            For rowIndex = LBound(rows) To UBound(rows)
                If Len(rows(rowIndex)) > 0 Then
                    fields = Split(rows(rowIndex), Chr$(9))
                    payload = payload & NavigatorRoomFragment(fields)
                    itemCount = itemCount + 1
                End If
            Next rowIndex
        End If
    End If

    NavigatorCombinedRoomListPayload = CStr(Proc_3_0_6D2AF0(itemCount, Empty, payload))
    Exit Function

BuildFailed:
    NavigatorCombinedRoomListPayload = CStr(Proc_3_0_6D2AF0(0, Empty, vbNullString))
End Function

Private Function NavigatorEventFragment(ByRef fields() As String) As String
    Dim roomId As Long
    Dim visitorsNow As Long
    Dim visitorsMax As Long
    Dim ratingValue As Long
    Dim categoryId As Long
    Dim hasTrading As Long
    Dim payload As String

    On Error GoTo BuildFailed

    roomId = CLng(Val(NavigatorField(fields, 0)))
    visitorsNow = CLng(Val(NavigatorField(fields, 4)))
    visitorsMax = CLng(Val(NavigatorField(fields, 5)))
    hasTrading = CLng(Val(NavigatorField(fields, 7)))
    ratingValue = CLng(Val(NavigatorField(fields, 9)))
    categoryId = CLng(Val(NavigatorField(fields, 10)))

    payload = CStr(Proc_3_0_6D2AF0(roomId, Empty, vbNullString))
    payload = CStr(Proc_3_0_6D2AF0(visitorsNow, Empty, payload))
    payload = CStr(Proc_3_0_6D2AF0(visitorsMax, Empty, payload))
    payload = CStr(Proc_3_0_6D2AF0(ratingValue, Empty, payload))
    payload = CStr(Proc_3_0_6D2AF0(categoryId, Empty, payload))
    payload = CStr(Proc_3_0_6D2AF0(hasTrading, Empty, payload))
    payload = payload & Chr$(32)
    payload = payload & NavigatorField(fields, 1) & Chr$(2)
    payload = payload & NavigatorField(fields, 2) & Chr$(2)
    payload = payload & NavigatorField(fields, 3) & Chr$(2)
    payload = payload & NavigatorField(fields, 6) & Chr$(2)
    payload = payload & NavigatorField(fields, 11) & Chr$(2)
    payload = payload & NavigatorField(fields, 12) & Chr$(2)
    payload = payload & NavigatorField(fields, 13) & Chr$(2)
    payload = payload & NavigatorField(fields, 14) & Chr$(2)
    NavigatorEventFragment = payload & "H"
    Exit Function

BuildFailed:
    NavigatorEventFragment = vbNullString
End Function

Private Function NavigatorRoomFragment(ByRef fields() As String) As String
    Dim roomId As Long
    Dim visitorsNow As Long
    Dim visitorsMax As Long
    Dim ratingValue As Long
    Dim categoryId As Long
    Dim hasTrading As Long
    Dim allowPets As Long
    Dim staffPicked As Long
    Dim payload As String

    On Error GoTo BuildFailed

    roomId = CLng(Val(NavigatorField(fields, 0)))
    visitorsNow = CLng(Val(NavigatorField(fields, 4)))
    visitorsMax = CLng(Val(NavigatorField(fields, 5)))
    hasTrading = CLng(Val(NavigatorField(fields, 7)))
    ratingValue = CLng(Val(NavigatorField(fields, 9)))
    categoryId = CLng(Val(NavigatorField(fields, 10)))
    allowPets = CLng(Val(NavigatorField(fields, 14)))
    staffPicked = CLng(Val(NavigatorField(fields, 15)))

    payload = CStr(Proc_3_0_6D2AF0(roomId, Empty, vbNullString))
    payload = CStr(Proc_3_0_6D2AF0(visitorsNow, Empty, payload))
    payload = CStr(Proc_3_0_6D2AF0(visitorsMax, Empty, payload))
    payload = CStr(Proc_3_0_6D2AF0(ratingValue, Empty, payload))
    payload = CStr(Proc_3_0_6D2AF0(categoryId, Empty, payload))
    payload = CStr(Proc_3_0_6D2AF0(hasTrading, Empty, payload))
    payload = CStr(Proc_3_0_6D2AF0(allowPets, Empty, payload))
    payload = CStr(Proc_3_0_6D2AF0(staffPicked, Empty, payload))
    payload = payload & NavigatorField(fields, 1) & Chr$(2)
    payload = payload & NavigatorField(fields, 2) & Chr$(2)
    payload = payload & NavigatorField(fields, 3) & Chr$(2)
    payload = payload & NavigatorField(fields, 6) & Chr$(2)
    payload = payload & NavigatorField(fields, 11) & Chr$(2)
    payload = payload & NavigatorField(fields, 12) & Chr$(2)
    payload = payload & NavigatorField(fields, 13) & Chr$(2)
    NavigatorRoomFragment = payload & "H"
    Exit Function

BuildFailed:
    NavigatorRoomFragment = vbNullString
End Function

Private Function NavigatorField(ByRef fields() As String, ByVal fieldIndex As Long) As String
    On Error GoTo MissingField
    If fieldIndex < LBound(fields) Or fieldIndex > UBound(fields) Then GoTo MissingField
    NavigatorField = CStr(fields(fieldIndex))
    Exit Function

MissingField:
    NavigatorField = vbNullString
End Function

Private Function IsSocketMarkedBusy(ByVal socketIndex As Integer) As Boolean
    Dim recordText As String
    Dim marker As String
    Dim startAt As Long
    Dim endAt As Long
    Dim fields As Variant

    On Error GoTo NotBusy
    If IsEmpty(global_0082934C) Then GoTo NotBusy

    marker = "[" & CStr(socketIndex) & "]"
    startAt = InStr(1, CStr(global_0082934C), marker, vbBinaryCompare)
    If startAt = 0 Then GoTo NotBusy

    endAt = InStr(startAt + Len(marker), CStr(global_0082934C), "[", vbBinaryCompare)
    If endAt = 0 Then endAt = Len(CStr(global_0082934C)) + 1

    recordText = Mid$(CStr(global_0082934C), startAt + Len(marker), endAt - startAt - Len(marker))
    fields = Split(recordText, Chr$(2))
    If UBound(fields) >= 5 Then IsSocketMarkedBusy = (Val(CStr(fields(5))) <> 0)
    Exit Function

NotBusy:
    IsSocketMarkedBusy = False
End Function
