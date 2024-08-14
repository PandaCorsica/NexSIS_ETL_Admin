//%attributes = {}
// cette méthode traite les CRSS qui sont revenus à un état VALIDE ou VALIDE APRES CORRECTION dans la table crss_validation
// [crss_validation]etat_validation peut avoir plusieurs valeurs selon la phase de traitement :
//         - VALIDE : CRSS validé par l'UF mais pas encore passé en traitement
//         - PAS VALIDE :CRSS pas encore validé par l'UF
//         - VALIDE APRES MODIFICATION : CRSS re-validé après avoir été rejeté
//         - EN COURS : CRSS en cours de traitement dans la présente méthode
//         - A PAYER : CRSS dont la forme est conforme après vérification et qui doit donc être transmis à la méthode de paiement
//         - A REFUSER : CRSS qui présente des erreurs bloquantes lors de l'analyse de la conformité des données et qui doit donc repartir en validation dans l'UF
//         - REFUSE : CRSS renvoyé dans l'UF
//         - PAYE : CRSS passé en phase de paiement

// 1) on supprime les crss validés qui relèvent d'inters avant le lancement en prod de NexSIS (1/1/2024)
QUERY:C277([crss_validation:154]; [crss_validation:154]numero_operation:21<"2024")
DELETE SELECTION:C66([crss_validation:154])

//2) on supprime tous les agents qui apparaissent sur les CRSS mais qui avaient été supprimés (valide=faux)
QUERY:C277([crss_agent:99]; [crss_agent:99]active:32=False:C215)
DELETE SELECTION:C66([crss_agent:99])

//3) on supprime tous les engins qui apparaissent sur les CRSS mais qui avaient été supprimés (valide=faux)
QUERY:C277([crss_engin:106]; [crss_engin:106]isActive:46=False:C215)
DELETE SELECTION:C66([crss_engin:106])

//3-1 on recherche les engins saisis manuellement car ils risquent de ne pas avoir toutes les infos de remplies
QUERY:C277([crss_engin:106]; [crss_engin:106]ajout_manuel:44=True:C214)
While (Not:C34(End selection:C36([crss_engin:106])))
	If ([crss_engin:106]date_debut_intervention:9=Null:C1517) | ([crss_engin:106]date_debut_intervention:9="")
		[crss_engin:106]date_debut_intervention:9:=[crss_engin:106]horaire_alerte_initial:13
	End if 
	If ([crss_engin:106]date_debut_intervention:9=Null:C1517) | ([crss_engin:106]date_debut_intervention:9="")
		[crss_engin:106]date_debut_intervention:9:=[crss_engin:106]horaire_alerte_modifie:14
	End if 
	If ([crss_engin:106]date_debut_intervention:9=Null:C1517) | ([crss_engin:106]date_debut_intervention:9="")
		[crss_engin:106]date_debut_intervention:9:=[crss_engin:106]horaire_parti_initial:15
	End if 
	If ([crss_engin:106]date_debut_intervention:9=Null:C1517) | ([crss_engin:106]date_debut_intervention:9="")
		[crss_engin:106]date_debut_intervention:9:=[crss_engin:106]horaire_parti_modifie:16
	End if 
	If ([crss_engin:106]date_fin_intervention:10=Null:C1517) | ([crss_engin:106]date_fin_intervention:10="")
		[crss_engin:106]date_fin_intervention:10:=[crss_engin:106]horaire_fin_initial:42
	End if 
	If ([crss_engin:106]date_fin_intervention:10=Null:C1517) | ([crss_engin:106]date_fin_intervention:10="")
		[crss_engin:106]date_fin_intervention:10:=[crss_engin:106]horaire_fin_modifie:43
	End if 
	If ([crss_engin:106]date_fin_intervention:10=Null:C1517) | ([crss_engin:106]date_fin_intervention:10="")
		[crss_engin:106]date_fin_intervention:10:=[crss_engin:106]horaire_rentre_a_uf_initial:25
	End if 
	If ([crss_engin:106]date_fin_intervention:10=Null:C1517) | ([crss_engin:106]date_fin_intervention:10="")
		[crss_engin:106]date_fin_intervention:10:=[crss_engin:106]horaire_rentre_a_uf_modifie:26
	End if 
	SAVE RECORD:C53([crss_engin:106])
	NEXT RECORD:C51([crss_engin:106])
End while 



// 3-2) on cherche les crss_agent qui n'ont pas de crss_engin id
QUERY:C277([crss_agent:99]; [crss_agent:99]id_engin:2=Null:C1517; *)
QUERY:C277([crss_agent:99];  | ; [crss_agent:99]id_engin:2="")
While (Not:C34(End selection:C36([crss_agent:99])))
	QUERY:C277([crss_engin:106]; [crss_engin:106]numero_operation:34=[crss_agent:99]numero_operation:23; *)
	QUERY:C277([crss_engin:106]; [crss_engin:106]code_unite_fonctionnelle:6=[crss_agent:99]code_unite_fonctionnelle:6; *)
	QUERY:C277([crss_engin:106]; [crss_engin:106]nom_engin:5=[crss_agent:99]nom_engin:5)
	If (Records in selection:C76([crss_engin:106])=1)  // logiquement l'agent n'est que sur un engin
		[crss_agent:99]id_engin:2:=[crss_engin:106]id_engin:2
	Else 
		[crss_agent:99]active:32:=False:C215
		//TRACE
	End if 
	SAVE RECORD:C53([crss_agent:99])
	NEXT RECORD:C51([crss_agent:99])
End while 
QUERY:C277([crss_agent:99]; [crss_agent:99]active:32=False:C215)
DELETE SELECTION:C66([crss_agent:99])


// 4) on récupère les crss validés dans crss_validation
QUERY:C277([crss_validation:154]; [crss_validation:154]etat_validation:4="VALIDE"; *)
QUERY:C277([crss_validation:154];  | ; [crss_validation:154]etat_validation:4="REFUSE"; *)
QUERY:C277([crss_validation:154];  | ; [crss_validation:154]etat_validation:4="PAS VALIDE")
// ATTENTION : prevoir de reprendre également les CRSS en état validation apres correction

//5) on les marque en cours de traitement
APPLY TO SELECTION:C70([crss_validation:154]; [crss_validation:154]etat_validation:4:="EN COURS")

// 6) on va traiter tous ces CRSS qui sont encore dans le statut EN COURS
QUERY:C277([crss_validation:154]; [crss_validation:154]etat_validation:4="EN COURS")
ORDER BY:C49([crss_validation:154]; [crss_validation:154]numero_operation:21; >)
While (Not:C34(End selection:C36([crss_validation:154])))
	//6-1) on crée un enregistrement avec les données relatives à l'intervention
	$dateRecept:=Creation_Donnees_Inter_CRSS
	If ($dateRecept#!00-00-00!)
		//6-2) on va creer les PARTICIPATION ENGIN pour les engins qui ne sont pas en erreur
		$messageRefus:=""
		// on récupère les engins associés à ce CRSS validé dans l'UF
		QUERY:C277([crss_engin:106]; [crss_engin:106]id_operation:33=[crss_validation:154]id_operation:2; *)
		QUERY:C277([crss_engin:106]; [crss_engin:106]code_unite_fonctionnelle:6=[crss_validation:154]unite_fonctionnelle:8)
		If (Records in selection:C76([crss_engin:106])#0)  // s'il y a bien des engins sur cette inter pour cette UF
			// pour chacun de ces engins, on va récupérer le personnel et vérifier que tous les horaires sont corrects
			$erreurEngin:=False:C215
			$ligneEngin:=""
			$lignePersonnel:=""
			$nbperso:=0
			$nbenginsSurInter:=0
			$enginSansPersonnel:=False:C215
			While (Not:C34(End selection:C36([crss_engin:106])))
				// on récupère les données relatives à l'intervention
				QUERY:C277([sgo_operation:110]; [sgo_operation:110]id_operation:2=[crss_engin:106]id_operation:33)
				If ([sgo_operation:110]date_fin:5="") | ([sgo_operation:110]date_fin:5=Null:C1517)
					[sgo_operation:110]date_fin:5:=[crss_engin:106]date_fin_intervention:10
				End if 
				//on va vérifier que les horaires de l'engin sont bien présents
				If ([crss_engin:106]date_debut_intervention:9="") | ([crss_engin:106]date_debut_intervention:9=Null:C1517)  // si la date de début d'inter n'est pas renseignée, 
					$messageRefus:="pas de debut d'inter pour engin : "+[crss_engin:106]nom_engin:5
				End if 
				If ([crss_engin:106]date_fin_intervention:10="") | ([crss_engin:106]date_fin_intervention:10=Null:C1517)  // si la date de fin d'inter n'est pas renseignée
					[crss_engin:106]date_fin_intervention:10:=[crss_engin:106]horaire_rentre_a_uf_modifie:26  // on prend  la date de fin d'inter modifiée
				End if 
				If ([crss_engin:106]date_fin_intervention:10="") | ([crss_engin:106]date_fin_intervention:10=Null:C1517)  // si elle n'est toujours pas renseignée
					[crss_engin:106]date_fin_intervention:10:=[crss_engin:106]horaire_rentre_a_uf_initial:25  // on prend par défaut la date de fin d'inter
				End if 
				If ([crss_engin:106]date_fin_intervention:10="") | ([crss_engin:106]date_fin_intervention:10=Null:C1517)  // si elle n'est toujours pas renseignée
					[crss_engin:106]date_fin_intervention:10:=[sgo_operation:110]date_fin:5  // on prend par défaut la date de fin d'inter sur le sgo
				End if 
				If ([crss_engin:106]date_fin_intervention:10="") | ([crss_engin:106]date_fin_intervention:10=Null:C1517)  // si elle n'est toujours pas renseignée
					$messageRefus:="pas de fin d'inter pour engin : "+[crss_engin:106]nom_engin:5
				End if 
				
				// on vérifie la cohérence des horaires modifiés de l'engin par rapport aux horaires de l'inter
				If (4DStmp_Write(Date:C102([crss_engin:106]date_fin_intervention:10); Time:C179([crss_engin:106]date_fin_intervention:10))>4DStmp_Write(Date:C102([sgo_operation:110]date_fin:5); Time:C179([sgo_operation:110]date_fin:5)))  // si la fin d'inter modifiée sur le crss est après l'heure globale de fin d'intervention
					//$messageRefus:="Horaire de retour modifié de l'engin "+[crss_engin]nom_engin+" non conforme avec la fin de l'intervention"
					[crss_engin:106]date_fin_intervention:10:=[sgo_operation:110]date_fin:5
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
						//6-3) on va creer les PARTICIPATION AGENT pour les agents qui ne sont pas en erreur 
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
						// on vérifie la cohérence du statut  sur le CRSS avec le planning
						
						If ([crss_agent:99]horaire_debut_modifie:18="")
							$heureDebut:=[crss_agent:99]horaire_debut_initial:16
						Else 
							$heureDebut:=[crss_agent:99]horaire_debut_modifie:18
						End if 
						
						If ([crss_agent:99]horaire_fin_modifie:19="")
							$heureFin:=[crss_agent:99]horaire_fin_initial:17
						Else 
							$heureFin:=[crss_agent:99]horaire_fin_modifie:19
						End if 
						
						If (Substring:C12([crss_validation:154]numero_operation:21; 1; 5)="SIS2A")
							$numeroRef:=Substring:C12([crss_validation:154]numero_operation:21; 7)
						Else 
							$numeroRef:=[crss_validation:154]numero_operation:21
						End if 
						$numRapport:=String:C10(Numero_Jour_Annee($dateRecept); "000")+Substring:C12($numeroRef; 10; 5)
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
						[PARTICIPATION_AGENT:163]ID_Donnees_Inter:17:=[DONNEES_INTERS:158]ID:1
						[PARTICIPATION_AGENT:163]Archivage:20:=False:C215
						[PARTICIPATION_AGENT:163]statut:19:=Verifie_Statut_Planning($statut; [PARTICIPATION_AGENT:163]TSDebut:14; [PARTICIPATION_AGENT:163]TSFin:15; [PARTICIPATION_AGENT:163]Matricule:3)
						[PARTICIPATION_AGENT:163]Paye:21:=False:C215
						SAVE RECORD:C53([PARTICIPATION_AGENT:163])
						NEXT RECORD:C51([crss_agent:99])
					End while 
					If ($messageRefus#"")
						$erreurEngin:=True:C214
					End if 
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
					[PARTICIPATION_ENGIN:164]ID_Donnees_Inter:13:=[DONNEES_INTERS:158]ID:1
					[PARTICIPATION_ENGIN:164]Archivage:15:=False:C215
					[PARTICIPATION_ENGIN:164]Paye:16:=False:C215
					SAVE RECORD:C53([PARTICIPATION_ENGIN:164])
				End if 
				$enginSansPersonnel:=False:C215
				NEXT RECORD:C51([crss_engin:106])
			End while 
			
			//6-4 on verifie que tous les engins ont une heure de fin et de début
			QUERY:C277([PARTICIPATION_ENGIN:164]; [PARTICIPATION_ENGIN:164]Debut:3=""; *)
			QUERY:C277([PARTICIPATION_ENGIN:164]; [PARTICIPATION_ENGIN:164]Archivage:15=False:C215)
			While (Not:C34(End selection:C36([PARTICIPATION_ENGIN:164])))
				QUERY:C277([DONNEES_INTERS:158]; [DONNEES_INTERS:158]ID:1=[PARTICIPATION_ENGIN:164]ID_Donnees_Inter:13)
				[PARTICIPATION_ENGIN:164]Debut:3:=[DONNEES_INTERS:158]date_Debut:13
				[PARTICIPATION_ENGIN:164]DateDebut:6:=Date:C102([DONNEES_INTERS:158]date_Debut:13)
				[PARTICIPATION_ENGIN:164]HeureDebut:7:=Time:C179([DONNEES_INTERS:158]date_Debut:13)
				[PARTICIPATION_ENGIN:164]TSDebut:10:=4DStmp_Write([PARTICIPATION_ENGIN:164]DateDebut:6; [PARTICIPATION_ENGIN:164]HeureDebut:7)
				SAVE RECORD:C53([PARTICIPATION_ENGIN:164])
				NEXT RECORD:C51([PARTICIPATION_ENGIN:164])
			End while 
			QUERY:C277([PARTICIPATION_ENGIN:164]; [PARTICIPATION_ENGIN:164]Fin:4=""; *)
			QUERY:C277([PARTICIPATION_ENGIN:164]; [PARTICIPATION_ENGIN:164]Archivage:15=False:C215)
			While (Not:C34(End selection:C36([PARTICIPATION_ENGIN:164])))
				QUERY:C277([DONNEES_INTERS:158]; [DONNEES_INTERS:158]ID:1=[PARTICIPATION_ENGIN:164]ID_Donnees_Inter:13)
				[PARTICIPATION_ENGIN:164]Fin:4:=[DONNEES_INTERS:158]date_Fin:14
				[PARTICIPATION_ENGIN:164]DateFin:8:=Date:C102([DONNEES_INTERS:158]date_Fin:14)
				[PARTICIPATION_ENGIN:164]HeureFin:9:=Time:C179([DONNEES_INTERS:158]date_Fin:14)
				[PARTICIPATION_ENGIN:164]TSFin:11:=4DStmp_Write([PARTICIPATION_ENGIN:164]DateFin:8; [PARTICIPATION_ENGIN:164]HeureFin:9)
				SAVE RECORD:C53([PARTICIPATION_ENGIN:164])
				NEXT RECORD:C51([PARTICIPATION_ENGIN:164])
			End while 
			
			//6-5 on verifie que tous les agents ont une heure de fin et de début
			QUERY:C277([PARTICIPATION_AGENT:163]; [PARTICIPATION_AGENT:163]Debut:8=""; *)
			QUERY:C277([PARTICIPATION_AGENT:163]; [PARTICIPATION_AGENT:163]Archivage:20=False:C215)
			While (Not:C34(End selection:C36([PARTICIPATION_AGENT:163])))
				QUERY:C277([PARTICIPATION_ENGIN:164]; [PARTICIPATION_ENGIN:164]numero_rapport:5=[PARTICIPATION_AGENT:163]numero_rapport:2; *)
				QUERY:C277([PARTICIPATION_ENGIN:164]; [PARTICIPATION_ENGIN:164]DateDebut:6=[PARTICIPATION_AGENT:163]DateDebut:10; *)
				QUERY:C277([PARTICIPATION_ENGIN:164]; [PARTICIPATION_ENGIN:164]Nom_Vehicule:2=[PARTICIPATION_AGENT:163]Vehicule:7)
				[PARTICIPATION_AGENT:163]Debut:8:=[PARTICIPATION_ENGIN:164]Debut:3
				[PARTICIPATION_AGENT:163]DateDebut:10:=Date:C102([PARTICIPATION_ENGIN:164]Debut:3)
				[PARTICIPATION_AGENT:163]HeureDebut:11:=Time:C179([PARTICIPATION_ENGIN:164]Debut:3)
				[PARTICIPATION_AGENT:163]TSDebut:14:=4DStmp_Write([PARTICIPATION_AGENT:163]DateDebut:10; [PARTICIPATION_AGENT:163]HeureDebut:11)
				SAVE RECORD:C53([PARTICIPATION_AGENT:163])
				NEXT RECORD:C51([PARTICIPATION_AGENT:163])
			End while 
			QUERY:C277([PARTICIPATION_AGENT:163]; [PARTICIPATION_AGENT:163]Fin:9=""; *)
			QUERY:C277([PARTICIPATION_AGENT:163]; [PARTICIPATION_AGENT:163]Archivage:20=False:C215)
			While (Not:C34(End selection:C36([PARTICIPATION_AGENT:163])))
				QUERY:C277([PARTICIPATION_ENGIN:164]; [PARTICIPATION_ENGIN:164]numero_rapport:5=[PARTICIPATION_AGENT:163]numero_rapport:2; *)
				QUERY:C277([PARTICIPATION_ENGIN:164]; [PARTICIPATION_ENGIN:164]DateDebut:6=[PARTICIPATION_AGENT:163]DateDebut:10; *)
				QUERY:C277([PARTICIPATION_ENGIN:164]; [PARTICIPATION_ENGIN:164]Nom_Vehicule:2=[PARTICIPATION_AGENT:163]Vehicule:7)
				[PARTICIPATION_AGENT:163]Fin:9:=[PARTICIPATION_ENGIN:164]Fin:4
				[PARTICIPATION_AGENT:163]DateFin:12:=Date:C102([PARTICIPATION_ENGIN:164]Fin:4)
				[PARTICIPATION_AGENT:163]HeureFin:13:=Time:C179([PARTICIPATION_ENGIN:164]Fin:4)
				[PARTICIPATION_AGENT:163]TSFin:15:=4DStmp_Write([PARTICIPATION_AGENT:163]DateFin:12; [PARTICIPATION_AGENT:163]HeureFin:13)
				SAVE RECORD:C53([PARTICIPATION_AGENT:163])
				NEXT RECORD:C51([PARTICIPATION_AGENT:163])
			End while 
			
			
			//6-6 on teste la validité des informations relatives à ce CRSS
			$messageErreur:=Teste_Validite_Donnees_CRSS
			
			//6-7 on supprime les agents qui sont en trop
			RELATE MANY:C262([DONNEES_INTERS:158]ID:1)
			QUERY SELECTION:C341([PARTICIPATION_AGENT:163]; [PARTICIPATION_AGENT:163]toDelete:18=True:C214)
			DELETE SELECTION:C66([PARTICIPATION_AGENT:163])
			
			//6-8 si les données sont valides, on met le crss_validation à A PAYER sinon à A REFUSER
			If ($messageErreur="")  // crss OK
				// on va chercher le nombre de rapports faits pour cette inter
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
				//Cree_Ligne_Fichier_CRSS
			Else   //CRSS avec erreurs
				[crss_validation:154]etat_validation:4:="A REFUSER"
				[crss_validation:154]message:14:=$messageErreur
				SAVE RECORD:C53([crss_validation:154])
				// on supprime toutes les références à ce CRSS qui est refusé
				QUERY:C277([DONNEES_INTERS:158]; [DONNEES_INTERS:158]numInter:4=[crss_validation:154]numero_operation:21; *)
				QUERY:C277([DONNEES_INTERS:158]; [DONNEES_INTERS:158]codeUF:3=[crss_validation:154]unite_fonctionnelle:8)
				RELATE MANY:C262([DONNEES_INTERS:158]ID:1)
				DELETE SELECTION:C66([PARTICIPATION_AGENT:163])
				DELETE SELECTION:C66([PARTICIPATION_ENGIN:164])
				DELETE SELECTION:C66([DONNEES_INTERS:158])
			End if 
		Else 
			[crss_validation:154]etat_validation:4:="A SUPPRIMER"
			SAVE RECORD:C53([crss_validation:154])
		End if 
	Else 
		[crss_validation:154]etat_validation:4:="DIFFERE"
		SAVE RECORD:C53([crss_validation:154])
	End if 
	NEXT RECORD:C51([crss_validation:154])
End while 
//6-9) On supprime tous les crss sans engin
QUERY:C277([crss_validation:154]; [crss_validation:154]etat_validation:4="A SUPPRIMER")
DELETE SELECTION:C66([crss_validation:154])

//7-1)  On va vérifier les recouvrements d'engins
QUERY:C277([PARTICIPATION_ENGIN:164]; [PARTICIPATION_ENGIN:164]Archivage:15=False:C215)
DISTINCT VALUES:C339([PARTICIPATION_ENGIN:164]Nom_Vehicule:2; $TMoyens)
For ($i; 1; Size of array:C274($TMoyens))
	QUERY:C277([PARTICIPATION_ENGIN:164]; [PARTICIPATION_ENGIN:164]Nom_Vehicule:2=$TMoyens{$i}; *)
	QUERY:C277([PARTICIPATION_ENGIN:164]; [PARTICIPATION_ENGIN:164]Archivage:15=False:C215)
	ORDER BY:C49([PARTICIPATION_ENGIN:164]; [PARTICIPATION_ENGIN:164]TSDebut:10; >)
	$tsFinPrecedent:=0
	While (Not:C34(End selection:C36([PARTICIPATION_ENGIN:164])))
		If ([PARTICIPATION_ENGIN:164]TSDebut:10<$tsFinPrecedent)  //& ([PARTICIPATION_AGENT]TSFin>$tsFinPrecedent)
			// si il y a un chevauchement
			[PARTICIPATION_ENGIN:164]TSDebut:10:=$tsFinPrecedent  //
			If ([PARTICIPATION_ENGIN:164]TSDebut:10>=[PARTICIPATION_ENGIN:164]TSFin:11)
				[PARTICIPATION_ENGIN:164]toDelete:14:=True:C214
			End if 
			SAVE RECORD:C53([PARTICIPATION_ENGIN:164])
		End if 
		$tsFinPrecedent:=[PARTICIPATION_ENGIN:164]TSFin:11
		NEXT RECORD:C51([PARTICIPATION_ENGIN:164])
	End while 
End for 
QUERY:C277([PARTICIPATION_ENGIN:164]; [PARTICIPATION_ENGIN:164]toDelete:14=True:C214)
DELETE SELECTION:C66([PARTICIPATION_ENGIN:164])

//7-2)  On va vérifier les recouvrements de personnels
QUERY:C277([PARTICIPATION_AGENT:163]; [PARTICIPATION_AGENT:163]Archivage:20=False:C215)
DISTINCT VALUES:C339([PARTICIPATION_AGENT:163]Matricule:3; $TMatricules)
For ($i; 1; Size of array:C274($TMatricules))
	QUERY:C277([PARTICIPATION_AGENT:163]; [PARTICIPATION_AGENT:163]Matricule:3=$TMatricules{$i}; *)
	QUERY:C277([PARTICIPATION_AGENT:163]; [PARTICIPATION_AGENT:163]Archivage:20=False:C215)
	ORDER BY:C49([PARTICIPATION_AGENT:163]; [PARTICIPATION_AGENT:163]TSDebut:14; >)
	$tsFinPrecedent:=0
	While (Not:C34(End selection:C36([PARTICIPATION_AGENT:163])))
		If ([PARTICIPATION_AGENT:163]TSDebut:14<$tsFinPrecedent)  //& ([PARTICIPATION_AGENT]TSFin>$tsFinPrecedent)
			// si il y a un chevauchement
			[PARTICIPATION_AGENT:163]TSDebut:14:=$tsFinPrecedent  //
			If ([PARTICIPATION_AGENT:163]TSDebut:14>=[PARTICIPATION_AGENT:163]TSFin:15)  //si les horaires sont incohérents
				[PARTICIPATION_AGENT:163]toDelete:18:=True:C214
			End if 
			If ([PARTICIPATION_AGENT:163]TSFin:15<=$tsFinPrecedent)  // si cette inter est pendant une autre
				[PARTICIPATION_AGENT:163]toDelete:18:=True:C214
			End if 
			SAVE RECORD:C53([PARTICIPATION_AGENT:163])
		End if 
		$tsFinPrecedent:=[PARTICIPATION_AGENT:163]TSFin:15
		NEXT RECORD:C51([PARTICIPATION_AGENT:163])
	End while 
End for 
QUERY:C277([PARTICIPATION_AGENT:163]; [PARTICIPATION_AGENT:163]toDelete:18=True:C214)
DELETE SELECTION:C66([PARTICIPATION_AGENT:163])

//7-3) on va regarder si tous les DONNEES_CRSSont bien des horaires de debut et de fin
QUERY:C277([DONNEES_INTERS:158]; [DONNEES_INTERS:158]date_Debut:13=""; *)
QUERY:C277([DONNEES_INTERS:158];  | ; [DONNEES_INTERS:158]date_Fin:14=""; *)
QUERY:C277([DONNEES_INTERS:158]; [DONNEES_INTERS:158]Archivage:19=False:C215)
If (Records in selection:C76([DONNEES_INTERS:158])#0)
	While (Not:C34(End selection:C36([DONNEES_INTERS:158])))
		RELATE MANY:C262([DONNEES_INTERS:158]ID:1)
		QUERY SELECTION:C341([PARTICIPATION_AGENT:163]; [PARTICIPATION_AGENT:163]Archivage:20=False:C215)
		QUERY SELECTION:C341([PARTICIPATION_ENGIN:164]; [PARTICIPATION_ENGIN:164]Archivage:15=False:C215)
		[DONNEES_INTERS:158]date_Debut:13:=Min:C4([PARTICIPATION_ENGIN:164]Debut:3)
		[DONNEES_INTERS:158]date_Fin:14:=Max:C3([PARTICIPATION_ENGIN:164]Fin:4)
		SAVE RECORD:C53([DONNEES_INTERS:158])
		NEXT RECORD:C51([DONNEES_INTERS:158])
	End while 
	
End if 
