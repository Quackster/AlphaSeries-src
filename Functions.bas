Attribute VB_Name = "Functions"
Option Explicit

' Reconstructed VB6 source shell generated from decompiled output.
' Source reference: /opt/git/AlphaSeries_cracked/DECOMPILED/Functions.bas
' Decompiled procedure bodies are intentionally not copied until they are understood and made valid VB6.

' Original declaration: Private Sub Proc_10_0_809570
Public Function Proc_10_0_809570(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_10_0_809570 = Empty
End Function

' Original declaration: Private  Proc_10_1_809790(arg_C, arg_10, arg_14) '809790
Public Function Proc_10_1_809790(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_10_1_809790 = Empty
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
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_10_5_809D80 = Empty
End Function

' Original declaration: Private Sub Proc_10_6_809F10
Public Function Proc_10_6_809F10(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_10_6_809F10 = Empty
End Function

' Original declaration: Private Sub Proc_10_7_80A190
Public Function Proc_10_7_80A190(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_10_7_80A190 = Empty
End Function

' Original declaration: Private  Proc_10_8_80A580(arg_C) '80A580
Public Function Proc_10_8_80A580(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_10_8_80A580 = Empty
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
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_10_12_80ADB0 = Empty
End Function

' Original declaration: Private  Proc_10_13_80AEC0(arg_10) '80AEC0
Public Function Proc_10_13_80AEC0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
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
