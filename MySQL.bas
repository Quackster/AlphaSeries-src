Attribute VB_Name = "MySQL"
Option Explicit

Public DatabaseConnection As Object

' Reconstructed VB6 source shell generated from decompiled output.
' Source reference: /opt/git/AlphaSeries_cracked/DECOMPILED/MySQL.bas
' Decompiled procedure bodies are intentionally not copied until they are understood and made valid VB6.

' Original declaration: Private Sub Proc_5_0_6D3CD0
Public Function Proc_5_0_6D3CD0(ParamArray args() As Variant) As Variant
    On Error GoTo QueryFailed
    ExecuteSql BuildSqlFromArgs(args)
    Proc_5_0_6D3CD0 = Empty
    Exit Function

QueryFailed:
    Proc_5_0_6D3CD0 = Empty
End Function

' Original declaration: Private Sub Proc_5_1_6D4110
Public Function Proc_5_1_6D4110(ParamArray args() As Variant) As Variant
    On Error Resume Next
    ExecuteSql BuildSqlFromArgs(args)
    Proc_5_1_6D4110 = Empty
End Function

' Original declaration: Private Sub Proc_5_2_6D4690
Public Function Proc_5_2_6D4690(ParamArray args() As Variant) As Variant
    On Error GoTo ReadFailed
    Proc_5_2_6D4690 = ReadSqlRows(BuildSqlFromArgs(args))
    Exit Function

ReadFailed:
    Proc_5_2_6D4690 = vbNullString
End Function

' Original declaration: Private Sub Proc_5_3_6D4CF0
Public Function Proc_5_3_6D4CF0(ParamArray args() As Variant) As Variant
    On Error Resume Next
    Proc_5_3_6D4CF0 = ReadSqlRows(BuildSqlFromArgs(args))
End Function

' Original declaration: Private Sub Proc_5_4_6D55E0
Public Function Proc_5_4_6D55E0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_5_4_6D55E0 = Empty
End Function

' Original declaration: Private Sub Proc_5_5_6D64D0
Public Function Proc_5_5_6D64D0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_5_5_6D64D0 = Empty
End Function

' Original declaration: Private Sub Proc_5_6_6D7090
Public Function Proc_5_6_6D7090(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_5_6_6D7090 = Empty
End Function

Public Function ConfigureDatabaseConnection(ByVal connectionString As String) As Boolean
    On Error GoTo ConfigureFailed

    Set DatabaseConnection = CreateObject("ADODB.Connection")
    DatabaseConnection.ConnectionString = connectionString
    DatabaseConnection.Open
    ConfigureDatabaseConnection = True
    Exit Function

ConfigureFailed:
    Set DatabaseConnection = Nothing
    ConfigureDatabaseConnection = False
End Function

Private Sub ExecuteSql(ByVal sqlText As String)
    If Len(sqlText) = 0 Then Exit Sub
    If DatabaseConnection Is Nothing Then Err.Raise 91
    DatabaseConnection.Execute sqlText
End Sub

Private Function ReadSqlRows(ByVal sqlText As String) As String
    Dim recordset As Object
    Dim rowText As String
    Dim fieldIndex As Long

    If Len(sqlText) = 0 Then Exit Function
    If DatabaseConnection Is Nothing Then Err.Raise 91

    Set recordset = CreateObject("ADODB.Recordset")
    recordset.Open sqlText, DatabaseConnection

    Do Until recordset.EOF
        If Len(rowText) > 0 Then rowText = rowText & Chr$(13)
        For fieldIndex = 0 To recordset.Fields.Count - 1
            If fieldIndex > 0 Then rowText = rowText & Chr$(9)
            If Not IsNull(recordset.Fields(fieldIndex).Value) Then
                rowText = rowText & CStr(recordset.Fields(fieldIndex).Value)
            End If
        Next fieldIndex
        recordset.MoveNext
    Loop

    recordset.Close
    ReadSqlRows = Replace(rowText, "\n", Chr$(10))
End Function

Private Function BuildSqlFromArgs(ByRef args() As Variant) As String
    Dim index As Long
    Dim part As String

    On Error GoTo BuildFailed
    For index = LBound(args) To UBound(args)
        If Not IsEmpty(args(index)) Then
            If Not IsNull(args(index)) Then
                part = CStr(args(index))
                If Not IsIgnorableSqlArg(part) Then
                    BuildSqlFromArgs = BuildSqlFromArgs & part
                End If
            End If
        End If
    Next index
    BuildSqlFromArgs = Replace(BuildSqlFromArgs, "\'", "/'")
    Exit Function

BuildFailed:
    BuildSqlFromArgs = vbNullString
End Function

Private Function IsIgnorableSqlArg(ByVal value As String) As Boolean
    IsIgnorableSqlArg = (Len(value) = 0 Or value = "0" Or value = "-1")
End Function
