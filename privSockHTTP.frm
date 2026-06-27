VERSION 5.00
Object = "{48E59290-9880-11CF-975400AA00C00908}#1.0#0"; "C:\Windows\SysWow64\MSINET.OCX"
Object = "{248DD890-BB45-11CF-9ABC-0080C7E7B78D}#1.0#0"; "C:\Windows\SysWow64\MSWINSCK.OCX"
Begin VB.Form privSockHTTP
  Caption = "privSockHTTP"
  BackColor = &HFFFFFF&
  ScaleMode = 1
  AutoRedraw = False
  FontTransparent = True
  BorderStyle = 0 'None
  Icon = "privSockHTTP.frx":0000
  LinkTopic = "Form2"
  ClientLeft = 0
  ClientTop = 0
  ClientWidth = 795
  ClientHeight = 450
  ShowInTaskbar = 0   'False
  StartUpPosition = 3 'Windows Default
  Begin InetCtlsObjects.Inet Inet1
    OleObjectBlob = "privSockHTTP.frx":08CA
    Left = 0
    Top = 0
  End
  Begin VB.Timer tmrCheckAlive
    Index = 0
    Enabled = 0   'False
    Interval = 250
    Left = 360
    Top = 0
  End
  Begin MSWinsockLib.Winsock GetHTTP
    Index = 0
    OleObjectBlob = "privSockHTTP.frx":091C
    Left = 0
    Top = 0
  End
End

Attribute VB_Name = "privSockHTTP"
Option Explicit

Private httpAliveTicks(0 To 9999) As Integer
Private httpResponseBuffer(0 To 9999) As String
Private httpRequestPath(0 To 9999) As String
Private httpRequestHost(0 To 9999) As String
Private httpRequestPort(0 To 9999) As String

' Reconstructed code shell generated from decompiled output.
' Source reference: /opt/git/AlphaSeries_cracked/DECOMPILED/privSockHTTP.frm
' Event bodies are inert until each handler is manually reconstructed.

' Original declaration: Private Sub tmrCheckAlive_Timer(Index As Integer) '826A50
Private Sub tmrCheckAlive_Timer(Index As Integer)
    Dim hostPort As String
    Dim requestText As String

    On Error Resume Next
    If Index < LBound(httpAliveTicks) Or Index > UBound(httpAliveTicks) Then Exit Sub

    If httpAliveTicks(Index) >= 200 Then
        tmrCheckAlive(Index).Enabled = False
        Exit Sub
    End If

    httpAliveTicks(Index) = httpAliveTicks(Index) + 1
    If httpResponseBuffer(Index) = "-1" Then Exit Sub
    If Len(httpRequestPath(Index)) = 0 Or Len(httpRequestHost(Index)) = 0 Then Exit Sub

    httpResponseBuffer(Index) = vbNullString
    If Len(httpRequestPort(Index)) > 0 And Val(httpRequestPort(Index)) <> 80 Then
        hostPort = ":" & CStr(Val(httpRequestPort(Index)))
    End If

    requestText = "GET " & httpRequestPath(Index) & " HTTP/1.1" & vbCrLf & _
                  "Host:   " & httpRequestHost(Index) & hostPort & vbCrLf & _
                  "Connection:   keep-alive" & vbCrLf & _
                  "Accept:   application/xml,application/xhtml+xml,text/html;q=0.9,text/plain;q=0.8,image/png,*/*;q=0.5" & vbCrLf & _
                  "User-Agent:   FireFox/1.0" & vbCrLf & _
                  "Accept-Language:   en-US,en;q=0.8;q=0.6,en;q=0.4" & vbCrLf & _
                  "Accept-Charset:   ISO-8859-1,utf-8;q=0.7,*;q=0.3" & vbCrLf & vbCrLf

    GetHTTP(Index).SendData requestText
End Sub

' Original declaration: Public Function ReadHTTP(URL, Action) '825160
Public Function ReadHTTP(Optional ByVal URL As Variant, Optional ByVal Action As Variant) As Variant
    On Error GoTo ReadFailed
    ReadHTTP = Inet1.OpenURL(CStr(URL))
    Exit Function

ReadFailed:
    ReadHTTP = vbNullString
End Function
