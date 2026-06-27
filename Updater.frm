VERSION 5.00
Begin VB.Form Updater
  Caption = "Downloade Updates..."
  BackColor = &HFFFFFF&
  ScaleMode = 1
  AutoRedraw = False
  FontTransparent = True
  BorderStyle = 1 'Fixed Single
  Icon = "Updater.frx":0000
  LinkTopic = "Form1"
  MaxButton = 0   'False
  MinButton = 0   'False
  ClientLeft = 45
  ClientTop = 345
  ClientWidth = 11805
  ClientHeight = 11580
  StartUpPosition = 3 'Windows Default
  Begin VB.Timer walkPerCent
    Interval = 75
    Left = 840
    Top = 0
  End
  Begin VB.Timer DownloadFile
    Interval = 500
    Left = 0
    Top = 0
  End
  Begin VB.Timer Timer2
    Enabled = 0   'False
    Interval = 150
    Left = 2040
    Top = 5760
  End
  Begin VB.Timer Timer1
    Enabled = 0   'False
    Interval = 5000
    Left = 1560
    Top = 5880
  End
  Begin VB.Frame Frame1
    Caption = "Frame1"
    BackColor = &HFFFFFF&
    Left = 120
    Top = 120
    Width = 11535
    Height = 375
    TabIndex = 0
    BorderStyle = 0 'None
    Begin VB.Timer Timer3
      Enabled = 0   'False
      Interval = 2500
      Left = 240
      Top = 0
    End
    Begin VB.Label lblInit
      Caption = "Downloade..."
      Left = 0
      Top = 60
      Width = 11535
      Height = 255
      TabIndex = 29
      Alignment = 2 'Center
      BackStyle = 0 'Transparent
      BeginProperty Font
        Name = "Trebuchet MS"
        Size = 9
        Charset = 0
        Weight = 400
        Underline = 0 'False
        Italic = 0 'False
        Strikethrough = 0 'False
      EndProperty
    End
    Begin VB.Image Image1
      Picture = "Updater.frx":08CA
      Left = 0
      Top = 0
      Width = 11535
      Height = 375
    End
    Begin VB.Image Image2
      Picture = "Updater.frx":EA70
      Left = 0
      Top = 0
      Width = 11535
      Height = 375
    End
  End
  Begin VB.Label downloadFeature
    Caption = "CMS muss im Store erneut heruntergeladen werden"
    ForeColor = &H800000&
    Left = 120
    Top = 10200
    Width = 11535
    Height = 375
    Visible = 0   'False
    TabIndex = 30
    Alignment = 1 'Right Justify
    BackStyle = 0 'Transparent
    BeginProperty Font
      Name = "Trebuchet MS"
      Size = 15
      Charset = 0
      Weight = 400
      Underline = 0 'False
      Italic = 0 'False
      Strikethrough = 0 'False
    EndProperty
  End
  Begin VB.Label mText
    Caption = "asd"
    Index = 6
    ForeColor = &H0&
    Left = 120
    Top = 3120
    Width = 11535
    Height = 375
    TabIndex = 28
    BackStyle = 0 'Transparent
    BeginProperty Font
      Name = "Trebuchet MS"
      Size = 15
      Charset = 0
      Weight = 400
      Underline = 0 'False
      Italic = 0 'False
      Strikethrough = 0 'False
    EndProperty
  End
  Begin VB.Label mText
    Caption = "asd"
    Index = 5
    ForeColor = &H0&
    Left = 120
    Top = 2760
    Width = 11535
    Height = 375
    TabIndex = 27
    BackStyle = 0 'Transparent
    BeginProperty Font
      Name = "Trebuchet MS"
      Size = 15
      Charset = 0
      Weight = 400
      Underline = 0 'False
      Italic = 0 'False
      Strikethrough = 0 'False
    EndProperty
  End
  Begin VB.Label mText
    Caption = "Lorem ipsum dolor sit amet, consetetur sadipscing elitr"
    Index = 25
    ForeColor = &H0&
    Left = 120
    Top = 9960
    Width = 11535
    Height = 375
    TabIndex = 26
    BackStyle = 0 'Transparent
    BeginProperty Font
      Name = "Trebuchet MS"
      Size = 15
      Charset = 0
      Weight = 400
      Underline = 0 'False
      Italic = 0 'False
      Strikethrough = 0 'False
    EndProperty
  End
  Begin VB.Label mText
    Caption = "Lorem ipsum dolor sit amet, consetetur sadipscing elitr"
    Index = 24
    ForeColor = &H0&
    Left = 120
    Top = 9600
    Width = 11535
    Height = 375
    TabIndex = 25
    BackStyle = 0 'Transparent
    BeginProperty Font
      Name = "Trebuchet MS"
      Size = 15
      Charset = 0
      Weight = 400
      Underline = 0 'False
      Italic = 0 'False
      Strikethrough = 0 'False
    EndProperty
  End
  Begin VB.Label mText
    Caption = "Lorem ipsum dolor sit amet, consetetur sadipscing elitr"
    Index = 23
    ForeColor = &H0&
    Left = 120
    Top = 9240
    Width = 11535
    Height = 375
    TabIndex = 24
    BackStyle = 0 'Transparent
    BeginProperty Font
      Name = "Trebuchet MS"
      Size = 15
      Charset = 0
      Weight = 400
      Underline = 0 'False
      Italic = 0 'False
      Strikethrough = 0 'False
    EndProperty
  End
  Begin VB.Label mText
    Caption = "Lorem ipsum dolor sit amet, consetetur sadipscing elitr"
    Index = 22
    ForeColor = &H0&
    Left = 120
    Top = 8880
    Width = 11535
    Height = 375
    TabIndex = 23
    BackStyle = 0 'Transparent
    BeginProperty Font
      Name = "Trebuchet MS"
      Size = 15
      Charset = 0
      Weight = 400
      Underline = 0 'False
      Italic = 0 'False
      Strikethrough = 0 'False
    EndProperty
  End
  Begin VB.Label mText
    Caption = "Lorem ipsum dolor sit amet, consetetur sadipscing elitr"
    Index = 21
    ForeColor = &H0&
    Left = 120
    Top = 8520
    Width = 11535
    Height = 375
    TabIndex = 22
    BackStyle = 0 'Transparent
    BeginProperty Font
      Name = "Trebuchet MS"
      Size = 15
      Charset = 0
      Weight = 400
      Underline = 0 'False
      Italic = 0 'False
      Strikethrough = 0 'False
    EndProperty
  End
  Begin VB.Label mText
    Caption = "Lorem ipsum dolor sit amet, consetetur sadipscing elitr"
    Index = 20
    ForeColor = &H0&
    Left = 120
    Top = 8160
    Width = 11535
    Height = 375
    TabIndex = 21
    BackStyle = 0 'Transparent
    BeginProperty Font
      Name = "Trebuchet MS"
      Size = 15
      Charset = 0
      Weight = 400
      Underline = 0 'False
      Italic = 0 'False
      Strikethrough = 0 'False
    EndProperty
  End
  Begin VB.Label mText
    Caption = "Lorem ipsum dolor sit amet, consetetur sadipscing elitr"
    Index = 19
    ForeColor = &H0&
    Left = 120
    Top = 7800
    Width = 11535
    Height = 375
    TabIndex = 20
    BackStyle = 0 'Transparent
    BeginProperty Font
      Name = "Trebuchet MS"
      Size = 15
      Charset = 0
      Weight = 400
      Underline = 0 'False
      Italic = 0 'False
      Strikethrough = 0 'False
    EndProperty
  End
  Begin VB.Label mText
    Caption = "Lorem ipsum dolor sit amet, consetetur sadipscing elitr"
    Index = 18
    ForeColor = &H0&
    Left = 120
    Top = 7440
    Width = 11535
    Height = 375
    TabIndex = 19
    BackStyle = 0 'Transparent
    BeginProperty Font
      Name = "Trebuchet MS"
      Size = 15
      Charset = 0
      Weight = 400
      Underline = 0 'False
      Italic = 0 'False
      Strikethrough = 0 'False
    EndProperty
  End
  Begin VB.Label mText
    Caption = "Lorem ipsum dolor sit amet, consetetur sadipscing elitr"
    Index = 17
    ForeColor = &H0&
    Left = 120
    Top = 7080
    Width = 11535
    Height = 375
    TabIndex = 18
    BackStyle = 0 'Transparent
    BeginProperty Font
      Name = "Trebuchet MS"
      Size = 15
      Charset = 0
      Weight = 400
      Underline = 0 'False
      Italic = 0 'False
      Strikethrough = 0 'False
    EndProperty
  End
  Begin VB.Label mText
    Caption = "Lorem ipsum dolor sit amet, consetetur sadipscing elitr"
    Index = 16
    ForeColor = &H0&
    Left = 120
    Top = 6720
    Width = 11535
    Height = 375
    TabIndex = 17
    BackStyle = 0 'Transparent
    BeginProperty Font
      Name = "Trebuchet MS"
      Size = 15
      Charset = 0
      Weight = 400
      Underline = 0 'False
      Italic = 0 'False
      Strikethrough = 0 'False
    EndProperty
  End
  Begin VB.Label mText
    Caption = "Lorem ipsum dolor sit amet, consetetur sadipscing elitr"
    Index = 15
    ForeColor = &H0&
    Left = 120
    Top = 6360
    Width = 11535
    Height = 375
    TabIndex = 16
    BackStyle = 0 'Transparent
    BeginProperty Font
      Name = "Trebuchet MS"
      Size = 15
      Charset = 0
      Weight = 400
      Underline = 0 'False
      Italic = 0 'False
      Strikethrough = 0 'False
    EndProperty
  End
  Begin VB.Label mText
    Caption = "Lorem ipsum dolor sit amet, consetetur sadipscing elitr"
    Index = 14
    ForeColor = &H0&
    Left = 120
    Top = 6000
    Width = 11535
    Height = 375
    TabIndex = 15
    BackStyle = 0 'Transparent
    BeginProperty Font
      Name = "Trebuchet MS"
      Size = 15
      Charset = 0
      Weight = 400
      Underline = 0 'False
      Italic = 0 'False
      Strikethrough = 0 'False
    EndProperty
  End
  Begin VB.Label mText
    Caption = "Lorem ipsum dolor sit amet, consetetur sadipscing elitr"
    Index = 13
    ForeColor = &H0&
    Left = 120
    Top = 5640
    Width = 11535
    Height = 375
    TabIndex = 14
    BackStyle = 0 'Transparent
    BeginProperty Font
      Name = "Trebuchet MS"
      Size = 15
      Charset = 0
      Weight = 400
      Underline = 0 'False
      Italic = 0 'False
      Strikethrough = 0 'False
    EndProperty
  End
  Begin VB.Label mText
    Caption = "Lorem ipsum dolor sit amet, consetetur sadipscing elitr"
    Index = 12
    ForeColor = &H0&
    Left = 120
    Top = 5280
    Width = 11535
    Height = 375
    TabIndex = 13
    BackStyle = 0 'Transparent
    BeginProperty Font
      Name = "Trebuchet MS"
      Size = 15
      Charset = 0
      Weight = 400
      Underline = 0 'False
      Italic = 0 'False
      Strikethrough = 0 'False
    EndProperty
  End
  Begin VB.Label mText
    Caption = "Lorem ipsum dolor sit amet, consetetur sadipscing elitr"
    Index = 11
    ForeColor = &H0&
    Left = 120
    Top = 4920
    Width = 11535
    Height = 375
    TabIndex = 12
    BackStyle = 0 'Transparent
    BeginProperty Font
      Name = "Trebuchet MS"
      Size = 15
      Charset = 0
      Weight = 400
      Underline = 0 'False
      Italic = 0 'False
      Strikethrough = 0 'False
    EndProperty
  End
  Begin VB.Label mText
    Caption = "Lorem ipsum dolor sit amet, consetetur sadipscing elitr"
    Index = 10
    ForeColor = &H0&
    Left = 120
    Top = 4560
    Width = 11535
    Height = 375
    TabIndex = 11
    BackStyle = 0 'Transparent
    BeginProperty Font
      Name = "Trebuchet MS"
      Size = 15
      Charset = 0
      Weight = 400
      Underline = 0 'False
      Italic = 0 'False
      Strikethrough = 0 'False
    EndProperty
  End
  Begin VB.Label mText
    Caption = "Lorem ipsum dolor sit amet, consetetur sadipscing elitr"
    Index = 9
    ForeColor = &H0&
    Left = 120
    Top = 4200
    Width = 11535
    Height = 375
    TabIndex = 10
    BackStyle = 0 'Transparent
    BeginProperty Font
      Name = "Trebuchet MS"
      Size = 15
      Charset = 0
      Weight = 400
      Underline = 0 'False
      Italic = 0 'False
      Strikethrough = 0 'False
    EndProperty
  End
  Begin VB.Label mText
    Caption = "asd"
    Index = 8
    ForeColor = &H0&
    Left = 120
    Top = 3840
    Width = 11535
    Height = 375
    TabIndex = 9
    BackStyle = 0 'Transparent
    BeginProperty Font
      Name = "Trebuchet MS"
      Size = 15
      Charset = 0
      Weight = 400
      Underline = 0 'False
      Italic = 0 'False
      Strikethrough = 0 'False
    EndProperty
  End
  Begin VB.Label mText
    Caption = "asd"
    Index = 7
    ForeColor = &H0&
    Left = 120
    Top = 3480
    Width = 11535
    Height = 375
    TabIndex = 8
    BackStyle = 0 'Transparent
    BeginProperty Font
      Name = "Trebuchet MS"
      Size = 15
      Charset = 0
      Weight = 400
      Underline = 0 'False
      Italic = 0 'False
      Strikethrough = 0 'False
    EndProperty
  End
  Begin VB.Label freeFeature
    Caption = "Kostenloses Feature"
    ForeColor = &H8000&
    Left = 120
    Top = 9480
    Width = 11535
    Height = 375
    Visible = 0   'False
    TabIndex = 7
    Alignment = 1 'Right Justify
    BackStyle = 0 'Transparent
    BeginProperty Font
      Name = "Trebuchet MS"
      Size = 15
      Charset = 0
      Weight = 400
      Underline = 0 'False
      Italic = 0 'False
      Strikethrough = 0 'False
    EndProperty
  End
  Begin VB.Label unfreeFeature
    Caption = "Kostet 10 Punkte"
    ForeColor = &HFF&
    Left = 120
    Top = 9840
    Width = 11535
    Height = 375
    TabIndex = 6
    Alignment = 1 'Right Justify
    BackStyle = 0 'Transparent
    BeginProperty Font
      Name = "Trebuchet MS"
      Size = 15
      Charset = 0
      Weight = 400
      Underline = 0 'False
      Italic = 0 'False
      Strikethrough = 0 'False
    EndProperty
  End
  Begin VB.Label mText
    Caption = "asd"
    Index = 4
    ForeColor = &H0&
    Left = 120
    Top = 2400
    Width = 11535
    Height = 375
    TabIndex = 5
    BackStyle = 0 'Transparent
    BeginProperty Font
      Name = "Trebuchet MS"
      Size = 15
      Charset = 0
      Weight = 400
      Underline = 0 'False
      Italic = 0 'False
      Strikethrough = 0 'False
    EndProperty
  End
  Begin VB.Label mText
    Caption = "asd"
    Index = 3
    ForeColor = &H0&
    Left = 120
    Top = 2040
    Width = 11535
    Height = 375
    TabIndex = 4
    BackStyle = 0 'Transparent
    BeginProperty Font
      Name = "Trebuchet MS"
      Size = 15
      Charset = 0
      Weight = 400
      Underline = 0 'False
      Italic = 0 'False
      Strikethrough = 0 'False
    EndProperty
  End
  Begin VB.Label mText
    Caption = "asd"
    Index = 2
    ForeColor = &H0&
    Left = 120
    Top = 1680
    Width = 11535
    Height = 375
    TabIndex = 3
    BackStyle = 0 'Transparent
    BeginProperty Font
      Name = "Trebuchet MS"
      Size = 15
      Charset = 0
      Weight = 400
      Underline = 0 'False
      Italic = 0 'False
      Strikethrough = 0 'False
    EndProperty
  End
  Begin VB.Label mText
    Caption = "asd"
    Index = 1
    ForeColor = &H0&
    Left = 120
    Top = 1320
    Width = 11535
    Height = 375
    TabIndex = 2
    BackStyle = 0 'Transparent
    BeginProperty Font
      Name = "Trebuchet MS"
      Size = 15
      Charset = 0
      Weight = 400
      Underline = 0 'False
      Italic = 0 'False
      Strikethrough = 0 'False
    EndProperty
  End
  Begin VB.Label mTitle
    Caption = "asd"
    ForeColor = &H0&
    Left = 120
    Top = 720
    Width = 11535
    Height = 615
    TabIndex = 1
    BackStyle = 0 'Transparent
    BeginProperty Font
      Name = "Trebuchet MS"
      Size = 24.75
      Charset = 0
      Weight = 400
      Underline = 0 'False
      Italic = 0 'False
      Strikethrough = 0 'False
    EndProperty
  End
End

Attribute VB_Name = "Updater"
Option Explicit

Private pendingHeightTarget As Long
Private pendingAnimationInterval As Long
Private pendingProgressWidth As Long

' Reconstructed code shell generated from decompiled output.
' Source reference: /opt/git/AlphaSeries_cracked/DECOMPILED/Updater.frm
' Event bodies are inert until each handler is manually reconstructed.

' Original declaration: Private Sub Timer3_Timer() '8238F0
Private Sub Timer3_Timer()
    ' TODO: Reconstruct behavior from decompiled reference.
End Sub

' Original declaration: Private Sub DownloadFile_Timer() '821E60
Private Sub DownloadFile_Timer()
    Dim updateRows() As String
    Dim updateCount As Long
    Dim targetWidth As Long
    Dim executableName As String
    Dim destinationPath As String
    Dim sourceUrl As String

    On Error GoTo DownloadFailed
    DownloadFile.Enabled = False

    updateRows = Split(global_00829044, Chr$(10))
    updateCount = UBound(updateRows)
    If updateCount <= 0 Then updateCount = 1

    targetWidth = CLng(11535 / updateCount)
    If targetWidth < 1 Then targetWidth = 1
    QueueProgressWidth targetWidth

    executableName = GetUpdaterExecutableName()
    destinationPath = App.Path & "\" & executableName & ".exe"
    sourceUrl = "http://www.alpha-series.com/upgrades/" & executableName & "/file.database?timestamp=" & Format$(Now, "dmYnhs")

    If Not CBool(Proc_10_28_8210C0(sourceUrl, destinationPath)) Then GoTo DownloadFailed
    lblInit.Caption = "Installiere..."
    Timer3.Enabled = True
    Exit Sub

DownloadFailed:
    On Error Resume Next
    Hide
    MsgBox "Es ist ein Fehler aufgetreten. Versuche es erneut!", vbCritical
    End
End Sub

' Original declaration: Private Sub Timer1_Timer() '823220
Private Sub Timer1_Timer()
    On Error Resume Next
    Timer1.Enabled = False
    If pendingAnimationInterval <= 0 Then pendingAnimationInterval = 1
    Timer2.Interval = pendingAnimationInterval
    Timer2.Enabled = True
End Sub

' Original declaration: Private Sub Timer2_Timer() '823420
Private Sub Timer2_Timer()
    On Error Resume Next

    If pendingHeightTarget <= 0 Then
        Timer2.Enabled = False
        Exit Sub
    End If

    If Height < pendingHeightTarget Then
        Height = Height + 50
        If Height >= pendingHeightTarget Then
            Height = pendingHeightTarget
            Timer2.Enabled = False
        End If
    ElseIf Height > pendingHeightTarget Then
        Height = Height - 50
        If Height <= pendingHeightTarget Then
            Height = pendingHeightTarget
            Timer2.Enabled = False
        End If
    Else
        Timer2.Enabled = False
    End If
End Sub

' Original declaration: Private Sub Form_Load() '822330
Private Sub Form_Load()
    ' TODO: Reconstruct behavior from decompiled reference.
End Sub

' Original declaration: Private Sub Form_Unload(Cancel As Integer) '823170
Private Sub Form_Unload(Cancel As Integer)
    On Error Resume Next
    End
End Sub

' Original declaration: Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer) '8230C0
Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
    On Error Resume Next
    End
End Sub

' Original declaration: Private Sub walkPerCent_Timer() '824C00
Private Sub walkPerCent_Timer()
    On Error GoTo ProgressFailed
    walkPerCent.Enabled = False

    If pendingProgressWidth <= 0 Then
        walkPerCent.Enabled = False
        Exit Sub
    End If

    If Image1.Width < pendingProgressWidth Then
        Image1.Width = Image1.Width + 50
        If Image1.Width > pendingProgressWidth Then Image1.Width = pendingProgressWidth
    ElseIf Image1.Width > pendingProgressWidth Then
        Image1.Width = pendingProgressWidth
    End If

    If Image1.Width >= 11535 And Timer3.Enabled = False Then
        Hide
        MsgBox "Update erfolgreich heruntergeladen. Die Datei wurde nach """ & App.EXEName & ".exe"" benannt." & vbCrLf & vbCrLf & "Bitte schauen Sie doch einmal in unserem User Voice Forum nach neuen Meldungen. Die Webseite wurde automatisch geöffnet.", vbInformation
        End
    End If

    walkPerCent.Enabled = True
    Exit Sub

ProgressFailed:
    On Error Resume Next
    Hide
    MsgBox "Es ist ein Fehler aufgetreten. Versuche es erneut!", vbCritical
    End
End Sub

Private Sub QueueHeightAnimation(ByVal targetHeight As Long, ByVal animationInterval As Long)
    pendingHeightTarget = targetHeight
    pendingAnimationInterval = animationInterval
    Timer1.Enabled = True
End Sub

Private Sub QueueProgressWidth(ByVal targetWidth As Long)
    pendingProgressWidth = targetWidth
    walkPerCent.Enabled = True
End Sub

Private Function GetUpdaterExecutableName() As String
    If Len(global_00829040) > 0 Then
        GetUpdaterExecutableName = global_00829040
    Else
        GetUpdaterExecutableName = App.EXEName
    End If
End Function
