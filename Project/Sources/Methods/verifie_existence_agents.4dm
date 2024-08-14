//%attributes = {}
$doc:=$1
$erreur:=False:C215
ALL RECORDS:C47([AFFECTATIONS:3])
While (Not:C34(End selection:C36([AFFECTATIONS:3])))
	QUERY:C277([AGENTS:2]; [AGENTS:2]id_agent:3=[AFFECTATIONS:3]id_agent:3)
	If (Records in selection:C76([AGENTS:2])=0)
		[AFFECTATIONS:3]delete:8:=True:C214
		SEND PACKET:C103($doc; "Affectation supprimée :"+[AFFECTATIONS:3]id_affectation:2+Char:C90(Retour à la ligne:K15:40))
		$erreur:=True:C214
	Else 
		[AFFECTATIONS:3]delete:8:=False:C215
	End if 
	SAVE RECORD:C53([AFFECTATIONS:3])
	NEXT RECORD:C51([AFFECTATIONS:3])
End while 

QUERY:C277([AFFECTATIONS:3]; [AFFECTATIONS:3]delete:8=True:C214)
DELETE SELECTION:C66([AFFECTATIONS:3])

$0:=$erreur
