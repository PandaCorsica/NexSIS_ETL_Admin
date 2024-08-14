$evt:=Form event code:C388

Case of 
	: ($evt=Sur chargement:K2:1)
		ALL RECORDS:C47([REFERENTIEL_GRADES:28])
		DISTINCT VALUES:C339([REFERENTIEL_GRADES:28]Filiere:4; TFiliere)
		DISTINCT VALUES:C339([REFERENTIEL_GRADES:28]Structure:5; TStructure)
		DISTINCT VALUES:C339([REFERENTIEL_GRADES:28]Categorie:7; TCategorie)
		INSERT IN ARRAY:C227(TFiliere; 1)
		TFiliere{1}:="Toutes"
		INSERT IN ARRAY:C227(TStructure; 1)
		TStructure{1}:="Toutes"
		INSERT IN ARRAY:C227(TCategorie; 1)
		TCategorie{1}:="Toutes"
		TFiliere:=1
		TStructure:=1
		TCategorie:=1
End case 