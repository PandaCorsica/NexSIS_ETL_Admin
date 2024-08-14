$evt:=Form event code:C388

Case of 
	: ($evt=Sur chargement:K2:1)
		ALL RECORDS:C47([CORRESPONDANCE_COMPETENCES:41])
		ALL RECORDS:C47([IMPORT_COMPETENCES:39])
End case 