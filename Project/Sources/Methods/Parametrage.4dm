//%attributes = {}
ALL RECORDS:C47([PARAMETRES:27])
If (Records in selection:C76([PARAMETRES:27])=0)
	CREATE RECORD:C68([PARAMETRES:27])
	[PARAMETRES:27]baseLogin:3:=""
	[PARAMETRES:27]baseName:2:=""
	[PARAMETRES:27]basePass:4:=""
	SAVE RECORD:C53([PARAMETRES:27])
End if 
$fen:=Open form window:C675([PARAMETRES:27]; "Saisie")
DIALOG:C40([PARAMETRES:27]; "Saisie")
CLOSE WINDOW:C154($fen)
