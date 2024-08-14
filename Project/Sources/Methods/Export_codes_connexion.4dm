//%attributes = {}
$date:=String:C10(Current date:C33; Interne date court:K1:7)
$heure:=String:C10(Current time:C178; h mn s:K7:1)
$YYMMDD:=Substring:C12($date; 9)+Substring:C12($date; 4; 2)+Substring:C12($date; 1; 2)
$HHMMSS:=Replace string:C233($heure; ":"; "")

$idUF:="CDO"
$doc2:=Create document:C266(Get 4D folder:C485(Dossier base:K5:14)+"SIS2A_"+$YYMMDD+"-"+$HHMMSS+"_"+$idUF+".csv"; ".csv")
If (OK=1)
	SEND PACKET:C103($doc2; "Nom"+";")
	SEND PACKET:C103($doc2; "Prenom"+";")
	SEND PACKET:C103($doc2; "Matricule"+";")
	SEND PACKET:C103($doc2; "affectation"+";")
	SEND PACKET:C103($doc2; "identifiant"+";")
	SEND PACKET:C103($doc2; "Mot de passe"+Char:C90(Retour à la ligne:K15:40))
	
	QUERY:C277([AFFECTATIONS:3]; [AFFECTATIONS:3]id_uf:4=$idUF; *)
	QUERY:C277([AFFECTATIONS:3]; [AFFECTATIONS:3]type:5="AFFECTATION_ADMINISTRATIVE")
	DISTINCT VALUES:C339([AFFECTATIONS:3]id_agent:3; $TAgents)
	//AJOUTER À TABLEAU($TAgents; "2109-0") // Demedardi
	
	For ($i; 1; Size of array:C274($TAgents))
		QUERY:C277([AGENTS:2]; [AGENTS:2]id_agent:3=$TAgents{$i})
		QUERY:C277([INDIVIDUS:1]; [INDIVIDUS:1]id_individu:2=[AGENTS:2]id_individu:2)
		SEND PACKET:C103($doc2; Capitalize_First_Only([INDIVIDUS:1]nom_patronymique:4)+";")
		SEND PACKET:C103($doc2; Capitalize_First_Only([INDIVIDUS:1]prenom:5)+";")
		SEND PACKET:C103($doc2; [AGENTS:2]matricule:5+";")
		SEND PACKET:C103($doc2; $idUF+";")
		SEND PACKET:C103($doc2; [AGENTS:2]id_connexion:4+";")
		SEND PACKET:C103($doc2; [INDIVIDUS:1]password:11+Char:C90(Retour à la ligne:K15:40))
	End for 
	CLOSE DOCUMENT:C267($doc2)
	
End if 

