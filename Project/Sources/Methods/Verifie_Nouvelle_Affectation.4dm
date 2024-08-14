//%attributes = {}
// verification du format de l'ID_affectation dans competences
ALL RECORDS:C47([LISTE_GARDE:44])
While (Not:C34(End selection:C36([LISTE_GARDE:44])))
	If ([LISTE_GARDE:44]statut:9="SPP")
		$valStatut:="1"
	Else 
		$valStatut:="0"
	End if 
	
	QUERY:C277([AFFECTATIONS:3]; [AFFECTATIONS:3]id_affectation:2=[LISTE_GARDE:44]matricule:2+"-"+$valStatut+"_"+[LISTE_GARDE:44]id_uf:6)
	If (Records in selection:C76([AFFECTATIONS:3])=0)  // si cette affectation n'apparait pas, il faut la créer
		CREATE RECORD:C68([AFFECTATIONS:3])
		[AFFECTATIONS:3]id_affectation:2:=[LISTE_GARDE:44]matricule:2+"-"+$valStatut+"_"+[LISTE_GARDE:44]id_uf:6
		[AFFECTATIONS:3]id_agent:3:=[LISTE_GARDE:44]matricule:2+"-"+$valStatut
		[AFFECTATIONS:3]id_uf:4:=[LISTE_GARDE:44]id_uf:6
		[AFFECTATIONS:3]type:5:="AFFECTATION_OPERATIONNELLE"
		[AFFECTATIONS:3]date_debut:6:=[LISTE_GARDE:44]date_debut:4
		[AFFECTATIONS:3]date_fin:7:=[LISTE_GARDE:44]date_fin:5
		SAVE RECORD:C53([AFFECTATIONS:3])
	End if 
	NEXT RECORD:C51([LISTE_GARDE:44])
End while 
//CHERCHER([LISTE_GARDE]; [LISTE_GARDE]delete=Vrai)
//SUPPRIMER SÉLECTION([LISTE_GARDE])
