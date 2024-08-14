//%attributes = {}
// 1er lancement au démarrage de la base
//récupération des données NexSIS sur les engins, les radios et les habilitations
//DD_Recupere_Donnees_NexSIS
//récupération RH et envoi des données montantes
//DM_Traitement_Automatise

Repeat 
	$heureCourante:=Current time:C178(*)
	If ((Teste_heure("@:10") | Teste_heure("@:25") | Teste_heure("@:40") | Teste_heure("@:55")) & (Not:C34(Teste_heure("02:@"))))  // déclenchement toutes les 15mn
		// on récupère les plannings en temps réel sauf entre 2 et 3h du matin car il y a le traitement journalier qui est long
		DDF_Recupere_POJ_Tps_Reel
	End if 
	If (Teste_heure("02:00"))  // déclenchement à 2h du matin
		//Si (Num(Sous chaîne(Chaîne($heureCourante; h mn); 1; 2))=2)  // déclenchement à 2h du matin
		//récupération des données NexSIS sur les engins, (les radios) et les habilitations
		DD_Recupere_Donnees_NexSIS
		//récupération RH et envoi des données montantes
		DM_Traitement_Automatise
	End if 
	If (Teste_heure("06:00"))  // déclenchement à 6h du matin
		//Si (Num(Sous chaîne(Chaîne($heureCourante; h mn); 1; 2))=6)  // déclenchement à 6h du matin
		//récupération des données descendantes
		DDF_Recuperation_Journaliere
	End if 
	If (Teste_heure("06:35"))  // déclenchement à 6h35 du matin
		// on récupère le BRQ
		//$brq:=Recupere_BRQ
		// et on l'envoie par mail au CODIS
		//$result:=BRQ_Envoi_mail("codis@sis2a.corsica"; $brq)
		// on récupère les infos de la nuit
		$brq:=Recupere_Bilan_Nuit
		// et on l'envoie par mail au CODIS
		$result:=Bilan_Nuit_Envoi_Mail("codis@sis2a.corsica"; $brq)
	End if 
	If (Teste_heure("08:00"))  // déclenchement à 8h du matin
		//Si (Num(Sous chaîne(Chaîne($heureCourante; h mn); 1; 2))=8)  // déclenchement à 8h du matin
		//envoi des états de synthese
		Envoi_rapport_erreurs
	End if 
	If (Teste_heure("17:32"))  // déclenchement à 17h32 pour récupération du bilan jour
		// on récupère les infos de la journée
		//$brq:=Recupere_Bilan_Jour
		// et on l'envoie par mail au CODIS
		//$result:=Bilan_Jour_Envoi_Mail("codis@sis2a.corsica"; $brq)
	End if 
	Recupere_Donnees_Chaudes
	// on endort le process pendant 1mn
	DELAY PROCESS:C323(Current process:C322; 3600)
Until (False:C215)