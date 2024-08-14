$evt:=Form event code:C388

Case of 
	: ($evt=Sur clic:K2:4) & (Self:C308->=1)
		Cree_Etats_Disponibilite
		
		Traite_Fichier_Etats_Dispo
		
		
		
End case 