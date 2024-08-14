//%attributes = {}
QUERY:C277([PARTICIPATION_AGENT:163]; [PARTICIPATION_AGENT:163]Paye:21=False:C215)
RELATE ONE SELECTION:C349([PARTICIPATION_AGENT:163]; [DONNEES_INTERS:158])
DISTINCT VALUES:C339([DONNEES_INTERS:158]ID:1; $TIDDonnees)
For ($i; 1; Size of array:C274($TIDDonnees))
	QUERY:C277([PARTICIPATION_AGENT:163]; [PARTICIPATION_AGENT:163]Paye:21=False:C215; *)
	QUERY:C277([PARTICIPATION_AGENT:163]; [PARTICIPATION_AGENT:163]ID_Donnees_Inter:17=$TIDDonnees{$i})
	//CHERCHER([PARTICIPATION_ENGIN]; [PARTICIPATION_ENGIN]Paye=Faux; *)
	QUERY:C277([PARTICIPATION_ENGIN:164]; [PARTICIPATION_ENGIN:164]ID_Donnees_Inter:13=$TIDDonnees{$i})
	QUERY:C277([DONNEES_INTERS:158]; [DONNEES_INTERS:158]ID:1=$TIDDonnees{$i})
	$ligneEngin:=calcule_ligne_engin
	$lignePersonnel:=calcule_ligne_personnel
	// on rajoute une ligne de données pour générer un CRSS Systel
	If ($ligneEngin#"") & ($lignePersonnel#"")  // s'il n'y a pas euy d'erreur
		$param1:=[DONNEES_INTERS:158]codeUF:3
		$param2:=[DONNEES_INTERS:158]numInter:4
		$param3:=[DONNEES_INTERS:158]date_CRSS:6
		$param4:=[DONNEES_INTERS:158]adresse:10
		$param5:=[DONNEES_INTERS:158]Code_centre_Systel:8
		$param6:=[DONNEES_INTERS:158]code_NF:15
		$param7:=[DONNEES_INTERS:158]codePostal:11
		$param8:=[DONNEES_INTERS:158]commune:12
		$param9:=[DONNEES_INTERS:158]date_Debut:13
		$param10:=[DONNEES_INTERS:158]date_Fin:14
		$param11:=[DONNEES_INTERS:158]Libelle_UF:9
		$param12:=[DONNEES_INTERS:158]nom_signataire:16
		$param13:=[DONNEES_INTERS:158]prenom_signataire:17
		$param14:=[DONNEES_INTERS:158]ID_CRSS_Validation:18
		
		
		CREATE RECORD:C68([DONNEES_INTERS:158])
		[DONNEES_INTERS:158]codeUF:3:=$param1
		[DONNEES_INTERS:158]numInter:4:=$param2
		[DONNEES_INTERS:158]traite:5:=False:C215
		[DONNEES_INTERS:158]date_CRSS:6:=$param3
		[DONNEES_INTERS:158]adresse:10:=$param4
		[DONNEES_INTERS:158]Code_centre_Systel:8:=$param5
		[DONNEES_INTERS:158]code_NF:15:=$param6
		[DONNEES_INTERS:158]codePostal:11:=$param7
		[DONNEES_INTERS:158]commune:12:=$param8
		[DONNEES_INTERS:158]date_Debut:13:=$param9
		[DONNEES_INTERS:158]date_Fin:14:=$param10
		[DONNEES_INTERS:158]Libelle_UF:9:=$param11
		[DONNEES_INTERS:158]nom_signataire:16:=$param12
		[DONNEES_INTERS:158]numeroRenfort:7:=10
		[DONNEES_INTERS:158]prenom_signataire:17:=$param13
		[DONNEES_INTERS:158]ID_CRSS_Validation:18:=$param14
		[DONNEES_INTERS:158]Archivage:19:=False:C215
		[DONNEES_INTERS:158]ligne:2:=CRSS_Cree_Ligne_Fichier($ligneEngin; $lignePersonnel)
		SAVE RECORD:C53([DONNEES_INTERS:158])
	End if 
	
End for 

