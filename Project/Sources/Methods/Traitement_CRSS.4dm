//%attributes = {}
//// On commence par faire le ménage dans le format des données
//CHERCHER([sgo_operation]; [sgo_operation]numero="SIS2A@")
//Tant que (Non(Fin de sélection([sgo_operation])))
//[sgo_operation]numero:=Sous chaîne([sgo_operation]numero; 7)
//STOCKER ENREGISTREMENT([sgo_operation])
//ENREGISTREMENT SUIVANT([sgo_operation])
//Fin tant que 


// 1) on supprime les crss validés qui relèvent d'inters avant le lancement en prod de NexSIS (1/1/2024)
QUERY:C277([crss_validation:154]; [crss_validation:154]numero_operation:21<"2024")
DELETE SELECTION:C66([crss_validation:154])

//2) on supprime tous les agents qui apparaissent sur les CRSS mais qui avaient été supprimés (valide=faux)
QUERY:C277([crss_agent:99]; [crss_agent:99]active:32=False:C215)
DELETE SELECTION:C66([crss_agent:99])

//2bis) on supprime tous les engins qui apparaissent sur les CRSS mais qui avaient été supprimés (valide=faux)
//CHERCHER([crss_engin]; [crss_engin]active=Faux)
//SUPPRIMER SÉLECTION([crss_engin])

// 3) on récupère les crss validés dans crss_validation
QUERY:C277([crss_validation:154]; [crss_validation:154]etat_validation:4="VALIDE")
// ATTENTION : prevoir de reprendre également les CRSS en état validation apres correction

//4) on les marque en cours de traitement
APPLY TO SELECTION:C70([crss_validation:154]; [crss_validation:154]etat_validation:4:="EN COURS")

// 5) on va traiter tous ces CRSS qui sont encore dans le statut EN COURS
QUERY:C277([crss_validation:154]; [crss_validation:154]etat_validation:4="EN COURS")
ORDER BY:C49([crss_validation:154]; [crss_validation:154]numero_operation:21; >)
While (Not:C34(End selection:C36([crss_validation:154])))
	
	$messageRefus:=""
	// on récupère les engins associés à ce CRSS validé dans l'UF
	QUERY:C277([crss_engin:106]; [crss_engin:106]id_operation:33=[crss_validation:154]id_operation:2; *)
	QUERY:C277([crss_engin:106]; [crss_engin:106]code_unite_fonctionnelle:6=[crss_validation:154]unite_fonctionnelle:8)
	// pour chacun de ces engins, on va récupérer le personnel et que tous les horaires sont corrects
	$erreurEngin:=False:C215
	$ligneEngin:=""
	$lignePersonnel:=""
	$nbperso:=0
	$nbenginsSurInter:=0
	$enginSansPersonnel:=False:C215
	While (Not:C34(End selection:C36([crss_engin:106])))
		// on récupère les données relatives à l'intervention
		QUERY:C277([sgo_operation:110]; [sgo_operation:110]id_operation:2=[crss_engin:106]id_operation:33)
		//on va vérifier que les horaires de l'engin sont bien présents
		If ([crss_engin:106]date_debut_intervention:9="")  // si la date de début d'inter n'est pas renseignée, 
			$messageRefus:="pas de debut d'inter pour engin : "+[crss_engin:106]nom_engin:5
		End if 
		If ([crss_engin:106]date_fin_intervention:10="")  // si la date de fin d'inter n'est pas renseignée
			[crss_engin:106]date_fin_intervention:10:=[crss_engin:106]horaire_rentre_a_uf_modifie:26  // on prend  la date de fin d'inter modifiée
		End if 
		If ([crss_engin:106]date_fin_intervention:10="")  // si elle n'est toujours pas renseignée
			[crss_engin:106]date_fin_intervention:10:=[crss_engin:106]horaire_rentre_a_uf_initial:25  // on prend par défaut la date de fin d'inter
		End if 
		If ([crss_engin:106]date_fin_intervention:10="")  // si elle n'est toujours pas renseignée
			[crss_engin:106]date_fin_intervention:10:=[sgo_operation:110]date_fin:5  // on prend par défaut la date de fin d'inter sur le sgo
		End if 
		If ([crss_engin:106]date_fin_intervention:10="")  // si elle n'est toujours pas renseignée
			$messageRefus:="pas de fin d'inter pour engin : "+[crss_engin:106]nom_engin:5
		End if 
		// on vérifie la cohérence des horaires modifiés de l'engin par rapport aux horaires de l'inter
		If (Date:C102([crss_engin:106]date_fin_intervention:10)>Date:C102([sgo_operation:110]date_fin:5))  // si la fin d'inter modifiée sur le crss est après l'heure globale de fin d'intervention
			$messageRefus:="Horaire de retour modifié de l'engin "+[crss_engin:106]nom_engin:5+" non conforme avec la fin de l'intervention"
		End if 
		// on verifie qu'il y a bien des agents sur cet engin
		QUERY:C277([crss_agent:99]; [crss_agent:99]id_engin:2=[crss_engin:106]id_engin:2)
		If (Records in selection:C76([crss_agent:99])>0)
			$nbenginsSurInter:=$nbenginsSurInter+1  // on ne compte que les engins avec des agents
		Else 
			$enginSansPersonnel:=True:C214
		End if 
		
		If ($messageRefus="") & (Not:C34($enginSansPersonnel))  // s'il n'y a pas d'erreur jusque là
			While (Not:C34(End selection:C36([crss_agent:99])))
				$nbperso:=$nbperso+1
				// on va vérifier si les horaires des agents sont bien présents
				If ([crss_agent:99]horaire_debut_initial:16="")
					[crss_agent:99]horaire_debut_initial:16:=[crss_engin:106]date_debut_intervention:9
				End if 
				If ([crss_agent:99]horaire_fin_initial:17="")
					[crss_agent:99]horaire_fin_initial:17:=[crss_engin:106]date_fin_intervention:10
				End if 
				// on vérifie la cohérence des horaires des horaires modifiés de l'agent par rapport aux horaires de l'engin
				If ([crss_agent:99]horaire_debut_modifie:18#"")
					If (Date:C102([crss_agent:99]horaire_debut_modifie:18)<Date:C102([crss_engin:106]date_debut_intervention:9))
						$messageRefus:="Horaire de départ des agents incompatibles avec l'horaire de départ de l'engin"
					End if 
				End if 
				If ([crss_agent:99]horaire_fin_modifie:19#"")
					If (Date:C102([crss_agent:99]horaire_fin_modifie:19)<Date:C102([crss_engin:106]date_fin_intervention:10))
						$messageRefus:="Horaire de rentrée des agents incompatibles avec l'horaire de rentrée de l'engin"
					End if 
				End if 
				SAVE RECORD:C53([crss_agent:99])
				If ([crss_agent:99]code_statut_rh:14="SPV")
					$statut:="V"
				Else 
					$statut:="P"
				End if 
				$lignePersonnel:=$lignePersonnel+[crss_agent:99]matricule:10+"|"+[crss_agent:99]nom:11+"|"+[crss_agent:99]prenom:12+"|"+$statut+"|"+" "+Grade_Nexsis_vers_Systel([crss_agent:99]code_grade:13)+"|"+[crss_engin:106]nom_engin:5+"|"+"01|0|1|0000000000|0|0|"
				If ([crss_agent:99]horaire_debut_modifie:18="")
					$heureDebut:=[crss_agent:99]horaire_debut_initial:16
				Else 
					$heureDebut:=[crss_agent:99]horaire_debut_modifie:18
				End if 
				$lignePersonnel:=$lignePersonnel+Convertit_DateHeure_ISO_vers_DD($heureDebut)+"|"
				
				If ([crss_agent:99]horaire_fin_modifie:19="")
					$heureFin:=[crss_agent:99]horaire_fin_initial:17
				Else 
					$heureFin:=[crss_agent:99]horaire_fin_modifie:19
				End if 
				$lignePersonnel:=$lignePersonnel+Convertit_DateHeure_ISO_vers_DD($heureFin)+"|"
				$lignePersonnel:=$lignePersonnel+"|"
				$lignePersonnel:=$lignePersonnel+"|"
				
				If (Substring:C12([sgo_operation:110]numero:3; 1; 5)="SIS2A")
					$numeroRef:=Substring:C12([sgo_operation:110]numero:3; 7)
				Else 
					$numeroRef:=[sgo_operation:110]numero:3
				End if 
				$numRapport:=String:C10(Numero_Jour_Annee(Date:C102([sgo_operation:110]date_reception:15)); "000")+Substring:C12($numeroRef; 10; 5)
				CREATE RECORD:C68([PARTICIPATION_AGENT:163])
				[PARTICIPATION_AGENT:163]numero_rapport:2:=$numRapport
				[PARTICIPATION_AGENT:163]Matricule:3:=[crss_agent:99]matricule:10
				[PARTICIPATION_AGENT:163]Nom:4:=[crss_agent:99]nom:11
				[PARTICIPATION_AGENT:163]Prenom:5:=[crss_agent:99]prenom:12
				[PARTICIPATION_AGENT:163]Grade:6:=Grade_Nexsis_vers_Systel([crss_agent:99]code_grade:13)
				[PARTICIPATION_AGENT:163]Vehicule:7:=[crss_engin:106]nom_engin:5
				[PARTICIPATION_AGENT:163]Debut:8:=$heureDebut
				[PARTICIPATION_AGENT:163]Fin:9:=$heureFin
				[PARTICIPATION_AGENT:163]DateDebut:10:=Date:C102($heureDebut)
				[PARTICIPATION_AGENT:163]HeureDebut:11:=Time:C179($heureDebut)
				[PARTICIPATION_AGENT:163]DateFin:12:=Date:C102($heureFin)
				[PARTICIPATION_AGENT:163]HeureFin:13:=Time:C179($heureFin)
				[PARTICIPATION_AGENT:163]TSDebut:14:=4DStmp_Write([PARTICIPATION_AGENT:163]DateDebut:10; [PARTICIPATION_AGENT:163]HeureDebut:11)
				[PARTICIPATION_AGENT:163]TSFin:15:=4DStmp_Write([PARTICIPATION_AGENT:163]DateFin:12; [PARTICIPATION_AGENT:163]HeureFin:13)
				[PARTICIPATION_AGENT:163]UF_rapport:16:=[crss_validation:154]unite_fonctionnelle:8
				[PARTICIPATION_AGENT:163]toDelete:18:=False:C215
				[PARTICIPATION_AGENT:163]statut:19:=$statut
				SAVE RECORD:C53([PARTICIPATION_AGENT:163])
				NEXT RECORD:C51([crss_agent:99])
			End while 
			If ($messageRefus#"")
				$erreurEngin:=True:C214
			End if 
			$ligneEngin:=$ligneEngin+[crss_engin:106]nom_engin:5+"|1|0|0|0|"
			$ligneEngin:=$ligneEngin+Convertit_DateHeure_ISO_vers_DD([crss_engin:106]date_debut_intervention:9)+"|"
			$ligneEngin:=$ligneEngin+Convertit_DateHeure_ISO_vers_DD([crss_engin:106]date_fin_intervention:10)+"|"
			CREATE RECORD:C68([PARTICIPATION_ENGIN:164])
			[PARTICIPATION_ENGIN:164]numero_rapport:5:=$numRapport
			[PARTICIPATION_ENGIN:164]Nom_Vehicule:2:=[crss_engin:106]nom_engin:5
			[PARTICIPATION_ENGIN:164]Debut:3:=[crss_engin:106]date_debut_intervention:9
			[PARTICIPATION_ENGIN:164]Fin:4:=[crss_engin:106]date_fin_intervention:10
			[PARTICIPATION_ENGIN:164]DateDebut:6:=Date:C102([crss_engin:106]date_debut_intervention:9)
			[PARTICIPATION_ENGIN:164]HeureDebut:7:=Time:C179([crss_engin:106]date_debut_intervention:9)
			[PARTICIPATION_ENGIN:164]DateFin:8:=Date:C102([crss_engin:106]date_fin_intervention:10)
			[PARTICIPATION_ENGIN:164]HeureFin:9:=Time:C179([crss_engin:106]date_fin_intervention:10)
			[PARTICIPATION_ENGIN:164]TSDebut:10:=4DStmp_Write([PARTICIPATION_ENGIN:164]DateDebut:6; [PARTICIPATION_ENGIN:164]HeureDebut:7)
			[PARTICIPATION_ENGIN:164]TSFin:11:=4DStmp_Write([PARTICIPATION_ENGIN:164]DateFin:8; [PARTICIPATION_ENGIN:164]HeureFin:9)
			[PARTICIPATION_ENGIN:164]UF_rapport:12:=[crss_validation:154]unite_fonctionnelle:8
			SAVE RECORD:C53([PARTICIPATION_ENGIN:164])
		End if 
		$enginSansPersonnel:=False:C215
		
		NEXT RECORD:C51([crss_engin:106])
	End while 
	
	$ligneEngin:=String:C10(Records in selection:C76([crss_engin:106]))+"|"+$ligneEngin
	$lignePersonnel:=String:C10($nbperso)+"|"+$lignePersonnel
	If ($nbenginsSurInter=0)
		$erreurEngin:=True:C214
		$messageRefus:="Pas de moyen"
	End if 
	If ($nbperso=0)
		$erreurEngin:=True:C214
		$messageRefus:="Pas de personnel"
	End if 
	If ($erreurEngin=False:C215)  // s'il n'y a pas eu d'erreur sur le traitement de l'engin
		// on va chercher le nombre de rapportsfaits pour cette inter
		QUERY:C277([NOMBRE_CRSS:162]; [NOMBRE_CRSS:162]numero_inter:2=[crss_validation:154]numero_operation:21)
		If (Records in selection:C76([NOMBRE_CRSS:162])=0)
			CREATE RECORD:C68([NOMBRE_CRSS:162])
			[NOMBRE_CRSS:162]nombre_crss:3:=0
			[NOMBRE_CRSS:162]numero_inter:2:=[crss_validation:154]numero_operation:21
		End if 
		[NOMBRE_CRSS:162]nombre_crss:3:=[NOMBRE_CRSS:162]nombre_crss:3+1
		SAVE RECORD:C53([NOMBRE_CRSS:162])
		[crss_validation:154]num_renfort:22:=[NOMBRE_CRSS:162]nombre_crss:3
		[crss_validation:154]etat_validation:4:="A PAYER"
		[crss_validation:154]message:14:=""
		SAVE RECORD:C53([crss_validation:154])
		// on rajoute une ligne de données pour générer un CRSS Systel
		Cree_Ligne_Fichier_CRSS($ligneEngin; $lignePersonnel; $numRapport)
	Else 
		[crss_validation:154]etat_validation:4:="A REFUSER"
		[crss_validation:154]message:14:=$messageRefus
		SAVE RECORD:C53([crss_validation:154])
	End if 
	NEXT RECORD:C51([crss_validation:154])
End while 
// s'il y a des crss a traiter

CRSS_Generation_Fichier_Antibia


// on appelle l'API OK/KO de validation des CRSS
Traite_Statut_Paie
