$evt:=Form event code:C388

Case of 
	: ($evt=Sur clic:K2:4) & (Self:C308->=1)
		Cree_Habilitations_New
		//genere_Donnees_Habilitation
		Traite_Fichier_Habilitations
End case 