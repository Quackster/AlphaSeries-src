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
    ' TODO: Reconstruct behavior from decompiled reference.
End Sub

' Original declaration contained invalid VB6 identifier text: Private Sub gameServer_C_q]<lkamWk&_uo_lLfj`j=nEge]( '68F5C0
Private Sub gameServer_C_q()
    ' TODO: Reconstruct behavior from decompiled reference.
End Sub

' Original declaration: Private Sub gameServer_UnknownEvent_C '68F4C0
Private Sub gameServer_UnknownEvent_C()
    ' TODO: Reconstruct behavior from decompiled reference.
End Sub

' Original declaration: Private Sub gameServer_UnknownEvent_D '68EB20
Private Sub gameServer_UnknownEvent_D()
    ' TODO: Reconstruct behavior from decompiled reference.
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
    ' TODO: Reconstruct behavior from decompiled reference.
End Sub

' Original declaration: Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer) '68D210
Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
    ' TODO: Reconstruct behavior from decompiled reference.
End Sub

' Original declaration: Private Sub Form_Initialize() '68B530
Private Sub Form_Initialize()
    ' TODO: Reconstruct behavior from decompiled reference.
End Sub

' Original declaration: Private Sub tmrRollers_Timer(Index As Integer) '6B5900
Private Sub tmrRollers_Timer(Index As Integer)
    ' TODO: Reconstruct behavior from decompiled reference.
End Sub

' Original declaration: Private Sub tmrPing_Timer() '694630
Private Sub tmrPing_Timer()
    ' TODO: Reconstruct behavior from decompiled reference.
End Sub

' Original declaration: Private Sub tmrWalking_Timer(Index As Integer) '693B20
Private Sub tmrWalking_Timer(Index As Integer)
    ' TODO: Reconstruct behavior from decompiled reference.
End Sub

' Original declaration: Public Function EasyGetIdentity(arg1) '68C620
Public Function EasyGetIdentity(Optional ByVal arg1 As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    EasyGetIdentity = Empty
End Function

' Original declaration: Public Function NewPremiumCheck(arg0, arg1) '68C820
Public Function NewPremiumCheck(Optional ByVal arg0 As Variant, Optional ByVal arg1 As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    NewPremiumCheck = Empty
End Function

' Original declaration: Public Function CreateSuperEasyIdentity(arg1) '68CB10
Public Function CreateSuperEasyIdentity(Optional ByVal arg1 As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    CreateSuperEasyIdentity = Empty
End Function

' Original declaration: Public Function SuperEasyGetIdentity(arg1) '68CD20
Public Function SuperEasyGetIdentity(Optional ByVal arg1 As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    SuperEasyGetIdentity = Empty
End Function

' Original declaration: Public Function GetIdentity(arg1, arg2) '68CF20
Public Function GetIdentity(Optional ByVal arg1 As Variant, Optional ByVal arg2 As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    GetIdentity = Empty
End Function

' Original declaration: Public Sub runServer() '68EC00
Public Sub runServer()
    ' TODO: Reconstruct behavior from decompiled reference.
End Sub

' Original declaration: Public Function getProcessor() '68EE00
Public Function getProcessor() As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    getProcessor = Empty
End Function

' Original declaration: Private  Proc_0_22_68C1A0(arg_C) '68C1A0
Private Sub Proc_0_22_68C1A0()
    ' TODO: Reconstruct behavior from decompiled reference.
End Sub

' Original declaration: Private  Proc_0_23_68C430(arg_C) '68C430
Private Sub Proc_0_23_68C430()
    ' TODO: Reconstruct behavior from decompiled reference.
End Sub

' Original declaration: Private Sub Proc_0_24_68EEF0
Private Sub Proc_0_24_68EEF0()
    ' TODO: Reconstruct behavior from decompiled reference.
End Sub

' Original declaration: Private  Proc_0_25_68FBC0(arg_C, arg_10) '68FBC0
Private Sub Proc_0_25_68FBC0()
    ' TODO: Reconstruct behavior from decompiled reference.
End Sub

' Original declaration: Private  Proc_0_26_6ACF30(arg_C, arg_10) '6ACF30
Private Sub Proc_0_26_6ACF30()
    ' TODO: Reconstruct behavior from decompiled reference.
End Sub

' Original declaration: Private  Proc_0_27_6AD400(arg_C, arg_10) '6AD400
Private Sub Proc_0_27_6AD400()
    ' TODO: Reconstruct behavior from decompiled reference.
End Sub

' Original declaration: Private  Proc_0_28_6AD850(arg_C) '6AD850
Private Sub Proc_0_28_6AD850()
    ' TODO: Reconstruct behavior from decompiled reference.
End Sub

' Original declaration: Private  Proc_0_29_6B0E10(arg_C) '6B0E10
Private Sub Proc_0_29_6B0E10()
    ' TODO: Reconstruct behavior from decompiled reference.
End Sub
