$evt:=Form event code:C388

Case of 
	: ($evt=Sur données modifiées:K2:15)
		ALL RECORDS:C47([REFERENTIEL_GRADES:28])
		If (TFiliere#1)
			QUERY SELECTION:C341([REFERENTIEL_GRADES:28]; [REFERENTIEL_GRADES:28]Filiere:4=TFiliere{TFiliere})
		End if 
		If (TStructure#1)
			QUERY SELECTION:C341([REFERENTIEL_GRADES:28]; [REFERENTIEL_GRADES:28]Structure:5=TStructure{TStructure})
		End if 
		If (TCategorie#1)
			QUERY SELECTION:C341([REFERENTIEL_GRADES:28]; [REFERENTIEL_GRADES:28]Categorie:7=TCategorie{TCategorie})
		End if 
		
End case 