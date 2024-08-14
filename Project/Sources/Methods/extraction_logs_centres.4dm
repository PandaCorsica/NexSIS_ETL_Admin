//%attributes = {}
ALL RECORDS:C47([UF:5])
While (Not:C34(End selection:C36([UF:5])))
	
	
	QUERY:C277([AFFECTATIONS:3]; [AFFECTATIONS:3]id_uf:4=[UF:5]id_uf:5)
	RELATE ONE SELECTION:C349([AFFECTATIONS:3]; [AGENTS:2])
	$doc:=Create document:C266([UF:5]id_uf:5+".txt"; ".txt")
	SEND PACKET:C103($doc; "Nom"+Char:C90(Tabulation:K15:37))
	SEND PACKET:C103($doc; "Prenom"+Char:C90(Tabulation:K15:37))
	SEND PACKET:C103($doc; "login"+Char:C90(Tabulation:K15:37))
	SEND PACKET:C103($doc; "mot de passe"+Char:C90(Retour à la ligne:K15:40))
	While (Not:C34(End selection:C36([AGENTS:2])))
		QUERY:C277([INDIVIDUS:1]; [INDIVIDUS:1]id_individu:2=[AGENTS:2]id_individu:2)
		SEND PACKET:C103($doc; [INDIVIDUS:1]nom_usuel:3+Char:C90(Tabulation:K15:37))
		SEND PACKET:C103($doc; [INDIVIDUS:1]prenom:5+Char:C90(Tabulation:K15:37))
		SEND PACKET:C103($doc; [AGENTS:2]id_connexion:4+Char:C90(Tabulation:K15:37))
		SEND PACKET:C103($doc; [INDIVIDUS:1]password:11+Char:C90(Retour à la ligne:K15:40))
		NEXT RECORD:C51([AGENTS:2])
	End while 
	CLOSE DOCUMENT:C267($doc)
	NEXT RECORD:C51([UF:5])
End while 
