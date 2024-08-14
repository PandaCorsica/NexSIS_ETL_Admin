//%attributes = {}
ARRAY TEXT:C222($WACle; 0)
ARRAY TEXT:C222($WAmatricules; 0)
ARRAY TEXT:C222($WADatedeb; 0)
ARRAY TEXT:C222($WADatefin; 0)
//TABLEAU heure($WAHeuredeb; 0)
//TABLEAU HEURE($WAHeurefin; 0)
ARRAY LONGINT:C221($WACategorie; 0)
ARRAY TEXT:C222($WACleCentre; 0)
ARRAY TEXT:C222($WALibCentre; 0)
//TABLEAU TEXTE($PERScle_corpsAff; 0)
ARRAY LONGINT:C221($WAMandatee; 0)
ARRAY TEXT:C222($WANumCrss; 0)
ARRAY REAL:C219($WAMontantVac; 0)
ARRAY REAL:C219($WAMontantMandate; 0)



ALL RECORDS:C47([ANTIBIA_INTERS_WA:190])
DELETE SELECTION:C66([ANTIBIA_INTERS_WA:190])


ConnexionSQL_WA

If (OK=1)
	//SQL EXÉCUTER("SELECT CAST(DATE_DEBUT AS DATE) FROM IA_ACTIVITE WHERE NUM_CRSS is not null AND DATE_DEBUT >='2024-01-01'"; $WADatedeb)
	
	SQL EXECUTE:C820("SELECT CLE,AGENT_MATR,  CONVERT(VARCHAR,DATE_DEBUT,127), CONVERT(VARCHAR,DATE_FIN,127), CATEG_AGENT, CLE_CENTRE, LIB_CENTRE, MANDATEE, NUM_CRSS, MNT_VACATION, MNT_MANDATE FROM IA_ACTIVITE WHERE NUM_CRSS is not null AND DATE_DEBUT >='2024-01-01'"; $WACle; $WAmatricules; $WADatedeb; $WADatefin; $WACategorie; $WACleCentre; $WALibCentre; $WAMandatee; $WANumCrss; $WAMontantVac; $WAMontantMandate)
	SQL LOAD RECORD:C822(SQL tous les enregistrements:K49:10)
	For ($i; 1; Size of array:C274($WACle))
		CREATE RECORD:C68([ANTIBIA_INTERS_WA:190])
		If ($WACategorie{$i}=2)
			[ANTIBIA_INTERS_WA:190]Categorie:6:="SPP"
		Else 
			[ANTIBIA_INTERS_WA:190]Categorie:6:="SPV"
		End if 
		[ANTIBIA_INTERS_WA:190]Cle:2:=$WACle{$i}
		[ANTIBIA_INTERS_WA:190]Cle_Centre:7:=$WACleCentre{$i}
		[ANTIBIA_INTERS_WA:190]Date_Debut:4:=Date:C102($WADatedeb{$i})
		[ANTIBIA_INTERS_WA:190]Date_Fin:5:=Date:C102($WADatefin{$i})
		[ANTIBIA_INTERS_WA:190]Heure_Debut:13:=Time:C179($WADatedeb{$i})
		[ANTIBIA_INTERS_WA:190]Heure_Fin:14:=Time:C179($WADatefin{$i})
		[ANTIBIA_INTERS_WA:190]Libelle_Centre:8:=$WALibCentre{$i}
		If ($WAMandatee{$i}=1)
			[ANTIBIA_INTERS_WA:190]Mandatee:9:=True:C214
		Else 
			[ANTIBIA_INTERS_WA:190]Mandatee:9:=False:C215
		End if 
		[ANTIBIA_INTERS_WA:190]Matricule:3:=$WAmatricules{$i}
		[ANTIBIA_INTERS_WA:190]Montant_Mandate:12:=$WAMontantMandate{$i}
		[ANTIBIA_INTERS_WA:190]Montant_Vacation:11:=$WAMontantVac{$i}
		[ANTIBIA_INTERS_WA:190]Numero_CRSS:10:=$WANumCrss{$i}
		
		SAVE RECORD:C53([ANTIBIA_INTERS_WA:190])
	End for 
	SQL LOGOUT:C872
	
	
End if 
