//%attributes = {}
$erreur:=False:C215
$cheminDossier:=$1
$docAgent:=Create document:C266($cheminDossier+"ErreursGenerationFichierAgents.txt"; ".txt")

$date:=String:C10(Current date:C33; Interne date court:K1:7)
$heure:=String:C10(Current time:C178; h mn s:K7:1)
$YYMMDD:=Substring:C12($date; 9)+Substring:C12($date; 4; 2)+Substring:C12($date; 1; 2)
$HHMMSS:=Replace string:C233($heure; ":"; "")

$doc:=Create document:C266($cheminDossier+"AGENTS.CSV"; ".csv")
If (OK=1)
	//$doc2:=Créer document(Dossier 4D(Dossier base)+"SIS2A_"+$YYMMDD+"-"+$HHMMSS+"_"+"AFFECTATIONS.CSV"; ".csv")
	//Si (OK=1)
	$doc3:=Create document:C266($cheminDossier+"COMPETENCES.CSV"; ".csv")
	
	If (OK=1)
		SEND PACKET:C103($doc; "id_individu"+";")
		SEND PACKET:C103($doc; "id_agent"+";")
		SEND PACKET:C103($doc; "id_connexion"+";")
		SEND PACKET:C103($doc; "matricule"+";")
		SEND PACKET:C103($doc; "statut"+";")
		SEND PACKET:C103($doc; "grade"+Char:C90(Retour à la ligne:K15:40))
		
		QUERY BY FORMULA:C48([AGENTS:2]; Length:C16([AGENTS:2]grade:7)<1)
		DELETE SELECTION:C66([AGENTS:2])
		
		ALL RECORDS:C47([AGENTS:2])
		While (Not:C34(End selection:C36([AGENTS:2])))
			SEND PACKET:C103($doc; [AGENTS:2]id_individu:2+";")
			SEND PACKET:C103($doc; [AGENTS:2]id_agent:3+";")
			SEND PACKET:C103($doc; [AGENTS:2]id_connexion:4+";")
			SEND PACKET:C103($doc; [AGENTS:2]matricule:5+";")
			SEND PACKET:C103($doc; [AGENTS:2]statut:6+";")
			SEND PACKET:C103($doc; [AGENTS:2]grade:7+Char:C90(Retour à la ligne:K15:40))
			
			NEXT RECORD:C51([AGENTS:2])
		End while 
		CLOSE DOCUMENT:C267($doc)
		
		//ENVOYER PAQUET($doc2; "id_affectation"+";")
		//ENVOYER PAQUET($doc2; "id_agent"+";")
		//ENVOYER PAQUET($doc2; "id_uf"+";")
		//ENVOYER PAQUET($doc2; "type"+Caractère(Retour à la ligne))
		
		//TOUT SÉLECTIONNER([AFFECTATIONS])
		//Tant que (Non(Fin de sélection([AFFECTATIONS])))
		//ENVOYER PAQUET($doc2; [AFFECTATIONS]id_affectation+";")
		//ENVOYER PAQUET($doc2; [AFFECTATIONS]id_agent+";")
		//ENVOYER PAQUET($doc2; [AFFECTATIONS]id_uf+";")
		//ENVOYER PAQUET($doc2; [AFFECTATIONS]type+Caractère(Retour à la ligne))
		
		//ENREGISTREMENT SUIVANT([AFFECTATIONS])
		//Fin tant que 
		//FERMER DOCUMENT($doc2)
		
		SEND PACKET:C103($doc3; "id_affectation"+";")
		SEND PACKET:C103($doc3; "id_competence"+Char:C90(Retour à la ligne:K15:40))
		
		ALL RECORDS:C47([COMPETENCES:4])
		While (Not:C34(End selection:C36([COMPETENCES:4])))
			SEND PACKET:C103($doc3; [COMPETENCES:4]id_affectation:2+";")
			SEND PACKET:C103($doc3; [COMPETENCES:4]competence:3+Char:C90(Retour à la ligne:K15:40))
			
			NEXT RECORD:C51([COMPETENCES:4])
		End while 
		CLOSE DOCUMENT:C267($doc3)
		
		
		
	End if 
	//FERMER DOCUMENT($doc2)
	//Fin de si 
Else 
	CLOSE DOCUMENT:C267($doc)
End if 

CLOSE DOCUMENT:C267($docAgent)

$0:=$erreur
