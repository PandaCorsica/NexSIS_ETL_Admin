//%attributes = {}
ARRAY TEXT:C222($PERSmatricules; 0)
ARRAY TEXT:C222($PERSnoms; 0)
ARRAY TEXT:C222($PERSprenoms; 0)
ARRAY DATE:C224($PERSfincis; 0)
ARRAY LONGINT:C221($PERScat; 0)

ALL RECORDS:C47([NON_ACTIFS:141])
DELETE SELECTION:C66([NON_ACTIFS:141])

ConnexionSQL

If (OK=1)
	SQL EXECUTE:C820("SELECT P_MATR, P_CATEG, P_DRAD, P_PREN, P_NOM FROM Na_pers"; $PERSmatricules; $PERScat; $PERSfincis; $PERSprenoms; $PERSnoms)
	SQL LOAD RECORD:C822(SQL tous les enregistrements:K49:10)
	For ($i; 1; Size of array:C274($PERSmatricules))
		CREATE RECORD:C68([NON_ACTIFS:141])
		[NON_ACTIFS:141]Matricule:2:=$PERSmatricules{$i}
		[NON_ACTIFS:141]Nom:3:=$PERSnoms{$i}
		[NON_ACTIFS:141]Prenom:4:=$PERSprenoms{$i}
		[NON_ACTIFS:141]Cle_Categorie:6:=$PERScat{$i}
		$TSFin:=4DStmp_Write($PERSfincis{$i}; ?00:00:00?)
		$decallage:=Calcule_Decallage($TSFin)
		$tempDate:=Date:C102($PERSfincis{$i})
		Case of 
			: ($decallage>=0) & ($decallage<10)
				[NON_ACTIFS:141]Radiation:5:=String:C10($tempDate; ISO date:K1:8; ?00:00:00?)+"+0"+String:C10($decallage)+":00"
			: ($decallage>=0) & ($decallage>=10)
				[NON_ACTIFS:141]Radiation:5:=String:C10($tempDate; ISO date:K1:8; ?00:00:00?)+"+"+String:C10($decallage)+":00"
			: ($decallage<0) & ($decallage>-10)
				[NON_ACTIFS:141]Radiation:5:=String:C10($tempDate; ISO date:K1:8; ?00:00:00?)+"-0"+String:C10(-$decallage)+":00"
			: ($decallage<0) & ($decallage<=10)
				[NON_ACTIFS:141]Radiation:5:=String:C10($tempDate; ISO date:K1:8; ?00:00:00?)+"-"+String:C10(-$decallage)+":00"
		End case 
		
		SAVE RECORD:C53([NON_ACTIFS:141])
	End for 
	SQL LOGOUT:C872
End if 
