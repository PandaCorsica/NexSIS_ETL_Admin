//%attributes = {}
QUERY:C277([crss_agent:99]; [crss_agent:99]active:32=True:C214)
While (Not:C34(End selection:C36([crss_agent:99])))
	If ([crss_agent:99]numero_operation:23="20240115_00038")
		
	End if 
	QUERY:C277([crss_engin:106]; [crss_engin:106]id_engin:2=[crss_agent:99]id_engin:2)
	$erreur:=False:C215
	If (Records in selection:C76([crss_engin:106])=0)
		// erreur
		$erreur:=True:C214
	End if 
	QUERY:C277([crss_validation:154]; [crss_validation:154]id_operation:2=[crss_agent:99]id_operation:22; *)
	QUERY:C277([crss_validation:154]; [crss_validation:154]unite_fonctionnelle:8=[crss_agent:99]code_unite_fonctionnelle:6)
	QUERY:C277([DONNEES_INTERS:158]; [DONNEES_INTERS:158]ID_CRSS_Validation:18=[crss_validation:154]id:1)
	If (Records in selection:C76([DONNEES_INTERS:158])#0) & ($erreur=False:C215)  // on ne s'intéresse quaux inters deja traitées, les autres seront traitées dans un process normal
		$dateCRSS:=[DONNEES_INTERS:158]date_CRSS:6
		$dateRecept:=Date:C102(String:C10(Day of:C23($dateCRSS); "00")+"/"+String:C10(Month of:C24($dateCRSS); "00")+"/"+String:C10(Year of:C25($dateCRSS); "0000"))
		If (Substring:C12([crss_validation:154]numero_operation:21; 1; 5)="SIS2A")
			$numeroRef:=Substring:C12([crss_validation:154]numero_operation:21; 7)
		Else 
			$numeroRef:=[crss_validation:154]numero_operation:21
		End if 
		$numRapport:=String:C10(Numero_Jour_Annee($dateRecept); "000")+Substring:C12($numeroRef; 10; 5)
		// on cherche si la participation engin existe
		QUERY:C277([PARTICIPATION_ENGIN:164]; [PARTICIPATION_ENGIN:164]ID_Donnees_Inter:13=[DONNEES_INTERS:158]ID:1; *)
		QUERY:C277([PARTICIPATION_ENGIN:164]; [PARTICIPATION_ENGIN:164]UF_rapport:12=[crss_agent:99]code_unite_fonctionnelle:6; *)
		QUERY:C277([PARTICIPATION_ENGIN:164]; [PARTICIPATION_ENGIN:164]Nom_Vehicule:2=[crss_agent:99]nom_engin:5)
		If (Records in selection:C76([PARTICIPATION_ENGIN:164])=0)  // l'engin n'a pas été créé pour paiement
			// on le crée
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
		Else 
			[PARTICIPATION_ENGIN:164]Paye:16:=True:C214
		End if 
		SAVE RECORD:C53([PARTICIPATION_ENGIN:164])
		
		QUERY:C277([PARTICIPATION_AGENT:163]; [PARTICIPATION_AGENT:163]ID_Donnees_Inter:17=[DONNEES_INTERS:158]ID:1; *)
		QUERY:C277([PARTICIPATION_AGENT:163]; [PARTICIPATION_AGENT:163]UF_rapport:16=[crss_agent:99]code_unite_fonctionnelle:6; *)
		QUERY:C277([PARTICIPATION_AGENT:163]; [PARTICIPATION_AGENT:163]Matricule:3=[crss_agent:99]matricule:10; *)
		QUERY:C277([PARTICIPATION_AGENT:163]; [PARTICIPATION_AGENT:163]Vehicule:7=[crss_agent:99]nom_engin:5)
		If (Records in selection:C76([PARTICIPATION_AGENT:163])=0)  // l'agent n'a pas été payé
			// on cree une participation agent
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
		Else 
			// on marque l'agent comme payé
			[PARTICIPATION_AGENT:163]Paye:21:=True:C214
		End if 
		SAVE RECORD:C53([PARTICIPATION_AGENT:163])
	End if 
	NEXT RECORD:C51([crss_agent:99])
End while 
