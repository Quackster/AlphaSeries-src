Attribute VB_Name = "Functions"
Option Explicit

' Reconstructed VB6 source shell generated from decompiled output.
' Source reference: /opt/git/AlphaSeries_cracked/DECOMPILED/Functions.bas
' Decompiled procedure bodies are intentionally not copied until they are understood and made valid VB6.

Public global_0082928C As String
Public global_008292A8 As Variant

' Original declaration: Private Sub Proc_10_0_809570
Public Function Proc_10_0_809570(ParamArray args() As Variant) As Variant
    Dim keyName As String

    On Error GoTo LookupFailed
    If UBound(args) < 0 Then
        Proc_10_0_809570 = vbNullString
        Exit Function
    End If

    keyName = CStr(args(0))
    Proc_10_0_809570 = ReadSettingsValue(global_0082928C, keyName)
    Exit Function

LookupFailed:
    Proc_10_0_809570 = vbNullString
End Function

' Original declaration: Private  Proc_10_1_809790(arg_C, arg_10, arg_14) '809790
Public Function Proc_10_1_809790(ParamArray args() As Variant) As Variant
    Dim rankIndex As Long
    Dim basePermissions As String
    Dim permissionName As String
    Dim permissionList As String

    On Error GoTo CheckFailed
    If UBound(args) < 2 Then
        Proc_10_1_809790 = False
        Exit Function
    End If

    rankIndex = CLng(Val(CStr(args(0))))
    basePermissions = CStr(args(1))
    permissionName = CStr(args(2))

    permissionList = Chr$(2) & basePermissions & Chr$(2)
    If IsArray(global_008292A8) Then
        If rankIndex >= LBound(global_008292A8) And rankIndex <= UBound(global_008292A8) Then
            permissionList = permissionList & CStr(global_008292A8(rankIndex))
        End If
    End If

    Proc_10_1_809790 = (InStr(1, permissionList, Chr$(2) & permissionName & Chr$(2), vbBinaryCompare) > 0)
    Exit Function

CheckFailed:
    Proc_10_1_809790 = False
End Function

' Original declaration: Private Sub Proc_10_2_8099D0
Public Function Proc_10_2_8099D0(ParamArray args() As Variant) As Variant
    Dim requestedLength As Long
    Dim index As Long
    Dim outputValue As String

    On Error GoTo GenerateFailed
    If UBound(args) < 0 Then
        Proc_10_2_8099D0 = vbNullString
        Exit Function
    End If

    requestedLength = CLng(args(0))
    If requestedLength > 100 Then requestedLength = 100
    If requestedLength < 0 Then requestedLength = 0

    For index = 1 To requestedLength
        If CLng(Proc_10_4_809CA0(0, 1)) = 1 Then
            outputValue = outputValue & Chr$(CLng(Proc_10_4_809CA0(48, 57)))
        Else
            outputValue = outputValue & Chr$(CLng(Proc_10_4_809CA0(97, 122)))
        End If
    Next index

    Proc_10_2_8099D0 = outputValue
    Exit Function

GenerateFailed:
    Proc_10_2_8099D0 = vbNullString
End Function

' Original declaration: Private  Proc_10_3_809B90(arg_C) '809B90
Public Function Proc_10_3_809B90(ParamArray args() As Variant) As Variant
    Proc_10_3_809B90 = CStr(RandomLongFromArgs(args))
End Function

' Original declaration: Private  Proc_10_4_809CA0(arg_C) '809CA0
Public Function Proc_10_4_809CA0(ParamArray args() As Variant) As Variant
    Proc_10_4_809CA0 = RandomLongFromArgs(args)
End Function

' Original declaration: Private  Proc_10_5_809D80(arg_C) '809D80
Public Function Proc_10_5_809D80(ParamArray args() As Variant) As Variant
    Dim sourceValue As String
    Dim startAt As Long
    Dim fieldLength As Long

    On Error GoTo ExtractFailed
    If UBound(args) < 1 Then
        Proc_10_5_809D80 = vbNullString
        Exit Function
    End If

    sourceValue = CStr(args(0))
    startAt = CLng(args(1))
    If startAt < 1 Then startAt = 1

    If UBound(args) >= 2 And Len(CStr(args(2))) > 0 Then
        fieldLength = CLng(Val(CStr(args(2))))
        If fieldLength > 0 Then
            Proc_10_5_809D80 = Mid$(sourceValue, startAt, fieldLength)
        Else
            Proc_10_5_809D80 = Mid$(sourceValue, startAt)
        End If
    Else
        Proc_10_5_809D80 = Mid$(sourceValue, startAt)
    End If
    Exit Function

ExtractFailed:
    Proc_10_5_809D80 = vbNullString
End Function

' Original declaration: Private Sub Proc_10_6_809F10
Public Function Proc_10_6_809F10(ParamArray args() As Variant) As Variant
    Dim sourceValue As String
    Dim encodedLengthSize As Long
    Dim fieldLength As Long

    On Error GoTo ExtractFailed
    If UBound(args) < 0 Then
        Proc_10_6_809F10 = vbNullString
        Exit Function
    End If

    sourceValue = CStr(args(0))
    encodedLengthSize = CLng(Proc_3_2_6D30A0(sourceValue))
    fieldLength = CLng(Proc_3_3_6D3240(sourceValue))

    If encodedLengthSize <= 0 Or fieldLength <= 0 Then
        Proc_10_6_809F10 = vbNullString
    Else
        Proc_10_6_809F10 = Mid$(sourceValue, encodedLengthSize + 1, fieldLength)
    End If
    Exit Function

ExtractFailed:
    Proc_10_6_809F10 = vbNullString
End Function

' Original declaration: Private Sub Proc_10_7_80A190
Public Function Proc_10_7_80A190(ParamArray args() As Variant) As Variant
    Dim sourceValue As String
    Dim fieldLength As Long

    On Error GoTo ExtractFailed
    If UBound(args) < 0 Then
        Proc_10_7_80A190 = vbNullString
        Exit Function
    End If

    sourceValue = CStr(args(0))
    fieldLength = CLng(Proc_3_4_6D3620(sourceValue))
    If fieldLength <= 0 Then
        Proc_10_7_80A190 = vbNullString
    Else
        Proc_10_7_80A190 = Mid$(sourceValue, 3, fieldLength)
    End If
    Exit Function

ExtractFailed:
    Proc_10_7_80A190 = vbNullString
End Function

' Original declaration: Private  Proc_10_8_80A580(arg_C) '80A580
Public Function Proc_10_8_80A580(ParamArray args() As Variant) As Variant
    Dim firstValue As Long
    Dim secondValue As Long

    On Error GoTo BuildFailed
    If UBound(args) < 0 Then
        Proc_10_8_80A580 = vbNullString
        Exit Function
    End If

    firstValue = CLng(Val(CStr(args(0))))
    If UBound(args) >= 1 Then secondValue = CLng(Val(CStr(args(1))))
    Proc_10_8_80A580 = CStr(Proc_3_0_6D2AF0(firstValue, 0, "Dk")) & CStr(Proc_3_0_6D2AF0(secondValue, 0, vbNullString))
    Exit Function

BuildFailed:
    Proc_10_8_80A580 = vbNullString
End Function

' Original declaration: Private Sub Proc_10_9_80A680
Public Function Proc_10_9_80A680(ParamArray args() As Variant) As Variant
    On Error GoTo CleanupFailed
    If UBound(args) < 0 Then
        Proc_10_9_80A680 = vbNullString
    Else
        Proc_10_9_80A680 = Replace(CStr(args(0)), Chr$(0), Chr$(160))
    End If
    Exit Function

CleanupFailed:
    Proc_10_9_80A680 = vbNullString
End Function

' Original declaration: Private Sub Proc_10_10_80A7F0
Public Function Proc_10_10_80A7F0(ParamArray args() As Variant) As Variant
    Dim value As String

    On Error GoTo CleanupFailed
    If UBound(args) < 0 Then
        Proc_10_10_80A7F0 = vbNullString
        Exit Function
    End If

    value = CStr(args(0))
    value = Replace(value, Chr$(10), Chr$(32))
    value = Replace(value, Chr$(13), Chr$(32))
    Proc_10_10_80A7F0 = value
    Exit Function

CleanupFailed:
    Proc_10_10_80A7F0 = vbNullString
End Function

' Original declaration: Private Sub Proc_10_11_80A9C0
Public Function Proc_10_11_80A9C0(ParamArray args() As Variant) As Variant
    Dim value As String

    On Error GoTo EscapeFailed
    If UBound(args) < 0 Then
        Proc_10_11_80A9C0 = vbNullString
        Exit Function
    End If

    value = CStr(args(0))
    value = Replace(value, "'", "''")
    value = Replace(value, "\r", Chr$(32))
    value = Replace(value, "\n", Chr$(32))
    value = Replace(value, """", Chr$(32))
    Proc_10_11_80A9C0 = value
    Exit Function

EscapeFailed:
    Proc_10_11_80A9C0 = vbNullString
End Function

' Original declaration: Private  Proc_10_12_80ADB0(arg_C) '80ADB0
Public Function Proc_10_12_80ADB0(ParamArray args() As Variant) As Variant
    On Error GoTo SendFailed
    If UBound(args) < 1 Then
        Proc_10_12_80ADB0 = Empty
        Exit Function
    End If

    Proc_10_12_80ADB0 = Proc_7_0_8034A0("Ba" & CStr(args(0)) & Chr$(2) & CStr(args(1)) & Chr$(2))
    Exit Function

SendFailed:
    Proc_10_12_80ADB0 = Empty
End Function

' Original declaration: Private  Proc_10_13_80AEC0(arg_10) '80AEC0
Public Function Proc_10_13_80AEC0(ParamArray args() As Variant) As Variant
    On Error GoTo SendFailed
    If UBound(args) < 1 Then
        Proc_10_13_80AEC0 = Empty
        Exit Function
    End If

    Proc_10_13_80AEC0 = Proc_7_0_8034A0("Ba" & CStr(args(0)) & Chr$(2) & CStr(args(1)) & Chr$(2))
    Exit Function

SendFailed:
    Proc_10_13_80AEC0 = Empty
End Function

' Original declaration: Private Sub Proc_10_14_80B010
Public Function Proc_10_14_80B010(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_10_14_80B010 = Empty
End Function

' Original declaration: Private Sub Proc_10_15_80BA40
Public Function Proc_10_15_80BA40(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_10_15_80BA40 = Empty
End Function

' Original declaration: Private Sub Proc_10_16_80C480
Public Function Proc_10_16_80C480(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_10_16_80C480 = Empty
End Function

' Original declaration: Private Sub Proc_10_17_80C6B0
Public Function Proc_10_17_80C6B0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_10_17_80C6B0 = Empty
End Function

' Original declaration: Private Sub Proc_10_18_80C9E0
Public Function Proc_10_18_80C9E0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_10_18_80C9E0 = Empty
End Function

' Original declaration: Private Sub Proc_10_19_80CCD0
Public Function Proc_10_19_80CCD0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_10_19_80CCD0 = Empty
End Function

' Original declaration: Private  Proc_10_20_80CF60(arg_C, arg_10) '80CF60
Public Function Proc_10_20_80CF60(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_10_20_80CF60 = Empty
End Function

' Original declaration: Private  Proc_10_21_80D0A0(arg_C, arg_10) '80D0A0
Public Function Proc_10_21_80D0A0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_10_21_80D0A0 = Empty
End Function

' Original declaration: Private Sub Proc_10_22_80D460
Public Function Proc_10_22_80D460(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_10_22_80D460 = Empty
End Function

' Original declaration: Private  Proc_10_23_80E110(arg_C, arg_10, arg_14) '80E110
Public Function Proc_10_23_80E110(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_10_23_80E110 = Empty
End Function

' Original declaration: Private Sub Proc_10_24_80E790
Public Function Proc_10_24_80E790(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_10_24_80E790 = Empty
End Function

' Original declaration: Private  Proc_10_25_80F5D0(arg_C, arg_10) '80F5D0
Public Function Proc_10_25_80F5D0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_10_25_80F5D0 = Empty
End Function

' Original declaration: Private Sub Proc_10_26_81E4E0
Public Function Proc_10_26_81E4E0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_10_26_81E4E0 = Empty
End Function

' Original declaration: Private  Proc_10_27_81F1A0(arg_C, arg_10) '81F1A0
Public Function Proc_10_27_81F1A0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_10_27_81F1A0 = Empty
End Function

' Original declaration: Private  Proc_10_28_8210C0(arg_C) '8210C0
Public Function Proc_10_28_8210C0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_10_28_8210C0 = Empty
End Function

Private Function RandomLongFromArgs(ByRef args() As Variant) As Long
    Dim lowerBound As Long
    Dim upperBound As Long
    Dim swapValue As Long

    On Error GoTo RandomFailed
    If UBound(args) < 1 Then
        RandomLongFromArgs = 0
        Exit Function
    End If

    lowerBound = CLng(args(0))
    upperBound = CLng(args(1))
    If upperBound < lowerBound Then
        swapValue = lowerBound
        lowerBound = upperBound
        upperBound = swapValue
    End If

    Randomize
    RandomLongFromArgs = CLng(Int((upperBound - lowerBound + 1) * Rnd) + lowerBound)
    Exit Function

RandomFailed:
    RandomLongFromArgs = 0
End Function

Private Function ReadSettingsValue(ByVal settingsText As String, ByVal keyName As String) As String
    Dim marker As String
    Dim valueStart As Long
    Dim valueEnd As Long
    Dim normalizedText As String
    Dim settingLines() As String
    Dim index As Long
    Dim currentLine As String
    Dim equalsAt As Long

    If Len(keyName) = 0 Or Len(settingsText) = 0 Then Exit Function

    marker = "[" & keyName & "="
    valueStart = InStr(1, settingsText, marker, vbTextCompare)
    If valueStart > 0 Then
        valueStart = valueStart + Len(marker)
        valueEnd = InStr(valueStart, settingsText, "]", vbBinaryCompare)
        If valueEnd = 0 Then valueEnd = Len(settingsText) + 1
        ReadSettingsValue = Mid$(settingsText, valueStart, valueEnd - valueStart)
        Exit Function
    End If

    normalizedText = Replace(settingsText, vbCrLf, vbLf)
    normalizedText = Replace(normalizedText, vbCr, vbLf)
    normalizedText = Replace(normalizedText, "]", vbLf)
    settingLines = Split(normalizedText, vbLf)

    For index = LBound(settingLines) To UBound(settingLines)
        currentLine = Trim$(settingLines(index))
        If Left$(currentLine, 1) = "[" Then currentLine = Mid$(currentLine, 2)
        equalsAt = InStr(1, currentLine, "=", vbBinaryCompare)
        If equalsAt > 0 Then
            If StrComp(Trim$(Left$(currentLine, equalsAt - 1)), keyName, vbTextCompare) = 0 Then
                ReadSettingsValue = Mid$(currentLine, equalsAt + 1)
                Exit Function
            End If
        End If
    Next index
End Function
