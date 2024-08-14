//%attributes = {}
ALL RECORDS:C47([LISTE_GARDE:44])
APPLY TO SELECTION:C70([LISTE_GARDE:44]; [LISTE_GARDE:44]delete:7:=False:C215)

// verification du format de l'ID_affectation dans competences
ALL RECORDS:C47([LISTE_GARDE:44])
While (Not:C34(End selection:C36([LISTE_GARDE:44])))
	If (Not:C34(Match regex:C1019("[0-9]+\\-[0-9]+\\_[a-zA-Z0-9]+"; [LISTE_GARDE:44]id_affectation:2)))
		[LISTE_GARDE:44]delete:7:=True:C214
		SAVE RECORD:C53([LISTE_GARDE:44])
	End if 
	
	QUERY:C277([AFFECTATIONS:3]; [AFFECTATIONS:3]id_affectation:2=[LISTE_GARDE:44]id_affectation:2)
	If (Records in selection:C76([AFFECTATIONS:3])=0)
		[LISTE_GARDE:44]delete:7:=True:C214
		SAVE RECORD:C53([LISTE_GARDE:44])
	End if 
	NEXT RECORD:C51([LISTE_GARDE:44])
End while 
QUERY:C277([LISTE_GARDE:44]; [LISTE_GARDE:44]delete:7=True:C214)
DELETE SELECTION:C66([LISTE_GARDE:44])
