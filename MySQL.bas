Attribute VB_Name = "MySQL"
Option Explicit

Public DatabaseConnection As Object

' Reconstructed VB6 source shell generated from decompiled output.
' Source reference: /opt/git/AlphaSeries_cracked/DECOMPILED/MySQL.bas
' Decompiled procedure bodies are intentionally not copied until they are understood and made valid VB6.

' Original declaration: Private Sub Proc_5_0_6D3CD0
Public Function Proc_5_0_6D3CD0(ParamArray args() As Variant) As Variant
    On Error GoTo QueryFailed
    ExecuteSql BuildSqlFromArgs(args)
    Proc_5_0_6D3CD0 = Empty
    Exit Function

QueryFailed:
    Proc_5_0_6D3CD0 = Empty
End Function

' Original declaration: Private Sub Proc_5_1_6D4110
Public Function Proc_5_1_6D4110(ParamArray args() As Variant) As Variant
    On Error Resume Next
    ExecuteSql BuildSqlFromArgs(args)
    Proc_5_1_6D4110 = Empty
End Function

' Original declaration: Private Sub Proc_5_2_6D4690
Public Function Proc_5_2_6D4690(ParamArray args() As Variant) As Variant
    On Error GoTo ReadFailed
    Proc_5_2_6D4690 = ReadSqlRows(BuildSqlFromArgs(args))
    Exit Function

ReadFailed:
    Proc_5_2_6D4690 = vbNullString
End Function

' Original declaration: Private Sub Proc_5_3_6D4CF0
Public Function Proc_5_3_6D4CF0(ParamArray args() As Variant) As Variant
    On Error Resume Next
    Proc_5_3_6D4CF0 = ReadSqlRows(BuildSqlFromArgs(args))
End Function

' Original declaration: Private Sub Proc_5_4_6D55E0
Public Function Proc_5_4_6D55E0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_5_4_6D55E0 = Empty
End Function

' Original declaration: Private Sub Proc_5_5_6D64D0
Public Function Proc_5_5_6D64D0(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim requestPayload As String
    Dim userId As String
    Dim roomId As Long
    Dim roomRow As String
    Dim roomFields() As String
    Dim chatRows As String
    Dim payload As String

    On Error GoTo ChatLogFailed

    socketIndex = MySqlSocketIndex(args)
    packetPayload = MySqlPacketPayload(args)
    requestPayload = packetPayload
    If Left$(requestPayload, 2) = "GH" Then requestPayload = Mid$(requestPayload, 3)

    userId = MySqlUserIdFromSocket(socketIndex)
    If Len(userId) = 0 Or userId = "0" Then GoTo ChatLogFailed
    If Not MySqlUserHasPermission(userId, "fuse_mod") Then GoTo ChatLogFailed
    If Not MySqlUserHasPermission(userId, "fuse_chatlog") Then GoTo ChatLogFailed

    roomId = CLng(Val(CStr(Proc_10_6_809F10(requestPayload, 0, 0))))
    If roomId <= 0 Then GoTo ChatLogFailed

    roomRow = CStr(Proc_5_2_6D4690("SELECT rooms.id,rooms.name,models.type FROM rooms,models WHERE rooms.id='" & _
        CStr(roomId) & "' AND models.id=rooms.id_model LIMIT 1", 0, 0))
    If Len(roomRow) = 0 Then GoTo ChatLogFailed

    roomFields = Split(roomRow, Chr$(9))
    chatRows = CStr(Proc_5_2_6D4690("SELECT DATE_FORMAT(FROM_UNIXTIME(logs_chat.timestamp), '" & Chr$(37) & _
        "H'),DATE_FORMAT(FROM_UNIXTIME(logs_chat.timestamp), '" & Chr$(37) & _
        "i'),users.id,users.name,logs_chat.description FROM logs_chat,rooms,users WHERE logs_chat.id_room='" & _
        CStr(roomId) & "' AND logs_chat.timestamp > UNIX_TIMESTAMP()-600 AND users.id=logs_chat.id_user " & _
        "GROUP BY logs_chat.id ORDER BY logs_chat.id DESC LIMIT 100", 0, 0))

    payload = "HW" & MySqlRoomChatLogHeader(roomFields) & MySqlRoomChatLogRows(chatRows)
    Proc_6_244_801E80 socketIndex, payload, 0

ChatLogFailed:
    Proc_5_5_6D64D0 = Empty
End Function

' Original declaration: Private Sub Proc_5_6_6D7090
Public Function Proc_5_6_6D7090(ParamArray args() As Variant) As Variant
    Dim socketIndex As Integer
    Dim packetPayload As String
    Dim requestPayload As String
    Dim userId As String
    Dim roomId As Long
    Dim roomRow As String
    Dim eventRow As String
    Dim roomFields() As String
    Dim eventFields() As String
    Dim payload As String

    On Error GoTo RoomInfoFailed

    socketIndex = MySqlSocketIndex(args)
    packetPayload = MySqlPacketPayload(args)
    requestPayload = packetPayload
    If Left$(requestPayload, 2) = "GK" Then requestPayload = Mid$(requestPayload, 3)

    userId = MySqlUserIdFromSocket(socketIndex)
    If Len(userId) = 0 Or userId = "0" Then GoTo RoomInfoFailed
    If Not MySqlUserHasPermission(userId, "fuse_mod") Then GoTo RoomInfoFailed

    roomId = CLng(Val(CStr(Proc_10_6_809F10(requestPayload, 0, 0))))
    If roomId <= 0 Then GoTo RoomInfoFailed

    roomRow = CStr(Proc_5_2_6D4690("SELECT rooms.id,rooms.visitors_now,users.id,users.name,rooms.name,rooms.description,rooms.tag_1,rooms.tag_2 FROM rooms,users WHERE rooms.id='" & _
        CStr(roomId) & "' AND users.id=rooms.id_owner LIMIT 1", 0, 0))
    If Len(roomRow) = 0 Then GoTo RoomInfoFailed

    roomFields = Split(roomRow, Chr$(9))
    eventRow = CStr(Proc_5_2_6D4690("SELECT name,description,tag_1,tag_2 FROM rooms_events WHERE id_room='" & CStr(roomId) & "' LIMIT 1", 0, 0))
    If Len(eventRow) > 0 Then eventFields = Split(eventRow, Chr$(9))

    payload = "HZ" & MySqlRoomInfoPayload(roomFields, eventFields)
    Proc_6_244_801E80 socketIndex, payload, 0

RoomInfoFailed:
    Proc_5_6_6D7090 = Empty
End Function

Public Function ConfigureDatabaseConnection(ByVal connectionString As String) As Boolean
    On Error GoTo ConfigureFailed

    Set DatabaseConnection = CreateObject("ADODB.Connection")
    DatabaseConnection.ConnectionString = connectionString
    DatabaseConnection.Open
    ConfigureDatabaseConnection = True
    Exit Function

ConfigureFailed:
    Set DatabaseConnection = Nothing
    ConfigureDatabaseConnection = False
End Function

Private Sub ExecuteSql(ByVal sqlText As String)
    If Len(sqlText) = 0 Then Exit Sub
    If DatabaseConnection Is Nothing Then Err.Raise 91
    DatabaseConnection.Execute sqlText
End Sub

Private Function ReadSqlRows(ByVal sqlText As String) As String
    Dim recordset As Object
    Dim rowText As String
    Dim fieldIndex As Long

    If Len(sqlText) = 0 Then Exit Function
    If DatabaseConnection Is Nothing Then Err.Raise 91

    Set recordset = CreateObject("ADODB.Recordset")
    recordset.Open sqlText, DatabaseConnection

    Do Until recordset.EOF
        If Len(rowText) > 0 Then rowText = rowText & Chr$(13)
        For fieldIndex = 0 To recordset.Fields.Count - 1
            If fieldIndex > 0 Then rowText = rowText & Chr$(9)
            If Not IsNull(recordset.Fields(fieldIndex).Value) Then
                rowText = rowText & CStr(recordset.Fields(fieldIndex).Value)
            End If
        Next fieldIndex
        recordset.MoveNext
    Loop

    recordset.Close
    ReadSqlRows = Replace(rowText, "\n", Chr$(10))
End Function

Private Function BuildSqlFromArgs(ByRef args() As Variant) As String
    Dim index As Long
    Dim part As String

    On Error GoTo BuildFailed
    For index = LBound(args) To UBound(args)
        If Not IsEmpty(args(index)) Then
            If Not IsNull(args(index)) Then
                part = CStr(args(index))
                If Not IsIgnorableSqlArg(part) Then
                    BuildSqlFromArgs = BuildSqlFromArgs & part
                End If
            End If
        End If
    Next index
    BuildSqlFromArgs = Replace(BuildSqlFromArgs, "\'", "/'")
    Exit Function

BuildFailed:
    BuildSqlFromArgs = vbNullString
End Function

Private Function MySqlSocketIndex(ByRef args() As Variant) As Integer
    On Error GoTo LookupFailed
    If UBound(args) >= 0 Then MySqlSocketIndex = CInt(Val(CStr(args(0))))
    Exit Function

LookupFailed:
    MySqlSocketIndex = 0
End Function

Private Function MySqlPacketPayload(ByRef args() As Variant) As String
    On Error GoTo LookupFailed
    If UBound(args) >= 2 Then MySqlPacketPayload = CStr(args(2))
    If Len(MySqlPacketPayload) = 0 And UBound(args) >= 1 Then MySqlPacketPayload = CStr(args(1))
    Exit Function

LookupFailed:
    MySqlPacketPayload = vbNullString
End Function

Private Function MySqlUserIdFromSocket(ByVal socketIndex As Integer) As String
    On Error GoTo LookupFailed
    MySqlUserIdFromSocket = CStr(Val(CStr(Proc_5_2_6D4690("SELECT id FROM users WHERE id_socket='" & _
        CStr(socketIndex) & "' LIMIT 1", 0, 0))))
    Exit Function

LookupFailed:
    MySqlUserIdFromSocket = vbNullString
End Function

Private Function MySqlUserHasPermission(ByVal userId As String, ByVal permissionName As String) As Boolean
    Dim rankIndex As Long
    Dim hcLevel As Long

    On Error GoTo CheckFailed
    rankIndex = CLng(Val(CStr(Proc_5_2_6D4690("SELECT level FROM users WHERE id='" & _
        Proc_10_11_80A9C0(userId, 0, 0) & "' LIMIT 1", 0, 0))))
    hcLevel = CLng(Val(CStr(Proc_5_2_6D4690("SELECT level_hc FROM users WHERE id='" & _
        Proc_10_11_80A9C0(userId, 0, 0) & "' LIMIT 1", 0, 0))))
    MySqlUserHasPermission = CBool(Proc_10_1_809790(rankIndex, vbNullString, permissionName, hcLevel))
    Exit Function

CheckFailed:
    MySqlUserHasPermission = False
End Function

Private Function MySqlRoomChatLogHeader(ByRef roomFields() As String) As String
    Dim roomId As Long
    Dim roomName As String
    Dim modelType As Long

    On Error GoTo BuildFailed
    roomId = CLng(Val(CStr(roomFields(0))))
    roomName = CStr(roomFields(1))
    modelType = CLng(Val(CStr(roomFields(2))))

    MySqlRoomChatLogHeader = CStr(Proc_3_0_6D2AF0(roomId, Empty, vbNullString)) & _
        CStr(Proc_3_0_6D2AF0(modelType, Empty, vbNullString)) & roomName & Chr$(2)
    Exit Function

BuildFailed:
    MySqlRoomChatLogHeader = vbNullString
End Function

Private Function MySqlRoomChatLogRows(ByVal chatRows As String) As String
    Dim rows() As String
    Dim fields() As String
    Dim rowIndex As Long
    Dim payload As String

    On Error GoTo BuildFailed
    If Len(chatRows) = 0 Then Exit Function

    rows = Split(chatRows, Chr$(13))
    For rowIndex = LBound(rows) To UBound(rows)
        If Len(rows(rowIndex)) > 0 Then
            fields = Split(rows(rowIndex), Chr$(9))
            If UBound(fields) >= 4 Then
                payload = payload & CStr(Proc_3_0_6D2AF0(CLng(Val(CStr(fields(0)))), Empty, vbNullString))
                payload = payload & CStr(Proc_3_0_6D2AF0(CLng(Val(CStr(fields(1)))), Empty, vbNullString))
                payload = payload & CStr(Proc_3_0_6D2AF0(CLng(Val(CStr(fields(2)))), Empty, vbNullString))
                payload = payload & CStr(fields(3)) & Chr$(2)
                payload = payload & CStr(fields(4)) & Chr$(2)
            End If
        End If
    Next rowIndex

    MySqlRoomChatLogRows = payload
    Exit Function

BuildFailed:
    MySqlRoomChatLogRows = payload
End Function

Private Function MySqlRoomInfoPayload(ByRef roomFields() As String, ByRef eventFields() As String) As String
    Dim payload As String
    Dim fieldIndex As Long
    Dim roomId As Long
    Dim visitorCount As Long
    Dim ownerId As Long
    Dim hasEvent As Long

    On Error GoTo BuildFailed
    If UBound(roomFields) < 7 Then GoTo BuildFailed

    roomId = CLng(Val(CStr(roomFields(0))))
    visitorCount = CLng(Val(CStr(roomFields(1))))
    ownerId = CLng(Val(CStr(roomFields(2))))

    payload = CStr(Proc_3_0_6D2AF0(roomId, Empty, vbNullString))
    payload = payload & CStr(Proc_3_0_6D2AF0(visitorCount, Empty, vbNullString))
    payload = payload & CStr(Proc_3_0_6D2AF0(ownerId, Empty, vbNullString))
    For fieldIndex = 3 To 7
        payload = payload & CStr(roomFields(fieldIndex)) & Chr$(2)
    Next fieldIndex

    On Error Resume Next
    hasEvent = IIf(UBound(eventFields) >= 3, 1, 0)
    If Err.Number <> 0 Then
        Err.Clear
        hasEvent = 0
    End If
    On Error GoTo BuildFailed

    payload = payload & CStr(Proc_3_0_6D2AF0(hasEvent, Empty, vbNullString))
    If hasEvent <> 0 Then
        For fieldIndex = 0 To 3
            payload = payload & CStr(eventFields(fieldIndex)) & Chr$(2)
        Next fieldIndex
    End If

    MySqlRoomInfoPayload = payload
    Exit Function

BuildFailed:
    MySqlRoomInfoPayload = payload
End Function

Private Function IsIgnorableSqlArg(ByVal value As String) As Boolean
    IsIgnorableSqlArg = (Len(value) = 0 Or value = "0" Or value = "-1")
End Function
