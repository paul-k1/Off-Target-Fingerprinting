Private activeTool As Boolean

Private Sub Worksheet_Activate()
    activeTool = True
End Sub

Private Sub Worksheet_SelectionChange(ByVal Target As Range)
    ' Defines the range in the table where the tool should work
    Const START_COL As Long = 4     ' Column D
    Const END_COL As Long = 139     ' Column EI
    Const START_ROW As Long = 12
    Const END_ROW As Long = 1570

    Dim col As Long, checkCol As Long
    Dim infoText As String
    Dim header(1 To 4) As String
    Dim i As Long

    ' Turn on the tool with click on column "C"
    If Target.Cells.CountLarge = 1 And Target.Column = 3 Then
        activeTool = Not activeTool
        MsgBox "Table Orientation Tool: " & IIf(activeTool, "On", "Off"), vbInformation
        Exit Sub
    End If

    If Not activeTool Then Exit Sub

    ' Check valid range
    If Target.Cells.CountLarge > 1 Then Exit Sub
    If Target.Row < START_ROW Or Target.Row > END_ROW Then Exit Sub
    If Target.Column < START_COL Or Target.Column > END_COL Then Exit Sub

    ' For connected cells we need the leftmost cell (the others are empty) 
    col = Target.Column
    checkCol = col

    Do While checkCol >= START_COL
        For i = 1 To 4
            header(i) = Me.Cells(2 + i, checkCol).Text
        Next i
        If Trim(Join(header, "")) <> "" Then Exit Do
        checkCol = checkCol - 1
    Loop

    ' Exit if all empty
    If Trim(Join(header, "")) = "" Then Exit Sub

    ' Display info
    infoText = "Cell: " & Target.Address(False, False) & vbCrLf & _
               header(1) & vbCrLf & header(2) & vbCrLf & header(3) & vbCrLf & header(4)

    MsgBox infoText, vbInformation, "Column Information"
End Sub
