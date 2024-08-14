//%attributes = {}
// ----------------------------------------------------
// Method : InitView
// Description
// Initialization of document with one sheet
//
// Parameters
// $1 (C_TEXT): name of the sheet
// $2 (C_LONGINT): row count of the sheet
// $0 (C_OBJECT): document initialized
// ----------------------------------------------------
C_TEXT:C284($1; $sheetName)
C_LONGINT:C283($2; $numberRow)
C_OBJECT:C1216($sheet)
C_OBJECT:C1216($0; $doc)

$doc:=New object:C1471
$sheetName:=$1
$numberRow:=$2

// version [mandatory]
$doc.version:=1

// creation date [mandatory]
$doc.dateCreation:=Timestamp:C1445

// modification date [mandatory]
$doc.dateModified:=Timestamp:C1445

// meta [what you want]
$doc.meta:=New object:C1471("comment"; "Fichier synthese")

// spreadJS [mandatory]
$doc.spreadJS:=New object:C1471

// version [mandatory]
$doc.spreadJS.version:="11.0.0"

// multisheet = false
$doc.spreadJS.tabStripVisible:=False:C215

// workBook
$doc.spreadJS.sheets:=New object:C1471

$doc.spreadJS.sheets[$sheetName]:=New object:C1471
$sheet:=$doc.spreadJS.sheets[$sheetName]

//********************************************
//
// Sheet name
//
$sheet.name:=$sheetName

//********************************************
//
// number of row and columns
//
$sheet.rowCount:=$numberRow
$sheet.columnCount:=7
$sheet.theme:="Office"

$sheet.rowHeaderVisible:=True:C214
$sheet.colHeaderVisible:=False:C215


// data
$sheet.data:=New object:C1471("dataTable"; New object:C1471)

$0:=$doc





