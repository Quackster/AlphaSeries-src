Attribute VB_Name = "Boot"
Option Explicit

' Reconstructed VB6 source shell generated from decompiled output.
' Source reference: /opt/git/AlphaSeries_cracked/DECOMPILED/Boot.bas
' Decompiled procedure bodies are intentionally not copied until they are understood and made valid VB6.

' Original declaration: Private Sub Proc_1_0_6BA9D0
Public Function Proc_1_0_6BA9D0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_1_0_6BA9D0 = Empty
End Function

' Original declaration: Private Sub Proc_1_1_6BB340
Public Function Proc_1_1_6BB340(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_1_1_6BB340 = Empty
End Function

' Original declaration: Private Sub Proc_1_2_6BE280
Public Function Proc_1_2_6BE280(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_1_2_6BE280 = Empty
End Function

' Original declaration: Private Sub Proc_1_3_6BEBA0
Public Function Proc_1_3_6BEBA0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_1_3_6BEBA0 = Empty
End Function

' Original declaration: Private Sub Proc_1_4_6C4F00
Public Function Proc_1_4_6C4F00(ParamArray args() As Variant) As Variant
    On Error GoTo BootStepFailed
    Proc_1_8_6C6850 0, 0, 0
    Proc_1_22_6D0F00 0, 0, 0
    Proc_1_11_6C8D10 0, 0, 0
    Proc_1_12_6C8EF0 0, 0, 0
    Proc_1_2_6BE280 0

BootStepFailed:
    Proc_1_4_6C4F00 = Empty
End Function

' Original declaration: Private Sub Proc_1_5_6C4F80
Public Function Proc_1_5_6C4F80(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_1_5_6C4F80 = Empty
End Function

' Original declaration: Private Sub Proc_1_6_6C5830
Public Function Proc_1_6_6C5830(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_1_6_6C5830 = Empty
End Function

' Original declaration: Private Sub Proc_1_7_6C5E10
Public Function Proc_1_7_6C5E10(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_1_7_6C5E10 = Empty
End Function

' Original declaration: Private Sub Proc_1_8_6C6850
Public Function Proc_1_8_6C6850(ParamArray args() As Variant) As Variant
    Dim rows() As String
    Dim fields() As String
    Dim rowIndex As Long
    Dim cacheKey As String
    Dim cacheValue As String

    On Error GoTo BuildFailed

    rows = Split(CStr(Proc_5_2_6D4690("SELECT variable,value FROM locales WHERE category='2' AND variable LIKE 'roomevent_type_" & Chr$(37) & "'", 0, 0)), Chr$(13))
    For rowIndex = LBound(rows) To UBound(rows)
        If Len(rows(rowIndex)) > 0 Then
            fields = Split(rows(rowIndex), Chr$(9))
            If UBound(fields) >= 1 Then
                cacheKey = Replace(CStr(fields(0)), "roomevent_type_", vbNullString, 1, 1, vbBinaryCompare)
                cacheValue = CStr(fields(1))
                If Len(cacheKey) > 0 Then
                    global_008291AC = global_008291AC & Chr$(0) & CStr(Val(cacheKey)) & Chr$(1) & cacheValue & Chr$(2)
                End If
            End If
        End If
    Next rowIndex

BuildFailed:
    Proc_1_8_6C6850 = Empty
End Function

' Original declaration: Private Sub Proc_1_9_6C6DF0
Public Function Proc_1_9_6C6DF0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_1_9_6C6DF0 = Empty
End Function

' Original declaration: Private Sub Proc_1_10_6C7690
Public Function Proc_1_10_6C7690(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_1_10_6C7690 = Empty
End Function

' Original declaration: Private Sub Proc_1_11_6C8D10
Public Function Proc_1_11_6C8D10(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_1_11_6C8D10 = Empty
End Function

' Original declaration: Private Sub Proc_1_12_6C8EF0
Public Function Proc_1_12_6C8EF0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_1_12_6C8EF0 = Empty
End Function

' Original declaration: Private Sub Proc_1_13_6C9820
Public Function Proc_1_13_6C9820(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_1_13_6C9820 = Empty
End Function

' Original declaration: Private  Proc_1_14_6C9DD0(arg_C, arg_10, arg_14, arg_18) '6C9DD0
Public Function Proc_1_14_6C9DD0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_1_14_6C9DD0 = Empty
End Function

' Original declaration: Private Sub Proc_1_15_6CA000
Public Function Proc_1_15_6CA000(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_1_15_6CA000 = Empty
End Function

' Original declaration: Private Sub Proc_1_16_6CCA60
Public Function Proc_1_16_6CCA60(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_1_16_6CCA60 = Empty
End Function

' Original declaration: Private Sub Proc_1_17_6CCDC0
Public Function Proc_1_17_6CCDC0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_1_17_6CCDC0 = Empty
End Function

' Original declaration: Private Sub Proc_1_18_6CE9C0
Public Function Proc_1_18_6CE9C0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_1_18_6CE9C0 = Empty
End Function

' Original declaration: Private Sub Proc_1_19_6CF190
Public Function Proc_1_19_6CF190(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_1_19_6CF190 = Empty
End Function

' Original declaration: Private Sub Proc_1_20_6CF830
Public Function Proc_1_20_6CF830(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_1_20_6CF830 = Empty
End Function

' Original declaration: Private Sub Proc_1_21_6D08C0
Public Function Proc_1_21_6D08C0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_1_21_6D08C0 = Empty
End Function

' Original declaration: Private Sub Proc_1_22_6D0F00
Public Function Proc_1_22_6D0F00(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_1_22_6D0F00 = Empty
End Function

' Original declaration: Private  Proc_1_23_6D1480(arg_C) '6D1480
Public Function Proc_1_23_6D1480(ParamArray args() As Variant) As Variant
    Dim messageText As String
    Dim logChannel As String

    On Error GoTo LogFailed
    If UBound(args) >= 0 Then messageText = CStr(args(0))
    If UBound(args) >= 1 Then logChannel = CStr(args(1))
    Proc_2_0_6D1510 messageText, logChannel, CStr(65280)

LogFailed:
    Proc_1_23_6D1480 = Empty
End Function
