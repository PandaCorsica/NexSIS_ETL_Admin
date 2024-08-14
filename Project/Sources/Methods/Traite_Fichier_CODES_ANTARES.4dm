//%attributes = {}
$doc:=Create document:C266(Get 4D folder:C485(Dossier base:K5:14)+"CODES_ANTARES_DEPT.CSV"; ".csv")
If (OK=1)
	SEND PACKET:C103($doc; "id_sis"+";")
	SEND PACKET:C103($doc; "id_reseau"+";")
	SEND PACKET:C103($doc; "code_antares"+";")
	SEND PACKET:C103($doc; "code_etat_situation"+";")
	SEND PACKET:C103($doc; "signification"+";")
	SEND PACKET:C103($doc; "libelle_long"+";")
	SEND PACKET:C103($doc; "libelle_court"+";")
	SEND PACKET:C103($doc; "type"+";")
	SEND PACKET:C103($doc; "action_operateur"+";")
	SEND PACKET:C103($doc; "niveau_gravite"+";")
	SEND PACKET:C103($doc; "disponible"+Char:C90(Retour à la ligne:K15:40))
	
	
	ALL RECORDS:C47([CODES_ANTARES_DEPT:11])
	While (Not:C34(End selection:C36([CODES_ANTARES_DEPT:11])))
		SEND PACKET:C103($doc; [CODES_ANTARES_DEPT:11]id_sis:2+";")
		SEND PACKET:C103($doc; [CODES_ANTARES_DEPT:11]id_reseau:3+";")
		SEND PACKET:C103($doc; [CODES_ANTARES_DEPT:11]code_antares:4+";")
		SEND PACKET:C103($doc; [CODES_ANTARES_DEPT:11]code_etat_situation:5+";")
		SEND PACKET:C103($doc; [CODES_ANTARES_DEPT:11]signification:6+";")
		SEND PACKET:C103($doc; [CODES_ANTARES_DEPT:11]libelle_long:7+";")
		SEND PACKET:C103($doc; [CODES_ANTARES_DEPT:11]libelle_court:8+";")
		SEND PACKET:C103($doc; [CODES_ANTARES_DEPT:11]type:9+";")
		SEND PACKET:C103($doc; [CODES_ANTARES_DEPT:11]action_operateur:10+";")
		SEND PACKET:C103($doc; [CODES_ANTARES_DEPT:11]niveau_gravite:11+";")
		SEND PACKET:C103($doc; [CODES_ANTARES_DEPT:11]disponible:12+Char:C90(Retour à la ligne:K15:40))
		
		
		NEXT RECORD:C51([CODES_ANTARES_DEPT:11])
	End while 
	CLOSE DOCUMENT:C267($doc)
End if 
