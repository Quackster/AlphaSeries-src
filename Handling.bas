Attribute VB_Name = "Handling"
Option Explicit

' Reconstructed VB6 source shell generated from decompiled output.
' Source reference: /opt/git/AlphaSeries_cracked/DECOMPILED/Handling.bas
' Decompiled procedure bodies are intentionally not copied until they are understood and made valid VB6.

Private representedActivityPointTicks As String
Private representedInteractionPairs As String
Private representedTradeOffers As String
Private representedSoundMachineStoppedAt As Date

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
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim requestPayload As String
    Dim callerUserId As String
    Dim roomId As Long
    Dim roomFields() As String
    Dim roomText As String
    Dim roomOwnerId As String
    Dim actionType As Long
    Dim logType As Long
    Dim messageText As String
    Dim offset As Long

    On Error GoTo RoomModerationFailed

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    If Len(packetPayload) = 0 And UBound(args) >= 1 Then packetPayload = CStr(args(1))

    requestPayload = packetPayload
    If Left$(requestPayload, 2) = "CH" Then requestPayload = Mid$(requestPayload, 3)

    offset = 1
    actionType = ReadWireLong(requestPayload, offset)
    If actionType <= 0 Then actionType = CLng(Val(CStr(Proc_10_6_809F10(requestPayload, 0, 0))))
    messageText = ReadWireString(requestPayload, offset)
    If Len(messageText) = 0 Then messageText = CStr(Proc_10_7_80A190(requestPayload, 0, 0))
    messageText = CStr(Proc_10_10_80A7F0(messageText, 0, 0))

    callerUserId = HandlingUserIdFromSocket(socketIndex)
    If Len(callerUserId) = 0 Or callerUserId = "0" Then GoTo RoomModerationFailed
    If Not HandlingUserHasPermission(callerUserId, "fuse_mod") Then GoTo RoomModerationFailed

    roomId = HandlingCurrentRoomId(socketIndex, callerUserId)
    If roomId <= 0 Then GoTo RoomModerationFailed
    If actionType <= 0 Or Len(messageText) = 0 Then GoTo RoomModerationFailed
    If ContainsUnsafeStaffAlert(messageText) Then GoTo RoomModerationFailed

    roomText = CStr(Proc_5_2_6D4690("SELECT id_slot,id_owner FROM rooms WHERE id='" & CStr(roomId) & "' LIMIT 1", 0, 0))
    roomFields = Split(roomText, Chr$(9))
    roomOwnerId = CStr(Val(HandlingField(roomFields, 1)))
    If Len(roomOwnerId) = 0 Or roomOwnerId = "0" Then GoTo RoomModerationFailed

    If actionType = 1 Then
        logType = 1
    Else
        logType = 2
    End If

    Proc_5_1_6D4110 "INSERT INTO logs_moderation(id_type,id_user,id_target,timestamp,message,id_session) VALUES('" & CStr(logType) & "','" & _
        Proc_10_11_80A9C0(callerUserId, 0, 0) & "','" & CStr(roomId) & "',UNIX_TIMESTAMP(),'" & Proc_10_11_80A9C0(messageText, 0, 0) & "','" & CStr(socketIndex) & "')", 0, 0

    BroadcastToRoomUsers roomId, "Ba" & messageText & Chr$(2)

    If actionType = 1 Or actionType = 4 Then
        Proc_5_0_6D3CD0 "DELETE FROM rooms_events WHERE id_room='" & CStr(roomId) & "' LIMIT 1", 0, 0
        Proc_6_247_8027E0 socketIndex, "Er" & CStr(Proc_6_51_716AC0(roomId)), 0
        Proc_10_18_80C9E0 roomId, 0, 0
    End If

    If actionType = 1 Then
        Proc_5_0_6D3CD0 "INSERT INTO users_cautions(id_user,id_partner,message,timestamp_submit) VALUES('" & Proc_10_11_80A9C0(roomOwnerId, 0, 0) & "','" & _
            Proc_10_11_80A9C0(callerUserId, 0, 0) & "','" & Proc_10_11_80A9C0(messageText & " (Room caution of room id: " & CStr(roomId) & ")", 0, 0) & "',UNIX_TIMESTAMP())", 0, 0
    End If

    Proc_6_4_6DAFB0 = actionType
    Exit Function

RoomModerationFailed:
    Proc_6_4_6DAFB0 = Empty
End Function

' Original declaration: Private  Proc_6_5_6DC340(arg_C) '6DC340
Public Function Proc_6_5_6DC340(ParamArray args() As Variant) As Variant
    Dim callForHelpId As Long
    Dim socketIndex As Integer
    Dim rowText As String
    Dim fields() As String
    Dim representedFields(0 To 10) As String
    Dim payload As String

    On Error GoTo SendFailed
    If UBound(args) < 0 Then GoTo SendFailed

    callForHelpId = CLng(Val(CStr(args(0))))
    If UBound(args) >= 1 Then socketIndex = CInt(Val(CStr(args(1))))
    If callForHelpId <= 0 Then GoTo SendFailed

    rowText = CStr(Proc_5_2_6D4690("SELECT staff_cfh.id,users.id,users.name,staff_cfh.id_partner,staff_cfh.id_room,staff_cfh.id_category,staff_cfh.description,rooms.id,rooms.name FROM staff_cfh,users,rooms WHERE staff_cfh.id='" & CStr(callForHelpId) & "' AND staff_cfh.id_closed='0' AND users.id=staff_cfh.id_user AND rooms.id=staff_cfh.id_room LIMIT 1", 0, 0))
    If Len(rowText) = 0 Then GoTo SendFailed

    fields = Split(rowText, Chr$(9))
    If UBound(fields) < 8 Then GoTo SendFailed

    representedFields(0) = HandlingField(fields, 0)
    representedFields(1) = vbNullString
    representedFields(2) = HandlingField(fields, 1)
    representedFields(3) = HandlingField(fields, 2)
    representedFields(4) = HandlingField(fields, 3)
    representedFields(5) = HandlingField(fields, 4)
    representedFields(6) = HandlingField(fields, 5)
    representedFields(7) = HandlingField(fields, 6)
    representedFields(8) = HandlingField(fields, 7)
    representedFields(9) = HandlingField(fields, 8)
    representedFields(10) = vbNullString

    payload = "HR" & CallForHelpRowPayload(representedFields)
    If socketIndex > 0 Then
        Proc_6_244_801E80 socketIndex, payload, 0
    Else
        Proc_6_249_802F10 payload, 0, 0
    End If

SendFailed:
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
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim requestPayload As String
    Dim callerUserId As String
    Dim roomId As Long
    Dim firstFlag As Long
    Dim lockFlag As Long
    Dim offset As Long

    On Error GoTo RoomLockFailed

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    If Len(packetPayload) = 0 And UBound(args) >= 1 Then packetPayload = CStr(args(1))

    requestPayload = packetPayload
    If Left$(requestPayload, 2) = "GL" Then requestPayload = Mid$(requestPayload, 3)

    callerUserId = HandlingUserIdFromSocket(socketIndex)
    If Len(callerUserId) = 0 Or callerUserId = "0" Then GoTo RoomLockFailed
    If Not HandlingUserHasPermission(callerUserId, "fuse_mod") Then GoTo RoomLockFailed

    roomId = HandlingCurrentRoomId(socketIndex, callerUserId)
    If roomId <= 0 Then GoTo RoomLockFailed

    offset = 1
    firstFlag = ReadWireLong(requestPayload, offset)
    lockFlag = ReadWireLong(requestPayload, offset)
    If lockFlag <> 1 Then GoTo RoomLockFailed

    Proc_5_0_6D3CD0 "UPDATE rooms SET status_door='1', name='Inappropriate to hotel management' WHERE id='" & CStr(roomId) & "'", 0, 0

RoomLockFailed:
    Proc_6_9_6DDD70 = Empty
End Function

' Original declaration: Private Sub Proc_6_10_6DE1D0
Public Function Proc_6_10_6DE1D0(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim requestPayload As String
    Dim callerUserId As String
    Dim targetUserId As String
    Dim targetRow As String
    Dim targetFields() As String
    Dim visitRows As String
    Dim rows() As String
    Dim fields() As String
    Dim rowIndex As Long
    Dim roomCount As Long
    Dim roomPayload As String
    Dim responsePayload As String

    On Error GoTo ChatHistoryFailed

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    If Len(packetPayload) = 0 And UBound(args) >= 1 Then packetPayload = CStr(args(1))

    requestPayload = packetPayload
    If Left$(requestPayload, 2) = "GG" Then requestPayload = Mid$(requestPayload, 3)

    callerUserId = HandlingUserIdFromSocket(socketIndex)
    If Len(callerUserId) = 0 Or callerUserId = "0" Then GoTo ChatHistoryFailed
    If Not HandlingUserHasPermission(callerUserId, "fuse_mod") Then GoTo ChatHistoryFailed
    If Not HandlingUserHasPermission(callerUserId, "fuse_chatlog") Then GoTo ChatHistoryFailed

    targetUserId = StaffNestedUserIdFromWire(requestPayload)
    If Len(targetUserId) = 0 Or targetUserId = "0" Then GoTo ChatHistoryFailed

    targetRow = CStr(Proc_5_2_6D4690("SELECT users.id,users.name FROM users WHERE users.id='" & Proc_10_11_80A9C0(targetUserId, 0, 0) & "' LIMIT 1", 0, 0))
    If Len(targetRow) = 0 Then GoTo ChatHistoryFailed
    targetFields = Split(targetRow, Chr$(9))
    targetUserId = CStr(Val(HandlingField(targetFields, 0)))
    If Len(targetUserId) = 0 Or targetUserId = "0" Then GoTo ChatHistoryFailed

    visitRows = CStr(Proc_5_2_6D4690("SELECT models.type,rooms.id,rooms.name,logs_visitedrooms.timestamp_enter,logs_visitedrooms.timestamp_left FROM rooms,logs_visitedrooms,models WHERE logs_visitedrooms.id_user='" & _
        Proc_10_11_80A9C0(targetUserId, 0, 0) & "' AND rooms.id=logs_visitedrooms.id_room AND logs_visitedrooms.timestamp_enter > UNIX_TIMESTAMP()-21600 AND models.id=rooms.id_model GROUP BY logs_visitedrooms.id ORDER BY logs_visitedrooms.id DESC LIMIT 10", 0, 0))

    If Len(visitRows) > 0 Then
        rows = Split(visitRows, Chr$(13))
        For rowIndex = LBound(rows) To UBound(rows)
            If Len(rows(rowIndex)) > 0 Then
                fields = Split(rows(rowIndex), Chr$(9))
                roomPayload = roomPayload & StaffRoomChatHistoryPayload(fields, CLng(Val(targetUserId)))
                roomCount = roomCount + 1
            End If
        Next rowIndex
    End If

    responsePayload = CStr(Proc_3_0_6D2AF0(CLng(Val(targetUserId)), Empty, "HX")) & HandlingField(targetFields, 1) & Chr$(2)
    responsePayload = CStr(Proc_3_0_6D2AF0(roomCount, Empty, responsePayload)) & roomPayload
    Proc_6_244_801E80 socketIndex, responsePayload, 0

ChatHistoryFailed:
    Proc_6_10_6DE1D0 = Empty
End Function

' Original declaration: Private Sub Proc_6_11_6DF4A0
Public Function Proc_6_11_6DF4A0(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim requestPayload As String
    Dim callerUserId As String
    Dim targetUserId As String
    Dim targetRow As String
    Dim targetFields() As String
    Dim visitRows As String
    Dim rows() As String
    Dim fields() As String
    Dim rowIndex As Long
    Dim visitCount As Long
    Dim visitPayload As String
    Dim responsePayload As String

    On Error GoTo RoomHistoryFailed

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    If Len(packetPayload) = 0 And UBound(args) >= 1 Then packetPayload = CStr(args(1))

    requestPayload = packetPayload
    If Left$(requestPayload, 2) = "GJ" Then requestPayload = Mid$(requestPayload, 3)

    callerUserId = HandlingUserIdFromSocket(socketIndex)
    If Len(callerUserId) = 0 Or callerUserId = "0" Then GoTo RoomHistoryFailed
    If Not HandlingUserHasPermission(callerUserId, "fuse_mod") Then GoTo RoomHistoryFailed

    targetUserId = CStr(Val(CStr(Proc_10_6_809F10(requestPayload, 0, 0))))
    If Len(targetUserId) = 0 Or targetUserId = "0" Then GoTo RoomHistoryFailed

    targetRow = CStr(Proc_5_2_6D4690("SELECT users.id,users.name FROM users WHERE users.id='" & Proc_10_11_80A9C0(targetUserId, 0, 0) & "' LIMIT 1", 0, 0))
    If Len(targetRow) = 0 Then GoTo RoomHistoryFailed
    targetFields = Split(targetRow, Chr$(9))
    targetUserId = CStr(Val(HandlingField(targetFields, 0)))
    If Len(targetUserId) = 0 Or targetUserId = "0" Then GoTo RoomHistoryFailed

    visitRows = CStr(Proc_5_2_6D4690("SELECT models.type,rooms.id,rooms.name,DATE_FORMAT(FROM_UNIXTIME(logs_visitedrooms.timestamp_enter), '" & Chr$(37) & _
        "H'),DATE_FORMAT(FROM_UNIXTIME(logs_visitedrooms.timestamp_enter), '" & Chr$(37) & _
        "i') FROM rooms,logs_visitedrooms,models WHERE logs_visitedrooms.timestamp_enter > UNIX_TIMESTAMP()-21600 AND logs_visitedrooms.id_user='" & _
        Proc_10_11_80A9C0(targetUserId, 0, 0) & "' AND rooms.id=logs_visitedrooms.id_room AND models.id=rooms.id_model GROUP BY logs_visitedrooms.id ORDER BY logs_visitedrooms.id DESC LIMIT 50", 0, 0))

    If Len(visitRows) > 0 Then
        rows = Split(visitRows, Chr$(13))
        For rowIndex = LBound(rows) To UBound(rows)
            If Len(rows(rowIndex)) > 0 Then
                fields = Split(rows(rowIndex), Chr$(9))
                visitPayload = visitPayload & StaffRoomVisitPayload(fields)
                visitCount = visitCount + 1
            End If
        Next rowIndex
    End If

    responsePayload = CStr(Proc_3_0_6D2AF0(CLng(Val(targetUserId)), Empty, "HY")) & HandlingField(targetFields, 1) & Chr$(2)
    responsePayload = CStr(Proc_3_0_6D2AF0(visitCount, Empty, responsePayload)) & visitPayload
    Proc_6_244_801E80 socketIndex, responsePayload, 0

RoomHistoryFailed:
    Proc_6_11_6DF4A0 = Empty
End Function

' Original declaration: Private Sub Proc_6_12_6DFE90
Public Function Proc_6_12_6DFE90(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim requestPayload As String
    Dim callerUserId As String
    Dim targetUserId As String
    Dim targetSocketIndex As Integer
    Dim currentRoomId As Long
    Dim alertMessage As String
    Dim offset As Long

    On Error GoTo DirectAlertFailed

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    If Len(packetPayload) = 0 And UBound(args) >= 1 Then packetPayload = CStr(args(1))

    requestPayload = packetPayload
    If Left$(requestPayload, 2) = "GN" Then requestPayload = Mid$(requestPayload, 3)

    offset = 1
    targetUserId = CStr(ReadWireLong(requestPayload, offset))
    If Len(targetUserId) = 0 Or targetUserId = "0" Then targetUserId = CStr(Val(CStr(Proc_10_6_809F10(requestPayload, 0, 0))))
    If Len(targetUserId) = 0 Or targetUserId = "0" Then GoTo DirectAlertFailed

    alertMessage = ReadWireString(requestPayload, offset)
    If Len(alertMessage) = 0 Then alertMessage = CStr(Proc_10_7_80A190(requestPayload, 0, 0))
    If Len(alertMessage) = 0 Then GoTo DirectAlertFailed

    callerUserId = HandlingUserIdFromSocket(socketIndex)
    If Len(callerUserId) = 0 Or callerUserId = "0" Then GoTo DirectAlertFailed
    If Not HandlingUserHasPermission(callerUserId, "fuse_mod") Then GoTo DirectAlertFailed
    If Not HandlingUserHasPermission(callerUserId, "fuse_alert") Then GoTo DirectAlertFailed
    If ContainsUnsafeStaffAlert(alertMessage) Then GoTo DirectAlertFailed

    targetSocketIndex = HandlingSocketFromUserId(targetUserId)
    If targetSocketIndex <= 0 Then GoTo DirectAlertFailed

    currentRoomId = HandlingCurrentRoomId(socketIndex, callerUserId)
    Proc_5_1_6D4110 "INSERT INTO logs_moderation(id_type,id_user,id_target,id_target_2,timestamp,message,id_session) VALUES('3','" & _
        Proc_10_11_80A9C0(callerUserId, 0, 0) & "','" & Proc_10_11_80A9C0(targetUserId, 0, 0) & "','" & CStr(currentRoomId) & "',UNIX_TIMESTAMP(),'" & _
        Proc_10_11_80A9C0(alertMessage, 0, 0) & "','" & CStr(socketIndex) & "')", 0, 0

    Proc_6_244_801E80 targetSocketIndex, "Ba" & alertMessage & Chr$(2), 0

DirectAlertFailed:
    Proc_6_12_6DFE90 = Empty
End Function

' Original declaration: Private Sub Proc_6_13_6E0A80
Public Function Proc_6_13_6E0A80(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim userId As String
    Dim roomId As Long
    Dim roomUserIndex As Long
    Dim payload As String

    On Error GoTo WaveFailed

    socketIndex = HandlingSocketIndex(args)
    userId = HandlingUserIdFromSocket(socketIndex)
    If Len(userId) = 0 Or userId = "0" Then GoTo WaveFailed

    roomId = HandlingCurrentRoomId(socketIndex, userId)
    If roomId <= 0 Then GoTo WaveFailed

    roomUserIndex = RepresentedRoomUserIndex(socketIndex, userId)
    payload = CStr(Proc_3_0_6D2AF0(roomUserIndex, Empty, "Ga"))
    Proc_6_247_8027E0 socketIndex, payload, 0
    Proc_6_13_6E0A80 = roomUserIndex
    Exit Function

WaveFailed:
    Proc_6_13_6E0A80 = Empty
End Function

' Original declaration: Private Sub Proc_6_14_6E10C0
Public Function Proc_6_14_6E10C0(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim userId As String
    Dim roomId As Long
    Dim roomUserIndex As Long
    Dim packetPayload As String
    Dim requestPayload As String
    Dim danceId As Long
    Dim offset As Long
    Dim payload As String

    On Error GoTo DanceFailed

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    If Len(packetPayload) = 0 And UBound(args) >= 1 Then packetPayload = CStr(args(1))

    requestPayload = packetPayload
    If Left$(requestPayload, 2) = "A]" Then requestPayload = Mid$(requestPayload, 3)

    danceId = CLng(Val(CStr(Proc_10_6_809F10(requestPayload, 0, 0))))
    If danceId <= 0 Then
        offset = 1
        danceId = ReadWireLong(requestPayload, offset)
    End If
    If danceId < 0 Then danceId = 0
    If danceId > 4 Then danceId = 4

    userId = HandlingUserIdFromSocket(socketIndex)
    If Len(userId) = 0 Or userId = "0" Then GoTo DanceFailed

    roomId = HandlingCurrentRoomId(socketIndex, userId)
    If roomId <= 0 Then GoTo DanceFailed

    roomUserIndex = RepresentedRoomUserIndex(socketIndex, userId)
    payload = CStr(Proc_3_0_6D2AF0(danceId, Empty, CStr(Proc_3_0_6D2AF0(roomUserIndex, Empty, "G`"))))
    Proc_6_247_8027E0 socketIndex, payload, 0
    Proc_6_14_6E10C0 = danceId
    Exit Function

DanceFailed:
    Proc_6_14_6E10C0 = Empty
End Function

' Original declaration: Private Sub Proc_6_15_6E1900
Public Function Proc_6_15_6E1900(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim userId As String
    Dim rowText As String
    Dim rows() As String
    Dim fields() As String
    Dim rowIndex As Long
    Dim slotId As Long
    Dim figureText As String
    Dim genderText As String
    Dim wardrobePayload As String
    Dim slotCount As Long
    Dim maxSlots As Long

    On Error GoTo WardrobeFailed

    socketIndex = HandlingSocketIndex(args)
    userId = HandlingUserIdFromSocket(socketIndex)
    If Len(userId) = 0 Or userId = "0" Then GoTo WardrobeFailed
    If Not HandlingUserHasPermission(userId, "fuse_use_wardrobe") Then GoTo WardrobeFailed

    maxSlots = 5
    If HandlingUserHasPermission(userId, "fuse_larger_wardrobe") Then maxSlots = 10

    rowText = CStr(Proc_5_2_6D4690("SELECT id_slot,figure,gender FROM users_wardrobe WHERE id_user='" & Proc_10_11_80A9C0(userId, 0, 0) & "' ORDER BY id_slot", 0, 0))
    If Len(rowText) > 0 Then
        rows = Split(rowText, Chr$(13))
        For rowIndex = LBound(rows) To UBound(rows)
            If Len(rows(rowIndex)) > 0 Then
                fields = Split(CStr(rows(rowIndex)), Chr$(9))
                If UBound(fields) >= 2 Then
                    slotId = CLng(Val(CStr(fields(0))))
                    If slotId >= 1 And slotId <= maxSlots Then
                        figureText = CStr(fields(1))
                        genderText = UCase$(Left$(CStr(fields(2)), 1))
                        If genderText <> "M" And genderText <> "F" Then genderText = "M"

                        wardrobePayload = wardrobePayload & WardrobeSlotPayload(slotId, figureText, genderText)
                        slotCount = slotCount + 1
                    End If
                End If
            End If
        Next rowIndex
    End If

    Proc_6_244_801E80 socketIndex, CStr(Proc_3_0_6D2AF0(slotCount, Empty, "DK")) & wardrobePayload, 0

WardrobeFailed:
    Proc_6_15_6E1900 = Empty
End Function

Private Function WardrobeSlotPayload(ByVal slotId As Long, ByVal figureText As String, ByVal genderText As String) As String
    WardrobeSlotPayload = CStr(Proc_3_0_6D2AF0(slotId, Empty, vbNullString)) & figureText & Chr$(2) & genderText & Chr$(2)
End Function

' Original declaration: Private Sub Proc_6_16_6E2320
Public Function Proc_6_16_6E2320(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim requestPayload As String
    Dim userId As String
    Dim slotId As Long
    Dim figureText As String
    Dim genderText As String
    Dim maxSlots As Long
    Dim offset As Long

    On Error GoTo SaveFailed

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    If Len(packetPayload) = 0 And UBound(args) >= 1 Then packetPayload = CStr(args(1))

    requestPayload = packetPayload
    If Left$(requestPayload, 2) = "Ex" Then requestPayload = Mid$(requestPayload, 3)

    offset = 1
    slotId = ReadWireLong(requestPayload, offset)
    figureText = CStr(Proc_10_10_80A7F0(ReadWireString(requestPayload, offset), 0, 0))
    genderText = UCase$(Left$(CStr(ReadWireString(requestPayload, offset)), 1))

    userId = HandlingUserIdFromSocket(socketIndex)
    If Len(userId) = 0 Or userId = "0" Then GoTo SaveFailed
    If Not HandlingUserHasPermission(userId, "fuse_use_wardrobe") Then GoTo SaveFailed

    maxSlots = 5
    If HandlingUserHasPermission(userId, "fuse_larger_wardrobe") Then maxSlots = 10
    If slotId < 1 Or slotId > maxSlots Then GoTo SaveFailed
    If genderText <> "M" And genderText <> "F" Then GoTo SaveFailed
    If Not IsValidWardrobeFigure(figureText, genderText) Then GoTo SaveFailed

    Proc_5_0_6D3CD0 "DELETE FROM users_wardrobe WHERE id_user='" & Proc_10_11_80A9C0(userId, 0, 0) & "' AND id_slot='" & CStr(slotId) & "' LIMIT 1", 0, 0
    Proc_5_0_6D3CD0 "INSERT INTO users_wardrobe(id_user,id_slot,figure,gender) VALUES('" & Proc_10_11_80A9C0(userId, 0, 0) & "','" & CStr(slotId) & "','" & Proc_10_11_80A9C0(figureText, 0, 0) & "','" & Proc_10_11_80A9C0(genderText, 0, 0) & "')", 0, 0

    Proc_6_15_6E1900 socketIndex, "Ew", "Ew"

SaveFailed:
    Proc_6_16_6E2320 = Empty
End Function

Private Function IsValidWardrobeFigure(ByVal figureText As String, ByVal genderText As String) As Boolean
    Dim allowedTypes As String
    Dim figureData As String
    Dim parts() As String
    Dim piece() As String
    Dim partIndex As Long
    Dim figureType As String
    Dim setId As String
    Dim setTypeStart As Long
    Dim setTypeEnd As Long
    Dim setTypeXml As String
    Dim setMarker As String

    On Error GoTo InvalidFigure
    If Len(figureText) = 0 Or Len(figureText) > 255 Then GoTo InvalidFigure
    If InStr(1, figureText, "'", vbBinaryCompare) > 0 Or InStr(1, figureText, Chr$(34), vbBinaryCompare) > 0 Then GoTo InvalidFigure

    allowedTypes = ";lg;ha;wa;hr;ch;sh;cc;ea;he;ca;hd;fa;cp;"
    parts = Split(figureText, ".")
    figureData = CStr(Proc_6_239_7FC170(App.Path & "\figuredata.cache", 0, 0))

    For partIndex = LBound(parts) To UBound(parts)
        If Len(parts(partIndex)) > 0 Then
            piece = Split(CStr(parts(partIndex)), "-")
            If UBound(piece) < 1 Then GoTo InvalidFigure

            figureType = LCase$(CStr(piece(0)))
            setId = CStr(piece(1))
            If InStr(1, allowedTypes, ";" & figureType & ";", vbBinaryCompare) = 0 Then GoTo InvalidFigure
            If CLng(Val(setId)) <= 0 Then GoTo InvalidFigure

            If Len(figureData) > 0 Then
                setTypeStart = InStr(1, figureData, "<settype type=""" & figureType & """", vbTextCompare)
                If setTypeStart = 0 Then GoTo InvalidFigure
                setTypeEnd = InStr(setTypeStart, figureData, "</settype>", vbTextCompare)
                If setTypeEnd = 0 Then GoTo InvalidFigure

                setTypeXml = Mid$(figureData, setTypeStart, setTypeEnd - setTypeStart)
                setMarker = "<set id=""" & CStr(CLng(Val(setId))) & """"
                If InStr(1, setTypeXml, setMarker, vbTextCompare) = 0 Then GoTo InvalidFigure
                If Not FigureSetAllowsGender(setTypeXml, setMarker, genderText) Then GoTo InvalidFigure
            End If
        End If
    Next partIndex

    IsValidWardrobeFigure = True
    Exit Function

InvalidFigure:
    IsValidWardrobeFigure = False
End Function

Private Function FigureSetAllowsGender(ByVal setTypeXml As String, ByVal setMarker As String, ByVal genderText As String) As Boolean
    Dim setStart As Long
    Dim setEnd As Long
    Dim setXml As String
    Dim genderStart As Long
    Dim genderValue As String

    On Error GoTo GenderCheckFailed
    setStart = InStr(1, setTypeXml, setMarker, vbTextCompare)
    If setStart = 0 Then GoTo GenderCheckFailed

    setEnd = InStr(setStart, setTypeXml, "</set>", vbTextCompare)
    If setEnd = 0 Then setEnd = InStr(setStart, setTypeXml, "/>", vbTextCompare)
    If setEnd = 0 Then setEnd = Len(setTypeXml)

    setXml = Mid$(setTypeXml, setStart, setEnd - setStart)
    genderStart = InStr(1, setXml, "gender=""", vbTextCompare)
    If genderStart = 0 Then
        FigureSetAllowsGender = True
        Exit Function
    End If

    genderValue = Mid$(setXml, genderStart + 8, 1)
    FigureSetAllowsGender = (UCase$(genderValue) = "U" Or UCase$(genderValue) = UCase$(genderText))
    Exit Function

GenderCheckFailed:
    FigureSetAllowsGender = False
End Function

' Original declaration: Private Sub Proc_6_17_6E48D0
Public Function Proc_6_17_6E48D0(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim requestPayload As String
    Dim userId As String
    Dim mottoText As String
    Dim figureText As String
    Dim genderText As String
    Dim payload As String
    Dim offset As Long

    On Error GoTo FigureFailed

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    If Len(packetPayload) = 0 And UBound(args) >= 1 Then packetPayload = CStr(args(1))

    requestPayload = packetPayload
    If Left$(requestPayload, 2) = "@l" Then requestPayload = Mid$(requestPayload, 3)

    offset = 1
    genderText = UCase$(Left$(CStr(ReadWireString(requestPayload, offset)), 1))
    figureText = CStr(Proc_10_10_80A7F0(ReadWireString(requestPayload, offset), 0, 0))

    userId = HandlingUserIdFromSocket(socketIndex)
    If Len(userId) = 0 Or userId = "0" Then GoTo FigureFailed
    If genderText <> "M" And genderText <> "F" Then GoTo FigureFailed
    If Not IsValidWardrobeFigure(figureText, genderText) Then GoTo FigureFailed

    Proc_5_0_6D3CD0 "UPDATE users SET tutorial_clothes='1',gender='" & Proc_10_11_80A9C0(genderText, 0, 0) & "',figure='" & Proc_10_11_80A9C0(figureText, 0, 0) & "' WHERE id='" & Proc_10_11_80A9C0(userId, 0, 0) & "'", 0, 0

    mottoText = CStr(Proc_5_2_6D4690("SELECT motto FROM users WHERE id='" & Proc_10_11_80A9C0(userId, 0, 0) & "' LIMIT 1", 0, 0))
    payload = UserIdentityPayload(CLng(Val(userId)), mottoText, genderText, figureText)
    Proc_6_244_801E80 socketIndex, payload, 0
    Proc_6_247_8027E0 socketIndex, payload, 0

FigureFailed:
    Proc_6_17_6E48D0 = Empty
End Function

Private Function UserIdentityPayload(ByVal userId As Long, ByVal mottoText As String, ByVal genderText As String, ByVal figureText As String) As String
    UserIdentityPayload = CStr(Proc_3_0_6D2AF0(userId, Empty, "DJ")) & mottoText & Chr$(2) & genderText & Chr$(2) & figureText & Chr$(2)
End Function

' Original declaration: Private Sub Proc_6_18_6E7480
Public Function Proc_6_18_6E7480(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim userId As String
    Dim offerRows() As String
    Dim offerFields() As String
    Dim offerIndex As Long
    Dim offerCount As Long
    Dim offerPayload As String
    Dim rowText As String
    Dim userFields() As String
    Dim hcLevel As Long
    Dim hcDays As Long
    Dim vipDays As Long
    Dim hcPeriods As Long
    Dim vipPeriods As Long
    Dim presentsAvailable As Long
    Dim daysSinceStart As Long
    Dim activeDays As Long
    Dim daysLeft As Long
    Dim periodsLeft As Long
    Dim payload As String

    On Error GoTo ClubStatusFailed

    socketIndex = HandlingSocketIndex(args)
    userId = HandlingUserIdFromSocket(socketIndex)
    If socketIndex <= 0 Or Len(userId) = 0 Or userId = "0" Then GoTo ClubStatusFailed

    offerRows = Split(CStr(Proc_5_2_6D4690("SELECT id,sprite_name,months,level,price_credits FROM products_club ORDER BY id ASC", 0, 0)), Chr$(13))
    For offerIndex = LBound(offerRows) To UBound(offerRows)
        If Len(offerRows(offerIndex)) > 0 Then
            offerFields = Split(CStr(offerRows(offerIndex)), Chr$(9))
            If UBound(offerFields) >= 4 Then
                offerPayload = offerPayload & CStr(Proc_3_0_6D2AF0(CLng(Val(CStr(offerFields(0)))), Empty, vbNullString))
                offerPayload = offerPayload & CStr(offerFields(1)) & Chr$(2)
                offerPayload = offerPayload & CStr(Proc_3_0_6D2AF0(CLng(Val(CStr(offerFields(2)))), Empty, vbNullString))
                offerPayload = offerPayload & CStr(Proc_3_0_6D2AF0(CLng(Val(CStr(offerFields(2)))) * 31, Empty, vbNullString))
                offerPayload = offerPayload & CStr(Proc_3_0_6D2AF0(CLng(Val(CStr(offerFields(3)))), Empty, vbNullString))
                offerPayload = offerPayload & CStr(Proc_3_0_6D2AF0(CLng(Val(CStr(offerFields(4)))), Empty, vbNullString))
                offerPayload = offerPayload & CStr(Proc_3_0_6D2AF0(0, Empty, vbNullString))
                offerCount = offerCount + 1
            End If
        End If
    Next offerIndex

    rowText = CStr(Proc_5_2_6D4690("SELECT level_hc,hc_days,hc2_days,hc_periods,hc2_periods,hc_presents,ROUND((UNIX_TIMESTAMP()-hc_startperiod)/60/60/24,0) FROM users WHERE id='" & Proc_10_11_80A9C0(userId, 0, 0) & "' LIMIT 1", 0, 0))
    If Len(rowText) > 0 Then
        userFields = Split(rowText, Chr$(9))
        hcLevel = CLng(Val(NavigatorField(userFields, 0)))
        hcDays = CLng(Val(NavigatorField(userFields, 1)))
        vipDays = CLng(Val(NavigatorField(userFields, 2)))
        hcPeriods = CLng(Val(NavigatorField(userFields, 3)))
        vipPeriods = CLng(Val(NavigatorField(userFields, 4)))
        presentsAvailable = CLng(Val(NavigatorField(userFields, 5)))
        daysSinceStart = CLng(Val(NavigatorField(userFields, 6)))
    End If

    If hcLevel > 1 Then
        activeDays = vipDays
        periodsLeft = vipPeriods
    Else
        activeDays = hcDays
        periodsLeft = hcPeriods
    End If
    daysLeft = activeDays - daysSinceStart
    If daysLeft < 0 Then daysLeft = 0
    If periodsLeft < 1 And daysLeft > 0 Then periodsLeft = CLng(Int((daysLeft + 30) / 31))

    payload = CStr(Proc_3_0_6D2AF0(offerCount, Empty, "Iq")) & offerPayload
    payload = payload & CStr(Proc_3_0_6D2AF0(hcLevel, Empty, vbNullString))
    payload = payload & CStr(Proc_3_0_6D2AF0(daysLeft, Empty, vbNullString))
    payload = payload & CStr(Proc_3_0_6D2AF0(periodsLeft, Empty, vbNullString))
    payload = payload & CStr(Proc_3_0_6D2AF0(presentsAvailable, Empty, vbNullString))
    Proc_6_244_801E80 socketIndex, payload, 0

ClubStatusFailed:
    Proc_6_18_6E7480 = Empty
End Function

' Original declaration: Private Sub Proc_6_19_6E8040
Public Function Proc_6_19_6E8040(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim cachedPayload As String
    Dim packetPrefix As String
    Dim payload As String

    On Error GoTo SendFailed

    socketIndex = HandlingSocketIndex(args)
    If socketIndex <= 0 Then GoTo SendFailed

    If UBound(args) >= 1 Then cachedPayload = CStr(args(1))
    If UBound(args) >= 2 Then packetPrefix = CStr(args(2))
    If Len(packetPrefix) = 0 Then packetPrefix = "Gz"
    If Len(cachedPayload) = 0 Then cachedPayload = global_0082912C

    payload = packetPrefix & cachedPayload
    Proc_6_244_801E80 socketIndex, payload, 0
    Proc_6_19_6E8040 = payload
    Exit Function

SendFailed:
    Proc_6_19_6E8040 = Empty
End Function

' Original declaration: Private Sub Proc_6_20_6E88E0
Public Function Proc_6_20_6E88E0(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim userId As String
    Dim rankIndex As Long
    Dim staffFlag As Long
    Dim payload As String

    On Error GoTo StaffClientFailed

    socketIndex = HandlingSocketIndex(args)
    userId = HandlingUserIdFromSocket(socketIndex)
    If Len(userId) = 0 Or userId = "0" Then GoTo StaffClientFailed

    rankIndex = HandlingUserRank(userId)
    If HandlingUserHasPermission(userId, "fuse_client_staff") Then staffFlag = 1

    payload = CStr(Proc_3_0_6D2AF0(rankIndex, Empty, "@B"))
    payload = payload & CStr(Proc_3_0_6D2AF0(rankIndex, Empty, vbNullString))
    payload = "0" & CStr(Proc_3_0_6D2AF0(staffFlag, Empty, payload))
    Proc_6_244_801E80 socketIndex, payload, 0

StaffClientFailed:
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
    Proc_6_24_6EA010 = HandlingRepresentedChatRoute(args, 0)
End Function

' Original declaration: Private  Proc_6_25_6EEAC0(arg_C) '6EEAC0
Public Function Proc_6_25_6EEAC0(ParamArray args() As Variant) As Variant
    Proc_6_25_6EEAC0 = HandlingRepresentedChatRoute(args, 0)
End Function

' Original declaration: Private Sub Proc_6_26_7034C0
Public Function Proc_6_26_7034C0(ParamArray args() As Variant) As Variant
    Proc_6_26_7034C0 = HandlingRepresentedChatRoute(args, 0)
End Function

' Original declaration: Private Sub Proc_6_27_706920
Public Function Proc_6_27_706920(ParamArray args() As Variant) As Variant
    Proc_6_27_706920 = HandlingRepresentedChatRoute(args, 1)
End Function

' Original declaration: Private Sub Proc_6_28_709DA0
Public Function Proc_6_28_709DA0(ParamArray args() As Variant) As Variant
    Proc_6_28_709DA0 = HandlingRepresentedChatRoute(args, 2)
End Function

Private Function HandlingRepresentedChatRoute(ByRef args() As Variant, ByVal chatType As Long) As Variant
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim requestPayload As String
    Dim userId As String
    Dim roomId As Long
    Dim roomUserIndex As Long
    Dim messageText As String
    Dim filteredText As String
    Dim targetName As String
    Dim targetSocketIndex As Integer
    Dim gestureId As Long
    Dim payload As String
    Dim offset As Long
    Dim idType As Long
    Dim userRank As Long
    Dim hcLevel As Long

    On Error GoTo ChatDone

    socketIndex = HandlingSocketIndex(args)
    If socketIndex <= 0 Then GoTo ChatDone
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    If Len(packetPayload) = 0 And UBound(args) >= 1 Then packetPayload = CStr(args(1))

    requestPayload = packetPayload
    If Left$(requestPayload, 2) = "@t" Or Left$(requestPayload, 2) = "@w" Or Left$(requestPayload, 2) = "@x" Then
        requestPayload = Mid$(requestPayload, 3)
    End If
    If Left$(requestPayload, 1) = "H" Or Left$(requestPayload, 1) = "I" Then requestPayload = Mid$(requestPayload, 2)

    offset = 1
    If chatType = 2 Then
        targetName = Trim$(CStr(ReadWireString(requestPayload, offset)))
        messageText = CStr(ReadWireString(requestPayload, offset))
        If Len(messageText) = 0 Then
            messageText = requestPayload
            If InStr(1, messageText, Chr$(32), vbBinaryCompare) > 0 Then
                targetName = Trim$(Left$(messageText, InStr(1, messageText, Chr$(32), vbBinaryCompare) - 1))
                messageText = Mid$(messageText, Len(targetName) + 2)
            End If
        End If
    Else
        messageText = CStr(ReadWireString(requestPayload, offset))
        If Len(messageText) = 0 Then messageText = requestPayload
    End If

    messageText = Left$(Trim$(CStr(Proc_10_10_80A7F0(messageText, 0, 0))), 122)
    If Len(messageText) = 0 Then GoTo ChatDone

    userId = HandlingUserIdFromSocket(socketIndex)
    If Len(userId) = 0 Or userId = "0" Then GoTo ChatDone

    roomId = HandlingCurrentRoomId(socketIndex, userId)
    roomUserIndex = RepresentedRoomUserIndex(socketIndex, userId)
    If roomId <= 0 Or roomUserIndex <= 0 Then GoTo ChatDone

    userRank = HandlingUserRank(userId)
    hcLevel = HandlingUserHcLevel(userId)
    If Len(Proc_6_21_6E8BA0(messageText, 0, 0)) > 0 Then
        If Not CBool(Proc_10_1_809790(userRank, vbNullString, "fuse_can_chat_links", hcLevel)) Then GoTo ChatDone
    End If

    filteredText = CStr(Proc_6_22_6E9300(messageText, 0, 0))
    If Len(filteredText) = 0 Then filteredText = messageText
    gestureId = CLng(Val(CStr(Proc_6_23_6E9A90(filteredText, 0, 0))))

    idType = chatType
    Proc_5_1_6D4110 "INSERT INTO logs_chat(id_user,id_room,timestamp,description,id_type,id_session) VALUES('" & _
        Proc_10_11_80A9C0(userId, 0, 0) & "','" & CStr(roomId) & "',UNIX_TIMESTAMP(),'" & _
        Proc_10_11_80A9C0(filteredText, 0, 0) & "','" & CStr(idType) & "','" & _
        Proc_10_11_80A9C0(HandlingUserSessionId(userId), 0, 0) & "')", 0, 0

    payload = CStr(Proc_3_0_6D2AF0(roomUserIndex, Empty, IIf(chatType = 1, "@Y", "@X")))
    payload = payload & filteredText & Chr$(2)
    payload = CStr(Proc_3_0_6D2AF0(gestureId, Empty, payload))

    If chatType = 2 Then
        targetSocketIndex = HandlingSocketIndexForUserName(targetName)
        If targetSocketIndex > 0 Then
            Proc_6_244_801E80 targetSocketIndex, payload, 0
            Proc_6_244_801E80 socketIndex, payload, 0
        Else
            Proc_6_244_801E80 socketIndex, payload, 0
        End If
    Else
        Proc_6_245_801FA0 socketIndex, payload, 0
    End If

    HandlingRepresentedChatRoute = payload
    Exit Function

ChatDone:
    HandlingRepresentedChatRoute = Empty
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
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim requestPayload As String
    Dim candidateName As String
    Dim offset As Long

    On Error GoTo ApplyFailed

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    If Len(packetPayload) = 0 And UBound(args) >= 1 Then packetPayload = CStr(args(1))

    requestPayload = packetPayload
    If Left$(requestPayload, 2) = "GV" Then requestPayload = Mid$(requestPayload, 3)

    offset = 1
    candidateName = CStr(Proc_10_10_80A7F0(ReadWireString(requestPayload, offset), 0, 0))
    If Len(candidateName) = 0 Then candidateName = CStr(Proc_10_10_80A7F0(Proc_10_7_80A190(requestPayload, 0, 0), 0, 0))

    Proc_6_38_70FD10 = Proc_6_40_711770(socketIndex, 0, candidateName)
    Exit Function

ApplyFailed:
    Proc_6_38_70FD10 = Empty
End Function

' Original declaration: Private Sub Proc_6_39_711650
Public Function Proc_6_39_711650(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim requestPayload As String
    Dim candidateName As String
    Dim offset As Long

    On Error GoTo CheckFailed

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    If Len(packetPayload) = 0 And UBound(args) >= 1 Then packetPayload = CStr(args(1))

    requestPayload = packetPayload
    If Left$(requestPayload, 2) = "GW" Then requestPayload = Mid$(requestPayload, 3)

    offset = 1
    candidateName = CStr(Proc_10_10_80A7F0(ReadWireString(requestPayload, offset), 0, 0))
    If Len(candidateName) = 0 Then candidateName = CStr(Proc_10_10_80A7F0(Proc_10_7_80A190(requestPayload, 0, 0), 0, 0))

    Proc_6_39_711650 = Proc_6_40_711770(socketIndex, -1, candidateName)
    Exit Function

CheckFailed:
    Proc_6_39_711650 = Empty
End Function

' Original declaration: Private  Proc_6_40_711770(arg_C, arg_10) '711770
Public Function Proc_6_40_711770(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim checkOnly As Boolean
    Dim candidateName As String
    Dim userId As String
    Dim oldName As String
    Dim genderText As String
    Dim roomId As Long
    Dim validationCode As Long
    Dim roomUserIndex As Long
    Dim queryTail As String

    On Error GoTo RenameFailed
    If UBound(args) < 2 Then GoTo RenameFailed

    socketIndex = HandlingSocketIndex(args)
    checkOnly = (CLng(Val(CStr(args(1)))) < 0)
    candidateName = Trim$(CStr(args(2)))
    If socketIndex <= 0 Then GoTo RenameFailed

    userId = HandlingUserIdFromSocket(socketIndex)
    If Len(userId) = 0 Or userId = "0" Then GoTo RenameFailed

    oldName = CStr(Proc_5_2_6D4690("SELECT name FROM users WHERE id='" & Proc_10_11_80A9C0(userId, 0, 0) & "' LIMIT 1", 0, 0))
    genderText = CStr(Proc_5_2_6D4690("SELECT gender FROM users WHERE id='" & Proc_10_11_80A9C0(userId, 0, 0) & "' LIMIT 1", 0, 0))

    validationCode = AvatarNameValidationCode(candidateName, oldName)
    Proc_6_244_801E80 socketIndex, CStr(Proc_3_0_6D2AF0(validationCode, Empty, "H{")) & candidateName & Chr$(2), 0
    If checkOnly Or validationCode <> 0 Then
        Proc_6_40_711770 = validationCode
        Exit Function
    End If

    Proc_5_0_6D3CD0 "UPDATE users SET name='" & Proc_10_11_80A9C0(candidateName, 0, 0) & "',tutorial_name='1',merge_name='0' WHERE id='" & Proc_10_11_80A9C0(userId, 0, 0) & "'", 0, 0
    Proc_5_1_6D4110 "INSERT INTO logs_identity(previous_identity,new_identity,timestamp,id_session) VALUES('" & Proc_10_11_80A9C0(oldName, 0, 0) & "','" & Proc_10_11_80A9C0(candidateName, 0, 0) & "',UNIX_TIMESTAMP(),'" & CStr(socketIndex) & "')", 0, 0

    roomId = HandlingCurrentRoomId(socketIndex, userId)
    If roomId > 0 Then
        roomUserIndex = RepresentedRoomUserIndex(socketIndex, userId)
        Proc_6_247_8027E0 socketIndex, CStr(Proc_3_0_6D2AF0(roomUserIndex, Empty, CStr(Proc_3_0_6D2AF0(CLng(Val(userId)), Empty, "H|")))) & candidateName & Chr$(2), 0
        queryTail = "users,rooms,rooms_categories WHERE rooms.id='" & CStr(roomId) & "' AND users.id=rooms.id_owner AND rooms_categories.id=rooms.id_category LIMIT 1"
        Proc_6_247_8027E0 socketIndex, CStr(Proc_6_112_74E0C0(queryTail, "GF", 0)), 0
        Proc_6_247_8027E0 socketIndex, CStr(Proc_3_0_6D2AF0(roomId, Empty, "GH")), 0
    End If

    Proc_6_40_711770 = 0
    Exit Function

RenameFailed:
    Proc_6_40_711770 = Empty
End Function

' Original declaration: Private  Proc_6_41_712730(arg_C) '712730
Public Function Proc_6_41_712730(ParamArray args() As Variant) As Variant
    Dim fields() As String
    Dim recordText As String
    Dim userId As Long
    Dim userName As String
    Dim figureText As String
    Dim mottoText As String
    Dim genderText As String
    Dim roomUserIndex As Long
    Dim xValue As Long
    Dim yValue As Long
    Dim zValue As String
    Dim firstState As Long
    Dim secondState As Long
    Dim payload As String

    On Error GoTo BuildFailed
    If UBound(args) < 0 Then GoTo BuildFailed

    If UBound(args) = 0 Then
        recordText = CStr(args(0))
        If InStr(1, recordText, Chr$(9), vbBinaryCompare) > 0 Then
            fields = Split(recordText, Chr$(9))
            userId = CLng(Val(HandlingField(fields, 0)))
            userName = HandlingField(fields, 1)
            figureText = HandlingField(fields, 2)
            mottoText = HandlingField(fields, 3)
            genderText = HandlingField(fields, 4)
            roomUserIndex = CLng(Val(HandlingField(fields, 5)))
            xValue = CLng(Val(HandlingField(fields, 6)))
            yValue = CLng(Val(HandlingField(fields, 7)))
            zValue = HandlingField(fields, 8)
            firstState = CLng(Val(HandlingField(fields, 9)))
            secondState = CLng(Val(HandlingField(fields, 10)))
        Else
            userId = CLng(Val(recordText))
            roomUserIndex = userId
        End If
    Else
        userId = CLng(Val(CStr(args(0))))
        userName = CStr(args(1))
        If UBound(args) >= 2 Then figureText = CStr(args(2))
        If UBound(args) >= 3 Then mottoText = CStr(args(3))
        If UBound(args) >= 4 Then genderText = CStr(args(4))
        If UBound(args) >= 5 Then roomUserIndex = CLng(Val(CStr(args(5))))
        If UBound(args) >= 6 Then xValue = CLng(Val(CStr(args(6))))
        If UBound(args) >= 7 Then yValue = CLng(Val(CStr(args(7))))
        If UBound(args) >= 8 Then zValue = CStr(args(8))
        If UBound(args) >= 9 Then firstState = CLng(Val(CStr(args(9))))
        If UBound(args) >= 10 Then secondState = CLng(Val(CStr(args(10))))
    End If

    If roomUserIndex <= 0 Then roomUserIndex = userId

    payload = CStr(Proc_3_0_6D2AF0(userId, Empty, vbNullString)) & userName & Chr$(2) & figureText
    payload = CStr(Proc_3_0_6D2AF0(roomUserIndex, Empty, payload & Chr$(2) & mottoText & Chr$(2)))
    payload = CStr(Proc_3_0_6D2AF0(xValue, Empty, "0" & payload))
    payload = CStr(Proc_3_0_6D2AF0(yValue, Empty, "0" & payload)) & zValue & Chr$(2) & "JI"
    payload = payload & genderText & Chr$(2) & "M"
    payload = CStr(Proc_3_0_6D2AF0(firstState, Empty, payload))
    Proc_6_41_712730 = CStr(Proc_3_0_6D2AF0(secondState, Empty, payload & "M" & Chr$(2)))
    Exit Function

BuildFailed:
    Proc_6_41_712730 = vbNullString
End Function

' Original declaration: Private  Proc_6_42_712FB0(arg_C) '712FB0
Public Function Proc_6_42_712FB0(ParamArray args() As Variant) As Variant
    Dim fields() As String
    Dim recordText As String
    Dim objectType As Long
    Dim entityId As Long
    Dim roomUserIndex As Long
    Dim xValue As Long
    Dim yValue As Long
    Dim zValue As String
    Dim displayName As String
    Dim figureText As String
    Dim genderText As String
    Dim payload As String
    Dim tailMarker As String

    On Error GoTo BuildFailed
    If UBound(args) < 0 Then GoTo BuildFailed

    If UBound(args) = 0 Then
        recordText = CStr(args(0))
        If InStr(1, recordText, Chr$(9), vbBinaryCompare) > 0 Then
            fields = Split(recordText, Chr$(9))
            entityId = CLng(Val(HandlingField(fields, 0)))
            displayName = HandlingField(fields, 1)
            figureText = HandlingField(fields, 2)
            genderText = HandlingField(fields, 3)
            roomUserIndex = CLng(Val(HandlingField(fields, 4)))
            xValue = CLng(Val(HandlingField(fields, 5)))
            yValue = CLng(Val(HandlingField(fields, 6)))
            zValue = HandlingField(fields, 7)
            objectType = CLng(Val(HandlingField(fields, 8)))
        Else
            entityId = CLng(Val(recordText))
            roomUserIndex = entityId
        End If
    Else
        entityId = CLng(Val(CStr(args(0))))
        displayName = CStr(args(1))
        If UBound(args) >= 2 Then figureText = CStr(args(2))
        If UBound(args) >= 3 Then genderText = CStr(args(3))
        If UBound(args) >= 4 Then roomUserIndex = CLng(Val(CStr(args(4))))
        If UBound(args) >= 5 Then xValue = CLng(Val(CStr(args(5))))
        If UBound(args) >= 6 Then yValue = CLng(Val(CStr(args(6))))
        If UBound(args) >= 7 Then zValue = CStr(args(7))
        If UBound(args) >= 8 Then objectType = CLng(Val(CStr(args(8))))
    End If

    If roomUserIndex <= 0 Then roomUserIndex = entityId
    If objectType = 3 Then
        payload = CStr(Proc_3_0_6D2AF0(entityId, Empty, vbNullString))
        tailMarker = "PAJJ"
    Else
        payload = "M"
        tailMarker = "HK"
    End If

    payload = payload & displayName & Chr$(2)
    payload = payload & figureText & Chr$(2)
    payload = payload & genderText & Chr$(2)
    payload = payload & CStr(Proc_3_0_6D2AF0(roomUserIndex, Empty, vbNullString))
    payload = payload & CStr(Proc_3_0_6D2AF0(xValue, Empty, vbNullString))
    payload = payload & CStr(Proc_3_0_6D2AF0(yValue, Empty, vbNullString))
    payload = payload & zValue & Chr$(2)
    Proc_6_42_712FB0 = payload & tailMarker
    Exit Function

BuildFailed:
    Proc_6_42_712FB0 = vbNullString
End Function

' Original declaration: Private Sub Proc_6_43_713680
Public Function Proc_6_43_713680(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim requestPayload As String
    Dim callerUserId As String
    Dim roomId As Long
    Dim requestedRoomId As Long
    Dim roomRow As String
    Dim roomFields() As String
    Dim rightsRow As String
    Dim payload As String
    Dim offset As Long

    On Error GoTo SettingsReadFailed

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 2 Then
        packetPayload = CStr(args(2))
    ElseIf UBound(args) >= 1 Then
        packetPayload = CStr(args(1))
    End If

    requestPayload = packetPayload
    If Left$(requestPayload, 2) = "FF" Then requestPayload = Mid$(requestPayload, 3)

    requestedRoomId = CLng(Val(CStr(Proc_10_6_809F10(requestPayload, 0, 0))))
    If requestedRoomId <= 0 Then
        offset = 1
        requestedRoomId = ReadWireLong(requestPayload, offset)
    End If

    callerUserId = HandlingUserIdFromSocket(socketIndex)
    If Len(callerUserId) = 0 Or callerUserId = "0" Then GoTo SettingsReadFailed

    roomId = requestedRoomId
    If roomId <= 0 Then roomId = HandlingCurrentRoomId(socketIndex, callerUserId)
    If roomId <= 0 Then GoTo SettingsReadFailed

    If Not HandlingUserOwnsRoom(callerUserId, roomId) Then
        If Not HandlingUserHasPermission(callerUserId, "fuse_any_room_controller") Then GoTo SettingsReadFailed
    End If

    roomRow = CStr(Proc_5_2_6D4690("SELECT rooms.id,rooms.name,rooms.description,rooms.status_door,rooms.id_category,rooms.visitors_max,models.visitors_max,rooms.tag_1,rooms.tag_2,NULL,rooms.allow_otherspets,rooms.allow_feedpets,rooms.allow_walkthrough,rooms.disable_walls FROM rooms,models WHERE rooms.id='" & CStr(roomId) & "' AND models.id=rooms.id_model LIMIT 1", 0, 0))
    If Len(roomRow) = 0 Then GoTo SettingsReadFailed

    roomFields = Split(roomRow, Chr$(9))
    If UBound(roomFields) < 13 Then GoTo SettingsReadFailed

    rightsRow = CStr(Proc_5_2_6D4690("SELECT users.id,users.name FROM rooms_rights,users WHERE rooms_rights.id_room='" & CStr(roomId) & "' AND users.id=rooms_rights.id_user LIMIT 250", 0, 0))
    payload = RoomSettingsReadPayload(roomFields, rightsRow)
    If Len(payload) = 0 Then GoTo SettingsReadFailed

    Proc_6_244_801E80 socketIndex, payload, 0

SettingsReadFailed:
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
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim requestPayload As String
    Dim targetName As String
    Dim targetRow As String
    Dim targetFields() As String
    Dim targetUserId As String
    Dim targetSocketIndex As Long
    Dim targetRoomId As Long

    On Error GoTo FollowFailed

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 2 Then
        packetPayload = CStr(args(2))
    ElseIf UBound(args) >= 1 Then
        packetPayload = CStr(args(1))
    End If

    requestPayload = packetPayload
    If Left$(requestPayload, 2) = "Ab" Then requestPayload = Mid$(requestPayload, 3)

    targetName = CStr(Proc_10_7_80A190(requestPayload, 0, 0))
    targetName = Trim$(targetName)
    If Len(targetName) = 0 Then GoTo TargetUnavailable

    targetRow = CStr(Proc_5_2_6D4690("SELECT users.id,users.id_socket,logs_visitedrooms.id_room FROM users,logs_visitedrooms WHERE users.name='" & Proc_10_11_80A9C0(targetName, 0, 0) & "' AND users.id=logs_visitedrooms.id_user AND logs_visitedrooms.timestamp_left IS NULL LIMIT 1", 0, 0))
    If Len(targetRow) = 0 Then GoTo TargetUnavailable

    targetFields = Split(targetRow, Chr$(9))
    If UBound(targetFields) < 2 Then GoTo TargetUnavailable

    targetUserId = CStr(Val(CStr(targetFields(0))))
    targetSocketIndex = CLng(Val(CStr(targetFields(1))))
    targetRoomId = CLng(Val(CStr(targetFields(2))))
    If targetUserId = "0" Or targetSocketIndex <= 0 Or targetRoomId <= 0 Then GoTo TargetUnavailable

    Proc_6_57_71E8F0 socketIndex, targetRoomId, vbNullString

FollowFailed:
    Proc_6_50_7166B0 = Empty
    Exit Function

TargetUnavailable:
    Proc_6_244_801E80 socketIndex, "BC", 0
    GoTo FollowFailed
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
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim userId As String
    Dim roomId As Long
    Dim roomName As String
    Dim roomPassword As String
    Dim doorStatus As Long
    Dim roomDescription As String
    Dim visitorsMax As Long
    Dim categoryId As Long
    Dim tagOne As String
    Dim tagTwo As String
    Dim allowOthersPets As Long
    Dim allowFeedPets As Long
    Dim allowWalkthrough As Long
    Dim disableWalls As Long
    Dim thicknessFloor As Long
    Dim thicknessWallpaper As Long
    Dim queryText As String
    Dim queryTail As String
    Dim roomOptionPayload As String

    On Error GoTo SettingsFailed

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 2 Then
        packetPayload = CStr(args(2))
    ElseIf UBound(args) >= 1 Then
        packetPayload = CStr(args(1))
    End If
    If Left$(packetPayload, 2) = "FQ" Then packetPayload = Mid$(packetPayload, 3)

    userId = HandlingUserIdFromSocket(socketIndex)
    If Len(userId) = 0 Or userId = "0" Then GoTo SettingsFailed

    roomId = HandlingCurrentRoomId(socketIndex, userId)
    If roomId <= 0 Then GoTo SettingsFailed

    If Not HandlingUserOwnsRoom(userId, roomId) Then
        If Not HandlingUserHasPermission(userId, "fuse_any_room_controller") Then GoTo SettingsFailed
    End If

    If Not RoomSettingsFromWire(packetPayload, roomName, roomPassword, doorStatus, roomDescription, _
        visitorsMax, categoryId, tagOne, tagTwo, allowOthersPets, allowFeedPets, allowWalkthrough, _
        disableWalls, thicknessFloor, thicknessWallpaper) Then GoTo SettingsFailed

    categoryId = RoomCategoryForUser(categoryId, userId)
    If categoryId <= 0 Then GoTo SettingsFailed

    If disableWalls <> 0 Then
        If Not HandlingUserHasPermission(userId, "fuse_hide_room_walls") Then disableWalls = 0
    End If

    queryText = "UPDATE rooms SET thickness_floor='" & CStr(thicknessFloor) & "',thickness_wallpaper='" & CStr(thicknessWallpaper) & "',name='"
    queryText = queryText & Proc_10_11_80A9C0(roomName, 0, 0) & "',password='" & Proc_10_11_80A9C0(roomPassword, 0, 0) & "',description='"
    queryText = queryText & Proc_10_11_80A9C0(roomDescription, 0, 0) & "',status_door='" & CStr(doorStatus) & "',id_category='" & CStr(categoryId) & "'"
    queryText = queryText & ",tag_1=" & NullableSqlText(tagOne) & ",tag_2=" & NullableSqlText(tagTwo)
    queryText = queryText & ",allow_otherspets='" & CStr(allowOthersPets) & "',allow_feedpets='" & CStr(allowFeedPets) & "',allow_walkthrough='"
    queryText = queryText & CStr(allowWalkthrough) & "',visitors_max='" & CStr(visitorsMax) & "',disable_walls='" & CStr(disableWalls) & "' WHERE id='" & CStr(roomId) & "'"
    Proc_5_0_6D3CD0 queryText, 0, 0

    queryTail = "users,rooms,rooms_categories WHERE rooms.id='" & CStr(roomId) & "' AND users.id=rooms.id_owner AND rooms_categories.id=rooms.id_category LIMIT 1"
    Proc_6_247_8027E0 socketIndex, CStr(Proc_6_112_74E0C0(queryTail, "GF", 0)), 0
    Proc_6_244_801E80 socketIndex, CStr(Proc_3_0_6D2AF0(roomId, Empty, "GS")), 0
    Proc_6_244_801E80 socketIndex, CStr(Proc_3_0_6D2AF0(roomId, Empty, "GH")), 0

    roomOptionPayload = CStr(Proc_3_0_6D2AF0(disableWalls, Empty, "GX"))
    roomOptionPayload = CStr(Proc_3_0_6D2AF0(thicknessFloor, Empty, roomOptionPayload))
    roomOptionPayload = CStr(Proc_3_0_6D2AF0(thicknessWallpaper, Empty, roomOptionPayload))
    Proc_6_244_801E80 socketIndex, roomOptionPayload, 0

SettingsFailed:
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
    Dim socketIndex As Integer
    Dim roomId As Long
    Dim preferredSlot As Long
    Dim reservedSlot As Long
    Dim userId As String
    Dim previousRoomId As Long
    Dim sessionId As String

    On Error GoTo EnterFailed

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 1 Then roomId = CLng(Val(CStr(args(1))))
    If UBound(args) >= 2 Then preferredSlot = CLng(Val(CStr(args(2))))
    If socketIndex <= 0 Or roomId <= 0 Then GoTo EnterFailed

    userId = HandlingUserIdFromSocket(socketIndex)
    If Len(userId) = 0 Or userId = "0" Then GoTo EnterFailed

    previousRoomId = HandlingCurrentRoomId(socketIndex, userId)
    If previousRoomId > 0 Then
        Proc_6_55_71A6E0 socketIndex, 0, 0
    End If

    reservedSlot = ReserveRepresentedRoomSlot(preferredSlot)
    If reservedSlot <= 0 Then
        Proc_6_244_801E80 socketIndex, CStr(Proc_10_8_80A580(1, 0, 0)), 0
        Proc_6_54_719050 = 0
        Exit Function
    End If

    LoadRepresentedRoomBots reservedSlot, roomId

    sessionId = CStr(Proc_5_2_6D4690("SELECT login_session FROM users WHERE id='" & _
        Proc_10_11_80A9C0(userId, 0, 0) & "' LIMIT 1", 0, 0))
    Proc_5_1_6D4110 "INSERT INTO logs_visitedrooms(id_user,id_room,timestamp_enter,id_session) VALUES('" & _
        Proc_10_11_80A9C0(userId, 0, 0) & "','" & CStr(roomId) & "',UNIX_TIMESTAMP(),'" & _
        Proc_10_11_80A9C0(sessionId, 0, 0) & "')", 0, 0
    Proc_5_0_6D3CD0 "UPDATE rooms SET id_slot='" & CStr(reservedSlot) & _
        "',visitors_now=visitors_now+1 WHERE id='" & CStr(roomId) & "'", 0, 0

    Proc_6_56_71E730 socketIndex, 0, 0
    Proc_6_53_718E00 socketIndex, 0, 0

    Proc_6_54_719050 = reservedSlot
    Exit Function

EnterFailed:
    If reservedSlot > 0 Then ReleaseRepresentedRoomSlot reservedSlot
    Proc_6_54_719050 = 0
End Function

' Original declaration: Private Sub Proc_6_55_71A6E0
Public Function Proc_6_55_71A6E0(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim userId As String
    Dim roomRow As String
    Dim fields() As String
    Dim visitId As Long
    Dim roomId As Long
    Dim slotId As Long
    Dim roomUserIndex As Long
    Dim leavePayload As String

    On Error GoTo LeaveFailed

    socketIndex = HandlingSocketIndex(args)
    If socketIndex <= 0 Then GoTo LeaveFailed

    userId = HandlingUserIdFromSocket(socketIndex)
    If Len(userId) = 0 Or userId = "0" Then GoTo LeaveFailed

    roomRow = CStr(Proc_5_2_6D4690("SELECT logs_visitedrooms.id,logs_visitedrooms.id_room,rooms.id_slot FROM logs_visitedrooms,rooms WHERE logs_visitedrooms.id_user='" & _
        Proc_10_11_80A9C0(userId, 0, 0) & "' AND logs_visitedrooms.timestamp_left IS NULL AND rooms.id=logs_visitedrooms.id_room ORDER BY logs_visitedrooms.timestamp_enter DESC LIMIT 1", 0, 0))
    If Len(roomRow) = 0 Then
        Proc_6_244_801E80 socketIndex, "J|H", 0
        Proc_6_55_71A6E0 = 0
        Exit Function
    End If

    fields = Split(roomRow, Chr$(9))
    If UBound(fields) < 2 Then GoTo LeaveFailed

    visitId = CLng(Val(HandlingField(fields, 0)))
    roomId = CLng(Val(HandlingField(fields, 1)))
    slotId = CLng(Val(HandlingField(fields, 2)))
    If roomId <= 0 Then GoTo LeaveFailed

    roomUserIndex = RepresentedRoomUserIndex(socketIndex, userId)
    If roomUserIndex > 0 Then
        leavePayload = CStr(Proc_3_0_6D2AF0(roomUserIndex, Empty, "@\"))
        Proc_6_247_8027E0 socketIndex, leavePayload, 0
    End If

    Proc_6_94_746990 socketIndex, 0, 0
    Proc_6_180_7C96F0 socketIndex, 0, 0

    If visitId > 0 Then
        Proc_5_0_6D3CD0 "UPDATE logs_visitedrooms SET timestamp_left=UNIX_TIMESTAMP() WHERE id='" & _
            CStr(visitId) & "' AND timestamp_left IS NULL", 0, 0
    Else
        Proc_5_0_6D3CD0 "UPDATE logs_visitedrooms SET timestamp_left=UNIX_TIMESTAMP() WHERE id_user='" & _
            Proc_10_11_80A9C0(userId, 0, 0) & "' AND id_room='" & CStr(roomId) & "' AND timestamp_left IS NULL", 0, 0
    End If

    Proc_5_0_6D3CD0 "UPDATE rooms SET visitors_now=IF(visitors_now>0,visitors_now-1,0) WHERE id='" & CStr(roomId) & "'", 0, 0
    If slotId > 0 Then
        ReleaseRepresentedRoomSlot slotId
        Proc_5_0_6D3CD0 "UPDATE rooms SET id_slot=null WHERE id='" & CStr(roomId) & "' AND id_slot='" & CStr(slotId) & "'", 0, 0
    End If

    Proc_6_244_801E80 socketIndex, "J|H", 0
    Proc_6_55_71A6E0 = roomId
    Exit Function

LeaveFailed:
    Proc_6_55_71A6E0 = 0
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
    Dim socketIndex As Integer
    Dim roomId As Long
    Dim suppliedPassword As String
    Dim userId As String
    Dim roomRow As String
    Dim fields() As String
    Dim visitorsNow As Long
    Dim visitorsMax As Long
    Dim doorStatus As Long
    Dim roomPassword As String
    Dim roomSlot As Long
    Dim ownerUserId As String
    Dim isOwner As Boolean
    Dim isBanned As Boolean

    On Error GoTo EnterFailed

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 1 Then roomId = CLng(Val(CStr(args(1))))
    If UBound(args) >= 2 Then suppliedPassword = CStr(args(2))
    If roomId <= 0 Then
        Proc_6_244_801E80 socketIndex, "C`H", 0
        Proc_6_57_71E8F0 = 0
        Exit Function
    End If

    userId = HandlingUserIdFromSocket(socketIndex)
    If Len(userId) = 0 Or userId = "0" Then GoTo EnterFailed

    roomRow = CStr(Proc_5_2_6D4690("SELECT visitors_now,visitors_max,status_door,password,id_slot,id_owner FROM rooms WHERE rooms.id='" & CStr(roomId) & "' LIMIT 1", 0, 0))
    If Len(roomRow) = 0 Then
        Proc_6_244_801E80 socketIndex, "C`H", 0
        Proc_6_57_71E8F0 = 0
        Exit Function
    End If

    fields = Split(roomRow, Chr$(9))
    If UBound(fields) < 5 Then GoTo EnterFailed

    visitorsNow = CLng(Val(CStr(fields(0))))
    visitorsMax = CLng(Val(CStr(fields(1))))
    doorStatus = CLng(Val(CStr(fields(2))))
    roomPassword = CStr(fields(3))
    roomSlot = CLng(Val(CStr(fields(4))))
    ownerUserId = CStr(Val(CStr(fields(5))))
    isOwner = (ownerUserId = CStr(Val(userId)))

    If Not isOwner Then
        isBanned = (CLng(Val(CStr(Proc_5_2_6D4690("SELECT id_user FROM rooms_bans WHERE id_user='" & Proc_10_11_80A9C0(userId, 0, 0) & "' AND id_room='" & CStr(roomId) & "' LIMIT 1", 0, 0)))) > 0)
        If isBanned Then
            Proc_6_53_718E00 socketIndex, 0, 0
            Proc_6_244_801E80 socketIndex, "C`PA", 0
            Proc_6_57_71E8F0 = 0
            Exit Function
        End If

        If visitorsMax > 0 And visitorsNow >= visitorsMax Then
            If Not HandlingUserHasPermission(userId, "fuse_enter_full_rooms") Then
                Proc_6_53_718E00 socketIndex, 0, 0
                Proc_6_244_801E80 socketIndex, "C`I", 0
                Proc_6_57_71E8F0 = 0
                Exit Function
            End If
        End If

        If doorStatus = 1 Then
            If Not HandlingUserHasPermission(userId, "fuse_enter_locked_rooms") Then
                Proc_6_53_718E00 socketIndex, 0, 0
                Proc_6_244_801E80 socketIndex, "C`H", 0
                Proc_6_57_71E8F0 = 0
                Exit Function
            End If
        ElseIf doorStatus = 2 Then
            If StrComp(roomPassword, suppliedPassword, vbBinaryCompare) <> 0 Then
                Proc_6_53_718E00 socketIndex, 0, 0
                Proc_6_244_801E80 socketIndex, "@a" & "fhFF", 0
                Proc_6_57_71E8F0 = 0
                Exit Function
            End If
        End If
    End If

    Proc_6_57_71E8F0 = Proc_6_54_719050(socketIndex, roomId, roomSlot)
    Exit Function

EnterFailed:
    Proc_6_57_71E8F0 = 0
End Function

' Original declaration: Private Sub Proc_6_58_71FCA0
Public Function Proc_6_58_71FCA0(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim roomIdText As String
    Dim passwordStart As Long
    Dim roomId As Long
    Dim roomPassword As String

    On Error GoTo EnterFailed

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 2 Then
        packetPayload = CStr(args(2))
    ElseIf UBound(args) >= 1 Then
        packetPayload = CStr(args(1))
    End If
    If Left$(packetPayload, 2) = "FG" Then packetPayload = Mid$(packetPayload, 3)

    EnsureRepresentedRoomSlotPool
    If Len(global_0082930C) = 0 Then
        Proc_6_244_801E80 socketIndex, CStr(Proc_10_8_80A580(1, 0, 0)), 0
        Proc_6_58_71FCA0 = 0
        Exit Function
    End If

    roomIdText = CStr(Proc_10_7_80A190(packetPayload, 0, 0))
    roomId = CLng(Val(roomIdText))
    passwordStart = 3 + Len(roomIdText)
    If passwordStart <= Len(packetPayload) Then
        roomPassword = CStr(Proc_10_6_809F10(Mid$(packetPayload, passwordStart), 0, 0))
    End If
    Proc_6_57_71E8F0 socketIndex, roomId, roomPassword

    Proc_6_58_71FCA0 = roomId
    Exit Function

EnterFailed:
    Proc_6_58_71FCA0 = 0
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
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim requestPayload As String
    Dim callerUserId As String
    Dim roomId As Long
    Dim furnitureId As Long
    Dim noteColor As String
    Dim noteCaption As String
    Dim rowText As String
    Dim fields() As String
    Dim productId As Long
    Dim broadcastPayload As String

    On Error GoTo StickyUpdateFailed

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    If Len(packetPayload) = 0 And UBound(args) >= 1 Then packetPayload = CStr(args(1))

    requestPayload = packetPayload
    If Left$(requestPayload, 2) = "AT" Then requestPayload = Mid$(requestPayload, 3)

    If Not StickyNoteUpdateFromWire(requestPayload, furnitureId, noteColor, noteCaption) Then GoTo StickyUpdateFailed
    If furnitureId <= 0 Then GoTo StickyUpdateFailed

    callerUserId = HandlingUserIdFromSocket(socketIndex)
    If Len(callerUserId) = 0 Or callerUserId = "0" Then GoTo StickyUpdateFailed

    roomId = HandlingCurrentRoomId(socketIndex, callerUserId)
    If roomId <= 0 Then GoTo StickyUpdateFailed
    If Not HandlingUserHasRoomRight(callerUserId, roomId) Then GoTo StickyUpdateFailed

    rowText = CStr(Proc_5_2_6D4690("SELECT id,id_product,sign,caption,position_wall FROM furnitures WHERE id='" & CStr(furnitureId) & "' AND id_room='" & CStr(roomId) & "' LIMIT 1", 0, 0))
    If Len(rowText) = 0 Then GoTo StickyUpdateFailed

    fields = Split(rowText, Chr$(9))
    If UBound(fields) < 1 Then GoTo StickyUpdateFailed

    productId = CLng(Val(CStr(fields(1))))
    If Left$(LCase$(CStr(Proc_8_12_806C30(productId, 18, 0))), 7) <> "post.it" Then GoTo StickyUpdateFailed

    Proc_5_0_6D3CD0 "UPDATE furnitures SET sign='" & Proc_10_11_80A9C0(noteColor, 0, 0) & "',caption='" & Proc_10_11_80A9C0(noteCaption, 0, 0) & "' WHERE id='" & CStr(furnitureId) & "'", 0, 0
    broadcastPayload = "AT" & CStr(furnitureId) & Chr$(1) & "AS" & CStr(furnitureId) & Chr$(2)
    broadcastPayload = CStr(Proc_3_0_6D2AF0(productId, Empty, broadcastPayload)) & CStr(productId) & Chr$(2) & noteColor & Chr$(2)
    Proc_6_247_8027E0 socketIndex, broadcastPayload, 0

StickyUpdateFailed:
    Proc_6_66_721D60 = Empty
End Function

' Original declaration: Private Sub Proc_6_67_722940
Public Function Proc_6_67_722940(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim requestPayload As String
    Dim callerUserId As String
    Dim roomId As Long
    Dim furnitureId As Long
    Dim rowText As String
    Dim fields() As String
    Dim productId As Long
    Dim noteColor As String
    Dim noteCaption As String
    Dim payload As String
    Dim offset As Long

    On Error GoTo StickyReadFailed

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    If Len(packetPayload) = 0 And UBound(args) >= 1 Then packetPayload = CStr(args(1))

    requestPayload = packetPayload
    If Left$(requestPayload, 2) = "AS" Then requestPayload = Mid$(requestPayload, 3)

    furnitureId = CLng(Val(CStr(Proc_10_6_809F10(requestPayload, 0, 0))))
    If furnitureId <= 0 Then
        offset = 1
        furnitureId = ReadWireLong(requestPayload, offset)
    End If
    If furnitureId <= 0 Then GoTo StickyReadFailed

    callerUserId = HandlingUserIdFromSocket(socketIndex)
    If Len(callerUserId) = 0 Or callerUserId = "0" Then GoTo StickyReadFailed

    roomId = HandlingCurrentRoomId(socketIndex, callerUserId)
    If roomId <= 0 Then GoTo StickyReadFailed

    rowText = CStr(Proc_5_2_6D4690("SELECT id,id_product,sign,caption FROM furnitures WHERE id='" & CStr(furnitureId) & "' AND id_room='" & CStr(roomId) & "' LIMIT 1", 0, 0))
    If Len(rowText) = 0 Then GoTo StickyReadFailed

    fields = Split(rowText, Chr$(9))
    If UBound(fields) < 3 Then GoTo StickyReadFailed

    productId = CLng(Val(CStr(fields(1))))
    If Left$(LCase$(CStr(Proc_8_12_806C30(productId, 18, 0))), 7) <> "post.it" Then GoTo StickyReadFailed

    noteColor = Left$(CStr(fields(2)), 6)
    If Len(noteColor) = 0 Then noteColor = "FFFF33"

    noteCaption = Replace(CStr(fields(3)), Chr$(31), Chr$(13), 1, -1, vbBinaryCompare)
    payload = "@p" & CStr(furnitureId) & Chr$(2) & noteColor & Chr$(13) & noteCaption & Chr$(2)
    Proc_6_244_801E80 socketIndex, payload, 0

StickyReadFailed:
    Proc_6_67_722940 = Empty
End Function

' Original declaration: Private Sub Proc_6_68_723170
Public Function Proc_6_68_723170(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim requestPayload As String
    Dim callerUserId As String
    Dim roomId As Long
    Dim furnitureId As Long
    Dim rowText As String
    Dim fields() As String
    Dim productId As Long
    Dim offset As Long

    On Error GoTo StickyDeleteFailed

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    If Len(packetPayload) = 0 And UBound(args) >= 1 Then packetPayload = CStr(args(1))

    requestPayload = packetPayload
    If Left$(requestPayload, 2) = "AU" Then requestPayload = Mid$(requestPayload, 3)

    furnitureId = CLng(Val(CStr(Proc_10_6_809F10(requestPayload, 0, 0))))
    If furnitureId <= 0 Then
        offset = 1
        furnitureId = ReadWireLong(requestPayload, offset)
    End If
    If furnitureId <= 0 Then GoTo StickyDeleteFailed

    callerUserId = HandlingUserIdFromSocket(socketIndex)
    If Len(callerUserId) = 0 Or callerUserId = "0" Then GoTo StickyDeleteFailed

    roomId = HandlingCurrentRoomId(socketIndex, callerUserId)
    If roomId <= 0 Then GoTo StickyDeleteFailed
    If Not HandlingUserOwnsRoom(callerUserId, roomId) Then GoTo StickyDeleteFailed

    rowText = CStr(Proc_5_2_6D4690("SELECT id,id_product,sign,caption FROM furnitures WHERE id='" & CStr(furnitureId) & "' AND id_room='" & CStr(roomId) & "' LIMIT 1", 0, 0))
    If Len(rowText) = 0 Then GoTo StickyDeleteFailed

    fields = Split(rowText, Chr$(9))
    If UBound(fields) < 1 Then GoTo StickyDeleteFailed

    productId = CLng(Val(CStr(fields(1))))
    If Left$(LCase$(CStr(Proc_8_12_806C30(productId, 18, 0))), 7) <> "post.it" Then GoTo StickyDeleteFailed

    Proc_5_0_6D3CD0 "DELETE FROM furnitures WHERE id='" & CStr(furnitureId) & "' LIMIT 1", 0, 0
    Proc_6_247_8027E0 socketIndex, "AT" & CStr(furnitureId), 0

StickyDeleteFailed:
    Proc_6_68_723170 = Empty
End Function

' Original declaration: Private Sub Proc_6_69_723630
Public Function Proc_6_69_723630(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim requestPayload As String
    Dim callerUserId As String
    Dim roomId As Long
    Dim furnitureId As Long
    Dim rowText As String
    Dim fields() As String
    Dim boxProductId As Long
    Dim openedProductId As Long
    Dim openedProductType As Long
    Dim boxAction As String
    Dim openedSign As String
    Dim offset As Long
    Dim previousOffset As Long
    Dim responseClass As String
    Dim responsePayload As String

    On Error GoTo PresentOpenFailed

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    If Len(packetPayload) = 0 And UBound(args) >= 1 Then packetPayload = CStr(args(1))

    requestPayload = packetPayload
    If Left$(requestPayload, 2) = "AN" Then requestPayload = Mid$(requestPayload, 3)

    furnitureId = CLng(Val(CStr(Proc_10_6_809F10(requestPayload, 0, 0))))
    If furnitureId <= 0 Then
        offset = 1
        previousOffset = offset
        furnitureId = ReadWireLong(requestPayload, offset)
        If offset <= previousOffset Then GoTo PresentOpenFailed
    End If
    If furnitureId <= 0 Then GoTo PresentOpenFailed

    callerUserId = HandlingUserIdFromSocket(socketIndex)
    If Len(callerUserId) = 0 Or callerUserId = "0" Then GoTo PresentOpenFailed

    roomId = HandlingCurrentRoomId(socketIndex, callerUserId)
    If roomId <= 0 Then GoTo PresentOpenFailed
    If Not HandlingUserHasRoomRight(callerUserId, roomId) Then GoTo PresentOpenFailed

    rowText = CStr(Proc_5_2_6D4690("SELECT id,id_product,id_destination,sign_extra FROM furnitures WHERE id='" & CStr(furnitureId) & "' AND id_room='" & CStr(roomId) & "' LIMIT 1", 0, 0))
    If Len(rowText) = 0 Then GoTo PresentOpenFailed

    fields = Split(rowText, Chr$(9))
    If UBound(fields) < 2 Then GoTo PresentOpenFailed

    boxProductId = CLng(Val(CStr(fields(1))))
    openedProductId = CLng(Val(CStr(fields(2))))
    If UBound(fields) >= 3 Then openedSign = CStr(fields(3))
    If boxProductId <= 0 Or openedProductId <= 0 Then GoTo PresentOpenFailed

    boxAction = LCase$(CStr(Proc_8_12_806C30(boxProductId, 17, 0)))
    If InStr(1, boxAction, "present_", vbTextCompare) = 0 Then GoTo PresentOpenFailed
    If StrComp(boxAction, "ecotron_box", vbTextCompare) = 0 Then GoTo PresentOpenFailed

    Proc_6_247_8027E0 socketIndex, "A^" & CStr(furnitureId) & Chr$(2) & "H" & Chr$(2), 0
    Proc_5_0_6D3CD0 "DELETE FROM furnitures WHERE id='" & CStr(furnitureId) & "' LIMIT 1", 0, 0
    Proc_5_0_6D3CD0 "INSERT INTO furnitures(id_product,id_owner,sign,task_owner,task_time) VALUES('" & _
        CStr(openedProductId) & "','" & Proc_10_11_80A9C0(callerUserId, 0, 0) & "','" & _
        Proc_10_11_80A9C0(openedSign, 0, 0) & "','" & Proc_10_11_80A9C0(callerUserId, 0, 0) & "',UNIX_TIMESTAMP())", 0, 0

    openedProductType = CLng(Val(CStr(Proc_8_12_806C30(openedProductId, 0, 0))))
    responseClass = "i"
    If openedProductType = 2 Then responseClass = "s"
    If openedProductType = 3 Then responseClass = "e"

    responsePayload = CStr(Proc_3_0_6D2AF0(openedProductId, Empty, "BA" & responseClass & Chr$(2)))
    responsePayload = responsePayload & CStr(Proc_8_12_806C30(openedProductId, 24, 0)) & Chr$(2)
    Proc_6_244_801E80 socketIndex, responsePayload, 0

PresentOpenFailed:
    Proc_6_69_723630 = Empty
End Function

' Original declaration: Private Sub Proc_6_70_724190
Public Function Proc_6_70_724190(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim requestPayload As String
    Dim callerUserId As String
    Dim roomId As Long
    Dim furnitureId As Long
    Dim rowText As String
    Dim fields() As String
    Dim productId As Long
    Dim currentState As Long
    Dim stateCount As Long
    Dim nextState As Long
    Dim encodedState As Long
    Dim offset As Long
    Dim previousOffset As Long
    Dim payload As String

    On Error GoTo WallStateFailed

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    If Len(packetPayload) = 0 And UBound(args) >= 1 Then packetPayload = CStr(args(1))

    requestPayload = packetPayload
    If Left$(requestPayload, 2) = "FI" Then requestPayload = Mid$(requestPayload, 3)

    furnitureId = CLng(Val(CStr(Proc_10_6_809F10(requestPayload, 0, 0))))
    If furnitureId <= 0 Then
        offset = 1
        previousOffset = offset
        furnitureId = ReadWireLong(requestPayload, offset)
        If offset <= previousOffset Then GoTo WallStateFailed
    End If
    If furnitureId <= 0 Then GoTo WallStateFailed

    callerUserId = HandlingUserIdFromSocket(socketIndex)
    If Len(callerUserId) = 0 Or callerUserId = "0" Then GoTo WallStateFailed

    roomId = HandlingCurrentRoomId(socketIndex, callerUserId)
    If roomId <= 0 Then GoTo WallStateFailed
    If Not HandlingUserHasRoomRight(callerUserId, roomId) Then GoTo WallStateFailed

    rowText = CStr(Proc_5_2_6D4690("SELECT id,id_product,sign,position_wall FROM furnitures WHERE id='" & CStr(furnitureId) & "' AND id_room='" & CStr(roomId) & "' AND position_wall IS NOT NULL LIMIT 1", 0, 0))
    If Len(rowText) = 0 Then GoTo WallStateFailed

    fields = Split(rowText, Chr$(9))
    If UBound(fields) < 2 Then GoTo WallStateFailed

    productId = CLng(Val(CStr(fields(1))))
    If productId <= 0 Then GoTo WallStateFailed

    currentState = CLng(Val(CStr(fields(2))))
    stateCount = CLng(Val(CStr(Proc_9_0_806F70(productId, 5, 0))))
    If stateCount <= 0 Then stateCount = CLng(Val(CStr(Proc_8_12_806C30(productId, 10, 0))))
    If stateCount <= 0 Then stateCount = 1

    nextState = currentState + 1
    If nextState > stateCount Then nextState = 0
    If nextState < 0 Then nextState = 0

    Proc_5_0_6D3CD0 "UPDATE furnitures SET sign='" & CStr(nextState) & "' WHERE id='" & CStr(furnitureId) & "'", 0, 0

    encodedState = 0
    payload = CStr(Proc_3_0_6D2AF0(productId, Empty, "AU" & CStr(furnitureId) & Chr$(2))) & CStr(nextState) & Chr$(2) & CStr(encodedState) & Chr$(2)
    Proc_6_247_8027E0 socketIndex, payload, 0

WallStateFailed:
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
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim requestPayload As String
    Dim callerUserId As String
    Dim roomId As Long
    Dim requestFlag As Long
    Dim offset As Long

    On Error GoTo DeleteFailed

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    If Len(packetPayload) = 0 And UBound(args) >= 1 Then packetPayload = CStr(args(1))

    requestPayload = packetPayload
    If Left$(requestPayload, 2) = "@W" Then requestPayload = Mid$(requestPayload, 3)

    requestFlag = CLng(Val(CStr(Proc_10_6_809F10(requestPayload, 0, 0))))
    If requestFlag = 0 And Len(requestPayload) > 0 Then
        offset = 1
        requestFlag = ReadWireLong(requestPayload, offset)
    End If
    If requestFlag <> 0 Then GoTo DeleteFailed

    callerUserId = HandlingUserIdFromSocket(socketIndex)
    If Len(callerUserId) = 0 Or callerUserId = "0" Then GoTo DeleteFailed

    roomId = HandlingCurrentRoomId(socketIndex, callerUserId)
    If roomId <= 0 Then GoTo DeleteFailed
    If Not HandlingUserOwnsRoom(callerUserId, roomId) Then GoTo DeleteFailed

    Proc_10_18_80C9E0 roomId, 0, 0
    Proc_5_0_6D3CD0 "DELETE FROM rooms WHERE id='" & CStr(roomId) & "' LIMIT 1", 0, 0
    Proc_6_53_718E00 socketIndex, 0, 0

DeleteFailed:
    Proc_6_72_7250D0 = Empty
End Function

' Original declaration: Private Sub Proc_6_73_725540
Public Function Proc_6_73_725540(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim requestPayload As String
    Dim userId As String
    Dim roomId As Long
    Dim furnitureId As Long
    Dim productId As Long
    Dim creditValue As Long
    Dim productSprite As String
    Dim productParts() As String
    Dim rowText As String
    Dim offset As Long

    On Error GoTo RedeemFailed

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    If Len(packetPayload) = 0 And UBound(args) >= 1 Then packetPayload = CStr(args(1))

    requestPayload = packetPayload
    If Left$(requestPayload, 2) = "AT" Then requestPayload = Mid$(requestPayload, 3)

    userId = HandlingUserIdFromSocket(socketIndex)
    If Len(userId) = 0 Or userId = "0" Then GoTo RedeemFailed

    roomId = HandlingCurrentRoomId(socketIndex, userId)
    If roomId <= 0 Then GoTo RedeemFailed
    If Not HandlingUserHasRoomRight(userId, roomId) And Not HandlingUserHasPermission(userId, "fuse_pick_up_any_furni") Then GoTo RedeemFailed

    furnitureId = CLng(Val(CStr(Proc_10_6_809F10(requestPayload, 0, 0))))
    If furnitureId <= 0 Then
        offset = 1
        furnitureId = ReadWireLong(requestPayload, offset)
    End If
    If furnitureId <= 0 Then GoTo RedeemFailed

    rowText = CStr(Proc_5_2_6D4690("SELECT id_product FROM furnitures WHERE id_room='" & CStr(roomId) & "' AND id='" & CStr(furnitureId) & "' LIMIT 1", 0, 0))
    productId = CLng(Val(rowText))
    If productId <= 0 Then GoTo RedeemFailed

    productSprite = CStr(Proc_8_12_806C30(productId, 17, 0))
    If Len(productSprite) = 0 Then productSprite = CStr(Proc_8_12_806C30(productId, 18, 0))
    If Left$(productSprite, 3) <> "CF_" And Left$(productSprite, 4) <> "CFC_" Then GoTo RedeemFailed

    productParts = Split(productSprite, "_")
    If UBound(productParts) < 1 Then GoTo RedeemFailed
    creditValue = CLng(Val(productParts(1)))
    If creditValue <= 0 Then GoTo RedeemFailed

    Proc_5_0_6D3CD0 "UPDATE users SET credits=credits+" & CStr(creditValue) & " WHERE id='" & Proc_10_11_80A9C0(userId, 0, 0) & "'", 0, 0
    Proc_6_244_801E80 socketIndex, "@F" & CStr(CLng(Val(CStr(Proc_5_2_6D4690("SELECT credits FROM users WHERE id='" & Proc_10_11_80A9C0(userId, 0, 0) & "' LIMIT 1", 0, 0))))) & ".0" & Chr$(2), 0
    Proc_6_247_8027E0 socketIndex, "A^" & CStr(furnitureId) & Chr$(2) & "H" & Chr$(2), 0
    Proc_5_0_6D3CD0 "DELETE FROM furnitures WHERE id='" & CStr(furnitureId) & "' LIMIT 1", 0, 0
    Proc_6_106_74B750 App.Path & "\CACHE\ROOMS\" & CStr(roomId) & ".cache", 0, 0
    Proc_6_106_74B750 App.Path & "\CACHE\PATHFINDER\" & CStr(roomId) & ".cache", 0, 0

RedeemFailed:
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
    Proc_6_205_7D9780 socketIndex, 3
    Proc_6_205_7D9780 targetSocketIndex, 2

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
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim requestPayload As String
    Dim offset As Long
    Dim furnitureId As Long
    Dim petName As String
    Dim validationCode As Long
    Dim userId As String
    Dim roomId As Long
    Dim rowText As String
    Dim fields() As String
    Dim productId As Long
    Dim ownerId As String
    Dim packageRow As String
    Dim packageFields() As String
    Dim packageType As String
    Dim containedPetId As Long
    Dim petRow As String
    Dim petFields() As String
    Dim petFigure As String
    Dim botId As Long
    Dim inventoryRow As String
    Dim responsePayload As String

    On Error GoTo PackagePetDone

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    If Len(packetPayload) = 0 And UBound(args) >= 1 Then packetPayload = CStr(args(1))

    requestPayload = packetPayload
    If Left$(requestPayload, 2) = "n~" Then requestPayload = Mid$(requestPayload, 3)

    offset = 1
    furnitureId = ReadWireLong(requestPayload, offset)
    If furnitureId <= 0 Then furnitureId = CLng(Val(CStr(Proc_10_6_809F10(requestPayload, 0, 0))))
    petName = CStr(Proc_10_10_80A7F0(ReadWireString(requestPayload, offset), 0, 0))
    If Len(petName) = 0 Then petName = CStr(Proc_10_10_80A7F0(Proc_10_7_80A190(requestPayload, 0, 0), 0, 0))

    validationCode = CLng(Val(CStr(Proc_6_181_7CA920(petName, 0, 0))))
    If validationCode > 0 Then
        Proc_6_244_801E80 socketIndex, CStr(Proc_3_0_6D2AF0(validationCode, Empty, CStr(Proc_3_0_6D2AF0(furnitureId, Empty, "Lz")))) & petName & Chr$(2), 0
        GoTo PackagePetDone
    End If

    If socketIndex <= 0 Or furnitureId <= 0 Then GoTo PackagePetDone
    userId = HandlingUserIdFromSocket(socketIndex)
    If Len(userId) = 0 Or userId = "0" Then GoTo PackagePetDone

    roomId = HandlingCurrentRoomId(socketIndex, userId)
    If roomId <= 0 Then GoTo PackagePetDone

    rowText = CStr(Proc_5_2_6D4690("SELECT id_product,id_owner FROM furnitures WHERE id='" & CStr(furnitureId) & _
        "' AND id_room='" & CStr(roomId) & "' LIMIT 1", 0, 0))
    If Len(rowText) = 0 Then GoTo PackagePetDone

    fields = Split(rowText, Chr$(9))
    productId = CLng(Val(HandlingField(fields, 0)))
    ownerId = CStr(CLng(Val(HandlingField(fields, 1))))
    If productId <= 0 Then GoTo PackagePetDone
    If ownerId <> userId And Not HandlingUserOwnsRoom(userId, roomId) And Not HandlingUserHasRoomRight(userId, roomId) Then GoTo PackagePetDone

    packageRow = CStr(Proc_5_2_6D4690("SELECT id_product,type_secondary,id_contain,type_check FROM packages WHERE id_product='" & _
        CStr(productId) & "' LIMIT 1", 0, 0))
    If Len(packageRow) = 0 Then GoTo PackagePetDone

    packageFields = Split(packageRow, Chr$(9))
    packageType = LCase$(HandlingField(packageFields, 1))
    containedPetId = CLng(Val(HandlingField(packageFields, 2)))
    If packageType <> "packages_pets" Or containedPetId <= 0 Then GoTo PackagePetDone

    petRow = CStr(Proc_5_2_6D4690("SELECT id_pet,id_race,color FROM packages_pets WHERE id='" & _
        CStr(containedPetId) & "' LIMIT 1", 0, 0))
    If Len(petRow) = 0 Then GoTo PackagePetDone

    petFields = Split(petRow, Chr$(9))
    petFigure = CStr(CLng(Val(HandlingField(petFields, 0)))) & Chr$(32) & _
        CStr(CLng(Val(HandlingField(petFields, 1)))) & Chr$(32) & HandlingField(petFields, 2)

    Proc_5_0_6D3CD0 "INSERT INTO bots(id_user,figure,name,id_handle) VALUES('" & Proc_10_11_80A9C0(userId, 0, 0) & "','" & _
        Proc_10_11_80A9C0(LCase$(petFigure), 0, 0) & "','" & Proc_10_11_80A9C0(petName, 0, 0) & "','3')", 0, 0
    botId = CLng(Val(CStr(Proc_5_2_6D4690("SELECT id FROM bots WHERE id_user='" & Proc_10_11_80A9C0(userId, 0, 0) & _
        "' AND id_handle='3' ORDER BY id DESC LIMIT 1", 0, 0))))
    If botId <= 0 Then GoTo PackagePetDone

    Proc_5_0_6D3CD0 "INSERT INTO bots_petdata(id_bot,timestamp_buy,id_owner,energy,nutrition,scratches) VALUES('" & _
        CStr(botId) & "',UNIX_TIMESTAMP(),'" & Proc_10_11_80A9C0(userId, 0, 0) & "','100','100','0')", 0, 0

    inventoryRow = RepresentedPetInventoryRow(botId, petName, petFigure, 0)
    If Len(inventoryRow) > 0 Then Proc_6_244_801E80 socketIndex, "I[" & inventoryRow, 0

    Proc_6_146_76D300 socketIndex, furnitureId, productId
    Proc_6_247_8027E0 socketIndex, "A^" & CStr(furnitureId) & Chr$(2) & "H" & Chr$(2), 0
    Proc_5_0_6D3CD0 "DELETE FROM furnitures WHERE id='" & CStr(furnitureId) & "' LIMIT 1", 0, 0

    responsePayload = CStr(Proc_3_0_6D2AF0(validationCode, Empty, CStr(Proc_3_0_6D2AF0(furnitureId, Empty, "Lz"))))
    Proc_6_244_801E80 socketIndex, responsePayload & petName & Chr$(2), 0
    Proc_6_87_73C120 = botId
    Exit Function

PackagePetDone:
    Proc_6_87_73C120 = Empty
End Function

' Original declaration: Private Sub Proc_6_88_73E4F0
Public Function Proc_6_88_73E4F0(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim rows() As String
    Dim fields() As String
    Dim rowIndex As Long
    Dim roomId As Long
    Dim modelType As Long
    Dim payload As String

    On Error GoTo SendFailed

    socketIndex = HandlingSocketIndex(args)

    If Len(global_0082908C) = 0 Or DateDiff("s", Now, global_00829090, vbSunday, vbFirstJan1) <= 0 Then
        global_0082908C = CStr(Proc_5_2_6D4690("SELECT rooms.id,models.type FROM rooms_categories,rooms,models WHERE rooms_categories.is_newfriends='1' AND rooms.id_category=rooms_categories.id AND models.id=rooms.id_model ORDER BY rooms.visitors_now DESC LIMIT 15", 0, 0))
        global_00829090 = DateAdd("s", 90, Now)
    End If

    If Len(global_0082908C) > 0 Then
        rows = Split(global_0082908C, Chr$(13))
        rowIndex = CLng(Val(CStr(Proc_10_4_809CA0(0, UBound(rows), 0))))
        If rowIndex < LBound(rows) Then rowIndex = LBound(rows)
        If rowIndex > UBound(rows) Then rowIndex = UBound(rows)

        If Len(rows(rowIndex)) > 0 Then
            fields = Split(rows(rowIndex), Chr$(9))
            If UBound(fields) >= 1 Then
                roomId = CLng(Val(CStr(fields(0))))
                modelType = CLng(Val(CStr(fields(1))))
            End If
        End If
    End If

    payload = "L" & Chr$(127)
    payload = CStr(Proc_3_0_6D2AF0(roomId, Empty, payload))
    payload = CStr(Proc_3_0_6D2AF0(modelType, Empty, payload))
    Proc_6_244_801E80 socketIndex, payload, 0

SendFailed:
    Proc_6_88_73E4F0 = Empty
End Function

' Original declaration: Private Sub Proc_6_89_73EA10
Public Function Proc_6_89_73EA10(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim userId As String
    Dim targetSocketIndex As Integer
    Dim targetUserId As String
    Dim sourceSqlIds As String
    Dim targetSqlIds As String
    Dim sourceLogItems As String
    Dim targetLogItems As String
    Dim roomId As Long
    Dim sessionId As String

    On Error GoTo TradeDone

    socketIndex = HandlingSocketIndex(args)
    If socketIndex <= 0 Then GoTo TradeDone

    targetSocketIndex = RepresentedInteractionPartner(socketIndex)
    If targetSocketIndex <= 0 Then GoTo TradeDone

    userId = HandlingUserIdFromSocket(socketIndex)
    targetUserId = HandlingUserIdFromSocket(targetSocketIndex)
    If Len(userId) = 0 Or userId = "0" Or Len(targetUserId) = 0 Or targetUserId = "0" Then GoTo TradeDone

    sourceSqlIds = RepresentedTradeOfferSqlIds(socketIndex)
    targetSqlIds = RepresentedTradeOfferSqlIds(targetSocketIndex)
    If Len(sourceSqlIds) = 0 And Len(targetSqlIds) = 0 Then GoTo TradeDone

    sourceLogItems = RepresentedTradeOfferLogItems(socketIndex)
    targetLogItems = RepresentedTradeOfferLogItems(targetSocketIndex)
    roomId = HandlingCurrentRoomId(socketIndex, userId)
    sessionId = HandlingUserSessionId(userId)

    If Len(sourceSqlIds) > 0 Then
        Proc_5_0_6D3CD0 "UPDATE furnitures SET id_owner='" & Proc_10_11_80A9C0(targetUserId, 0, 0) & _
            "' WHERE id IN (" & sourceSqlIds & ") AND id_owner='" & Proc_10_11_80A9C0(userId, 0, 0) & _
            "' AND id_room IS NULL", 0, 0
    End If
    If Len(targetSqlIds) > 0 Then
        Proc_5_0_6D3CD0 "UPDATE furnitures SET id_owner='" & Proc_10_11_80A9C0(userId, 0, 0) & _
            "' WHERE id IN (" & targetSqlIds & ") AND id_owner='" & Proc_10_11_80A9C0(targetUserId, 0, 0) & _
            "' AND id_room IS NULL", 0, 0
    End If

    Proc_5_1_6D4110 "INSERT INTO logs_trading(id_user,id_partner,items_user,items_partner,id_room,timestamp,id_session) VALUES('" & _
        Proc_10_11_80A9C0(userId, 0, 0) & "','" & Proc_10_11_80A9C0(targetUserId, 0, 0) & "','" & _
        Proc_10_11_80A9C0(sourceLogItems, 0, 0) & "','" & Proc_10_11_80A9C0(targetLogItems, 0, 0) & "','" & _
        CStr(roomId) & "',UNIX_TIMESTAMP(),'" & Proc_10_11_80A9C0(sessionId, 0, 0) & "')", 0, 0

    Proc_6_244_801E80 socketIndex, "Ap", 0
    Proc_6_244_801E80 targetSocketIndex, "Ap", 0
    Proc_6_140_769400 socketIndex, "FT", vbNullString
    Proc_6_140_769400 targetSocketIndex, "FT", vbNullString
    RemoveRepresentedInteractionPair socketIndex
    RemoveRepresentedInteractionPair targetSocketIndex

    Proc_6_89_73EA10 = "Ap"
    Exit Function

TradeDone:
    Proc_6_89_73EA10 = Empty
End Function

' Original declaration: Private Sub Proc_6_90_742E80
Public Function Proc_6_90_742E80(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim userId As String
    Dim targetSocketIndex As Integer
    Dim targetUserId As String
    Dim sourceRoomUserIndex As Long
    Dim interactionState As Long
    Dim sourcePayload As String
    Dim targetPayload As String

    On Error GoTo InteractionStateFailed

    socketIndex = HandlingSocketIndex(args)
    If socketIndex <= 0 Then GoTo InteractionStateFailed

    userId = HandlingUserIdFromSocket(socketIndex)
    If Len(userId) = 0 Or userId = "0" Then GoTo InteractionStateFailed

    sourceRoomUserIndex = RepresentedRoomUserIndex(socketIndex, userId)
    If sourceRoomUserIndex <= 0 Then GoTo InteractionStateFailed

    ' The original reads the paired socket from hidden session slot +15Ch and the
    ' interaction state from +160h. Until those slots are fully represented, accept
    ' the recovered pair/state as explicit arguments from callers that know them.
    If UBound(args) >= 1 Then targetSocketIndex = CInt(Val(CStr(args(1))))
    If targetSocketIndex <= 0 Then targetSocketIndex = RepresentedInteractionPartner(socketIndex)
    If UBound(args) >= 2 Then
        interactionState = CLng(Val(CStr(args(2))))
    Else
        interactionState = RepresentedInteractionState(socketIndex)
    End If
    If targetSocketIndex <= 0 Then GoTo InteractionStateFailed

    targetUserId = HandlingUserIdFromSocket(targetSocketIndex)
    If Len(targetUserId) = 0 Or targetUserId = "0" Then GoTo InteractionStateFailed

    sourcePayload = "0" & CStr(Proc_3_0_6D2AF0(interactionState, Empty, _
        "0" & CStr(Proc_3_0_6D2AF0(sourceRoomUserIndex, Empty, "Am"))))
    targetPayload = CStr(Proc_3_0_6D2AF0(interactionState, Empty, _
        CStr(Proc_3_0_6D2AF0(sourceRoomUserIndex, Empty, "Am"))))

    Proc_6_244_801E80 socketIndex, sourcePayload, 0
    Proc_6_244_801E80 targetSocketIndex, targetPayload, 0

    If interactionState = 1 Then
        Proc_6_244_801E80 socketIndex, "Ao", 0
        Proc_6_244_801E80 targetSocketIndex, "Ao", 0
    End If

InteractionStateFailed:
    Proc_6_90_742E80 = Empty
End Function

' Original declaration: Private Sub Proc_6_91_743480
Public Function Proc_6_91_743480(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim requestPayload As String
    Dim userId As String
    Dim targetSocketIndex As Integer
    Dim targetUserId As String
    Dim furnitureId As Long
    Dim productId As Long
    Dim signText As String
    Dim secondaryValue As Long
    Dim rowText As String
    Dim fields() As String
    Dim offset As Long
    Dim sourcePayload As String
    Dim targetPayload As String

    On Error GoTo CarryItemDone

    socketIndex = HandlingSocketIndex(args)
    If socketIndex <= 0 Then GoTo CarryItemDone
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    If Len(packetPayload) = 0 And UBound(args) >= 1 Then packetPayload = CStr(args(1))

    requestPayload = packetPayload
    If Left$(requestPayload, 2) = "FU" Then requestPayload = Mid$(requestPayload, 3)

    targetSocketIndex = RepresentedInteractionPartner(socketIndex)
    If targetSocketIndex <= 0 Then GoTo CarryItemDone

    userId = HandlingUserIdFromSocket(socketIndex)
    targetUserId = HandlingUserIdFromSocket(targetSocketIndex)
    If Len(userId) = 0 Or userId = "0" Or Len(targetUserId) = 0 Or targetUserId = "0" Then GoTo CarryItemDone

    furnitureId = CLng(Val(CStr(Proc_10_6_809F10(requestPayload, 0, 0))))
    If furnitureId <= 0 Then
        offset = 1
        furnitureId = ReadWireLong(requestPayload, offset)
    End If
    If furnitureId <= 0 Then GoTo CarryItemDone

    rowText = CStr(Proc_5_2_6D4690("SELECT id,id_product,sign,id_secondary FROM furnitures WHERE id='" & CStr(furnitureId) & _
        "' AND id_owner='" & Proc_10_11_80A9C0(userId, 0, 0) & "' AND id_room IS NULL LIMIT 1", 0, 0))
    If Len(rowText) = 0 Then GoTo CarryItemDone

    fields = Split(rowText, Chr$(9))
    productId = CLng(Val(HandlingField(fields, 1)))
    signText = HandlingField(fields, 2)
    secondaryValue = CLng(Val(HandlingField(fields, 3)))
    If productId <= 0 Then GoTo CarryItemDone

    StoreRepresentedTradeOffer socketIndex, furnitureId, productId, signText, secondaryValue

    sourcePayload = RepresentedTradeOfferPayload(socketIndex, targetSocketIndex, userId, targetUserId)
    targetPayload = RepresentedTradeOfferPayload(targetSocketIndex, socketIndex, targetUserId, userId)
    If Len(sourcePayload) > 0 Then Proc_6_244_801E80 socketIndex, sourcePayload, 0
    If Len(targetPayload) > 0 Then Proc_6_244_801E80 targetSocketIndex, targetPayload, 0

    Proc_6_91_743480 = sourcePayload
    Exit Function

CarryItemDone:
    Proc_6_91_743480 = Empty
End Function

' Original declaration: Private Sub Proc_6_92_744870
Public Function Proc_6_92_744870(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim requestPayload As String
    Dim userId As String
    Dim targetSocketIndex As Integer
    Dim targetUserId As String
    Dim furnitureId As Long
    Dim rowText As String
    Dim offset As Long
    Dim sourcePayload As String
    Dim targetPayload As String

    On Error GoTo RemoveItemDone

    socketIndex = HandlingSocketIndex(args)
    If socketIndex <= 0 Then GoTo RemoveItemDone
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    If Len(packetPayload) = 0 And UBound(args) >= 1 Then packetPayload = CStr(args(1))

    requestPayload = packetPayload
    If Left$(requestPayload, 2) = "AH" Then requestPayload = Mid$(requestPayload, 3)

    targetSocketIndex = RepresentedInteractionPartner(socketIndex)
    If targetSocketIndex <= 0 Then GoTo RemoveItemDone

    userId = HandlingUserIdFromSocket(socketIndex)
    targetUserId = HandlingUserIdFromSocket(targetSocketIndex)
    If Len(userId) = 0 Or userId = "0" Or Len(targetUserId) = 0 Or targetUserId = "0" Then GoTo RemoveItemDone

    furnitureId = CLng(Val(CStr(Proc_10_6_809F10(requestPayload, 0, 0))))
    If furnitureId <= 0 Then
        offset = 1
        furnitureId = ReadWireLong(requestPayload, offset)
    End If
    If furnitureId <= 0 Then GoTo RemoveItemDone

    rowText = CStr(Proc_5_2_6D4690("SELECT id,id_product,sign FROM furnitures WHERE id='" & CStr(furnitureId) & _
        "' AND id_owner='" & Proc_10_11_80A9C0(userId, 0, 0) & "' AND id_room IS NULL LIMIT 1", 0, 0))
    If Len(rowText) = 0 Then GoTo RemoveItemDone

    RemoveRepresentedTradeOffer socketIndex, furnitureId

    sourcePayload = RepresentedTradeOfferPayload(socketIndex, targetSocketIndex, userId, targetUserId)
    targetPayload = RepresentedTradeOfferPayload(targetSocketIndex, socketIndex, targetUserId, userId)
    If Len(sourcePayload) > 0 Then Proc_6_244_801E80 socketIndex, sourcePayload, 0
    If Len(targetPayload) > 0 Then Proc_6_244_801E80 targetSocketIndex, targetPayload, 0

    Proc_6_92_744870 = sourcePayload
    Exit Function

RemoveItemDone:
    Proc_6_92_744870 = Empty
End Function

' Original declaration: Private Sub Proc_6_93_745D90
Public Function Proc_6_93_745D90(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim requestPayload As String
    Dim callerUserId As String
    Dim targetUserId As String
    Dim callerRoomId As Long
    Dim requestedRoomUserIndex As Long
    Dim targetRoomUserIndex As Long
    Dim targetSocketIndex As Integer
    Dim targetRow As String
    Dim targetFields() As String
    Dim offset As Long
    Dim callerPayload As String
    Dim targetPayload As String

    On Error GoTo PairStartFailed

    socketIndex = HandlingSocketIndex(args)
    If socketIndex <= 0 Then GoTo PairStartFailed
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    If Len(packetPayload) = 0 And UBound(args) >= 1 Then packetPayload = CStr(args(1))

    requestPayload = packetPayload
    If Left$(requestPayload, 2) = "AG" Then requestPayload = Mid$(requestPayload, 3)

    offset = 1
    requestedRoomUserIndex = ReadWireLong(requestPayload, offset)
    If requestedRoomUserIndex <= 0 Then requestedRoomUserIndex = CLng(Val(CStr(Proc_10_6_809F10(requestPayload, 0, 0))))
    If requestedRoomUserIndex <= 0 Then GoTo PairStartFailed

    callerUserId = HandlingUserIdFromSocket(socketIndex)
    If Len(callerUserId) = 0 Or callerUserId = "0" Then GoTo PairStartFailed

    callerRoomId = HandlingCurrentRoomId(socketIndex, callerUserId)
    If callerRoomId <= 0 Then GoTo PairStartFailed

    targetRow = CStr(Proc_5_2_6D4690("SELECT logs_visitedrooms.id,logs_visitedrooms.id_user,users.id_socket FROM logs_visitedrooms,users WHERE logs_visitedrooms.id='" & _
        CStr(requestedRoomUserIndex) & "' AND logs_visitedrooms.id_room='" & CStr(callerRoomId) & "' AND logs_visitedrooms.timestamp_left IS NULL AND users.id=logs_visitedrooms.id_user LIMIT 1", 0, 0))
    If Len(targetRow) = 0 Then
        targetRow = CStr(Proc_5_2_6D4690("SELECT logs_visitedrooms.id,logs_visitedrooms.id_user,users.id_socket FROM logs_visitedrooms,users WHERE logs_visitedrooms.id_user='" & _
            CStr(requestedRoomUserIndex) & "' AND logs_visitedrooms.id_room='" & CStr(callerRoomId) & "' AND logs_visitedrooms.timestamp_left IS NULL AND users.id=logs_visitedrooms.id_user LIMIT 1", 0, 0))
    End If
    If Len(targetRow) = 0 Then GoTo PairStartFailed

    targetFields = Split(targetRow, Chr$(9))
    If UBound(targetFields) < 2 Then GoTo PairStartFailed

    targetRoomUserIndex = CLng(Val(CStr(targetFields(0))))
    targetUserId = CStr(CLng(Val(CStr(targetFields(1)))))
    targetSocketIndex = CInt(Val(CStr(targetFields(2))))
    If targetRoomUserIndex <= 0 Or Len(targetUserId) = 0 Or targetUserId = "0" Then GoTo PairStartFailed
    If targetSocketIndex <= 0 Then targetSocketIndex = HandlingSocketFromUserId(targetUserId)
    If targetSocketIndex <= 0 Or targetSocketIndex = socketIndex Then GoTo PairStartFailed
    If RepresentedInteractionPartner(targetSocketIndex) > 0 Then GoTo PairStartFailed

    StoreRepresentedInteractionPair socketIndex, targetSocketIndex, 1

    callerPayload = CStr(Proc_3_0_6D2AF0(CLng(Val(targetUserId)), Empty, _
        CStr(Proc_3_0_6D2AF0(CLng(Val(callerUserId)), Empty, "Ah")) & global_004096B0)) & global_004096B0
    targetPayload = CStr(Proc_3_0_6D2AF0(CLng(Val(callerUserId)), Empty, _
        CStr(Proc_3_0_6D2AF0(CLng(Val(targetUserId)), Empty, "Ah")) & global_004096B0)) & global_004096B0

    Proc_6_244_801E80 socketIndex, callerPayload, 0
    Proc_6_244_801E80 targetSocketIndex, targetPayload, 0

PairStartFailed:
    Proc_6_93_745D90 = Empty
End Function

' Original declaration: Private Sub Proc_6_94_746990
Public Function Proc_6_94_746990(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim userId As String
    Dim sourceRoomUserIndex As Long
    Dim targetSocketIndex As Integer
    Dim targetUserId As String
    Dim targetRoomUserIndex As Long
    Dim sourcePayload As String
    Dim targetPayload As String

    On Error GoTo InteractionFailed

    socketIndex = HandlingSocketIndex(args)
    If socketIndex <= 0 Then GoTo InteractionFailed

    userId = HandlingUserIdFromSocket(socketIndex)
    If Len(userId) = 0 Or userId = "0" Then GoTo InteractionFailed

    sourceRoomUserIndex = RepresentedRoomUserIndex(socketIndex, userId)
    If sourceRoomUserIndex <= 0 Then GoTo InteractionFailed

    ' The original used hidden session slot +15Ch for the paired user/socket. Use an
    ' explicit second argument when the caller has recovered it; otherwise there is
    ' no represented pair to notify.
    If UBound(args) >= 1 Then targetSocketIndex = CInt(Val(CStr(args(1))))
    If targetSocketIndex <= 0 Then targetSocketIndex = RepresentedInteractionPartner(socketIndex)
    If targetSocketIndex <= 0 Then GoTo InteractionFailed

    targetUserId = HandlingUserIdFromSocket(targetSocketIndex)
    If Len(targetUserId) = 0 Or targetUserId = "0" Then GoTo InteractionFailed

    targetRoomUserIndex = RepresentedRoomUserIndex(targetSocketIndex, targetUserId)
    If targetRoomUserIndex <= 0 Then GoTo InteractionFailed

    sourcePayload = "0" & CStr(Proc_3_0_6D2AF0(sourceRoomUserIndex, Empty, "An"))
    targetPayload = "0" & CStr(Proc_3_0_6D2AF0(sourceRoomUserIndex, Empty, "An"))

    Proc_6_244_801E80 socketIndex, sourcePayload, 0
    Proc_6_244_801E80 targetSocketIndex, targetPayload, 0

InteractionFailed:
    Proc_6_94_746990 = Empty
End Function

' Original declaration: Private Sub Proc_6_95_746CD0
Public Function Proc_6_95_746CD0(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim requestPayload As String
    Dim userId As String
    Dim roomId As Long
    Dim furnitureId As Long
    Dim rowText As String
    Dim fields() As String
    Dim productId As Long
    Dim productAction As String

    On Error GoTo WheelCheckFailed

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    If Len(packetPayload) = 0 And UBound(args) >= 1 Then packetPayload = CStr(args(1))
    If Left$(packetPayload, 2) = "Cw" Then
        requestPayload = Mid$(packetPayload, 3)
    Else
        requestPayload = packetPayload
    End If

    userId = HandlingUserIdFromSocket(socketIndex)
    roomId = HandlingCurrentRoomId(socketIndex, userId)
    If Len(userId) = 0 Or userId = "0" Or roomId <= 0 Then GoTo WheelCheckFailed

    furnitureId = CLng(Val(CStr(Proc_10_6_809F10(requestPayload, 0, 0))))
    If furnitureId <= 0 Then GoTo WheelCheckFailed

    rowText = CStr(Proc_5_2_6D4690("SELECT id,position_x,position_y,id_product FROM furnitures WHERE id='" & CStr(furnitureId) & "' AND id_room='" & CStr(roomId) & "' LIMIT 1", 0, 0))
    If Len(rowText) = 0 Then GoTo WheelCheckFailed

    fields = Split(rowText, Chr$(9))
    productId = CLng(Val(HandlingField(fields, 3)))
    If productId <= 0 Then GoTo WheelCheckFailed

    productAction = CStr(Proc_8_12_806C30(productId, 17, 0))
    If StrComp(productAction, "habbowheel", vbBinaryCompare) <> 0 Then GoTo WheelCheckFailed

WheelCheckFailed:
    Proc_6_95_746CD0 = Empty
End Function

' Original declaration: Private Sub Proc_6_96_747000
Public Function Proc_6_96_747000(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim requestPayload As String
    Dim userId As String
    Dim roomId As Long
    Dim furnitureId As Long
    Dim rowText As String
    Dim fields() As String
    Dim furnitureX As Long
    Dim furnitureY As Long
    Dim productId As Long
    Dim productType As String
    Dim userX As Long
    Dim userY As Long
    Dim hasUserPosition As Boolean
    Dim payload As String

    On Error GoTo UseFailed

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    If Len(packetPayload) = 0 And UBound(args) >= 1 Then packetPayload = CStr(args(1))
    If Left$(packetPayload, 2) = "AM" Then
        requestPayload = Mid$(packetPayload, 3)
    Else
        requestPayload = packetPayload
    End If

    userId = HandlingUserIdFromSocket(socketIndex)
    roomId = HandlingCurrentRoomId(socketIndex, userId)
    If Len(userId) = 0 Or userId = "0" Or roomId <= 0 Then GoTo UseFailed

    furnitureId = CLng(Val(CStr(Proc_10_6_809F10(requestPayload, 0, 0))))
    If furnitureId <= 0 Then GoTo UseFailed

    rowText = CStr(Proc_5_2_6D4690("SELECT id,position_x,position_y,id_product FROM furnitures WHERE id='" & CStr(furnitureId) & "' AND id_room='" & CStr(roomId) & "' LIMIT 1", 0, 0))
    If Len(rowText) = 0 Then GoTo UseFailed

    fields = Split(rowText, Chr$(9))
    furnitureX = CLng(Val(HandlingField(fields, 1)))
    furnitureY = CLng(Val(HandlingField(fields, 2)))
    productId = CLng(Val(HandlingField(fields, 3)))
    If productId <= 0 Then GoTo UseFailed

    productType = CStr(Proc_8_12_806C30(productId, 0, 0))
    If Len(productType) > 0 And Val(productType) <> 0 Then GoTo UseFailed

    hasUserPosition = HandlingRepresentedUserPosition(args, userX, userY)
    If hasUserPosition Then
        If Abs(userX - furnitureX) > 2 Or Abs(userY - furnitureY) > 2 Then GoTo UseFailed
    End If

    payload = "0" & CStr(Proc_3_0_6D2AF0(0, Empty, CStr(Proc_3_0_6D2AF0(furnitureId, Empty, "AZ"))))
    Proc_6_247_8027E0 socketIndex, payload, 0
    Proc_6_151_78AC20 roomId, furnitureId, 0

UseFailed:
    Proc_6_96_747000 = Empty
End Function

' Original declaration: Private Sub Proc_6_97_747640
Public Function Proc_6_97_747640(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim requestPayload As String
    Dim userId As String
    Dim roomId As Long
    Dim furnitureId As Long
    Dim rowText As String
    Dim fields() As String
    Dim furnitureX As Long
    Dim furnitureY As Long
    Dim productId As Long
    Dim productType As String
    Dim userX As Long
    Dim userY As Long
    Dim hasUserPosition As Boolean
    Dim payload As String

    On Error GoTo UseFailed

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    If Len(packetPayload) = 0 And UBound(args) >= 1 Then packetPayload = CStr(args(1))
    If Left$(packetPayload, 2) = "AL" Then
        requestPayload = Mid$(packetPayload, 3)
    Else
        requestPayload = packetPayload
    End If

    userId = HandlingUserIdFromSocket(socketIndex)
    roomId = HandlingCurrentRoomId(socketIndex, userId)
    If Len(userId) = 0 Or userId = "0" Or roomId <= 0 Then GoTo UseFailed

    furnitureId = CLng(Val(CStr(Proc_10_6_809F10(requestPayload, 0, 0))))
    If furnitureId <= 0 Then GoTo UseFailed

    rowText = CStr(Proc_5_2_6D4690("SELECT id,position_x,position_y,id_product FROM furnitures WHERE id='" & CStr(furnitureId) & "' AND id_room='" & CStr(roomId) & "' LIMIT 1", 0, 0))
    If Len(rowText) = 0 Then GoTo UseFailed

    fields = Split(rowText, Chr$(9))
    furnitureX = CLng(Val(HandlingField(fields, 1)))
    furnitureY = CLng(Val(HandlingField(fields, 2)))
    productId = CLng(Val(HandlingField(fields, 3)))
    If productId <= 0 Then GoTo UseFailed

    productType = CStr(Proc_8_12_806C30(productId, 0, 0))
    If Len(productType) > 0 And Val(productType) <> 0 Then GoTo UseFailed

    hasUserPosition = HandlingRepresentedUserPosition(args, userX, userY)
    If hasUserPosition Then
        If Abs(userX - furnitureX) > 2 Or Abs(userY - furnitureY) > 2 Then GoTo UseFailed
    End If

    payload = "0" & CStr(Proc_3_0_6D2AF0(-1, Empty, CStr(Proc_3_0_6D2AF0(furnitureId, Empty, "AZ"))))
    Proc_6_247_8027E0 socketIndex, payload, 0
    Proc_6_145_76CA20 socketIndex, roomId, furnitureId

UseFailed:
    Proc_6_97_747640 = Empty
End Function

' Original declaration: Private Sub Proc_6_98_747D80
Public Function Proc_6_98_747D80(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim userId As String
    Dim roomId As Long
    Dim dimmerFurnitureId As Long
    Dim rowText As String
    Dim rows() As String
    Dim fields() As String
    Dim rowIndex As Long
    Dim presetId As Long
    Dim lightLevel As Long
    Dim backgroundId As Long
    Dim colourText As String
    Dim stateId As Long
    Dim currentPresetId As Long
    Dim presetPayload As String

    On Error GoTo DimmerDone

    socketIndex = HandlingSocketIndex(args)
    userId = HandlingUserIdFromSocket(socketIndex)
    If Len(userId) = 0 Or userId = "0" Then GoTo DimmerDone

    roomId = HandlingCurrentRoomId(socketIndex, userId)
    If roomId <= 0 Then GoTo DimmerDone
    If Not HandlingUserOwnsRoom(userId, roomId) And Not HandlingUserHasRoomRight(userId, roomId) Then GoTo DimmerDone

    dimmerFurnitureId = CLng(Val(CStr(Proc_5_2_6D4690("SELECT furnitures.id FROM furnitures,products WHERE furnitures.id_room='" & CStr(roomId) & "' AND products.id_type='9' AND furnitures.id_product=products.id LIMIT 1", 0, 0))))
    If dimmerFurnitureId <= 0 Then GoTo DimmerDone

    rowText = CStr(Proc_5_2_6D4690("SELECT id_light,id_preset,id_background,colour,id_state FROM furnitures_dimmerpresets WHERE id_furni='" & CStr(dimmerFurnitureId) & "' LIMIT 3", 0, 0))
    If Len(rowText) > 0 Then
        rows = Split(rowText, Chr$(13))
        For rowIndex = LBound(rows) To UBound(rows)
            If Len(rows(rowIndex)) > 0 Then
                fields = Split(rows(rowIndex), Chr$(9))
                If UBound(fields) >= 4 Then
                    lightLevel = CLng(Val(HandlingField(fields, 0)))
                    presetId = CLng(Val(HandlingField(fields, 1)))
                    backgroundId = CLng(Val(HandlingField(fields, 2)))
                    colourText = HandlingField(fields, 3)
                    stateId = CLng(Val(HandlingField(fields, 4)))

                    If stateId = 2 Or currentPresetId = 0 Then currentPresetId = presetId

                    presetPayload = presetPayload & CStr(Proc_3_0_6D2AF0(presetId, Empty, vbNullString))
                    presetPayload = presetPayload & CStr(Proc_3_0_6D2AF0(backgroundId, Empty, vbNullString))
                    presetPayload = presetPayload & CStr(Proc_3_0_6D2AF0(lightLevel, Empty, vbNullString))
                    presetPayload = presetPayload & colourText & Chr$(2)
                End If
            End If
        Next rowIndex
    End If

    Proc_6_244_801E80 socketIndex, CStr(Proc_3_0_6D2AF0(currentPresetId, Empty, CStr(Proc_3_0_6D2AF0(0, Empty, "Em")))) & presetPayload, 0

DimmerDone:
    Proc_6_98_747D80 = currentPresetId
End Function

' Original declaration: Private Sub Proc_6_99_748460
Public Function Proc_6_99_748460(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim userId As String
    Dim roomId As Long
    Dim dimmerFurnitureId As Long
    Dim rowText As String
    Dim fields() As String
    Dim lightLevel As Long
    Dim presetId As Long
    Dim backgroundId As Long
    Dim colourText As String
    Dim productId As Long
    Dim wallPosition As String
    Dim currentSign As String
    Dim currentState As Long
    Dim nextState As Long
    Dim signText As String

    On Error GoTo DimmerToggleDone

    socketIndex = HandlingSocketIndex(args)
    userId = HandlingUserIdFromSocket(socketIndex)
    If Len(userId) = 0 Or userId = "0" Then GoTo DimmerToggleDone

    roomId = HandlingCurrentRoomId(socketIndex, userId)
    If roomId <= 0 Then GoTo DimmerToggleDone
    If Not HandlingUserOwnsRoom(userId, roomId) And Not HandlingUserHasRoomRight(userId, roomId) Then GoTo DimmerToggleDone

    dimmerFurnitureId = CLng(Val(CStr(Proc_5_2_6D4690("SELECT furnitures.id FROM furnitures,products WHERE furnitures.id_room='" & CStr(roomId) & "' AND products.id_type='9' AND furnitures.id_product=products.id LIMIT 1", 0, 0))))
    If dimmerFurnitureId <= 0 Then GoTo DimmerToggleDone

    rowText = CStr(Proc_5_2_6D4690("SELECT furnitures_dimmerpresets.id_light,furnitures_dimmerpresets.id_preset,furnitures_dimmerpresets.id_background,furnitures_dimmerpresets.colour,furnitures.id_product,furnitures.position_wall,furnitures.sign FROM furnitures_dimmerpresets,furnitures WHERE furnitures_dimmerpresets.id_furni='" & CStr(dimmerFurnitureId) & "' AND furnitures_dimmerpresets.id_state='2' AND furnitures.id=furnitures_dimmerpresets.id_furni LIMIT 1", 0, 0))
    If Len(rowText) = 0 Then GoTo DimmerToggleDone

    fields = Split(rowText, Chr$(9))
    If UBound(fields) < 6 Then GoTo DimmerToggleDone

    lightLevel = CLng(Val(HandlingField(fields, 0)))
    presetId = CLng(Val(HandlingField(fields, 1)))
    backgroundId = CLng(Val(HandlingField(fields, 2)))
    colourText = HandlingField(fields, 3)
    productId = CLng(Val(HandlingField(fields, 4)))
    wallPosition = HandlingField(fields, 5)
    currentSign = HandlingField(fields, 6)

    currentState = CLng(Val(Left$(currentSign, 1)))
    If currentState <= 0 Then currentState = 2
    nextState = currentState - 1
    If nextState < 1 Then nextState = 2

    signText = CStr(nextState) & "," & CStr(presetId) & "," & CStr(backgroundId) & "," & colourText & "," & CStr(lightLevel)

    Proc_5_0_6D3CD0 "UPDATE furnitures SET sign='" & Proc_10_11_80A9C0(signText, 0, 0) & "' WHERE id='" & CStr(dimmerFurnitureId) & "'", 0, 0
    Proc_6_247_8027E0 socketIndex, "AU" & CStr(dimmerFurnitureId) & Chr$(2) & CStr(Proc_3_0_6D2AF0(productId, Empty, vbNullString)) & wallPosition & Chr$(2) & signText & Chr$(2), 0

    Proc_6_99_748460 = nextState
    Exit Function

DimmerToggleDone:
    Proc_6_99_748460 = Empty
End Function

' Original declaration: Private Sub Proc_6_100_748C80
Public Function Proc_6_100_748C80(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim requestPayload As String
    Dim userId As String
    Dim roomId As Long
    Dim dimmerFurnitureId As Long
    Dim presetId As Long
    Dim backgroundId As Long
    Dim colourText As String
    Dim lightLevel As Long
    Dim offset As Long
    Dim signText As String
    Dim rowText As String
    Dim fields() As String
    Dim productId As Long
    Dim wallPosition As String

    On Error GoTo DimmerUpdateDone

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    If Len(packetPayload) = 0 And UBound(args) >= 1 Then packetPayload = CStr(args(1))

    requestPayload = packetPayload
    If Left$(requestPayload, 2) = "EV" Then requestPayload = Mid$(requestPayload, 3)

    offset = 1
    presetId = ReadWireLong(requestPayload, offset)
    backgroundId = ReadWireLong(requestPayload, offset)
    colourText = UCase$(ReadWireString(requestPayload, offset))
    lightLevel = ReadWireLong(requestPayload, offset)

    If presetId < 1 Or presetId > 3 Then GoTo DimmerUpdateDone
    If backgroundId < 1 Or backgroundId > 2 Then GoTo DimmerUpdateDone
    If Not IsDimmerColour(colourText) Then GoTo DimmerUpdateDone
    If lightLevel < 76 Or lightLevel > 225 Then GoTo DimmerUpdateDone

    userId = HandlingUserIdFromSocket(socketIndex)
    If Len(userId) = 0 Or userId = "0" Then GoTo DimmerUpdateDone

    roomId = HandlingCurrentRoomId(socketIndex, userId)
    If roomId <= 0 Then GoTo DimmerUpdateDone
    If Not HandlingUserOwnsRoom(userId, roomId) And Not HandlingUserHasRoomRight(userId, roomId) Then GoTo DimmerUpdateDone

    dimmerFurnitureId = CLng(Val(CStr(Proc_5_2_6D4690("SELECT furnitures.id FROM furnitures,products WHERE furnitures.id_room='" & CStr(roomId) & "' AND products.id_type='9' AND furnitures.id_product=products.id LIMIT 1", 0, 0))))
    If dimmerFurnitureId <= 0 Then GoTo DimmerUpdateDone

    signText = "2," & CStr(presetId) & "," & CStr(backgroundId) & "," & colourText & "," & CStr(lightLevel)

    Proc_5_0_6D3CD0 "UPDATE furnitures_dimmerpresets SET id_state='1' WHERE id_furni='" & CStr(dimmerFurnitureId) & "'", 0, 0
    Proc_5_0_6D3CD0 "UPDATE furnitures_dimmerpresets SET id_state='2',id_light='" & CStr(lightLevel) & "',id_background='" & CStr(backgroundId) & "',colour='" & Proc_10_11_80A9C0(colourText, 0, 0) & "' WHERE id_furni='" & CStr(dimmerFurnitureId) & "' AND id_preset='" & CStr(presetId) & "'", 0, 0
    Proc_5_0_6D3CD0 "UPDATE furnitures SET sign='" & Proc_10_11_80A9C0(signText, 0, 0) & "' WHERE id='" & CStr(dimmerFurnitureId) & "'", 0, 0

    rowText = CStr(Proc_5_2_6D4690("SELECT id_product,position_wall FROM furnitures WHERE id='" & CStr(dimmerFurnitureId) & "' LIMIT 1", 0, 0))
    fields = Split(rowText, Chr$(9))
    If UBound(fields) >= 1 Then
        productId = CLng(Val(HandlingField(fields, 0)))
        wallPosition = HandlingField(fields, 1)
        Proc_6_247_8027E0 socketIndex, "AU" & CStr(dimmerFurnitureId) & Chr$(2) & CStr(Proc_3_0_6D2AF0(productId, Empty, vbNullString)) & wallPosition & Chr$(2) & signText & Chr$(2), 0
    End If

    Proc_6_100_748C80 = dimmerFurnitureId
    Exit Function

DimmerUpdateDone:
    Proc_6_100_748C80 = Empty
End Function

' Original declaration: Private Sub Proc_6_101_749540
Public Function Proc_6_101_749540(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim userId As String
    Dim rows() As String
    Dim fields() As String
    Dim rowIndex As Long
    Dim effectId As Long
    Dim rentSeconds As Long
    Dim effectCount As Long
    Dim expireTimestamp As Long
    Dim currentTimestamp As Long
    Dim remainingSeconds As Long
    Dim listedEffects As Long
    Dim payload As String

    On Error GoTo ListDone

    socketIndex = HandlingSocketIndex(args)
    userId = HandlingUserIdFromSocket(socketIndex)
    If Len(userId) = 0 Or userId = "0" Then GoTo ListDone

    rows = Split(CStr(Proc_5_2_6D4690("SELECT id_effect,time_rent,COUNT(id_effect),timestamp_expire,UNIX_TIMESTAMP() FROM users_effects WHERE id_user='" & _
        Proc_10_11_80A9C0(userId, 0, 0) & "' GROUP BY users_effects.id_effect LIMIT 50", 0, 0)), Chr$(13))

    For rowIndex = LBound(rows) To UBound(rows)
        If Len(rows(rowIndex)) > 0 Then
            fields = Split(rows(rowIndex), Chr$(9))
            If UBound(fields) >= 4 Then
                effectId = CLng(Val(HandlingField(fields, 0)))
                rentSeconds = CLng(Val(HandlingField(fields, 1)))
                effectCount = CLng(Val(HandlingField(fields, 2)))
                expireTimestamp = CLng(Val(HandlingField(fields, 3)))
                currentTimestamp = CLng(Val(HandlingField(fields, 4)))

                If effectId > 0 Then
                    payload = payload & CStr(Proc_3_0_6D2AF0(effectId, Empty, vbNullString))
                    payload = payload & CStr(Proc_3_0_6D2AF0(rentSeconds, Empty, vbNullString))
                    payload = payload & CStr(Proc_3_0_6D2AF0(effectCount, Empty, vbNullString))

                    remainingSeconds = expireTimestamp - currentTimestamp
                    If expireTimestamp > 0 And remainingSeconds > 0 Then
                        payload = payload & CStr(Proc_3_0_6D2AF0(remainingSeconds, Empty, vbNullString))
                    Else
                        payload = payload & "M"
                    End If

                    listedEffects = listedEffects + 1
                End If
            End If
        End If
    Next rowIndex

    Proc_6_244_801E80 socketIndex, CStr(Proc_3_0_6D2AF0(listedEffects, Empty, "GL")) & payload, 0

ListDone:
    Proc_6_101_749540 = listedEffects
End Function

' Original declaration: Private Sub Proc_6_102_749C50
Public Function Proc_6_102_749C50(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim requestPayload As String
    Dim userId As String
    Dim effectId As Long
    Dim effectRow As String
    Dim fields() As String
    Dim effectRowId As Long
    Dim rentSeconds As Long
    Dim existingExpireTimestamp As Long
    Dim broadcastPayload As String
    Dim offset As Long

    On Error GoTo ActivateDone

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    If Len(packetPayload) = 0 And UBound(args) >= 1 Then packetPayload = CStr(args(1))

    requestPayload = packetPayload
    If Len(requestPayload) >= 3 Then requestPayload = CStr(Proc_10_5_809D80(requestPayload, 3, 0))
    effectId = CLng(Val(CStr(Proc_10_6_809F10(requestPayload, 0, 0))))
    If effectId <= 0 Then
        offset = 1
        effectId = ReadWireLong(requestPayload, offset)
    End If
    If effectId <= 0 Then GoTo ActivateDone

    userId = HandlingUserIdFromSocket(socketIndex)
    If Len(userId) = 0 Or userId = "0" Then GoTo ActivateDone

    effectRow = CStr(Proc_5_2_6D4690("SELECT id,time_rent,timestamp_expire FROM users_effects WHERE id_user='" & _
        Proc_10_11_80A9C0(userId, 0, 0) & "' AND id_effect='" & CStr(effectId) & "' ORDER BY timestamp_expire DESC LIMIT 1", 0, 0))
    If Len(effectRow) = 0 Then GoTo ActivateDone

    fields = Split(effectRow, Chr$(9))
    If UBound(fields) < 1 Then GoTo ActivateDone

    effectRowId = CLng(Val(HandlingField(fields, 0)))
    rentSeconds = CLng(Val(HandlingField(fields, 1)))
    If UBound(fields) >= 2 Then existingExpireTimestamp = CLng(Val(HandlingField(fields, 2)))
    If effectRowId <= 0 Or rentSeconds <= 0 Then GoTo ActivateDone

    Proc_5_0_6D3CD0 "UPDATE users_effects SET timestamp_expire=UNIX_TIMESTAMP()+time_rent WHERE id='" & CStr(effectRowId) & "' LIMIT 1", 0, 0

    Proc_6_244_801E80 socketIndex, CStr(Proc_3_0_6D2AF0(rentSeconds, Empty, CStr(Proc_3_0_6D2AF0(effectId, Empty, "GN")))), 0

    broadcastPayload = CStr(Proc_3_0_6D2AF0(socketIndex, Empty, "Ge"))
    broadcastPayload = CStr(Proc_3_0_6D2AF0(effectId, Empty, broadcastPayload)) & "H"
    Proc_6_247_8027E0 socketIndex, broadcastPayload, 0

    Proc_6_102_749C50 = effectId
    Exit Function

ActivateDone:
    Proc_6_102_749C50 = Empty
End Function

' Original declaration: Private Sub Proc_6_103_74A510
Public Function Proc_6_103_74A510(ParamArray args() As Variant) As Variant
    Dim queryText As String
    Dim rows() As String
    Dim fields() As String
    Dim rowIndex As Long
    Dim effectId As Long
    Dim socketIndex As Integer
    Dim effectRowId As Long
    Dim expiredCount As Long
    Dim broadcastPayload As String

    On Error GoTo ExpireDone

    queryText = "SELECT users_effects.id_effect,users.id_socket,users_effects.id FROM users_effects,users WHERE users_effects.timestamp_expire IS NOT NULL AND users_effects.timestamp_expire<UNIX_TIMESTAMP() AND users.id=users_effects.id_user AND users.id_socket IS NOT NULL LIMIT 500"
    rows = Split(CStr(Proc_5_2_6D4690(queryText, 1, 0)), Chr$(13))

    For rowIndex = LBound(rows) To UBound(rows)
        If Len(rows(rowIndex)) > 0 Then
            fields = Split(rows(rowIndex), Chr$(9))
            If UBound(fields) >= 2 Then
                effectId = CLng(Val(fields(0)))
                socketIndex = CInt(Val(fields(1)))
                effectRowId = CLng(Val(fields(2)))

                If socketIndex > 0 And effectId > 0 Then
                    broadcastPayload = CStr(Proc_3_0_6D2AF0(socketIndex, Empty, "Ge")) & "H"
                    Proc_6_247_8027E0 socketIndex, broadcastPayload, 0
                    Proc_6_244_801E80 socketIndex, CStr(Proc_3_0_6D2AF0(effectId, Empty, "GO")), 0
                    expiredCount = expiredCount + 1
                End If
            End If
        End If
    Next rowIndex

    Proc_5_0_6D3CD0 "DELETE FROM users_effects WHERE users_effects.timestamp_expire IS NOT NULL AND users_effects.timestamp_expire<UNIX_TIMESTAMP() LIMIT 500", 0, 0

ExpireDone:
    Proc_6_103_74A510 = expiredCount
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
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim requestPayload As String
    Dim userId As String
    Dim roomName As String
    Dim modelName As String
    Dim maxOwnedRooms As Long
    Dim ownedRoomCount As Long
    Dim modelRow As String
    Dim modelFields() As String
    Dim modelId As Long
    Dim visitorsMax As Long
    Dim roomId As Long
    Dim offset As Long

    On Error GoTo CreateFailed

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 2 Then
        packetPayload = CStr(args(2))
    ElseIf UBound(args) >= 1 Then
        packetPayload = CStr(args(1))
    End If

    requestPayload = packetPayload
    If Left$(requestPayload, 2) = "@]" Then requestPayload = Mid$(requestPayload, 3)

    userId = HandlingUserIdFromSocket(socketIndex)
    If Len(userId) = 0 Or userId = "0" Then GoTo CreateFailed

    maxOwnedRooms = CLng(Val(CStr(Proc_10_0_809570("com.server.socket.game.rooms.own.max", 0, 0))))
    ownedRoomCount = CLng(Val(CStr(Proc_5_2_6D4690("SELECT COUNT(id) FROM rooms WHERE id_owner='" & Proc_10_11_80A9C0(userId, 0, 0) & "'", 0, 0))))
    If maxOwnedRooms > 0 And ownedRoomCount >= maxOwnedRooms Then GoTo CreateFailed

    offset = 1
    roomName = CStr(Proc_10_10_80A7F0(ReadWireString(requestPayload, offset), 0, 0))
    If Len(roomName) = 0 Then roomName = CStr(Proc_10_10_80A7F0(Proc_10_7_80A190(requestPayload, 0, 0), 0, 0))
    roomName = Left$(roomName, 25)
    If Len(roomName) = 0 Then GoTo CreateFailed

    modelName = CStr(Proc_10_11_80A9C0(ReadWireString(requestPayload, offset), 0, 0))
    If Len(modelName) = 0 Then modelName = CStr(Proc_10_11_80A9C0(Proc_10_7_80A190(requestPayload, 0, 0), 0, 0))
    modelName = Left$(modelName, 10)
    If Len(modelName) = 0 Then GoTo CreateFailed

    modelRow = CStr(Proc_5_2_6D4690("SELECT id,visitors_max FROM models WHERE create_min_level_hc <= '" & CStr(HandlingUserHcLevel(userId)) & "' AND type='0' AND name='" & modelName & "' LIMIT 1", 0, 0))
    If Len(modelRow) = 0 Then GoTo CreateFailed

    modelFields = Split(modelRow, Chr$(9))
    modelId = CLng(Val(HandlingField(modelFields, 0)))
    visitorsMax = CLng(Val(HandlingField(modelFields, 1)))
    If modelId <= 0 Then GoTo CreateFailed
    If visitorsMax <= 0 Then visitorsMax = 25

    Proc_5_0_6D3CD0 "INSERT INTO rooms(id_owner,name,visitors_max,id_model,timestamp_created) VALUES('" & Proc_10_11_80A9C0(userId, 0, 0) & "','" & Proc_10_11_80A9C0(roomName, 0, 0) & "','" & CStr(visitorsMax) & "','" & CStr(modelId) & "',UNIX_TIMESTAMP())", 0, 0
    roomId = CLng(Val(CStr(Proc_5_2_6D4690("SELECT MAX(id) FROM rooms", 0, 0))))
    If roomId <= 0 Then GoTo CreateFailed

    Proc_6_106_74B750 App.Path & "\CACHE\ROOMS\" & CStr(roomId) & ".cache", 0, 0
    Proc_6_106_74B750 App.Path & "\CACHE\PATHFINDER\" & CStr(roomId) & ".cache", 0, 0
    Proc_6_244_801E80 socketIndex, CStr(Proc_3_0_6D2AF0(roomId, Empty, "@{")) & roomName & Chr$(2), 0

CreateFailed:
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
    Dim socketIndex As Integer
    Dim userId As String
    Dim roomId As Long
    Dim ownerUserId As String
    Dim currentPicked As Long
    Dim newPicked As Long
    Dim categoryId As Long
    Dim styleId As Long
    Dim iconId As Long
    Dim queryTail As String

    On Error GoTo StaffPickFailed

    socketIndex = HandlingSocketIndex(args)
    userId = HandlingUserIdFromSocket(socketIndex)
    If Len(userId) = 0 Or userId = "0" Then GoTo StaffPickFailed
    If Not HandlingUserHasPermission(userId, "fuse_client_staff") Then GoTo StaffPickFailed

    roomId = HandlingCurrentRoomId(socketIndex, userId)
    If roomId <= 0 Then GoTo StaffPickFailed

    ownerUserId = CStr(Proc_5_2_6D4690("SELECT id_owner FROM rooms WHERE id='" & CStr(roomId) & "' LIMIT 1", 0, 0))
    If Len(ownerUserId) = 0 Then GoTo StaffPickFailed

    currentPicked = CLng(Val(CStr(Proc_5_2_6D4690("SELECT is_staff_picked FROM rooms WHERE id='" & CStr(roomId) & "' LIMIT 1", 0, 0))))
    If currentPicked = 0 Then
        newPicked = 1
    Else
        newPicked = 0
    End If

    categoryId = CLng(Val(CStr(Proc_10_0_809570("com.client.navigator.staff_picked.category.id.default", 0, 0))))
    If categoryId <= 0 Then categoryId = 1

    If newPicked = 0 Then
        Proc_5_0_6D3CD0 "DELETE FROM rooms_official WHERE id_parent='" & CStr(categoryId) & "' AND id_room='" & CStr(roomId) & "' LIMIT 1", 0, 0
    Else
        styleId = CLng(Val(CStr(Proc_10_0_809570("com.client.navigator.staff_picked.style.default", 0, 0))))
        iconId = CLng(Val(CStr(Proc_10_0_809570("com.client.navigator.staff_picked.category.icon.default", 0, 0))))
        Proc_5_0_6D3CD0 "DELETE FROM rooms_official WHERE id_parent='" & CStr(categoryId) & "' AND id_room='" & CStr(roomId) & "' LIMIT 1", 0, 0
        Proc_5_0_6D3CD0 "INSERT INTO rooms_official(id_parent,id_room,id_style,id_type,icon) VALUES('" & CStr(categoryId) & "','" & CStr(roomId) & "','" & CStr(styleId) & "','2','" & CStr(iconId) & "')", 0, 0
        Proc_5_0_6D3CD0 "UPDATE users SET amount_staffpicked=amount_staffpicked+1 WHERE id='" & Proc_10_11_80A9C0(ownerUserId, 0, 0) & "'", 0, 0
    End If

    Proc_5_0_6D3CD0 "UPDATE rooms SET is_staff_picked='" & CStr(newPicked) & "' WHERE id='" & CStr(roomId) & "'", 0, 0
    queryTail = "users,rooms,rooms_categories WHERE rooms.id='" & CStr(roomId) & "' AND users.id=rooms.id_owner AND rooms_categories.id=rooms.id_category LIMIT 1"
    Proc_6_247_8027E0 socketIndex, CStr(Proc_6_112_74E0C0(queryTail, "GF", 0)), 0
    Proc_6_247_8027E0 socketIndex, CStr(Proc_3_0_6D2AF0(roomId, Empty, "GH")), 0

StaffPickFailed:
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
    Dim rowText As String
    Dim includeCountPrefix As Boolean
    Dim rows() As String
    Dim fields() As String
    Dim rowIndex As Long
    Dim fieldIndex As Long
    Dim itemCount As Long
    Dim rowPayload As String
    Dim payload As String

    On Error GoTo BuildFailed
    If UBound(args) < 0 Then GoTo BuildFailed

    rowText = CStr(args(0))
    If UBound(args) >= 1 Then includeCountPrefix = CBool(args(1))
    If Len(rowText) = 0 Then GoTo BuildDone

    rows = Split(rowText, Chr$(13))
    For rowIndex = LBound(rows) To UBound(rows)
        If Len(rows(rowIndex)) > 0 Then
            fields = Split(rows(rowIndex), Chr$(9))
            If UBound(fields) >= 26 Then
                rowPayload = CStr(Proc_3_0_6D2AF0(CLng(Val(NavigatorField(fields, 0))), Empty, vbNullString))
                rowPayload = rowPayload & CStr(Proc_3_0_6D2AF0(CLng(Val(NavigatorField(fields, 1))), Empty, vbNullString))
                rowPayload = rowPayload & CStr(Proc_3_0_6D2AF0(CLng(Val(NavigatorField(fields, 2))), Empty, vbNullString))
                For fieldIndex = 3 To 24
                    rowPayload = rowPayload & NavigatorField(fields, fieldIndex) & Chr$(2)
                Next fieldIndex
                rowPayload = rowPayload & CStr(Proc_3_0_6D2AF0(CLng(Val(NavigatorField(fields, 25))), Empty, vbNullString))
                rowPayload = rowPayload & CStr(Proc_3_0_6D2AF0(CLng(Val(NavigatorField(fields, 26))), Empty, vbNullString))
                If UBound(fields) >= 27 Then
                    rowPayload = rowPayload & CStr(Proc_3_0_6D2AF0(CLng(Val(NavigatorField(fields, 27))), Empty, vbNullString))
                End If

                payload = payload & rowPayload
                itemCount = itemCount + 1
            End If
        End If
    Next rowIndex

BuildDone:
    If includeCountPrefix Then payload = CStr(Proc_3_0_6D2AF0(itemCount, Empty, vbNullString)) & payload
    Proc_6_122_752280 = payload
    Exit Function

BuildFailed:
    If includeCountPrefix Then
        Proc_6_122_752280 = CStr(Proc_3_0_6D2AF0(0, Empty, vbNullString))
    Else
        Proc_6_122_752280 = vbNullString
    End If
End Function

' Original declaration: Private Sub Proc_6_123_754020
Public Function Proc_6_123_754020(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim queryText As String
    Dim rowText As String
    Dim payload As String

    On Error GoTo NavigatorFailed

    socketIndex = HandlingSocketIndex(args)
    queryText = OfficialNavigatorQuery()
    rowText = CStr(Proc_5_2_6D4690(queryText, 0, 0))
    payload = OfficialNavigatorPayload(rowText)
    Proc_6_244_801E80 socketIndex, "GB" & payload, 0

NavigatorFailed:
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
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim requestPayload As String
    Dim offset As Long
    Dim catalogProductId As Long
    Dim signText As String
    Dim userId As String
    Dim catalogRow As String
    Dim catalogFields() As String
    Dim productId As Long
    Dim typeSecondary As String
    Dim creditPrice As Long
    Dim activityPrice As Long
    Dim activityType As Long
    Dim minClubLevel As Long
    Dim userRow As String
    Dim userFields() As String
    Dim userCredits As Long
    Dim userActivityPoints As Long
    Dim userClubLevel As Long
    Dim grantedFurnitureId As Long
    Dim itemClass As String
    Dim purchasePayload As String

    On Error GoTo PurchaseFailed

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    If Len(packetPayload) = 0 And UBound(args) >= 1 Then packetPayload = CStr(args(1))

    requestPayload = packetPayload
    If Left$(requestPayload, 2) = "Ad" Then requestPayload = Mid$(requestPayload, 3)

    offset = 1
    catalogProductId = ReadWireLong(requestPayload, offset)
    signText = CStr(Proc_10_10_80A7F0(ReadWireString(requestPayload, offset), 1, 1))

    If catalogProductId <= 0 Then catalogProductId = CLng(Val(CStr(Proc_10_6_809F10(requestPayload, 0, 0))))
    If Len(signText) = 0 Then signText = CStr(Proc_10_10_80A7F0(Proc_10_7_80A190(requestPayload, 0, 0), 1, 1))
    If catalogProductId <= 0 Then GoTo PurchaseFailed

    userId = HandlingUserIdFromSocket(socketIndex)
    If socketIndex <= 0 Or Len(userId) = 0 Or userId = "0" Then GoTo PurchaseFailed

    catalogRow = CStr(Proc_9_4_807B90(catalogProductId, 0, 0))
    If Len(catalogRow) = 0 Then GoTo PurchaseFailed
    catalogFields = Split(catalogRow, Chr$(9))
    productId = CLng(Val(HandlingField(catalogFields, 2)))
    typeSecondary = LCase$(HandlingField(catalogFields, 4))
    creditPrice = CLng(Val(HandlingField(catalogFields, 7)))
    activityPrice = CLng(Val(HandlingField(catalogFields, 8)))
    activityType = CLng(Val(HandlingField(catalogFields, 9)))
    minClubLevel = CLng(Val(HandlingField(catalogFields, 11)))
    If productId <= 0 Then GoTo PurchaseFailed
    If activityType < 0 Or activityType > 4 Then activityType = 0

    userRow = CStr(Proc_5_2_6D4690("SELECT credits,activitypoints_" & CStr(activityType) & ",level_hc FROM users WHERE id='" & _
        Proc_10_11_80A9C0(userId, 0, 0) & "' LIMIT 1", 0, 0))
    If Len(userRow) = 0 Then GoTo PurchaseFailed
    userFields = Split(userRow, Chr$(9))
    userCredits = CLng(Val(HandlingField(userFields, 0)))
    userActivityPoints = CLng(Val(HandlingField(userFields, 1)))
    userClubLevel = CLng(Val(HandlingField(userFields, 2)))

    If minClubLevel > 0 And userClubLevel < minClubLevel Then
        Proc_6_244_801E80 socketIndex, "AD" & CStr(Proc_3_0_6D2AF0(3, Empty, vbNullString)), 0
        GoTo PurchaseFailed
    End If
    If userCredits < creditPrice Then
        Proc_6_244_801E80 socketIndex, "AD" & CStr(Proc_3_0_6D2AF0(1, Empty, vbNullString)), 0
        GoTo PurchaseFailed
    End If
    If userActivityPoints < activityPrice Then
        Proc_6_244_801E80 socketIndex, "AD" & CStr(Proc_3_0_6D2AF0(2, Empty, vbNullString)), 0
        GoTo PurchaseFailed
    End If

    grantedFurnitureId = CLng(Val(CStr(Proc_6_129_7583C0(socketIndex, catalogProductId, signText))))
    If grantedFurnitureId <= 0 Then GoTo PurchaseFailed

    If creditPrice > 0 Or activityPrice > 0 Then
        Proc_5_0_6D3CD0 "UPDATE users SET credits=credits-" & CStr(creditPrice) & ",activitypoints_" & CStr(activityType) & _
            "=activitypoints_" & CStr(activityType) & "-" & CStr(activityPrice) & " WHERE id='" & Proc_10_11_80A9C0(userId, 0, 0) & "'", 0, 0
        If creditPrice > 0 Then Proc_10_16_80C480 userId, 0, 0
        If activityPrice > 0 Then Proc_10_17_80C6B0 userId, activityType, 0
    End If

    itemClass = "i"
    If typeSecondary <> "products_deals" Then
        If CLng(Val(CStr(Proc_8_12_806C30(productId, 0, 0)))) = 8 Then itemClass = "I"
    End If
    purchasePayload = CStr(Proc_3_0_6D2AF0(catalogProductId, Empty, "AC"))
    purchasePayload = CStr(Proc_3_0_6D2AF0(creditPrice, Empty, purchasePayload))
    purchasePayload = CStr(Proc_3_0_6D2AF0(activityPrice, Empty, purchasePayload))
    purchasePayload = CStr(Proc_3_0_6D2AF0(activityType, Empty, purchasePayload))
    purchasePayload = CStr(Proc_3_0_6D2AF0(grantedFurnitureId, Empty, purchasePayload)) & Chr$(2) & itemClass & Chr$(2) & "IHH"
    Proc_6_244_801E80 socketIndex, purchasePayload, 0
    Proc_6_140_769400 socketIndex, "FT", vbNullString

PurchaseFailed:
    Proc_6_128_756190 = Empty
End Function

' Original declaration: Private  Proc_6_129_7583C0(arg_C, arg_10) '7583C0
Public Function Proc_6_129_7583C0(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim catalogProductId As Long
    Dim signText As String
    Dim catalogRow As String
    Dim catalogFields() As String
    Dim typeSecondary As String
    Dim productId As Long
    Dim grantResult As String
    Dim grantedIds() As String
    Dim dealRow As String
    Dim dealFields() As String
    Dim dealItems() As String
    Dim productIds() As Long
    Dim itemCount As Long
    Dim itemIndex As Long
    Dim furnitureId As Long
    Dim itemData As String
    Dim secondaryValue As Long
    Dim addPayload As String
    Dim firstFurnitureId As Long
    Dim trophySign As String
    Dim dateFormat As String
    Dim productType As Long

    On Error GoTo PurchaseGrantFailed

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 1 Then catalogProductId = CLng(Val(CStr(args(1))))
    If UBound(args) >= 2 Then signText = CStr(args(2))
    If socketIndex <= 0 Or catalogProductId <= 0 Then GoTo PurchaseGrantFailed

    catalogRow = CStr(Proc_9_4_807B90(catalogProductId, 0, 0))
    If Len(catalogRow) = 0 Then GoTo PurchaseGrantFailed
    catalogFields = Split(catalogRow, Chr$(9))
    productId = CLng(Val(HandlingField(catalogFields, 2)))
    typeSecondary = LCase$(HandlingField(catalogFields, 4))
    If productId <= 0 Then GoTo PurchaseGrantFailed

    grantResult = CStr(Proc_6_133_760400(socketIndex, catalogProductId, signText))
    If Len(grantResult) = 0 Then GoTo PurchaseGrantFailed
    grantedIds = Split(grantResult, global_004092F0)

    If typeSecondary = "products_deals" Then
        dealRow = CStr(Proc_9_5_807DF0(productId, 0, 0))
        dealFields = Split(dealRow, Chr$(9))
        If UBound(dealFields) >= 1 Then dealRow = CStr(dealFields(1))
        dealItems = Split(Replace(dealRow, ",", ";", 1, -1, vbBinaryCompare), ";")
        ReDim productIds(0 To UBound(dealItems))
        For itemIndex = LBound(dealItems) To UBound(dealItems)
            If CLng(Val(CStr(dealItems(itemIndex)))) > 0 Then
                productIds(itemCount) = CLng(Val(CStr(dealItems(itemIndex))))
                itemCount = itemCount + 1
            End If
        Next itemIndex
    Else
        itemCount = UBound(grantedIds) - LBound(grantedIds) + 1
        If itemCount < 1 Then itemCount = 1
        ReDim productIds(0 To itemCount - 1)
        For itemIndex = 0 To itemCount - 1
            productIds(itemIndex) = productId
        Next itemIndex
    End If

    If itemCount > 0 Then
        For itemIndex = 0 To itemCount - 1
            If itemIndex <= UBound(grantedIds) Then furnitureId = CLng(Val(CStr(grantedIds(itemIndex)))) Else furnitureId = 0
            If furnitureId > 0 And productIds(itemIndex) > 0 Then
                If firstFurnitureId = 0 Then firstFurnitureId = furnitureId
                itemData = CStr(Proc_8_12_806C30(productIds(itemIndex), 24, 0))
                If Len(itemData) = 0 Then itemData = CStr(Proc_8_12_806C30(productIds(itemIndex), 4, 0))
                productType = CLng(Val(CStr(Proc_8_12_806C30(productIds(itemIndex), 0, 0))))
                secondaryValue = 0

                addPayload = "Ab" & CStr(Proc_6_138_7678A0(furnitureId, productIds(itemIndex), itemData, secondaryValue))
                Proc_6_244_801E80 socketIndex, addPayload & Chr$(2), 0

                If StrComp(CStr(Proc_8_12_806C30(productIds(itemIndex), 4, 0)), "TROPHY_VAR", vbTextCompare) = 0 Then
                    dateFormat = CStr(Proc_10_0_809570("com.client.format.date", "dd.mm.yyyy", 0))
                    trophySign = HandlingUserName(HandlingUserIdFromSocket(socketIndex)) & Chr$(8) & Format$(Now, dateFormat) & Chr$(8) & signText
                    Proc_5_0_6D3CD0 "UPDATE furnitures SET sign='" & Proc_10_11_80A9C0(Proc_10_10_80A7F0(trophySign, 1, 1), 0, 0) & _
                        "' WHERE id='" & CStr(furnitureId) & "'", 0, 0
                End If

                If productType = 8 Then
                    Proc_6_244_801E80 socketIndex, "GM" & CStr(Proc_3_0_6D2AF0(furnitureId, Empty, vbNullString)) & _
                        CStr(Proc_3_0_6D2AF0(CLng(Val(CStr(Proc_8_12_806C30(productIds(itemIndex), 20, 0)))), Empty, vbNullString)), 0
                End If
            End If
        Next itemIndex
    End If

    Proc_6_129_7583C0 = firstFurnitureId
    Exit Function

PurchaseGrantFailed:
    Proc_6_129_7583C0 = Empty
End Function

' Original declaration: Private Sub Proc_6_130_75B770
Public Function Proc_6_130_75B770(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim requestPayload As String
    Dim requestedSprite As String
    Dim userId As String
    Dim rowText As String
    Dim userFields() As String
    Dim hcLevel As Long
    Dim hcDays As Long
    Dim vipDays As Long
    Dim presentsAvailable As Long
    Dim daysSinceStart As Long
    Dim activeDays As Long
    Dim catalogProductId As Long
    Dim productId As Long
    Dim requiredDays As Long
    Dim giftRows() As String
    Dim giftParts() As String
    Dim giftIndex As Long
    Dim insertedFurnitureId As Long
    Dim itemData As String
    Dim itemClass As String
    Dim responsePayload As String

    On Error GoTo ClaimFailed

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    If Len(packetPayload) = 0 And UBound(args) >= 1 Then packetPayload = CStr(args(1))
    requestPayload = packetPayload
    If Left$(requestPayload, 2) = "G[" Then requestPayload = Mid$(requestPayload, 3)

    requestedSprite = CStr(Proc_10_7_80A190(requestPayload, 0, 0))
    If Len(requestedSprite) = 0 Then requestedSprite = CStr(Proc_10_6_809F10(requestPayload, 0, 0))
    If Len(requestedSprite) = 0 Then requestedSprite = Trim$(Replace(Replace(requestPayload, Chr$(2), vbNullString, 1, -1, vbBinaryCompare), Chr$(0), vbNullString, 1, -1, vbBinaryCompare))
    If Len(requestedSprite) = 0 Then GoTo ClaimFailed

    userId = HandlingUserIdFromSocket(socketIndex)
    If socketIndex <= 0 Or Len(userId) = 0 Or userId = "0" Then GoTo ClaimFailed

    If Len(global_00829178) = 0 Or Len(global_0082917C) = 0 Then Proc_1_18_6CE9C0 0, 0, 0

    catalogProductId = CLng(Val(CStr(Proc_5_2_6D4690("SELECT id FROM catalog_products WHERE sprite='" & _
        Proc_10_11_80A9C0(requestedSprite, 0, 0) & "' LIMIT 1", 0, 0))))
    If catalogProductId <= 0 Then GoTo ClaimFailed

    giftRows = Split(Replace(global_0082917C, "[", vbNullString, 1, -1, vbBinaryCompare), "]")
    For giftIndex = LBound(giftRows) To UBound(giftRows)
        If Len(giftRows(giftIndex)) > 0 Then
            giftParts = Split(Replace(CStr(giftRows(giftIndex)), Chr$(1), Chr$(0), 1, -1, vbBinaryCompare), Chr$(0))
            If UBound(giftParts) >= 2 Then
                If CLng(Val(CStr(giftParts(0)))) = catalogProductId Then
                    productId = CLng(Val(CStr(giftParts(1))))
                    requiredDays = CLng(Val(CStr(giftParts(2))))
                    Exit For
                End If
            End If
        End If
    Next giftIndex
    If productId <= 0 Then GoTo ClaimFailed

    rowText = CStr(Proc_5_2_6D4690("SELECT level_hc,hc_days,hc2_days,hc_presents,ROUND((UNIX_TIMESTAMP()-hc_startperiod)/60/60/24,0) FROM users WHERE id='" & _
        Proc_10_11_80A9C0(userId, 0, 0) & "' LIMIT 1", 0, 0))
    If Len(rowText) = 0 Then GoTo ClaimFailed

    userFields = Split(rowText, Chr$(9))
    hcLevel = CLng(Val(HandlingField(userFields, 0)))
    hcDays = CLng(Val(HandlingField(userFields, 1)))
    vipDays = CLng(Val(HandlingField(userFields, 2)))
    presentsAvailable = CLng(Val(HandlingField(userFields, 3)))
    daysSinceStart = CLng(Val(HandlingField(userFields, 4)))
    If hcLevel > 1 Then
        activeDays = vipDays
    Else
        activeDays = hcDays
    End If
    activeDays = activeDays - daysSinceStart
    If activeDays < 0 Then activeDays = 0
    If presentsAvailable <= 0 Or activeDays < requiredDays Then GoTo ClaimFailed

    itemData = CStr(Proc_8_12_806C30(productId, 24, 0))
    Proc_5_0_6D3CD0 "INSERT INTO furnitures(id_product,id_ctlgproduct,id_owner,task_owner,task_time,position_r,sign) VALUES('" & _
        CStr(productId) & "','" & CStr(catalogProductId) & "','" & Proc_10_11_80A9C0(userId, 0, 0) & "','" & _
        Proc_10_11_80A9C0(userId, 0, 0) & "',UNIX_TIMESTAMP(),'0','" & Proc_10_11_80A9C0(itemData, 0, 0) & "')", 0, 0
    insertedFurnitureId = CLng(Val(CStr(Proc_5_2_6D4690("SELECT id FROM furnitures WHERE id_owner='" & Proc_10_11_80A9C0(userId, 0, 0) & _
        "' AND id_product='" & CStr(productId) & "' ORDER BY id DESC LIMIT 1", 0, 0))))

    itemClass = "i"
    If CLng(Val(CStr(Proc_8_12_806C30(productId, 0, 0)))) = 9 Then itemClass = "I"
    responsePayload = CStr(Proc_3_0_6D2AF0(productId, Empty, "AC"))
    responsePayload = responsePayload & CStr(Proc_8_12_806C30(productId, 24, 0)) & Chr$(2)
    responsePayload = responsePayload & "HHHI" & itemClass & Chr$(2)
    responsePayload = CStr(Proc_3_0_6D2AF0(insertedFurnitureId, Empty, responsePayload)) & Chr$(2) & "IH"
    Proc_6_244_801E80 socketIndex, responsePayload, 0

    Proc_5_0_6D3CD0 "UPDATE users SET hc_presents=hc_presents-1 WHERE id='" & Proc_10_11_80A9C0(userId, 0, 0) & "'", 0, 0
    Proc_6_140_769400 socketIndex, "FT", vbNullString

ClaimFailed:
    Proc_6_130_75B770 = Empty
End Function

' Original declaration: Private Sub Proc_6_131_75C700
Public Function Proc_6_131_75C700(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim userId As String
    Dim rowText As String
    Dim userFields() As String
    Dim hcLevel As Long
    Dim hcDays As Long
    Dim vipDays As Long
    Dim presentsAvailable As Long
    Dim daysSinceStart As Long
    Dim activeDays As Long
    Dim giftRows() As String
    Dim giftParts() As String
    Dim giftIndex As Long
    Dim catalogProductId As Long
    Dim productId As Long
    Dim requiredDays As Long
    Dim canClaim As Long
    Dim statusCount As Long
    Dim statusPayload As String
    Dim payload As String

    On Error GoTo GiftListFailed

    socketIndex = HandlingSocketIndex(args)
    userId = HandlingUserIdFromSocket(socketIndex)
    If socketIndex <= 0 Or Len(userId) = 0 Or userId = "0" Then GoTo GiftListFailed

    If Len(global_00829178) = 0 Or Len(global_0082917C) = 0 Then Proc_1_18_6CE9C0 0, 0, 0

    rowText = CStr(Proc_5_2_6D4690("SELECT level_hc,hc_days,hc2_days,hc_presents,ROUND((UNIX_TIMESTAMP()-hc_startperiod)/60/60/24,0) FROM users WHERE id='" & _
        Proc_10_11_80A9C0(userId, 0, 0) & "' LIMIT 1", 0, 0))
    If Len(rowText) > 0 Then
        userFields = Split(rowText, Chr$(9))
        hcLevel = CLng(Val(HandlingField(userFields, 0)))
        hcDays = CLng(Val(HandlingField(userFields, 1)))
        vipDays = CLng(Val(HandlingField(userFields, 2)))
        presentsAvailable = CLng(Val(HandlingField(userFields, 3)))
        daysSinceStart = CLng(Val(HandlingField(userFields, 4)))
    End If

    If hcLevel > 1 Then
        activeDays = vipDays
    Else
        activeDays = hcDays
    End If
    activeDays = activeDays - daysSinceStart
    If activeDays < 0 Then activeDays = 0

    giftRows = Split(Replace(global_0082917C, "[", vbNullString, 1, -1, vbBinaryCompare), "]")
    For giftIndex = LBound(giftRows) To UBound(giftRows)
        If Len(giftRows(giftIndex)) > 0 Then
            giftParts = Split(Replace(CStr(giftRows(giftIndex)), Chr$(1), Chr$(0), 1, -1, vbBinaryCompare), Chr$(0))
            If UBound(giftParts) >= 2 Then
                catalogProductId = CLng(Val(CStr(giftParts(0))))
                productId = CLng(Val(CStr(giftParts(1))))
                requiredDays = CLng(Val(CStr(giftParts(2))))
                canClaim = 0
                If presentsAvailable > 0 And activeDays >= requiredDays Then canClaim = 1

                statusPayload = statusPayload & CStr(Proc_3_0_6D2AF0(catalogProductId, Empty, vbNullString))
                statusPayload = statusPayload & CStr(Proc_3_0_6D2AF0(productId, Empty, vbNullString))
                statusPayload = statusPayload & CStr(Proc_3_0_6D2AF0(requiredDays, Empty, vbNullString))
                statusPayload = statusPayload & CStr(Proc_3_0_6D2AF0(canClaim, Empty, vbNullString))
                statusPayload = statusPayload & "H"
                statusCount = statusCount + 1
            End If
        End If
    Next giftIndex

    payload = CStr(Proc_3_0_6D2AF0(presentsAvailable, Empty, "Io" & "M"))
    payload = payload & global_00829178
    payload = payload & CStr(Proc_3_0_6D2AF0(statusCount, Empty, vbNullString)) & statusPayload
    Proc_6_244_801E80 socketIndex, payload, 0

GiftListFailed:
    Proc_6_131_75C700 = Empty
End Function

' Original declaration: Private Sub Proc_6_132_75D4A0
Public Function Proc_6_132_75D4A0(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim requestPayload As String
    Dim offset As Long
    Dim catalogProductId As Long
    Dim expectedProductId As Long
    Dim recipientName As String
    Dim giftMessage As String
    Dim wrapProductId As Long
    Dim ribbonId As Long
    Dim colorId As Long
    Dim senderUserId As String
    Dim recipientUserId As String
    Dim catalogRow As String
    Dim catalogFields() As String
    Dim productId As Long
    Dim creditPrice As Long
    Dim activityPrice As Long
    Dim activityType As Long
    Dim allowGifts As Long
    Dim minClubLevel As Long
    Dim wrapPrice As Long
    Dim userRow As String
    Dim userFields() As String
    Dim userCredits As Long
    Dim userActivityPoints As Long
    Dim userClubLevel As Long
    Dim grantedFurnitureId As Long
    Dim productSign As String
    Dim dateFormat As String
    Dim senderName As String
    Dim giftSignExtra As String
    Dim giftSecondary As Long
    Dim recipientSocket As Long
    Dim itemPayload As String
    Dim productType As Long
    Dim purchasePayload As String

    On Error GoTo GiftPurchaseFailed

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    If Len(packetPayload) = 0 And UBound(args) >= 1 Then packetPayload = CStr(args(1))

    requestPayload = packetPayload
    If Left$(requestPayload, 2) = "GX" Then requestPayload = Mid$(requestPayload, 3)

    offset = 1
    catalogProductId = ReadWireLong(requestPayload, offset)
    expectedProductId = ReadWireLong(requestPayload, offset)
    recipientName = CStr(Proc_10_10_80A7F0(ReadWireString(requestPayload, offset), 1, 1))
    giftMessage = Left$(CStr(Proc_10_10_80A7F0(ReadWireString(requestPayload, offset), 1, 1)), 142)
    wrapProductId = ReadWireLong(requestPayload, offset)
    ribbonId = ReadWireLong(requestPayload, offset)
    colorId = ReadWireLong(requestPayload, offset)

    If catalogProductId <= 0 Then catalogProductId = CLng(Val(CStr(Proc_10_6_809F10(requestPayload, 0, 0))))
    If Len(recipientName) = 0 Then recipientName = CStr(Proc_10_10_80A7F0(Proc_10_7_80A190(requestPayload, 0, 0), 1, 1))
    If catalogProductId <= 0 Or Len(recipientName) = 0 Or Len(giftMessage) > 142 Then GoTo GiftPurchaseFailed

    senderUserId = HandlingUserIdFromSocket(socketIndex)
    If socketIndex <= 0 Or Len(senderUserId) = 0 Or senderUserId = "0" Then GoTo GiftPurchaseFailed

    catalogRow = CStr(Proc_9_4_807B90(catalogProductId, 0, 0))
    If Len(catalogRow) = 0 Then GoTo GiftPurchaseFailed
    catalogFields = Split(catalogRow, Chr$(9))
    productId = CLng(Val(HandlingField(catalogFields, 2)))
    creditPrice = CLng(Val(HandlingField(catalogFields, 7)))
    activityPrice = CLng(Val(HandlingField(catalogFields, 8)))
    activityType = CLng(Val(HandlingField(catalogFields, 9)))
    allowGifts = CLng(Val(HandlingField(catalogFields, 10)))
    minClubLevel = CLng(Val(HandlingField(catalogFields, 11)))
    If productId <= 0 Or allowGifts = 0 Then GoTo GiftPurchaseFailed
    If expectedProductId > 0 And expectedProductId <> productId Then GoTo GiftPurchaseFailed
    If activityType < 0 Or activityType > 4 Then activityType = 0

    If CLng(Val(CStr(Proc_10_0_809570("com.client.catalog.gifts.wrap.enabled", 0, 0)))) <> 0 Then
        wrapPrice = CLng(Val(CStr(Proc_10_0_809570("com.client.catalog.gifts.wrap.price", 0, 0))))
        If wrapProductId <= 0 Then wrapProductId = CLng(Val(CStr(Proc_5_2_6D4690("SELECT id FROM products WHERE sprite LIKE 'present_wrap%' ORDER BY id ASC LIMIT 1", 0, 0))))
        If wrapProductId > 0 Then
            If InStr(1, global_0082925C, Chr$(13) & CStr(wrapProductId) & Chr$(13), vbBinaryCompare) = 0 Then GoTo GiftPurchaseFailed
        End If
    End If

    creditPrice = creditPrice + wrapPrice
    userRow = CStr(Proc_5_2_6D4690("SELECT credits,activitypoints_" & CStr(activityType) & ",level_hc FROM users WHERE id='" & _
        Proc_10_11_80A9C0(senderUserId, 0, 0) & "' LIMIT 1", 0, 0))
    If Len(userRow) = 0 Then GoTo GiftPurchaseFailed
    userFields = Split(userRow, Chr$(9))
    userCredits = CLng(Val(HandlingField(userFields, 0)))
    userActivityPoints = CLng(Val(HandlingField(userFields, 1)))
    userClubLevel = CLng(Val(HandlingField(userFields, 2)))

    If minClubLevel > 0 And userClubLevel < minClubLevel Then
        Proc_6_244_801E80 socketIndex, "AD" & CStr(Proc_3_0_6D2AF0(3, Empty, vbNullString)), 0
        GoTo GiftPurchaseFailed
    End If
    If userCredits < creditPrice Then
        Proc_6_244_801E80 socketIndex, "AD" & CStr(Proc_3_0_6D2AF0(1, Empty, vbNullString)), 0
        GoTo GiftPurchaseFailed
    End If
    If userActivityPoints < activityPrice Then
        Proc_6_244_801E80 socketIndex, "AD" & CStr(Proc_3_0_6D2AF0(2, Empty, vbNullString)), 0
        GoTo GiftPurchaseFailed
    End If

    recipientUserId = CStr(Val(CStr(Proc_5_2_6D4690("SELECT id FROM users WHERE name='" & Proc_10_11_80A9C0(recipientName, 0, 0) & "' LIMIT 1", 0, 0))))
    If Len(recipientUserId) = 0 Or recipientUserId = "0" Then recipientUserId = senderUserId

    grantedFurnitureId = CLng(Val(CStr(Proc_6_133_760400(socketIndex, catalogProductId, giftMessage))))
    If grantedFurnitureId <= 0 Then GoTo GiftPurchaseFailed

    productSign = CStr(Proc_8_12_806C30(productId, 4, 0))
    If StrComp(productSign, "TROPHY_VAR", vbTextCompare) = 0 Then
        dateFormat = CStr(Proc_10_0_809570("com.client.format.date", "dd.mm.yyyy", 0))
        senderName = HandlingUserName(senderUserId)
        productSign = senderName & Chr$(8) & Format$(Now, dateFormat) & Chr$(8) & giftMessage
    End If

    giftSecondary = (colorId * 1000) + ribbonId
    giftSignExtra = giftMessage
    Proc_5_0_6D3CD0 "UPDATE furnitures SET sign_extra='" & Proc_10_11_80A9C0(Proc_10_10_80A7F0(giftSignExtra, 0, 0), 0, 0) & _
        "',sign='" & Proc_10_11_80A9C0(Proc_10_10_80A7F0(productSign, 0, 0), 0, 0) & "',id_owner='" & Proc_10_11_80A9C0(recipientUserId, 0, 0) & _
        "',id_destination='" & CStr(catalogProductId) & "',id_secondary='" & CStr(giftSecondary) & "' WHERE id='" & CStr(grantedFurnitureId) & "'", 0, 0

    If creditPrice > 0 Or activityPrice > 0 Then
        Proc_5_0_6D3CD0 "UPDATE users SET credits=credits-" & CStr(creditPrice) & ",activitypoints_" & CStr(activityType) & _
            "=activitypoints_" & CStr(activityType) & "-" & CStr(activityPrice) & " WHERE id='" & Proc_10_11_80A9C0(senderUserId, 0, 0) & "'", 0, 0
        If creditPrice > 0 Then Proc_10_16_80C480 senderUserId, 0, 0
        If activityPrice > 0 Then Proc_10_17_80C6B0 senderUserId, activityType, 0
    End If

    Proc_5_0_6D3CD0 "UPDATE users SET gifts_given=gifts_given+1 WHERE id='" & Proc_10_11_80A9C0(senderUserId, 0, 0) & "'", 0, 0
    If recipientUserId <> senderUserId Then
        Proc_5_0_6D3CD0 "UPDATE users SET gifts_received=gifts_received+1 WHERE id='" & Proc_10_11_80A9C0(recipientUserId, 0, 0) & "'", 0, 0
        Proc_6_205_7D9780 socketIndex, 6
    End If

    productType = CLng(Val(CStr(Proc_8_12_806C30(productId, 0, 0))))
    purchasePayload = CStr(Proc_3_0_6D2AF0(catalogProductId, Empty, "AC"))
    purchasePayload = purchasePayload & CStr(Proc_9_1_8072B0(catalogProductId, 0, 0)) & Chr$(2)
    purchasePayload = CStr(Proc_3_0_6D2AF0(creditPrice, Empty, purchasePayload))
    purchasePayload = CStr(Proc_3_0_6D2AF0(activityPrice, Empty, purchasePayload))
    purchasePayload = CStr(Proc_3_0_6D2AF0(activityType, Empty, purchasePayload))
    purchasePayload = CStr(Proc_3_0_6D2AF0(grantedFurnitureId, Empty, purchasePayload)) & Chr$(2) & "i" & Chr$(2) & "IH"
    Proc_6_244_801E80 socketIndex, purchasePayload, 0

    recipientSocket = CLng(Val(CStr(Proc_9_9_808AC0(recipientUserId, 0, 0))))
    If recipientSocket > 0 Then
        itemPayload = CStr(Proc_6_138_7678A0(grantedFurnitureId, productId, productSign, giftSecondary))
        Proc_6_244_801E80 CInt(recipientSocket), "Ab" & itemPayload & Chr$(2), 0
        Proc_6_205_7D9780 CInt(recipientSocket), 7
    End If

GiftPurchaseFailed:
    Proc_6_132_75D4A0 = Empty
End Function

' Original declaration: Private  Proc_6_133_760400(arg_C, arg_10, arg_14) '760400
Public Function Proc_6_133_760400(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim userId As String
    Dim catalogProductId As Long
    Dim catalogRow As String
    Dim catalogFields() As String
    Dim typeSecondary As String
    Dim productId As Long
    Dim amount As Long
    Dim signText As String
    Dim grantedIds As String
    Dim dealRow As String
    Dim dealFields() As String
    Dim dealItems() As String
    Dim itemIndex As Long
    Dim grantedCount As Long
    Dim defaultSign As String
    Dim containsClubRow As String
    Dim containsClubFields() As String
    Dim hcMonths As Long
    Dim hcLevel As Long
    Dim badgeId As String
    Dim existingBadge As String
    Dim badgeRowId As Long
    Dim firstGrantedId As Long
    Dim newestIds As String

    On Error GoTo GrantFailed

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 1 Then catalogProductId = CLng(Val(CStr(args(1))))
    If UBound(args) >= 2 Then signText = CStr(args(2))

    If socketIndex <= 0 Or catalogProductId <= 0 Then
        If UBound(args) >= 0 Then catalogProductId = CLng(Val(CStr(args(0))))
        If UBound(args) >= 1 Then signText = CStr(args(1))
        socketIndex = 0
    End If

    If socketIndex > 0 Then userId = HandlingUserIdFromSocket(socketIndex)
    If Len(userId) = 0 Or userId = "0" Then GoTo GrantFailed

    catalogRow = CStr(Proc_9_4_807B90(catalogProductId, 0, 0))
    If Len(catalogRow) = 0 Then GoTo GrantFailed

    catalogFields = Split(catalogRow, Chr$(9))
    productId = CLng(Val(HandlingField(catalogFields, 2)))
    typeSecondary = LCase$(HandlingField(catalogFields, 4))
    amount = CLng(Val(HandlingField(catalogFields, 5)))
    If amount <= 0 Then amount = 1

    If typeSecondary = "products_deals" Then
        dealRow = CStr(Proc_9_5_807DF0(productId, 0, 0))
        If Len(dealRow) = 0 Then GoTo GrantFailed
        dealFields = Split(dealRow, Chr$(9))
        If UBound(dealFields) >= 1 Then dealRow = CStr(dealFields(1))
        dealRow = Replace(dealRow, ",", ";", 1, -1, vbBinaryCompare)
        dealItems = Split(dealRow, ";")

        For itemIndex = LBound(dealItems) To UBound(dealItems)
            productId = CLng(Val(CStr(dealItems(itemIndex))))
            If productId > 0 Then
                defaultSign = CStr(Proc_10_10_80A7F0(Proc_8_12_806C30(productId, 4, 0), 0, 0))
                If Len(defaultSign) = 0 Then defaultSign = CStr(Proc_10_10_80A7F0(Proc_8_12_806C30(productId, 5, 0), 0, 0))
                Proc_5_0_6D3CD0 "INSERT INTO furnitures(id_product,id_owner,sign,task_owner,task_time,id_ctlgproduct) VALUES('" & _
                    CStr(productId) & "','" & Proc_10_11_80A9C0(userId, 0, 0) & "','" & Proc_10_11_80A9C0(defaultSign, 0, 0) & "','" & _
                    Proc_10_11_80A9C0(userId, 0, 0) & "',UNIX_TIMESTAMP(),'" & CStr(catalogProductId) & "')", 0, 0
                grantedCount = grantedCount + 1
            End If
        Next itemIndex
    Else
        containsClubRow = CStr(Proc_5_2_6D4690("SELECT months,level FROM products_containshc WHERE id_product='" & CStr(catalogProductId) & "' LIMIT 1", 0, 0))
        If Len(containsClubRow) = 0 Then containsClubRow = CStr(Proc_5_2_6D4690("SELECT months,level FROM products_containshc WHERE id_product='" & CStr(productId) & "' LIMIT 1", 0, 0))
        If Len(containsClubRow) > 0 Then
            containsClubFields = Split(containsClubRow, Chr$(9))
            hcMonths = CLng(Val(HandlingField(containsClubFields, 0)))
            hcLevel = CLng(Val(HandlingField(containsClubFields, 1)))
            If hcLevel <= 0 Then hcLevel = 1
            Proc_10_23_80E110 userId, hcLevel, hcMonths, hcMonths * 31
        End If

        badgeId = UCase$(CStr(Proc_8_12_806C30(productId, 26, 0)))
        If Len(badgeId) = 0 Then badgeId = UCase$(CStr(Proc_8_12_806C30(productId, 27, 0)))
        If Len(badgeId) > 2 Then
            existingBadge = UCase$(CStr(Proc_5_2_6D4690("SELECT id_badge FROM users_badges WHERE id_user='" & Proc_10_11_80A9C0(userId, 0, 0) & _
                "' AND id_badge='" & Proc_10_11_80A9C0(badgeId, 0, 0) & "' LIMIT 1", 0, 0)))
            If existingBadge <> badgeId Then
                Proc_5_0_6D3CD0 "INSERT INTO users_badges(id_user,id_slot,id_badge) VALUES('" & Proc_10_11_80A9C0(userId, 0, 0) & "','0','" & _
                    Proc_10_11_80A9C0(badgeId, 0, 0) & "')", 0, 0
                badgeRowId = CLng(Val(CStr(Proc_5_2_6D4690("SELECT id FROM users_badges WHERE id_user='" & Proc_10_11_80A9C0(userId, 0, 0) & _
                    "' AND id_badge='" & Proc_10_11_80A9C0(badgeId, 0, 0) & "' ORDER BY id DESC LIMIT 1", 0, 0))))
                Proc_6_195_7D38D0 userId, 0, 0
                Proc_6_193_7D2BB0 socketIndex, "Ce", vbNullString
                If badgeRowId > 0 Then Proc_6_143_76BB80 socketIndex, 0, 0
            End If
        End If

        defaultSign = signText
        If Len(defaultSign) = 0 Then defaultSign = CStr(Proc_10_10_80A7F0(Proc_8_12_806C30(productId, 4, 0), 0, 0))
        If Len(defaultSign) = 0 Then defaultSign = CStr(Proc_10_10_80A7F0(Proc_8_12_806C30(productId, 5, 0), 0, 0))

        For itemIndex = 1 To amount
            Proc_5_0_6D3CD0 "INSERT INTO furnitures(id_product,id_owner,sign,task_owner,task_time,id_ctlgproduct) VALUES('" & _
                CStr(productId) & "','" & Proc_10_11_80A9C0(userId, 0, 0) & "','" & Proc_10_11_80A9C0(defaultSign, 0, 0) & "','" & _
                Proc_10_11_80A9C0(userId, 0, 0) & "',UNIX_TIMESTAMP(),'" & CStr(catalogProductId) & "')", 0, 0
            grantedCount = grantedCount + 1
        Next itemIndex
    End If

    If grantedCount > 0 Then
        newestIds = CStr(Proc_5_2_6D4690("SELECT id FROM furnitures WHERE id_owner='" & Proc_10_11_80A9C0(userId, 0, 0) & _
            "' ORDER BY id DESC LIMIT " & CStr(grantedCount), 0, 0))
        grantedIds = Replace(newestIds, Chr$(13), global_004092F0, 1, -1, vbBinaryCompare)
        firstGrantedId = CLng(Val(grantedIds))

        If typeSecondary <> "products_deals" And CLng(Val(CStr(Proc_8_12_806C30(productId, 0, 0)))) = 9 And firstGrantedId > 0 Then
            Proc_5_0_6D3CD0 "INSERT INTO furnitures_dimmerpresets(id_furni,id_preset,id_state) VALUES('" & CStr(firstGrantedId) & "','1','2'),('" & _
                CStr(firstGrantedId) & "','2','1'),('" & CStr(firstGrantedId) & "','3','1')", 0, 0
            Proc_5_0_6D3CD0 "UPDATE furnitures SET sign='1,1,1,#000000,166' WHERE id='" & CStr(firstGrantedId) & "'", 0, 0
        End If
    End If

    Proc_6_133_760400 = grantedIds
    Exit Function

GrantFailed:
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
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim userId As String
    Dim roomId As Long
    Dim furnitureId As Long
    Dim rowText As String
    Dim fields() As String
    Dim productId As Long
    Dim productFields() As String
    Dim productType As Long
    Dim decoName As String
    Dim decoColumn As String
    Dim decoValue As String

    On Error GoTo DecorationFailed

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    userId = HandlingUserIdFromSocket(socketIndex)
    roomId = HandlingCurrentRoomId(socketIndex, userId)
    If Len(userId) = 0 Or roomId <= 0 Then GoTo DecorationFailed

    Proc_10_5_809D80 packetPayload, 3, 0
    furnitureId = CLng(Val(CStr(Proc_10_6_809F10(packetPayload, 0, 0))))
    If furnitureId <= 0 Then GoTo DecorationFailed

    rowText = CStr(Proc_5_2_6D4690("SELECT id,id_product,sign FROM furnitures WHERE id_owner='" & Proc_10_11_80A9C0(userId, 0, 0) & "' AND id='" & CStr(furnitureId) & "' AND id_room IS NULL LIMIT 1", 0, 0))
    If Len(rowText) = 0 Then GoTo DecorationFailed

    fields = Split(rowText, Chr$(9))
    productId = CLng(Val(NavigatorField(fields, 1)))
    decoValue = NavigatorField(fields, 2)
    productFields = Split(CStr(Proc_9_3_807930(productId, 0, 0)), Chr$(9))
    productType = CLng(Val(NavigatorField(productFields, 1)))

    Select Case productType
        Case 2
            decoName = "wallpaper"
            decoColumn = "id_wallpaper"
        Case 3
            decoName = "floor"
            decoColumn = "id_floor"
        Case 4
            decoName = "landscape"
            decoColumn = "id_landscape"
        Case Else
            GoTo DecorationFailed
    End Select

    If Len(decoValue) = 0 Or decoValue = "0" Then decoValue = NavigatorField(productFields, 20)
    If Len(decoValue) = 0 Then decoValue = NavigatorField(productFields, 18)
    If Len(decoValue) = 0 Then GoTo DecorationFailed

    Proc_6_247_8027E0 socketIndex, "@n" & decoName & Chr$(2) & decoValue & Chr$(2), 0
    Proc_5_0_6D3CD0 "UPDATE rooms SET " & decoColumn & "='" & Proc_10_11_80A9C0(decoValue, 0, 0) & "' WHERE id='" & CStr(roomId) & "'", 0, 0
    Proc_6_244_801E80 socketIndex, CStr(Proc_3_0_6D2AF0(furnitureId, Empty, "Ac")), 0
    Proc_5_0_6D3CD0 "DELETE FROM furnitures WHERE id='" & CStr(furnitureId) & "' LIMIT 1", 0, 0
    Proc_6_140_769400 socketIndex, "FT", vbNullString

DecorationFailed:
    Proc_6_139_768100 = Empty
End Function

' Original declaration: Private Sub Proc_6_140_769400
Public Function Proc_6_140_769400(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim userId As String
    Dim rowText As String
    Dim rows() As String
    Dim fields() As String
    Dim rowIndex As Long
    Dim furnitureId As Long
    Dim productId As Long
    Dim itemData As String
    Dim secondaryValue As Long
    Dim productType As Long
    Dim regularCount As Long
    Dim iconCount As Long
    Dim regularPayload As String
    Dim iconPayload As String

    On Error GoTo InventoryFailed

    socketIndex = HandlingSocketIndex(args)
    userId = HandlingUserIdFromSocket(socketIndex)
    If Len(userId) = 0 Then GoTo InventoryFailed

    rowText = CStr(Proc_5_2_6D4690("SELECT id,id_product,sign,id_secondary FROM furnitures WHERE id_owner='" & Proc_10_11_80A9C0(userId, 0, 0) & "' AND id_room IS NULL LIMIT 1000", 0, 0))
    If Len(rowText) > 0 Then
        rows = Split(rowText, Chr$(13))
        For rowIndex = LBound(rows) To UBound(rows)
            If Len(rows(rowIndex)) > 0 Then
                fields = Split(rows(rowIndex), Chr$(9))
                furnitureId = CLng(Val(NavigatorField(fields, 0)))
                productId = CLng(Val(NavigatorField(fields, 1)))
                itemData = NavigatorField(fields, 2)
                secondaryValue = CLng(Val(NavigatorField(fields, 3)))
                productType = CLng(Val(CStr(Proc_8_12_806C30(productId, 0, 0))))

                If productType = 9 Then
                    iconPayload = iconPayload & CStr(Proc_6_138_7678A0(furnitureId, productId, itemData, secondaryValue))
                    iconCount = iconCount + 1
                Else
                    regularPayload = regularPayload & CStr(Proc_6_138_7678A0(furnitureId, productId, itemData, secondaryValue))
                    regularCount = regularCount + 1
                End If
            End If
        Next rowIndex
    End If

    Proc_6_244_801E80 socketIndex, Chr$(2) & CStr(Proc_3_0_6D2AF0(regularCount, Empty, "BLS" & Chr$(2) & "II")) & regularPayload, 0
    Proc_6_244_801E80 socketIndex, CStr(Proc_3_0_6D2AF0(iconCount, Empty, "BL" & global_004096B0 & Chr$(2) & "II")) & iconPayload, 0
    Proc_6_244_801E80 socketIndex, CStr(Proc_3_0_6D2AF0(0, Empty, CStr(Proc_3_0_6D2AF0(0, Empty, CStr(Proc_3_0_6D2AF0(0, Empty, CStr(Proc_3_0_6D2AF0(0, Empty, "Id")) & "HHH"))))) & "H", 0

InventoryFailed:
    Proc_6_140_769400 = Empty
End Function

' Original declaration: Private Sub Proc_6_141_76A670
Public Function Proc_6_141_76A670(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim requestPayload As String
    Dim normalizedPayload As String
    Dim tokens() As String
    Dim offset As Long
    Dim userId As String
    Dim roomId As Long
    Dim furnitureId As Long
    Dim productId As Long
    Dim secondaryValue As Long
    Dim productType As Long
    Dim positionX As Long
    Dim positionY As Long
    Dim rotation As Long
    Dim positionZ As String
    Dim itemData As String
    Dim itemRow As String
    Dim itemFields() As String
    Dim productFields() As String
    Dim movementPayload As String

    On Error GoTo MoveFailed

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    If Len(packetPayload) = 0 And UBound(args) >= 1 Then packetPayload = CStr(args(1))

    requestPayload = packetPayload
    If Left$(requestPayload, 2) = "A[" Then requestPayload = Mid$(requestPayload, 3)

    normalizedPayload = Replace(requestPayload, Chr$(1), Chr$(32), 1, -1, vbBinaryCompare)
    normalizedPayload = Replace(normalizedPayload, Chr$(2), Chr$(32), 1, -1, vbBinaryCompare)
    normalizedPayload = Replace(normalizedPayload, Chr$(9), Chr$(32), 1, -1, vbBinaryCompare)
    normalizedPayload = Replace(normalizedPayload, Chr$(13), Chr$(32), 1, -1, vbBinaryCompare)
    normalizedPayload = Replace(normalizedPayload, Chr$(10), Chr$(32), 1, -1, vbBinaryCompare)
    Do While InStr(1, normalizedPayload, "  ", vbBinaryCompare) > 0
        normalizedPayload = Replace(normalizedPayload, "  ", " ", 1, -1, vbBinaryCompare)
    Loop
    normalizedPayload = Trim$(normalizedPayload)

    If Len(normalizedPayload) > 0 Then
        tokens = Split(normalizedPayload, Chr$(32))
        If UBound(tokens) >= 0 Then furnitureId = CLng(Val(tokens(0)))
        If UBound(tokens) >= 1 Then positionX = CLng(Val(tokens(1)))
        If UBound(tokens) >= 2 Then positionY = CLng(Val(tokens(2)))
        If UBound(tokens) >= 3 Then rotation = CLng(Val(tokens(3)))
    End If

    If furnitureId <= 0 Then
        offset = 1
        furnitureId = ReadWireLong(requestPayload, offset)
    End If
    If furnitureId <= 0 Then GoTo MoveFailed

    userId = HandlingUserIdFromSocket(socketIndex)
    If Len(userId) = 0 Or userId = "0" Then GoTo MoveFailed

    roomId = HandlingCurrentRoomId(socketIndex, userId)
    If roomId <= 0 Then GoTo MoveFailed
    If Not HandlingUserHasRoomRight(userId, roomId) And Not HandlingUserHasPermission(userId, "fuse_pick_up_any_furni") Then GoTo MoveFailed

    itemRow = CStr(Proc_5_2_6D4690("SELECT id_product,id,sign,id_secondary,id_destination FROM furnitures WHERE id='" & CStr(furnitureId) & "' AND id_room='" & CStr(roomId) & "' LIMIT 1", 0, 0))
    If Len(itemRow) = 0 Then GoTo MoveFailed

    itemFields = Split(itemRow, Chr$(9))
    productId = CLng(Val(NavigatorField(itemFields, 0)))
    itemData = NavigatorField(itemFields, 2)
    secondaryValue = CLng(Val(NavigatorField(itemFields, 3)))
    If productId <= 0 Then GoTo MoveFailed

    productFields = Split(CStr(Proc_9_3_807930(productId, 0, 0)), Chr$(9))
    productType = CLng(Val(NavigatorField(productFields, 1)))
    If productType = 9 Then GoTo MoveFailed

    positionZ = CStr(Val(NavigatorField(productFields, 24)))

    Proc_5_0_6D3CD0 "UPDATE furnitures SET position_x='" & CStr(positionX) & "',position_y='" & CStr(positionY) & _
        "',position_z='" & Proc_10_11_80A9C0(positionZ, 0, 0) & "',position_r='" & CStr(rotation) & _
        "',position_wall=NULL,task_owner='" & Proc_10_11_80A9C0(userId, 0, 0) & _
        "',task_time=UNIX_TIMESTAMP() WHERE id='" & CStr(furnitureId) & "' AND id_room='" & CStr(roomId) & "' LIMIT 1", 0, 0

    movementPayload = CStr(Proc_6_161_7B2EE0(furnitureId, positionX, positionY, rotation, CLng(Val(positionZ)), vbNullString, itemData, secondaryValue, productId))
    If Len(movementPayload) > 0 Then Proc_6_247_8027E0 socketIndex, "A_" & movementPayload, 0
    Proc_6_106_74B750 App.Path & "\CACHE\ROOMS\" & CStr(roomId) & ".cache", 0, 0
    Proc_6_106_74B750 App.Path & "\CACHE\PATHFINDER\" & CStr(roomId) & ".cache", 0, 0

MoveFailed:
    Proc_6_141_76A670 = Empty
End Function

' Original declaration: Private Sub Proc_6_142_76B310
Public Function Proc_6_142_76B310(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim requestPayload As String
    Dim normalizedPayload As String
    Dim tokens() As String
    Dim offset As Long
    Dim userId As String
    Dim roomId As Long
    Dim furnitureId As Long
    Dim productId As Long
    Dim secondaryValue As Long
    Dim productType As Long
    Dim positionX As Long
    Dim positionY As Long
    Dim rotation As Long
    Dim positionZ As String
    Dim itemData As String
    Dim itemRow As String
    Dim itemFields() As String
    Dim productFields() As String
    Dim placementPayload As String

    On Error GoTo PlaceFailed

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    If Len(packetPayload) = 0 And UBound(args) >= 1 Then packetPayload = CStr(args(1))

    requestPayload = packetPayload
    If Left$(requestPayload, 2) = "rv" Then requestPayload = Mid$(requestPayload, 3)

    normalizedPayload = Replace(requestPayload, Chr$(1), Chr$(32), 1, -1, vbBinaryCompare)
    normalizedPayload = Replace(normalizedPayload, Chr$(2), Chr$(32), 1, -1, vbBinaryCompare)
    normalizedPayload = Replace(normalizedPayload, Chr$(9), Chr$(32), 1, -1, vbBinaryCompare)
    normalizedPayload = Replace(normalizedPayload, Chr$(13), Chr$(32), 1, -1, vbBinaryCompare)
    normalizedPayload = Replace(normalizedPayload, Chr$(10), Chr$(32), 1, -1, vbBinaryCompare)
    Do While InStr(1, normalizedPayload, "  ", vbBinaryCompare) > 0
        normalizedPayload = Replace(normalizedPayload, "  ", " ", 1, -1, vbBinaryCompare)
    Loop
    normalizedPayload = Trim$(normalizedPayload)

    If Len(normalizedPayload) > 0 Then
        tokens = Split(normalizedPayload, Chr$(32))
        If UBound(tokens) >= 0 Then furnitureId = CLng(Val(tokens(0)))
        If UBound(tokens) >= 1 Then positionX = CLng(Val(tokens(1)))
        If UBound(tokens) >= 2 Then positionY = CLng(Val(tokens(2)))
        If UBound(tokens) >= 3 Then rotation = CLng(Val(tokens(3)))
    End If

    If furnitureId <= 0 Then
        offset = 1
        furnitureId = ReadWireLong(requestPayload, offset)
    End If
    If furnitureId <= 0 Then GoTo PlaceFailed

    userId = HandlingUserIdFromSocket(socketIndex)
    If Len(userId) = 0 Or userId = "0" Then GoTo PlaceFailed

    roomId = HandlingCurrentRoomId(socketIndex, userId)
    If roomId <= 0 Then GoTo PlaceFailed
    If Not HandlingUserHasRoomRight(userId, roomId) And Not HandlingUserHasPermission(userId, "fuse_pick_up_any_furni") Then GoTo PlaceFailed

    itemRow = CStr(Proc_5_2_6D4690("SELECT id_product,id,sign,id_secondary,id_destination FROM furnitures WHERE id='" & CStr(furnitureId) & "' AND id_owner='" & _
        Proc_10_11_80A9C0(userId, 0, 0) & "' AND id_room IS NULL LIMIT 1", 0, 0))
    If Len(itemRow) = 0 Then GoTo PlaceFailed

    itemFields = Split(itemRow, Chr$(9))
    productId = CLng(Val(NavigatorField(itemFields, 0)))
    itemData = NavigatorField(itemFields, 2)
    secondaryValue = CLng(Val(NavigatorField(itemFields, 3)))
    If productId <= 0 Then GoTo PlaceFailed

    productFields = Split(CStr(Proc_9_3_807930(productId, 0, 0)), Chr$(9))
    productType = CLng(Val(NavigatorField(productFields, 1)))
    If productType = 9 Then
        Proc_6_157_7974B0 socketIndex, requestPayload, itemFields
        GoTo PlaceFailed
    End If

    positionZ = CStr(Val(NavigatorField(productFields, 24)))

    Proc_5_0_6D3CD0 "UPDATE furnitures SET id_owner=NULL,id_room='" & CStr(roomId) & "',position_x='" & CStr(positionX) & _
        "',position_y='" & CStr(positionY) & "',position_z='" & Proc_10_11_80A9C0(positionZ, 0, 0) & "',position_r='" & _
        CStr(rotation) & "',position_wall=NULL,task_owner='" & Proc_10_11_80A9C0(userId, 0, 0) & _
        "',task_time=UNIX_TIMESTAMP() WHERE id='" & CStr(furnitureId) & "' AND id_owner='" & _
        Proc_10_11_80A9C0(userId, 0, 0) & "' AND id_room IS NULL LIMIT 1", 0, 0

    Proc_6_244_801E80 socketIndex, CStr(Proc_3_0_6D2AF0(furnitureId, Empty, "Ac")), 0
    placementPayload = CStr(Proc_6_161_7B2EE0(furnitureId, positionX, positionY, rotation, CLng(Val(positionZ)), vbNullString, itemData, secondaryValue, productId))
    If Len(placementPayload) > 0 Then Proc_6_247_8027E0 socketIndex, "A]" & placementPayload, 0
    Proc_6_106_74B750 App.Path & "\CACHE\ROOMS\" & CStr(roomId) & ".cache", 0, 0
    Proc_6_106_74B750 App.Path & "\CACHE\PATHFINDER\" & CStr(roomId) & ".cache", 0, 0
    Proc_6_140_769400 socketIndex, "FT", vbNullString

PlaceFailed:
    Proc_6_142_76B310 = Empty
End Function

' Original declaration: Private Sub Proc_6_143_76BB80
Public Function Proc_6_143_76BB80(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim userId As String
    Dim rowText As String
    Dim fields() As String
    Dim pointType As Long
    Dim pointValue As Long
    Dim itemCount As Long
    Dim itemPayload As String

    On Error GoTo BalanceFailed

    socketIndex = HandlingSocketIndex(args)
    userId = HandlingUserIdFromSocket(socketIndex)
    If Len(userId) = 0 Then GoTo BalanceFailed

    rowText = CStr(Proc_5_2_6D4690("SELECT activitypoints_1,activitypoints_2,activitypoints_3,activitypoints_4 FROM users WHERE id='" & Proc_10_11_80A9C0(userId, 0, 0) & "' LIMIT 1", 0, 0))
    If Len(rowText) = 0 Then GoTo BalanceFailed

    fields = Split(rowText, Chr$(9))
    For pointType = 1 To 4
        pointValue = CLng(Val(NavigatorField(fields, pointType - 1)))
        itemPayload = itemPayload & CStr(Proc_3_0_6D2AF0(pointType, Empty, vbNullString))
        itemPayload = itemPayload & CStr(Proc_3_0_6D2AF0(pointValue, Empty, vbNullString))
        itemCount = itemCount + 1
    Next pointType

    Proc_6_244_801E80 socketIndex, CStr(Proc_3_0_6D2AF0(itemCount, Empty, "M@")) & itemPayload, 0

BalanceFailed:
    Proc_6_143_76BB80 = Empty
End Function

' Original declaration: Private Sub Proc_6_144_76BE70
Public Function Proc_6_144_76BE70(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim requestPayload As String
    Dim userId As String
    Dim roomId As Long
    Dim furnitureId As Long
    Dim rowText As String
    Dim fields() As String
    Dim ownerId As String
    Dim productId As Long
    Dim offset As Long

    On Error GoTo PickupFailed

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    If Len(packetPayload) = 0 And UBound(args) >= 1 Then packetPayload = CStr(args(1))
    If Left$(packetPayload, 2) = "AZ" Then
        requestPayload = Mid$(packetPayload, 3)
    Else
        requestPayload = packetPayload
    End If

    userId = HandlingUserIdFromSocket(socketIndex)
    roomId = HandlingCurrentRoomId(socketIndex, userId)
    If Len(userId) = 0 Or userId = "0" Or roomId <= 0 Then GoTo PickupFailed

    furnitureId = CLng(Val(CStr(Proc_10_6_809F10(requestPayload, 0, 0))))
    If furnitureId <= 0 Then
        offset = 1
        furnitureId = ReadWireLong(requestPayload, offset)
    End If
    If furnitureId <= 0 Then GoTo PickupFailed

    rowText = CStr(Proc_5_2_6D4690("SELECT id_product,id_owner FROM furnitures WHERE id='" & CStr(furnitureId) & "' AND id_room='" & CStr(roomId) & "' LIMIT 1", 0, 0))
    If Len(rowText) = 0 Then GoTo PickupFailed

    fields = Split(rowText, Chr$(9))
    productId = CLng(Val(HandlingField(fields, 0)))
    ownerId = CStr(CLng(Val(HandlingField(fields, 1))))
    If productId <= 0 Or Len(ownerId) = 0 Or ownerId = "0" Then GoTo PickupFailed

    If ownerId <> userId Then
        If Not HandlingUserOwnsRoom(userId, roomId) And Not HandlingUserHasPermission(userId, "fuse_pick_up_any_furni") Then GoTo PickupFailed
    End If
    If Not HandlingUserHasRoomRight(userId, roomId) And ownerId <> userId And Not HandlingUserHasPermission(userId, "fuse_pick_up_any_furni") Then GoTo PickupFailed

    Proc_5_0_6D3CD0 "UPDATE furnitures SET id_room=NULL,position_x=NULL,position_y=NULL,position_z=NULL,position_r='0',position_wall=NULL,id_owner='" & _
        Proc_10_11_80A9C0(userId, 0, 0) & "',task_owner='" & Proc_10_11_80A9C0(userId, 0, 0) & "',task_time=UNIX_TIMESTAMP() WHERE id='" & CStr(furnitureId) & "' LIMIT 1", 0, 0
    Proc_6_247_8027E0 socketIndex, "A^" & CStr(furnitureId) & Chr$(2), 0
    Proc_6_106_74B750 App.Path & "\CACHE\ROOMS\" & CStr(roomId) & ".cache", 0, 0
    Proc_6_106_74B750 App.Path & "\CACHE\PATHFINDER\" & CStr(roomId) & ".cache", 0, 0
    Proc_6_140_769400 socketIndex, "FT", vbNullString

PickupFailed:
    Proc_6_144_76BE70 = Empty
End Function

' Original declaration: Private  Proc_6_145_76CA20(arg_C, arg_10, arg_14) '76CA20
Public Function Proc_6_145_76CA20(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim roomId As Long
    Dim furnitureId As Long
    Dim userId As String
    Dim markerText As String
    Dim roomCacheText As String

    On Error GoTo TrackDone

    If UBound(args) >= 2 Then
        socketIndex = CInt(Val(CStr(args(0))))
        roomId = CLng(Val(CStr(args(1))))
        furnitureId = CLng(Val(CStr(args(2))))
    ElseIf UBound(args) >= 1 Then
        roomId = CLng(Val(CStr(args(0))))
        furnitureId = CLng(Val(CStr(args(1))))
    ElseIf UBound(args) >= 0 Then
        furnitureId = CLng(Val(CStr(args(0))))
    End If

    If roomId <= 0 And socketIndex > 0 Then
        userId = HandlingUserIdFromSocket(socketIndex)
        If Len(userId) > 0 And userId <> "0" Then roomId = HandlingCurrentRoomId(socketIndex, userId)
    End If
    If furnitureId <= 0 Then GoTo TrackDone

    markerText = Chr$(1) & CStr(furnitureId) & Chr$(2)
    global_008291FC = Replace(global_008291FC, markerText, vbNullString, 1, -1, vbBinaryCompare)
    global_008291FC = global_008291FC & markerText

    markerText = Chr$(1) & CStr(furnitureId) & Chr$(9)
    global_008291FC = RemoveRepresentedCacheRecord(global_008291FC, markerText)

    If Len(global_00829310) > 0 Then
        roomCacheText = CStr(global_00829310)
        roomCacheText = RemoveRepresentedCacheRecord(roomCacheText, Chr$(1) & CStr(furnitureId) & Chr$(2))
        roomCacheText = RemoveRepresentedCacheRecord(roomCacheText, Chr$(1) & CStr(furnitureId) & Chr$(9))
        global_00829310 = roomCacheText
    End If

    If roomId > 0 Then
        markerText = Chr$(1) & CStr(roomId) & Chr$(2)
        global_008291F8 = Replace(global_008291F8, markerText, vbNullString, 1, -1, vbBinaryCompare)
        global_008291F8 = RemoveRepresentedCacheRecord(global_008291F8, Chr$(1) & CStr(roomId) & Chr$(9))
        global_008291F8 = global_008291F8 & markerText

        Proc_6_106_74B750 App.Path & "\CACHE\ROOMS\" & CStr(roomId) & ".cache", 0, 0
        Proc_6_106_74B750 App.Path & "\CACHE\PATHFINDER\" & CStr(roomId) & ".cache", 0, 0
    End If

TrackDone:
    Proc_6_145_76CA20 = Empty
End Function

' Original declaration: Private  Proc_6_146_76D300(arg_C, arg_10) '76D300
Public Function Proc_6_146_76D300(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim furnitureId As Long
    Dim productId As Long
    Dim roomId As Long
    Dim rowText As String
    Dim fields() As String
    Dim markerText As String
    Dim roomCacheText As String

    On Error GoTo RemoveDone

    If UBound(args) >= 2 Then
        socketIndex = CInt(Val(CStr(args(0))))
        furnitureId = CLng(Val(CStr(args(1))))
        productId = CLng(Val(CStr(args(2))))
    ElseIf UBound(args) >= 1 Then
        furnitureId = CLng(Val(CStr(args(0))))
        productId = CLng(Val(CStr(args(1))))
    ElseIf UBound(args) >= 0 Then
        furnitureId = CLng(Val(CStr(args(0))))
    End If

    If furnitureId <= 0 Then GoTo RemoveDone

    If productId <= 0 Then
        productId = CLng(Val(CStr(Proc_5_2_6D4690("SELECT id_product FROM furnitures WHERE id='" & CStr(furnitureId) & "' LIMIT 1", 0, 0))))
    End If

    rowText = CStr(Proc_5_2_6D4690("SELECT id_room FROM furnitures WHERE id='" & CStr(furnitureId) & "' LIMIT 1", 0, 0))
    If Len(rowText) > 0 Then
        fields = Split(rowText, Chr$(9))
        roomId = CLng(Val(HandlingField(fields, 0)))
    End If

    markerText = Chr$(1) & CStr(furnitureId) & Chr$(2)
    global_008291F8 = Replace(global_008291F8, markerText, vbNullString, 1, -1, vbBinaryCompare)
    global_008291FC = Replace(global_008291FC, markerText, vbNullString, 1, -1, vbBinaryCompare)

    markerText = Chr$(1) & CStr(furnitureId) & Chr$(9)
    global_008291F8 = RemoveRepresentedCacheRecord(global_008291F8, markerText)
    global_008291FC = RemoveRepresentedCacheRecord(global_008291FC, markerText)

    If Len(global_00829310) > 0 Then
        roomCacheText = CStr(global_00829310)
        roomCacheText = RemoveRepresentedCacheRecord(roomCacheText, Chr$(1) & CStr(furnitureId) & Chr$(2))
        roomCacheText = RemoveRepresentedCacheRecord(roomCacheText, Chr$(1) & CStr(furnitureId) & Chr$(9))
        global_00829310 = roomCacheText
    End If

    If roomId <= 0 And socketIndex > 0 Then
        rowText = HandlingUserIdFromSocket(socketIndex)
        If Len(rowText) > 0 And rowText <> "0" Then roomId = HandlingCurrentRoomId(socketIndex, rowText)
    End If

    If roomId > 0 Then
        Proc_6_106_74B750 App.Path & "\CACHE\ROOMS\" & CStr(roomId) & ".cache", 0, 0
        Proc_6_106_74B750 App.Path & "\CACHE\PATHFINDER\" & CStr(roomId) & ".cache", 0, 0
    End If

RemoveDone:
    Proc_6_146_76D300 = Empty
End Function

' Original declaration: Private  Proc_6_147_76E910(arg_C, arg_10) '76E910
Public Function Proc_6_147_76E910(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_147_76E910 = Empty
End Function

' Original declaration: Private  Proc_6_148_7756D0(arg_C, arg_10, arg_14) '7756D0
Public Function Proc_6_148_7756D0(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim productId As Long
    Dim furnitureId As Long
    Dim productFields() As String
    Dim chargePath As String
    Dim currentCharges As Long
    Dim hasCharge As Long
    Dim chargePriceCredits As Long
    Dim chargePricePoints As Long
    Dim chargePointType As Long
    Dim chargeSize As Long
    Dim payload As String

    On Error GoTo ChargeInfoFailed
    If UBound(args) < 2 Then GoTo ChargeInfoFailed

    socketIndex = HandlingSocketIndex(args)
    productId = CLng(Val(CStr(args(1))))
    furnitureId = CLng(Val(CStr(args(2))))
    If socketIndex <= 0 Or productId <= 0 Or furnitureId <= 0 Then GoTo ChargeInfoFailed

    productFields = Split(CStr(Proc_9_3_807930(productId, 0, 0)), Chr$(9))
    hasCharge = CLng(Val(NavigatorField(productFields, 34)))
    If hasCharge = 0 Then GoTo ChargeInfoFailed

    chargeSize = CLng(Val(NavigatorField(productFields, 34)))
    chargePriceCredits = CLng(Val(NavigatorField(productFields, 35)))
    chargePricePoints = CLng(Val(NavigatorField(productFields, 36)))
    chargePointType = CLng(Val(NavigatorField(productFields, 37)))

    chargePath = App.Path & "\cache\items_charges\" & CStr(furnitureId) & ".cache"
    currentCharges = CLng(Val(CStr(Proc_6_239_7FC170(chargePath, 0, 0))))

    If currentCharges < 1 Then
        payload = CStr(Proc_3_0_6D2AF0(furnitureId, Empty, "Iu"))
        payload = payload & CStr(Proc_3_0_6D2AF0(currentCharges, Empty, vbNullString))
        payload = payload & CStr(Proc_3_0_6D2AF0(chargeSize, Empty, vbNullString))
        payload = payload & CStr(Proc_3_0_6D2AF0(chargePriceCredits, Empty, vbNullString))
        payload = payload & CStr(Proc_3_0_6D2AF0(chargePricePoints, Empty, vbNullString))
        payload = payload & CStr(Proc_3_0_6D2AF0(chargePointType, Empty, vbNullString))
        Proc_6_244_801E80 socketIndex, payload, 0
    Else
        Proc_8_10_8068E0 chargePath, CStr(currentCharges - 1), 0
    End If

ChargeInfoFailed:
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
    Dim roomId As Long
    Dim furnitureId As Long
    Dim stateValue As Long
    Dim markerText As String
    Dim roomRecord As String
    Dim roomCacheText As String

    On Error GoTo StateDone

    If UBound(args) >= 2 Then
        roomId = CLng(Val(CStr(args(0))))
        furnitureId = CLng(Val(CStr(args(1))))
        stateValue = CLng(Val(CStr(args(2))))
    ElseIf UBound(args) >= 1 Then
        roomId = CLng(Val(CStr(args(0))))
        furnitureId = CLng(Val(CStr(args(1))))
    ElseIf UBound(args) >= 0 Then
        furnitureId = CLng(Val(CStr(args(0))))
    End If

    If roomId <= 0 Or furnitureId <= 0 Then GoTo StateDone

    markerText = Chr$(1) & CStr(roomId) & Chr$(2)
    global_008291F8 = Replace(global_008291F8, markerText, vbNullString, 1, -1, vbBinaryCompare)
    global_008291F8 = RemoveRepresentedCacheRecord(global_008291F8, Chr$(1) & CStr(roomId) & Chr$(9))
    global_008291F8 = global_008291F8 & markerText

    markerText = Chr$(1) & CStr(furnitureId) & Chr$(2)
    global_008291FC = Replace(global_008291FC, markerText, vbNullString, 1, -1, vbBinaryCompare)
    global_008291FC = global_008291FC & markerText

    roomCacheText = CStr(global_00829310)
    roomCacheText = RemoveRepresentedCacheRecord(roomCacheText, Chr$(1) & CStr(roomId) & Chr$(9))
    roomCacheText = RemoveRepresentedCacheRecord(roomCacheText, Chr$(1) & CStr(furnitureId) & Chr$(2))
    roomCacheText = RemoveRepresentedCacheRecord(roomCacheText, Chr$(1) & CStr(furnitureId) & Chr$(9))
    roomRecord = Chr$(1) & CStr(roomId) & Chr$(9) & CStr(furnitureId) & Chr$(9) & CStr(stateValue) & Chr$(2)
    global_00829310 = roomCacheText & roomRecord

    Proc_6_106_74B750 App.Path & "\CACHE\ROOMS\" & CStr(roomId) & ".cache", 0, 0
    Proc_6_106_74B750 App.Path & "\CACHE\PATHFINDER\" & CStr(roomId) & ".cache", 0, 0

StateDone:
    Proc_6_151_78AC20 = Empty
End Function

' Original declaration: Private  Proc_6_152_78C2F0(arg_C, arg_10) '78C2F0
Public Function Proc_6_152_78C2F0(ParamArray args() As Variant) As Variant
    Proc_6_152_78C2F0 = HandlingRepresentedFurnitureStateWrite(args)
    Proc_6_152_78C2F0 = Empty
End Function

' Original declaration: Private  Proc_6_153_78D980(arg_C, arg_10) '78D980
Public Function Proc_6_153_78D980(ParamArray args() As Variant) As Variant
    Proc_6_153_78D980 = HandlingRepresentedFurnitureStateWrite(args)
    Proc_6_153_78D980 = Empty
End Function

' Original declaration: Private  Proc_6_154_78F040(arg_C, arg_10) '78F040
Public Function Proc_6_154_78F040(ParamArray args() As Variant) As Variant
    Dim furnitureId As Long
    Dim productId As Long
    Dim roomId As Long
    Dim rowText As String
    Dim fields() As String
    Dim signText As String
    Dim stateValue As Long
    Dim productType As Long
    Dim productSprite As String
    Dim payload As String

    On Error GoTo RefreshDone
    If UBound(args) < 0 Then GoTo RefreshDone

    furnitureId = CLng(Val(CStr(args(0))))
    If UBound(args) >= 1 Then productId = CLng(Val(CStr(args(1))))
    If furnitureId <= 0 Then GoTo RefreshDone

    rowText = CStr(Proc_5_2_6D4690("SELECT id_room,id_product,sign FROM furnitures WHERE id='" & CStr(furnitureId) & "' LIMIT 1", 0, 0))
    If Len(rowText) = 0 Then GoTo RefreshDone

    fields = Split(rowText, Chr$(9))
    roomId = CLng(Val(HandlingField(fields, 0)))
    If productId <= 0 Then productId = CLng(Val(HandlingField(fields, 1)))
    signText = HandlingField(fields, 2)
    If roomId <= 0 Or productId <= 0 Then GoTo RefreshDone

    productType = CLng(Val(CStr(Proc_8_12_806C30(productId, 0, 0))))
    productSprite = CStr(Proc_8_12_806C30(productId, 17, 0))
    If Len(productSprite) = 0 Then productSprite = CStr(Proc_8_12_806C30(productId, 18, 0))

    stateValue = CLng(Val(signText))
    If LCase$(Left$(productSprite, 9)) = "bb_score_" Or LCase$(Left$(productSprite, 9)) = "es_score_" Then
        If stateValue < 0 Then stateValue = 0
    End If

    Proc_6_151_78AC20 roomId, furnitureId, stateValue

    payload = "AX" & CStr(furnitureId) & Chr$(2) & CStr(stateValue) & Chr$(2)
    Proc_6_246_8024C0 roomId, payload, 0

    If productType = 11 Or InStr(1, LCase$(productSprite), "soundmachine", vbTextCompare) > 0 Or InStr(1, LCase$(productSprite), "jukebox", vbTextCompare) > 0 Then
        Proc_6_224_7EF5A0 0, roomId, furnitureId
    End If

    Proc_6_154_78F040 = payload
    Exit Function

RefreshDone:
    Proc_6_154_78F040 = Empty
End Function

' Original declaration: Private Sub Proc_6_155_795C90
Public Function Proc_6_155_795C90(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim requestPayload As String
    Dim userId As String
    Dim roomId As Long
    Dim furnitureId As Long
    Dim rowText As String
    Dim fields() As String
    Dim productId As Long
    Dim ownerId As String
    Dim sessionId As String
    Dim offset As Long

    On Error GoTo PickupDone

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    If Len(packetPayload) = 0 And UBound(args) >= 1 Then packetPayload = CStr(args(1))

    requestPayload = packetPayload
    If Left$(requestPayload, 2) = "AC" Then requestPayload = Mid$(requestPayload, 3)

    furnitureId = CLng(Val(CStr(Proc_10_6_809F10(requestPayload, 0, 0))))
    If furnitureId <= 0 Then
        offset = 1
        furnitureId = ReadWireLong(requestPayload, offset)
    End If
    If socketIndex <= 0 Or furnitureId <= 0 Then GoTo PickupDone

    userId = HandlingUserIdFromSocket(socketIndex)
    roomId = HandlingCurrentRoomId(socketIndex, userId)
    If Len(userId) = 0 Or userId = "0" Or roomId <= 0 Then GoTo PickupDone

    rowText = CStr(Proc_5_2_6D4690("SELECT id_product,id_owner FROM furnitures WHERE id='" & CStr(furnitureId) & _
        "' AND id_room='" & CStr(roomId) & "' LIMIT 1", 0, 0))
    If Len(rowText) = 0 Then GoTo PickupDone

    fields = Split(rowText, Chr$(9))
    productId = CLng(Val(HandlingField(fields, 0)))
    ownerId = CStr(CLng(Val(HandlingField(fields, 1))))
    If productId <= 0 Then GoTo PickupDone

    If ownerId <> userId Then
        If Not HandlingUserOwnsRoom(userId, roomId) And Not HandlingUserHasPermission(userId, "fuse_pick_up_any_furni") Then GoTo PickupDone
    End If
    If Not HandlingUserHasRoomRight(userId, roomId) And ownerId <> userId And Not HandlingUserHasPermission(userId, "fuse_pick_up_any_furni") Then GoTo PickupDone

    If ownerId <> userId Then
        sessionId = CStr(Proc_5_2_6D4690("SELECT id_session FROM users WHERE id='" & Proc_10_11_80A9C0(userId, 0, 0) & "' LIMIT 1", 0, 0))
        Proc_5_1_6D4110 "INSERT INTO logs_moderation(id_type,id_user,id_target,id_target_2,timestamp,message,id_session) VALUES('8','" & _
            Proc_10_11_80A9C0(userId, 0, 0) & "','" & CStr(roomId) & "','" & CStr(furnitureId) & "',UNIX_TIMESTAMP(),'','" & _
            Proc_10_11_80A9C0(sessionId, 0, 0) & "')", 0, 0
    End If

    Proc_6_146_76D300 socketIndex, furnitureId, productId
    Proc_5_0_6D3CD0 "UPDATE furnitures SET id_room=NULL,position_x=NULL,position_y=NULL,position_z=NULL,position_r='0',position_wall=NULL,id_owner='" & _
        Proc_10_11_80A9C0(userId, 0, 0) & "',task_owner='" & Proc_10_11_80A9C0(userId, 0, 0) & _
        "',task_time=UNIX_TIMESTAMP() WHERE id='" & CStr(furnitureId) & "' AND id_room='" & CStr(roomId) & "' LIMIT 1", 0, 0

    Proc_6_244_801E80 socketIndex, CStr(Proc_3_0_6D2AF0(furnitureId, Empty, "Ac")), 0
    Proc_6_247_8027E0 socketIndex, "A^" & CStr(furnitureId) & Chr$(2), 0
    Proc_6_106_74B750 App.Path & "\CACHE\ROOMS\" & CStr(roomId) & ".cache", 0, 0
    Proc_6_106_74B750 App.Path & "\CACHE\PATHFINDER\" & CStr(roomId) & ".cache", 0, 0
    Proc_6_140_769400 socketIndex, "FT", vbNullString

PickupDone:
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
    Dim socketIndex As Integer
    Dim wallPayload As String
    Dim itemFields() As String
    Dim userId As String
    Dim roomId As Long
    Dim furnitureId As Long
    Dim productId As Long
    Dim productType As Long
    Dim wallPosition As String
    Dim wallX As Long
    Dim wallY As Long
    Dim localX As Long
    Dim localY As Long
    Dim itemRow As String
    Dim fieldIndex As Long
    Dim payload As String

    On Error GoTo WallPlaceDone

    socketIndex = HandlingSocketIndex(args)
    If socketIndex <= 0 Then GoTo WallPlaceDone

    If UBound(args) >= 1 Then wallPayload = CStr(args(1))
    If Left$(wallPayload, 2) = "rv" Then wallPayload = Mid$(wallPayload, 3)

    If UBound(args) >= 2 Then
        If IsArray(args(2)) Then
            ReDim itemFields(LBound(args(2)) To UBound(args(2)))
            For fieldIndex = LBound(args(2)) To UBound(args(2))
                itemFields(fieldIndex) = CStr(args(2)(fieldIndex))
            Next fieldIndex
        Else
            itemFields = Split(CStr(args(2)), Chr$(9))
        End If
    End If

    furnitureId = CLng(Val(HandlingField(itemFields, 1)))
    productId = CLng(Val(HandlingField(itemFields, 0)))
    If furnitureId <= 0 Then furnitureId = CLng(Val(CStr(Proc_10_6_809F10(wallPayload, 0, 0))))
    If furnitureId <= 0 Then GoTo WallPlaceDone

    userId = HandlingUserIdFromSocket(socketIndex)
    If Len(userId) = 0 Or userId = "0" Then GoTo WallPlaceDone

    roomId = HandlingCurrentRoomId(socketIndex, userId)
    If roomId <= 0 Then GoTo WallPlaceDone
    If Not HandlingUserHasRoomRight(userId, roomId) And Not HandlingUserHasPermission(userId, "fuse_pick_up_any_furni") Then GoTo WallPlaceDone

    If productId <= 0 Then
        itemRow = CStr(Proc_5_2_6D4690("SELECT id_product,id,sign,id_secondary,id_destination FROM furnitures WHERE id='" & CStr(furnitureId) & _
            "' AND id_owner='" & Proc_10_11_80A9C0(userId, 0, 0) & "' AND id_room IS NULL LIMIT 1", 0, 0))
        If Len(itemRow) > 0 Then itemFields = Split(itemRow, Chr$(9))
        productId = CLng(Val(HandlingField(itemFields, 0)))
    End If
    If productId <= 0 Then GoTo WallPlaceDone

    productType = CLng(Val(CStr(Proc_8_12_806C30(productId, 0, 0))))
    If productType <> 9 Then GoTo WallPlaceDone

    If Not WallPlacementFromPayload(wallPayload, wallX, wallY, localX, localY) Then GoTo WallPlaceDone
    wallPosition = Proc_10_11_80A9C0(LCase$(":w=" & CStr(wallX) & "," & CStr(wallY) & " l=" & CStr(localX) & "," & CStr(localY)), 0, 0)

    Proc_5_0_6D3CD0 "UPDATE furnitures SET position_wall='" & wallPosition & "',id_room='" & CStr(roomId) & _
        "',id_owner=NULL,task_owner='" & Proc_10_11_80A9C0(userId, 0, 0) & "',task_time=UNIX_TIMESTAMP() WHERE id='" & _
        CStr(furnitureId) & "' AND id_owner='" & Proc_10_11_80A9C0(userId, 0, 0) & "' AND id_room IS NULL LIMIT 1", 0, 0

    Proc_6_244_801E80 socketIndex, CStr(Proc_3_0_6D2AF0(furnitureId, Empty, "Ac")), 0
    payload = CStr(Proc_6_156_7972B0(furnitureId, productId, wallPosition, HandlingField(itemFields, 2), CLng(Val(HandlingField(itemFields, 3)))))
    If Len(payload) > 0 Then Proc_6_247_8027E0 socketIndex, "AS" & payload, 0

    Proc_6_106_74B750 App.Path & "\CACHE\ROOMS\" & CStr(roomId) & ".cache", 0, 0
    Proc_6_106_74B750 App.Path & "\CACHE\PATHFINDER\" & CStr(roomId) & ".cache", 0, 0
    Proc_6_140_769400 socketIndex, "FT", vbNullString

WallPlaceDone:
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
    Dim socketIndex As Integer
    Dim firstId As Long
    Dim secondId As Long
    Dim furnitureId As Long
    Dim productId As Long
    Dim roomId As Long
    Dim signText As String
    Dim rowText As String
    Dim fields() As String
    Dim productSprite As String
    Dim stateValue As Long
    Dim maxState As Long

    On Error GoTo ScoreboardDone

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 1 Then firstId = CLng(Val(CStr(args(1))))
    If UBound(args) >= 2 Then secondId = CLng(Val(CStr(args(2))))

    If secondId > 0 Then
        rowText = CStr(Proc_5_2_6D4690("SELECT id_room,id_product,sign FROM furnitures WHERE id='" & CStr(secondId) & "' LIMIT 1", 0, 0))
        If Len(rowText) > 0 Then
            furnitureId = secondId
            productId = firstId
        End If
    End If

    If Len(rowText) = 0 And firstId > 0 Then
        rowText = CStr(Proc_5_2_6D4690("SELECT id_room,id_product,sign FROM furnitures WHERE id='" & CStr(firstId) & "' LIMIT 1", 0, 0))
        If Len(rowText) > 0 Then furnitureId = firstId
    End If

    If Len(rowText) = 0 And secondId > 0 Then
        rowText = CStr(Proc_5_2_6D4690("SELECT id_room,id_product,sign FROM furnitures WHERE id_product='" & CStr(secondId) & "' ORDER BY id DESC LIMIT 1", 0, 0))
        If Len(rowText) > 0 Then productId = secondId
    End If
    If Len(rowText) = 0 Then GoTo ScoreboardDone

    fields = Split(rowText, Chr$(9))
    roomId = CLng(Val(HandlingField(fields, 0)))
    If productId <= 0 Then productId = CLng(Val(HandlingField(fields, 1)))
    signText = HandlingField(fields, 2)
    If roomId <= 0 Or productId <= 0 Then GoTo ScoreboardDone

    If furnitureId <= 0 Then
        furnitureId = CLng(Val(CStr(Proc_5_2_6D4690("SELECT id FROM furnitures WHERE id_room='" & CStr(roomId) & _
            "' AND id_product='" & CStr(productId) & "' ORDER BY id DESC LIMIT 1", 0, 0))))
    End If
    If furnitureId <= 0 Then GoTo ScoreboardDone

    productSprite = LCase$(CStr(Proc_8_12_806C30(productId, 17, 0)))
    If Len(productSprite) = 0 Then productSprite = LCase$(CStr(Proc_8_12_806C30(productId, 18, 0)))

    If Left$(productSprite, 9) = "bb_score_" Or Left$(productSprite, 9) = "es_score_" Then
        stateValue = CLng(Val(signText))
        maxState = CLng(Val(CStr(Proc_8_12_806C30(productId, 12, 0))))
        If maxState <= 0 Then maxState = 99
        If stateValue < 0 Then stateValue = 0
        If stateValue > maxState Then stateValue = maxState

        If CStr(stateValue) <> signText Then
            Proc_5_0_6D3CD0 "UPDATE furnitures SET sign='" & CStr(stateValue) & "' WHERE id='" & CStr(furnitureId) & "' LIMIT 1", 0, 0
        End If
    End If

    Proc_6_160_7A71A0 = Proc_6_154_78F040(furnitureId, productId)
    Exit Function

ScoreboardDone:
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
    Dim socketIndex As Integer
    Dim userId As String
    Dim questId As Long
    Dim numericQuestId As Long
    Dim activeRow As String
    Dim activeFields() As String
    Dim questRows() As String
    Dim questFields() As String
    Dim questRow As String
    Dim questIndex As Long
    Dim questName As String
    Dim rewardAmount As Long
    Dim rewardType As Long
    Dim campaignId As Long
    Dim activityCount As Long
    Dim progressValue As Long
    Dim userQuestLevel As Long
    Dim campaignLevelCount As Long
    Dim matchedQuest As Boolean
    Dim completionPayload As String
    Dim currentPoints As Long
    Dim newPoints As Long
    Dim pointColumn As String

    On Error GoTo QuestCompleteFailed

    socketIndex = HandlingSocketIndex(args)
    userId = HandlingUserIdFromSocket(socketIndex)
    If Len(userId) = 0 Or userId = "0" Then GoTo QuestCompleteFailed

    If UBound(args) >= 1 Then questId = CLng(Val(CStr(args(1))))
    If UBound(args) >= 2 Then numericQuestId = CLng(Val(CStr(args(2))))

    If questId <= 0 Then
        activeRow = CStr(Proc_5_2_6D4690("SELECT id_quest,id_numericquest,progress,id_level FROM users_quests WHERE id_user='" & _
            Proc_10_11_80A9C0(userId, 0, 0) & "' AND timestamp_accepted IS NOT NULL AND timestamp_done IS NULL LIMIT 1", 0, 0))
    Else
        activeRow = CStr(Proc_5_2_6D4690("SELECT id_quest,id_numericquest,progress,id_level FROM users_quests WHERE id_user='" & _
            Proc_10_11_80A9C0(userId, 0, 0) & "' AND id_quest='" & CStr(questId) & "' LIMIT 1", 0, 0))
    End If
    If Len(activeRow) = 0 Then GoTo QuestCompleteFailed

    activeFields = Split(activeRow, Chr$(9))
    questId = CLng(Val(HandlingField(activeFields, 0)))
    If numericQuestId <= 0 Then numericQuestId = CLng(Val(HandlingField(activeFields, 1)))
    progressValue = CLng(Val(HandlingField(activeFields, 2)))
    userQuestLevel = CLng(Val(HandlingField(activeFields, 3)))
    If questId <= 0 Then GoTo QuestCompleteFailed

    If Len(global_00829080) > 0 Then
        questRows = Split(global_00829080, Chr$(13))
    Else
        questRows = Split(CStr(Proc_5_2_6D4690("SELECT id,level,name,NULL,reward,reward_type,require_action,id_additional,id_campaign,amount_activities,waitamount FROM quests ORDER BY id_campaign DESC,level ASC", 0, 0)), Chr$(13))
    End If

    For questIndex = LBound(questRows) To UBound(questRows)
        questRow = Trim$(CStr(questRows(questIndex)))
        If Len(questRow) > 0 Then
            questFields = Split(questRow, Chr$(9))
            If UBound(questFields) >= 10 Then
                If CLng(Val(HandlingField(questFields, 0))) = questId Then
                    questName = HandlingField(questFields, 2)
                    rewardAmount = CLng(Val(HandlingField(questFields, 4)))
                    rewardType = CLng(Val(HandlingField(questFields, 5)))
                    campaignId = CLng(Val(HandlingField(questFields, 8)))
                    activityCount = CLng(Val(HandlingField(questFields, 9)))
                    matchedQuest = True
                End If
            End If
        End If
    Next questIndex
    If Not matchedQuest Then GoTo QuestCompleteFailed
    For questIndex = LBound(questRows) To UBound(questRows)
        questRow = Trim$(CStr(questRows(questIndex)))
        If Len(questRow) > 0 Then
            questFields = Split(questRow, Chr$(9))
            If UBound(questFields) >= 8 Then
                If CLng(Val(HandlingField(questFields, 8))) = campaignId Then campaignLevelCount = campaignLevelCount + 1
            End If
        End If
    Next questIndex
    If activityCount <= 0 Then activityCount = 1

    completionPayload = CStr(Proc_3_0_6D2AF0(campaignId, Empty, vbNullString)) & questName & Chr$(2)
    completionPayload = completionPayload & CStr(Proc_3_0_6D2AF0(campaignLevelCount, Empty, vbNullString))
    completionPayload = completionPayload & CStr(Proc_3_0_6D2AF0(questId, Empty, vbNullString))
    completionPayload = completionPayload & CStr(Proc_3_0_6D2AF0(userQuestLevel, Empty, vbNullString))
    completionPayload = completionPayload & CStr(Proc_3_0_6D2AF0(progressValue, Empty, vbNullString))
    completionPayload = completionPayload & CStr(Proc_3_0_6D2AF0(activityCount, Empty, vbNullString))
    completionPayload = completionPayload & CStr(Proc_3_0_6D2AF0(0, Empty, vbNullString))

    Proc_6_244_801E80 socketIndex, "Lb" & completionPayload, 0
    If progressValue < activityCount Then GoTo QuestCompleteFailed

    If rewardAmount <> 0 Then
        If rewardType >= 0 And rewardType <= 20 Then
            pointColumn = "activitypoints_" & CStr(rewardType)
            currentPoints = CLng(Val(CStr(Proc_5_2_6D4690("SELECT " & pointColumn & " FROM users WHERE id='" & _
                Proc_10_11_80A9C0(userId, 0, 0) & "' LIMIT 1", 0, 0))))
            Proc_5_0_6D3CD0 "UPDATE users SET " & pointColumn & "=" & pointColumn & "+" & CStr(rewardAmount) & _
                " WHERE id='" & Proc_10_11_80A9C0(userId, 0, 0) & "' LIMIT 1", 0, 0
            newPoints = currentPoints + rewardAmount
            Proc_6_244_801E80 socketIndex, RepresentedActivityPointAwardPayload(rewardType, newPoints), 0
        End If
    End If

    Proc_5_0_6D3CD0 "UPDATE users_quests SET id_level=id_level+1,progress='0',id_numericquest='0',timestamp_done=UNIX_TIMESTAMP() WHERE id_user='" & _
        Proc_10_11_80A9C0(userId, 0, 0) & "' AND id_quest='" & CStr(questId) & "' LIMIT 1", 0, 0
    Proc_6_244_801E80 socketIndex, "La" & completionPayload, 0
    Proc_6_236_7F8540 socketIndex, Empty, Empty

QuestCompleteFailed:
    Proc_6_164_7BC820 = Empty
End Function

' Original declaration: Private Sub Proc_6_165_7BE0B0
Public Function Proc_6_165_7BE0B0(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim userId As String
    Dim targetSocketIndex As Integer
    Dim rowText As String
    Dim rows As Variant
    Dim fields As Variant
    Dim rowIndex As Long
    Dim summaryPayload As String
    Dim notifyPayload As String

    On Error GoTo NotifyFailed

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 1 Then targetSocketIndex = CInt(Val(CStr(args(1))))

    userId = HandlingUserIdFromSocket(socketIndex)
    If Len(userId) = 0 Or userId = "0" Then GoTo NotifyFailed

    summaryPayload = MessengerFriendSummaryPayload(userId, 1)
    If Len(summaryPayload) = 0 Then GoTo NotifyFailed
    notifyPayload = "@MHIH" & summaryPayload

    If targetSocketIndex > 0 Then
        If Proc_11_2_821390(targetSocketIndex, 0, 0) = 1 Then
            Proc_6_244_801E80 targetSocketIndex, notifyPayload, 0
        End If
    Else
        rowText = CStr(Proc_5_2_6D4690("SELECT users.id_socket FROM friendships,users WHERE friendships.has_accept='1' AND friendships.id_user='" & _
            Proc_10_11_80A9C0(userId, 0, 0) & "' AND users.id=friendships.id_friend AND users.id_socket>'0'", 0, 0))
        rows = Split(rowText, Chr$(13))
        For rowIndex = LBound(rows) To UBound(rows)
            If Len(CStr(rows(rowIndex))) > 0 Then
                fields = Split(CStr(rows(rowIndex)), Chr$(9))
                If UBound(fields) >= 0 Then
                    targetSocketIndex = CInt(Val(CStr(fields(0))))
                    If targetSocketIndex > 0 Then
                        If Proc_11_2_821390(targetSocketIndex, 0, 0) = 1 Then
                            Proc_6_244_801E80 targetSocketIndex, notifyPayload, 0
                        End If
                    End If
                End If
            End If
        Next rowIndex
    End If

    Proc_6_165_7BE0B0 = notifyPayload
    Exit Function

NotifyFailed:
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
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim requestPayload As String
    Dim userId As String
    Dim acceptCount As Long
    Dim acceptIndex As Long
    Dim acceptedCount As Long
    Dim targetUserId As String
    Dim targetSocketIndex As Integer
    Dim targetIds As String
    Dim targetParts As Variant
    Dim rowText As String
    Dim fields As Variant
    Dim offset As Long
    Dim payloadRows As String
    Dim callerPayload As String
    Dim notifyPayload As String
    Dim dateFormat As String
    Dim timeFormat As String

    On Error GoTo AcceptFailed

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    If Len(packetPayload) = 0 And UBound(args) >= 1 Then packetPayload = CStr(args(1))

    requestPayload = packetPayload
    If Left$(requestPayload, 2) = "@e" Then requestPayload = Mid$(requestPayload, 3)

    userId = HandlingUserIdFromSocket(socketIndex)
    If Len(userId) = 0 Or userId = "0" Then GoTo AcceptFailed

    offset = 1
    acceptCount = ReadWireLong(requestPayload, offset)
    If acceptCount <= 0 Then GoTo AcceptFailed
    If acceptCount > 75 Then acceptCount = 75

    dateFormat = CStr(Proc_10_0_809570("com.mysql.format.date", "%d-%m-%Y", 0))
    timeFormat = CStr(Proc_10_0_809570("com.mysql.format.time", "%H:%i", 0))

    For acceptIndex = 1 To acceptCount
        targetUserId = CStr(ReadWireLong(requestPayload, offset))
        If Len(targetUserId) > 0 And targetUserId <> "0" Then
            If InStr(1, "," & targetIds & ",", "," & targetUserId & ",", vbBinaryCompare) = 0 Then
                rowText = CStr(Proc_5_2_6D4690("SELECT users.id,users.name,users.motto,users.figure,users.level,users.id_socket,DATE_FORMAT(FROM_UNIXTIME(users.lastonline_time), '" & _
                    Proc_10_11_80A9C0(dateFormat & " " & timeFormat, 0, 0) & "') FROM users,friendships WHERE friendships.has_accept='0' AND friendships.id_user='" & _
                    Proc_10_11_80A9C0(userId, 0, 0) & "' AND friendships.id_friend='" & Proc_10_11_80A9C0(targetUserId, 0, 0) & "' AND users.id=friendships.id_friend LIMIT 1", 0, 0))
                If Len(rowText) > 0 Then
                    If Len(targetIds) > 0 Then targetIds = targetIds & ","
                    targetIds = targetIds & targetUserId
                End If
            End If
        End If
    Next acceptIndex

    If Len(targetIds) = 0 Then GoTo AcceptFailed
    targetParts = Split(targetIds, ",")

    For acceptIndex = LBound(targetParts) To UBound(targetParts)
        targetUserId = CStr(targetParts(acceptIndex))
        rowText = CStr(Proc_5_2_6D4690("SELECT id,name,motto,figure,level,id_socket,DATE_FORMAT(FROM_UNIXTIME(lastonline_time), '" & _
            Proc_10_11_80A9C0(dateFormat & " " & timeFormat, 0, 0) & "') FROM users WHERE id='" & Proc_10_11_80A9C0(targetUserId, 0, 0) & "' LIMIT 1", 0, 0))
        If Len(rowText) > 0 Then
            fields = Split(rowText, Chr$(9))
            If UBound(fields) >= 6 Then
                targetSocketIndex = CInt(Val(CStr(fields(5))))
                payloadRows = payloadRows & "H" & CStr(Proc_6_166_7BE940(CLng(Val(CStr(fields(0)))), CStr(fields(1)), CStr(fields(2)), CStr(fields(3)), _
                    CLng(Val(CStr(fields(4)))), IIf(targetSocketIndex > 0, 2, 0), IIf(targetSocketIndex > 0, 1, 0), CStr(fields(6)), 0))

                Proc_5_0_6D3CD0 "INSERT IGNORE INTO friendships(id_user,id_friend,has_accept) VALUES('" & Proc_10_11_80A9C0(targetUserId, 0, 0) & "','" & Proc_10_11_80A9C0(userId, 0, 0) & "','0')", 0, 0
                Proc_5_0_6D3CD0 "UPDATE friendships SET has_accept='1' WHERE ((id_user='" & Proc_10_11_80A9C0(userId, 0, 0) & "' AND id_friend='" & Proc_10_11_80A9C0(targetUserId, 0, 0) & "') OR (id_user='" & Proc_10_11_80A9C0(targetUserId, 0, 0) & "' AND id_friend='" & Proc_10_11_80A9C0(userId, 0, 0) & "')) AND has_accept='0' LIMIT 2", 0, 0

                If targetSocketIndex > 0 Then
                    notifyPayload = "@MHIH" & CStr(MessengerFriendSummaryPayload(userId, 1))
                    Proc_6_244_801E80 targetSocketIndex, notifyPayload, 0
                End If
                acceptedCount = acceptedCount + 1
            End If
        End If
    Next acceptIndex

    If acceptedCount > 0 Then
        callerPayload = CStr(Proc_3_0_6D2AF0(acceptedCount, Empty, "@MH")) & payloadRows
        Proc_6_244_801E80 socketIndex, callerPayload, 0
        Proc_6_167_7BECA0 = callerPayload
        Exit Function
    End If

AcceptFailed:
    Proc_6_167_7BECA0 = Empty
End Function

' Original declaration: Private Sub Proc_6_168_7C05F0
Public Function Proc_6_168_7C05F0(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim requestPayload As String
    Dim userId As String
    Dim roomId As Long
    Dim targetCount As Long
    Dim targetIndex As Long
    Dim targetUserId As String
    Dim targetSocketIndex As Integer
    Dim targetList As String
    Dim targetIds As Variant
    Dim inviteText As String
    Dim filteredText As String
    Dim payload As String
    Dim offset As Long
    Dim friendshipRow As String

    On Error GoTo InviteFailed

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    If Len(packetPayload) = 0 And UBound(args) >= 1 Then packetPayload = CStr(args(1))

    requestPayload = packetPayload
    If Left$(requestPayload, 2) = "@b" Then requestPayload = Mid$(requestPayload, 3)

    userId = HandlingUserIdFromSocket(socketIndex)
    If Len(userId) = 0 Or userId = "0" Then GoTo InviteFailed

    roomId = HandlingCurrentRoomId(socketIndex, userId)
    If roomId <= 0 Then GoTo InviteFailed

    offset = 1
    targetCount = ReadWireLong(requestPayload, offset)
    If targetCount <= 0 Then GoTo InviteFailed
    If targetCount > 150 Then targetCount = 150

    For targetIndex = 1 To targetCount
        targetUserId = CStr(ReadWireLong(requestPayload, offset))
        If Len(targetUserId) > 0 And targetUserId <> "0" Then
            If InStr(1, "," & targetList & ",", "," & targetUserId & ",", vbBinaryCompare) = 0 Then
                friendshipRow = CStr(Proc_5_2_6D4690("SELECT id_user FROM friendships WHERE has_accept='1' AND ((id_user='" & _
                    Proc_10_11_80A9C0(userId, 0, 0) & "' AND id_friend='" & Proc_10_11_80A9C0(targetUserId, 0, 0) & "') OR (id_user='" & _
                    Proc_10_11_80A9C0(targetUserId, 0, 0) & "' AND id_friend='" & Proc_10_11_80A9C0(userId, 0, 0) & "')) LIMIT 1", 0, 0))
                If Len(friendshipRow) > 0 Then
                    targetSocketIndex = HandlingSocketFromUserId(targetUserId)
                    If targetSocketIndex > 0 Then
                        If Len(targetList) > 0 Then targetList = targetList & ","
                        targetList = targetList & targetUserId
                    End If
                End If
            End If
        End If
    Next targetIndex

    inviteText = Mid$(CStr(Proc_10_7_80A190(requestPayload, 0, 0)), 1, 122)
    If Len(inviteText) = 0 Then inviteText = Mid$(ReadWireString(requestPayload, offset), 1, 122)
    filteredText = CStr(Proc_6_22_6E9300(inviteText, 0, 0))
    payload = CStr(Proc_3_0_6D2AF0(CLng(Val(userId)), Empty, "BG")) & filteredText & Chr$(2)

    If Len(targetList) > 0 Then
        targetIds = Split(targetList, ",")
        For targetIndex = LBound(targetIds) To UBound(targetIds)
            targetUserId = CStr(targetIds(targetIndex))
            targetSocketIndex = HandlingSocketFromUserId(targetUserId)
            If targetSocketIndex > 0 Then
                Proc_6_244_801E80 targetSocketIndex, payload, 0
                Proc_5_1_6D4110 "INSERT INTO logs_chat(id_user,id_room,timestamp,description,id_type,id_session) VALUES('" & _
                    Proc_10_11_80A9C0(userId, 0, 0) & "','" & CStr(roomId) & "',UNIX_TIMESTAMP(),'" & _
                    Proc_10_11_80A9C0("(Invite To: " & CStr(HandlingUserName(targetUserId)) & ") -- " & inviteText, 0, 0) & "','4','" & CStr(socketIndex) & "')", 0, 0
            End If
        Next targetIndex
    End If

    Proc_6_168_7C05F0 = payload
    Exit Function

InviteFailed:
    Proc_6_168_7C05F0 = Empty
End Function

' Original declaration: Private Sub Proc_6_169_7C0DC0
Public Function Proc_6_169_7C0DC0(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim requestPayload As String
    Dim userId As String
    Dim targetUserId As String
    Dim targetSocketIndex As Integer
    Dim targetRoomUserIndex As Long
    Dim targetRoomId As Long
    Dim friendshipRow As String
    Dim offset As Long
    Dim payload As String

    On Error GoTo FollowFailed

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    If Len(packetPayload) = 0 And UBound(args) >= 1 Then packetPayload = CStr(args(1))

    requestPayload = packetPayload
    If Left$(requestPayload, 2) = "DF" Then requestPayload = Mid$(requestPayload, 3)

    userId = HandlingUserIdFromSocket(socketIndex)
    If Len(userId) = 0 Or userId = "0" Then GoTo FollowFailed

    offset = 1
    targetUserId = CStr(ReadWireLong(requestPayload, offset))
    If Len(targetUserId) = 0 Or targetUserId = "0" Then targetUserId = CStr(Val(CStr(Proc_10_6_809F10(requestPayload, 0, 0))))
    If Len(targetUserId) = 0 Or targetUserId = "0" Then GoTo FollowFailed

    friendshipRow = CStr(Proc_5_2_6D4690("SELECT id_friend FROM friendships WHERE id_user='" & Proc_10_11_80A9C0(userId, 0, 0) & "' AND id_friend='" & Proc_10_11_80A9C0(targetUserId, 0, 0) & "' AND has_accept='1' LIMIT 1", 0, 0))
    If Len(friendshipRow) = 0 Then GoTo FollowFailed

    targetSocketIndex = HandlingSocketFromUserId(targetUserId)
    If targetSocketIndex <= 0 Then GoTo FollowFailed

    targetRoomId = HandlingCurrentRoomId(targetSocketIndex, targetUserId)
    If targetRoomId <= 0 Then GoTo FollowFailed

    targetRoomUserIndex = RepresentedRoomUserIndex(targetSocketIndex, targetUserId)
    payload = CStr(Proc_3_0_6D2AF0(targetRoomUserIndex, Empty, "D^"))
    payload = CStr(Proc_3_0_6D2AF0(targetRoomId, Empty, payload))

    Proc_6_244_801E80 socketIndex, payload, 0
    Proc_6_169_7C0DC0 = payload
    Exit Function

FollowFailed:
    Proc_6_169_7C0DC0 = Empty
End Function

' Original declaration: Private Sub Proc_6_170_7C1100
Public Function Proc_6_170_7C1100(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim requestPayload As String
    Dim userId As String
    Dim offset As Long
    Dim firstValue As Long
    Dim targetUserId As Long
    Dim targetList As String
    Dim targetCount As Long
    Dim maxTargets As Long
    Dim previousOffset As Long

    On Error GoTo DeleteFailed

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    If Len(packetPayload) = 0 And UBound(args) >= 1 Then packetPayload = CStr(args(1))

    requestPayload = packetPayload
    If Left$(requestPayload, 2) = "@f" Then requestPayload = Mid$(requestPayload, 3)

    userId = HandlingUserIdFromSocket(socketIndex)
    If Len(userId) = 0 Or userId = "0" Then GoTo DeleteFailed

    offset = 1
    firstValue = ReadWireLong(requestPayload, offset)
    If firstValue = 1 Then
        Proc_5_0_6D3CD0 "DELETE FROM friendships WHERE id_user='" & Proc_10_11_80A9C0(userId, 0, 0) & "' AND has_accept='0' LIMIT 75", 0, 0
        Proc_6_170_7C1100 = 1
        Exit Function
    End If

    maxTargets = firstValue
    If maxTargets <= 0 Then maxTargets = 75
    If maxTargets > 75 Then maxTargets = 75

    Do While offset <= Len(requestPayload) And targetCount < maxTargets
        previousOffset = offset
        targetUserId = ReadWireLong(requestPayload, offset)
        If targetUserId <= 0 Or offset = previousOffset Then Exit Do

        If InStr(1, "," & targetList & ",", "," & CStr(targetUserId) & ",", vbBinaryCompare) = 0 Then
            If Len(targetList) > 0 Then targetList = targetList & ","
            targetList = targetList & CStr(targetUserId)
            targetCount = targetCount + 1
        End If
    Loop

    If Len(targetList) = 0 And firstValue > 1 Then targetList = CStr(firstValue)
    If Len(targetList) = 0 Then GoTo DeleteFailed

    Proc_5_0_6D3CD0 "DELETE FROM friendships WHERE id_user='" & Proc_10_11_80A9C0(userId, 0, 0) & "' AND has_accept='0' AND id_friend IN (" & targetList & ") LIMIT 75", 0, 0
    Proc_6_170_7C1100 = 1
    Exit Function

DeleteFailed:
    Proc_6_170_7C1100 = Empty
End Function

' Original declaration: Private Sub Proc_6_171_7C1520
Public Function Proc_6_171_7C1520(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim requestPayload As String
    Dim userId As String
    Dim removeCount As Long
    Dim removeIndex As Long
    Dim removedCount As Long
    Dim targetUserId As Long
    Dim targetSocketIndex As Integer
    Dim targetList As String
    Dim removedIdsPayload As String
    Dim callerPayload As String
    Dim offset As Long

    On Error GoTo RemoveFailed

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    If Len(packetPayload) = 0 And UBound(args) >= 1 Then packetPayload = CStr(args(1))

    requestPayload = packetPayload
    If Left$(requestPayload, 2) = "@h" Then requestPayload = Mid$(requestPayload, 3)

    userId = HandlingUserIdFromSocket(socketIndex)
    If Len(userId) = 0 Or userId = "0" Then GoTo RemoveFailed

    offset = 1
    removeCount = ReadWireLong(requestPayload, offset)
    If removeCount <= 0 Then GoTo RemoveFailed
    If removeCount > 75 Then removeCount = 75

    For removeIndex = 1 To removeCount
        targetUserId = ReadWireLong(requestPayload, offset)
        If targetUserId > 0 And CStr(targetUserId) <> userId Then
            If InStr(1, "," & targetList & ",", "," & CStr(targetUserId) & ",", vbBinaryCompare) = 0 Then
                If Len(CStr(Proc_5_2_6D4690("SELECT id_user FROM friendships WHERE has_accept='1' AND ((id_friend='" & _
                    Proc_10_11_80A9C0(CStr(targetUserId), 0, 0) & "' AND id_user='" & Proc_10_11_80A9C0(userId, 0, 0) & "') OR (id_user='" & _
                    Proc_10_11_80A9C0(CStr(targetUserId), 0, 0) & "' AND id_friend='" & Proc_10_11_80A9C0(userId, 0, 0) & "')) LIMIT 1", 0, 0))) > 0 Then
                    If Len(targetList) > 0 Then targetList = targetList & ","
                    targetList = targetList & CStr(targetUserId)
                    removedIdsPayload = removedIdsPayload & CStr(Proc_3_0_6D2AF0(targetUserId, Empty, vbNullString))
                    removedCount = removedCount + 1

                    targetSocketIndex = HandlingSocketFromUserId(CStr(targetUserId))
                    If targetSocketIndex > 0 Then
                        Proc_6_244_801E80 targetSocketIndex, "@MMIM" & userId, 0
                    End If
                End If
            End If
        End If
    Next removeIndex

    If Len(targetList) = 0 Then GoTo RemoveFailed

    Proc_5_0_6D3CD0 "DELETE FROM friendships WHERE has_accept='1' AND ((id_user='" & Proc_10_11_80A9C0(userId, 0, 0) & "' AND id_friend IN (" & _
        targetList & ")) OR (id_friend='" & Proc_10_11_80A9C0(userId, 0, 0) & "' AND id_user IN (" & targetList & "))) LIMIT 150", 0, 0

    callerPayload = CStr(Proc_3_0_6D2AF0(removedCount, Empty, "@MM")) & removedIdsPayload
    Proc_6_244_801E80 socketIndex, callerPayload, 0
    Proc_6_171_7C1520 = callerPayload
    Exit Function

RemoveFailed:
    Proc_6_171_7C1520 = Empty
End Function

' Original declaration: Private Sub Proc_6_172_7C25B0
Public Function Proc_6_172_7C25B0(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim requestPayload As String
    Dim userId As String
    Dim searchText As String
    Dim escapedSearch As String
    Dim whereClause As String
    Dim rowText As String
    Dim rows As Variant
    Dim fields As Variant
    Dim rowIndex As Long
    Dim friendCount As Long
    Dim otherCount As Long
    Dim friendPayload As String
    Dim otherPayload As String
    Dim resultPayload As String
    Dim targetUserId As String
    Dim isFriend As Boolean
    Dim isOnline As Long
    Dim offset As Long
    Dim dateFormat As String
    Dim timeFormat As String

    On Error GoTo SearchFailed

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    If Len(packetPayload) = 0 And UBound(args) >= 1 Then packetPayload = CStr(args(1))

    requestPayload = packetPayload
    If Left$(requestPayload, 2) = "@i" Then requestPayload = Mid$(requestPayload, 3)

    userId = HandlingUserIdFromSocket(socketIndex)
    If Len(userId) = 0 Or userId = "0" Then GoTo SearchFailed

    searchText = CStr(Proc_10_7_80A190(requestPayload, 0, 0))
    If Len(searchText) = 0 Then
        offset = 1
        searchText = ReadWireString(requestPayload, offset)
    End If
    searchText = LCase$(Trim$(searchText))
    If Len(searchText) = 0 Then GoTo SearchFailed

    escapedSearch = LCase$(Proc_10_11_80A9C0(searchText, 0, 0))
    If Len(searchText) > 3 Then
        whereClause = "LOWER(name) LIKE '" & escapedSearch & "%'"
    Else
        whereClause = "LOWER(name)='" & escapedSearch & "'"
    End If

    dateFormat = CStr(Proc_10_0_809570("com.mysql.format.date", "%d-%m-%Y", 0))
    timeFormat = CStr(Proc_10_0_809570("com.mysql.format.time", "%H:%i", 0))
    rowText = CStr(Proc_5_2_6D4690("SELECT id,name,id_socket,figure,motto,nickname,DATE_FORMAT(FROM_UNIXTIME(lastonline_time), '" & _
        Proc_10_11_80A9C0(dateFormat & " " & timeFormat, 0, 0) & "') FROM users WHERE " & whereClause & " LIMIT 50", 0, 0))

    If Len(rowText) > 0 Then
        rows = Split(rowText, Chr$(13))
        For rowIndex = LBound(rows) To UBound(rows)
            If Len(CStr(rows(rowIndex))) > 0 Then
                fields = Split(CStr(rows(rowIndex)), Chr$(9))
                If UBound(fields) >= 6 Then
                    targetUserId = CStr(fields(0))
                    If targetUserId <> userId Then
                        isOnline = IIf(CInt(Val(CStr(fields(2)))) > 0, 1, 0)
                        resultPayload = MessengerSearchResultPayload(targetUserId, CStr(fields(1)), CStr(fields(3)), CStr(fields(4)), CStr(fields(5)), CStr(fields(6)), isOnline)
                        isFriend = (Len(CStr(Proc_5_2_6D4690("SELECT id_user FROM friendships WHERE has_accept='1' AND ((id_user='" & _
                            Proc_10_11_80A9C0(userId, 0, 0) & "' AND id_friend='" & Proc_10_11_80A9C0(targetUserId, 0, 0) & "') OR (id_user='" & _
                            Proc_10_11_80A9C0(targetUserId, 0, 0) & "' AND id_friend='" & Proc_10_11_80A9C0(userId, 0, 0) & "')) LIMIT 1", 0, 0))) > 0)
                        If isFriend Then
                            friendPayload = friendPayload & resultPayload
                            friendCount = friendCount + 1
                        Else
                            otherPayload = otherPayload & resultPayload
                            otherCount = otherCount + 1
                        End If
                    End If
                End If
            End If
        Next rowIndex
    End If

    resultPayload = CStr(Proc_3_0_6D2AF0(friendCount, Empty, "Fs")) & friendPayload
    resultPayload = resultPayload & CStr(Proc_3_0_6D2AF0(otherCount, Empty, vbNullString)) & otherPayload
    Proc_6_244_801E80 socketIndex, resultPayload, 0

    Proc_6_172_7C25B0 = resultPayload
    Exit Function

SearchFailed:
    Proc_6_172_7C25B0 = Empty
End Function

' Original declaration: Private Sub Proc_6_173_7C3430
Public Function Proc_6_173_7C3430(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim requestPayload As String
    Dim userId As String
    Dim targetUserId As String
    Dim targetSocketIndex As Integer
    Dim messageText As String
    Dim filteredText As String
    Dim currentRoomId As Long
    Dim offset As Long
    Dim payload As String

    On Error GoTo ChatFailed

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    If Len(packetPayload) = 0 And UBound(args) >= 1 Then packetPayload = CStr(args(1))

    requestPayload = packetPayload
    If Left$(requestPayload, 2) = "@a" Then requestPayload = Mid$(requestPayload, 3)

    userId = HandlingUserIdFromSocket(socketIndex)
    If Len(userId) = 0 Or userId = "0" Then GoTo ChatFailed

    offset = 1
    targetUserId = CStr(ReadWireLong(requestPayload, offset))
    If Len(targetUserId) = 0 Or targetUserId = "0" Then targetUserId = CStr(Val(CStr(Proc_10_6_809F10(requestPayload, 0, 0))))
    If Len(targetUserId) = 0 Or targetUserId = "0" Then GoTo ChatFailed

    messageText = Mid$(CStr(Proc_10_7_80A190(requestPayload, 0, 0)), 1, 122)
    If Len(messageText) = 0 Then messageText = Mid$(ReadWireString(requestPayload, offset), 1, 122)
    If Len(messageText) = 0 Or Len(messageText) > 255 Then GoTo ChatFailed

    targetSocketIndex = HandlingSocketFromUserId(targetUserId)
    If targetSocketIndex <= 0 Then GoTo ChatFailed

    currentRoomId = HandlingCurrentRoomId(socketIndex, userId)
    Proc_5_1_6D4110 "INSERT INTO logs_chat(id_user,id_room,timestamp,description,id_type,id_session) VALUES('" & _
        Proc_10_11_80A9C0(userId, 0, 0) & "','" & CStr(currentRoomId) & "',UNIX_TIMESTAMP(),'" & _
        Proc_10_11_80A9C0("(Chat To:     " & CStr(HandlingUserName(targetUserId)) & ") -- " & messageText, 0, 0) & "','3','" & CStr(socketIndex) & "')", 0, 0

    filteredText = CStr(Proc_6_22_6E9300(messageText, 0, 0))
    payload = CStr(Proc_3_0_6D2AF0(CLng(Val(userId)), Empty, "BF")) & filteredText & Chr$(2)
    Proc_6_244_801E80 targetSocketIndex, payload, 0

    Proc_6_173_7C3430 = payload
    Exit Function

ChatFailed:
    Proc_6_173_7C3430 = Empty
End Function

' Original declaration: Private Sub Proc_6_174_7C3BC0
Public Function Proc_6_174_7C3BC0(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim requestPayload As String
    Dim userId As String
    Dim userName As String
    Dim targetName As String
    Dim targetUserId As String
    Dim targetSocketIndex As Integer
    Dim acceptFriends As Long
    Dim friendshipRow As String
    Dim offset As Long
    Dim callerPayload As String
    Dim targetPayload As String

    On Error GoTo RequestFailed

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    If Len(packetPayload) = 0 And UBound(args) >= 1 Then packetPayload = CStr(args(1))

    requestPayload = packetPayload
    If Left$(requestPayload, 2) = "@g" Then requestPayload = Mid$(requestPayload, 3)

    userId = HandlingUserIdFromSocket(socketIndex)
    If Len(userId) = 0 Or userId = "0" Then GoTo RequestFailed

    targetName = CStr(Proc_10_7_80A190(requestPayload, 0, 0))
    If Len(targetName) = 0 Then
        offset = 1
        targetName = ReadWireString(requestPayload, offset)
    End If
    targetName = Trim$(targetName)
    If Len(targetName) = 0 Then GoTo RequestFailed

    targetUserId = CStr(Val(CStr(Proc_5_2_6D4690("SELECT id FROM users WHERE name='" & Proc_10_11_80A9C0(targetName, 0, 0) & "' LIMIT 1", 0, 0))))
    If Len(targetUserId) = 0 Or targetUserId = "0" Or targetUserId = userId Then GoTo RequestDenied

    friendshipRow = CStr(Proc_5_2_6D4690("SELECT id_user FROM friendships WHERE (id_user='" & Proc_10_11_80A9C0(userId, 0, 0) & "' AND id_friend='" & Proc_10_11_80A9C0(targetUserId, 0, 0) & "') OR (id_user='" & Proc_10_11_80A9C0(targetUserId, 0, 0) & "' AND id_friend='" & Proc_10_11_80A9C0(userId, 0, 0) & "') LIMIT 1", 0, 0))
    If Len(friendshipRow) > 0 Then GoTo RequestDenied

    acceptFriends = CLng(Val(CStr(Proc_5_2_6D4690("SELECT accept_friends FROM users WHERE id='" & Proc_10_11_80A9C0(targetUserId, 0, 0) & "' LIMIT 1", 0, 0))))
    If acceptFriends <> 1 Then GoTo RequestDenied

    Proc_5_0_6D3CD0 "INSERT IGNORE INTO friendships(id_user,id_friend) VALUES('" & Proc_10_11_80A9C0(targetUserId, 0, 0) & "','" & Proc_10_11_80A9C0(userId, 0, 0) & "')", 0, 0

    userName = HandlingUserName(userId)
    targetSocketIndex = HandlingSocketFromUserId(targetUserId)
    If targetSocketIndex > 0 Then
        targetPayload = CStr(Proc_3_0_6D2AF0(CLng(Val(userId)), Empty, "BD")) & userName & Chr$(2) & CStr(userId) & Chr$(2)
        Proc_6_244_801E80 targetSocketIndex, targetPayload, 0
    End If

    callerPayload = CStr(Proc_3_0_6D2AF0(CLng(Val(targetUserId)), Empty, "DD")) & "H"
    Proc_6_244_801E80 socketIndex, callerPayload, 0
    Proc_6_174_7C3BC0 = callerPayload
    Exit Function

RequestDenied:
    callerPayload = "DDH" & Chr$(2)
    Proc_6_244_801E80 socketIndex, callerPayload, 0
    Proc_6_174_7C3BC0 = callerPayload
    Exit Function

RequestFailed:
    Proc_6_174_7C3BC0 = Empty
End Function

' Original declaration: Private Sub Proc_6_175_7C4800
Public Function Proc_6_175_7C4800(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim userId As String
    Dim rows As Variant
    Dim fields As Variant
    Dim rowIndex As Long
    Dim requestCount As Long
    Dim requestPayload As String
    Dim requesterId As Long
    Dim requesterName As String
    Dim payload As String

    On Error GoTo PendingFailed

    socketIndex = HandlingSocketIndex(args)
    userId = HandlingUserIdFromSocket(socketIndex)
    If Len(userId) = 0 Or userId = "0" Then GoTo PendingFailed

    rows = Split(CStr(Proc_5_2_6D4690("SELECT users.id,users.name FROM users,friendships WHERE friendships.has_accept='0' AND friendships.id_user='" & _
        Proc_10_11_80A9C0(userId, 0, 0) & "' AND users.id=friendships.id_friend LIMIT 50", 0, 0)), Chr$(13))

    For rowIndex = LBound(rows) To UBound(rows)
        If Len(CStr(rows(rowIndex))) > 0 Then
            fields = Split(CStr(rows(rowIndex)), Chr$(9))
            If UBound(fields) >= 1 Then
                requesterId = CLng(Val(CStr(fields(0))))
                requesterName = CStr(fields(1))
                If requesterId > 0 Then
                    requestPayload = requestPayload & "0" & CStr(Proc_3_0_6D2AF0(requesterId, Empty, vbNullString))
                    requestPayload = requestPayload & requesterName & Chr$(2) & requesterName & Chr$(2)
                    requestCount = requestCount + 1
                End If
            End If
        End If
    Next rowIndex

    payload = CStr(Proc_3_0_6D2AF0(requestCount, Empty, "Dz"))
    payload = payload & CStr(Proc_3_0_6D2AF0(requestCount, Empty, "Dz"))
    payload = CStr(Proc_3_0_6D2AF0(requestCount, Empty, payload)) & requestPayload
    Proc_6_244_801E80 socketIndex, payload, 0

    Proc_6_175_7C4800 = payload
    Exit Function

PendingFailed:
    Proc_6_175_7C4800 = Empty
End Function

' Original declaration: Private Sub Proc_6_176_7C4EE0
Public Function Proc_6_176_7C4EE0(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim userId As String
    Dim rows As Variant
    Dim fields As Variant
    Dim rowIndex As Long
    Dim friendCount As Long
    Dim friendPayload As String
    Dim payload As String
    Dim dateFormat As String
    Dim timeFormat As String
    Dim maxFriends0 As Long
    Dim maxFriends1 As Long
    Dim maxFriends2 As Long
    Dim queryLimit As Long
    Dim friendUserId As String
    Dim friendSocketIndex As Integer
    Dim friendOnline As Long
    Dim callerSummary As String

    On Error GoTo ListFailed

    socketIndex = HandlingSocketIndex(args)
    userId = HandlingUserIdFromSocket(socketIndex)
    If Len(userId) = 0 Or userId = "0" Then GoTo ListFailed

    maxFriends0 = MessengerMaxFriends(0)
    maxFriends1 = MessengerMaxFriends(2)
    maxFriends2 = MessengerMaxFriends(4)
    queryLimit = maxFriends2
    If queryLimit <= 0 Then queryLimit = 200

    dateFormat = CStr(Proc_10_0_809570("com.mysql.format.date", "%d-%m-%Y", 0))
    timeFormat = CStr(Proc_10_0_809570("com.mysql.format.time", "%H:%i", 0))
    rows = Split(CStr(Proc_5_2_6D4690("SELECT users.id,users.name,users.id_socket,users.figure,users.motto,users.level,DATE_FORMAT(FROM_UNIXTIME(users.lastonline_time), '" & _
        Proc_10_11_80A9C0(dateFormat & " " & timeFormat, 0, 0) & "') FROM friendships,users WHERE friendships.has_accept='1' AND friendships.id_user='" & _
        Proc_10_11_80A9C0(userId, 0, 0) & "' AND users.id=friendships.id_friend LIMIT " & CStr(queryLimit), 0, 0)), Chr$(13))

    callerSummary = MessengerFriendSummaryPayload(userId, 1)

    For rowIndex = LBound(rows) To UBound(rows)
        If Len(CStr(rows(rowIndex))) > 0 Then
            fields = Split(CStr(rows(rowIndex)), Chr$(9))
            If UBound(fields) >= 6 Then
                friendUserId = CStr(fields(0))
                friendSocketIndex = CInt(Val(CStr(fields(2))))
                friendOnline = IIf(friendSocketIndex > 0 And Proc_11_2_821390(friendSocketIndex, 0, 0) = 1, 1, 0)
                friendPayload = friendPayload & CStr(Proc_6_166_7BE940(CLng(Val(friendUserId)), CStr(fields(1)), CStr(fields(4)), CStr(fields(3)), _
                    CLng(Val(CStr(fields(5)))), IIf(friendOnline = 1, 2, 0), friendOnline, CStr(fields(6)), 1))
                friendCount = friendCount + 1

                If friendOnline = 1 And Len(callerSummary) > 0 Then
                    Proc_6_244_801E80 friendSocketIndex, "@MHIH" & callerSummary, 0
                End If
            End If
        End If
    Next rowIndex

    payload = CStr(Proc_3_0_6D2AF0(maxFriends0, Empty, "@L"))
    payload = payload & CStr(Proc_3_0_6D2AF0(maxFriends1, Empty, vbNullString))
    payload = payload & CStr(Proc_3_0_6D2AF0(maxFriends2, Empty, vbNullString))
    payload = payload & CStr(Proc_3_0_6D2AF0(friendCount, Empty, vbNullString)) & friendPayload & "PYH"
    Proc_6_244_801E80 socketIndex, payload, 0

    Proc_6_176_7C4EE0 = payload
    Exit Function

ListFailed:
    Proc_6_176_7C4EE0 = Empty
End Function

' Original declaration: Private Sub Proc_6_177_7C6580
Public Function Proc_6_177_7C6580(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim requestPayload As String
    Dim userId As String
    Dim productPet As String
    Dim rankIndex As Long
    Dim hcLevel As Long
    Dim rows As Variant
    Dim fields As Variant
    Dim rowIndex As Long
    Dim raceCount As Long
    Dim racePayload As String
    Dim payload As String
    Dim breedId As Long
    Dim minRank As Long
    Dim minHcRank As Long

    On Error GoTo RaceListFailed

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    If Len(packetPayload) = 0 And UBound(args) >= 1 Then packetPayload = CStr(args(1))

    requestPayload = packetPayload
    If Left$(requestPayload, 2) = "n" & Chr$(127) Then requestPayload = Mid$(requestPayload, 3)

    userId = HandlingUserIdFromSocket(socketIndex)
    If Len(userId) = 0 Or userId = "0" Then GoTo RaceListFailed

    productPet = CStr(Proc_10_7_80A190(requestPayload, 0, 0))
    If Len(productPet) = 0 Then productPet = ReadWireString(requestPayload, 1)
    If Len(productPet) = 0 Then GoTo RaceListFailed

    rankIndex = HandlingUserRank(userId)
    hcLevel = HandlingUserHcLevel(userId)

    rows = Split(CStr(Proc_5_2_6D4690("SELECT id_pet,breed,min_rank,min_hcrank,name FROM settings_petraces WHERE product_pet='" & _
        Proc_10_11_80A9C0(productPet, 0, 0) & "' ORDER BY breed ASC", 0, 0)), Chr$(13))

    For rowIndex = LBound(rows) To UBound(rows)
        If Len(CStr(rows(rowIndex))) > 0 Then
            fields = Split(CStr(rows(rowIndex)), Chr$(9))
            If UBound(fields) >= 3 Then
                breedId = CLng(Val(CStr(fields(1))))
                minRank = CLng(Val(CStr(fields(2))))
                minHcRank = CLng(Val(CStr(fields(3))))
                If rankIndex >= minRank And hcLevel >= minHcRank Then
                    racePayload = racePayload & CStr(Proc_3_0_6D2AF0(breedId, Empty, vbNullString)) & "II"
                    raceCount = raceCount + 1
                End If
            End If
        End If
    Next rowIndex

    payload = CStr(Proc_3_0_6D2AF0(raceCount, Empty, "L{" & productPet & Chr$(2))) & racePayload
    Proc_6_244_801E80 socketIndex, payload, 0

    Proc_6_177_7C6580 = payload
    Exit Function

RaceListFailed:
    Proc_6_177_7C6580 = Empty
End Function

' Original declaration: Private Sub Proc_6_178_7C6E60
Public Function Proc_6_178_7C6E60(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim userId As String
    Dim rows As Variant
    Dim fields As Variant
    Dim figureParts As Variant
    Dim rowIndex As Long
    Dim petCount As Long
    Dim petPayload As String
    Dim payload As String
    Dim petId As Long
    Dim petName As String
    Dim petFigure As String
    Dim petType As Long
    Dim petRace As Long
    Dim petColor As String
    Dim scratches As Long

    On Error GoTo PetListFailed

    socketIndex = HandlingSocketIndex(args)
    userId = HandlingUserIdFromSocket(socketIndex)
    If Len(userId) = 0 Or userId = "0" Then GoTo PetListFailed

    rows = Split(CStr(Proc_5_2_6D4690("SELECT bots.id,bots.name,bots.figure,bots_petdata.scratches FROM bots,bots_petdata WHERE bots.id_user='" & _
        Proc_10_11_80A9C0(userId, 0, 0) & "' AND bots.id_handle='3' AND bots.id_room IS NULL AND bots_petdata.id_bot=bots.id", 0, 0)), Chr$(13))

    For rowIndex = LBound(rows) To UBound(rows)
        If Len(CStr(rows(rowIndex))) > 0 Then
            fields = Split(CStr(rows(rowIndex)), Chr$(9))
            If UBound(fields) >= 3 Then
                petId = CLng(Val(CStr(fields(0))))
                petName = CStr(fields(1))
                petFigure = LCase$(CStr(fields(2)))
                scratches = CLng(Val(CStr(fields(3))))

                figureParts = Split(petFigure, Chr$(32))
                petType = 0
                petRace = 0
                petColor = vbNullString
                If UBound(figureParts) >= 0 Then petType = CLng(Val(CStr(figureParts(0))))
                If UBound(figureParts) >= 1 Then petRace = CLng(Val(CStr(figureParts(1))))
                If UBound(figureParts) >= 2 Then petColor = CStr(figureParts(2))

                petPayload = petPayload & "0" & CStr(Proc_3_0_6D2AF0(petId, Empty, vbNullString)) & petName & Chr$(2)
                petPayload = petPayload & CStr(Proc_3_0_6D2AF0(petType, Empty, vbNullString))
                petPayload = petPayload & CStr(Proc_3_0_6D2AF0(petRace, Empty, vbNullString))
                petPayload = petPayload & "0" & petColor & Chr$(2)
                petPayload = petPayload & CStr(Proc_3_0_6D2AF0(scratches, Empty, vbNullString))
                petCount = petCount + 1
            End If
        End If
    Next rowIndex

    payload = CStr(Proc_3_0_6D2AF0(petCount, Empty, "IX")) & petPayload
    Proc_6_244_801E80 socketIndex, payload, 0

    Proc_6_178_7C6E60 = payload
    Exit Function

PetListFailed:
    Proc_6_178_7C6E60 = Empty
End Function

' Original declaration: Private Sub Proc_6_179_7C7790
Public Function Proc_6_179_7C7790(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim requestPayload As String
    Dim offset As Long
    Dim petId As Long
    Dim positionX As Long
    Dim positionY As Long
    Dim positionR As Long
    Dim userId As String
    Dim roomId As Long
    Dim roomSlot As Long
    Dim botRow As String
    Dim botFields() As String
    Dim botEntityId As Long
    Dim positionZ As String
    Dim placementPayload As String

    On Error GoTo PlaceFailed

    If CLng(Val(CStr(Proc_10_0_809570("com.client.rooms.bots.pets.enabled", "0", 0)))) = 0 Then GoTo PlaceFailed

    socketIndex = HandlingSocketIndex(args)
    If socketIndex <= 0 Then GoTo PlaceFailed
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    If Len(packetPayload) = 0 And UBound(args) >= 1 Then packetPayload = CStr(args(1))

    requestPayload = packetPayload
    If Left$(requestPayload, 2) = "nz" Then requestPayload = Mid$(requestPayload, 3)

    offset = 1
    petId = ReadWireLong(requestPayload, offset)
    positionX = ReadWireLong(requestPayload, offset)
    positionY = ReadWireLong(requestPayload, offset)
    positionR = ReadWireLong(requestPayload, offset)
    If petId <= 0 Then GoTo PlaceFailed

    userId = HandlingUserIdFromSocket(socketIndex)
    If Len(userId) = 0 Or userId = "0" Then GoTo PlaceFailed

    roomId = HandlingCurrentRoomId(socketIndex, userId)
    If roomId <= 0 Then GoTo PlaceFailed

    roomSlot = CLng(Val(CStr(Proc_5_2_6D4690("SELECT id_slot FROM rooms WHERE id='" & CStr(roomId) & "' LIMIT 1", 0, 0))))
    If roomSlot <= 0 Then GoTo PlaceFailed

    positionZ = CStr(Val(CStr(Proc_5_2_6D4690("SELECT heightmap FROM models,rooms WHERE rooms.id='" & CStr(roomId) & _
        "' AND models.id=rooms.id_model LIMIT 1", 0, 0))))

    botRow = CStr(Proc_5_2_6D4690("SELECT bots.id,bots.name,bots.motto,bots.speech,bots.responses,'" & _
        CStr(positionX) & "','" & CStr(positionY) & "','" & Proc_10_11_80A9C0(positionZ, 0, 0) & "','" & _
        CStr(positionR) & "',bots.figure,NULL,bots.id_handle,bots.id_handleaction,NULL,bots.speech_submit,bots.allow_walk,bots.max_fields_away FROM bots,bots_petdata WHERE bots_petdata.id_bot='" & _
        CStr(petId) & "' AND bots.id=bots_petdata.id_bot AND bots.id_user='" & Proc_10_11_80A9C0(userId, 0, 0) & "' AND bots.id_room IS NULL LIMIT 1", 0, 0))
    If Len(botRow) = 0 Then GoTo PlaceFailed

    botFields = Split(botRow, Chr$(9))
    botEntityId = CLng(Val(CStr(Proc_6_187_7CD700(roomSlot, botFields, 0))))
    If botEntityId <= 0 Then GoTo PlaceFailed

    StoreRepresentedBotPosition botEntityId, positionX, positionY, positionZ, positionR
    Proc_5_0_6D3CD0 "UPDATE bots SET id_room='" & CStr(roomId) & "',position_x='" & CStr(positionX) & _
        "',position_y='" & CStr(positionY) & "',position_z='" & Proc_10_11_80A9C0(positionZ, 0, 0) & _
        "',position_r='" & CStr(positionR) & "' WHERE id='" & CStr(petId) & "'", 0, 0

    placementPayload = RepresentedBotRoomEntryPayload(botEntityId)
    If Len(placementPayload) > 0 Then Proc_6_247_8027E0 socketIndex, placementPayload, 0
    Proc_6_244_801E80 socketIndex, CStr(Proc_3_0_6D2AF0(petId, Empty, "I\")), 0

    Proc_6_179_7C7790 = botEntityId
    Exit Function

PlaceFailed:
    Proc_6_179_7C7790 = 0
End Function

' Original declaration: Private  Proc_6_180_7C96F0(arg_C) '7C96F0
Public Function Proc_6_180_7C96F0(ParamArray args() As Variant) As Variant
    Dim botEntityId As Long
    Dim botId As Long
    Dim petName As String
    Dim petFigure As String
    Dim scratches As Long
    Dim pickupPayload As String

    On Error GoTo PickupFailed

    If UBound(args) >= 1 Then botEntityId = CLng(Val(CStr(args(1))))
    If botEntityId <= 0 Then
        Proc_6_180_7C96F0 = 0
        Exit Function
    End If

    botId = RepresentedBotRecordLong(botEntityId, 1)
    If botId <= 0 Then GoTo PickupFailed

    Proc_5_0_6D3CD0 "UPDATE bots SET id_room=null WHERE id='" & CStr(botId) & "'", 0, 0
    Proc_5_0_6D3CD0 "UPDATE bots_petdata SET id_level=id_level,energy=energy,experience=experience,nutrition=nutrition,scratches=scratches WHERE id_bot='" & CStr(botId) & "'", 0, 0

    Proc_6_247_8027E0 CLng(Val(CStr(args(0)))), "@]" & CStr(botEntityId) & Chr$(2), 0

    petName = RepresentedBotRecordField(botEntityId, 2)
    petFigure = LCase$(RepresentedBotRecordField(botEntityId, 10))
    scratches = CLng(Val(CStr(Proc_5_2_6D4690("SELECT scratches FROM bots_petdata WHERE id_bot='" & CStr(botId) & "' LIMIT 1", 0, 0))))
    pickupPayload = RepresentedPetInventoryRow(botId, petName, petFigure, scratches)
    If Len(pickupPayload) > 0 Then Proc_6_244_801E80 CLng(Val(CStr(args(0)))), "I[" & pickupPayload, 0

    RemoveRepresentedBotRecord botEntityId
    Proc_6_180_7C96F0 = botId
    Exit Function

PickupFailed:
    Proc_6_180_7C96F0 = 0
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
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim requestPayload As String
    Dim offset As Long
    Dim requestedId As Long
    Dim botEntityId As Long
    Dim botId As Long
    Dim userId As String
    Dim petRow As String
    Dim petFields() As String
    Dim payload As String

    On Error GoTo StatusFailed

    socketIndex = HandlingSocketIndex(args)
    If socketIndex <= 0 Then GoTo StatusFailed
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    If Len(packetPayload) = 0 And UBound(args) >= 1 Then packetPayload = CStr(args(1))

    requestPayload = packetPayload
    If Left$(requestPayload, 2) = "ny" Then requestPayload = Mid$(requestPayload, 3)

    offset = 1
    requestedId = ReadWireLong(requestPayload, offset)
    If requestedId <= 0 Then GoTo StatusFailed

    botEntityId = requestedId
    botId = RepresentedBotRecordLong(botEntityId, 1)
    If botId <= 0 Then
        botId = requestedId
        botEntityId = RepresentedBotEntityFromBotId(botId)
    End If
    If botId <= 0 Then GoTo StatusFailed

    userId = HandlingUserIdFromSocket(socketIndex)
    If Len(userId) = 0 Or userId = "0" Then GoTo StatusFailed

    petRow = CStr(Proc_5_2_6D4690("SELECT bots.id,bots.name,bots.figure,bots_petdata.id_level,bots_petdata.experience,bots_petdata.energy,bots_petdata.nutrition,bots_petdata.scratches,ROUND((UNIX_TIMESTAMP()-bots_petdata.timestamp_buy)/60/60/24,0),bots_petdata.id_owner,users.name FROM bots,bots_petdata,users WHERE bots.id='" & _
        CStr(botId) & "' AND bots.id_handle='3' AND bots_petdata.id_bot=bots.id AND users.id=bots_petdata.id_owner LIMIT 1", 0, 0))
    If Len(petRow) = 0 Then GoTo StatusFailed

    petFields = Split(petRow, Chr$(9))
    If UBound(petFields) < 10 Then GoTo StatusFailed
    If botEntityId <= 0 Then botEntityId = botId

    payload = RepresentedPetStatusPayload(botEntityId, petFields)
    If Len(payload) > 0 Then Proc_6_244_801E80 socketIndex, payload, 0

    Proc_6_183_7CABF0 = payload
    Exit Function

StatusFailed:
    Proc_6_183_7CABF0 = Empty
End Function

' Original declaration: Private  Proc_6_184_7CBDA0(arg_C) '7CBDA0
Public Function Proc_6_184_7CBDA0(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim petLevel As Long
    Dim commandIndex As Long
    Dim commandFields() As String
    Dim commandId As Long
    Dim requiredLevel As Long
    Dim allCount As Long
    Dim availableCount As Long
    Dim allPayload As String
    Dim availablePayload As String
    Dim payload As String

    On Error GoTo CommandListFailed

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 1 Then
        petLevel = CLng(Val(CStr(args(1))))
    ElseIf UBound(args) >= 0 Then
        petLevel = CLng(Val(CStr(args(0))))
    End If
    If petLevel < 0 Then petLevel = 0

    If IsArray(global_008292CC) Then
        For commandIndex = LBound(global_008292CC) To UBound(global_008292CC)
            If Len(CStr(global_008292CC(commandIndex))) > 0 Then
                commandFields = Split(CStr(global_008292CC(commandIndex)), Chr$(9))
                If UBound(commandFields) >= 1 Then
                    commandId = CLng(Val(CStr(commandFields(0))))
                    requiredLevel = CLng(Val(CStr(commandFields(1))))
                    If commandId > 0 Then
                        allPayload = allPayload & "0" & CStr(Proc_3_0_6D2AF0(commandId, Empty, vbNullString))
                        allCount = allCount + 1
                        If requiredLevel <= petLevel Then
                            availablePayload = availablePayload & "0" & CStr(Proc_3_0_6D2AF0(commandId, Empty, vbNullString))
                            availableCount = availableCount + 1
                        End If
                    End If
                End If
            End If
        Next commandIndex
    End If

    If allCount = 0 Then
        allPayload = RepresentedPetCommandPayloadFromSql(petLevel, False, allCount)
        availablePayload = RepresentedPetCommandPayloadFromSql(petLevel, True, availableCount)
    End If

    payload = CStr(Proc_3_0_6D2AF0(petLevel, Empty, "I]"))
    payload = payload & CStr(Proc_3_0_6D2AF0(allCount, Empty, vbNullString)) & allPayload
    payload = payload & CStr(Proc_3_0_6D2AF0(availableCount, Empty, vbNullString)) & availablePayload

    If socketIndex > 0 Then Proc_6_244_801E80 socketIndex, payload, 0
    Proc_6_184_7CBDA0 = payload
    Exit Function

CommandListFailed:
    Proc_6_184_7CBDA0 = Empty
End Function

' Original decompiler route target: Proc_7CC190(Me, "n|", packet)
Public Function Proc_7CC190(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim requestPayload As String
    Dim offset As Long
    Dim requestedId As Long
    Dim botId As Long
    Dim petLevel As Long
    Dim userId As String

    On Error GoTo CommandRouteFailed

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    If Len(packetPayload) = 0 And UBound(args) >= 1 Then packetPayload = CStr(args(1))

    requestPayload = packetPayload
    If Left$(requestPayload, 2) = "n|" Then requestPayload = Mid$(requestPayload, 3)

    offset = 1
    requestedId = ReadWireLong(requestPayload, offset)
    botId = RepresentedBotRecordLong(requestedId, 1)
    If botId <= 0 Then botId = requestedId

    userId = HandlingUserIdFromSocket(socketIndex)
    If Len(userId) > 0 And userId <> "0" And botId > 0 Then
        petLevel = CLng(Val(CStr(Proc_5_2_6D4690("SELECT bots_petdata.id_level FROM bots,bots_petdata WHERE bots.id='" & _
            CStr(botId) & "' AND bots.id_user='" & Proc_10_11_80A9C0(userId, 0, 0) & "' AND bots_petdata.id_bot=bots.id LIMIT 1", 0, 0))))
    End If

    Proc_7CC190 = Proc_6_184_7CBDA0(socketIndex, petLevel, 0)
    Exit Function

CommandRouteFailed:
    Proc_7CC190 = Empty
End Function

' Original decompiler route target: Proc_7CA730(Me, "n{", packet)
Public Function Proc_7CA730(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim requestPayload As String
    Dim offset As Long
    Dim requestedId As Long
    Dim commandId As Long
    Dim botEntityId As Long
    Dim botId As Long
    Dim userId As String
    Dim roomId As Long
    Dim petRow As String
    Dim petFields() As String
    Dim petLevel As Long
    Dim petEnergy As Long
    Dim petNutrition As Long
    Dim requiredLevel As Long
    Dim commandAction As String
    Dim commandSpeech As String
    Dim experienceDelta As Long
    Dim payload As String

    On Error GoTo CommandActionFailed

    socketIndex = HandlingSocketIndex(args)
    If socketIndex <= 0 Then GoTo CommandActionFailed
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    If Len(packetPayload) = 0 And UBound(args) >= 1 Then packetPayload = CStr(args(1))

    requestPayload = packetPayload
    If Left$(requestPayload, 2) = "n{" Then requestPayload = Mid$(requestPayload, 3)

    offset = 1
    requestedId = ReadWireLong(requestPayload, offset)
    commandId = ReadWireLong(requestPayload, offset)
    If requestedId <= 0 Or commandId <= 0 Then GoTo CommandActionFailed

    botEntityId = requestedId
    botId = RepresentedBotRecordLong(botEntityId, 1)
    If botId <= 0 Then
        botId = requestedId
        botEntityId = RepresentedBotEntityFromBotId(botId)
    End If
    If botId <= 0 Then GoTo CommandActionFailed

    userId = HandlingUserIdFromSocket(socketIndex)
    If Len(userId) = 0 Or userId = "0" Then GoTo CommandActionFailed
    roomId = HandlingCurrentRoomId(socketIndex, userId)
    If roomId <= 0 Then GoTo CommandActionFailed

    petRow = CStr(Proc_5_2_6D4690("SELECT bots.id,bots.id_room,bots_petdata.id_level,bots_petdata.energy,bots_petdata.nutrition FROM bots,bots_petdata WHERE bots.id='" & _
        CStr(botId) & "' AND bots.id_handle='3' AND bots.id_room='" & CStr(roomId) & "' AND bots_petdata.id_bot=bots.id LIMIT 1", 0, 0))
    If Len(petRow) = 0 Then GoTo CommandActionFailed

    petFields = Split(petRow, Chr$(9))
    If UBound(petFields) < 4 Then GoTo CommandActionFailed
    petLevel = CLng(Val(CStr(petFields(2))))
    petEnergy = CLng(Val(CStr(petFields(3))))
    petNutrition = CLng(Val(CStr(petFields(4))))

    If Not RepresentedPetCommandAction(commandId, requiredLevel, commandAction) Then GoTo CommandActionFailed
    If requiredLevel > petLevel Then GoTo CommandActionFailed

    experienceDelta = commandId * 10
    If Len(commandAction) > 0 Then
        payload = "IZ" & CStr(Proc_3_0_6D2AF0(botEntityId, Empty, vbNullString))
        payload = payload & commandAction & Chr$(2)
        payload = payload & CStr(Proc_3_0_6D2AF0(commandId, Empty, vbNullString))
        Proc_6_248_802B80 roomId, payload, 0
    End If

    If petEnergy < 250 Or petNutrition < 250 Then
        If CLng(Val(CStr(Proc_10_4_809CA0(0, 2, -1)))) = 0 Then
            commandSpeech = CStr(Proc_10_0_809570("com.client.bot.pet.sad.speech", "gst thr", 0))
        Else
            commandSpeech = CStr(Proc_10_0_809570("com.client.bot.pet.angry.speech", "gst grr", 0))
        End If
        If Len(commandSpeech) > 0 Then Proc_6_248_802B80 roomId, "@X" & CStr(Proc_3_0_6D2AF0(botEntityId, Empty, vbNullString)) & commandSpeech & Chr$(2) & "H", 0
    Else
        Proc_6_185_7CC2D0 botEntityId, experienceDelta, 0
    End If

    Proc_7CA730 = commandId
    Exit Function

CommandActionFailed:
    Proc_7CA730 = Empty
End Function

' Original declaration: Private  Proc_6_185_7CC2D0(arg_C) '7CC2D0
Public Function Proc_6_185_7CC2D0(ParamArray args() As Variant) As Variant
    Dim botEntityId As Long
    Dim botId As Long
    Dim experienceDelta As Long
    Dim petRow As String
    Dim petFields() As String
    Dim petName As String
    Dim petFigure As String
    Dim petLevel As Long
    Dim petExperience As Long
    Dim petEnergy As Long
    Dim petNutrition As Long
    Dim petScratches As Long
    Dim roomId As Long
    Dim nextLevel As Long
    Dim maxExperience As Long
    Dim payload As String
    Dim levelSpeech As String

    On Error GoTo ExperienceFailed
    If UBound(args) < 0 Then GoTo ExperienceFailed

    botEntityId = CLng(Val(CStr(args(0))))
    If UBound(args) >= 1 Then experienceDelta = CLng(Val(CStr(args(1)))) Else experienceDelta = 0
    If botEntityId <= 0 Then GoTo ExperienceFailed

    botId = RepresentedBotRecordLong(botEntityId, 1)
    If botId <= 0 Then
        botId = botEntityId
        botEntityId = RepresentedBotEntityFromBotId(botId)
    End If
    If botId <= 0 Then GoTo ExperienceFailed

    petRow = CStr(Proc_5_2_6D4690("SELECT bots.name,bots.figure,bots_petdata.id_level,bots_petdata.experience,bots_petdata.energy,bots_petdata.nutrition,bots_petdata.scratches,bots.id_room FROM bots,bots_petdata WHERE bots.id='" & _
        CStr(botId) & "' AND bots_petdata.id_bot=bots.id LIMIT 1", 0, 0))
    If Len(petRow) = 0 Then GoTo ExperienceFailed

    petFields = Split(petRow, Chr$(9))
    If UBound(petFields) < 7 Then GoTo ExperienceFailed

    petName = CStr(petFields(0))
    petFigure = CStr(petFields(1))
    petLevel = CLng(Val(CStr(petFields(2))))
    petExperience = CLng(Val(CStr(petFields(3)))) + experienceDelta
    petEnergy = CLng(Val(CStr(petFields(4))))
    petNutrition = CLng(Val(CStr(petFields(5))))
    petScratches = CLng(Val(CStr(petFields(6))))
    roomId = CLng(Val(CStr(petFields(7))))
    If petExperience < 0 Then petExperience = 0

    maxExperience = RepresentedPetLevelMaxExperience(petLevel)
    If maxExperience > 0 And petExperience >= maxExperience Then
        nextLevel = petLevel + 1
        If RepresentedPetLevelMaxExperience(nextLevel) > 0 Then
            petLevel = nextLevel
            petExperience = 0
            levelSpeech = CStr(Proc_10_0_809570("com.client.bot.pet.level_up.speech", "gst sml", 0))
            If roomId > 0 Then Proc_6_248_802B80 roomId, "@X" & CStr(Proc_3_0_6D2AF0(botEntityId, Empty, vbNullString)) & levelSpeech & Chr$(2) & "H", 0
        End If
    End If

    Proc_5_0_6D3CD0 "UPDATE bots_petdata SET id_level='" & CStr(petLevel) & "',experience='" & CStr(petExperience) & _
        "' WHERE id_bot='" & CStr(botId) & "'", 0, 0

    If botEntityId <= 0 Then botEntityId = botId
    payload = "IY" & CStr(Proc_3_0_6D2AF0(botEntityId, Empty, vbNullString)) & petName & Chr$(2)
    payload = payload & CStr(Proc_3_0_6D2AF0(petLevel, Empty, vbNullString))
    payload = payload & CStr(Proc_3_0_6D2AF0(petExperience, Empty, vbNullString))
    payload = payload & CStr(Proc_3_0_6D2AF0(petEnergy, Empty, vbNullString))
    payload = payload & CStr(Proc_3_0_6D2AF0(petNutrition, Empty, vbNullString))
    payload = payload & CStr(Proc_3_0_6D2AF0(petScratches, Empty, vbNullString)) & petFigure & Chr$(2)
    If roomId > 0 Then Proc_6_248_802B80 roomId, payload, 0

    If roomId > 0 Then Proc_6_248_802B80 roomId, "Ia" & CStr(Proc_3_0_6D2AF0(botEntityId, Empty, vbNullString)) & _
        CStr(Proc_3_0_6D2AF0(experienceDelta, Empty, vbNullString)) & CStr(Proc_3_0_6D2AF0(petExperience, Empty, vbNullString)), 0

    Proc_6_185_7CC2D0 = petLevel
    Exit Function

ExperienceFailed:
    Proc_6_185_7CC2D0 = 0
End Function

' Original declaration: Private Sub Proc_6_186_7CD040
Public Function Proc_6_186_7CD040(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim requestPayload As String
    Dim offset As Long
    Dim requestedId As Long
    Dim botEntityId As Long
    Dim botId As Long
    Dim userId As String
    Dim scratchAmount As Long
    Dim petRow As String
    Dim petFields() As String
    Dim petName As String
    Dim petFigure As String
    Dim scratches As Long
    Dim payload As String

    On Error GoTo ScratchFailed

    socketIndex = HandlingSocketIndex(args)
    If socketIndex <= 0 Then GoTo ScratchFailed
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    If Len(packetPayload) = 0 And UBound(args) >= 1 Then packetPayload = CStr(args(1))

    requestPayload = packetPayload
    If Left$(requestPayload, 2) = "n}" Then requestPayload = Mid$(requestPayload, 3)

    offset = 1
    requestedId = ReadWireLong(requestPayload, offset)
    If requestedId <= 0 Then GoTo ScratchFailed

    botEntityId = requestedId
    botId = RepresentedBotRecordLong(botEntityId, 1)
    If botId <= 0 Then
        botId = requestedId
        botEntityId = RepresentedBotEntityFromBotId(botId)
    End If
    If botId <= 0 Then GoTo ScratchFailed

    userId = HandlingUserIdFromSocket(socketIndex)
    If Len(userId) = 0 Or userId = "0" Then GoTo ScratchFailed

    scratchAmount = CLng(Val(CStr(Proc_5_2_6D4690("SELECT scratch_amount FROM users WHERE id='" & _
        Proc_10_11_80A9C0(userId, 0, 0) & "' LIMIT 1", 0, 0))))
    If scratchAmount <= 0 Then GoTo ScratchFailed

    petRow = CStr(Proc_5_2_6D4690("SELECT bots.id,bots.name,bots.figure,bots_petdata.scratches FROM bots,bots_petdata WHERE bots.id='" & _
        CStr(botId) & "' AND bots.id_handle='3' AND bots.id_room IS NOT NULL AND bots_petdata.id_bot=bots.id LIMIT 1", 0, 0))
    If Len(petRow) = 0 Then GoTo ScratchFailed

    petFields = Split(petRow, Chr$(9))
    If UBound(petFields) < 3 Then GoTo ScratchFailed
    petName = CStr(petFields(1))
    petFigure = CStr(petFields(2))
    scratches = CLng(Val(CStr(petFields(3)))) + 1

    Proc_5_0_6D3CD0 "UPDATE bots_petdata SET scratches='" & CStr(scratches) & "' WHERE id_bot='" & CStr(botId) & "'", 0, 0
    Proc_5_0_6D3CD0 "UPDATE users SET scratch_amount=scratch_amount-1,scratch_given=scratch_given+1 WHERE id='" & _
        Proc_10_11_80A9C0(userId, 0, 0) & "'", 0, 0

    If botEntityId <= 0 Then botEntityId = botId
    payload = "I^" & CStr(Proc_3_0_6D2AF0(botEntityId, Empty, vbNullString))
    payload = payload & CStr(Proc_3_0_6D2AF0(CLng(Val(userId)), Empty, vbNullString))
    payload = payload & CStr(Proc_3_0_6D2AF0(scratches, Empty, vbNullString))
    payload = payload & petName & Chr$(2) & petFigure & Chr$(2)
    Proc_6_247_8027E0 socketIndex, payload, 0

    Proc_6_186_7CD040 = scratches
    Exit Function

ScratchFailed:
    Proc_6_186_7CD040 = 0
End Function

' Original declaration: Private  Proc_6_187_7CD700(arg_C) '7CD700
Public Function Proc_6_187_7CD700(ParamArray args() As Variant) As Variant
    Dim roomSlot As Long
    Dim botFields As Variant
    Dim botEntityId As Long
    Dim botId As Long
    Dim botName As String
    Dim botMotto As String
    Dim botSpeech As String
    Dim botResponses As String
    Dim positionX As Long
    Dim positionY As Long
    Dim positionZ As String
    Dim positionR As Long
    Dim botFigure As String
    Dim handleId As Long
    Dim handleActionId As Long
    Dim cacheAction As String
    Dim speechSubmit As String
    Dim allowWalk As Long
    Dim maxFieldsAway As Long
    Dim recordText As String

    On Error GoTo AllocateFailed
    If UBound(args) < 1 Then GoTo AllocateFailed

    roomSlot = CLng(Val(CStr(args(0))))
    botFields = args(1)
    If roomSlot <= 0 Then GoTo AllocateFailed

    botEntityId = ReserveRepresentedBotSlot()
    If botEntityId <= 0 Then GoTo AllocateFailed

    botId = CLng(Val(RepresentedBotField(botFields, 0)))
    botName = RepresentedBotField(botFields, 1)
    botMotto = RepresentedBotField(botFields, 2)
    botSpeech = RepresentedBotField(botFields, 3)
    botResponses = RepresentedBotField(botFields, 4)
    positionX = CLng(Val(RepresentedBotField(botFields, 5)))
    positionY = CLng(Val(RepresentedBotField(botFields, 6)))
    positionZ = RepresentedBotField(botFields, 7)
    positionR = CLng(Val(RepresentedBotField(botFields, 8)))
    botFigure = RepresentedBotField(botFields, 9)
    handleId = CLng(Val(RepresentedBotField(botFields, 11)))
    handleActionId = CLng(Val(RepresentedBotField(botFields, 12)))
    cacheAction = RepresentedBotField(botFields, 13)
    speechSubmit = RepresentedBotField(botFields, 14)
    allowWalk = CLng(Val(RepresentedBotField(botFields, 15)))
    maxFieldsAway = CLng(Val(RepresentedBotField(botFields, 16)))

    recordText = CStr(roomSlot) & Chr$(2) & CStr(botId) & Chr$(2)
    recordText = recordText & botName & Chr$(2) & botMotto & Chr$(2)
    recordText = recordText & botSpeech & Chr$(2) & botResponses & Chr$(2)
    recordText = recordText & CStr(positionX) & Chr$(2) & CStr(positionY) & Chr$(2)
    recordText = recordText & positionZ & Chr$(2) & CStr(positionR) & Chr$(2)
    recordText = recordText & botFigure & Chr$(2) & CStr(handleId) & Chr$(2)
    recordText = recordText & CStr(handleActionId) & Chr$(2) & cacheAction & Chr$(2)
    recordText = recordText & speechSubmit & Chr$(2) & CStr(allowWalk) & Chr$(2)
    recordText = recordText & CStr(maxFieldsAway)

    StoreRepresentedBotRecord botEntityId, recordText
    Proc_6_187_7CD700 = botEntityId
    Exit Function

AllocateFailed:
    Proc_6_187_7CD700 = 0
End Function

' Original declaration: Private Sub Proc_6_188_7CF3C0
Public Function Proc_6_188_7CF3C0(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim userId As String
    Dim roomId As Long
    Dim roomSlot As Long
    Dim guideBotId As Long
    Dim botRow As String
    Dim botFields() As String
    Dim botEntityId As Long
    Dim tutorialGuide As Long

    On Error GoTo GuideFailed

    socketIndex = HandlingSocketIndex(args)
    If socketIndex <= 0 Then GoTo GuideFailed

    userId = HandlingUserIdFromSocket(socketIndex)
    If Len(userId) = 0 Or userId = "0" Then GoTo GuideFailed

    tutorialGuide = CLng(Val(CStr(Proc_5_2_6D4690("SELECT tutorial_guide FROM users WHERE id='" & _
        Proc_10_11_80A9C0(userId, 0, 0) & "' LIMIT 1", 0, 0))))
    If tutorialGuide = 0 Then
        Proc_5_0_6D3CD0 "UPDATE users SET tutorial_guide='1' WHERE id='" & Proc_10_11_80A9C0(userId, 0, 0) & "'", 0, 0
    End If

    If CLng(Val(CStr(Proc_10_0_809570("com.client.rooms.bots.guide.enabled", "0", 0)))) = 0 Then GoTo GuideDone

    roomId = HandlingCurrentRoomId(socketIndex, userId)
    If roomId <= 0 Then GoTo GuideDone

    roomSlot = CLng(Val(CStr(Proc_5_2_6D4690("SELECT id_slot FROM rooms WHERE id='" & CStr(roomId) & "' LIMIT 1", 0, 0))))
    If roomSlot <= 0 Then GoTo GuideDone

    guideBotId = CLng(Val(CStr(Proc_10_0_809570("com.client.bot.guide.id", "0", 0))))
    If guideBotId <= 0 Then GoTo GuideDone
    If IsRepresentedBotAllocated(roomSlot, guideBotId) Then GoTo GuideDone

    botRow = CStr(Proc_5_2_6D4690("SELECT id,name,motto,speech,responses,position_x,position_y,position_z,position_r,figure,NULL,id_handle,id_handleaction,cache_action,speech_submit,allow_walk,max_fields_away FROM bots WHERE id='" & _
        CStr(guideBotId) & "' LIMIT 1", 0, 0))
    If Len(botRow) = 0 Then GoTo GuideDone

    botFields = Split(botRow, Chr$(9))
    botEntityId = CLng(Val(CStr(Proc_6_187_7CD700(roomSlot, botFields, 0))))
    If botEntityId > 0 Then
        Proc_6_244_801E80 socketIndex, "@a" & "YjO", 0
    End If

GuideDone:
    Proc_6_188_7CF3C0 = botEntityId
    Exit Function

GuideFailed:
    Proc_6_188_7CF3C0 = 0
End Function

' Original declaration: Private Sub Proc_6_189_7D0630
Public Function Proc_6_189_7D0630(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim requestPayload As String
    Dim userId As String
    Dim roomId As Long
    Dim roomSlot As Long
    Dim requestedEntityId As Long
    Dim guideBotId As Long
    Dim entityList As String
    Dim entityIds() As String
    Dim entityIndex As Long
    Dim botEntityId As Long
    Dim removedCount As Long
    Dim offset As Long

    On Error GoTo RemoveFailed

    socketIndex = HandlingSocketIndex(args)
    If socketIndex <= 0 Then GoTo RemoveFailed
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    If Len(packetPayload) = 0 And UBound(args) >= 1 Then packetPayload = CStr(args(1))

    requestPayload = packetPayload
    If Left$(requestPayload, 2) = "Fy" Then requestPayload = Mid$(requestPayload, 3)

    offset = 1
    requestedEntityId = ReadWireLong(requestPayload, offset)

    userId = HandlingUserIdFromSocket(socketIndex)
    If Len(userId) = 0 Or userId = "0" Then GoTo RemoveFailed

    roomId = HandlingCurrentRoomId(socketIndex, userId)
    If roomId <= 0 Then GoTo RemoveFailed

    roomSlot = CLng(Val(CStr(Proc_5_2_6D4690("SELECT id_slot FROM rooms WHERE id='" & CStr(roomId) & "' LIMIT 1", 0, 0))))
    If roomSlot <= 0 Then GoTo RemoveFailed

    If requestedEntityId > 0 Then
        If RepresentedBotRecordLong(requestedEntityId, 0) = roomSlot Then
            entityList = CStr(requestedEntityId)
        End If
    Else
        guideBotId = CLng(Val(CStr(Proc_10_0_809570("com.client.bot.guide.id", "0", 0))))
        entityList = RepresentedBotEntitiesForRoom(roomSlot, guideBotId)
    End If

    If Len(entityList) = 0 Then GoTo RemoveDone
    entityIds = Split(entityList, Chr$(13))
    For entityIndex = LBound(entityIds) To UBound(entityIds)
        botEntityId = CLng(Val(CStr(entityIds(entityIndex))))
        If botEntityId > 0 Then
            Proc_6_248_802B80 roomId, "@]" & CStr(botEntityId) & Chr$(2), 0
            RemoveRepresentedBotRecord botEntityId
            removedCount = removedCount + 1
        End If
    Next entityIndex

RemoveDone:
    Proc_6_189_7D0630 = removedCount
    Exit Function

RemoveFailed:
    Proc_6_189_7D0630 = 0
End Function

' Original declaration: Private Sub Proc_6_190_7D11D0
Public Function Proc_6_190_7D11D0(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim requestPayload As String
    Dim callerUserId As String
    Dim roomId As Long
    Dim requestedRoomUserIndex As Long
    Dim offset As Long
    Dim rowText As String
    Dim fields() As String
    Dim payload As String

    On Error GoTo ProfileFailed

    socketIndex = HandlingSocketIndex(args)
    If socketIndex <= 0 Then GoTo ProfileFailed
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    If Len(packetPayload) = 0 And UBound(args) >= 1 Then packetPayload = CStr(args(1))

    requestPayload = packetPayload
    If Left$(requestPayload, 2) = "Cg" Then requestPayload = Mid$(requestPayload, 3)

    offset = 1
    requestedRoomUserIndex = ReadWireLong(requestPayload, offset)
    If requestedRoomUserIndex <= 0 Then GoTo ProfileFailed

    callerUserId = HandlingUserIdFromSocket(socketIndex)
    If Len(callerUserId) = 0 Or callerUserId = "0" Then GoTo ProfileFailed

    roomId = HandlingCurrentRoomId(socketIndex, callerUserId)
    If roomId <= 0 Then GoTo ProfileFailed

    rowText = CStr(Proc_5_2_6D4690("SELECT logs_visitedrooms.id,users.name,users.motto,users.achievement_score,users.figure FROM logs_visitedrooms,users WHERE logs_visitedrooms.id='" & _
        CStr(requestedRoomUserIndex) & "' AND logs_visitedrooms.id_room='" & CStr(roomId) & "' AND logs_visitedrooms.timestamp_left IS NULL AND users.id=logs_visitedrooms.id_user LIMIT 1", 0, 0))
    If Len(rowText) = 0 Then
        rowText = CStr(Proc_5_2_6D4690("SELECT logs_visitedrooms.id,users.name,users.motto,users.achievement_score,users.figure FROM logs_visitedrooms,users WHERE logs_visitedrooms.id_user='" & _
            CStr(requestedRoomUserIndex) & "' AND logs_visitedrooms.id_room='" & CStr(roomId) & "' AND logs_visitedrooms.timestamp_left IS NULL AND users.id=logs_visitedrooms.id_user LIMIT 1", 0, 0))
    End If
    If Len(rowText) = 0 Then GoTo ProfileFailed

    fields = Split(rowText, Chr$(9))
    If UBound(fields) < 4 Then GoTo ProfileFailed

    payload = RepresentedRoomUserProfilePayload(CLng(Val(CStr(fields(0)))), CStr(fields(1)), CStr(fields(2)), CLng(Val(CStr(fields(3)))), CStr(fields(4)))
    If Len(payload) > 0 Then Proc_6_244_801E80 socketIndex, payload, 0

    Proc_6_190_7D11D0 = payload
    Exit Function

ProfileFailed:
    Proc_6_190_7D11D0 = Empty
End Function

' Original declaration: Private Sub Proc_6_191_7D18B0
Public Function Proc_6_191_7D18B0(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim requestPayload As String
    Dim callerUserId As String
    Dim requestedUserId As Long
    Dim targetSocketIndex As Integer
    Dim payload As String
    Dim offset As Long

    On Error GoTo TagsFailed

    socketIndex = HandlingSocketIndex(args)
    If socketIndex <= 0 Then GoTo TagsFailed
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    If Len(packetPayload) = 0 And UBound(args) >= 1 Then packetPayload = CStr(args(1))

    requestPayload = packetPayload
    If Left$(requestPayload, 2) = "DG" Then requestPayload = Mid$(requestPayload, 3)

    offset = 1
    requestedUserId = ReadWireLong(requestPayload, offset)
    If requestedUserId <= 0 Then GoTo TagsFailed

    callerUserId = HandlingUserIdFromSocket(socketIndex)
    If Len(callerUserId) = 0 Or callerUserId = "0" Then GoTo TagsFailed

    targetSocketIndex = CInt(Val(CStr(Proc_5_2_6D4690("SELECT id_socket FROM users WHERE id='" & CStr(requestedUserId) & "' LIMIT 1", 0, 0))))
    If targetSocketIndex <= 0 Then
        If HandlingCurrentRoomId(socketIndex, callerUserId) <= 0 Then GoTo TagsFailed
    End If

    payload = "E^" & CStr(Proc_3_0_6D2AF0(requestedUserId, Empty, vbNullString)) & CStr(Proc_6_196_7D3ED0(requestedUserId, 0, 0))
    Proc_6_244_801E80 socketIndex, payload, 0

    Proc_6_191_7D18B0 = payload
    Exit Function

TagsFailed:
    Proc_6_191_7D18B0 = Empty
End Function

' Original declaration: Private Sub Proc_6_192_7D1B80
Public Function Proc_6_192_7D1B80(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim requestPayload As String
    Dim callerUserId As String
    Dim callerRoomUserIndex As Long
    Dim callerRoomId As Long
    Dim requestedRoomUserIndex As Long
    Dim targetRow As String
    Dim targetFields() As String
    Dim targetRoomUserIndex As Long
    Dim targetUserId As String
    Dim targetBadgePayload As String
    Dim callerStatusPayload As String
    Dim targetStatusPayload As String
    Dim offset As Long

    On Error GoTo LookToFailed

    socketIndex = HandlingSocketIndex(args)
    If socketIndex <= 0 Then GoTo LookToFailed
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    If Len(packetPayload) = 0 And UBound(args) >= 1 Then packetPayload = CStr(args(1))

    requestPayload = packetPayload
    If Left$(requestPayload, 2) = "B_" Then requestPayload = Mid$(requestPayload, 3)

    offset = 1
    requestedRoomUserIndex = ReadWireLong(requestPayload, offset)
    If requestedRoomUserIndex <= 0 Then GoTo LookToFailed

    callerUserId = HandlingUserIdFromSocket(socketIndex)
    If Len(callerUserId) = 0 Or callerUserId = "0" Then GoTo LookToFailed

    callerRoomId = HandlingCurrentRoomId(socketIndex, callerUserId)
    If callerRoomId <= 0 Then GoTo LookToFailed

    callerRoomUserIndex = RepresentedRoomUserIndex(socketIndex, callerUserId)
    targetRow = CStr(Proc_5_2_6D4690("SELECT logs_visitedrooms.id,logs_visitedrooms.id_user,users.id_socket FROM logs_visitedrooms,users WHERE logs_visitedrooms.id='" & _
        CStr(requestedRoomUserIndex) & "' AND logs_visitedrooms.id_room='" & CStr(callerRoomId) & "' AND logs_visitedrooms.timestamp_left IS NULL AND users.id=logs_visitedrooms.id_user LIMIT 1", 0, 0))
    If Len(targetRow) = 0 Then
        targetRow = CStr(Proc_5_2_6D4690("SELECT logs_visitedrooms.id,logs_visitedrooms.id_user,users.id_socket FROM logs_visitedrooms,users WHERE logs_visitedrooms.id_user='" & _
            CStr(requestedRoomUserIndex) & "' AND logs_visitedrooms.id_room='" & CStr(callerRoomId) & "' AND logs_visitedrooms.timestamp_left IS NULL AND users.id=logs_visitedrooms.id_user LIMIT 1", 0, 0))
    End If
    If Len(targetRow) = 0 Then GoTo LookToFailed

    targetFields = Split(targetRow, Chr$(9))
    If UBound(targetFields) < 1 Then GoTo LookToFailed

    targetRoomUserIndex = CLng(Val(CStr(targetFields(0))))
    targetUserId = CStr(CLng(Val(CStr(targetFields(1)))))
    If targetRoomUserIndex <= 0 Or Len(targetUserId) = 0 Or targetUserId = "0" Then GoTo LookToFailed

    targetBadgePayload = "Cd" & CStr(Proc_3_0_6D2AF0(CLng(Val(targetUserId)), Empty, vbNullString)) & CStr(Proc_6_195_7D38D0(targetUserId, 0, 0))
    Proc_6_244_801E80 socketIndex, targetBadgePayload, 0

    If callerRoomUserIndex > 0 And callerRoomUserIndex <> targetRoomUserIndex Then
        callerStatusPayload = RepresentedRoomUserStatusPayload(callerRoomUserIndex, 0)
        targetStatusPayload = RepresentedRoomUserStatusPayload(targetRoomUserIndex, 0)
        If Len(callerStatusPayload) > 0 Then Proc_6_247_8027E0 socketIndex, callerStatusPayload, 0
        If Len(targetStatusPayload) > 0 Then Proc_6_247_8027E0 socketIndex, targetStatusPayload, 0
    End If

    Proc_6_192_7D1B80 = targetBadgePayload
    Exit Function

LookToFailed:
    Proc_6_192_7D1B80 = Empty
End Function

' Original declaration: Private Sub Proc_6_193_7D2BB0
Public Function Proc_6_193_7D2BB0(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim userId As String
    Dim rowText As String
    Dim rows() As String
    Dim fields() As String
    Dim rowIndex As Long
    Dim badgeId As String
    Dim badgeRowId As Long
    Dim inventoryPayload As String
    Dim inventoryCount As Long
    Dim payload As String

    On Error GoTo BadgeListFailed

    socketIndex = HandlingSocketIndex(args)
    If socketIndex <= 0 Then GoTo BadgeListFailed

    userId = HandlingUserIdFromSocket(socketIndex)
    If Len(userId) = 0 Or userId = "0" Then GoTo BadgeListFailed

    rowText = CStr(Proc_5_2_6D4690("SELECT id_badge,id_slot,id FROM users_badges WHERE id_user='" & Proc_10_11_80A9C0(userId, 0, 0) & "' AND id_slot='0' LIMIT 1000", 0, 0))
    If Len(rowText) > 0 Then
        rows = Split(rowText, Chr$(13))
        For rowIndex = LBound(rows) To UBound(rows)
            If Len(CStr(rows(rowIndex))) > 0 Then
                fields = Split(CStr(rows(rowIndex)), Chr$(9))
                If UBound(fields) >= 2 Then
                    badgeId = CStr(fields(0))
                    badgeRowId = CLng(Val(CStr(fields(2))))
                    inventoryPayload = inventoryPayload & "0" & CStr(Proc_3_0_6D2AF0(badgeRowId, Empty, vbNullString)) & badgeId & Chr$(2)
                    inventoryCount = inventoryCount + 1
                End If
            End If
        Next rowIndex
    End If

    payload = CStr(Proc_3_0_6D2AF0(inventoryCount, Empty, "Ce")) & inventoryPayload & CStr(Proc_6_195_7D38D0(userId, 0, 0))
    Proc_6_244_801E80 socketIndex, payload, 0
    Proc_6_244_801E80 socketIndex, "Cd" & CStr(Proc_3_0_6D2AF0(CLng(Val(userId)), Empty, vbNullString)) & CStr(Proc_6_195_7D38D0(userId, 0, 0)), 0

    Proc_6_193_7D2BB0 = payload
    Exit Function

BadgeListFailed:
    Proc_6_193_7D2BB0 = Empty
End Function

' Original declaration: Private Sub Proc_6_194_7D3180
Public Function Proc_6_194_7D3180(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim requestPayload As String
    Dim userId As String
    Dim offset As Long
    Dim slotIndex As Long
    Dim hasBadge As Long
    Dim badgeId As String
    Dim equippedPayload As String
    Dim roomId As Long

    On Error GoTo BadgeUpdateFailed

    socketIndex = HandlingSocketIndex(args)
    If socketIndex <= 0 Then GoTo BadgeUpdateFailed
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    If Len(packetPayload) = 0 And UBound(args) >= 1 Then packetPayload = CStr(args(1))

    requestPayload = packetPayload
    If Left$(requestPayload, 2) = "B^" Then requestPayload = Mid$(requestPayload, 3)

    userId = HandlingUserIdFromSocket(socketIndex)
    If Len(userId) = 0 Or userId = "0" Then GoTo BadgeUpdateFailed

    Proc_5_0_6D3CD0 "UPDATE users_badges SET id_slot='0' WHERE id_user='" & Proc_10_11_80A9C0(userId, 0, 0) & "'", 0, 0

    offset = 1
    For slotIndex = 1 To 5
        hasBadge = ReadWireLong(requestPayload, offset)
        If hasBadge = 1 Then
            badgeId = CStr(Proc_10_11_80A9C0(ReadWireString(requestPayload, offset), 0, 0))
            If Len(badgeId) > 0 Then
                Proc_5_0_6D3CD0 "UPDATE users_badges SET id_slot='" & CStr(slotIndex) & "' WHERE id_badge='" & _
                    badgeId & "' AND id_user='" & Proc_10_11_80A9C0(userId, 0, 0) & "'", 0, 0
            End If
        End If
    Next slotIndex

    equippedPayload = CStr(Proc_6_195_7D38D0(userId, 0, 0))
    Proc_6_244_801E80 socketIndex, "Cd" & CStr(Proc_3_0_6D2AF0(CLng(Val(userId)), Empty, vbNullString)) & equippedPayload, 0

    roomId = HandlingCurrentRoomId(socketIndex, userId)
    If roomId > 0 Then Proc_6_247_8027E0 socketIndex, "Cd" & CStr(Proc_3_0_6D2AF0(CLng(Val(userId)), Empty, vbNullString)) & equippedPayload, 0

    Proc_6_194_7D3180 = equippedPayload
    Exit Function

BadgeUpdateFailed:
    Proc_6_194_7D3180 = Empty
End Function

' Original declaration: Private Sub Proc_6_195_7D38D0
Public Function Proc_6_195_7D38D0(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim userId As String
    Dim rowText As String
    Dim rows() As String
    Dim fields() As String
    Dim rowIndex As Long
    Dim badgeId As String
    Dim badgeSlot As Long
    Dim equippedPayload As String
    Dim equippedCount As Long

    On Error GoTo EquippedFailed

    If UBound(args) >= 0 Then
        If IsNumeric(CStr(args(0))) Then userId = CStr(CLng(Val(CStr(args(0)))))
    End If
    If Len(userId) = 0 Or userId = "0" Then
        socketIndex = HandlingSocketIndex(args)
        If socketIndex > 0 Then userId = HandlingUserIdFromSocket(socketIndex)
    End If
    If Len(userId) = 0 Or userId = "0" Then GoTo EquippedFailed

    rowText = CStr(Proc_5_2_6D4690("SELECT id_badge,id_slot,id FROM users_badges WHERE id_slot != '0' AND id_user='" & Proc_10_11_80A9C0(userId, 0, 0) & "' LIMIT 5", 0, 0))
    If Len(rowText) > 0 Then
        rows = Split(rowText, Chr$(13))
        For rowIndex = LBound(rows) To UBound(rows)
            If Len(CStr(rows(rowIndex))) > 0 Then
                fields = Split(CStr(rows(rowIndex)), Chr$(9))
                If UBound(fields) >= 1 Then
                    badgeId = CStr(fields(0))
                    badgeSlot = CLng(Val(CStr(fields(1))))
                    equippedPayload = equippedPayload & "0" & CStr(Proc_3_0_6D2AF0(badgeSlot, Empty, vbNullString)) & badgeId & Chr$(2)
                    equippedCount = equippedCount + 1
                End If
            End If
        Next rowIndex
    End If

    Proc_6_195_7D38D0 = CStr(Proc_3_0_6D2AF0(equippedCount, Empty, vbNullString)) & equippedPayload
    Exit Function

EquippedFailed:
    Proc_6_195_7D38D0 = CStr(Proc_3_0_6D2AF0(0, Empty, vbNullString))
End Function

' Original declaration: Private Sub Proc_6_196_7D3ED0
Public Function Proc_6_196_7D3ED0(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim userId As String
    Dim rowText As String
    Dim rows() As String
    Dim rowIndex As Long
    Dim tagPayload As String
    Dim tagCount As Long

    On Error GoTo TagsBuildFailed

    If UBound(args) >= 0 Then
        If IsNumeric(CStr(args(0))) Then
            userId = CStr(CLng(Val(CStr(args(0)))))
        End If
    End If

    If Len(userId) = 0 Or userId = "0" Then
        socketIndex = HandlingSocketIndex(args)
        If socketIndex > 0 Then userId = HandlingUserIdFromSocket(socketIndex)
    End If
    If Len(userId) = 0 Or userId = "0" Then GoTo TagsBuildFailed

    rowText = CStr(Proc_5_2_6D4690("SELECT name FROM users_tags WHERE id_user='" & Proc_10_11_80A9C0(userId, 0, 0) & "' LIMIT 30", 0, 0))
    If Len(rowText) > 0 Then
        rows = Split(rowText, Chr$(13))
        For rowIndex = LBound(rows) To UBound(rows)
            If Len(CStr(rows(rowIndex))) > 0 Then
                tagPayload = tagPayload & CStr(rows(rowIndex)) & Chr$(2)
                tagCount = tagCount + 1
            End If
        Next rowIndex
    End If

    Proc_6_196_7D3ED0 = CStr(Proc_3_0_6D2AF0(tagCount, Empty, vbNullString)) & tagPayload
    Exit Function

TagsBuildFailed:
    Proc_6_196_7D3ED0 = CStr(Proc_3_0_6D2AF0(0, Empty, vbNullString))
End Function

' Original declaration: Private Sub Proc_6_197_7D43C0
Public Function Proc_6_197_7D43C0(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim requestPayload As String
    Dim userId As String
    Dim roomId As Long
    Dim roomSlot As Long
    Dim lookX As Long
    Dim lookY As Long
    Dim currentX As Long
    Dim currentY As Long
    Dim directionValue As Long
    Dim offset As Long

    On Error GoTo LookRequestDone

    socketIndex = HandlingSocketIndex(args)
    If socketIndex <= 0 Then GoTo LookRequestDone

    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    If Len(packetPayload) = 0 And UBound(args) >= 1 Then packetPayload = CStr(args(1))

    requestPayload = packetPayload
    If Left$(requestPayload, 2) = "AK" Then requestPayload = Mid$(requestPayload, 3)

    offset = 1
    lookX = ReadWireLong(requestPayload, offset)
    lookY = ReadWireLong(requestPayload, offset)
    If lookX = 0 And lookY = 0 Then
        lookX = CLng(Val(CStr(Proc_10_6_809F10(requestPayload, 0, 0))))
        lookY = CLng(Val(CStr(Proc_10_6_809F10(requestPayload, 0, 0))))
    End If
    If lookX < 0 Or lookY < 0 Then GoTo LookRequestDone

    userId = HandlingUserIdFromSocket(socketIndex)
    If Len(userId) = 0 Or userId = "0" Then GoTo LookRequestDone

    roomId = HandlingCurrentRoomId(socketIndex, userId)
    If roomId <= 0 Then GoTo LookRequestDone

    roomSlot = socketIndex
    If Not HandlingRepresentedMovementPosition(roomSlot, socketIndex, currentX, currentY) Then
        currentX = 0
        currentY = 0
    End If

    directionValue = HandlingDirectionCode(Sgn(lookX - currentX), Sgn(lookY - currentY))
    HandlingRepresentedRoomOccupantMove roomSlot, socketIndex, currentX, currentY, directionValue, 0
    Proc_6_106_74B750 App.Path & "\CACHE\ROOMS\" & CStr(roomId) & ".cache", 0, 0

LookRequestDone:
    Proc_6_197_7D43C0 = Empty
End Function

' Original declaration: Private Sub Proc_6_198_7D4B70
Public Function Proc_6_198_7D4B70(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim requestPayload As String
    Dim userId As String
    Dim roomId As Long
    Dim roomSlot As Long
    Dim targetX As Long
    Dim targetY As Long
    Dim currentX As Long
    Dim currentY As Long
    Dim movementText As String
    Dim nextX As Long
    Dim nextY As Long
    Dim directionValue As Long
    Dim movingValue As Long
    Dim offset As Long

    On Error GoTo WalkRequestDone

    socketIndex = HandlingSocketIndex(args)
    If socketIndex <= 0 Then GoTo WalkRequestDone

    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    If Len(packetPayload) = 0 And UBound(args) >= 1 Then packetPayload = CStr(args(1))

    requestPayload = packetPayload
    If Left$(requestPayload, 2) = "AO" Then requestPayload = Mid$(requestPayload, 3)

    offset = 1
    targetX = ReadWireLong(requestPayload, offset)
    targetY = ReadWireLong(requestPayload, offset)
    If targetX = 0 And targetY = 0 Then
        targetX = CLng(Val(CStr(Proc_10_6_809F10(requestPayload, 0, 0))))
        targetY = CLng(Val(CStr(Proc_10_6_809F10(requestPayload, 0, 0))))
    End If
    If targetX < 0 Or targetY < 0 Then GoTo WalkRequestDone

    userId = HandlingUserIdFromSocket(socketIndex)
    If Len(userId) = 0 Or userId = "0" Then GoTo WalkRequestDone

    roomId = HandlingCurrentRoomId(socketIndex, userId)
    If roomId <= 0 Then GoTo WalkRequestDone
    If CLng(Val(CStr(Proc_10_25_80F5D0(roomId, targetX, targetY)))) = 0 Then GoTo WalkRequestDone

    roomSlot = socketIndex
    If Not HandlingRepresentedMovementPosition(roomSlot, socketIndex, currentX, currentY) Then
        currentX = 0
        currentY = 0
    End If

    movementText = CStr(Proc_10_24_80E790(socketIndex, currentX, currentY, targetX, targetY))
    nextX = HandlingMovementField(movementText, 0)
    nextY = HandlingMovementField(movementText, 1)
    directionValue = HandlingMovementField(movementText, 2)
    movingValue = HandlingMovementField(movementText, 3)
    If movingValue = 0 And (currentX <> targetX Or currentY <> targetY) Then movingValue = 1

    HandlingRepresentedRoomOccupantMove roomSlot, socketIndex, nextX, nextY, directionValue, movingValue
    Proc_6_106_74B750 App.Path & "\CACHE\ROOMS\" & CStr(roomId) & ".cache", 0, 0

WalkRequestDone:
    Proc_6_198_7D4B70 = Empty
End Function

' Original declaration: Private Sub Proc_6_199_7D54E0
Public Function Proc_6_199_7D54E0(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim requestPayload As String
    Dim userId As String
    Dim roomId As Long
    Dim pollId As Long
    Dim offset As Long
    Dim pollRow As String

    On Error GoTo ExitFailed

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    If Len(packetPayload) = 0 And UBound(args) >= 1 Then packetPayload = CStr(args(1))

    requestPayload = packetPayload
    If Left$(requestPayload, 2) = "Ck" Then requestPayload = Mid$(requestPayload, 3)

    offset = 1
    pollId = ReadWireLong(requestPayload, offset)
    If pollId <= 0 Then pollId = CLng(Val(CStr(Proc_10_6_809F10(requestPayload, 0, 0))))
    If pollId <= 0 Then GoTo ExitFailed

    userId = HandlingUserIdFromSocket(socketIndex)
    If Len(userId) = 0 Or userId = "0" Then GoTo ExitFailed

    roomId = HandlingCurrentRoomId(socketIndex, userId)
    If roomId <= 0 Then GoTo ExitFailed

    pollRow = CStr(Proc_5_2_6D4690("SELECT id,description_title,description_thanks FROM poll WHERE id='" & CStr(pollId) & "' AND id_room='" & CStr(roomId) & "' LIMIT 1", 0, 0))
    If Len(pollRow) = 0 Then GoTo ExitFailed

    Proc_5_0_6D3CD0 "INSERT INTO poll_exit(id_user,id_poll) VALUES('" & Proc_10_11_80A9C0(userId, 0, 0) & "','" & CStr(pollId) & "')", 0, 0

ExitFailed:
    Proc_6_199_7D54E0 = Empty
End Function

' Original declaration: Private Sub Proc_6_200_7D5770
Public Function Proc_6_200_7D5770(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim requestPayload As String
    Dim userId As String
    Dim roomId As Long
    Dim pollId As Long
    Dim questionId As Long
    Dim answerValue As Long
    Dim answerText As String
    Dim offset As Long
    Dim pollRow As String

    On Error GoTo AnswerFailed

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    If Len(packetPayload) = 0 And UBound(args) >= 1 Then packetPayload = CStr(args(1))

    requestPayload = packetPayload
    If Left$(requestPayload, 2) = "Cl" Then requestPayload = Mid$(requestPayload, 3)

    offset = 1
    pollId = ReadWireLong(requestPayload, offset)
    questionId = ReadWireLong(requestPayload, offset)
    answerValue = ReadWireLong(requestPayload, offset)
    answerText = CStr(Proc_10_10_80A7F0(ReadWireString(requestPayload, offset), 0, 0))

    If pollId <= 0 Then pollId = CLng(Val(CStr(Proc_10_6_809F10(requestPayload, 0, 0))))
    If pollId <= 0 Or questionId <= 0 Then GoTo AnswerFailed
    If Len(answerText) = 0 And answerValue > 0 Then answerText = CStr(answerValue)

    userId = HandlingUserIdFromSocket(socketIndex)
    If Len(userId) = 0 Or userId = "0" Then GoTo AnswerFailed

    roomId = HandlingCurrentRoomId(socketIndex, userId)
    If roomId <= 0 Then GoTo AnswerFailed

    pollRow = CStr(Proc_5_2_6D4690("SELECT id,description_title,description_thanks FROM poll WHERE id='" & CStr(pollId) & "' AND id_room='" & CStr(roomId) & "' LIMIT 1", 0, 0))
    If Len(pollRow) = 0 Then GoTo AnswerFailed

    Proc_5_0_6D3CD0 "INSERT INTO poll_results(id_poll,id_question,message_answer,id_user,timestamp) VALUES('" & CStr(pollId) & "','" & CStr(questionId) & "','" & Proc_10_11_80A9C0(answerText, 0, 0) & "','" & Proc_10_11_80A9C0(userId, 0, 0) & "',UNIX_TIMESTAMP())", 0, 0

AnswerFailed:
    Proc_6_200_7D5770 = Empty
End Function

' Original declaration: Private Sub Proc_6_201_7D5AC0
Public Function Proc_6_201_7D5AC0(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim requestPayload As String
    Dim userId As String
    Dim roomId As Long
    Dim pollId As Long
    Dim pollRow As String
    Dim pollFields() As String
    Dim questionRows() As String
    Dim questionFields() As String
    Dim answerRows() As String
    Dim answerFields() As String
    Dim questionRowText As String
    Dim answerRowText As String
    Dim questionPayload As String
    Dim answerPayload As String
    Dim payload As String
    Dim questionCount As Long
    Dim questionIndex As Long
    Dim answerCount As Long
    Dim answerIndex As Long
    Dim questionId As Long
    Dim questionType As Long
    Dim questionText As String
    Dim answerText As String
    Dim offset As Long

    On Error GoTo SendFailed

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    If Len(packetPayload) = 0 And UBound(args) >= 1 Then packetPayload = CStr(args(1))

    requestPayload = packetPayload
    If Left$(requestPayload, 2) = "Cj" Then requestPayload = Mid$(requestPayload, 3)

    offset = 1
    pollId = ReadWireLong(requestPayload, offset)
    If pollId <= 0 Then pollId = CLng(Val(CStr(Proc_10_6_809F10(requestPayload, 0, 0))))
    If pollId <= 0 Then GoTo SendFailed

    userId = HandlingUserIdFromSocket(socketIndex)
    If Len(userId) = 0 Or userId = "0" Then GoTo SendFailed

    roomId = HandlingCurrentRoomId(socketIndex, userId)
    If roomId <= 0 Then GoTo SendFailed

    pollRow = CStr(Proc_5_2_6D4690("SELECT id,description_title,description_thanks FROM poll WHERE id='" & CStr(pollId) & "' AND id_room='" & CStr(roomId) & "' LIMIT 1", 0, 0))
    If Len(pollRow) = 0 Then GoTo SendFailed

    pollFields = Split(pollRow, Chr$(9))
    If UBound(pollFields) < 2 Then GoTo SendFailed

    questionRowText = CStr(Proc_5_2_6D4690("SELECT id,description_question,id_type FROM poll_questions WHERE id_poll='" & CStr(pollId) & "' LIMIT 50", 0, 0))
    If Len(questionRowText) > 0 Then questionRows = Split(questionRowText, Chr$(13))

    If Len(questionRowText) > 0 Then
        For questionIndex = LBound(questionRows) To UBound(questionRows)
            If Len(questionRows(questionIndex)) > 0 Then
                questionFields = Split(questionRows(questionIndex), Chr$(9))
                If UBound(questionFields) >= 2 Then
                    questionId = CLng(Val(CStr(questionFields(0))))
                    questionText = CStr(questionFields(1))
                    questionType = CLng(Val(CStr(questionFields(2))))

                    answerPayload = vbNullString
                    answerCount = 0
                    answerRowText = CStr(Proc_5_2_6D4690("SELECT id,id_question,caption FROM poll_answers WHERE id_question='" & CStr(questionId) & "' LIMIT 5", 0, 0))
                    If Len(answerRowText) > 0 Then
                        answerRows = Split(answerRowText, Chr$(13))
                        For answerIndex = LBound(answerRows) To UBound(answerRows)
                            If Len(answerRows(answerIndex)) > 0 Then
                                answerFields = Split(answerRows(answerIndex), Chr$(9))
                                If UBound(answerFields) >= 2 Then
                                    answerText = CStr(answerFields(2))
                                    answerPayload = answerPayload & answerText & Chr$(2)
                                    answerCount = answerCount + 1
                                End If
                            End If
                        Next answerIndex
                    End If

                    questionCount = questionCount + 1
                    questionPayload = CStr(Proc_3_0_6D2AF0(questionId, Empty, questionPayload))
                    questionPayload = CStr(Proc_3_0_6D2AF0(questionCount, Empty, questionPayload))
                    questionPayload = CStr(Proc_3_0_6D2AF0(questionType, Empty, questionPayload))
                    questionPayload = questionPayload & questionText & Chr$(2)
                    questionPayload = CStr(Proc_3_0_6D2AF0(answerCount, Empty, questionPayload))
                    questionPayload = CStr(Proc_3_0_6D2AF0(0, Empty, questionPayload))
                    questionPayload = CStr(Proc_3_0_6D2AF0(answerCount, Empty, questionPayload)) & answerPayload
                End If
            End If
        Next questionIndex
    End If

    payload = CStr(Proc_3_0_6D2AF0(pollId, Empty, "D}")) & CStr(pollFields(1)) & Chr$(2) & CStr(pollFields(2)) & Chr$(2)
    payload = CStr(Proc_3_0_6D2AF0(questionCount, Empty, payload)) & questionPayload
    Proc_6_244_801E80 socketIndex, payload, 0

SendFailed:
    Proc_6_201_7D5AC0 = Empty
End Function

' Original declaration: Private Sub Proc_6_202_7D6760
Public Function Proc_6_202_7D6760(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim requestPayload As String
    Dim userId As String
    Dim requestedCount As Long
    Dim offset As Long
    Dim itemIndex As Long
    Dim furnitureId As Long
    Dim selectedItems As String
    Dim itemWhere As String
    Dim validCount As Long
    Dim rewardProductId As Long
    Dim rewardDestinationId As Long
    Dim dateFormatText As String
    Dim rewardSign As String
    Dim payload As String

    On Error GoTo RecycleFailed

    socketIndex = HandlingSocketIndex(args)
    If socketIndex <= 0 Then GoTo RecycleFailed
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    If Len(packetPayload) = 0 And UBound(args) >= 1 Then packetPayload = CStr(args(1))

    requestPayload = packetPayload
    If Left$(requestPayload, 2) = "F^" Then requestPayload = Mid$(requestPayload, 3)

    If CLng(Val(CStr(Proc_10_0_809570("com.client.catalog.recycler.enabled", 0, 0)))) = 0 Then GoTo RecycleFailed

    userId = HandlingUserIdFromSocket(socketIndex)
    If Len(userId) = 0 Or userId = "0" Then GoTo RecycleFailed

    offset = 1
    requestedCount = ReadWireLong(requestPayload, offset)
    If requestedCount <> 5 Then GoTo RecycleFailed

    For itemIndex = 1 To requestedCount
        furnitureId = ReadWireLong(requestPayload, offset)
        If furnitureId <= 0 Then GoTo RecycleFailed
        If InStr(1, "," & selectedItems & ",", "," & CStr(furnitureId) & ",", vbBinaryCompare) > 0 Then GoTo RecycleFailed

        If Len(selectedItems) > 0 Then selectedItems = selectedItems & ","
        selectedItems = selectedItems & CStr(furnitureId)
        itemWhere = itemWhere & " OR furnitures.id_owner='" & Proc_10_11_80A9C0(userId, 0, 0) & _
            "' AND furnitures.id_room IS NULL AND furnitures.id='" & CStr(furnitureId) & _
            "' AND products.id=furnitures.id_product AND products.is_recycleable='1'"
    Next itemIndex

    If Len(itemWhere) = 0 Then GoTo RecycleFailed
    validCount = CLng(Val(CStr(Proc_5_2_6D4690("SELECT COUNT(*) FROM furnitures,products WHERE " & Mid$(itemWhere, 5), 0, 0))))
    If validCount <> requestedCount Then GoTo RecycleFailed

    rewardProductId = RepresentedRecyclerRewardProduct()
    If rewardProductId <= 0 Then GoTo RecycleFailed

    rewardDestinationId = CLng(Val(CStr(Proc_5_2_6D4690("SELECT id_destination FROM catalog_products WHERE id_product='" & CStr(rewardProductId) & "' ORDER BY id DESC LIMIT 1", 0, 0))))
    If rewardDestinationId <= 0 Then rewardDestinationId = rewardProductId

    dateFormatText = CStr(Proc_10_0_809570("com.client.format.date", 0, 0))
    If Len(dateFormatText) = 0 Or dateFormatText = "0" Then dateFormatText = "yyyy-mm-dd hh:nn:ss"
    rewardSign = Format$(Now, dateFormatText)

    Proc_5_0_6D3CD0 "UPDATE furnitures SET sign='" & Proc_10_11_80A9C0(rewardSign, 0, 0) & _
        "',id_owner='" & Proc_10_11_80A9C0(userId, 0, 0) & "',id_destination='" & CStr(rewardDestinationId) & _
        "' WHERE id_owner='" & Proc_10_11_80A9C0(userId, 0, 0) & "' AND id_product='" & _
        CStr(global_0082916C) & "' ORDER BY id DESC LIMIT 1", 1, 0
    Proc_5_0_6D3CD0 "UPDATE furnitures SET id_owner=NULL WHERE id_owner='" & Proc_10_11_80A9C0(userId, 0, 0) & _
        "' AND id_room IS NULL AND id IN (" & selectedItems & ")", 0, 0
    Proc_5_1_6D4110 "INSERT INTO logs_recycler(id_user,timestamp,items,id_reward,id_session) VALUES('" & _
        Proc_10_11_80A9C0(userId, 0, 0) & "',UNIX_TIMESTAMP(),'" & Proc_10_11_80A9C0(selectedItems, 0, 0) & "','" & _
        CStr(rewardProductId) & "','0')", 0, 0

    For itemIndex = 1 To requestedCount
        furnitureId = CLng(Val(Split(selectedItems, ",")(itemIndex - 1)))
        Proc_6_244_801E80 socketIndex, CStr(Proc_3_0_6D2AF0(furnitureId, Empty, "Ac")), 0
    Next itemIndex

    payload = CStr(Proc_3_0_6D2AF0(rewardProductId, Empty, "G|" & global_004096B0))
    Proc_6_244_801E80 socketIndex, payload, 0

RecycleFailed:
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
    Dim socketIndex As Integer
    Dim userId As String
    Dim achievementQuestId As Long
    Dim achievementIndex As Long
    Dim achievementId As Long
    Dim badgePrefix As String
    Dim progressStep As Long
    Dim levelTotal As Long
    Dim currentLevel As Long
    Dim nextLevel As Long
    Dim currentProgress As Long
    Dim requiredProgress As Long
    Dim rowText As String

    On Error GoTo ProgressFailed

    If UBound(args) < 1 Then GoTo ProgressFailed

    socketIndex = HandlingSocketIndex(args)
    If socketIndex <= 0 And UBound(args) >= 1 Then socketIndex = CInt(Val(CStr(args(1))))
    If socketIndex <= 0 Then GoTo ProgressFailed

    achievementQuestId = CLng(Val(CStr(args(UBound(args)))))
    If achievementQuestId <= 0 Then GoTo ProgressFailed

    userId = HandlingUserIdFromSocket(socketIndex)
    If Len(userId) = 0 Or userId = "0" Then GoTo ProgressFailed
    If Not IsArray(global_008291E8) Then GoTo ProgressFailed

    For achievementIndex = LBound(global_008291E8, 1) To UBound(global_008291E8, 1)
        achievementId = CLng(Val(CStr(global_008291E8(achievementIndex, 0))))
        If achievementId = achievementQuestId Then
            badgePrefix = CStr(global_008291E8(achievementIndex, 1))
            progressStep = CLng(Val(CStr(global_008291E8(achievementIndex, 2))))
            levelTotal = CLng(Val(CStr(global_008291E8(achievementIndex, 4))))
            If Len(badgePrefix) = 0 Or progressStep <= 0 Then GoTo ProgressFailed
            If levelTotal <= 0 Then levelTotal = 1

            rowText = CStr(Proc_5_2_6D4690("SELECT REPLACE(id_badge,'" & Proc_10_11_80A9C0(badgePrefix, 0, 0) & "','') FROM users_badges WHERE id_user='" & _
                Proc_10_11_80A9C0(userId, 0, 0) & "' AND id_badge LIKE '" & Proc_10_11_80A9C0(badgePrefix, 0, 0) & "%' ORDER BY id DESC LIMIT 1", 0, 0))
            currentLevel = CLng(Val(rowText))
            If currentLevel < 0 Then currentLevel = 0
            If currentLevel >= levelTotal Then GoTo ProgressFailed

            nextLevel = currentLevel + 1
            requiredProgress = progressStep * nextLevel
            currentProgress = RepresentedAchievementProgress(userId, achievementQuestId)
            If currentProgress >= requiredProgress Then
                Proc_6_204_7D82E0 socketIndex, achievementIndex, nextLevel
            End If
            Exit For
        End If
    Next achievementIndex

ProgressFailed:
    Proc_6_205_7D9780 = Empty
End Function

' Original declaration: Private Sub Proc_6_206_7DA450
Public Function Proc_6_206_7DA450(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim userId As String
    Dim achievementIndex As Long
    Dim achievementId As Long
    Dim badgePrefix As String
    Dim progressRequired As Long
    Dim rewardIncrease As Long
    Dim levelTotal As Long
    Dim scoreIncrease As Long
    Dim rewardType As Long
    Dim currentLevel As Long
    Dim currentProgress As Long
    Dim rowText As String
    Dim entryPayload As String
    Dim payload As String
    Dim achievementCount As Long

    On Error GoTo SendFailed

    socketIndex = HandlingSocketIndex(args)
    userId = HandlingUserIdFromSocket(socketIndex)
    If Len(userId) = 0 Or userId = "0" Then GoTo SendFailed
    If Not IsArray(global_008291E8) Then GoTo SendFailed

    For achievementIndex = LBound(global_008291E8, 1) To UBound(global_008291E8, 1)
        achievementId = CLng(Val(CStr(global_008291E8(achievementIndex, 0))))
        badgePrefix = CStr(global_008291E8(achievementIndex, 1))
        If achievementId > 0 And Len(badgePrefix) > 0 Then
            progressRequired = CLng(Val(CStr(global_008291E8(achievementIndex, 2))))
            rewardIncrease = CLng(Val(CStr(global_008291E8(achievementIndex, 3))))
            levelTotal = CLng(Val(CStr(global_008291E8(achievementIndex, 4))))
            scoreIncrease = CLng(Val(CStr(global_008291E8(achievementIndex, 5))))
            rewardType = CLng(Val(CStr(global_008291E8(achievementIndex, 6))))
            If levelTotal <= 0 Then levelTotal = 1

            rowText = CStr(Proc_5_2_6D4690("SELECT REPLACE(id_badge,'" & Proc_10_11_80A9C0(badgePrefix, 0, 0) & "','') FROM users_badges WHERE id_user='" & _
                Proc_10_11_80A9C0(userId, 0, 0) & "' AND id_badge LIKE '" & Proc_10_11_80A9C0(badgePrefix, 0, 0) & "%' ORDER BY id DESC LIMIT 1", 0, 0))
            currentLevel = CLng(Val(rowText))
            If currentLevel < 0 Then currentLevel = 0
            If currentLevel > levelTotal Then currentLevel = levelTotal

            currentProgress = 0
            If currentLevel > 0 Then currentProgress = progressRequired * currentLevel
            If currentProgress < 0 Then currentProgress = 0

            entryPayload = CStr(Proc_3_0_6D2AF0(achievementId, Empty, vbNullString))
            entryPayload = CStr(Proc_3_0_6D2AF0(currentLevel, Empty, entryPayload))
            entryPayload = CStr(Proc_3_0_6D2AF0(currentProgress, Empty, entryPayload))
            entryPayload = CStr(Proc_3_0_6D2AF0(progressRequired, Empty, entryPayload))
            entryPayload = CStr(Proc_3_0_6D2AF0(rewardIncrease, Empty, entryPayload))
            entryPayload = CStr(Proc_3_0_6D2AF0(scoreIncrease, Empty, entryPayload))
            entryPayload = CStr(Proc_3_0_6D2AF0(rewardType, Empty, entryPayload))
            entryPayload = CStr(Proc_3_0_6D2AF0(levelTotal, Empty, entryPayload))
            entryPayload = entryPayload & badgePrefix & Chr$(2) & CStr(currentLevel) & Chr$(2)

            payload = payload & entryPayload
            achievementCount = achievementCount + 1
        End If
    Next achievementIndex

    Proc_6_244_801E80 socketIndex, CStr(Proc_3_0_6D2AF0(achievementCount, Empty, "Ft")) & payload, 0

SendFailed:
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
    Dim itemState As Long

    On Error GoTo BuildFailed
    If UBound(args) < 0 Then GoTo BuildFailed

    itemState = CLng(Val(CStr(args(0))))
    If itemState = 1507 Then
        Proc_6_218_7EA200 = "5;1;7;1;5;0;"
    Else
        Proc_6_218_7EA200 = vbNullString
    End If
    Exit Function

BuildFailed:
    Proc_6_218_7EA200 = vbNullString
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
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim requestPayload As String
    Dim offset As Long
    Dim requestedCount As Long
    Dim requestIndex As Long
    Dim cdId As Long
    Dim whereClause As String
    Dim rowText As String
    Dim rows() As String
    Dim fields() As String
    Dim rowIndex As Long
    Dim rowValue As String
    Dim responseCount As Long
    Dim cdPayload As String
    Dim rowPayload As String

    On Error GoTo SongInfoFailed

    socketIndex = HandlingSocketIndex(args)
    If socketIndex <= 0 Then GoTo SongInfoFailed

    If UBound(args) >= 1 Then packetPayload = CStr(args(1))
    If Left$(packetPayload, 2) = "C]" Then
        requestPayload = Mid$(packetPayload, 3)
    Else
        requestPayload = packetPayload
    End If

    offset = 1
    requestedCount = ReadWireLong(requestPayload, offset)
    If requestedCount <= 0 Then
        requestedCount = CLng(Val(CStr(Proc_10_6_809F10(requestPayload, 0, 0))))
        offset = offset + CLng(Proc_3_2_6D30A0(requestPayload, 0, 0))
    End If
    If requestedCount > 60 Then requestedCount = 60

    For requestIndex = 1 To requestedCount
        cdId = ReadWireLong(requestPayload, offset)
        If cdId > 0 Then
            If Len(whereClause) > 0 Then whereClause = whereClause & " OR "
            whereClause = whereClause & "id='" & CStr(cdId) & "'"
        End If
    Next requestIndex

    If Len(whereClause) > 0 Then
        rowText = CStr(Proc_5_2_6D4690("SELECT title,sequence,author,sound,id FROM soundmachine_cds WHERE " & _
            whereClause & " LIMIT " & CStr(requestedCount), 0, 0))
    End If

    If Len(rowText) > 0 Then
        rows = Split(rowText, Chr$(13))
        For rowIndex = LBound(rows) To UBound(rows)
            rowValue = Trim$(CStr(rows(rowIndex)))
            If Len(rowValue) > 0 Then
                fields = Split(rowValue, Chr$(9))
                If UBound(fields) >= 4 Then
                    rowPayload = CStr(Proc_3_0_6D2AF0(CLng(Val(HandlingField(fields, 4))), Empty, vbNullString))
                    rowPayload = CStr(Proc_3_0_6D2AF0(CLng(Val(HandlingField(fields, 1))), Empty, rowPayload))
                    rowPayload = rowPayload & HandlingField(fields, 0) & Chr$(2)
                    rowPayload = rowPayload & HandlingField(fields, 2) & Chr$(2)
                    rowPayload = rowPayload & HandlingField(fields, 3) & Chr$(2)
                    cdPayload = cdPayload & rowPayload
                    responseCount = responseCount + 1
                End If
            End If
        Next rowIndex
    End If

    Proc_6_244_801E80 socketIndex, CStr(Proc_3_0_6D2AF0(responseCount, Empty, "Dl")) & cdPayload, 0

SongInfoFailed:
    Proc_6_223_7EEDD0 = Empty
End Function

' Original declaration: Private Sub Proc_6_224_7EF5A0
Public Function Proc_6_224_7EF5A0(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim userId As String
    Dim roomId As Long
    Dim jukeboxId As Long
    Dim jukeboxRow As String
    Dim jukeboxFields() As String
    Dim activeDestinationId As Long
    Dim markerText As String

    On Error GoTo ClearDone

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 1 Then roomId = CLng(Val(CStr(args(1))))
    If UBound(args) >= 2 Then jukeboxId = CLng(Val(CStr(args(2))))

    If socketIndex > 0 Then
        userId = HandlingUserIdFromSocket(socketIndex)
        If Len(userId) > 0 And userId <> "0" Then
            If roomId <= 0 Then roomId = HandlingCurrentRoomId(socketIndex, userId)
        End If
    End If

    If jukeboxId <= 0 And roomId > 0 Then
        jukeboxRow = CStr(Proc_5_2_6D4690("SELECT furnitures.id,furnitures.id_product FROM furnitures,soundmachine_jb_playlist WHERE furnitures.id_room='" & _
            CStr(roomId) & "' AND soundmachine_jb_playlist.id_jukebox=furnitures.id GROUP BY furnitures.id ORDER BY furnitures.id DESC LIMIT 1", 0, 0))
        If Len(jukeboxRow) = 0 Then
            jukeboxRow = CStr(Proc_5_2_6D4690("SELECT furnitures.id,furnitures.id_product FROM furnitures,products WHERE furnitures.id_room='" & _
                CStr(roomId) & "' AND furnitures.id_product=products.id AND (products.action LIKE '%soundmachine%' OR products.action LIKE '%jukebox%' OR products.name LIKE '%jukebox%' OR products.sprite LIKE '%jukebox%') ORDER BY furnitures.id DESC LIMIT 1", 0, 0))
        End If
        If Len(jukeboxRow) > 0 Then
            jukeboxFields = Split(jukeboxRow, Chr$(9))
            jukeboxId = CLng(Val(HandlingField(jukeboxFields, 0)))
        End If
    End If

    If jukeboxId > 0 Then
        activeDestinationId = CLng(Val(CStr(Proc_5_2_6D4690("SELECT id_destination FROM soundmachine_jb_playlist WHERE id_jukebox='" & _
            CStr(jukeboxId) & "' AND id_order='0' LIMIT 1", 0, 0))))
        If activeDestinationId > 0 Then
            markerText = Chr$(1) & CStr(activeDestinationId) & Chr$(2)
            global_008291FC = Replace(global_008291FC, markerText, vbNullString, 1, 1, vbBinaryCompare)
        End If

        markerText = Chr$(1) & CStr(jukeboxId) & Chr$(2)
        global_008291FC = Replace(global_008291FC, markerText, vbNullString, 1, 1, vbBinaryCompare)
    End If

    representedSoundMachineStoppedAt = Now

ClearDone:
    Proc_6_224_7EF5A0 = Empty
End Function

' Original declaration: Private Sub Proc_6_225_7EFBD0
Public Function Proc_6_225_7EFBD0(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim userId As String
    Dim packetPayload As String
    Dim requestPayload As String
    Dim offset As Long
    Dim diskFurnitureId As Long
    Dim playlistOrder As Long
    Dim roomId As Long
    Dim jukeboxRow As String
    Dim jukeboxFields() As String
    Dim jukeboxId As Long
    Dim jukeboxProductId As Long
    Dim maxOrderText As String
    Dim maxOrder As Long
    Dim playlistLimit As Long
    Dim playlistCount As Long
    Dim songDiskProductId As Long
    Dim destinationId As Long

    On Error GoTo AddFailed

    socketIndex = HandlingSocketIndex(args)
    If socketIndex <= 0 Then GoTo AddFailed

    userId = HandlingUserIdFromSocket(socketIndex)
    If Len(userId) = 0 Or userId = "0" Then GoTo AddFailed

    If UBound(args) >= 1 Then packetPayload = CStr(args(1))
    If Left$(packetPayload, 2) = "C" & Chr$(127) Then
        requestPayload = Mid$(packetPayload, 3)
    Else
        requestPayload = packetPayload
    End If

    offset = 1
    diskFurnitureId = ReadWireLong(requestPayload, offset)
    playlistOrder = ReadWireLong(requestPayload, offset)
    If diskFurnitureId <= 0 Then GoTo AddFailed
    If playlistOrder < 0 Then playlistOrder = 0

    roomId = HandlingCurrentRoomId(socketIndex, userId)
    If roomId <= 0 Then GoTo AddFailed

    jukeboxRow = CStr(Proc_5_2_6D4690("SELECT furnitures.id,furnitures.id_product FROM furnitures,soundmachine_jb_playlist WHERE furnitures.id_room='" & _
        CStr(roomId) & "' AND soundmachine_jb_playlist.id_jukebox=furnitures.id GROUP BY furnitures.id ORDER BY furnitures.id DESC LIMIT 1", 0, 0))
    If Len(jukeboxRow) = 0 Then
        jukeboxRow = CStr(Proc_5_2_6D4690("SELECT furnitures.id,furnitures.id_product FROM furnitures,products WHERE furnitures.id_room='" & _
            CStr(roomId) & "' AND furnitures.id_product=products.id AND (products.action LIKE '%soundmachine%' OR products.action LIKE '%jukebox%' OR products.name LIKE '%jukebox%' OR products.sprite LIKE '%jukebox%') ORDER BY furnitures.id DESC LIMIT 1", 0, 0))
    End If
    If Len(jukeboxRow) = 0 Then GoTo AddFailed

    jukeboxFields = Split(jukeboxRow, Chr$(9))
    jukeboxId = CLng(Val(HandlingField(jukeboxFields, 0)))
    jukeboxProductId = CLng(Val(HandlingField(jukeboxFields, 1)))
    If jukeboxId <= 0 Then GoTo AddFailed

    maxOrderText = CStr(Proc_5_2_6D4690("SELECT MAX(id_order) FROM soundmachine_jb_playlist WHERE id_jukebox='" & CStr(jukeboxId) & "'", 0, 0))
    maxOrder = CLng(Val(maxOrderText))
    playlistCount = CLng(Val(CStr(Proc_5_2_6D4690("SELECT COUNT(*) FROM soundmachine_jb_playlist WHERE id_jukebox='" & CStr(jukeboxId) & "'", 0, 0))))
    playlistLimit = CLng(Val(CStr(Proc_10_0_809570("com.server.socket.game.jukebox." & CStr(jukeboxProductId) & ".soundsets.max", 0, 0))))
    If playlistLimit <= 0 Then playlistLimit = 100
    If playlistCount >= playlistLimit Then GoTo AddFailed

    If Len(maxOrderText) > 0 Then
        If playlistOrder <> maxOrder Then
            If playlistOrder <> maxOrder + 1 Then GoTo AddFailed
        End If
    Else
        If playlistOrder <> 0 Then GoTo AddFailed
    End If

    songDiskProductId = CLng(Val(CStr(Proc_10_0_809570("com.server.socket.game.default.songdisk", 0, 0))))
    If songDiskProductId <= 0 Then GoTo AddFailed

    destinationId = CLng(Val(CStr(Proc_5_2_6D4690("SELECT id_destination FROM furnitures WHERE id_owner='" & Proc_10_11_80A9C0(userId, 0, 0) & _
        "' AND id='" & CStr(diskFurnitureId) & "' AND id_product='" & CStr(songDiskProductId) & "' LIMIT 1", 0, 0))))
    If destinationId <= 0 Then GoTo AddFailed

    Proc_5_0_6D3CD0 "UPDATE furnitures SET id_owner=NULL WHERE id_owner='" & Proc_10_11_80A9C0(userId, 0, 0) & _
        "' AND id='" & CStr(diskFurnitureId) & "' AND id_product='" & CStr(songDiskProductId) & "' LIMIT 1", 0, 0
    Proc_5_0_6D3CD0 "INSERT INTO soundmachine_jb_playlist(id_jukebox,id_cd,id_order,id_destination) VALUES('" & _
        CStr(jukeboxId) & "','" & CStr(diskFurnitureId) & "','" & CStr(playlistOrder) & "','" & CStr(destinationId) & "')", 0, 0

    Proc_6_244_801E80 socketIndex, CStr(Proc_3_0_6D2AF0(diskFurnitureId, Empty, "Ac")), 0
    Proc_6_227_7F2400 socketIndex, 0, 0
    Proc_6_228_7F2AF0 socketIndex, 0, 0

AddFailed:
    Proc_6_225_7EFBD0 = Empty
End Function

' Original declaration: Private Sub Proc_6_226_7F0B20
Public Function Proc_6_226_7F0B20(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim userId As String
    Dim packetPayload As String
    Dim requestPayload As String
    Dim offset As Long
    Dim playlistOrder As Long
    Dim roomId As Long
    Dim jukeboxRow As String
    Dim jukeboxFields() As String
    Dim jukeboxId As Long
    Dim cdFurnitureId As Long
    Dim songDiskProductId As Long

    On Error GoTo RemoveFailed

    socketIndex = HandlingSocketIndex(args)
    If socketIndex <= 0 Then GoTo RemoveFailed

    userId = HandlingUserIdFromSocket(socketIndex)
    If Len(userId) = 0 Or userId = "0" Then GoTo RemoveFailed

    If UBound(args) >= 1 Then packetPayload = CStr(args(1))
    If Left$(packetPayload, 2) = "D@" Then
        requestPayload = Mid$(packetPayload, 3)
    Else
        requestPayload = packetPayload
    End If

    offset = 1
    playlistOrder = ReadWireLong(requestPayload, offset)
    If playlistOrder < 0 Then playlistOrder = 0

    roomId = HandlingCurrentRoomId(socketIndex, userId)
    If roomId <= 0 Then GoTo RemoveFailed

    jukeboxRow = CStr(Proc_5_2_6D4690("SELECT furnitures.id,furnitures.id_product FROM furnitures,soundmachine_jb_playlist WHERE furnitures.id_room='" & _
        CStr(roomId) & "' AND soundmachine_jb_playlist.id_jukebox=furnitures.id GROUP BY furnitures.id ORDER BY furnitures.id DESC LIMIT 1", 0, 0))
    If Len(jukeboxRow) = 0 Then
        jukeboxRow = CStr(Proc_5_2_6D4690("SELECT furnitures.id,furnitures.id_product FROM furnitures,products WHERE furnitures.id_room='" & _
            CStr(roomId) & "' AND furnitures.id_product=products.id AND (products.action LIKE '%soundmachine%' OR products.action LIKE '%jukebox%' OR products.name LIKE '%jukebox%' OR products.sprite LIKE '%jukebox%') ORDER BY furnitures.id DESC LIMIT 1", 0, 0))
    End If
    If Len(jukeboxRow) = 0 Then GoTo RemoveFailed

    jukeboxFields = Split(jukeboxRow, Chr$(9))
    jukeboxId = CLng(Val(HandlingField(jukeboxFields, 0)))
    If jukeboxId <= 0 Then GoTo RemoveFailed

    cdFurnitureId = CLng(Val(CStr(Proc_5_2_6D4690("SELECT id_cd FROM soundmachine_jb_playlist WHERE id_jukebox='" & _
        CStr(jukeboxId) & "' AND id_order='" & CStr(playlistOrder) & "' LIMIT 1", 0, 0))))
    If cdFurnitureId <= 0 Then GoTo RemoveFailed

    songDiskProductId = CLng(Val(CStr(Proc_10_0_809570("com.server.socket.game.default.songdisk", 0, 0))))
    If songDiskProductId > 0 Then
        Proc_5_0_6D3CD0 "UPDATE furnitures SET id_owner='" & Proc_10_11_80A9C0(userId, 0, 0) & "' WHERE id='" & _
            CStr(cdFurnitureId) & "' AND id_product='" & CStr(songDiskProductId) & "' LIMIT 1", 0, 0
    Else
        Proc_5_0_6D3CD0 "UPDATE furnitures SET id_owner='" & Proc_10_11_80A9C0(userId, 0, 0) & "' WHERE id='" & _
            CStr(cdFurnitureId) & "' LIMIT 1", 0, 0
    End If

    Proc_5_0_6D3CD0 "DELETE FROM soundmachine_jb_playlist WHERE id_jukebox='" & CStr(jukeboxId) & "' AND id_cd='" & _
        CStr(cdFurnitureId) & "' LIMIT 1", 0, 0
    Proc_5_0_6D3CD0 "UPDATE soundmachine_jb_playlist SET id_order=id_order-1 WHERE id_jukebox='" & _
        CStr(jukeboxId) & "' AND id_order>'" & CStr(playlistOrder) & "'", 0, 0

    Proc_6_227_7F2400 socketIndex, 0, 0
    Proc_6_228_7F2AF0 socketIndex, 0, 0

RemoveFailed:
    Proc_6_226_7F0B20 = Empty
End Function

' Original declaration: Private Sub Proc_6_227_7F2400
Public Function Proc_6_227_7F2400(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim userId As String
    Dim roomId As Long
    Dim jukeboxRow As String
    Dim jukeboxFields() As String
    Dim jukeboxId As Long
    Dim jukeboxProductId As Long
    Dim playlistLimit As Long
    Dim rowText As String
    Dim rows() As String
    Dim fields() As String
    Dim rowIndex As Long
    Dim rowValue As String
    Dim playlistCount As Long
    Dim playlistPayload As String
    Dim cdId As Long
    Dim destinationId As Long

    On Error GoTo PlaylistFailed

    socketIndex = HandlingSocketIndex(args)
    If socketIndex <= 0 Then GoTo PlaylistFailed

    userId = HandlingUserIdFromSocket(socketIndex)
    If Len(userId) = 0 Or userId = "0" Then GoTo PlaylistFailed

    roomId = HandlingCurrentRoomId(socketIndex, userId)
    If roomId <= 0 Then GoTo PlaylistFailed

    jukeboxRow = CStr(Proc_5_2_6D4690("SELECT furnitures.id,furnitures.id_product FROM furnitures,soundmachine_jb_playlist WHERE furnitures.id_room='" & _
        CStr(roomId) & "' AND soundmachine_jb_playlist.id_jukebox=furnitures.id GROUP BY furnitures.id ORDER BY furnitures.id DESC LIMIT 1", 0, 0))
    If Len(jukeboxRow) = 0 Then
        jukeboxRow = CStr(Proc_5_2_6D4690("SELECT furnitures.id,furnitures.id_product FROM furnitures,products WHERE furnitures.id_room='" & _
            CStr(roomId) & "' AND furnitures.id_product=products.id AND (products.action LIKE '%soundmachine%' OR products.action LIKE '%jukebox%' OR products.name LIKE '%jukebox%' OR products.sprite LIKE '%jukebox%') ORDER BY furnitures.id DESC LIMIT 1", 0, 0))
    End If

    If Len(jukeboxRow) = 0 Then GoTo PlaylistFailed
    jukeboxFields = Split(jukeboxRow, Chr$(9))
    jukeboxId = CLng(Val(HandlingField(jukeboxFields, 0)))
    jukeboxProductId = CLng(Val(HandlingField(jukeboxFields, 1)))
    If jukeboxId <= 0 Then GoTo PlaylistFailed

    playlistLimit = CLng(Val(CStr(Proc_10_0_809570("com.server.socket.game.jukebox." & CStr(jukeboxProductId) & ".soundsets.max", 0, 0))))
    If playlistLimit <= 0 Then playlistLimit = CLng(Val(CStr(Proc_5_2_6D4690("SELECT MAX(id_order)+1 FROM soundmachine_jb_playlist WHERE id_jukebox='" & CStr(jukeboxId) & "'", 0, 0))))
    If playlistLimit <= 0 Then playlistLimit = 100

    rowText = CStr(Proc_5_2_6D4690("SELECT id_cd,id_destination FROM soundmachine_jb_playlist WHERE id_jukebox='" & _
        CStr(jukeboxId) & "' ORDER BY id_order ASC LIMIT " & CStr(playlistLimit), 0, 0))
    If Len(rowText) > 0 Then
        rows = Split(rowText, Chr$(13))
        For rowIndex = LBound(rows) To UBound(rows)
            rowValue = Trim$(CStr(rows(rowIndex)))
            If Len(rowValue) > 0 Then
                fields = Split(rowValue, Chr$(9))
                cdId = CLng(Val(HandlingField(fields, 0)))
                destinationId = CLng(Val(HandlingField(fields, 1)))
                If cdId > 0 Then
                    playlistPayload = playlistPayload & CStr(Proc_3_0_6D2AF0(cdId, Empty, vbNullString))
                    playlistPayload = playlistPayload & CStr(Proc_3_0_6D2AF0(destinationId, Empty, vbNullString))
                    playlistCount = playlistCount + 1
                End If
            End If
        Next rowIndex
    End If

    Proc_6_244_801E80 socketIndex, CStr(Proc_3_0_6D2AF0(playlistLimit, Empty, CStr(Proc_3_0_6D2AF0(playlistCount, Empty, "EN")))) & playlistPayload, 0

PlaylistFailed:
    Proc_6_227_7F2400 = Empty
End Function

' Original declaration: Private Sub Proc_6_228_7F2AF0
Public Function Proc_6_228_7F2AF0(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim userId As String
    Dim songDiskProductId As Long
    Dim rowText As String
    Dim rows() As String
    Dim fields() As String
    Dim rowIndex As Long
    Dim diskCount As Long
    Dim diskPayload As String
    Dim rowValue As String
    Dim diskId As Long
    Dim destinationId As Long

    On Error GoTo DiskListFailed

    socketIndex = HandlingSocketIndex(args)
    userId = HandlingUserIdFromSocket(socketIndex)
    If Len(userId) = 0 Or userId = "0" Then GoTo DiskListFailed

    songDiskProductId = CLng(Val(CStr(Proc_10_0_809570("com.server.socket.game.default.songdisk", 0, 0))))
    If songDiskProductId <= 0 Then GoTo DiskListFailed

    rowText = CStr(Proc_5_2_6D4690("SELECT id,id_destination FROM furnitures WHERE id_owner='" & Proc_10_11_80A9C0(userId, 0, 0) & "' AND id_product='" & CStr(songDiskProductId) & "' LIMIT 250", 0, 0))
    If Len(rowText) > 0 Then
        rows = Split(rowText, Chr$(13))
        For rowIndex = LBound(rows) To UBound(rows)
            rowValue = Trim$(CStr(rows(rowIndex)))
            If Len(rowValue) > 0 Then
                fields = Split(rowValue, Chr$(9))
                diskId = CLng(Val(HandlingField(fields, 0)))
                destinationId = CLng(Val(HandlingField(fields, 1)))
                If diskId > 0 Then
                    diskPayload = diskPayload & CStr(Proc_3_0_6D2AF0(diskId, Empty, vbNullString))
                    diskPayload = diskPayload & CStr(Proc_3_0_6D2AF0(destinationId, Empty, vbNullString))
                    diskCount = diskCount + 1
                End If
            End If
        Next rowIndex
    End If

    Proc_6_244_801E80 socketIndex, CStr(Proc_3_0_6D2AF0(diskCount, Empty, "EM")) & diskPayload, 0

DiskListFailed:
    Proc_6_228_7F2AF0 = Empty
End Function

' Original declaration: Private Sub Proc_6_229_7F3070
Public Function Proc_6_229_7F3070(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim userId As String
    Dim roomId As Long
    Dim jukeboxId As Long
    Dim jukeboxRow As String
    Dim jukeboxFields() As String
    Dim rowText As String
    Dim fields() As String
    Dim destinationId As Long
    Dim diskFurnitureId As Long
    Dim sequenceId As Long
    Dim startedAt As Long
    Dim payload As String

    On Error GoTo PlaybackFailed

    socketIndex = HandlingSocketIndex(args)
    If socketIndex <= 0 Then GoTo PlaybackFailed

    If UBound(args) >= 1 Then roomId = CLng(Val(CStr(args(1))))
    If UBound(args) >= 2 Then jukeboxId = CLng(Val(CStr(args(2))))

    userId = HandlingUserIdFromSocket(socketIndex)
    If Len(userId) > 0 And userId <> "0" Then
        If roomId <= 0 Then roomId = HandlingCurrentRoomId(socketIndex, userId)
    End If

    If jukeboxId <= 0 And roomId > 0 Then
        jukeboxRow = CStr(Proc_5_2_6D4690("SELECT furnitures.id,furnitures.id_product FROM furnitures,soundmachine_jb_playlist WHERE furnitures.id_room='" & _
            CStr(roomId) & "' AND soundmachine_jb_playlist.id_jukebox=furnitures.id GROUP BY furnitures.id ORDER BY furnitures.id DESC LIMIT 1", 0, 0))
        If Len(jukeboxRow) = 0 Then
            jukeboxRow = CStr(Proc_5_2_6D4690("SELECT furnitures.id,furnitures.id_product FROM furnitures,products WHERE furnitures.id_room='" & _
                CStr(roomId) & "' AND furnitures.id_product=products.id AND (products.action LIKE '%soundmachine%' OR products.action LIKE '%jukebox%' OR products.name LIKE '%jukebox%' OR products.sprite LIKE '%jukebox%') ORDER BY furnitures.id DESC LIMIT 1", 0, 0))
        End If
        If Len(jukeboxRow) > 0 Then
            jukeboxFields = Split(jukeboxRow, Chr$(9))
            jukeboxId = CLng(Val(HandlingField(jukeboxFields, 0)))
        End If
    End If
    If jukeboxId <= 0 Then GoTo PlaybackFailed

    rowText = CStr(Proc_5_2_6D4690("SELECT soundmachine_jb_playlist.id_destination,soundmachine_jb_playlist.id_cd,soundmachine_cds.sequence FROM soundmachine_jb_playlist,soundmachine_cds WHERE soundmachine_jb_playlist.id_jukebox='" & _
        CStr(jukeboxId) & "' AND soundmachine_jb_playlist.id_order='0' AND soundmachine_cds.id=soundmachine_jb_playlist.id_destination GROUP BY soundmachine_cds.id LIMIT 1", 0, 0))
    If Len(rowText) = 0 Then GoTo PlaybackFailed

    fields = Split(rowText, Chr$(9))
    destinationId = CLng(Val(HandlingField(fields, 0)))
    diskFurnitureId = CLng(Val(HandlingField(fields, 1)))
    sequenceId = CLng(Val(HandlingField(fields, 2)))
    If destinationId <= 0 Or sequenceId <= 0 Then GoTo PlaybackFailed

    startedAt = CLng(DateDiff("s", DateSerial(1970, 1, 1), Now))
    payload = CStr(Proc_3_0_6D2AF0(startedAt, Empty, "EG"))
    payload = CStr(Proc_3_0_6D2AF0(sequenceId, Empty, payload))
    payload = CStr(Proc_3_0_6D2AF0(destinationId, Empty, payload))
    payload = CStr(Proc_3_0_6D2AF0(diskFurnitureId, Empty, payload))
    payload = CStr(Proc_3_0_6D2AF0(0, Empty, CStr(Proc_3_0_6D2AF0(0, Empty, payload))))

    If roomId > 0 Then
        Proc_6_246_8024C0 roomId, payload, 0
    Else
        Proc_6_247_8027E0 socketIndex, payload, 0
    End If

PlaybackFailed:
    Proc_6_229_7F3070 = Empty
End Function

' Original declaration: Private Sub Proc_6_230_7F3D20
Public Function Proc_6_230_7F3D20(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim requestPayload As String
    Dim userId As String
    Dim rawMotto As String
    Dim mottoText As String
    Dim rowText As String
    Dim fields() As String
    Dim figureText As String
    Dim genderText As String
    Dim offset As Long

    On Error GoTo MottoFailed

    socketIndex = HandlingSocketIndex(args)
    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    If Len(packetPayload) = 0 And UBound(args) >= 1 Then packetPayload = CStr(args(1))

    requestPayload = packetPayload
    If Left$(requestPayload, 2) = "Gd" Then requestPayload = Mid$(requestPayload, 3)

    offset = 1
    rawMotto = ReadWireString(requestPayload, offset)
    If Len(rawMotto) = 0 Then rawMotto = CStr(Proc_10_7_80A190(requestPayload, 0, 0))
    If Len(rawMotto) = 0 Then rawMotto = requestPayload

    mottoText = Left$(CStr(Proc_10_10_80A7F0(rawMotto, 0, 0)), 255)

    userId = HandlingUserIdFromSocket(socketIndex)
    If Len(userId) = 0 Or userId = "0" Then GoTo MottoFailed

    Proc_5_0_6D3CD0 "UPDATE users SET motto='" & Proc_10_11_80A9C0(mottoText, 0, 0) & "' WHERE id='" & Proc_10_11_80A9C0(userId, 0, 0) & "'", 0, 0

    rowText = CStr(Proc_5_2_6D4690("SELECT figure,gender FROM users WHERE id='" & Proc_10_11_80A9C0(userId, 0, 0) & "' LIMIT 1", 0, 0))
    If Len(rowText) > 0 Then
        fields = Split(rowText, Chr$(9))
        figureText = HandlingField(fields, 0)
        genderText = UCase$(Left$(HandlingField(fields, 1), 1))
    End If
    If genderText <> "M" And genderText <> "F" Then genderText = "M"

    Proc_6_244_801E80 socketIndex, UserIdentityPayload(CLng(Val(userId)), mottoText, genderText, figureText), 0

MottoFailed:
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
    Dim socketIndex As Integer
    Dim userId As String
    Dim packetPayload As String
    Dim requestPayload As String
    Dim offset As Long
    Dim requestedQuestId As Long
    Dim questRows() As String
    Dim questFields() As String
    Dim questRow As String
    Dim questIndex As Long
    Dim questId As Long
    Dim existingLevelText As String
    Dim progressValue As Long
    Dim activityCount As Long
    Dim waitAmount As Long
    Dim timeNextText As String
    Dim matchedQuest As Boolean

    On Error GoTo QuestAcceptFailed

    socketIndex = HandlingSocketIndex(args)
    userId = HandlingUserIdFromSocket(socketIndex)
    If Len(userId) = 0 Or userId = "0" Then GoTo QuestAcceptFailed

    If UBound(args) >= 2 Then packetPayload = CStr(args(2))
    If Len(packetPayload) = 0 And UBound(args) >= 1 Then packetPayload = CStr(args(1))
    requestPayload = packetPayload
    If Left$(requestPayload, 2) = "p^" Then requestPayload = Mid$(requestPayload, 3)

    offset = 1
    requestedQuestId = ReadWireLong(requestPayload, offset)
    If requestedQuestId <= 0 Then requestedQuestId = CLng(Val(CStr(Proc_10_6_809F10(requestPayload, 0, 0))))
    If requestedQuestId <= 0 Then GoTo QuestAcceptFailed

    If Len(global_00829080) > 0 Then
        questRows = Split(global_00829080, Chr$(13))
    Else
        questRows = Split(CStr(Proc_5_2_6D4690("SELECT id,level,name,NULL,reward,reward_type,require_action,id_additional,id_campaign,amount_activities,waitamount FROM quests ORDER BY id_campaign DESC,level ASC", 0, 0)), Chr$(13))
    End If

    For questIndex = LBound(questRows) To UBound(questRows)
        questRow = Trim$(CStr(questRows(questIndex)))
        If Len(questRow) > 0 Then
            questFields = Split(questRow, Chr$(9))
            If UBound(questFields) >= 10 Then
                questId = CLng(Val(HandlingField(questFields, 0)))
                If questId = requestedQuestId Then
                    activityCount = CLng(Val(HandlingField(questFields, 9)))
                    waitAmount = CLng(Val(HandlingField(questFields, 10)))
                    matchedQuest = True
                    Exit For
                End If
            End If
        End If
    Next questIndex
    If Not matchedQuest Then GoTo QuestAcceptFailed
    If activityCount <= 0 Then activityCount = 1

    Proc_5_0_6D3CD0 "UPDATE users_quests SET timestamp_accepted=NULL WHERE id_user='" & _
        Proc_10_11_80A9C0(userId, 0, 0) & "' AND timestamp_accepted IS NOT NULL AND timestamp_done IS NULL LIMIT 1", 0, 0

    existingLevelText = CStr(Proc_5_2_6D4690("SELECT id_level FROM users_quests WHERE id_user='" & _
        Proc_10_11_80A9C0(userId, 0, 0) & "' AND id_quest='" & CStr(questId) & "' LIMIT 1", 0, 0))
    If Len(existingLevelText) > 0 Then
        Proc_5_0_6D3CD0 "UPDATE users_quests SET timestamp_done=NULL,timestamp_accepted=UNIX_TIMESTAMP(),id_numericquest='" & _
            CStr(requestedQuestId) & "',time_next=NULL WHERE id_user='" & Proc_10_11_80A9C0(userId, 0, 0) & _
            "' AND id_quest='" & CStr(questId) & "' LIMIT 1", 0, 0
    Else
        Proc_5_0_6D3CD0 "INSERT INTO users_quests(id_user,id_quest,id_level,id_numericquest,timestamp_accepted) VALUES('" & _
            Proc_10_11_80A9C0(userId, 0, 0) & "','" & CStr(questId) & "','0','" & CStr(requestedQuestId) & "',UNIX_TIMESTAMP())", 0, 0
    End If

    progressValue = CLng(Val(CStr(Proc_5_2_6D4690("SELECT progress FROM users_quests WHERE id_user='" & _
        Proc_10_11_80A9C0(userId, 0, 0) & "' AND id_quest='" & CStr(questId) & "' LIMIT 1", 0, 0))))
    If waitAmount > 0 And progressValue > 0 And progressValue < activityCount Then
        timeNextText = CStr(Proc_5_2_6D4690("SELECT time_next FROM users_quests WHERE id_user='" & _
            Proc_10_11_80A9C0(userId, 0, 0) & "' AND id_quest='" & CStr(questId) & "' LIMIT 1", 0, 0))
        If Len(timeNextText) = 0 Or timeNextText = "0" Then
            Proc_5_0_6D3CD0 "UPDATE users_quests SET time_next=DATE_ADD(NOW(),INTERVAL " & CStr(waitAmount) & _
                " SECOND) WHERE id_user='" & Proc_10_11_80A9C0(userId, 0, 0) & "' AND id_quest='" & CStr(questId) & "' LIMIT 1", 0, 0
        End If
    End If

    If progressValue >= activityCount Then
        Proc_6_164_7BC820 socketIndex, questId, requestedQuestId
    Else
        Proc_6_236_7F8540 socketIndex, Empty, Empty
    End If

QuestAcceptFailed:
    Proc_6_232_7F45A0 = Empty
End Function

' Original declaration: Private Sub Proc_6_233_7F5D60
Public Function Proc_6_233_7F5D60(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim userId As String
    Dim activeRow As String
    Dim activeFields() As String
    Dim questRows() As String
    Dim questFields() As String
    Dim questRow As String
    Dim questIndex As Long
    Dim currentQuestId As Long
    Dim currentCampaignId As Long
    Dim currentLevel As Long
    Dim requestedQuestId As Long
    Dim fallbackQuestId As Long
    Dim fallbackCampaignId As Long
    Dim fallbackLevel As Long
    Dim rowQuestId As Long
    Dim rowLevel As Long
    Dim rowCampaignId As Long
    Dim bestLevel As Long
    Dim foundCurrent As Boolean

    On Error GoTo QuestNextFailed

    socketIndex = HandlingSocketIndex(args)
    userId = HandlingUserIdFromSocket(socketIndex)
    If Len(userId) = 0 Or userId = "0" Then GoTo QuestNextFailed

    If Len(global_00829080) > 0 Then
        questRows = Split(global_00829080, Chr$(13))
    Else
        questRows = Split(CStr(Proc_5_2_6D4690("SELECT id,level,name,NULL,reward,reward_type,require_action,id_additional,id_campaign,amount_activities,waitamount FROM quests ORDER BY id_campaign DESC,level ASC", 0, 0)), Chr$(13))
    End If

    activeRow = CStr(Proc_5_2_6D4690("SELECT id_quest,id_level FROM users_quests WHERE id_user='" & _
        Proc_10_11_80A9C0(userId, 0, 0) & "' AND timestamp_accepted IS NOT NULL AND timestamp_done IS NULL LIMIT 1", 0, 0))
    If Len(activeRow) = 0 Then
        activeRow = CStr(Proc_5_2_6D4690("SELECT id_quest,id_level FROM users_quests WHERE id_user='" & _
            Proc_10_11_80A9C0(userId, 0, 0) & "' ORDER BY timestamp_done DESC,timestamp_accepted DESC,id_level DESC LIMIT 1", 0, 0))
    End If
    If Len(activeRow) > 0 Then
        activeFields = Split(activeRow, Chr$(9))
        currentQuestId = CLng(Val(HandlingField(activeFields, 0)))
        currentLevel = CLng(Val(HandlingField(activeFields, 1)))
    End If

    fallbackLevel = 2147483647
    For questIndex = LBound(questRows) To UBound(questRows)
        questRow = Trim$(CStr(questRows(questIndex)))
        If Len(questRow) > 0 Then
            questFields = Split(questRow, Chr$(9))
            If UBound(questFields) >= 8 Then
                rowQuestId = CLng(Val(HandlingField(questFields, 0)))
                rowLevel = CLng(Val(HandlingField(questFields, 1)))
                rowCampaignId = CLng(Val(HandlingField(questFields, 8)))
                If fallbackQuestId <= 0 Or rowLevel < fallbackLevel Then
                    fallbackQuestId = rowQuestId
                    fallbackCampaignId = rowCampaignId
                    fallbackLevel = rowLevel
                End If
                If rowQuestId = currentQuestId Then
                    currentCampaignId = rowCampaignId
                    currentLevel = rowLevel
                    foundCurrent = True
                End If
            End If
        End If
    Next questIndex

    If Not foundCurrent Then
        currentCampaignId = fallbackCampaignId
        currentLevel = fallbackLevel - 1
    End If

    bestLevel = 2147483647
    For questIndex = LBound(questRows) To UBound(questRows)
        questRow = Trim$(CStr(questRows(questIndex)))
        If Len(questRow) > 0 Then
            questFields = Split(questRow, Chr$(9))
            If UBound(questFields) >= 8 Then
                rowQuestId = CLng(Val(HandlingField(questFields, 0)))
                rowLevel = CLng(Val(HandlingField(questFields, 1)))
                rowCampaignId = CLng(Val(HandlingField(questFields, 8)))
                If rowCampaignId = currentCampaignId And rowLevel > currentLevel And rowLevel < bestLevel Then
                    requestedQuestId = rowQuestId
                    bestLevel = rowLevel
                End If
            End If
        End If
    Next questIndex

    If requestedQuestId <= 0 Then requestedQuestId = fallbackQuestId
    If requestedQuestId <= 0 Then GoTo QuestNextFailed

    Proc_6_232_7F45A0 socketIndex, "p^" & CStr(Proc_3_0_6D2AF0(requestedQuestId, Empty, vbNullString)), 0

QuestNextFailed:
    Proc_6_233_7F5D60 = Empty
End Function

' Original declaration: Private Sub Proc_6_234_7F75C0
Public Function Proc_6_234_7F75C0(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim userId As String

    On Error GoTo QuestResetFailed

    socketIndex = HandlingSocketIndex(args)
    userId = HandlingUserIdFromSocket(socketIndex)
    If Len(userId) = 0 Or userId = "0" Then GoTo QuestResetFailed

    Proc_5_0_6D3CD0 "UPDATE users_quests SET timestamp_done=NULL,timestamp_accepted=NULL WHERE id_user='" & Proc_10_11_80A9C0(userId, 0, 0) & "' LIMIT 50", 0, 0
    Proc_6_244_801E80 socketIndex, "Lc", 0
    Proc_6_236_7F8540 socketIndex, Empty, Empty

QuestResetFailed:
    Proc_6_234_7F75C0 = Empty
End Function

' Original declaration: Private Sub Proc_6_235_7F77E0
Public Function Proc_6_235_7F77E0(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim userId As String
    Dim activeRow As String
    Dim activeFields() As String
    Dim questRows() As String
    Dim questFields() As String
    Dim questRow As String
    Dim questId As Long
    Dim numericQuestId As Long
    Dim progressValue As Long
    Dim userQuestLevel As Long
    Dim timeNextText As String
    Dim amountRequired As Long
    Dim waitAmount As Long
    Dim questIndex As Long
    Dim remainingWait As Long
    Dim matchedQuest As Boolean

    On Error GoTo QuestProgressFailed

    socketIndex = HandlingSocketIndex(args)
    userId = HandlingUserIdFromSocket(socketIndex)
    If Len(userId) = 0 Or userId = "0" Then GoTo QuestProgressFailed

    activeRow = CStr(Proc_5_2_6D4690("SELECT id_quest,id_numericquest,progress,id_level,time_next FROM users_quests WHERE id_user='" & _
        Proc_10_11_80A9C0(userId, 0, 0) & "' AND timestamp_accepted IS NOT NULL AND timestamp_done IS NULL LIMIT 1", 0, 0))
    If Len(activeRow) = 0 Then GoTo QuestProgressFailed

    activeFields = Split(activeRow, Chr$(9))
    questId = CLng(Val(HandlingField(activeFields, 0)))
    numericQuestId = CLng(Val(HandlingField(activeFields, 1)))
    progressValue = CLng(Val(HandlingField(activeFields, 2)))
    userQuestLevel = CLng(Val(HandlingField(activeFields, 3)))
    timeNextText = HandlingField(activeFields, 4)
    If questId <= 0 Then GoTo QuestProgressFailed

    If Len(global_00829080) > 0 Then
        questRows = Split(global_00829080, Chr$(13))
    Else
        questRows = Split(CStr(Proc_5_2_6D4690("SELECT id,level,name,NULL,reward,reward_type,require_action,id_additional,id_campaign,amount_activities,waitamount FROM quests ORDER BY id_campaign DESC,level ASC", 0, 0)), Chr$(13))
    End If

    For questIndex = LBound(questRows) To UBound(questRows)
        questRow = Trim$(CStr(questRows(questIndex)))
        If Len(questRow) > 0 Then
            questFields = Split(questRow, Chr$(9))
            If UBound(questFields) >= 10 Then
                If CLng(Val(HandlingField(questFields, 0))) = questId Then
                    amountRequired = CLng(Val(HandlingField(questFields, 9)))
                    waitAmount = CLng(Val(HandlingField(questFields, 10)))
                    matchedQuest = True
                    Exit For
                End If
            End If
        End If
    Next questIndex
    If Not matchedQuest Then GoTo QuestProgressFailed

    If Len(timeNextText) > 0 And timeNextText <> "0" Then
        remainingWait = CLng(Val(CStr(Proc_5_2_6D4690("SELECT GREATEST(0,UNIX_TIMESTAMP('" & _
            Proc_10_11_80A9C0(timeNextText, 0, 0) & "')-UNIX_TIMESTAMP())", 0, 0))))
        If remainingWait > 0 Then
            Proc_6_236_7F8540 socketIndex, Empty, Empty
            GoTo QuestProgressFailed
        End If
    ElseIf waitAmount > 0 And progressValue > 0 And progressValue < amountRequired Then
        Proc_5_0_6D3CD0 "UPDATE users_quests SET time_next=DATE_ADD(NOW(),INTERVAL " & CStr(waitAmount) & _
            " SECOND) WHERE id_user='" & Proc_10_11_80A9C0(userId, 0, 0) & "' AND id_quest='" & CStr(questId) & "' LIMIT 1", 0, 0
        Proc_6_236_7F8540 socketIndex, Empty, Empty
        GoTo QuestProgressFailed
    End If

    If amountRequired <= 0 Then amountRequired = 1
    If progressValue >= amountRequired Then
        Proc_6_164_7BC820 socketIndex, questId, numericQuestId
    Else
        Proc_6_236_7F8540 socketIndex, Empty, Empty
    End If

QuestProgressFailed:
    Proc_6_235_7F77E0 = Empty
End Function

' Original declaration: Private Sub Proc_6_236_7F8540
Public Function Proc_6_236_7F8540(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim userId As String
    Dim userQuestRows() As String
    Dim questRows() As String
    Dim userQuestFields() As String
    Dim questFields() As String
    Dim userQuestRow As String
    Dim questRow As String
    Dim userQuestText As String
    Dim questId As Long
    Dim userQuestId As Long
    Dim questLevel As Long
    Dim userLevel As Long
    Dim timestampDone As String
    Dim timestampAccepted As String
    Dim timeNextText As String
    Dim progressValue As Long
    Dim waitSeconds As Long
    Dim questCount As Long
    Dim campaignId As Long
    Dim lastCampaignId As Long
    Dim campaignLevelCount As Long
    Dim rowIndex As Long
    Dim questIndex As Long
    Dim questPayload As String
    Dim rowPayload As String
    Dim questName As String
    Dim rewardType As Long
    Dim rewardAmount As Long
    Dim activityCount As Long
    Dim stateCode As Long

    On Error GoTo QuestListFailed

    socketIndex = HandlingSocketIndex(args)
    userId = HandlingUserIdFromSocket(socketIndex)
    If Len(userId) = 0 Or userId = "0" Then GoTo QuestListFailed

    userQuestText = CStr(Proc_5_2_6D4690("SELECT id_quest,id_level,timestamp_done,timestamp_accepted,time_next,progress FROM users_quests WHERE id_user='" & _
        Proc_10_11_80A9C0(userId, 0, 0) & "' LIMIT 250", Chr$(13), 0))
    userQuestText = Chr$(13) & userQuestText & Chr$(13)

    If Len(global_00829080) > 0 Then
        questRows = Split(global_00829080, Chr$(13))
    Else
        questRows = Split(CStr(Proc_5_2_6D4690("SELECT id,level,name,NULL,reward,reward_type,require_action,id_additional,id_campaign,amount_activities,waitamount FROM quests ORDER BY id_campaign DESC,level ASC", 0, 0)), Chr$(13))
    End If

    lastCampaignId = -1
    campaignLevelCount = 0

    For questIndex = LBound(questRows) To UBound(questRows)
        questRow = Trim$(CStr(questRows(questIndex)))
        If Len(questRow) > 0 Then
            questFields = Split(questRow, Chr$(9))
            If UBound(questFields) >= 10 Then
                questId = CLng(Val(HandlingField(questFields, 0)))
                questLevel = CLng(Val(HandlingField(questFields, 1)))
                questName = HandlingField(questFields, 2)
                rewardAmount = CLng(Val(HandlingField(questFields, 4)))
                rewardType = CLng(Val(HandlingField(questFields, 5)))
                campaignId = CLng(Val(HandlingField(questFields, 8)))
                activityCount = CLng(Val(HandlingField(questFields, 9)))
                waitSeconds = CLng(Val(HandlingField(questFields, 10)))

                If campaignId <> lastCampaignId Then
                    lastCampaignId = campaignId
                    campaignLevelCount = 0
                End If
                campaignLevelCount = campaignLevelCount + 1

                userQuestId = 0
                userLevel = 0
                timestampDone = vbNullString
                timestampAccepted = vbNullString
                timeNextText = vbNullString
                progressValue = 0

                userQuestRows = Split(userQuestText, Chr$(13) & CStr(questId) & Chr$(9), -1, vbBinaryCompare)
                If UBound(userQuestRows) > 0 Then
                    userQuestRow = Split(CStr(userQuestRows(1)), Chr$(13), -1, vbBinaryCompare)(0)
                    userQuestFields = Split(CStr(questId) & Chr$(9) & userQuestRow, Chr$(9))
                    userQuestId = CLng(Val(HandlingField(userQuestFields, 0)))
                    userLevel = CLng(Val(HandlingField(userQuestFields, 1)))
                    timestampDone = HandlingField(userQuestFields, 2)
                    timestampAccepted = HandlingField(userQuestFields, 3)
                    timeNextText = HandlingField(userQuestFields, 4)
                    progressValue = CLng(Val(HandlingField(userQuestFields, 5)))
                End If

                stateCode = 0
                If Len(timestampDone) > 0 And timestampDone <> "0" Then
                    stateCode = 2
                ElseIf Len(timestampAccepted) > 0 And timestampAccepted <> "0" Then
                    stateCode = 1
                End If

                If Len(timeNextText) > 0 And timeNextText <> "0" Then
                    waitSeconds = CLng(Val(CStr(Proc_5_2_6D4690("SELECT GREATEST(0,UNIX_TIMESTAMP('" & _
                        Proc_10_11_80A9C0(timeNextText, 0, 0) & "')-UNIX_TIMESTAMP())", 0, 0))))
                End If

                rowPayload = CStr(Proc_3_0_6D2AF0(campaignId, Empty, vbNullString)) & questName & Chr$(2)
                rowPayload = rowPayload & CStr(Proc_3_0_6D2AF0(questId, Empty, vbNullString))
                rowPayload = rowPayload & CStr(Proc_3_0_6D2AF0(questLevel, Empty, vbNullString))
                rowPayload = rowPayload & CStr(Proc_3_0_6D2AF0(campaignLevelCount, Empty, vbNullString))
                rowPayload = rowPayload & CStr(Proc_3_0_6D2AF0(stateCode, Empty, vbNullString))
                rowPayload = rowPayload & CStr(Proc_3_0_6D2AF0(userLevel, Empty, vbNullString))
                rowPayload = rowPayload & CStr(Proc_3_0_6D2AF0(progressValue, Empty, vbNullString))
                rowPayload = rowPayload & CStr(Proc_3_0_6D2AF0(activityCount, Empty, vbNullString))
                rowPayload = rowPayload & CStr(Proc_3_0_6D2AF0(rewardType, Empty, vbNullString))
                rowPayload = rowPayload & CStr(Proc_3_0_6D2AF0(rewardAmount, Empty, vbNullString))
                rowPayload = rowPayload & "HHH" & Chr$(2) & Chr$(2) & "H" & Chr$(2) & "HHH"
                rowPayload = rowPayload & CStr(Proc_3_0_6D2AF0(waitSeconds, Empty, vbNullString))

                questPayload = questPayload & rowPayload
                questCount = questCount + 1
            End If
        End If
    Next questIndex

    Proc_6_244_801E80 socketIndex, CStr(Proc_3_0_6D2AF0(0, Empty, CStr(Proc_3_0_6D2AF0(questCount, Empty, "L`")))) & questPayload, 0

QuestListFailed:
    Proc_6_236_7F8540 = Empty
End Function

' Original declaration: Private Sub Proc_6_237_7F9ED0
Public Function Proc_6_237_7F9ED0(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim userId As String
    Dim rowText As String
    Dim fields() As String
    Dim userName As String
    Dim mottoText As String
    Dim genderText As String
    Dim respectAmount As Long
    Dim scratchAmount As Long
    Dim payload As String

    On Error GoTo SendFailed

    socketIndex = HandlingSocketIndex(args)
    userId = HandlingUserIdFromSocket(socketIndex)
    If Len(userId) = 0 Or userId = "0" Then GoTo SendFailed

    rowText = CStr(Proc_5_2_6D4690("SELECT id,name,motto,gender,respect_amount,scratch_amount FROM users WHERE id='" & Proc_10_11_80A9C0(userId, 0, 0) & "' LIMIT 1", 0, 0))
    If Len(rowText) = 0 Then GoTo SendFailed

    fields = Split(rowText, Chr$(9))
    If UBound(fields) < 5 Then GoTo SendFailed

    userId = CStr(Val(CStr(fields(0))))
    userName = CStr(fields(1))
    mottoText = CStr(fields(2))
    genderText = UCase$(Left$(CStr(fields(3)), 1))
    If genderText <> "M" And genderText <> "F" Then genderText = "M"
    respectAmount = CLng(Val(CStr(fields(4))))
    scratchAmount = CLng(Val(CStr(fields(5))))

    payload = "@E" & userId & Chr$(2) & userName & Chr$(2) & mottoText & Chr$(2)
    payload = payload & genderText & Chr$(2) & Chr$(2) & Chr$(2) & "H" & Chr$(2) & "HIH"
    payload = CStr(Proc_3_0_6D2AF0(respectAmount, Empty, payload))
    payload = CStr(Proc_3_0_6D2AF0(scratchAmount, Empty, payload))

    Proc_6_244_801E80 socketIndex, payload, 0
    Proc_6_237_7F9ED0 = payload
    Exit Function

SendFailed:
    Proc_6_237_7F9ED0 = Empty
End Function

' Original declaration: Private Sub Proc_6_238_7FA670
Public Function Proc_6_238_7FA670(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim userId As String
    Dim sessionSeconds As Long
    Dim pointType As Long
    Dim intervalSeconds As Long
    Dim maxPoints As Long
    Dim awardAmount As Long
    Dim currentPoints As Long
    Dim newPoints As Long
    Dim columnName As String

    On Error GoTo AwardFailed

    socketIndex = HandlingSocketIndex(args)
    userId = HandlingUserIdFromSocket(socketIndex)
    If Len(userId) = 0 Or userId = "0" Then GoTo AwardFailed

    sessionSeconds = RepresentedActivityPointSessionSeconds(socketIndex, userId)
    If sessionSeconds <= 0 Then GoTo AwardFailed

    For pointType = 0 To 4
        intervalSeconds = CLng(Val(CStr(Proc_10_0_809570("com.server.socket.game.activitypoints_" & CStr(pointType) & ".interval", 0, 0))))
        If intervalSeconds > 0 Then
            If (sessionSeconds Mod intervalSeconds) = 0 Then
                columnName = "activitypoints_" & CStr(pointType)
                maxPoints = CLng(Val(CStr(Proc_10_0_809570("com.server.socket.game.activitypoints_" & CStr(pointType) & ".max", 1, 0))))
                currentPoints = CLng(Val(CStr(Proc_5_2_6D4690("SELECT " & columnName & " FROM users WHERE id='" & Proc_10_11_80A9C0(userId, 0, 0) & "' LIMIT 1", 0, 0))))
                If currentPoints < maxPoints Then
                    awardAmount = CLng(Val(CStr(Proc_10_0_809570("com.server.socket.game.activitypoints_" & CStr(pointType) & ".amount", 0, 0))))
                    If awardAmount <> 0 Then
                        Proc_5_0_6D3CD0 "UPDATE users SET " & columnName & "=" & columnName & "+" & CStr(awardAmount) & " WHERE id='" & Proc_10_11_80A9C0(userId, 0, 0) & "'", 0, 0
                        newPoints = currentPoints + awardAmount
                        Proc_6_244_801E80 socketIndex, RepresentedActivityPointAwardPayload(pointType, newPoints), 0
                    End If
                End If
            End If
        End If
    Next pointType

AwardFailed:
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
        Case "AZ"
            Proc_6_144_76BE70 socketIndex, "AZ", packetPayload
        Case "AC"
            Proc_6_155_795C90 socketIndex, "AC", packetPayload
        Case "A["
            Proc_6_141_76A670 socketIndex, "A[", packetPayload
        Case "rv"
            Proc_6_142_76B310 socketIndex, "rv", packetPayload
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
        Case "Cj"
            Proc_6_201_7D5AC0 socketIndex, "Cj", packetPayload
        Case "Ck"
            Proc_6_199_7D54E0 socketIndex, "Ck", packetPayload
        Case "Cl"
            Proc_6_200_7D5770 socketIndex, "Cl", packetPayload
        Case "EW"
            Proc_6_99_748460 socketIndex, "EW", packetPayload
        Case "Cw"
            Proc_6_95_746CD0 socketIndex, "Cw", packetPayload
        Case "AL"
            Proc_6_97_747640 socketIndex, "AL", packetPayload
        Case "AM"
            Proc_6_96_747000 socketIndex, "AM", packetPayload
        Case "FU"
            Proc_6_91_743480 socketIndex, "FU", packetPayload
        Case "AH"
            Proc_6_92_744870 socketIndex, "AH", packetPayload
        Case "FR"
            Proc_6_89_73EA10 socketIndex, "FR", packetPayload
        Case "EV"
            Proc_6_100_748C80 socketIndex, "EV", packetPayload
        Case "EU"
            Proc_6_98_747D80 socketIndex, "EU", packetPayload
        Case "Er"
            Proc_6_206_7DA450 socketIndex, "Er", packetPayload
        Case "@G"
            Proc_6_237_7F9ED0 socketIndex, "@G", packetPayload
        Case "@t"
            Proc_6_26_7034C0 socketIndex, "@t", packetPayload
        Case "@w"
            Proc_6_27_706920 socketIndex, "@w", packetPayload
        Case "@x"
            Proc_6_28_709DA0 socketIndex, "@x", packetPayload
        Case "Cd"
            Proc_6_101_749540 socketIndex, "EA", packetPayload
        Case "@Z"
            Proc_6_19_6E8040 socketIndex, global_0082912C, "Gz"
        Case "oW"
            Proc_6_18_6E7480 socketIndex, "GY", packetPayload
        Case "A^"
            Proc_6_13_6E0A80 socketIndex, "A^", packetPayload
        Case "A]"
            Proc_6_14_6E10C0 socketIndex, "A]", packetPayload
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
        Case "@]"
            Proc_6_105_74AD50 socketIndex, "@]", packetPayload
        Case "Af"
            Proc_6_136_765F10 socketIndex, "Af", packetPayload
        Case "Ew"
            Proc_6_15_6E1900 socketIndex, "Ew", packetPayload
        Case "Ex"
            Proc_6_16_6E2320 socketIndex, "Ex", packetPayload
        Case "@l"
            Proc_6_17_6E48D0 socketIndex, "@l", packetPayload
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
        Case "Ab"
            Proc_6_50_7166B0 socketIndex, "Ab", packetPayload
        Case "EZ"
            Proc_6_48_7151E0 socketIndex, "EZ", packetPayload
        Case "E\"
            Proc_6_49_715D30 socketIndex, "E\", packetPayload
        Case "FF"
            Proc_6_43_713680 socketIndex, "FF", packetPayload
        Case "FQ"
            Proc_6_52_7172B0 socketIndex, "FQ", packetPayload
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
        Case "GJ"
            Proc_6_11_6DF4A0 socketIndex, "GJ", packetPayload
        Case "GM"
            Proc_6_1_6D8B70 socketIndex, "GM", packetPayload
        Case "GO"
            Proc_6_2_6D9880 socketIndex, "GO", packetPayload
        Case "GP"
            Proc_6_3_6DA490 socketIndex, "GP", packetPayload
        Case "CH"
            Proc_6_4_6DAFB0 socketIndex, "CH", packetPayload
        Case "GB"
            Proc_6_6_6DC9D0 socketIndex, "GB", packetPayload
        Case "GC"
            Proc_6_8_6DD790 socketIndex, "GC", packetPayload
        Case "GD"
            Proc_6_7_6DD0E0 socketIndex, "GD", packetPayload
        Case "GL"
            Proc_6_9_6DDD70 socketIndex, "GL", packetPayload
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
        Case "@L"
            Proc_6_88_73E4F0 socketIndex, "@L", packetPayload
        Case "@f"
            Proc_6_170_7C1100 socketIndex, "@f", packetPayload
        Case "DF"
            Proc_6_169_7C0DC0 socketIndex, "DF", packetPayload
        Case "@a"
            Proc_6_173_7C3430 socketIndex, "@a", packetPayload
        Case "Ci"
            Proc_6_175_7C4800 socketIndex, "Ci", packetPayload
        Case "@b"
            Proc_6_168_7C05F0 socketIndex, "@b", packetPayload
        Case "@e"
            Proc_6_167_7BECA0 socketIndex, "@e", packetPayload
        Case "@i"
            Proc_6_172_7C25B0 socketIndex, "@i", packetPayload
        Case "@g"
            Proc_6_174_7C3BC0 socketIndex, "@g", packetPayload
        Case "@h"
            Proc_6_171_7C1520 socketIndex, "@h", packetPayload
        Case "Fy"
            Proc_6_189_7D0630 socketIndex, "Fy", packetPayload
        Case "Fx"
            Proc_6_188_7CF3C0 socketIndex, "Fx", packetPayload
        Case "Cg"
            Proc_6_190_7D11D0 socketIndex, "Cg", packetPayload
        Case "DG"
            Proc_6_191_7D18B0 socketIndex, "DG", packetPayload
        Case "B_"
            Proc_6_192_7D1B80 socketIndex, "B_", packetPayload
        Case "B]"
            Proc_6_193_7D2BB0 socketIndex, "B]", packetPayload
        Case "B^"
            Proc_6_194_7D3180 socketIndex, "B^", packetPayload
        Case "AK"
            Proc_6_197_7D43C0 socketIndex, "AK", packetPayload
        Case "AO"
            Proc_6_198_7D4B70 socketIndex, "AO", packetPayload
        Case "n" & Chr$(127)
            Proc_6_177_7C6580 socketIndex, "n" & Chr$(127), packetPayload
        Case "ny"
            Proc_6_183_7CABF0 socketIndex, "ny", packetPayload
        Case "nx"
            Proc_6_178_7C6E60 socketIndex, "nx", packetPayload
        Case "nz"
            Proc_6_179_7C7790 socketIndex, "nz", packetPayload
        Case "n~"
            Proc_6_87_73C120 socketIndex, "n~", packetPayload
        Case "n|"
            Proc_7CC190 socketIndex, "n|", packetPayload
        Case "n{"
            Proc_7CA730 socketIndex, "n{", packetPayload
        Case "n}"
            Proc_6_186_7CD040 socketIndex, "n}", packetPayload
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
        Case "@W"
            Proc_6_72_7250D0 socketIndex, "@W", packetPayload
        Case "Es"
            Proc_6_76_726CE0 socketIndex, "Es", packetPayload
        Case "FD"
            Proc_6_77_727590 socketIndex, "FD", packetPayload
        Case "A`"
            Proc_6_65_721A10 socketIndex, "A`", packetPayload
        Case "AT"
            Proc_6_66_721D60 socketIndex, "AT", packetPayload
        Case "AS"
            Proc_6_67_722940 socketIndex, "AS", packetPayload
        Case "AU"
            Proc_6_68_723170 socketIndex, "AU", packetPayload
        Case "FA"
            Proc_6_60_720060 socketIndex, "FA", packetPayload
        Case "FI"
            Proc_6_70_724190 socketIndex, "FI", packetPayload
        Case "AN"
            Proc_6_69_723630 socketIndex, "AN", packetPayload
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
    Dim socketIndex As Integer
    Dim marker As String

    On Error Resume Next

    socketIndex = HandlingSocketIndex(args)
    If socketIndex <= 0 Then GoTo CleanupDone

    Proc_6_242_7FF0D0 socketIndex, 0, 0

    marker = "[" & CStr(socketIndex) & "]"
    global_008291A0 = Replace(global_008291A0, marker, vbNullString, 1, -1, vbBinaryCompare)
    global_00829350 = Replace(global_00829350, marker, vbNullString, 1, -1, vbBinaryCompare)
    global_00829354 = Replace(global_00829354, marker, vbNullString, 1, -1, vbBinaryCompare)

    If Main.DataProcess(socketIndex).Enabled Then Main.DataProcess(socketIndex).Enabled = False
    If Main.musServer(socketIndex).State <> 0 Then Main.musServer(socketIndex).Close

CleanupDone:
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
    Dim socketIndex As Integer
    Dim userId As String
    Dim roomId As Long
    Dim payload As String

    On Error GoTo BroadcastFailed
    If UBound(args) < 1 Then GoTo BroadcastFailed

    socketIndex = CInt(Val(CStr(args(0))))
    payload = CStr(args(1))
    If socketIndex <= 0 Or Len(payload) = 0 Then GoTo BroadcastFailed

    userId = HandlingUserIdFromSocket(socketIndex)
    If Len(userId) = 0 Or userId = "0" Then GoTo BroadcastFailed

    roomId = HandlingCurrentRoomId(socketIndex, userId)
    If roomId <= 0 Then GoTo BroadcastFailed

    Proc_6_245_801FA0 = BroadcastToRoomUsers(roomId, payload)
    Exit Function

BroadcastFailed:
    Proc_6_245_801FA0 = 0
End Function

' Original declaration: Private  Proc_6_246_8024C0(arg_C) '8024C0
Public Function Proc_6_246_8024C0(ParamArray args() As Variant) As Variant
    Dim roomId As Long
    Dim payload As String

    On Error GoTo BroadcastFailed
    If UBound(args) < 1 Then GoTo BroadcastFailed

    roomId = CLng(Val(CStr(args(0))))
    payload = CStr(args(1))
    If roomId <= 0 Or Len(payload) = 0 Then GoTo BroadcastFailed

    Proc_6_246_8024C0 = BroadcastToRoomUsers(roomId, payload)
    Exit Function

BroadcastFailed:
    Proc_6_246_8024C0 = 0
End Function

' Original declaration: Private  Proc_6_247_8027E0(arg_C) '8027E0
Public Function Proc_6_247_8027E0(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim userId As String
    Dim roomId As Long
    Dim payload As String

    On Error GoTo BroadcastFailed
    If UBound(args) < 1 Then GoTo BroadcastFailed

    socketIndex = HandlingSocketIndex(args)
    payload = CStr(args(1))
    If socketIndex <= 0 Or Len(payload) = 0 Then GoTo BroadcastFailed

    userId = HandlingUserIdFromSocket(socketIndex)
    If Len(userId) = 0 Or userId = "0" Then GoTo BroadcastFailed

    roomId = HandlingCurrentRoomId(socketIndex, userId)
    If roomId <= 0 Then GoTo BroadcastFailed

    Proc_6_247_8027E0 = BroadcastToRoomUsers(roomId, payload)
    Exit Function

BroadcastFailed:
    Proc_6_247_8027E0 = 0
End Function

' Original declaration: Private  Proc_6_248_802B80(arg_C) '802B80
Public Function Proc_6_248_802B80(ParamArray args() As Variant) As Variant
    Dim roomId As Long
    Dim payload As String

    On Error GoTo BroadcastFailed
    If UBound(args) < 1 Then GoTo BroadcastFailed

    roomId = CLng(Val(CStr(args(0))))
    payload = CStr(args(1))
    If roomId <= 0 Or Len(payload) = 0 Then GoTo BroadcastFailed

    Proc_6_248_802B80 = BroadcastToRoomUsers(roomId, payload)
    Exit Function

BroadcastFailed:
    Proc_6_248_802B80 = 0
End Function

' Original declaration: Private Sub Proc_6_249_802F10
Public Function Proc_6_249_802F10(ParamArray args() As Variant) As Variant
    Dim payload As String

    On Error GoTo BroadcastFailed
    If UBound(args) < 0 Then GoTo BroadcastFailed

    payload = CStr(args(0))
    Proc_6_249_802F10 = BroadcastToStaffModerators(payload)
    Exit Function

BroadcastFailed:
    Proc_6_249_802F10 = 0
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

Private Function RepresentedAchievementProgress(ByVal userId As String, ByVal achievementQuestId As Long) As Long
    Dim escapedUserId As String
    Dim rowText As String
    Dim fields() As String

    On Error GoTo ProgressFailed
    escapedUserId = Proc_10_11_80A9C0(userId, 0, 0)

    Select Case achievementQuestId
        Case 1
            rowText = CStr(Proc_5_2_6D4690("SELECT COUNT(DISTINCT id_room) FROM logs_visitedrooms WHERE id_user='" & escapedUserId & "'", 0, 0))
            RepresentedAchievementProgress = CLng(Val(rowText))
        Case 2
            rowText = CStr(Proc_5_2_6D4690("SELECT respect_received FROM users WHERE id='" & escapedUserId & "' LIMIT 1", 0, 0))
            RepresentedAchievementProgress = CLng(Val(rowText))
        Case 3
            rowText = CStr(Proc_5_2_6D4690("SELECT respect_given FROM users WHERE id='" & escapedUserId & "' LIMIT 1", 0, 0))
            RepresentedAchievementProgress = CLng(Val(rowText))
        Case 4
            rowText = CStr(Proc_5_2_6D4690("SELECT online_time FROM users WHERE id='" & escapedUserId & "' LIMIT 1", 0, 0))
            RepresentedAchievementProgress = CLng(Val(rowText)) \ 60
        Case 5
            rowText = CStr(Proc_5_2_6D4690("SELECT create_time FROM users WHERE id='" & escapedUserId & "' LIMIT 1", 0, 0))
            If CLng(Val(rowText)) > 0 Then RepresentedAchievementProgress = DateDiff("d", DateSerial(1970, 1, 1), Now) - (CLng(Val(rowText)) \ 86400)
        Case 6
            rowText = CStr(Proc_5_2_6D4690("SELECT gifts_given FROM users WHERE id='" & escapedUserId & "' LIMIT 1", 0, 0))
            RepresentedAchievementProgress = CLng(Val(rowText))
        Case 7
            rowText = CStr(Proc_5_2_6D4690("SELECT gifts_received FROM users WHERE id='" & escapedUserId & "' LIMIT 1", 0, 0))
            RepresentedAchievementProgress = CLng(Val(rowText))
        Case 8
            rowText = CStr(Proc_5_2_6D4690("SELECT hc_periods FROM users WHERE id='" & escapedUserId & "' LIMIT 1", 0, 0))
            RepresentedAchievementProgress = CLng(Val(rowText))
        Case 9
            rowText = CStr(Proc_5_2_6D4690("SELECT hc2_periods FROM users WHERE id='" & escapedUserId & "' LIMIT 1", 0, 0))
            RepresentedAchievementProgress = CLng(Val(rowText))
        Case 11
            rowText = CStr(Proc_5_2_6D4690("SELECT amount_staffpicked FROM users WHERE id='" & escapedUserId & "' LIMIT 1", 0, 0))
            RepresentedAchievementProgress = CLng(Val(rowText))
        Case Else
            rowText = CStr(Proc_5_2_6D4690("SELECT respect_received,respect_given,gifts_given,gifts_received FROM users WHERE id='" & escapedUserId & "' LIMIT 1", 0, 0))
            fields = Split(rowText, Chr$(9))
            If UBound(fields) >= 0 Then RepresentedAchievementProgress = CLng(Val(CStr(fields(0))))
    End Select
    If RepresentedAchievementProgress < 0 Then RepresentedAchievementProgress = 0
    Exit Function

ProgressFailed:
    RepresentedAchievementProgress = 0
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

Private Function RepresentedRoomUserIndex(ByVal socketIndex As Integer, ByVal userId As String) As Long
    Dim roomUserIndex As Long

    On Error GoTo LookupFailed

    roomUserIndex = CLng(Val(CStr(Proc_5_2_6D4690("SELECT id FROM logs_visitedrooms WHERE id_user='" & _
        Proc_10_11_80A9C0(userId, 0, 0) & "' AND timestamp_left IS NULL ORDER BY timestamp_enter DESC LIMIT 1", 0, 0))))
    If roomUserIndex <= 0 Then roomUserIndex = CLng(socketIndex)

    RepresentedRoomUserIndex = roomUserIndex
    Exit Function

LookupFailed:
    RepresentedRoomUserIndex = CLng(socketIndex)
End Function

Private Function HandlingRepresentedUserPosition(ByRef args() As Variant, ByRef positionX As Long, ByRef positionY As Long) As Boolean
    On Error GoTo LookupFailed

    If UBound(args) >= 4 Then
        positionX = CLng(Val(CStr(args(3))))
        positionY = CLng(Val(CStr(args(4))))
        HandlingRepresentedUserPosition = True
    End If
    Exit Function

LookupFailed:
    HandlingRepresentedUserPosition = False
End Function

Private Sub EnsureRepresentedRoomSlotPool()
    Static slotPoolInitialized As Boolean
    Dim slotIndex As Long

    If slotPoolInitialized Then Exit Sub
    If Len(global_0082930C) > 0 Then
        slotPoolInitialized = True
        Exit Sub
    End If

    For slotIndex = 1 To 500
        global_0082930C = global_0082930C & "[" & CStr(slotIndex) & "]"
    Next slotIndex
    slotPoolInitialized = True
End Sub

Private Function ReserveRepresentedRoomSlot(ByVal preferredSlot As Long) As Long
    Dim marker As String
    Dim parts() As String
    Dim partIndex As Long
    Dim candidateSlot As Long

    On Error GoTo ReserveFailed

    EnsureRepresentedRoomSlotPool

    If preferredSlot > 0 Then
        marker = "[" & CStr(preferredSlot) & "]"
        If InStr(1, global_0082930C, marker, vbBinaryCompare) > 0 Then
            global_0082930C = Replace(global_0082930C, marker, vbNullString, 1, 1, vbBinaryCompare)
            ReserveRepresentedRoomSlot = preferredSlot
            Exit Function
        End If
    End If

    parts = Split(global_0082930C, "]")
    For partIndex = LBound(parts) To UBound(parts)
        candidateSlot = CLng(Val(Replace(CStr(parts(partIndex)), "[", vbNullString, 1, -1, vbBinaryCompare)))
        If candidateSlot > 0 Then
            marker = "[" & CStr(candidateSlot) & "]"
            global_0082930C = Replace(global_0082930C, marker, vbNullString, 1, 1, vbBinaryCompare)
            ReserveRepresentedRoomSlot = candidateSlot
            Exit Function
        End If
    Next partIndex

ReserveFailed:
    ReserveRepresentedRoomSlot = 0
End Function

Private Sub ReleaseRepresentedRoomSlot(ByVal slotId As Long)
    Dim marker As String

    If slotId <= 0 Then Exit Sub
    marker = "[" & CStr(slotId) & "]"
    If InStr(1, global_0082930C, marker, vbBinaryCompare) = 0 Then
        global_0082930C = global_0082930C & marker
    End If
End Sub

Private Sub LoadRepresentedRoomBots(ByVal roomSlot As Long, ByVal roomId As Long)
    Dim rowText As String
    Dim rows() As String
    Dim fields() As String
    Dim rowIndex As Long

    On Error GoTo LoadDone
    If roomSlot <= 0 Or roomId <= 0 Then GoTo LoadDone
    If CLng(Val(CStr(Proc_10_0_809570("com.client.rooms.bots.enabled", "-1", 0)))) = 0 Then GoTo LoadDone

    rowText = CStr(Proc_5_2_6D4690("SELECT id,name,motto,speech,responses,position_x,position_y,position_z,position_r,figure,NULL,id_handle,id_handleaction,cache_action,speech_submit,allow_walk,max_fields_away FROM bots WHERE id_room='" & _
        CStr(roomId) & "' LIMIT 255", 0, 0))
    If Len(rowText) = 0 Then GoTo LoadDone

    rows = Split(rowText, Chr$(13))
    For rowIndex = LBound(rows) To UBound(rows)
        If Len(rows(rowIndex)) > 0 Then
            fields = Split(rows(rowIndex), Chr$(9))
            Proc_6_187_7CD700 roomSlot, fields, 0
        End If
    Next rowIndex

LoadDone:
End Sub

Private Function ReserveRepresentedBotSlot() As Long
    Dim slotIndex As Long
    Dim marker As String

    On Error GoTo ReserveFailed
    For slotIndex = 1 To 5000
        marker = "[" & CStr(slotIndex) & "]"
        If InStr(1, global_008292D4, marker, vbBinaryCompare) = 0 Then
            global_008292D4 = global_008292D4 & marker
            ReserveRepresentedBotSlot = slotIndex
            Exit Function
        End If
    Next slotIndex

ReserveFailed:
    ReserveRepresentedBotSlot = 0
End Function

Private Function RepresentedBotField(ByVal botFields As Variant, ByVal fieldIndex As Long) As String
    On Error GoTo MissingField
    If Not IsArray(botFields) Then GoTo MissingField
    If fieldIndex < LBound(botFields) Or fieldIndex > UBound(botFields) Then GoTo MissingField
    RepresentedBotField = CStr(botFields(fieldIndex))
    Exit Function

MissingField:
    RepresentedBotField = vbNullString
End Function

Private Sub StoreRepresentedBotRecord(ByVal botEntityId As Long, ByVal recordText As String)
    Dim startMarker As String
    Dim endMarker As String
    Dim startAt As Long
    Dim endAt As Long

    On Error GoTo StoreDone
    If botEntityId <= 0 Then GoTo StoreDone

    startMarker = "[" & CStr(botEntityId) & ":"
    endMarker = "]"
    startAt = InStr(1, global_00829358, startMarker, vbBinaryCompare)
    If startAt > 0 Then
        endAt = InStr(startAt + Len(startMarker), global_00829358, endMarker, vbBinaryCompare)
        If endAt > 0 Then
            global_00829358 = Left$(global_00829358, startAt - 1) & Mid$(global_00829358, endAt + Len(endMarker))
        End If
    End If

    global_00829358 = global_00829358 & startMarker & recordText & endMarker

StoreDone:
End Sub

Private Sub RemoveRepresentedBotRecord(ByVal botEntityId As Long)
    Dim startMarker As String
    Dim startAt As Long
    Dim endAt As Long

    On Error GoTo RemoveDone
    If botEntityId <= 0 Then GoTo RemoveDone

    startMarker = "[" & CStr(botEntityId) & ":"
    startAt = InStr(1, global_00829358, startMarker, vbBinaryCompare)
    If startAt > 0 Then
        endAt = InStr(startAt + Len(startMarker), global_00829358, "]", vbBinaryCompare)
        If endAt > 0 Then global_00829358 = Left$(global_00829358, startAt - 1) & Mid$(global_00829358, endAt + 1)
    End If
    global_008292D4 = Replace(global_008292D4, "[" & CStr(botEntityId) & "]", vbNullString, 1, 1, vbBinaryCompare)

RemoveDone:
End Sub

Private Function RepresentedBotRecordText(ByVal botEntityId As Long) As String
    Dim startMarker As String
    Dim startAt As Long
    Dim endAt As Long

    On Error GoTo MissingRecord
    If botEntityId <= 0 Or Len(global_00829358) = 0 Then GoTo MissingRecord

    startMarker = "[" & CStr(botEntityId) & ":"
    startAt = InStr(1, global_00829358, startMarker, vbBinaryCompare)
    If startAt <= 0 Then GoTo MissingRecord

    startAt = startAt + Len(startMarker)
    endAt = InStr(startAt, global_00829358, "]", vbBinaryCompare)
    If endAt <= startAt Then GoTo MissingRecord

    RepresentedBotRecordText = Mid$(global_00829358, startAt, endAt - startAt)
    Exit Function

MissingRecord:
    RepresentedBotRecordText = vbNullString
End Function

Private Function RepresentedBotRecordField(ByVal botEntityId As Long, ByVal fieldIndex As Long) As String
    Dim fields() As String

    On Error GoTo MissingField
    fields = Split(RepresentedBotRecordText(botEntityId), Chr$(2))
    If fieldIndex < LBound(fields) Or fieldIndex > UBound(fields) Then GoTo MissingField
    RepresentedBotRecordField = CStr(fields(fieldIndex))
    Exit Function

MissingField:
    RepresentedBotRecordField = vbNullString
End Function

Private Function RepresentedBotRecordLong(ByVal botEntityId As Long, ByVal fieldIndex As Long) As Long
    RepresentedBotRecordLong = CLng(Val(RepresentedBotRecordField(botEntityId, fieldIndex)))
End Function

Private Function RepresentedBotEntityFromBotId(ByVal botId As Long) As Long
    Dim records() As String
    Dim recordIndex As Long
    Dim recordText As String
    Dim payloadAt As Long
    Dim endAt As Long
    Dim entityId As Long
    Dim fields() As String

    On Error GoTo MissingEntity
    If botId <= 0 Or Len(global_00829358) = 0 Then GoTo MissingEntity

    records = Split(global_00829358, "[")
    For recordIndex = LBound(records) To UBound(records)
        recordText = CStr(records(recordIndex))
        payloadAt = InStr(1, recordText, ":", vbBinaryCompare)
        endAt = InStr(1, recordText, "]", vbBinaryCompare)
        If payloadAt > 1 And endAt > payloadAt Then
            entityId = CLng(Val(Left$(recordText, payloadAt - 1)))
            fields = Split(Mid$(recordText, payloadAt + 1, endAt - payloadAt - 1), Chr$(2))
            If UBound(fields) >= 1 Then
                If CLng(Val(CStr(fields(1)))) = botId Then
                    RepresentedBotEntityFromBotId = entityId
                    Exit Function
                End If
            End If
        End If
    Next recordIndex

MissingEntity:
    RepresentedBotEntityFromBotId = 0
End Function

Private Function RepresentedBotEntitiesForRoom(ByVal roomSlot As Long, ByVal onlyBotId As Long) As String
    Dim records() As String
    Dim recordIndex As Long
    Dim recordText As String
    Dim payloadAt As Long
    Dim endAt As Long
    Dim entityId As Long
    Dim fields() As String

    On Error GoTo LookupDone
    If roomSlot <= 0 Or Len(global_00829358) = 0 Then GoTo LookupDone

    records = Split(global_00829358, "[")
    For recordIndex = LBound(records) To UBound(records)
        recordText = CStr(records(recordIndex))
        payloadAt = InStr(1, recordText, ":", vbBinaryCompare)
        endAt = InStr(1, recordText, "]", vbBinaryCompare)
        If payloadAt > 1 And endAt > payloadAt Then
            entityId = CLng(Val(Left$(recordText, payloadAt - 1)))
            fields = Split(Mid$(recordText, payloadAt + 1, endAt - payloadAt - 1), Chr$(2))
            If UBound(fields) >= 1 Then
                If CLng(Val(CStr(fields(0)))) = roomSlot Then
                    If onlyBotId <= 0 Or CLng(Val(CStr(fields(1)))) = onlyBotId Then
                        If Len(RepresentedBotEntitiesForRoom) > 0 Then RepresentedBotEntitiesForRoom = RepresentedBotEntitiesForRoom & Chr$(13)
                        RepresentedBotEntitiesForRoom = RepresentedBotEntitiesForRoom & CStr(entityId)
                    End If
                End If
            End If
        End If
    Next recordIndex

LookupDone:
End Function

Private Function RepresentedRoomUserProfilePayload(ByVal roomUserIndex As Long, ByVal userName As String, ByVal mottoText As String, ByVal achievementScore As Long, ByVal figureText As String) As String
    On Error GoTo BuildFailed
    If roomUserIndex <= 0 Then GoTo BuildFailed

    RepresentedRoomUserProfilePayload = CStr(Proc_3_0_6D2AF0(roomUserIndex, Empty, "Dw"))
    RepresentedRoomUserProfilePayload = RepresentedRoomUserProfilePayload & userName & Chr$(2)
    RepresentedRoomUserProfilePayload = RepresentedRoomUserProfilePayload & mottoText & Chr$(2)
    RepresentedRoomUserProfilePayload = CStr(Proc_3_0_6D2AF0(achievementScore, Empty, RepresentedRoomUserProfilePayload))
    RepresentedRoomUserProfilePayload = RepresentedRoomUserProfilePayload & figureText & Chr$(2)
    Exit Function

BuildFailed:
    RepresentedRoomUserProfilePayload = vbNullString
End Function

Private Function RepresentedRoomUserStatusPayload(ByVal roomUserIndex As Long, ByVal statusCode As Long) As String
    On Error GoTo BuildFailed
    If roomUserIndex <= 0 Then GoTo BuildFailed
    If statusCode < 0 Then statusCode = 0

    RepresentedRoomUserStatusPayload = "0" & CStr(Proc_3_0_6D2AF0(statusCode, Empty, _
        CStr(Proc_3_0_6D2AF0(roomUserIndex, Empty, "Ge"))))
    Exit Function

BuildFailed:
    RepresentedRoomUserStatusPayload = vbNullString
End Function

Private Sub StoreRepresentedInteractionPair(ByVal sourceSocketIndex As Integer, ByVal targetSocketIndex As Integer, ByVal interactionState As Long)
    On Error GoTo StoreDone
    If sourceSocketIndex <= 0 Or targetSocketIndex <= 0 Then GoTo StoreDone

    RemoveRepresentedInteractionPair sourceSocketIndex
    RemoveRepresentedInteractionPair targetSocketIndex

    If Len(representedInteractionPairs) > 0 Then representedInteractionPairs = representedInteractionPairs & Chr$(13)
    representedInteractionPairs = representedInteractionPairs & CStr(sourceSocketIndex) & Chr$(9) & CStr(targetSocketIndex) & Chr$(9) & CStr(interactionState)

    representedInteractionPairs = representedInteractionPairs & Chr$(13) & CStr(targetSocketIndex) & Chr$(9) & CStr(sourceSocketIndex) & Chr$(9) & CStr(interactionState)

StoreDone:
End Sub

Private Sub RemoveRepresentedInteractionPair(ByVal socketIndex As Integer)
    Dim rows() As String
    Dim fields() As String
    Dim rowIndex As Long
    Dim rebuiltText As String

    On Error GoTo RemoveDone
    If socketIndex <= 0 Or Len(representedInteractionPairs) = 0 Then GoTo RemoveDone

    rows = Split(representedInteractionPairs, Chr$(13))
    For rowIndex = LBound(rows) To UBound(rows)
        If Len(rows(rowIndex)) > 0 Then
            fields = Split(rows(rowIndex), Chr$(9))
            If UBound(fields) >= 0 Then
                If CInt(Val(CStr(fields(0)))) <> socketIndex Then
                    If Len(rebuiltText) > 0 Then rebuiltText = rebuiltText & Chr$(13)
                    rebuiltText = rebuiltText & rows(rowIndex)
                End If
            End If
        End If
    Next rowIndex

    representedInteractionPairs = rebuiltText
    RemoveRepresentedTradeOffer socketIndex, 0

RemoveDone:
End Sub

Private Function RepresentedInteractionPartner(ByVal socketIndex As Integer) As Integer
    Dim rows() As String
    Dim fields() As String
    Dim rowIndex As Long

    On Error GoTo LookupFailed
    If socketIndex <= 0 Or Len(representedInteractionPairs) = 0 Then GoTo LookupFailed

    rows = Split(representedInteractionPairs, Chr$(13))
    For rowIndex = LBound(rows) To UBound(rows)
        If Len(rows(rowIndex)) > 0 Then
            fields = Split(rows(rowIndex), Chr$(9))
            If UBound(fields) >= 1 Then
                If CInt(Val(CStr(fields(0)))) = socketIndex Then
                    RepresentedInteractionPartner = CInt(Val(CStr(fields(1))))
                    Exit Function
                End If
            End If
        End If
    Next rowIndex

LookupFailed:
    RepresentedInteractionPartner = 0
End Function

Private Function RepresentedInteractionState(ByVal socketIndex As Integer) As Long
    Dim rows() As String
    Dim fields() As String
    Dim rowIndex As Long

    On Error GoTo LookupFailed
    If socketIndex <= 0 Or Len(representedInteractionPairs) = 0 Then GoTo LookupFailed

    rows = Split(representedInteractionPairs, Chr$(13))
    For rowIndex = LBound(rows) To UBound(rows)
        If Len(rows(rowIndex)) > 0 Then
            fields = Split(rows(rowIndex), Chr$(9))
            If UBound(fields) >= 2 Then
                If CInt(Val(CStr(fields(0)))) = socketIndex Then
                    RepresentedInteractionState = CLng(Val(CStr(fields(2))))
                    Exit Function
                End If
            End If
        End If
    Next rowIndex

LookupFailed:
    RepresentedInteractionState = 0
End Function

Private Sub StoreRepresentedTradeOffer(ByVal socketIndex As Integer, ByVal furnitureId As Long, ByVal productId As Long, ByVal signText As String, ByVal secondaryValue As Long)
    Dim rows() As String
    Dim rowIndex As Long
    Dim fields() As String
    Dim rebuiltText As String
    Dim rowText As String
    Dim replacedExisting As Boolean

    If socketIndex <= 0 Or furnitureId <= 0 Or productId <= 0 Then Exit Sub

    rowText = CStr(socketIndex) & Chr$(9) & CStr(furnitureId) & Chr$(9) & CStr(productId) & Chr$(9) & _
        Replace(signText, Chr$(13), vbNullString, 1, -1, vbBinaryCompare) & Chr$(9) & CStr(secondaryValue)

    If Len(representedTradeOffers) > 0 Then
        rows = Split(representedTradeOffers, Chr$(13))
        For rowIndex = LBound(rows) To UBound(rows)
            If Len(rows(rowIndex)) > 0 Then
                fields = Split(CStr(rows(rowIndex)), Chr$(9))
                If UBound(fields) >= 1 Then
                    If CInt(Val(CStr(fields(0)))) = socketIndex And CLng(Val(CStr(fields(1)))) = furnitureId Then
                        If Len(rebuiltText) > 0 Then rebuiltText = rebuiltText & Chr$(13)
                        rebuiltText = rebuiltText & rowText
                        replacedExisting = True
                    Else
                        If Len(rebuiltText) > 0 Then rebuiltText = rebuiltText & Chr$(13)
                        rebuiltText = rebuiltText & CStr(rows(rowIndex))
                    End If
                End If
            End If
        Next rowIndex
    End If

    If Not replacedExisting Then
        If Len(rebuiltText) > 0 Then rebuiltText = rebuiltText & Chr$(13)
        rebuiltText = rebuiltText & rowText
    End If
    representedTradeOffers = rebuiltText
End Sub

Private Sub RemoveRepresentedTradeOffer(ByVal socketIndex As Integer, ByVal furnitureId As Long)
    Dim rows() As String
    Dim fields() As String
    Dim rowIndex As Long
    Dim rebuiltText As String
    Dim rowSocketIndex As Integer
    Dim rowFurnitureId As Long

    On Error GoTo RemoveDone
    If socketIndex <= 0 Or Len(representedTradeOffers) = 0 Then GoTo RemoveDone

    rows = Split(representedTradeOffers, Chr$(13))
    For rowIndex = LBound(rows) To UBound(rows)
        If Len(rows(rowIndex)) > 0 Then
            fields = Split(CStr(rows(rowIndex)), Chr$(9))
            If UBound(fields) >= 1 Then
                rowSocketIndex = CInt(Val(CStr(fields(0))))
                rowFurnitureId = CLng(Val(CStr(fields(1))))
                If rowSocketIndex <> socketIndex Or (furnitureId > 0 And rowFurnitureId <> furnitureId) Then
                    If Len(rebuiltText) > 0 Then rebuiltText = rebuiltText & Chr$(13)
                    rebuiltText = rebuiltText & CStr(rows(rowIndex))
                End If
            End If
        End If
    Next rowIndex

    representedTradeOffers = rebuiltText

RemoveDone:
End Sub

Private Function RepresentedTradeOfferSqlIds(ByVal socketIndex As Integer) As String
    Dim rows() As String
    Dim fields() As String
    Dim rowIndex As Long
    Dim furnitureId As Long
    Dim sqlIds As String

    On Error GoTo BuildDone
    If socketIndex <= 0 Or Len(representedTradeOffers) = 0 Then GoTo BuildDone

    rows = Split(representedTradeOffers, Chr$(13))
    For rowIndex = LBound(rows) To UBound(rows)
        If Len(rows(rowIndex)) > 0 Then
            fields = Split(CStr(rows(rowIndex)), Chr$(9))
            If UBound(fields) >= 1 Then
                If CInt(Val(CStr(fields(0)))) = socketIndex Then
                    furnitureId = CLng(Val(CStr(fields(1))))
                    If furnitureId > 0 Then
                        If Len(sqlIds) > 0 Then sqlIds = sqlIds & ","
                        sqlIds = sqlIds & "'" & CStr(furnitureId) & "'"
                    End If
                End If
            End If
        End If
    Next rowIndex

BuildDone:
    RepresentedTradeOfferSqlIds = sqlIds
End Function

Private Function RepresentedTradeOfferLogItems(ByVal socketIndex As Integer) As String
    Dim rows() As String
    Dim fields() As String
    Dim rowIndex As Long
    Dim furnitureId As Long
    Dim productId As Long
    Dim logItems As String

    On Error GoTo BuildDone
    If socketIndex <= 0 Or Len(representedTradeOffers) = 0 Then GoTo BuildDone

    rows = Split(representedTradeOffers, Chr$(13))
    For rowIndex = LBound(rows) To UBound(rows)
        If Len(rows(rowIndex)) > 0 Then
            fields = Split(CStr(rows(rowIndex)), Chr$(9))
            If UBound(fields) >= 2 Then
                If CInt(Val(CStr(fields(0)))) = socketIndex Then
                    furnitureId = CLng(Val(CStr(fields(1))))
                    productId = CLng(Val(CStr(fields(2))))
                    If furnitureId > 0 Then
                        If Len(logItems) > 0 Then logItems = logItems & Chr$(1)
                        logItems = logItems & CStr(furnitureId) & ":" & CStr(productId)
                    End If
                End If
            End If
        End If
    Next rowIndex

BuildDone:
    RepresentedTradeOfferLogItems = logItems
End Function

Private Function RepresentedTradeOfferItemPayload(ByVal socketIndex As Integer, ByRef itemCount As Long) As String
    Dim rows() As String
    Dim fields() As String
    Dim rowIndex As Long
    Dim furnitureId As Long
    Dim productId As Long
    Dim signText As String
    Dim secondaryValue As Long
    Dim payload As String

    On Error GoTo BuildDone
    If socketIndex <= 0 Or Len(representedTradeOffers) = 0 Then GoTo BuildDone

    rows = Split(representedTradeOffers, Chr$(13))
    For rowIndex = LBound(rows) To UBound(rows)
        If Len(rows(rowIndex)) > 0 Then
            fields = Split(CStr(rows(rowIndex)), Chr$(9))
            If UBound(fields) >= 4 Then
                If CInt(Val(CStr(fields(0)))) = socketIndex Then
                    furnitureId = CLng(Val(CStr(fields(1))))
                    productId = CLng(Val(CStr(fields(2))))
                    signText = CStr(fields(3))
                    secondaryValue = CLng(Val(CStr(fields(4))))
                    payload = payload & CStr(Proc_6_138_7678A0(furnitureId, productId, signText, secondaryValue))
                    itemCount = itemCount + 1
                End If
            End If
        End If
    Next rowIndex

BuildDone:
    RepresentedTradeOfferItemPayload = payload
End Function

Private Function RepresentedTradeOfferPayload(ByVal sourceSocketIndex As Integer, ByVal targetSocketIndex As Integer, ByVal sourceUserId As String, ByVal targetUserId As String) As String
    Dim sourceCount As Long
    Dim targetCount As Long
    Dim sourceItems As String
    Dim targetItems As String
    Dim payload As String

    On Error GoTo BuildFailed
    If sourceSocketIndex <= 0 Or targetSocketIndex <= 0 Then GoTo BuildFailed

    sourceItems = RepresentedTradeOfferItemPayload(sourceSocketIndex, sourceCount)
    targetItems = RepresentedTradeOfferItemPayload(targetSocketIndex, targetCount)

    payload = CStr(Proc_3_0_6D2AF0(CLng(Val(sourceUserId)), Empty, "Al"))
    payload = CStr(Proc_3_0_6D2AF0(CLng(Val(targetUserId)), Empty, payload))
    payload = CStr(Proc_3_0_6D2AF0(sourceCount, Empty, payload)) & sourceItems
    payload = CStr(Proc_3_0_6D2AF0(targetCount, Empty, payload)) & targetItems

    RepresentedTradeOfferPayload = payload
    Exit Function

BuildFailed:
    RepresentedTradeOfferPayload = vbNullString
End Function

Private Function RepresentedRecyclerRewardProduct() As Long
    Dim rewardGroupIndex As Long
    Dim productList As String
    Dim rewardRows As String
    Dim rewardRowsArray() As String
    Dim rowIndex As Long

    On Error GoTo RewardFailed

    If IsArray(global_00829140) And IsArray(global_0082915C) Then
        For rewardGroupIndex = 0 To CLng(global_00829168) - 1
            If rewardGroupIndex >= LBound(global_00829140) And rewardGroupIndex <= UBound(global_00829140) Then
                If CLng(Val(CStr(global_0082915C(rewardGroupIndex)))) > 0 Then
                    If CLng(Val(CStr(Proc_10_4_809CA0(1, CLng(Val(CStr(global_0082915C(rewardGroupIndex)))), 0)))) = 1 Then
                        productList = CStr(global_00829140(rewardGroupIndex))
                        RepresentedRecyclerRewardProduct = RepresentedRandomProductFromList(productList)
                        If RepresentedRecyclerRewardProduct > 0 Then Exit Function
                    End If
                End If
            End If
        Next rewardGroupIndex

        For rewardGroupIndex = 0 To CLng(global_00829168) - 1
            If rewardGroupIndex >= LBound(global_00829140) And rewardGroupIndex <= UBound(global_00829140) Then
                RepresentedRecyclerRewardProduct = RepresentedRandomProductFromList(CStr(global_00829140(rewardGroupIndex)))
                If RepresentedRecyclerRewardProduct > 0 Then Exit Function
            End If
        Next rewardGroupIndex
    End If

    rewardRows = CStr(Proc_5_2_6D4690("SELECT id_product FROM settings_recycler ORDER BY chance DESC LIMIT 100", 0, 0))
    If Len(rewardRows) > 0 Then
        rewardRowsArray = Split(rewardRows, Chr$(13))
        rowIndex = CLng(Val(CStr(Proc_10_4_809CA0(LBound(rewardRowsArray), UBound(rewardRowsArray), 0))))
        If rowIndex < LBound(rewardRowsArray) Then rowIndex = LBound(rewardRowsArray)
        If rowIndex > UBound(rewardRowsArray) Then rowIndex = UBound(rewardRowsArray)
        RepresentedRecyclerRewardProduct = CLng(Val(CStr(rewardRowsArray(rowIndex))))
    End If

RewardFailed:
End Function

Private Function RepresentedRandomProductFromList(ByVal productList As String) As Long
    Dim productRows() As String
    Dim productIndex As Long
    Dim nonEmptyProducts As String
    Dim productCount As Long
    Dim selectedIndex As Long

    On Error GoTo SelectFailed
    If Len(productList) = 0 Then GoTo SelectFailed

    productRows = Split(productList, Chr$(2))
    For productIndex = LBound(productRows) To UBound(productRows)
        If CLng(Val(CStr(productRows(productIndex)))) > 0 Then
            If Len(nonEmptyProducts) > 0 Then nonEmptyProducts = nonEmptyProducts & Chr$(2)
            nonEmptyProducts = nonEmptyProducts & CStr(CLng(Val(CStr(productRows(productIndex)))))
            productCount = productCount + 1
        End If
    Next productIndex
    If productCount <= 0 Then GoTo SelectFailed

    productRows = Split(nonEmptyProducts, Chr$(2))
    selectedIndex = CLng(Val(CStr(Proc_10_4_809CA0(LBound(productRows), UBound(productRows), 0))))
    If selectedIndex < LBound(productRows) Then selectedIndex = LBound(productRows)
    If selectedIndex > UBound(productRows) Then selectedIndex = UBound(productRows)
    RepresentedRandomProductFromList = CLng(Val(CStr(productRows(selectedIndex))))

SelectFailed:
End Function

Private Sub StoreRepresentedBotPosition(ByVal botEntityId As Long, ByVal positionX As Long, ByVal positionY As Long, ByVal positionZ As String, ByVal positionR As Long)
    Dim fields() As String
    Dim recordText As String
    Dim fieldIndex As Long

    On Error GoTo StoreDone
    fields = Split(RepresentedBotRecordText(botEntityId), Chr$(2))
    If UBound(fields) < 9 Then GoTo StoreDone

    fields(6) = CStr(positionX)
    fields(7) = CStr(positionY)
    fields(8) = positionZ
    fields(9) = CStr(positionR)

    For fieldIndex = LBound(fields) To UBound(fields)
        If fieldIndex > LBound(fields) Then recordText = recordText & Chr$(2)
        recordText = recordText & CStr(fields(fieldIndex))
    Next fieldIndex

    StoreRepresentedBotRecord botEntityId, recordText

StoreDone:
End Sub

Private Function RepresentedBotRoomEntryPayload(ByVal botEntityId As Long) As String
    Dim botId As Long
    Dim botName As String
    Dim botFigure As String
    Dim positionX As Long
    Dim positionY As Long
    Dim positionZ As String
    Dim positionR As Long

    On Error GoTo PayloadFailed
    botId = RepresentedBotRecordLong(botEntityId, 1)
    botName = RepresentedBotRecordField(botEntityId, 2)
    positionX = RepresentedBotRecordLong(botEntityId, 6)
    positionY = RepresentedBotRecordLong(botEntityId, 7)
    positionZ = RepresentedBotRecordField(botEntityId, 8)
    positionR = RepresentedBotRecordLong(botEntityId, 9)
    botFigure = RepresentedBotRecordField(botEntityId, 10)
    If botEntityId <= 0 Or botId <= 0 Then GoTo PayloadFailed

    RepresentedBotRoomEntryPayload = "@\" & CStr(Proc_3_0_6D2AF0(botEntityId, Empty, vbNullString))
    RepresentedBotRoomEntryPayload = RepresentedBotRoomEntryPayload & botName & Chr$(2)
    RepresentedBotRoomEntryPayload = RepresentedBotRoomEntryPayload & CStr(positionX) & " " & CStr(positionY) & " " & positionZ & Chr$(2)
    RepresentedBotRoomEntryPayload = RepresentedBotRoomEntryPayload & CStr(positionR) & Chr$(2) & botFigure & Chr$(2)
    Exit Function

PayloadFailed:
    RepresentedBotRoomEntryPayload = vbNullString
End Function

Private Function RepresentedPetInventoryRow(ByVal petId As Long, ByVal petName As String, ByVal petFigure As String, ByVal scratches As Long) As String
    Dim figureParts() As String
    Dim petType As Long
    Dim petRace As Long
    Dim petColor As String

    On Error GoTo RowFailed
    If petId <= 0 Then GoTo RowFailed

    figureParts = Split(LCase$(petFigure), Chr$(32))
    If UBound(figureParts) >= 0 Then petType = CLng(Val(CStr(figureParts(0))))
    If UBound(figureParts) >= 1 Then petRace = CLng(Val(CStr(figureParts(1))))
    If UBound(figureParts) >= 2 Then petColor = CStr(figureParts(2))

    RepresentedPetInventoryRow = "0" & CStr(Proc_3_0_6D2AF0(petId, Empty, vbNullString)) & petName & Chr$(2)
    RepresentedPetInventoryRow = RepresentedPetInventoryRow & CStr(Proc_3_0_6D2AF0(petType, Empty, vbNullString))
    RepresentedPetInventoryRow = RepresentedPetInventoryRow & CStr(Proc_3_0_6D2AF0(petRace, Empty, vbNullString))
    RepresentedPetInventoryRow = RepresentedPetInventoryRow & "0" & petColor & Chr$(2)
    RepresentedPetInventoryRow = RepresentedPetInventoryRow & CStr(Proc_3_0_6D2AF0(scratches, Empty, vbNullString))
    Exit Function

RowFailed:
    RepresentedPetInventoryRow = vbNullString
End Function

Private Function RepresentedPetCommandPayloadFromSql(ByVal petLevel As Long, ByVal onlyAvailable As Boolean, ByRef commandCount As Long) As String
    Dim rowText As String
    Dim rows() As String
    Dim fields() As String
    Dim rowIndex As Long
    Dim commandId As Long
    Dim requiredLevel As Long

    On Error GoTo BuildFailed

    rowText = CStr(Proc_5_2_6D4690("SELECT id_command,petlevel_required FROM bots_petcommands ORDER BY id_command ASC", 0, 0))
    If Len(rowText) = 0 Then GoTo BuildFailed

    rows = Split(rowText, Chr$(13))
    For rowIndex = LBound(rows) To UBound(rows)
        If Len(CStr(rows(rowIndex))) > 0 Then
            fields = Split(CStr(rows(rowIndex)), Chr$(9))
            If UBound(fields) >= 1 Then
                commandId = CLng(Val(CStr(fields(0))))
                requiredLevel = CLng(Val(CStr(fields(1))))
                If commandId > 0 Then
                    If Not onlyAvailable Or requiredLevel <= petLevel Then
                        RepresentedPetCommandPayloadFromSql = RepresentedPetCommandPayloadFromSql & "0" & _
                            CStr(Proc_3_0_6D2AF0(commandId, Empty, vbNullString))
                        commandCount = commandCount + 1
                    End If
                End If
            End If
        End If
    Next rowIndex
    Exit Function

BuildFailed:
    RepresentedPetCommandPayloadFromSql = vbNullString
End Function

Private Function RepresentedPetStatusPayload(ByVal botEntityId As Long, ByVal petFields As Variant) As String
    Dim botId As Long
    Dim petName As String
    Dim petFigure As String
    Dim petLevel As Long
    Dim petExperience As Long
    Dim petEnergy As Long
    Dim petNutrition As Long
    Dim petScratches As Long
    Dim petAgeDays As Long
    Dim ownerId As Long
    Dim ownerName As String

    On Error GoTo PayloadFailed
    If Not IsArray(petFields) Then GoTo PayloadFailed
    If UBound(petFields) < 10 Then GoTo PayloadFailed

    botId = CLng(Val(CStr(petFields(0))))
    petName = CStr(petFields(1))
    petFigure = CStr(petFields(2))
    petLevel = CLng(Val(CStr(petFields(3))))
    petExperience = CLng(Val(CStr(petFields(4))))
    petEnergy = CLng(Val(CStr(petFields(5))))
    petNutrition = CLng(Val(CStr(petFields(6))))
    petScratches = CLng(Val(CStr(petFields(7))))
    petAgeDays = CLng(Val(CStr(petFields(8))))
    ownerId = CLng(Val(CStr(petFields(9))))
    ownerName = CStr(petFields(10))
    If botEntityId <= 0 Then botEntityId = botId

    RepresentedPetStatusPayload = "IY" & CStr(Proc_3_0_6D2AF0(botEntityId, Empty, vbNullString)) & petName & Chr$(2)
    RepresentedPetStatusPayload = RepresentedPetStatusPayload & CStr(Proc_3_0_6D2AF0(petLevel, Empty, vbNullString))
    RepresentedPetStatusPayload = RepresentedPetStatusPayload & CStr(Proc_3_0_6D2AF0(petExperience, Empty, vbNullString))
    RepresentedPetStatusPayload = RepresentedPetStatusPayload & CStr(Proc_3_0_6D2AF0(petEnergy, Empty, vbNullString))
    RepresentedPetStatusPayload = RepresentedPetStatusPayload & CStr(Proc_3_0_6D2AF0(petNutrition, Empty, vbNullString))
    RepresentedPetStatusPayload = RepresentedPetStatusPayload & CStr(Proc_3_0_6D2AF0(petScratches, Empty, vbNullString))
    RepresentedPetStatusPayload = RepresentedPetStatusPayload & petFigure & Chr$(2)
    RepresentedPetStatusPayload = RepresentedPetStatusPayload & CStr(Proc_3_0_6D2AF0(petAgeDays, Empty, vbNullString))
    RepresentedPetStatusPayload = RepresentedPetStatusPayload & CStr(Proc_3_0_6D2AF0(ownerId, Empty, vbNullString)) & ownerName & Chr$(2)
    Exit Function

PayloadFailed:
    RepresentedPetStatusPayload = vbNullString
End Function

Private Function RepresentedPetLevelMaxExperience(ByVal petLevel As Long) As Long
    Dim fields() As String

    On Error GoTo LookupFailed
    If petLevel < 0 Then GoTo LookupFailed

    If IsArray(global_008292D0) Then
        If petLevel >= LBound(global_008292D0) And petLevel <= UBound(global_008292D0) Then
            If Len(CStr(global_008292D0(petLevel))) > 0 Then
                fields = Split(CStr(global_008292D0(petLevel)), Chr$(9))
                If UBound(fields) >= 1 Then
                    RepresentedPetLevelMaxExperience = CLng(Val(CStr(fields(1))))
                    Exit Function
                End If
            End If
        End If
    End If

    RepresentedPetLevelMaxExperience = CLng(Val(CStr(Proc_5_2_6D4690("SELECT max_exp FROM bots_petlevels WHERE id_level='" & _
        CStr(petLevel) & "' LIMIT 1", 0, 0))))
    Exit Function

LookupFailed:
    RepresentedPetLevelMaxExperience = 0
End Function

Private Function RepresentedPetCommandAction(ByVal commandId As Long, ByRef requiredLevel As Long, ByRef commandAction As String) As Boolean
    Dim commandIndex As Long
    Dim commandFields() As String
    Dim rowText As String
    Dim rowFields() As String

    On Error GoTo LookupFailed
    requiredLevel = 0
    commandAction = vbNullString
    If commandId <= 0 Then GoTo LookupFailed

    If IsArray(global_008292CC) Then
        For commandIndex = LBound(global_008292CC) To UBound(global_008292CC)
            If Len(CStr(global_008292CC(commandIndex))) > 0 Then
                commandFields = Split(CStr(global_008292CC(commandIndex)), Chr$(9))
                If UBound(commandFields) >= 1 Then
                    If CLng(Val(CStr(commandFields(0)))) = commandId Then
                        requiredLevel = CLng(Val(CStr(commandFields(1))))
                        If UBound(commandFields) >= 3 Then commandAction = CStr(commandFields(3))
                        RepresentedPetCommandAction = True
                        Exit Function
                    End If
                End If
            End If
        Next commandIndex
    End If

    rowText = CStr(Proc_5_2_6D4690("SELECT petlevel_required,command_action FROM bots_petcommands WHERE id_command='" & _
        CStr(commandId) & "' LIMIT 1", 0, 0))
    If Len(rowText) = 0 Then GoTo LookupFailed

    rowFields = Split(rowText, Chr$(9))
    If UBound(rowFields) < 0 Then GoTo LookupFailed
    requiredLevel = CLng(Val(CStr(rowFields(0))))
    If UBound(rowFields) >= 1 Then commandAction = CStr(rowFields(1))
    RepresentedPetCommandAction = True
    Exit Function

LookupFailed:
    RepresentedPetCommandAction = False
End Function

Private Function IsRepresentedBotAllocated(ByVal roomSlot As Long, ByVal botId As Long) As Boolean
    Dim records() As String
    Dim recordIndex As Long
    Dim recordText As String
    Dim payloadAt As Long
    Dim endAt As Long
    Dim fields() As String

    On Error GoTo NotAllocated
    If roomSlot <= 0 Or botId <= 0 Or Len(global_00829358) = 0 Then GoTo NotAllocated

    records = Split(global_00829358, "[")
    For recordIndex = LBound(records) To UBound(records)
        recordText = CStr(records(recordIndex))
        If Len(recordText) > 0 Then
            endAt = InStr(1, recordText, "]", vbBinaryCompare)
            payloadAt = InStr(1, recordText, ":", vbBinaryCompare)
            If endAt > payloadAt And payloadAt > 0 Then
                fields = Split(Mid$(recordText, payloadAt + 1, endAt - payloadAt - 1), Chr$(2))
                If UBound(fields) >= 1 Then
                    If CLng(Val(CStr(fields(0)))) = roomSlot And CLng(Val(CStr(fields(1)))) = botId Then
                        IsRepresentedBotAllocated = True
                        Exit Function
                    End If
                End If
            End If
        End If
    Next recordIndex

NotAllocated:
    IsRepresentedBotAllocated = False
End Function

Private Function AvatarNameValidationCode(ByVal candidateName As String, ByVal currentName As String) As Long
    Dim index As Long
    Dim characterCode As Long
    Dim existingCount As Long

    On Error GoTo InvalidName

    candidateName = Trim$(candidateName)
    If Len(candidateName) < 3 Then GoTo InvalidName
    If Len(candidateName) > 14 Then
        AvatarNameValidationCode = 1
        Exit Function
    End If
    If UCase$(Left$(candidateName, 4)) = "MOD-" Or UCase$(Left$(candidateName, 4)) = "VIP-" Then GoTo InvalidName

    For index = 1 To Len(candidateName)
        characterCode = Asc(Mid$(candidateName, index, 1))
        If Not ((characterCode >= 65 And characterCode <= 90) Or (characterCode >= 97 And characterCode <= 122) Or (characterCode >= 48 And characterCode <= 57) Or characterCode = 45 Or characterCode = 95) Then
            GoTo InvalidName
        End If
    Next index

    If StrComp(candidateName, currentName, vbTextCompare) = 0 Then
        AvatarNameValidationCode = 0
        Exit Function
    End If

    existingCount = CLng(Val(CStr(Proc_5_2_6D4690("SELECT COUNT(*) FROM users WHERE name='" & Proc_10_11_80A9C0(candidateName, 0, 0) & "'", 0, 0))))
    If existingCount > 0 Then
        AvatarNameValidationCode = 3
    Else
        AvatarNameValidationCode = 0
    End If
    Exit Function

InvalidName:
    AvatarNameValidationCode = 2
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

Private Function HandlingUserName(ByVal userId As String) As String
    On Error GoTo LookupFailed
    If Len(userId) = 0 Or userId = "0" Then GoTo LookupFailed

    HandlingUserName = CStr(Proc_5_2_6D4690("SELECT name FROM users WHERE id='" & Proc_10_11_80A9C0(userId, 0, 0) & "' LIMIT 1", 0, 0))
    Exit Function

LookupFailed:
    HandlingUserName = vbNullString
End Function

Private Function HandlingUserSessionId(ByVal userId As String) As String
    On Error GoTo LookupFailed
    If Len(userId) = 0 Or userId = "0" Then GoTo LookupFailed

    HandlingUserSessionId = CStr(Proc_5_2_6D4690("SELECT id_session FROM users WHERE id='" & _
        Proc_10_11_80A9C0(userId, 0, 0) & "' LIMIT 1", 0, 0))
    Exit Function

LookupFailed:
    HandlingUserSessionId = vbNullString
End Function

Private Function HandlingSocketIndexForUserName(ByVal userName As String) As Integer
    Dim rowText As String
    Dim fields() As String

    On Error GoTo LookupFailed
    If Len(userName) = 0 Then GoTo LookupFailed

    rowText = CStr(Proc_5_2_6D4690("SELECT id_socket FROM users WHERE name='" & _
        Proc_10_11_80A9C0(userName, 0, 0) & "' AND id_socket IS NOT NULL LIMIT 1", 0, 0))
    If Len(rowText) = 0 Then GoTo LookupFailed

    fields = Split(rowText, Chr$(9))
    HandlingSocketIndexForUserName = CInt(Val(HandlingField(fields, 0)))
    Exit Function

LookupFailed:
    HandlingSocketIndexForUserName = 0
End Function

Private Function MessengerFriendSummaryPayload(ByVal userId As String, ByVal relationshipState As Long) As String
    Dim rowText As String
    Dim fields As Variant
    Dim socketIndex As Integer
    Dim dateFormat As String
    Dim timeFormat As String

    On Error GoTo BuildFailed
    If Len(userId) = 0 Or userId = "0" Then GoTo BuildFailed

    dateFormat = CStr(Proc_10_0_809570("com.mysql.format.date", "%d-%m-%Y", 0))
    timeFormat = CStr(Proc_10_0_809570("com.mysql.format.time", "%H:%i", 0))
    rowText = CStr(Proc_5_2_6D4690("SELECT id,name,motto,figure,level,id_socket,DATE_FORMAT(FROM_UNIXTIME(lastonline_time), '" & _
        Proc_10_11_80A9C0(dateFormat & " " & timeFormat, 0, 0) & "') FROM users WHERE id='" & Proc_10_11_80A9C0(userId, 0, 0) & "' LIMIT 1", 0, 0))
    If Len(rowText) = 0 Then GoTo BuildFailed

    fields = Split(rowText, Chr$(9))
    If UBound(fields) < 6 Then GoTo BuildFailed

    socketIndex = CInt(Val(CStr(fields(5))))
    MessengerFriendSummaryPayload = CStr(Proc_6_166_7BE940(CLng(Val(CStr(fields(0)))), CStr(fields(1)), CStr(fields(2)), CStr(fields(3)), _
        CLng(Val(CStr(fields(4)))), IIf(socketIndex > 0, 2, 0), IIf(socketIndex > 0, 1, 0), CStr(fields(6)), relationshipState))
    Exit Function

BuildFailed:
    MessengerFriendSummaryPayload = vbNullString
End Function

Private Function MessengerSearchResultPayload(ByVal userId As String, ByVal userName As String, ByVal figureText As String, ByVal mottoText As String, ByVal nicknameText As String, ByVal lastOnlineText As String, ByVal isOnline As Long) As String
    Dim payload As String

    On Error GoTo BuildFailed

    payload = CStr(Proc_3_0_6D2AF0(CLng(Val(userId)), Empty, vbNullString))
    payload = payload & userName & Chr$(2) & mottoText & Chr$(2)
    payload = "1" & CStr(Proc_3_0_6D2AF0(isOnline, Empty, payload)) & "H" & Chr$(2)
    payload = payload & nicknameText & Chr$(2) & figureText & Chr$(2) & lastOnlineText & Chr$(2)

    MessengerSearchResultPayload = payload
    Exit Function

BuildFailed:
    MessengerSearchResultPayload = vbNullString
End Function

Private Function MessengerMaxFriends(ByVal configIndex As Long) As Long
    On Error GoTo LookupFailed

    MessengerMaxFriends = CLng(Val(CStr(global_0082927C(configIndex))))
    Exit Function

LookupFailed:
    MessengerMaxFriends = 0
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

Private Function BroadcastToStaffModerators(ByVal payload As String) As Long
    Dim records() As String
    Dim recordIndex As Long
    Dim recordText As String
    Dim payloadStart As Long
    Dim payloadEnd As Long
    Dim fields() As String
    Dim candidateSocket As Integer
    Dim candidateUserId As String
    Dim sentMarkers As String
    Dim sentCount As Long
    Dim rowText As String
    Dim rows() As String
    Dim rowFields() As String
    Dim rowIndex As Long

    On Error GoTo BroadcastDone
    If Len(payload) = 0 Then GoTo BroadcastDone

    If Len(global_00829268) > 0 Then
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
                        candidateUserId = CStr(Val(CStr(fields(0))))
                        candidateSocket = CInt(Val(CStr(fields(1))))
                        If candidateUserId = "0" Then candidateUserId = HandlingUserIdFromSocket(candidateSocket)
                        If candidateSocket > 0 Then
                            If InStr(1, sentMarkers, "[" & CStr(candidateSocket) & "]", vbBinaryCompare) = 0 Then
                                If HandlingUserHasPermission(candidateUserId, "fuse_mod") Then
                                    Proc_6_244_801E80 candidateSocket, payload, 0
                                    sentMarkers = sentMarkers & "[" & CStr(candidateSocket) & "]"
                                    sentCount = sentCount + 1
                                End If
                            End If
                        End If
                    End If
                End If
            End If
        Next recordIndex
    End If

    rowText = CStr(Proc_5_2_6D4690("SELECT id,id_socket FROM users WHERE id_socket IS NOT NULL", 0, 0))
    If Len(rowText) > 0 Then
        rows = Split(rowText, Chr$(13))
        For rowIndex = LBound(rows) To UBound(rows)
            If Len(rows(rowIndex)) > 0 Then
                rowFields = Split(rows(rowIndex), Chr$(9))
                If UBound(rowFields) >= 1 Then
                    candidateUserId = CStr(Val(CStr(rowFields(0))))
                    candidateSocket = CInt(Val(CStr(rowFields(1))))
                    If candidateSocket > 0 Then
                        If InStr(1, sentMarkers, "[" & CStr(candidateSocket) & "]", vbBinaryCompare) = 0 Then
                            If HandlingUserHasPermission(candidateUserId, "fuse_mod") Then
                                Proc_6_244_801E80 candidateSocket, payload, 0
                                sentMarkers = sentMarkers & "[" & CStr(candidateSocket) & "]"
                                sentCount = sentCount + 1
                            End If
                        End If
                    End If
                End If
            End If
        Next rowIndex
    End If

BroadcastDone:
    BroadcastToStaffModerators = sentCount
End Function

Private Function BroadcastToRoomUsers(ByVal roomId As Long, ByVal payload As String) As Long
    Dim rowText As String
    Dim rows() As String
    Dim fields() As String
    Dim rowIndex As Long
    Dim socketIndex As Integer
    Dim sentMarkers As String
    Dim sentCount As Long

    On Error GoTo BroadcastDone
    If roomId <= 0 Or Len(payload) = 0 Then GoTo BroadcastDone

    rowText = CStr(Proc_5_2_6D4690("SELECT users.id_socket FROM logs_visitedrooms,users WHERE logs_visitedrooms.id_room='" & CStr(roomId) & "' AND logs_visitedrooms.timestamp_left IS NULL AND users.id=logs_visitedrooms.id_user AND users.id_socket IS NOT NULL", 0, 0))
    If Len(rowText) = 0 Then
        rowText = CStr(Proc_5_2_6D4690("SELECT id_socket FROM users WHERE id_socket IS NOT NULL AND id IN (SELECT id_user FROM logs_visitedrooms WHERE id_room='" & CStr(roomId) & "' AND timestamp_left IS NULL)", 0, 0))
    End If

    If Len(rowText) > 0 Then
        rows = Split(rowText, Chr$(13))
        For rowIndex = LBound(rows) To UBound(rows)
            If Len(rows(rowIndex)) > 0 Then
                fields = Split(rows(rowIndex), Chr$(9))
                socketIndex = CInt(Val(CStr(fields(0))))
                If socketIndex > 0 Then
                    If InStr(1, sentMarkers, "[" & CStr(socketIndex) & "]", vbBinaryCompare) = 0 Then
                        Proc_6_244_801E80 socketIndex, payload, 0
                        sentMarkers = sentMarkers & "[" & CStr(socketIndex) & "]"
                        sentCount = sentCount + 1
                    End If
                End If
            End If
        Next rowIndex
    End If

BroadcastDone:
    BroadcastToRoomUsers = sentCount
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

Private Function StaffRoomVisitPayload(ByRef fields() As String) As String
    Dim modelType As Long
    Dim roomId As Long
    Dim enterHour As Long
    Dim enterMinute As Long
    Dim payload As String

    On Error GoTo BuildFailed

    modelType = CLng(Val(HandlingField(fields, 0)))
    roomId = CLng(Val(HandlingField(fields, 1)))
    enterHour = CLng(Val(HandlingField(fields, 3)))
    enterMinute = CLng(Val(HandlingField(fields, 4)))

    payload = CStr(Proc_3_0_6D2AF0(modelType, Empty, vbNullString))
    payload = CStr(Proc_3_0_6D2AF0(roomId, Empty, payload))
    payload = CStr(Proc_3_0_6D2AF0(enterHour, Empty, payload))
    payload = CStr(Proc_3_0_6D2AF0(enterMinute, Empty, payload))
    StaffRoomVisitPayload = payload & HandlingField(fields, 2) & Chr$(2)
    Exit Function

BuildFailed:
    StaffRoomVisitPayload = vbNullString
End Function

Private Function StaffNestedUserIdFromWire(ByVal packetPayload As String) As String
    Dim offset As Long
    Dim nestedPayload As String
    Dim userId As String

    On Error GoTo ParseFailed

    userId = CStr(Val(CStr(Proc_10_6_809F10(packetPayload, 0, 0))))
    If Len(userId) > 0 And userId <> "0" Then
        StaffNestedUserIdFromWire = userId
        Exit Function
    End If

    offset = 1
    nestedPayload = ReadWireString(packetPayload, offset)
    userId = CStr(Val(CStr(Proc_10_6_809F10(nestedPayload, 0, 0))))
    If Len(userId) = 0 Or userId = "0" Then userId = CStr(ReadWireLong(packetPayload, offset))

    StaffNestedUserIdFromWire = userId
    Exit Function

ParseFailed:
    StaffNestedUserIdFromWire = vbNullString
End Function

Private Function StaffRoomChatHistoryPayload(ByRef visitFields() As String, ByVal targetUserId As Long) As String
    Dim modelType As Long
    Dim roomId As Long
    Dim roomName As String
    Dim timestampEnter As Long
    Dim timestampLeft As Long
    Dim chatRows As String
    Dim chatPayload As String
    Dim chatCount As Long
    Dim payload As String

    On Error GoTo BuildFailed

    modelType = CLng(Val(HandlingField(visitFields, 0)))
    roomId = CLng(Val(HandlingField(visitFields, 1)))
    roomName = HandlingField(visitFields, 2)
    timestampEnter = CLng(Val(HandlingField(visitFields, 3)))
    timestampLeft = CLng(Val(HandlingField(visitFields, 4)))

    chatRows = StaffRoomChatRows(roomId, targetUserId, timestampEnter, timestampLeft)
    chatPayload = StaffRoomChatRowsPayload(chatRows, chatCount)

    payload = CStr(Proc_3_0_6D2AF0(modelType, Empty, vbNullString))
    payload = CStr(Proc_3_0_6D2AF0(roomId, Empty, payload))
    payload = CStr(Proc_3_0_6D2AF0(chatCount, Empty, payload))
    StaffRoomChatHistoryPayload = payload & roomName & Chr$(2) & chatPayload
    Exit Function

BuildFailed:
    StaffRoomChatHistoryPayload = vbNullString
End Function

Private Function StaffRoomChatRows(ByVal roomId As Long, ByVal targetUserId As Long, ByVal timestampEnter As Long, ByVal timestampLeft As Long) As String
    Dim upperBound As String
    Dim lowerBound As String

    On Error GoTo QueryFailed

    If timestampLeft > 0 Then
        upperBound = " AND logs_chat.timestamp < " & CStr(timestampLeft)
        lowerBound = " AND logs_chat.timestamp > " & CStr(timestampEnter)
    Else
        lowerBound = " AND logs_chat.timestamp > UNIX_TIMESTAMP()-600"
    End If

    StaffRoomChatRows = CStr(Proc_5_2_6D4690("SELECT DATE_FORMAT(FROM_UNIXTIME(logs_chat.timestamp), '" & Chr$(37) & _
        "H'),DATE_FORMAT(FROM_UNIXTIME(logs_chat.timestamp), '" & Chr$(37) & _
        "i'),users.id,users.name,logs_chat.description FROM logs_chat,rooms,users WHERE logs_chat.id_room='" & _
        CStr(roomId) & "'" & upperBound & lowerBound & " AND (users.id=logs_chat.id_user OR logs_chat.id_partner='" & _
        Proc_10_11_80A9C0(CStr(targetUserId), 0, 0) & "') AND users.id=logs_chat.id_user GROUP BY logs_chat.id ORDER BY logs_chat.id DESC LIMIT 50", 0, 0))
    Exit Function

QueryFailed:
    StaffRoomChatRows = vbNullString
End Function

Private Function StaffRoomChatRowsPayload(ByVal chatRows As String, ByRef chatCount As Long) As String
    Dim rows() As String
    Dim fields() As String
    Dim rowIndex As Long
    Dim payload As String

    On Error GoTo BuildFailed
    chatCount = 0
    If Len(chatRows) = 0 Then Exit Function

    rows = Split(chatRows, Chr$(13))
    For rowIndex = LBound(rows) To UBound(rows)
        If Len(rows(rowIndex)) > 0 Then
            fields = Split(rows(rowIndex), Chr$(9))
            If UBound(fields) >= 4 Then
                payload = payload & CStr(Proc_3_0_6D2AF0(CLng(Val(HandlingField(fields, 0))), Empty, vbNullString))
                payload = payload & CStr(Proc_3_0_6D2AF0(CLng(Val(HandlingField(fields, 1))), Empty, vbNullString))
                payload = payload & CStr(Proc_3_0_6D2AF0(CLng(Val(HandlingField(fields, 2))), Empty, vbNullString))
                payload = payload & HandlingField(fields, 3) & Chr$(2)
                payload = payload & HandlingField(fields, 4) & Chr$(2)
                chatCount = chatCount + 1
            End If
        End If
    Next rowIndex

    StaffRoomChatRowsPayload = payload
    Exit Function

BuildFailed:
    StaffRoomChatRowsPayload = payload
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

Private Function RemoveRepresentedCacheRecord(ByVal cacheText As String, ByVal markerText As String) As String
    Dim markerAt As Long
    Dim recordStart As Long
    Dim recordEnd As Long

    On Error GoTo RemoveFallback
    RemoveRepresentedCacheRecord = cacheText
    If Len(cacheText) = 0 Or Len(markerText) = 0 Then Exit Function

    markerAt = InStr(1, cacheText, markerText, vbBinaryCompare)
    Do While markerAt > 0
        recordStart = InStrRev(cacheText, Chr$(1), markerAt, vbBinaryCompare)
        If recordStart <= 0 Then recordStart = markerAt

        recordEnd = InStr(markerAt + Len(markerText), cacheText, Chr$(2), vbBinaryCompare)
        If recordEnd <= 0 Then recordEnd = markerAt + Len(markerText) - 1

        cacheText = Left$(cacheText, recordStart - 1) & Mid$(cacheText, recordEnd + 1)
        markerAt = InStr(1, cacheText, markerText, vbBinaryCompare)
    Loop

    RemoveRepresentedCacheRecord = cacheText
    Exit Function

RemoveFallback:
    RemoveRepresentedCacheRecord = Replace(cacheText, markerText, vbNullString, 1, -1, vbBinaryCompare)
End Function

Private Function HandlingRepresentedRoomRecord(ByVal roomSlot As Long) As String
    Dim cacheText As String
    Dim markerText As String
    Dim startAt As Long
    Dim endAt As Long

    On Error GoTo LookupFailed
    cacheText = CStr(global_00829310)
    markerText = Chr$(1) & CStr(roomSlot) & Chr$(9)
    startAt = InStr(1, cacheText, markerText, vbBinaryCompare)
    If startAt = 0 Then
        markerText = Chr$(1) & CStr(roomSlot) & Chr$(2)
        startAt = InStr(1, cacheText, markerText, vbBinaryCompare)
    End If
    If startAt = 0 Then GoTo LookupFailed

    startAt = startAt + 1
    endAt = InStr(startAt, cacheText, Chr$(2), vbBinaryCompare)
    If endAt = 0 Then endAt = Len(cacheText) + 1
    HandlingRepresentedRoomRecord = Mid$(cacheText, startAt, endAt - startAt)
    Exit Function

LookupFailed:
    HandlingRepresentedRoomRecord = vbNullString
End Function

Private Sub HandlingEnsureFieldCount(ByRef fields() As String, ByVal lastIndex As Long)
    On Error GoTo EmptyFields
    If UBound(fields) >= lastIndex Then Exit Sub
    ReDim Preserve fields(LBound(fields) To lastIndex)
    Exit Sub

EmptyFields:
    ReDim fields(0 To lastIndex)
End Sub

Private Sub HandlingRepresentedRoomRecordSet(ByVal roomSlot As Long, ByVal roomRecord As String)
    Dim cacheText As String

    If roomSlot <= 0 Then Exit Sub

    cacheText = CStr(global_00829310)
    cacheText = RemoveRepresentedCacheRecord(cacheText, Chr$(1) & CStr(roomSlot) & Chr$(9))
    cacheText = RemoveRepresentedCacheRecord(cacheText, Chr$(1) & CStr(roomSlot) & Chr$(2))
    global_00829310 = cacheText & Chr$(1) & roomRecord & Chr$(2)
End Sub

Private Function HandlingMovementField(ByVal movementText As String, ByVal fieldIndex As Long) As Long
    Dim fields() As String

    On Error GoTo LookupFailed
    fields = Split(movementText, Chr$(0))
    If fieldIndex <= UBound(fields) Then HandlingMovementField = CLng(Val(CStr(fields(fieldIndex))))
    Exit Function

LookupFailed:
    HandlingMovementField = 0
End Function

Private Function HandlingDirectionCode(ByVal deltaX As Long, ByVal deltaY As Long) As Long
    If deltaX = 0 And deltaY < 0 Then
        HandlingDirectionCode = 0
    ElseIf deltaX > 0 And deltaY < 0 Then
        HandlingDirectionCode = 1
    ElseIf deltaX > 0 And deltaY = 0 Then
        HandlingDirectionCode = 2
    ElseIf deltaX > 0 And deltaY > 0 Then
        HandlingDirectionCode = 3
    ElseIf deltaX = 0 And deltaY > 0 Then
        HandlingDirectionCode = 4
    ElseIf deltaX < 0 And deltaY > 0 Then
        HandlingDirectionCode = 5
    ElseIf deltaX < 0 And deltaY = 0 Then
        HandlingDirectionCode = 6
    ElseIf deltaX < 0 And deltaY < 0 Then
        HandlingDirectionCode = 7
    Else
        HandlingDirectionCode = 0
    End If
End Function

Private Function HandlingRepresentedMovementPosition(ByVal roomSlot As Long, ByVal entityIndex As Long, ByRef positionX As Long, ByRef positionY As Long) As Boolean
    Dim roomRecord As String
    Dim fields() As String
    Dim movementRecord As String
    Dim movementFields() As String
    Dim parts() As String
    Dim partIndex As Long

    On Error GoTo LookupFailed
    roomRecord = HandlingRepresentedRoomRecord(roomSlot)
    If Len(roomRecord) = 0 Then GoTo LookupFailed

    fields = Split(roomRecord, Chr$(9))
    If UBound(fields) < 4 Then GoTo LookupFailed

    parts = Split(CStr(fields(4)), Chr$(1))
    For partIndex = LBound(parts) To UBound(parts)
        movementRecord = CStr(parts(partIndex))
        If Len(movementRecord) > 0 Then
            If Right$(movementRecord, 1) = Chr$(2) Then movementRecord = Left$(movementRecord, Len(movementRecord) - 1)
            movementFields = Split(movementRecord, Chr$(9))
            If UBound(movementFields) >= 2 Then
                If CLng(Val(CStr(movementFields(0)))) = entityIndex Then
                    positionX = CLng(Val(CStr(movementFields(1))))
                    positionY = CLng(Val(CStr(movementFields(2))))
                    HandlingRepresentedMovementPosition = True
                    Exit Function
                End If
            End If
        End If
    Next partIndex

LookupFailed:
    HandlingRepresentedMovementPosition = False
End Function

Private Sub HandlingRepresentedRoomOccupantMove(ByVal roomSlot As Long, ByVal entityIndex As Long, ByVal positionX As Long, ByVal positionY As Long, ByVal directionValue As Long, ByVal movingValue As Long)
    Dim roomRecord As String
    Dim fields() As String
    Dim movementRecord As String

    If roomSlot <= 0 Or entityIndex <= 0 Then Exit Sub

    roomRecord = HandlingRepresentedRoomRecord(roomSlot)
    If Len(roomRecord) = 0 Then roomRecord = CStr(roomSlot) & Chr$(9) & vbNullString & Chr$(9) & vbNullString & Chr$(9) & "0"

    fields = Split(roomRecord, Chr$(9))
    HandlingEnsureFieldCount fields, 4

    movementRecord = CStr(entityIndex) & Chr$(9) & CStr(positionX) & Chr$(9) & CStr(positionY) & Chr$(9) & CStr(directionValue) & Chr$(9) & CStr(movingValue)
    fields(4) = RemoveRepresentedCacheRecord(CStr(fields(4)), Chr$(1) & CStr(entityIndex) & Chr$(9))
    fields(4) = CStr(fields(4)) & Chr$(1) & movementRecord & Chr$(2)

    HandlingRepresentedRoomRecordSet roomSlot, Join(fields, Chr$(9))
End Sub

Private Function HandlingRepresentedFurnitureStateWrite(ByRef args() As Variant) As Variant
    Dim roomId As Long
    Dim furnitureId As Long
    Dim stateText As String
    Dim markerText As String
    Dim roomCacheText As String

    On Error GoTo StateWriteDone

    If UBound(args) >= 2 Then
        roomId = CLng(Val(CStr(args(0))))
        furnitureId = CLng(Val(CStr(args(1))))
        stateText = CStr(args(2))
    ElseIf UBound(args) >= 1 Then
        furnitureId = CLng(Val(CStr(args(0))))
        stateText = CStr(args(1))
    End If

    If furnitureId <= 0 Then GoTo StateWriteDone
    If roomId <= 0 Then roomId = CLng(Val(CStr(Proc_5_2_6D4690("SELECT id_room FROM furnitures WHERE id='" & CStr(furnitureId) & "' LIMIT 1", 0, 0))))

    markerText = Chr$(1) & CStr(furnitureId) & Chr$(2)
    global_008291FC = Replace(global_008291FC, markerText, vbNullString, 1, -1, vbBinaryCompare)
    global_008291FC = global_008291FC & markerText

    If roomId > 0 Then
        markerText = Chr$(1) & CStr(roomId) & Chr$(2)
        global_008291F8 = Replace(global_008291F8, markerText, vbNullString, 1, -1, vbBinaryCompare)
        global_008291F8 = global_008291F8 & markerText
    End If

    roomCacheText = CStr(global_00829310)
    roomCacheText = RemoveRepresentedCacheRecord(roomCacheText, Chr$(1) & CStr(furnitureId) & Chr$(2))
    roomCacheText = RemoveRepresentedCacheRecord(roomCacheText, Chr$(1) & CStr(furnitureId) & Chr$(9))
    roomCacheText = roomCacheText & Chr$(1) & CStr(furnitureId) & Chr$(9) & CStr(roomId) & Chr$(9) & stateText & Chr$(2)
    global_00829310 = roomCacheText

    If roomId > 0 Then
        Proc_6_106_74B750 App.Path & "\CACHE\ROOMS\" & CStr(roomId) & ".cache", 0, 0
        Proc_6_106_74B750 App.Path & "\CACHE\PATHFINDER\" & CStr(roomId) & ".cache", 0, 0
    End If

StateWriteDone:
    HandlingRepresentedFurnitureStateWrite = Empty
End Function

Private Function StickyNoteUpdateFromWire(ByVal packetPayload As String, ByRef furnitureId As Long, ByRef noteColor As String, ByRef noteCaption As String) As Boolean
    Dim idText As String
    Dim idLengthSize As Long
    Dim notePayload As String
    Dim separatorAt As Long
    Dim offset As Long

    On Error GoTo ParseFailed

    idText = CStr(Proc_10_6_809F10(packetPayload, 0, 0))
    furnitureId = CLng(Val(idText))
    If furnitureId <= 0 Then
        offset = 1
        furnitureId = ReadWireLong(packetPayload, offset)
        notePayload = Mid$(packetPayload, offset)
    Else
        idLengthSize = CLng(Proc_3_2_6D30A0(packetPayload, 0, 0))
        If idLengthSize > 0 Then notePayload = Mid$(packetPayload, idLengthSize + Len(idText) + 1)
    End If

    If Len(notePayload) = 0 Then notePayload = CStr(Proc_10_7_80A190(packetPayload, 0, 0))
    If Len(notePayload) = 0 Then GoTo ParseFailed

    notePayload = Left$(notePayload, 510)
    separatorAt = InStr(1, notePayload, Chr$(13), vbBinaryCompare)
    If separatorAt = 0 Then separatorAt = InStr(1, notePayload, Chr$(10), vbBinaryCompare)
    If separatorAt = 0 Then separatorAt = InStr(1, notePayload, Chr$(2), vbBinaryCompare)

    If separatorAt > 0 Then
        noteColor = UCase$(Left$(notePayload, separatorAt - 1))
        noteCaption = Mid$(notePayload, separatorAt + 1)
    Else
        noteColor = UCase$(Left$(notePayload, 6))
        noteCaption = Mid$(notePayload, 7)
    End If

    noteColor = Left$(noteColor, 6)
    If Not IsStickyNoteColor(noteColor) Then GoTo ParseFailed

    noteCaption = Left$(noteCaption, 510)
    noteCaption = Replace(noteCaption, Chr$(160), Chr$(31), 1, -1, vbBinaryCompare)
    noteCaption = Replace(noteCaption, Chr$(13), Chr$(31), 1, -1, vbBinaryCompare)
    noteCaption = Replace(noteCaption, Chr$(10), Chr$(31), 1, -1, vbBinaryCompare)

    StickyNoteUpdateFromWire = True
    Exit Function

ParseFailed:
    StickyNoteUpdateFromWire = False
End Function

Private Function IsStickyNoteColor(ByVal noteColor As String) As Boolean
    Select Case UCase$(noteColor)
        Case "9CFF9C", "FFFF33", "FF9CFF", "9CCEFF"
            IsStickyNoteColor = True
    End Select
End Function

Private Function IsDimmerColour(ByVal colourText As String) As Boolean
    Select Case UCase$(colourText)
        Case "#0053F7", "#74F5F5", "#E759DE", "#EA4532", "#F2F851", "#82F349", "#000000"
            IsDimmerColour = True
    End Select
End Function

Private Function WallPlacementFromPayload(ByVal packetPayload As String, ByRef wallX As Long, ByRef wallY As Long, ByRef localX As Long, ByRef localY As Long) As Boolean
    Dim normalizedPayload As String
    Dim wallAt As Long
    Dim localAt As Long
    Dim wallText As String
    Dim localText As String
    Dim wallParts() As String
    Dim localParts() As String

    On Error GoTo ParseFailed

    normalizedPayload = Replace(packetPayload, Chr$(1), Chr$(32), 1, -1, vbBinaryCompare)
    normalizedPayload = Replace(normalizedPayload, Chr$(2), Chr$(32), 1, -1, vbBinaryCompare)
    normalizedPayload = Replace(normalizedPayload, Chr$(9), Chr$(32), 1, -1, vbBinaryCompare)
    normalizedPayload = Replace(normalizedPayload, Chr$(13), Chr$(32), 1, -1, vbBinaryCompare)
    normalizedPayload = Replace(normalizedPayload, Chr$(10), Chr$(32), 1, -1, vbBinaryCompare)
    Do While InStr(1, normalizedPayload, "  ", vbBinaryCompare) > 0
        normalizedPayload = Replace(normalizedPayload, "  ", " ", 1, -1, vbBinaryCompare)
    Loop
    normalizedPayload = Trim$(normalizedPayload)

    wallAt = InStr(1, normalizedPayload, ":w=", vbTextCompare)
    localAt = InStr(1, normalizedPayload, "l=", vbTextCompare)
    If wallAt <= 0 Or localAt <= wallAt Then GoTo ParseFailed

    wallText = Trim$(Mid$(normalizedPayload, wallAt + 3, localAt - (wallAt + 3)))
    localText = Trim$(Mid$(normalizedPayload, localAt + 2))
    wallText = Replace(wallText, Chr$(32), vbNullString, 1, -1, vbBinaryCompare)
    localText = Replace(localText, Chr$(32), vbNullString, 1, -1, vbBinaryCompare)

    wallParts = Split(wallText, ",")
    localParts = Split(localText, ",")
    If UBound(wallParts) < 1 Or UBound(localParts) < 1 Then GoTo ParseFailed

    wallX = CLng(Val(wallParts(0)))
    wallY = CLng(Val(wallParts(1)))
    localX = CLng(Val(localParts(0)))
    localY = CLng(Val(localParts(1)))
    WallPlacementFromPayload = True
    Exit Function

ParseFailed:
    WallPlacementFromPayload = False
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

Private Function RoomSettingsFromWire(ByVal packetPayload As String, ByRef roomName As String, ByRef roomPassword As String, ByRef doorStatus As Long, ByRef roomDescription As String, ByRef visitorsMax As Long, ByRef categoryId As Long, ByRef tagOne As String, ByRef tagTwo As String, ByRef allowOthersPets As Long, ByRef allowFeedPets As Long, ByRef allowWalkthrough As Long, ByRef disableWalls As Long, ByRef thicknessFloor As Long, ByRef thicknessWallpaper As Long) As Boolean
    Dim offset As Long
    Dim tagCount As Long
    Dim tagIndex As Long
    Dim tagText As String
    Dim previousOffset As Long

    On Error GoTo ParseFailed

    offset = 1
    roomName = CStr(Proc_10_10_80A7F0(ReadWireString(packetPayload, offset), 0, 0))
    If Len(roomName) < 3 Then GoTo ParseFailed
    roomName = Left$(roomName, 60)

    roomPassword = CStr(Proc_10_10_80A7F0(ReadWireString(packetPayload, offset), 0, 0))
    roomPassword = Left$(roomPassword, 60)

    doorStatus = ReadWireLong(packetPayload, offset)
    If doorStatus < 0 Or doorStatus > 2 Then GoTo ParseFailed

    roomDescription = CStr(Proc_10_10_80A7F0(ReadWireString(packetPayload, offset), 0, 0))
    roomDescription = Left$(roomDescription, 255)

    visitorsMax = ReadWireLong(packetPayload, offset)
    If visitorsMax < 1 Then visitorsMax = 1
    If visitorsMax > 250 Then visitorsMax = 250

    categoryId = ReadWireLong(packetPayload, offset)
    If categoryId <= 0 Then GoTo ParseFailed

    tagCount = ReadWireLong(packetPayload, offset)
    If tagCount < 0 Or tagCount > 2 Then GoTo ParseFailed

    For tagIndex = 1 To tagCount
        tagText = LCase$(Left$(CStr(Proc_10_10_80A7F0(ReadWireString(packetPayload, offset), 0, 0)), 60))
        If tagIndex = 1 Then
            tagOne = tagText
        ElseIf tagIndex = 2 Then
            tagTwo = tagText
        End If
    Next tagIndex

    previousOffset = offset
    allowOthersPets = ReadWireLong(packetPayload, offset)
    If offset <= previousOffset Then allowOthersPets = 0

    previousOffset = offset
    allowFeedPets = ReadWireLong(packetPayload, offset)
    If offset <= previousOffset Then allowFeedPets = 0

    previousOffset = offset
    allowWalkthrough = ReadWireLong(packetPayload, offset)
    If offset <= previousOffset Then allowWalkthrough = 0

    previousOffset = offset
    disableWalls = ReadWireLong(packetPayload, offset)
    If offset <= previousOffset Then disableWalls = 0

    previousOffset = offset
    thicknessFloor = ReadWireLong(packetPayload, offset)
    If offset <= previousOffset Then thicknessFloor = 0

    previousOffset = offset
    thicknessWallpaper = ReadWireLong(packetPayload, offset)
    If offset <= previousOffset Then thicknessWallpaper = 0

    allowOthersPets = RoomSettingsFlag(allowOthersPets)
    allowFeedPets = RoomSettingsFlag(allowFeedPets)
    allowWalkthrough = RoomSettingsFlag(allowWalkthrough)
    disableWalls = RoomSettingsFlag(disableWalls)
    thicknessFloor = RoomSettingsThickness(thicknessFloor)
    thicknessWallpaper = RoomSettingsThickness(thicknessWallpaper)

    RoomSettingsFromWire = True
    Exit Function

ParseFailed:
    RoomSettingsFromWire = False
End Function

Private Function RoomSettingsReadPayload(ByRef roomFields() As String, ByVal rightsRow As String) As String
    Dim tagPayload As String
    Dim tagCount As Long
    Dim rightsPayload As String
    Dim rightsCount As Long
    Dim rightsRows() As String
    Dim rightsFields() As String
    Dim rowIndex As Long
    Dim payload As String

    On Error GoTo BuildFailed

    If Len(HandlingField(roomFields, 7)) > 0 Then
        tagPayload = tagPayload & HandlingField(roomFields, 7) & Chr$(2)
        tagCount = tagCount + 1
    End If
    If Len(HandlingField(roomFields, 8)) > 0 Then
        tagPayload = tagPayload & HandlingField(roomFields, 8) & Chr$(2)
        tagCount = tagCount + 1
    End If

    If Len(rightsRow) > 0 Then
        rightsRows = Split(rightsRow, Chr$(13))
        For rowIndex = LBound(rightsRows) To UBound(rightsRows)
            If Len(rightsRows(rowIndex)) > 0 Then
                rightsFields = Split(rightsRows(rowIndex), Chr$(9))
                If UBound(rightsFields) >= 1 Then
                    rightsPayload = CStr(Proc_3_0_6D2AF0(CLng(Val(HandlingField(rightsFields, 0))), Empty, rightsPayload)) & HandlingField(rightsFields, 1) & Chr$(2)
                    rightsCount = rightsCount + 1
                End If
            End If
        Next rowIndex
    End If

    payload = CStr(Proc_3_0_6D2AF0(CLng(Val(HandlingField(roomFields, 0))), Empty, "GQ"))
    payload = payload & HandlingField(roomFields, 1) & Chr$(2)
    payload = payload & HandlingField(roomFields, 2) & Chr$(2)
    payload = CStr(Proc_3_0_6D2AF0(CLng(Val(HandlingField(roomFields, 3))), Empty, payload))
    payload = CStr(Proc_3_0_6D2AF0(CLng(Val(HandlingField(roomFields, 4))), Empty, payload))
    payload = CStr(Proc_3_0_6D2AF0(CLng(Val(HandlingField(roomFields, 5))), Empty, payload))
    payload = CStr(Proc_3_0_6D2AF0(CLng(Val(HandlingField(roomFields, 6))), Empty, payload))
    payload = CStr(Proc_3_0_6D2AF0(tagCount, Empty, payload)) & tagPayload
    payload = CStr(Proc_3_0_6D2AF0(rightsCount, Empty, payload)) & rightsPayload & "H"
    payload = CStr(Proc_3_0_6D2AF0(CLng(Val(HandlingField(roomFields, 10))), Empty, payload))
    payload = CStr(Proc_3_0_6D2AF0(CLng(Val(HandlingField(roomFields, 11))), Empty, payload))
    payload = CStr(Proc_3_0_6D2AF0(CLng(Val(HandlingField(roomFields, 12))), Empty, payload))
    RoomSettingsReadPayload = CStr(Proc_3_0_6D2AF0(CLng(Val(HandlingField(roomFields, 13))), Empty, payload))
    Exit Function

BuildFailed:
    RoomSettingsReadPayload = vbNullString
End Function

Private Function RoomSettingsFlag(ByVal flagValue As Long) As Long
    If flagValue <> 0 Then
        RoomSettingsFlag = 1
    Else
        RoomSettingsFlag = 0
    End If
End Function

Private Function RoomSettingsThickness(ByVal thicknessValue As Long) As Long
    If thicknessValue < -2 Then thicknessValue = -2
    If thicknessValue > 1 Then thicknessValue = 1
    RoomSettingsThickness = thicknessValue
End Function

Private Function RoomCategoryForUser(ByVal categoryId As Long, ByVal userId As String) As Long
    Dim rankIndex As Long
    Dim hcLevel As Long

    On Error GoTo LookupFailed
    If categoryId <= 0 Then GoTo LookupFailed

    rankIndex = HandlingUserRank(userId)
    hcLevel = HandlingUserHcLevel(userId)
    RoomCategoryForUser = CLng(Val(CStr(Proc_5_2_6D4690("SELECT id FROM rooms_categories WHERE id='" & CStr(categoryId) & "' AND level_minrequired <= '" & CStr(rankIndex) & "' AND hclevel_minrequired <= '" & CStr(hcLevel) & "' LIMIT 1", 0, 0))))
    Exit Function

LookupFailed:
    RoomCategoryForUser = 0
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

Private Function OfficialNavigatorQuery() As String
    Dim queryText As String
    Dim separator As String

    separator = " UNION ALL "

    queryText = "SELECT rooms_official.id_type,rooms_official.id_style,rooms_official.icon,"
    queryText = queryText & "rooms_official.caption,rooms_official.caption_2,rooms_official.caption_3,"
    queryText = queryText & "NULL,rooms.id,rooms.name,users.name,rooms.status_door,rooms.visitors_now,"
    queryText = queryText & "rooms.visitors_max,rooms.description,rooms_categories.has_trading,NULL,"
    queryText = queryText & "rooms.rate,rooms.id_category,rooms.icon,rooms.tag_1,rooms.tag_2,"
    queryText = queryText & "rooms.allow_otherspets,NULL,NULL,NULL,rooms_official.id_parent,"
    queryText = queryText & "rooms_official.id,rooms_official.requires_level_in FROM users,rooms,"
    queryText = queryText & "rooms_categories,rooms_official WHERE rooms_official.id_type='2' "
    queryText = queryText & "AND rooms_official.id_room IS NOT NULL AND rooms.id=rooms_official.id_room "
    queryText = queryText & "AND users.id=rooms.id_owner AND rooms_categories.id=rooms.id_category "
    queryText = queryText & "GROUP BY rooms_official.id"

    queryText = queryText & separator & "SELECT rooms_official.id_type,rooms_official.id_style,"
    queryText = queryText & "rooms_official.icon,rooms_official.caption,rooms_official.caption_2,"
    queryText = queryText & "rooms_official.caption_3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,"
    queryText = queryText & "NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,rooms_official.id_parent,"
    queryText = queryText & "rooms_official.id,rooms_official.requires_level_in FROM rooms_official "
    queryText = queryText & "WHERE rooms_official.id_type='1' GROUP BY rooms_official.id"

    queryText = queryText & separator & "SELECT rooms_official.id_type,rooms_official.id_style,"
    queryText = queryText & "rooms_official.icon,rooms_official.caption,rooms_official.caption_2,"
    queryText = queryText & "rooms_official.caption_3,NULL,rooms.id,rooms.name,NULL,rooms.status_door,"
    queryText = queryText & "rooms.visitors_now,rooms.visitors_max,rooms.description,"
    queryText = queryText & "rooms_categories.has_trading,NULL,rooms.rate,rooms.id_category,rooms.icon,"
    queryText = queryText & "rooms.tag_1,rooms.tag_2,rooms.allow_otherspets,models.name,"
    queryText = queryText & "models.required_files,models.visitors_max,rooms_official.id_parent,"
    queryText = queryText & "rooms_official.id,rooms_official.requires_level_in FROM models,rooms,"
    queryText = queryText & "rooms_categories,rooms_official WHERE rooms_official.id_type='3' "
    queryText = queryText & "AND rooms_official.id_room IS NOT NULL AND rooms.id=rooms_official.id_room "
    queryText = queryText & "AND models.id=rooms.id_model AND rooms_categories.id=rooms.id_category "
    queryText = queryText & "GROUP BY rooms_official.id"

    queryText = queryText & separator & "SELECT rooms_official.id_type,rooms_official.id_style,"
    queryText = queryText & "rooms_official.icon,rooms_official.caption,rooms_official.caption_2,"
    queryText = queryText & "rooms_official.caption_3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,"
    queryText = queryText & "NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,rooms_official.id_parent,"
    queryText = queryText & "rooms_official.id,rooms_official.requires_level_in FROM rooms_official "
    queryText = queryText & "WHERE rooms_official.id_type='4' GROUP BY rooms_official.id "
    queryText = queryText & "ORDER BY 27 ASC LIMIT 255"

    OfficialNavigatorQuery = queryText
End Function

Private Function OfficialNavigatorPayload(ByVal roomRows As String) As String
    On Error GoTo BuildFailed
    OfficialNavigatorPayload = CStr(Proc_6_122_752280(roomRows, True))
    Exit Function

BuildFailed:
    OfficialNavigatorPayload = CStr(Proc_3_0_6D2AF0(0, Empty, vbNullString))
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

Private Function RepresentedActivityPointSessionSeconds(ByVal socketIndex As Integer, ByVal userId As String) As Long
    Dim marker As String
    Dim startAt As Long
    Dim endAt As Long
    Dim tickValue As Long

    On Error GoTo TickFailed
    If socketIndex <= 0 Or Len(userId) = 0 Then GoTo TickFailed

    marker = "[" & CStr(socketIndex) & "]"
    startAt = InStr(1, representedActivityPointTicks, marker, vbBinaryCompare)
    If startAt > 0 Then
        endAt = InStr(startAt + Len(marker), representedActivityPointTicks, "[", vbBinaryCompare)
        If endAt = 0 Then endAt = Len(representedActivityPointTicks) + 1
        tickValue = CLng(Val(Mid$(representedActivityPointTicks, startAt + Len(marker), endAt - startAt - Len(marker))))
        representedActivityPointTicks = Left$(representedActivityPointTicks, startAt - 1) & Mid$(representedActivityPointTicks, endAt)
    Else
        tickValue = CLng(Val(CStr(Proc_5_2_6D4690("SELECT online_time FROM users WHERE id='" & Proc_10_11_80A9C0(userId, 0, 0) & "' LIMIT 1", 0, 0))))
    End If

    tickValue = tickValue + 60
    representedActivityPointTicks = representedActivityPointTicks & marker & CStr(tickValue)
    RepresentedActivityPointSessionSeconds = tickValue
    Exit Function

TickFailed:
    RepresentedActivityPointSessionSeconds = 0
End Function

Private Function RepresentedActivityPointAwardPayload(ByVal pointType As Long, ByVal pointsValue As Long) As String
    RepresentedActivityPointAwardPayload = CStr(Proc_3_0_6D2AF0(pointType, Empty, CStr(Proc_3_0_6D2AF0(pointsValue, Empty, "Fv")))) & "H"
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
