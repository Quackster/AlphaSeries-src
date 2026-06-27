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
    Proc_1_19_6CF190 0, 0, 0
    Proc_1_20_6CF830 0, 0, 0
    Proc_1_21_6D08C0 0, 0, 0
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
    Dim rows() As String
    Dim rowIndex As Long
    Dim wrapId As Long
    Dim wrapCount As Long
    Dim accessoryCount As Long
    Dim colorCount As Long
    Dim optionIndex As Long
    Dim wrapPayload As String
    Dim accessoryPayload As String
    Dim colorPayload As String

    On Error GoTo BuildFailed

    global_0082925C = vbCr & CStr(Proc_5_2_6D4690("SELECT id FROM products WHERE sprite LIKE 'present_wrap*" & Chr$(37) & "'", Chr$(13), 0)) & vbCr
    rows = Split(global_0082925C, vbCr)

    For rowIndex = LBound(rows) To UBound(rows)
        wrapId = CLng(Val(CStr(rows(rowIndex))))
        If wrapId <> 0 Then
            wrapCount = wrapCount + 1
            wrapPayload = CStr(Proc_3_0_6D2AF0(wrapId, Empty, wrapPayload))
        End If
    Next rowIndex

    accessoryCount = CLng(Val(CStr(Proc_10_0_809570("com.client.catalog.gifts.wrap.count.accessories", wrapCount, 0))))
    For optionIndex = 1 To accessoryCount
        accessoryPayload = CStr(Proc_3_0_6D2AF0(optionIndex, Empty, accessoryPayload))
    Next optionIndex

    colorCount = CLng(Val(CStr(Proc_10_0_809570("com.client.catalog.gifts.wrap.count.colors", 0, 0))))
    For optionIndex = 1 To colorCount
        colorPayload = CStr(Proc_3_0_6D2AF0(optionIndex, Empty, colorPayload))
    Next optionIndex

    global_00829260 = CStr(Proc_3_0_6D2AF0(accessoryCount, Empty, vbNullString)) & accessoryPayload
    global_00829260 = CStr(Proc_3_0_6D2AF0(wrapCount, Empty, global_00829260)) & wrapPayload
    global_00829260 = CStr(Proc_3_0_6D2AF0(colorCount, Empty, global_00829260)) & colorPayload

BuildFailed:
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
    Dim importanceLevel As Long
    Dim rows() As String
    Dim fields() As String
    Dim rowIndex As Long
    Dim groupPayload As String
    Dim groupCount As Long

    On Error GoTo BuildFailed

    global_00829204 = vbNullString
    For importanceLevel = 1 To 2
        groupPayload = vbNullString
        groupCount = 0
        rows = Split(CStr(Proc_5_2_6D4690("SELECT id,name FROM faq WHERE is_important='" & CStr(importanceLevel) & "' ORDER BY id DESC LIMIT 1", 0, 0)), Chr$(13))

        For rowIndex = LBound(rows) To UBound(rows)
            If Len(rows(rowIndex)) > 0 Then
                fields = Split(rows(rowIndex), Chr$(9))
                If UBound(fields) >= 1 Then
                    groupPayload = CStr(Proc_3_0_6D2AF0(CLng(Val(CStr(fields(0)))), Empty, groupPayload)) & CStr(fields(1)) & Chr$(2)
                    groupCount = groupCount + 1
                End If
            End If
        Next rowIndex

        global_00829204 = global_00829204 & CStr(Proc_3_0_6D2AF0(groupCount, Empty, vbNullString)) & groupPayload
    Next importanceLevel

    global_00829204 = CStr(Proc_3_0_6D2AF0(2, Empty, vbNullString)) & global_00829204

BuildFailed:
    Proc_1_19_6CF190 = Empty
End Function

' Original declaration: Private Sub Proc_1_20_6CF830
Public Function Proc_1_20_6CF830(ParamArray args() As Variant) As Variant
    Dim maxCategoryId As Long
    Dim categoryRows() As String
    Dim categoryFields() As String
    Dim faqRows() As String
    Dim faqFields() As String
    Dim categoryIndex As Long
    Dim faqIndex As Long
    Dim categoryId As Long
    Dim categoryCount As Long
    Dim faqCount As Long
    Dim categoryPayload As String
    Dim faqPayload As String

    On Error GoTo BuildFailed

    maxCategoryId = CLng(Val(CStr(Proc_5_2_6D4690("SELECT MAX(id) FROM faq_categories", 0, 0))))
    If maxCategoryId < 0 Then maxCategoryId = 0
    ReDim global_0082920C(0 To maxCategoryId)

    global_00829208 = vbNullString
    categoryRows = Split(CStr(Proc_5_2_6D4690("SELECT id,name FROM faq_categories", 0, 0)), Chr$(13))
    For categoryIndex = LBound(categoryRows) To UBound(categoryRows)
        If Len(categoryRows(categoryIndex)) > 0 Then
            categoryFields = Split(categoryRows(categoryIndex), Chr$(9))
            If UBound(categoryFields) >= 1 Then
                categoryId = CLng(Val(CStr(categoryFields(0))))
                If categoryId >= LBound(global_0082920C) And categoryId <= UBound(global_0082920C) Then
                    faqPayload = vbNullString
                    faqCount = 0
                    faqRows = Split(CStr(Proc_5_2_6D4690("SELECT id,name FROM faq WHERE id_category='" & CStr(categoryId) & "'", 0, 0)), Chr$(13))
                    For faqIndex = LBound(faqRows) To UBound(faqRows)
                        If Len(faqRows(faqIndex)) > 0 Then
                            faqFields = Split(faqRows(faqIndex), Chr$(9))
                            If UBound(faqFields) >= 1 Then
                                faqPayload = CStr(Proc_3_0_6D2AF0(CLng(Val(CStr(faqFields(0)))), Empty, faqPayload)) & CStr(faqFields(1)) & Chr$(2)
                                faqCount = faqCount + 1
                            End If
                        End If
                    Next faqIndex

                    global_0082920C(categoryId) = CStr(Proc_3_0_6D2AF0(faqCount, Empty, vbNullString)) & faqPayload
                    categoryPayload = categoryPayload & CStr(Proc_3_0_6D2AF0(categoryId, Empty, vbNullString)) & CStr(categoryFields(1)) & Chr$(2)
                    categoryCount = categoryCount + 1
                End If
            End If
        End If
    Next categoryIndex

    global_00829208 = CStr(Proc_3_0_6D2AF0(categoryCount, Empty, vbNullString)) & categoryPayload

BuildFailed:
    Proc_1_20_6CF830 = Empty
End Function

' Original declaration: Private Sub Proc_1_21_6D08C0
Public Function Proc_1_21_6D08C0(ParamArray args() As Variant) As Variant
    Dim maxFaqId As Long
    Dim rows() As String
    Dim fields() As String
    Dim rowIndex As Long
    Dim faqId As Long
    Dim descriptionText As String

    On Error GoTo BuildFailed

    maxFaqId = CLng(Val(CStr(Proc_5_2_6D4690("SELECT MAX(id) FROM faq", 0, 0))))
    If maxFaqId < 0 Then maxFaqId = 0
    ReDim global_00829210(0 To maxFaqId)

    rows = Split(CStr(Proc_5_2_6D4690("SELECT id,description FROM faq", 0, 0)), Chr$(13))
    For rowIndex = LBound(rows) To UBound(rows)
        If Len(rows(rowIndex)) > 0 Then
            fields = Split(rows(rowIndex), Chr$(9))
            If UBound(fields) >= 1 Then
                faqId = CLng(Val(CStr(fields(0))))
                If faqId >= LBound(global_00829210) And faqId <= UBound(global_00829210) Then
                    descriptionText = Replace(CStr(fields(1)), Chr$(10), Chr$(13), 1, -1, vbBinaryCompare)
                    global_00829210(faqId) = CStr(Proc_3_0_6D2AF0(faqId, Empty, vbNullString)) & descriptionText & Chr$(2)
                End If
            End If
        End If
    Next rowIndex

BuildFailed:
    Proc_1_21_6D08C0 = Empty
End Function

' Original declaration: Private Sub Proc_1_22_6D0F00
Public Function Proc_1_22_6D0F00(ParamArray args() As Variant) As Variant
    Dim maxId As Long
    Dim rows() As String
    Dim fields() As String
    Dim rowIndex As Long
    Dim visitRoomId As Long
    Dim assetPath As String

    On Error GoTo BuildFailed

    maxId = CLng(Val(CStr(Proc_5_2_6D4690("SELECT MAX(id) FROM advertisement_visitrooms", 0, 0))))
    If maxId < 0 Then maxId = 0
    ReDim global_008291D4(0 To maxId)
    global_008291D8 = 0

    assetPath = CStr(Proc_10_0_809570("com.server.socket.game.advertisement.visitrooms.path", vbNullString, 0))
    rows = Split(CStr(Proc_5_2_6D4690("SELECT id,address FROM advertisement_visitrooms", 0, 0)), Chr$(13))
    For rowIndex = LBound(rows) To UBound(rows)
        If Len(rows(rowIndex)) > 0 Then
            fields = Split(rows(rowIndex), Chr$(9))
            If UBound(fields) >= 1 Then
                visitRoomId = CLng(Val(CStr(fields(0))))
                If visitRoomId >= LBound(global_008291D4) And visitRoomId <= UBound(global_008291D4) Then
                    global_008291D8 = global_008291D8 + 1
                    global_008291D4(visitRoomId) = assetPath & CStr(visitRoomId) & Chr$(2) & CStr(fields(1)) & Chr$(2)
                End If
            End If
        End If
    Next rowIndex

BuildFailed:
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
