//%attributes = {}
//TOUT SÉLECTIONNER([crss_validation_old])
//Tant que (Non(Fin de sélection([crss_validation_old])))
//CHERCHER([crss_validation]; [crss_validation]numero_operation=[crss_validation_old]numero_operation; *)
//CHERCHER([crss_validation]; [crss_validation]unite_fonctionnelle=[crss_validation_old]unite_fonctionnelle)
//Si (Enregistrements trouvés([crss_validation])=0)

//Fin de si 
//[crss_validation]etat_validation:=[crss_validation_old]etat_validation
//[crss_validation]Traite:=[crss_validation_old]Traite
//STOCKER ENREGISTREMENT([crss_validation])
//CHERCHER([DONNEES_INTERS]; [DONNEES_INTERS]numInter=[crss_validation_old]numero_operation; *)
//CHERCHER([DONNEES_INTERS]; [DONNEES_INTERS]codeUF=[crss_validation_old]unite_fonctionnelle)
//Si (Enregistrements trouvés([DONNEES_INTERS])=0)

//Fin de si 
//CHERCHER([DONNEES_INTERS_old]; [DONNEES_INTERS_old]numInter=[crss_validation_old]numero_operation; *)
//CHERCHER([DONNEES_INTERS_old]; [DONNEES_INTERS_old]codeUF=[crss_validation_old]unite_fonctionnelle)
//Si (Enregistrements trouvés([DONNEES_INTERS_old])=0)

//Fin de si 
//[DONNEES_INTERS]date_CRSS:=[DONNEES_INTERS_old]date_CRSS
//[DONNEES_INTERS]date_Debut:=[DONNEES_INTERS_old]date_Debut
//[DONNEES_INTERS]date_Fin:=[DONNEES_INTERS_old]date_Fin
//[DONNEES_INTERS]ID_CRSS_Validation:=[crss_validation]id
//[DONNEES_INTERS]ligne:=[DONNEES_INTERS_old]ligne
//[DONNEES_INTERS]traite:=[DONNEES_INTERS_old]traite
//STOCKER ENREGISTREMENT([DONNEES_INTERS])

//CHERCHER([PARTICIPATION_AGENT]; [PARTICIPATION_AGENT]ID_Donnees_Inter=[DONNEES_INTERS]ID
//ENREGISTREMENT SUIVANT([crss_validation_old])
//Fin tant que 

QUERY:C277([DONNEES_INTERS_old:180]; [DONNEES_INTERS_old:180]traite:5=True:C214)
While (Not:C34(End selection:C36([DONNEES_INTERS_old:180])))
	QUERY:C277([crss_validation_old:177]; [crss_validation_old:177]id:1=[DONNEES_INTERS_old:180]ID_CRSS_Validation:18)
	If ([crss_validation_old:177]etat_validation:4="A PAYER")
		QUERY:C277([crss_validation:154]; [crss_validation:154]unite_fonctionnelle:8=[crss_validation_old:177]unite_fonctionnelle:8; *)
		QUERY:C277([crss_validation:154]; [crss_validation:154]numero_operation:21=[crss_validation_old:177]numero_operation:17)
		[crss_validation:154]etat_validation:4:="PAYE"
		[crss_validation:154]Traite:19:=True:C214
		SAVE RECORD:C53([crss_validation:154])
		QUERY:C277([DONNEES_INTERS:158]; [DONNEES_INTERS:158]ID_CRSS_Validation:18=[crss_validation:154]id:1)
		[DONNEES_INTERS:158]traite:5:=True:C214
		SAVE RECORD:C53([DONNEES_INTERS:158])
	End if 
	NEXT RECORD:C51([DONNEES_INTERS_old:180])
End while 

