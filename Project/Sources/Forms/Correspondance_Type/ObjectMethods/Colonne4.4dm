$evt:=Form event code:C388

Case of 
	: ($evt=Sur double clic:K2:5)
		CREATE SET:C116([REFERENTIEL_TYPES:33]; "select")
		If (Records in set:C195("$TypesChoisis")#0)
			USE SET:C118("$TypesChoisis")
			USE SET:C118("$TypesRef")
			APPLY TO SELECTION:C70([IMPORT_TYPE:23]; [IMPORT_TYPE:23]code_Ref:4:=[REFERENTIEL_TYPES:33]Code:2)
			ALL RECORDS:C47([IMPORT_TYPE:23])
			ORDER BY:C49([IMPORT_TYPE:23]; [IMPORT_TYPE:23]cle_type:2; >)
			USE SET:C118("select")
		Else 
			ALERT:C41("Vous devez choisir un type Antibia à modifier")
		End if 
End case 