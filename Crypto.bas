Attribute VB_Name = "Crypto"
Option Explicit

' Reconstructed VB6 source shell generated from decompiled output.
' Source reference: /opt/git/AlphaSeries_cracked/DECOMPILED/Crypto.bas
' Decompiled procedure bodies are intentionally not copied until they are understood and made valid VB6.

' Original declaration: Private Sub Proc_3_0_6D2AF0
Public Function Proc_3_0_6D2AF0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_3_0_6D2AF0 = Empty
End Function

' Original declaration: Private  Proc_3_1_6D2E00(arg_C) '6D2E00
Public Function Proc_3_1_6D2E00(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_3_1_6D2E00 = Empty
End Function

' Original declaration: Private Sub Proc_3_2_6D30A0
Public Function Proc_3_2_6D30A0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_3_2_6D30A0 = Empty
End Function

' Original declaration: Private Sub Proc_3_3_6D3240
Public Function Proc_3_3_6D3240(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_3_3_6D3240 = Empty
End Function

' Original declaration: Private Sub Proc_3_4_6D3620
Public Function Proc_3_4_6D3620(ParamArray args() As Variant) As Variant
    Dim encodedValue As String
    Dim firstValue As Long
    Dim secondValue As Long

    On Error GoTo DecodeFailed
    If UBound(args) < 0 Then
        Proc_3_4_6D3620 = 0
        Exit Function
    End If

    encodedValue = CStr(args(0))
    If Len(encodedValue) = 1 Then
        encodedValue = "@" & encodedValue
    End If

    firstValue = Asc(Mid$(encodedValue, 1, 1)) - 64
    secondValue = Asc(Mid$(encodedValue, 2, 1)) - 64
    Proc_3_4_6D3620 = (firstValue * &H40&) + secondValue
    Exit Function

DecodeFailed:
    Proc_3_4_6D3620 = 0
End Function

' Original declaration: Private  Proc_3_5_6D3880(arg_C, arg_10, arg_14, arg_18, arg_1C) '6D3880
Public Function Proc_3_5_6D3880(ParamArray args() As Variant) As Variant
    Dim connectionString As String

    On Error GoTo ConnectFailed
    connectionString = BuildDatabaseConnectionString(args)
    If Len(connectionString) = 0 Then GoTo ConnectFailed

    If ConfigureDatabaseConnection(connectionString) Then
        Proc_3_5_6D3880 = 1
    Else
        Proc_3_5_6D3880 = 0
    End If
    Exit Function

ConnectFailed:
    Proc_3_5_6D3880 = 0
End Function

Private Function BuildDatabaseConnectionString(ByRef args() As Variant) As String
    Dim configText As String
    Dim hostName As String
    Dim portNumber As String
    Dim databaseName As String
    Dim userName As String
    Dim password As String
    Dim driverName As String

    On Error GoTo BuildFailed
    If UBound(args) < 0 Then Exit Function

    configText = CStr(args(0))
    If InStr(1, configText, "mySQL_", vbTextCompare) > 0 Then
        hostName = ReadConfigValue(configText, "mySQL_host", "localhost")
        portNumber = ReadConfigValue(configText, "mySQL_port", "3306")
        databaseName = ReadConfigValue(configText, "mySQL_db", vbNullString)
        userName = ReadConfigValue(configText, "mySQL_username", vbNullString)
        password = ReadConfigValue(configText, "mySQL_password", vbNullString)
        driverName = ReadConfigValue(configText, "mySQL_driver", "MySQL ODBC 3.51 Driver")
    ElseIf UBound(args) >= 5 Then
        hostName = CStr(args(0))
        portNumber = CStr(args(1))
        databaseName = CStr(args(2))
        userName = CStr(args(3))
        password = CStr(args(4))
        driverName = CStr(args(5))
    ElseIf UBound(args) >= 4 Then
        hostName = "localhost"
        portNumber = CStr(args(0))
        databaseName = CStr(args(1))
        userName = CStr(args(2))
        password = CStr(args(3))
        driverName = CStr(args(4))
    End If

    If Len(databaseName) = 0 Or Len(driverName) = 0 Then Exit Function
    BuildDatabaseConnectionString = "Driver={" & driverName & "};Server=" & hostName & ";Port=" & portNumber & ";Database=" & databaseName & ";User=" & userName & ";Password=" & password & ";Option=3;"
    Exit Function

BuildFailed:
    BuildDatabaseConnectionString = vbNullString
End Function

Private Function ReadConfigValue(ByVal configText As String, ByVal keyName As String, ByVal defaultValue As String) As String
    Dim normalizedText As String
    Dim lines() As String
    Dim index As Long
    Dim equalsAt As Long
    Dim currentKey As String

    normalizedText = Replace(configText, vbCrLf, vbLf)
    normalizedText = Replace(normalizedText, vbCr, vbLf)
    lines = Split(normalizedText, vbLf)

    For index = LBound(lines) To UBound(lines)
        equalsAt = InStr(1, lines(index), "=", vbBinaryCompare)
        If equalsAt > 0 Then
            currentKey = Trim$(Left$(lines(index), equalsAt - 1))
            If StrComp(currentKey, keyName, vbTextCompare) = 0 Then
                ReadConfigValue = Trim$(Mid$(lines(index), equalsAt + 1))
                Exit Function
            End If
        End If
    Next index

    ReadConfigValue = defaultValue
End Function
