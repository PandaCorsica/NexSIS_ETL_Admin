//%attributes = {}
ALL RECORDS:C47([NON_ACTIFS:141])

While (Not:C34(End selection:C36([NON_ACTIFS:141])))
	Case of 
		: ([NON_ACTIFS:141]Cle_Categorie:6=0)
			$idAgent:=[NON_ACTIFS:141]Matricule:2+"-0"
		: ([NON_ACTIFS:141]Cle_Categorie:6=2)
			$idAgent:=[NON_ACTIFS:141]Matricule:2+"-1"
		Else 
			$idAgent:=[NON_ACTIFS:141]Matricule:2+"-2"
	End case 
	QUERY:C277([AFFECTATIONS:3]; [AFFECTATIONS:3]id_agent:3=$idAgent)
	If (Records in selection:C76([AFFECTATIONS:3])#0)
		APPLY TO SELECTION:C70([AFFECTATIONS:3]; [AFFECTATIONS:3]date_fin:7:=[NON_ACTIFS:141]Radiation:5)
	End if 
	NEXT RECORD:C51([NON_ACTIFS:141])
End while 


// verification des affectations en erreur
QUERY BY FORMULA:C48([AFFECTATIONS:3]; Substring:C12([AFFECTATIONS:3]date_debut:6; 1; 4)="0000")
APPLY TO SELECTION:C70([AFFECTATIONS:3]; [AFFECTATIONS:3]date_debut:6:="2020-01-01T00:00:00+01:00")

QUERY BY FORMULA:C48([AFFECTATIONS:3]; Substring:C12([AFFECTATIONS:3]date_debut:6; 1; 4)="1900")
APPLY TO SELECTION:C70([AFFECTATIONS:3]; [AFFECTATIONS:3]date_debut:6:="2020-01-01T00:00:00+01:00")
