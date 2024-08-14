$evt:=Form event code:C388

Case of 
	: ($evt=Sur clic:K2:4) & (Self:C308->=1)
		
		$erreur:=Traite_Fichier_Individus
		If ($erreur)
			ALERT:C41("Erreur dans la creation du fichier Individus")
		Else 
			ALERT:C41("Fichier INDIVIDUS créé")
		End if 
		
End case 