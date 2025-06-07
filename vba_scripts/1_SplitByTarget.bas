' Source sheet must be named "All Entries"
' It is recommended to sort the columns like the headers array below before running

Public Sub SplitByTarget()
    Dim i As Long
    Dim sheetName As String
    Dim ws As Worksheet
    Dim headers As Variant
    Dim col As Long

    ' Create target sheets
    For i = 1 To 88
        sheetName = "Target " & i
        If Not SheetExists(sheetName) Then
            ThisWorkbook.Sheets.Add After:=ThisWorkbook.Sheets(ThisWorkbook.Sheets.Count)
            ActiveSheet.Name = sheetName
        End If
    Next i

    ' Define headers
    headers = Array( _
        "CHEMBL_ID", "target_nr", "UNIPROT_ID", "pref_name", "gene_symbol", "target_type", _
        "PDB_ID", "resolution", "Method", "Mutations", "r_free", "r_work", "r_observed", _
        "Release Date", "title_ligand_info", "title_says_agonist_activator", "title_says_antagonist_inhibitor", _
        "title_says_complex_complexed", "comments" _
    )

    ' Add header to previously created target sheets
    For Each ws In ThisWorkbook.Sheets
        If Left(ws.Name, 6) = "Target" Then
            For col = LBound(headers) To UBound(headers)
                ws.Cells(1, col + 1).Value = headers(col)
            Next col
        End If
    Next ws

    ' Copy data from "All Entries" 
    Dim wsSource As Worksheet
    Dim wsTarget As Worksheet
    Dim lastRow As Long
    Dim targetRow As Long
    Dim targetNumber As Long
    Dim r As Long

    On Error Resume Next
    Set wsSource = ThisWorkbook.Sheets("All Entries")
    On Error GoTo 0

    If wsSource Is Nothing Then
        MsgBox "The Sheet 'All Entries' does not exist.", vbCritical
        Exit Sub
    End If

    lastRow = wsSource.Cells(wsSource.Rows.Count, 2).End(xlUp).Row

    For r = 2 To lastRow
        If IsNumeric(wsSource.Cells(r, 2).Value) Then
            targetNumber = wsSource.Cells(r, 2).Value
            sheetName = "Target " & targetNumber

            On Error Resume Next
            Set wsTarget = ThisWorkbook.Sheets(sheetName)
            On Error GoTo 0

            If Not wsTarget Is Nothing Then
                targetRow = wsTarget.Cells(wsTarget.Rows.Count, 1).End(xlUp).Row + 1
                wsSource.Rows(r).Copy Destination:=wsTarget.Rows(targetRow)
            End If

            Set wsTarget = Nothing
        End If
    Next r

    MsgBox "Finished! All data has been transferred to the corresponding sheets.", vbInformation
End Sub

Private Function SheetExists(sheetName As String) As Boolean
    Dim ws As Worksheet
    For Each ws In ThisWorkbook.Sheets
        If ws.Name = sheetName Then
            SheetExists = True
            Exit Function
        End If
    Next ws
    SheetExists = False
End Function
