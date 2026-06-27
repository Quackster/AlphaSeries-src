VERSION 5.00
Object = "{248DD890-BB45-11CF-9ABC-0080C7E7B78D}#1.0#0"; "C:\Windows\SysWow64\MSWINSCK.OCX"
Object = "{3B7C8863-D78F-101B-B9B5-04021C009402}#1.2#0"; "C:\Windows\SysWow64\RICHTX32.OCX"
Begin VB.Form Main
  Caption = "Alpha Series [INITIALISIERE] - [%%]"
  BackColor = &H0&
  ScaleMode = 1
  AutoRedraw = False
  FontTransparent = True
  Icon = "Main.frx":0000
  LinkTopic = "Form1"
  ClientLeft = 4470
  ClientTop = 1695
  ClientWidth = 10845
  ClientHeight = 9705
  StartUpPosition = 2 'CenterScreen
  Begin VB.Frame Frame7
    Caption = "Frame1"
    BackColor = &H808080&
    Left = 0
    Top = 0
    Width = 10815
    Height = 735
    Visible = 0   'False
    TabIndex = 7
    BorderStyle = 0 'None
    Begin VB.Label Label7
      Caption = "Main.frx":08CA
      BackColor = &H5F6736&
      ForeColor = &HFFFFFF&
      Left = 0
      Top = 0
      Width = 10815
      Height = 735
      TabIndex = 9
      Alignment = 2 'Center
      BackStyle = 0 'Transparent
      BeginProperty Font
        Name = "Trebuchet MS"
        Size = 12
        Charset = 0
        Weight = 700
        Underline = 0 'False
        Italic = 0 'False
        Strikethrough = 0 'False
      EndProperty
    End
  End
  Begin VB.Frame frmLade
    Caption = "Frame1"
    BackColor = &H404000&
    Left = 3000
    Top = 3840
    Width = 5055
    Height = 1335
    TabIndex = 4
    BorderStyle = 0 'None
    Begin VB.Label Label1
      Caption = "Bitte warte..."
      BackColor = &H5F6736&
      ForeColor = &HFFFFFF&
      Left = 0
      Top = 480
      Width = 5055
      Height = 375
      TabIndex = 5
      Alignment = 2 'Center
      BackStyle = 0 'Transparent
      BeginProperty Font
        Name = "Trebuchet MS"
        Size = 12
        Charset = 0
        Weight = 700
        Underline = 0 'False
        Italic = 0 'False
        Strikethrough = 0 'False
      EndProperty
    End
  End
  Begin VB.Frame fADDONS
    Caption = "frame :: ADDONS"
    BackColor = &H0&
    Left = 240
    Top = 5640
    Width = 6975
    Height = 1095
    Visible = 0   'False
    TabIndex = 2
    BorderStyle = 0 'None
    Begin VB.Timer DataProcess
      Index = 0
      Enabled = 0   'False
      Interval = 50
      Left = 6240
      Top = 120
    End
    Begin VB.Timer tmrWalking
      Index = 0
      Enabled = 0   'False
      Interval = 500
      Left = 3480
      Top = 120
    End
    Begin VB.Timer tmrRollers
      Index = 0
      Enabled = 0   'False
      Interval = 2500
      Left = 2040
      Top = 120
    End
    Begin VB.Timer tmrSigner
      Interval = 250
      Left = 1080
      Top = 120
    End
    Begin VB.Timer tmrBots
      Interval = 9000
      Left = 4680
      Top = 120
    End
    Begin VB.Timer tmrPing
      Interval = 60000
      Left = 120
      Top = 120
    End
    Begin MSWinsockLib.Winsock gameServer
      OleObjectBlob = "Main.frx":0978
      Left = 120
      Top = 600
    End
    Begin MSWinsockLib.Winsock musServer
      Index = 0
      OleObjectBlob = "Main.frx":09B8
      Left = 600
      Top = 600
    End
    Begin VB.Line Line6
      BorderColor = &HFF00&
      X1 = 4440
      Y1 = 240
      X2 = 4560
      Y2 = 360
    End
    Begin VB.Line Line5
      BorderColor = &HFF00&
      X1 = 4440
      Y1 = 480
      X2 = 4560
      Y2 = 360
    End
    Begin VB.Line Line4
      BorderColor = &HFF00&
      X1 = 4080
      Y1 = 360
      X2 = 4560
      Y2 = 360
    End
    Begin VB.Line Line2
      BorderColor = &HFF00&
      X1 = 3960
      Y1 = 120
      X2 = 3960
      Y2 = 480
    End
    Begin VB.Line Line3
      BorderColor = &HFF00&
      X1 = 3360
      Y1 = 120
      X2 = 3360
      Y2 = 480
    End
    Begin VB.Line Line1
      BorderColor = &HFF00&
      X1 = 2640
      Y1 = 360
      X2 = 3120
      Y2 = 360
    End
    Begin VB.Label productKey
      Caption = "Server by Privilege"
      BackColor = &HC0C0&
      Left = 1080
      Top = 690
      Width = 1815
      Height = 255
      TabIndex = 3
      Alignment = 2 'Center
      BeginProperty Font
        Name = "MS Sans Serif"
        Size = 8.25
        Charset = 0
        Weight = 700
        Underline = 0 'False
        Italic = 0 'False
        Strikethrough = 0 'False
      EndProperty
    End
  End
  Begin RichTextLib.RichTextBox txtLog
    Left = 0
    Top = 0
    Width = 7335
    Height = 5205
    TabIndex = 0
    OleObjectBlob = "Main.frx":09F8
  End
  Begin VB.Label Label6
    Caption = "User Voice"
    BackColor = &H5F6736&
    ForeColor = &HFFFFFF&
    Left = 0
    Top = 0
    Width = 5055
    Height = 375
    TabIndex = 8
    Alignment = 2 'Center
    BackStyle = 0 'Transparent
    BeginProperty Font
      Name = "Trebuchet MS"
      Size = 12
      Charset = 0
      Weight = 700
      Underline = 0 'False
      Italic = 0 'False
      Strikethrough = 0 'False
    EndProperty
  End
  Begin VB.Label Label4
    Caption = "User Voice"
    BackColor = &H5F6736&
    ForeColor = &HFFFFFF&
    Left = 0
    Top = 0
    Width = 5055
    Height = 375
    TabIndex = 6
    Alignment = 2 'Center
    BackStyle = 0 'Transparent
    BeginProperty Font
      Name = "Trebuchet MS"
      Size = 12
      Charset = 0
      Weight = 700
      Underline = 0 'False
      Italic = 0 'False
      Strikethrough = 0 'False
    EndProperty
  End
  Begin VB.Label Label3
    Caption = "Source is only avaible for the author. Please do not share this Source!"
    BackColor = &H80000009&
    ForeColor = &H80FF&
    Left = 120
    Top = 6840
    Width = 7215
    Height = 975
    Visible = 0   'False
    TabIndex = 1
    Alignment = 2 'Center
    BackStyle = 0 'Transparent
    BeginProperty Font
      Name = "Verdana"
      Size = 15.75
      Charset = 0
      Weight = 700
      Underline = 0 'False
      Italic = 0 'False
      Strikethrough = 0 'False
    EndProperty
  End
End

Attribute VB_Name = "Main"
Option Explicit

' Reconstructed code shell generated from decompiled output.
' Source reference: /opt/git/AlphaSeries_cracked/DECOMPILED/Main.frm
' Event bodies are inert until each handler is manually reconstructed.

' Original declaration: Private Sub DataProcess_Timer(Index As Integer) '68B2D0
Private Sub DataProcess_Timer(Index As Integer)
    Dim packetData As String

    On Error GoTo ProcessDone

    DataProcess(Index).Enabled = False
    If Proc_11_2_821390(Index, 1, Me) = 1 Then
        packetData = PopGameServerPacketData(Index)
        If Len(packetData) > 0 Then
            Proc_0_25_68FBC0 Index, packetData
        End If
        DataProcess(Index).Enabled = True
    End If

ProcessDone:
    On Error Resume Next
    If Proc_11_2_821390(Index, 1, Me) = 1 Then
        DataProcess(Index).Enabled = True
    End If
End Sub

' Original declaration contained invalid VB6 identifier text: Private Sub gameServer_C_q]<lkamWk&_uo_lLfj`j=nEge]( '68F5C0
Private Sub gameServer_C_q()
    Dim incomingData As String
    Dim packets As Variant
    Dim packet As Variant
    Dim fields As Variant
    Dim commandName As String
    Dim socketIndex As Long

    On Error GoTo ReadFailed

    gameServer.GetData incomingData, vbString
    packets = Split(incomingData, Chr$(1))

    For Each packet In packets
        If Len(CStr(packet)) > 0 Then
            fields = Split(CStr(packet), Chr$(2))
            commandName = UCase$(CStr(fields(0)))

            Select Case commandName
                Case "SHUTDOWN"
                    If UBound(fields) >= 1 Then
                        socketIndex = CLng(Val(CStr(fields(1))))
                        Proc_6_243_7FFEB0 socketIndex, Me, 0
                    End If

                Case "LISTEN"
                    If UBound(fields) >= 1 Then
                        socketIndex = CLng(Val(CStr(fields(1))))
                        Proc_11_3_821440 socketIndex, 0, 0
                    End If

                Case "DATA"
                    If UBound(fields) >= 2 Then
                        socketIndex = CLng(Val(CStr(fields(1))))
                        AppendGameServerPacketData socketIndex, fields
                    End If

                Case Else
                    If UBound(fields) >= 0 Then
                        socketIndex = CLng(Val(CStr(fields(0))))
                        Proc_6_243_7FFEB0 socketIndex, Me, 0
                    End If
            End Select
        End If
    Next packet

ReadFailed:
End Sub

' Original declaration: Private Sub gameServer_UnknownEvent_C '68F4C0
Private Sub gameServer_UnknownEvent_C()
    On Error Resume Next
    gameServer.Close
    gameServer.Accept 16387
End Sub

' Original declaration: Private Sub gameServer_UnknownEvent_D '68EB20
Private Sub gameServer_UnknownEvent_D()
    On Error Resume Next
    gameServer.Close
    gameServer.Listen
End Sub

' Original declaration: Private Sub tmrSigner_Timer() '695150
Private Sub tmrSigner_Timer()
    ' TODO: Reconstruct behavior from decompiled reference.
End Sub

' Original declaration: Private Sub tmrBots_Timer() '6923C0
Private Sub tmrBots_Timer()
    ' TODO: Reconstruct behavior from decompiled reference.
End Sub

' Original declaration: Private Sub Form_Resize() '68E3F0
Private Sub Form_Resize()
    On Error Resume Next

    If Width < 11085 Then Width = 11085
    If Height < 10245 Then Height = 10245

    txtLog.Width = ScaleWidth
    txtLog.Height = ScaleHeight - 525
    txtLog.SelStart = Len(txtLog.Text)

    Frame7.Width = ScaleWidth
    Label7.Width = Frame7.Width
End Sub

' Original declaration: Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer) '68D210
Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
    On Error Resume Next

    Hide
    gameServer.Close
    Proc_5_0_6D3CD0 "UPDATE users SET id_socket=null,lastonline_time=UNIX_TIMESTAMP() WHERE id_socket IS NOT NULL", 1, 0
    Proc_5_0_6D3CD0 "UPDATE rooms SET id_slot=null,visitors_now='0' WHERE id_slot IS NOT NULL OR visitors_now!='0'", 0, 0
    End
End Sub

' Original declaration: Private Sub Form_Initialize() '68B530
Private Sub Form_Initialize()
    Dim configText As String
    Dim configParts() As String
    Dim productKeyLines() As String

    global_0082904C = &HFFFFFF
    global_00829038 = "ALPHASERIES_FINAL (PREMIUM)"
    global_0082903C = &H17
    global_00829034 = False

    On Error Resume Next
    If CLng(Proc_3_3_6D3240("K", -1, Me)) <> 3 Then
        Mistake.Show vbModal, Me
        End
    End If

    Proc_11_1_821240 App.Path & "/CACHE/ROOMS", 0, 0
    Proc_11_1_821240 App.Path & "/CACHE/PATHFINDER", 0, 0
    Proc_11_1_821240 App.Path & "/CACHE/USERS", 0, 0

    Main.Caption = Replace(Main.Caption, "%%", global_00829038, 1, -1, vbBinaryCompare)
    global_008290AC = &HFFFFFF

    configText = CStr(Proc_6_239_7FC170(App.Path & "/config.ini", 0, 7))
    configParts = Split(configText, "=", -1, vbBinaryCompare)
    If UBound(configParts) >= 7 Then
        productKeyLines = Split(CStr(configParts(7)), vbCrLf, -1, vbBinaryCompare)
        If UBound(productKeyLines) >= 0 Then productKey.Caption = CStr(productKeyLines(0))
    End If

    runServer
End Sub

' Original declaration: Private Sub tmrRollers_Timer(Index As Integer) '6B5900
Private Sub tmrRollers_Timer(Index As Integer)
    ' TODO: Reconstruct behavior from decompiled reference.
End Sub

' Original declaration: Private Sub tmrPing_Timer() '694630
Private Sub tmrPing_Timer()
    Dim socketIndex As Long
    Dim socketMarker As String
    Dim activeCount As Long
    Static mostActiveCount As Long

    On Error GoTo PingDone

    tmrPing.Enabled = False
    Proc_5_0_6D3CD0 "UPDATE settings SET value=UNIX_TIMESTAMP() WHERE variable='com.server.socket.check.time'", 1, Me

    For socketIndex = 1 To global_0082919C
        socketMarker = "[" & CStr(socketIndex) & "]"
        If InStr(1, global_008291A0, socketMarker, vbBinaryCompare) > 0 Then
            If Proc_11_2_821390(socketIndex, 0, 0) = 1 Then
                activeCount = activeCount + 1
            Else
                Proc_6_243_7FFEB0 socketIndex, 0, 0
            End If
        End If
    Next socketIndex

    If activeCount > mostActiveCount Then
        Proc_5_0_6D3CD0 "UPDATE settings SET value='" & CStr(activeCount) & "' WHERE variable='com.server.socket.mostactive'", 0, 0
        mostActiveCount = activeCount
    End If

    Proc_6_103_74A510 0, 0, 0

PingDone:
    On Error Resume Next
    tmrPing.Enabled = True
End Sub

' Original declaration: Private Sub tmrWalking_Timer(Index As Integer) '693B20
Private Sub tmrWalking_Timer(Index As Integer)
    ' TODO: Reconstruct behavior from decompiled reference.
End Sub

' Original declaration: Public Function EasyGetIdentity(arg1) '68C620
Public Function EasyGetIdentity(Optional ByVal arg1 As Variant) As Variant
    EasyGetIdentity = ShiftIdentityText(CStr(arg1), -25)
End Function

' Original declaration: Public Function NewPremiumCheck(arg0, arg1) '68C820
Public Function NewPremiumCheck(Optional ByVal arg0 As Variant, Optional ByVal arg1 As Variant) As Variant
    Dim encodedText As String
    Dim seedValue As Long
    Dim index As Long
    Dim outputText As String

    On Error GoTo DecodeFailed
    encodedText = CStr(arg1)
    If Len(encodedText) = 0 Then
        NewPremiumCheck = vbNullString
        Exit Function
    End If

    seedValue = Asc(Mid$(encodedText, 1, 1))
    encodedText = Mid$(encodedText, 2)
    For index = 1 To Len(encodedText)
        outputText = outputText & Chr$(((Asc(Mid$(encodedText, index, 1)) - seedValue) + CLng(Val(CStr(arg0)))) And &HFF&)
    Next index

    NewPremiumCheck = outputText
    Exit Function

DecodeFailed:
    NewPremiumCheck = vbNullString
End Function

' Original declaration: Public Function CreateSuperEasyIdentity(arg1) '68CB10
Public Function CreateSuperEasyIdentity(Optional ByVal arg1 As Variant) As Variant
    CreateSuperEasyIdentity = ShiftIdentityText(CStr(arg1), 2)
End Function

' Original declaration: Public Function SuperEasyGetIdentity(arg1) '68CD20
Public Function SuperEasyGetIdentity(Optional ByVal arg1 As Variant) As Variant
    SuperEasyGetIdentity = ShiftIdentityText(CStr(arg1), -2)
End Function

' Original declaration: Public Function GetIdentity(arg1, arg2) '68CF20
Public Function GetIdentity(Optional ByVal arg1 As Variant, Optional ByVal arg2 As Variant) As Variant
    Dim encodedText As String
    Dim seedValue As Long
    Dim index As Long
    Dim outputText As String

    On Error GoTo DecodeFailed
    encodedText = CStr(arg1)
    If Len(encodedText) = 0 Then
        GetIdentity = vbNullString
        Exit Function
    End If

    seedValue = Asc(Mid$(encodedText, 1, 1)) - CLng(Val(CStr(arg2)))
    encodedText = Mid$(encodedText, 2)
    For index = 1 To Len(encodedText)
        outputText = outputText & Chr$(((Asc(Mid$(encodedText, index, 1)) - index) - seedValue) And &HFF&)
    Next index

    GetIdentity = outputText
    Exit Function

DecodeFailed:
    GetIdentity = vbNullString
End Function

' Original declaration: Public Sub runServer() '68EC00
Public Sub runServer()
    On Error GoTo RunFailed

    If InStr(1, Main.Caption, "[!]", vbBinaryCompare) = 0 Then
        Main.Height = 5730
        If CBool(Proc_8_7_8051C0(Me, 0, 0)) Then
            Proc_1_3_6BEBA0 0
        Else
            Main.Hide
            MsgBox "Unbekanntes Problem", vbCritical
        End If
        End
    End If
    Exit Sub

RunFailed:
    End
End Sub

' Original declaration: Public Function getProcessor() '68EE00
Public Function getProcessor() As Variant
    On Error Resume Next
    getProcessor = Environ$("USERNAME")
End Function

Private Function ShiftIdentityText(ByVal sourceText As String, ByVal shiftAmount As Long) As String
    Dim index As Long
    Dim charCode As Long
    Dim outputText As String

    On Error GoTo ShiftFailed
    For index = 1 To Len(sourceText)
        charCode = Asc(Mid$(sourceText, index, 1)) + shiftAmount
        outputText = outputText & Chr$(charCode And &HFF&)
    Next index

    ShiftIdentityText = outputText
    Exit Function

ShiftFailed:
    ShiftIdentityText = vbNullString
End Function

Private Sub AppendGameServerPacketData(ByVal socketIndex As Long, ByVal fields As Variant)
    Dim fieldIndex As Long
    Dim payload As String

    On Error GoTo AppendFailed

    For fieldIndex = 2 To UBound(fields)
        If Len(payload) > 0 Then payload = payload & Chr$(2)
        payload = payload & CStr(fields(fieldIndex))
    Next fieldIndex

    If Len(payload) > 0 Then
        global_00829350 = global_00829350 & "[" & CStr(socketIndex) & ":" & payload & "]"
    End If

AppendFailed:
End Sub

Private Function PopGameServerPacketData(ByVal socketIndex As Long) As String
    Dim marker As String
    Dim recordStart As Long
    Dim payloadStart As Long
    Dim recordEnd As Long

    On Error GoTo PopFailed

    marker = "[" & CStr(socketIndex) & ":"
    recordStart = InStr(1, global_00829350, marker, vbBinaryCompare)
    If recordStart = 0 Then Exit Function

    payloadStart = recordStart + Len(marker)
    recordEnd = InStr(payloadStart, global_00829350, "]", vbBinaryCompare)
    If recordEnd = 0 Then Exit Function

    PopGameServerPacketData = Mid$(global_00829350, payloadStart, recordEnd - payloadStart)
    global_00829350 = Left$(global_00829350, recordStart - 1) & Mid$(global_00829350, recordEnd + 1)

    Exit Function

PopFailed:
    PopGameServerPacketData = vbNullString
End Function

' Original declaration: Private  Proc_0_22_68C1A0(arg_C) '68C1A0
Private Function Proc_0_22_68C1A0(Optional ByVal arg_C As Variant) As Variant
    Dim sourceText As String
    Dim seedValue As Long
    Dim index As Long
    Dim outputText As String

    On Error GoTo EncodeFailed
    sourceText = CStr(arg_C)
    seedValue = CLng(Proc_10_3_809B90(&H41, &H5A))
    outputText = Chr$(seedValue)

    For index = 1 To Len(sourceText)
        outputText = outputText & Chr$((Asc(Mid$(sourceText, index, 1)) + index + seedValue) And &HFF&)
    Next index

    Proc_0_22_68C1A0 = outputText
    Exit Function

EncodeFailed:
    Proc_0_22_68C1A0 = vbNullString
End Function

' Original declaration: Private  Proc_0_23_68C430(arg_C) '68C430
Private Function Proc_0_23_68C430(Optional ByVal arg_C As Variant) As Variant
    Proc_0_23_68C430 = ShiftIdentityText(CStr(arg_C), 7)
End Function

' Original declaration: Private Sub Proc_0_24_68EEF0
Private Sub Proc_0_24_68EEF0()
    ' Recovered as an empty procedure in the decompiled reference.
End Sub

' Original declaration: Private  Proc_0_25_68FBC0(arg_C, arg_10) '68FBC0
Private Sub Proc_0_25_68FBC0(Optional ByVal arg_C As Variant, Optional ByVal arg_10 As Variant)
    Dim socketIndex As Long
    Dim packetData As String

    On Error GoTo DispatchFailed

    socketIndex = CLng(Val(CStr(arg_C)))
    packetData = CStr(arg_10)

    If Proc_11_2_821390(socketIndex, 1, 0) <> 1 Then Exit Sub

    If IsGameSessionReady(socketIndex) Then
        Proc_7_2_803D60 socketIndex, packetData, 0
    Else
        Proc_6_241_7FC380 socketIndex, packetData, 0
    End If
    Exit Sub

DispatchFailed:
    If global_00829034 Then
        Proc_2_0_6D1510 "[" & CStr(socketIndex) & "] " & Err.Description & " -> " & packetData, "ERROR " & CStr(Err.Number), CStr(255)
        Proc_8_9_806810 App.Path & "\ERR.log", CStr(Now & " - ERROR" & CStr(Err.Number) & "] " & packetData & " (" & Err.Description & ")" & vbCrLf & "0" & vbCrLf & vbCrLf & vbCrLf)
        Proc_10_8_80A580 socketIndex, &H60, 0
    End If
End Sub

Private Function IsGameSessionReady(ByVal socketIndex As Long) As Boolean
    On Error GoTo NotReady
    IsGameSessionReady = (InStr(1, global_00829354, "[" & CStr(socketIndex) & "]", vbBinaryCompare) > 0)
    Exit Function

NotReady:
    IsGameSessionReady = False
End Function

Private Function MainRepresentedSocketRoomSlot(ByVal socketIndex As Long) As Long
    Dim fields() As String

    On Error GoTo LookupFailed

    MainRepresentedSocketRoomSlot = CLng(Val(CStr(Proc_9_10_808F30(CStr(socketIndex), 1, 0))))
    If MainRepresentedSocketRoomSlot > 0 Then Exit Function

    fields = Split(MainRepresentedRecordByBracket(CStr(global_0082934C), socketIndex), Chr$(2))
    If UBound(fields) >= 1 Then MainRepresentedSocketRoomSlot = CLng(Val(CStr(fields(1))))
    Exit Function

LookupFailed:
    MainRepresentedSocketRoomSlot = 0
End Function

Private Function MainRepresentedBotRoomSlot(ByVal entityIndex As Long) As Long
    Dim fields() As String

    On Error GoTo LookupFailed

    fields = Split(MainRepresentedRecordByKey(CStr(global_00829358), entityIndex), Chr$(9))
    If UBound(fields) >= 0 Then MainRepresentedBotRoomSlot = CLng(Val(CStr(fields(0))))
    Exit Function

LookupFailed:
    MainRepresentedBotRoomSlot = 0
End Function

Private Sub MainRepresentedRoomOccupantAdd(ByVal roomSlot As Long, ByVal entityIndex As Long, ByVal occupantType As Long)
    Dim roomRecord As String
    Dim fields() As String
    Dim markerText As String
    Dim fieldIndex As Long
    Dim countIndex As Long

    If roomSlot <= 0 Or entityIndex <= 0 Then Exit Sub

    markerText = Chr$(1) & CStr(entityIndex) & Chr$(2)
    fieldIndex = IIf(occupantType = 2, 2, 1)
    countIndex = 3

    roomRecord = MainRepresentedRoomRecord(roomSlot)
    If Len(roomRecord) = 0 Then roomRecord = CStr(roomSlot) & Chr$(9) & vbNullString & Chr$(9) & vbNullString & Chr$(9) & "0"
    fields = Split(roomRecord, Chr$(9))
    MainEnsureFieldCount fields, countIndex

    If InStr(1, CStr(fields(fieldIndex)), markerText, vbBinaryCompare) = 0 Then
        fields(fieldIndex) = CStr(fields(fieldIndex)) & markerText
        fields(countIndex) = CStr(CLng(Val(CStr(fields(countIndex)))) + 1)
    End If

    MainRepresentedRoomRecordSet roomSlot, Join(fields, Chr$(9))
End Sub

Private Function MainRepresentedRecordByBracket(ByVal cacheText As String, ByVal recordId As Long) As String
    Dim markerText As String
    Dim startAt As Long
    Dim endAt As Long

    If recordId <= 0 Or Len(cacheText) = 0 Then Exit Function

    markerText = "[" & CStr(recordId) & "]"
    startAt = InStr(1, cacheText, markerText, vbBinaryCompare)
    If startAt = 0 Then Exit Function

    startAt = startAt + Len(markerText)
    endAt = InStr(startAt, cacheText, "[", vbBinaryCompare)
    If endAt = 0 Then endAt = Len(cacheText) + 1

    MainRepresentedRecordByBracket = Mid$(cacheText, startAt, endAt - startAt)
End Function

Private Function MainRepresentedRecordByKey(ByVal cacheText As String, ByVal recordId As Long) As String
    Dim markerText As String
    Dim startAt As Long
    Dim endAt As Long

    If recordId <= 0 Or Len(cacheText) = 0 Then Exit Function

    markerText = Chr$(1) & CStr(recordId) & Chr$(9)
    startAt = InStr(1, cacheText, markerText, vbBinaryCompare)
    If startAt = 0 Then
        markerText = Chr$(1) & CStr(recordId) & Chr$(2)
        startAt = InStr(1, cacheText, markerText, vbBinaryCompare)
        If startAt = 0 Then Exit Function
    End If

    startAt = startAt + 1
    endAt = InStr(startAt, cacheText, Chr$(2), vbBinaryCompare)
    If endAt = 0 Then endAt = Len(cacheText) + 1

    MainRepresentedRecordByKey = Mid$(cacheText, startAt, endAt - startAt)
End Function

Private Function MainRepresentedRoomRecord(ByVal roomSlot As Long) As String
    MainRepresentedRoomRecord = MainRepresentedRecordByKey(CStr(global_00829310), roomSlot)
End Function

Private Sub MainRepresentedRoomRecordSet(ByVal roomSlot As Long, ByVal roomRecord As String)
    Dim cacheText As String

    If roomSlot <= 0 Then Exit Sub

    cacheText = MainRepresentedCacheRemove(CStr(global_00829310), Chr$(1) & CStr(roomSlot) & Chr$(9))
    cacheText = MainRepresentedCacheRemove(cacheText, Chr$(1) & CStr(roomSlot) & Chr$(2))
    global_00829310 = cacheText & Chr$(1) & roomRecord & Chr$(2)
End Sub

Private Function MainRepresentedCacheRemove(ByVal cacheText As String, ByVal markerText As String) As String
    Dim startAt As Long
    Dim endAt As Long

    MainRepresentedCacheRemove = cacheText
    If Len(cacheText) = 0 Or Len(markerText) = 0 Then Exit Function

    startAt = InStr(1, cacheText, markerText, vbBinaryCompare)
    Do While startAt > 0
        endAt = InStr(startAt + Len(markerText), cacheText, Chr$(2), vbBinaryCompare)
        If endAt = 0 Then
            cacheText = Left$(cacheText, startAt - 1)
        Else
            cacheText = Left$(cacheText, startAt - 1) & Mid$(cacheText, endAt + 1)
        End If
        startAt = InStr(1, cacheText, markerText, vbBinaryCompare)
    Loop

    MainRepresentedCacheRemove = cacheText
End Function

Private Sub MainEnsureFieldCount(ByRef fields() As String, ByVal requiredIndex As Long)
    If UBound(fields) < requiredIndex Then ReDim Preserve fields(0 To requiredIndex)
End Sub

' Original declaration: Private  Proc_0_26_6ACF30(arg_C, arg_10) '6ACF30
Private Sub Proc_0_26_6ACF30(ParamArray args() As Variant)
    Dim socketIndex As Long
    Dim roomSlot As Long

    On Error GoTo AttachDone
    If UBound(args) < 0 Then GoTo AttachDone

    socketIndex = CLng(Val(CStr(args(0))))
    If socketIndex <= 0 Then GoTo AttachDone
    If Proc_11_2_821390(socketIndex, 0, 0) <> 1 Then GoTo AttachDone

    roomSlot = MainRepresentedSocketRoomSlot(socketIndex)
    If roomSlot <= 0 Then GoTo AttachDone

    MainRepresentedRoomOccupantAdd roomSlot, socketIndex, 1

AttachDone:
End Sub

' Original declaration: Private  Proc_0_27_6AD400(arg_C, arg_10) '6AD400
Private Sub Proc_0_27_6AD400(ParamArray args() As Variant)
    Dim entityIndex As Long
    Dim roomSlot As Long

    On Error GoTo AttachDone
    If UBound(args) < 0 Then GoTo AttachDone

    entityIndex = CLng(Val(CStr(args(0))))
    If entityIndex <= 0 Then GoTo AttachDone

    roomSlot = MainRepresentedBotRoomSlot(entityIndex)
    If roomSlot <= 0 Then GoTo AttachDone

    MainRepresentedRoomOccupantAdd roomSlot, entityIndex, 2

AttachDone:
End Sub

' Original declaration: Private  Proc_0_28_6AD850(arg_C) '6AD850
Private Sub Proc_0_28_6AD850()
    ' TODO: Reconstruct behavior from decompiled reference.
End Sub

' Original declaration: Private  Proc_0_29_6B0E10(arg_C) '6B0E10
Private Sub Proc_0_29_6B0E10()
    ' TODO: Reconstruct behavior from decompiled reference.
End Sub
