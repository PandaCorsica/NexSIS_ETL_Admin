//%attributes = {}
ALL RECORDS:C47([INDIVIDUS:1])
$doc:=Create document:C266(Get 4D folder:C485(Dossier base:K5:14)+"comptesApp.txt"; "txt")
SEND PACKET:C103($doc; "Nom"+Char:C90(Tabulation:K15:37))
SEND PACKET:C103($doc; "Prenom"+Char:C90(Tabulation:K15:37))
SEND PACKET:C103($doc; "Matricule"+Char:C90(Tabulation:K15:37))
SEND PACKET:C103($doc; "Statut"+Char:C90(Tabulation:K15:37))
SEND PACKET:C103($doc; "Grade"+Char:C90(Tabulation:K15:37))
SEND PACKET:C103($doc; "Affectation"+Char:C90(Tabulation:K15:37))
SEND PACKET:C103($doc; "Mail"+Char:C90(Retour à la ligne:K15:40))
While (Not:C34(End selection:C36([INDIVIDUS:1])))
	If ([INDIVIDUS:1]nom_patronymique:4="PERALDI")
		TRACE:C157
	End if 
	QUERY:C277([IMPORT_INDIVIDUS:17]; [IMPORT_INDIVIDUS:17]Matricule:2=[INDIVIDUS:1]Matricule:10)
	If (([IMPORT_INDIVIDUS:17]mail1:27#"") & ([IMPORT_INDIVIDUS:17]mail1:27#Null:C1517)) | (([IMPORT_INDIVIDUS:17]mail2:28#"") & ([IMPORT_INDIVIDUS:17]mail2:28#Null:C1517))
		QUERY:C277([AGENTS:2]; [AGENTS:2]id_individu:2=[INDIVIDUS:1]id_individu:2)
		ORDER BY:C49([AGENTS:2]; [AGENTS:2]statut:6; <)
		SEND PACKET:C103($doc; [INDIVIDUS:1]nom_usuel:3+Char:C90(Tabulation:K15:37))
		SEND PACKET:C103($doc; [INDIVIDUS:1]prenom:5+Char:C90(Tabulation:K15:37))
		SEND PACKET:C103($doc; [AGENTS:2]matricule:5+Char:C90(Tabulation:K15:37))
		SEND PACKET:C103($doc; [AGENTS:2]statut:6+Char:C90(Tabulation:K15:37))
		SEND PACKET:C103($doc; [AGENTS:2]grade:7+Char:C90(Tabulation:K15:37))
		QUERY:C277([AFFECTATIONS:3]; [AFFECTATIONS:3]id_agent:3=[AGENTS:2]id_agent:3; *)
		QUERY:C277([AFFECTATIONS:3]; [AFFECTATIONS:3]type:5="AFFECTATION_ADMINISTRATIVE")
		SEND PACKET:C103($doc; [AFFECTATIONS:3]id_uf:4+Char:C90(Tabulation:K15:37))
		If (([IMPORT_INDIVIDUS:17]mail2:28="") | ([IMPORT_INDIVIDUS:17]mail2:28=Null:C1517))
			SEND PACKET:C103($doc; [IMPORT_INDIVIDUS:17]mail1:27+Char:C90(Retour à la ligne:K15:40))
		Else 
			SEND PACKET:C103($doc; [IMPORT_INDIVIDUS:17]mail2:28+Char:C90(Retour à la ligne:K15:40))
		End if 
	End if 
	NEXT RECORD:C51([INDIVIDUS:1])
End while 
CLOSE DOCUMENT:C267($doc)
