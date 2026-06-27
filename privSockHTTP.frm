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

' Reconstructed code shell generated from decompiled output.
' Source reference: /opt/git/AlphaSeries_cracked/DECOMPILED/privSockHTTP.frm
' Event bodies are inert until each handler is manually reconstructed.

' Original declaration: Private Sub tmrCheckAlive_Timer(Index As Integer) '826A50
Private Sub tmrCheckAlive_Timer(Index As Integer)
    ' TODO: Reconstruct behavior from decompiled reference.
End Sub

' Original declaration: Public Function ReadHTTP(URL, Action) '825160
Public Function ReadHTTP(Optional ByVal URL As Variant, Optional ByVal Action As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Empty
End Function
