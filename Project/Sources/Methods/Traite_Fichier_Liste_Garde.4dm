//%attributes = {}
$doc:=Create document:C266(Get 4D folder:C485(Dossier base:K5:14)+"LISTE_GARDE.CSV"; ".csv")

If (OK=1)
	SEND PACKET:C103($doc; "id_affectation"+";")
	SEND PACKET:C103($doc; "etat_disponibilite"+";")
	SEND PACKET:C103($doc; "datetime_debut"+";")
	SEND PACKET:C103($doc; "datetime_fin"+";")
	SEND PACKET:C103($doc; "commentaire"+Char:C90(Retour à la ligne:K15:40))
	
	ALL RECORDS:C47([LISTE_GARDE:44])
	While (Not:C34(End selection:C36([LISTE_GARDE:44])))
		SEND PACKET:C103($doc; [LISTE_GARDE:44]id_affectation:2+";")
		SEND PACKET:C103($doc; [LISTE_GARDE:44]etat_disponibilite:3+";")
		SEND PACKET:C103($doc; [LISTE_GARDE:44]datetime_debut:4+";")
		SEND PACKET:C103($doc; [LISTE_GARDE:44]datetime_fin:5+";")
		SEND PACKET:C103($doc; [LISTE_GARDE:44]commentaire:6+Char:C90(Retour à la ligne:K15:40))
		
		NEXT RECORD:C51([LISTE_GARDE:44])
	End while 
	
	
	CLOSE DOCUMENT:C267($doc)
	
	// et on régénère le fichier affectations
	$doc2:=Create document:C266(Get 4D folder:C485(Dossier base:K5:14)+"AFFECTATIONS.CSV"; ".csv")
	If (OK=1)
		SEND PACKET:C103($doc2; "id_affectation"+";")
		SEND PACKET:C103($doc2; "id_agent"+";")
		SEND PACKET:C103($doc2; "id_uf"+";")
		SEND PACKET:C103($doc2; "type"+Char:C90(Retour à la ligne:K15:40))
		
		ALL RECORDS:C47([AFFECTATIONS:3])
		While (Not:C34(End selection:C36([AFFECTATIONS:3])))
			SEND PACKET:C103($doc2; [AFFECTATIONS:3]id_affectation:2+";")
			SEND PACKET:C103($doc2; [AFFECTATIONS:3]id_agent:3+";")
			SEND PACKET:C103($doc2; [AFFECTATIONS:3]id_uf:4+";")
			SEND PACKET:C103($doc2; [AFFECTATIONS:3]type:5+Char:C90(Retour à la ligne:K15:40))
			
			NEXT RECORD:C51([AFFECTATIONS:3])
		End while 
		
		CLOSE DOCUMENT:C267($doc2)
		
	End if 
	
	// et on régénère le fichier des competences
	$doc3:=Create document:C266(Get 4D folder:C485(Dossier base:K5:14)+"COMPETENCES.CSV"; ".csv")
	If (OK=1)
		SEND PACKET:C103($doc3; "id_affectation"+";")
		SEND PACKET:C103($doc3; "competence"+Char:C90(Retour à la ligne:K15:40))
		
		ALL RECORDS:C47([COMPETENCES:4])
		While (Not:C34(End selection:C36([COMPETENCES:4])))
			SEND PACKET:C103($doc3; [COMPETENCES:4]id_affectation:2+";")
			SEND PACKET:C103($doc3; [COMPETENCES:4]competence:3+Char:C90(Retour à la ligne:K15:40))
			
			NEXT RECORD:C51([COMPETENCES:4])
		End while 
		CLOSE DOCUMENT:C267($doc3)
		
	End if 
	
	
End if 

