//%attributes = {}
// on vérifie d'aboird la cohérence des données
CRSS_Pre_Traitement

// puis on fait le traitement final pour paie



//8) on va creer les lignes CRSS
QUERY:C277([DONNEES_INTERS:158]; [DONNEES_INTERS:158]traite:5=False:C215; *)
QUERY:C277([DONNEES_INTERS:158]; [DONNEES_INTERS:158]Archivage:19=False:C215)
While (Not:C34(End selection:C36([DONNEES_INTERS:158])))
	RELATE MANY:C262([DONNEES_INTERS:158]ID:1)
	QUERY SELECTION:C341([PARTICIPATION_AGENT:163]; [PARTICIPATION_AGENT:163]Archivage:20=False:C215)
	QUERY SELECTION:C341([PARTICIPATION_ENGIN:164]; [PARTICIPATION_ENGIN:164]Archivage:15=False:C215)
	$ligneEngin:=calcule_ligne_engin
	$lignePersonnel:=calcule_ligne_personnel
	// on rajoute une ligne de données pour générer un CRSS Systel
	If ($ligneEngin#"") & ($lignePersonnel#"")  // s'il n'y a pas euy d'erreur
		[DONNEES_INTERS:158]ligne:2:=CRSS_Cree_Ligne_Fichier($ligneEngin; $lignePersonnel)
		SAVE RECORD:C53([DONNEES_INTERS:158])
	End if 
	NEXT RECORD:C51([DONNEES_INTERS:158])
End while 

// 9)Envoi OK/KO
SFTP_Transfert_statut_paie




//10) Generation du fichier à intégrer dans Antibia
CRSS_Generation_Fichier_Antibia


