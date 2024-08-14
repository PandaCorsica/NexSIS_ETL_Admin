$evt:=Form event code:C388

Case of 
	: ($evt=Sur double clic:K2:5)
		CREATE SET:C116([REFERENTIEL_STATUTS:32]; "select")
		If (Records in set:C195("$StatutsChoisis")#0)
			USE SET:C118("$StatutsChoisis")
			USE SET:C118("$StatutsRef")
			APPLY TO SELECTION:C70([IMPORT_CATEGORIE:24]; [IMPORT_CATEGORIE:24]code_Ref:4:=[REFERENTIEL_STATUTS:32]Code:2)
			ALL RECORDS:C47([IMPORT_CATEGORIE:24])
			ORDER BY:C49([IMPORT_CATEGORIE:24]; [IMPORT_CATEGORIE:24]Cle:2; >)
			USE SET:C118("select")
		Else 
			ALERT:C41("Vous devez choisir une categorie Antibia à modifier")
		End if 
End case 