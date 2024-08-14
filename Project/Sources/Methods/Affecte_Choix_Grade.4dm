//%attributes = {}
$evt:=Form event code:C388

Case of 
	: ($evt=Sur double clic:K2:5)
		CREATE SET:C116([REFERENTIEL_GRADES:28]; "select")
		If (Records in set:C195("$GradesChoisis")#0)
			USE SET:C118("$GradesChoisis")
			USE SET:C118("$GradesRef")
			APPLY TO SELECTION:C70([IMPORT_GRADE:25]; [IMPORT_GRADE:25]code_Ref:5:=[REFERENTIEL_GRADES:28]Code:2)
			ALL RECORDS:C47([IMPORT_GRADE:25])
			ORDER BY:C49([IMPORT_GRADE:25]; [IMPORT_GRADE:25]cle:2; >)
			USE SET:C118("select")
			ORDER BY:C49([REFERENTIEL_GRADES:28]; [REFERENTIEL_GRADES:28]Statut:6; >; [REFERENTIEL_GRADES:28]Filiere:4; >; [REFERENTIEL_GRADES:28]Libelle:3; >)
		Else 
			ALERT:C41("Vous devez choisir un grade Antibia à modifier")
		End if 
End case 