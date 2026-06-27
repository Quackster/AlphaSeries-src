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
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_6_122_752280 = Empty
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
    ' TODO: Reconstruct behavior from decompiled reference.
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
    ' TODO: Reconstruct behavior from decompiled reference.
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

    roomUserIndex = CLng(Val(CStr(Proc_5_2_6D4690("SELECT id FROM logs_visitedrooms WHERE id_user='" & Proc_10_11_80A9C0(userId, 0, 0) & "' AND id_socket='" & CStr(socketIndex) & "' AND timestamp_left IS NULL ORDER BY timestamp_enter DESC LIMIT 1", 0, 0))))
    If roomUserIndex <= 0 Then roomUserIndex = CLng(socketIndex)

    RepresentedRoomUserIndex = roomUserIndex
    Exit Function

LookupFailed:
    RepresentedRoomUserIndex = CLng(socketIndex)
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
    Dim rows() As String
    Dim fields() As String
    Dim rowIndex As Long
    Dim fieldIndex As Long
    Dim itemCount As Long
    Dim rowPayload As String
    Dim payload As String

    On Error GoTo BuildFailed

    If Len(roomRows) = 0 Then GoTo BuildFailed
    rows = Split(roomRows, Chr$(13))
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

BuildFailed:
    OfficialNavigatorPayload = CStr(Proc_3_0_6D2AF0(itemCount, Empty, vbNullString)) & payload
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
