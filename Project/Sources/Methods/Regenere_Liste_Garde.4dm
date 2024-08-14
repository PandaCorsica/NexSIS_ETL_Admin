//%attributes = {}
$cheminDossier:=$1
$doc:=Create document:C266($cheminDossier+"LISTE_GARDE.CSV"; ".csv")

If (OK=1)
	SEND PACKET:C103($doc; "matricule"+";")
	SEND PACKET:C103($doc; "etat_disponibilite"+";")
	SEND PACKET:C103($doc; "etat_situation"+";")
	SEND PACKET:C103($doc; "date_debut"+";")
	SEND PACKET:C103($doc; "date_fin"+";")
	SEND PACKET:C103($doc; "id_uf"+";")
	SEND PACKET:C103($doc; "statut_rh"+";")
	SEND PACKET:C103($doc; "position_administrative"+Char:C90(Retour à la ligne:K15:40))
	
	ALL RECORDS:C47([LISTE_GARDE:44])
	While (Not:C34(End selection:C36([LISTE_GARDE:44])))
		If ([LISTE_GARDE:44]date_debut:4#[LISTE_GARDE:44]date_fin:5)
			SEND PACKET:C103($doc; [LISTE_GARDE:44]matricule:2+";")
			SEND PACKET:C103($doc; [LISTE_GARDE:44]etat_disponibilite:3+";")
			SEND PACKET:C103($doc; [LISTE_GARDE:44]etat_situation:8+";")
			SEND PACKET:C103($doc; [LISTE_GARDE:44]date_debut:4+";")
			SEND PACKET:C103($doc; [LISTE_GARDE:44]date_fin:5+";")
			SEND PACKET:C103($doc; [LISTE_GARDE:44]id_uf:6+";")
			SEND PACKET:C103($doc; [LISTE_GARDE:44]statut:9+";")
			SEND PACKET:C103($doc; [LISTE_GARDE:44]position_administrative:10+Char:C90(Retour à la ligne:K15:40))
		End if 
		NEXT RECORD:C51([LISTE_GARDE:44])
	End while 
	
	
	CLOSE DOCUMENT:C267($doc)
	
End if 
