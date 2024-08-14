$evt:=Form event code:C388

Case of 
	: ($evt=Sur chargement:K2:1)
		ALL RECORDS:C47([REF_HABILITATIONS:51])
		SELECTION TO ARRAY:C260([REF_HABILITATIONS:51]Code:2; THabilitations)
		
		
End case 