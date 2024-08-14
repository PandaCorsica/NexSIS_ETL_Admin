//%attributes = {}
ARRAY TEXT:C222($PERSCle; 0)
ARRAY TEXT:C222($PERSmatricules; 0)
ARRAY TEXT:C222($PERSnoms; 0)
ARRAY TEXT:C222($PERSprenoms; 0)
ARRAY TEXT:C222($PERSnomJF; 0)
ARRAY TEXT:C222($PERScle_Grade; 0)
ARRAY TEXT:C222($PERSCle_corps; 0)
//TABLEAU TEXTE($PERScle_corpsAff; 0)
ARRAY LONGINT:C221($PERScat; 0)
ARRAY TEXT:C222($PERSsexe; 0)
ARRAY DATE:C224($PERSdatenaiss; 0)
ARRAY TEXT:C222($PERSlieunais; 0)
ARRAY TEXT:C222($PERScpnais; 0)
ARRAY TEXT:C222($PERSpaysnais; 0)
ARRAY TEXT:C222($PERSSS; 0)
ARRAY TEXT:C222($PSERV; 0)
ARRAY TEXT:C222($PBURE; 0)
ARRAY TEXT:C222($PGPTFCT; 0)
ARRAY TEXT:C222($PPOLE; 0)
ARRAY TEXT:C222($PDIRECTION; 0)
ARRAY DATE:C224($PERSdebcis; 0)
ARRAY DATE:C224($PERSfincis; 0)
ARRAY TEXT:C222($PERSMailPerso; 0)
ARRAY TEXT:C222($PERSMailPro; 0)



ALL RECORDS:C47([IMPORT_INDIVIDUS:17])
DELETE SELECTION:C66([IMPORT_INDIVIDUS:17])


ConnexionSQL

If (OK=1)
	SQL EXECUTE:C820("SELECT P_MATR,P_CLE,  P_NOMJF, P_GRAD, P_CORPS, P_CATEG, P_SEXE, P_DANA, P_LINA, P_PANA, P_COPLNA, P_SS, P_SERV, P_BURE, P_GPTFCT, P_POLE, P_DIRECTION, P_DECIS, P_DRAD, P_EMAIL, P_PEMAIL, P_PREN, P_NOM FROM Pompers"; $PERSmatricules; $PERSCle; $PERSnomJF; $PERScle_Grade; $PERSCle_corps; $PERScat; $PERSsexe; $PERSdatenaiss; $PERSlieunais; $PERSpaysnais; $PERScpnais; $PERSSS; $PSERV; $PBURE; $PGPTFCT; $PPOLE; $PDIRECTION; $PERSdebcis; $PERSfincis; $PERSMailPerso; $PERSMailPro; $PERSprenoms; $PERSnoms)
	SQL LOAD RECORD:C822(SQL tous les enregistrements:K49:10)
	If (Size of array:C274($PDIRECTION)<Size of array:C274($PERSnoms))
		APPEND TO ARRAY:C911($PDIRECTION; "")
	End if 
	If (Size of array:C274($PPOLE)<Size of array:C274($PERSnoms))
		APPEND TO ARRAY:C911($PPOLE; "")
	End if 
	If (Size of array:C274($PGPTFCT)<Size of array:C274($PERSnoms))
		APPEND TO ARRAY:C911($PGPTFCT; "")
	End if 
	If (Size of array:C274($PSERV)<Size of array:C274($PERSnoms))
		APPEND TO ARRAY:C911($PSERV; "")
	End if 
	If (Size of array:C274($PBURE)<Size of array:C274($PERSnoms))
		APPEND TO ARRAY:C911($PBURE; "")
	End if 
	For ($i; 1; Size of array:C274($PERSCle))
		If ($PERScat{$i}#4)  // si ce n'est pas un JSP
			CREATE RECORD:C68([IMPORT_INDIVIDUS:17])
			[IMPORT_INDIVIDUS:17]Matricule:2:=$PERSmatricules{$i}
			[IMPORT_INDIVIDUS:17]Nom:3:=Supprime_Espace_Final($PERSnoms{$i})
			[IMPORT_INDIVIDUS:17]Prenom:5:=Supprime_Espace_Final($PERSprenoms{$i})
			If ($i>Size of array:C274($PERSnomJF))
				APPEND TO ARRAY:C911($PERSnomJF; "")
			End if 
			[IMPORT_INDIVIDUS:17]Nom_jeune_fille:4:=Supprime_Espace_Final($PERSnomJF{$i})
			If ([IMPORT_INDIVIDUS:17]Nom_jeune_fille:4="")
				[IMPORT_INDIVIDUS:17]Nom_jeune_fille:4:=[IMPORT_INDIVIDUS:17]Nom:3
			End if 
			[IMPORT_INDIVIDUS:17]Cle_Grade:12:=TraitePeraldiFrerson($PERSmatricules{$i}; $PERScle_Grade{$i})
			[IMPORT_INDIVIDUS:17]Cle_Corps:13:=$PERSCle_corps{$i}
			//[IMPORT_INDIVIDUS]Cle_Corps_Affec:=$PERScle_corpsAff{$i}
			[IMPORT_INDIVIDUS:17]Cle_Categorie:14:=$PERScat{$i}
			[IMPORT_INDIVIDUS:17]Cle_Pers:15:=$PERSCle{$i}
			[IMPORT_INDIVIDUS:17]Date_naissance:6:=String:C10($PERSdatenaiss{$i}; Interne date court:K1:7)
			[IMPORT_INDIVIDUS:17]Code_pays:8:=$PERSpaysnais{$i}
			[IMPORT_INDIVIDUS:17]Pays:7:=""
			[IMPORT_INDIVIDUS:17]Lieu _naissance:9:=$PERSlieunais{$i}
			[IMPORT_INDIVIDUS:17]CP_naissance:10:=$PERScpnais{$i}
			[IMPORT_INDIVIDUS:17]Sexe:11:=$PERSsexe{$i}
			[IMPORT_INDIVIDUS:17]num_secu:17:=$PERSSS{$i}
			[IMPORT_INDIVIDUS:17]Cle_Service:20:=$PSERV{$i}
			[IMPORT_INDIVIDUS:17]Cle_Bureau:21:=$PBURE{$i}
			[IMPORT_INDIVIDUS:17]Cle_GptFct:22:=$PGPTFCT{$i}
			[IMPORT_INDIVIDUS:17]Cle_Direction:24:=$PPOLE{$i}
			[IMPORT_INDIVIDUS:17]Cle_Pole:23:=$PDIRECTION{$i}
			[IMPORT_INDIVIDUS:17]mail1:27:=$PERSMailPerso{$i}
			[IMPORT_INDIVIDUS:17]mail2:28:=$PERSMailPro{$i}
			$TSEntree:=4DStmp_Write($PERSdebcis{$i}; ?00:00:00?)
			$decallage:=Calcule_Decallage($TSEntree)
			$tempDate:=Date:C102($PERSdebcis{$i})
			Case of 
				: ($decallage>=0) & ($decallage<10)
					[IMPORT_INDIVIDUS:17]Debut_CIS:25:=String:C10($tempDate; ISO date:K1:8; ?00:00:00?)+"+0"+String:C10($decallage)+":00"
				: ($decallage>=0) & ($decallage>=10)
					[IMPORT_INDIVIDUS:17]Debut_CIS:25:=String:C10($tempDate; ISO date:K1:8; ?00:00:00?)+"+"+String:C10($decallage)+":00"
				: ($decallage<0) & ($decallage>-10)
					[IMPORT_INDIVIDUS:17]Debut_CIS:25:=String:C10($tempDate; ISO date:K1:8; ?00:00:00?)+"-0"+String:C10(-$decallage)+":00"
				: ($decallage<0) & ($decallage<=10)
					[IMPORT_INDIVIDUS:17]Debut_CIS:25:=String:C10($tempDate; ISO date:K1:8; ?00:00:00?)+"-"+String:C10(-$decallage)+":00"
			End case 
			$TSFin:=4DStmp_Write($PERSfincis{$i}; ?00:00:00?)
			$decallage:=Calcule_Decallage($TSFin)
			$tempDate:=Date:C102($PERSfincis{$i})
			Case of 
				: ($decallage>=0) & ($decallage<10)
					[IMPORT_INDIVIDUS:17]Radiation:26:=String:C10($tempDate; ISO date:K1:8; ?00:00:00?)+"+0"+String:C10($decallage)+":00"
				: ($decallage>=0) & ($decallage>=10)
					[IMPORT_INDIVIDUS:17]Radiation:26:=String:C10($tempDate; ISO date:K1:8; ?00:00:00?)+"+"+String:C10($decallage)+":00"
				: ($decallage<0) & ($decallage>-10)
					[IMPORT_INDIVIDUS:17]Radiation:26:=String:C10($tempDate; ISO date:K1:8; ?00:00:00?)+"-0"+String:C10(-$decallage)+":00"
				: ($decallage<0) & ($decallage<=10)
					[IMPORT_INDIVIDUS:17]Radiation:26:=String:C10($tempDate; ISO date:K1:8; ?00:00:00?)+"-"+String:C10(-$decallage)+":00"
			End case 
			
			SAVE RECORD:C53([IMPORT_INDIVIDUS:17])
		End if 
	End for 
	SQL LOGOUT:C872
	
	//on va maintenant définir s'il y des homonymes
	ALL RECORDS:C47([IMPORT_INDIVIDUS:17])
	ORDER BY:C49([IMPORT_INDIVIDUS:17]; [IMPORT_INDIVIDUS:17]Nom:3; >; [IMPORT_INDIVIDUS:17]Prenom:5; >; [IMPORT_INDIVIDUS:17]Matricule:2; >)
	$lastInd:=""
	$lastMat:=""
	$lastNumOrdre:=0
	While (Not:C34(End selection:C36([IMPORT_INDIVIDUS:17])))
		If ([IMPORT_INDIVIDUS:17]Nom:3+[IMPORT_INDIVIDUS:17]Prenom:5=$lastInd)  // Homonyme
			If ([IMPORT_INDIVIDUS:17]Matricule:2=$lastMat)
				// il s'agit d'une personne traitee
				[IMPORT_INDIVIDUS:17]numOrdre:18:=$lastNumOrdre
			Else 
				[IMPORT_INDIVIDUS:17]numOrdre:18:=$lastNumOrdre+1
			End if 
		Else 
			[IMPORT_INDIVIDUS:17]numOrdre:18:=0
			$lastNumOrdre:=0
		End if 
		$lastInd:=[IMPORT_INDIVIDUS:17]Nom:3+[IMPORT_INDIVIDUS:17]Prenom:5
		$lastMat:=[IMPORT_INDIVIDUS:17]Matricule:2
		SAVE RECORD:C53([IMPORT_INDIVIDUS:17])
		NEXT RECORD:C51([IMPORT_INDIVIDUS:17])
	End while 
	
End if 
