$evt:=Form event code:C388

Case of 
	: ($evt=Sur clic:K2:4) & (Self:C308->=1)
		C_BOOLEAN:C305($erreur)
		$docLog:=Create document:C266(Get 4D folder:C485(Dossier base:K5:14)+"Log Erreurs relatives aux Individus.txt"; ".txt")
		
		$erreur:=genere_donnees_individu
		If ($erreur)
			SEND PACKET:C103($docLog; "Erreur dans le fichier erreursRH sur les individus (fichier erreursRHIndividus.txt)"+Char:C90(Retour à la ligne:K15:40))
		End if 
		
		$erreur:=Verifie_donnees_Individus
		If ($erreur)
			SEND PACKET:C103($docLog; "Certains individus ont des informations manquantes (fichier erreursIndividus.txt)"+Char:C90(Retour à la ligne:K15:40))
		End if 
		
		//$erreur:=Traite_Fichier_Individus
		//Si ($erreur)
		//ENVOYER PAQUET($docLog; "Erreur dans la creation du fichier Individus"+Caractère(Retour à la ligne))
		//Fin de si 
		
		CLOSE DOCUMENT:C267($docLog)
End case 