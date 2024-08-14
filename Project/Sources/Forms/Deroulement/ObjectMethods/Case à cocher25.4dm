$evt:=Form event code:C388

Case of 
	: ($evt=Sur clic:K2:4) & (Self:C308->=1)
		// immport LDG Panda
		Recuperation_LDG_Panda
		//Verifie_liste_garde
		Verifie_Nouvelle_Affectation
		
		Regenere_Liste_Garde
		
		
End case 