' Source sheet has to be named 'All Entries'
' It is recommended use the following sorted headers: molecule_name, CHEMBL_ID, mol_nr, glide_gridfile, grid, sheetname, docking_score

' Column descriptions:
' Column 4 (D) - glide_gridfile: Gridsfiles had unpractical names in the original data (e.g. "NAME - prepared" or "glide-grid_NAME"). 
' Column 5 (E) - grid: The following Excel formula was used to simplify the name of the grid
'                =WENN(LINKS(D2;11)="glide-grid_";RECHTS(D2;LÄNGE(D2)-11);WENN(RECHTS(D2;11)=" - prepared";LINKS(D2;LÄNGE(D2)-11);D2))               
' Column 6 (F) - sheetname: The following Excel formula was used to shorten names to the maximinum allowed length of 31. characters.
'                The sheetname column only provides the name and is not transferred like all other data.
'                =LINKS(E2;31)

Public Sub SplitByGrid()
    Dim wsSource As Worksheet
    Dim wsTarget As Worksheet
    Dim headers As Variant
    Dim colIndices As Variant
    Dim lastRow As Long, targetRow As Long
    Dim r As Long, i As Long
    Dim sheetName As String
    
    Set wsSource = ThisWorkbook.Sheets("All Entries")
    lastRow = wsSource.Cells(wsSource.Rows.Count, 1).End(xlUp).Row
    
    ' Define headers (does not include 'sheetname' column as it is only used for sheet naming)
    headers = Array("molecule_name", "CHEMBL_ID", "mol_nr", "glide_gridfile", "grid", "docking_score")
    colIndices = Array(1, 2, 3, 4, 5, 7)
    
    For r = 2 To lastRow
        sheetName = wsSource.Cells(r, 6).Value
        If sheetName <> "" Then
            ' add sheetName if not exists
            If Not SheetExists(sheetName) Then
                ThisWorkbook.Sheets.Add After:=ThisWorkbook.Sheets(ThisWorkbook.Sheets.Count)
                ActiveSheet.name = sheetName
                ' add header to new sheet
                For i = LBound(headers) To UBound(headers)
                    ActiveSheet.Cells(1, i + 1).Value = headers(i)
                Next i
            End If
            
            ' add data
            Set wsTarget = ThisWorkbook.Sheets(sheetName)
            targetRow = wsTarget.Cells(wsTarget.Rows.Count, 1).End(xlUp).Row + 1
            For i = LBound(colIndices) To UBound(colIndices)
                wsTarget.Cells(targetRow, i + 1).Value = wsSource.Cells(r, colIndices(i)).Value
            Next i
        End If
    Next r
    
    MsgBox "Data distribution completed.", vbInformation
End Sub

Private Function SheetExists(name As String) As Boolean
    Dim ws As Worksheet
    For Each ws In ThisWorkbook.Sheets
        If ws.name = name Then
            SheetExists = True
            Exit Function
        End If
    Next
    SheetExists = False
End Function

