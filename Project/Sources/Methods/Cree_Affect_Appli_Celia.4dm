//%attributes = {}
// cette méthode met des affectations applicatives sur toutes les UF
// droits pour Celia, Laure, Christian, Alexandra et JJ
QUERY:C277([AGENTS:2]; [AGENTS:2]matricule:5="4099"; *)
QUERY:C277([AGENTS:2]; [AGENTS:2]statut:6="PATS")  //SPP ou SPV ou PATS
$idAgent:=[AGENTS:2]id_agent:3

ALL RECORDS:C47([UF:5])
While (Not:C34(End selection:C36([UF:5])))
	QUERY:C277([AFFECTATIONS:3]; [AFFECTATIONS:3]id_agent:3=$idAgent; *)
	QUERY:C277([AFFECTATIONS:3]; [AFFECTATIONS:3]id_uf:4=[UF:5]id_uf:5; *)
	QUERY:C277([AFFECTATIONS:3]; [AFFECTATIONS:3]type:5="AFFECTATION_APPLICATIVE")
	If (Records in selection:C76([AFFECTATIONS:3])=0)
		CREATE RECORD:C68([AFFECTATIONS:3])
		[AFFECTATIONS:3]id_affectation:2:=$idAgent+"_"+"sis"
		[AFFECTATIONS:3]id_agent:3:=$idAgent
		[AFFECTATIONS:3]id_uf:4:=[UF:5]id_uf:5
		[AFFECTATIONS:3]type:5:="AFFECTATION_APPLICATIVE"
		[AFFECTATIONS:3]date_debut:6:="2024-01-01T00:00:00+01:00"
		[AFFECTATIONS:3]date_fin:7:=""
		SAVE RECORD:C53([AFFECTATIONS:3])
	End if 
	NEXT RECORD:C51([UF:5])
End while 

