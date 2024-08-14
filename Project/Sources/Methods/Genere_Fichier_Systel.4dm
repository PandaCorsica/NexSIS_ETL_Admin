//%attributes = {}
$erreur:=False:C215
If (vCheminFichier#"")
	$long:=Length:C16($1)
	$nomFichier:=Substring:C12($1; $long-11; 8)
	$chemin:=Substring:C12($1; 1; $long-12)
Else 
	$valeur_defaut:=""
	vChemin_Log:=Select document:C905($valeur_defaut; "log"; "Selectionnez le fichier log d'origine"; 0; $TChemin)
	If (OK=1)
		vCheminFichier:=$TChemin{1}
		$long:=Length:C16(vCheminFichier)
		$nomFichier:=Substring:C12(vCheminFichier; $long-11; 8)
		$chemin:=Substring:C12(vCheminFichier; 1; $long-12)
	Else 
		$erreur:=True:C214
	End if 
End if 

If ($erreur=False:C215)
	If (Test path name:C476($chemin+"new_"+$nomFichier+".txt")=Est un document:K24:1)
		DELETE DOCUMENT:C159($chemin+"new_"+$nomFichier+".txt")
	End if 
	$refDoc:=Create document:C266($chemin+"new_"+$nomFichier+".txt")
	USE CHARACTER SET:C205("iso-8859-1"; 0)
	
	ALL RECORDS:C47([DONNEES_INTERS:158])
	While (Not:C34(End selection:C36([DONNEES_INTERS:158])))
		RELATE MANY:C262([DONNEES_INTERS:158])
		
		
		$dataToSend:=[DONNEES_INTERS:158]Annee_Intervention:50+"|"  // L'année sur 2 chiffres
		SEND PACKET:C103($refDoc; $dataToSend)
		$dataToSend:=String:C10([DONNEES_INTERS:158]Numero_Rapport:4; "00000000")+"|"  // le numero de rapport 3 chiffres = jour annee + 5 chiffres rapport
		SEND PACKET:C103($refDoc; $dataToSend)
		$dataToSend:=String:C10([DONNEES_INTERS:158]Numero_Renfort:5; "00")+"|"  //"00" pour tester
		SEND PACKET:C103($refDoc; $dataToSend)
		SEND PACKET:C103($refDoc; [DONNEES_INTERS:158]Indice_Rapport:51+"|")  // 0 pour tester
		SEND PACKET:C103($refDoc; [DONNEES_INTERS:158]Annexes:52+"|")  // "0"
		SEND PACKET:C103($refDoc; [DONNEES_INTERS:158]Caractere_Prive:53+"|")  // 0
		If ([DONNEES_INTERS:158]Numero_Centre:6<100)
			$dataToSend:=String:C10([DONNEES_INTERS:158]Numero_Centre:6; "00")+" "+"|"  // numero du centre Systel
		Else 
			$dataToSend:=String:C10([DONNEES_INTERS:158]Numero_Centre:6; "000")+"|"  // numero du centre Systel
		End if 
		SEND PACKET:C103($refDoc; $dataToSend)
		SEND PACKET:C103($refDoc; [DONNEES_INTERS:158]Nom_Centre:7+"|")  // nom de l'UF
		$dataToSend:=String:C10([DONNEES_INTERS:158]Numero_Sortie_CIS:8)+"|"  // 0 pour tester
		//$dataToSend:=Chaine([DONNEES_INTERS]Numero_Sortie_CIS;"00000")+"|"
		SEND PACKET:C103($refDoc; $dataToSend)
		SEND PACKET:C103($refDoc; [DONNEES_INTERS:158]INSEE_Commune:9+"|")  // code INSEE de la commune
		SEND PACKET:C103($refDoc; [DONNEES_INTERS:158]Nom_Commune:10+"|")  // nom de la commune
		SEND PACKET:C103($refDoc; [DONNEES_INTERS:158]Numero_Rue:54+"|")
		SEND PACKET:C103($refDoc; [DONNEES_INTERS:158]Type_Lieu:55+"|")
		SEND PACKET:C103($refDoc; [DONNEES_INTERS:158]Nom_Lieu:11+"|")
		SEND PACKET:C103($refDoc; [DONNEES_INTERS:158]Niveau:56+"|")
		SEND PACKET:C103($refDoc; [DONNEES_INTERS:158]Distance:57+"|")
		SEND PACKET:C103($refDoc; [DONNEES_INTERS:158]Police_Gie_Smur:58+"|")
		SEND PACKET:C103($refDoc; String:C10([DONNEES_INTERS:158]Nb_CIS_Sortis:59)+"|")
		//ENVOYER PAQUET($refDoc;Chaine([DONNEES_INTERS]Nb_CIS_Sortis;"00")+"|")
		While (Not:C34(End selection:C36([CIS_SORTIS])))
			SEND PACKET:C103($refDoc; [CIS_SORTIS]Code_CIS+"|")
			NEXT RECORD:C51([CIS_SORTIS])
		End while 
		
		
		Envoyer_Date_Heure($refDoc; [DONNEES_INTERS:158]Date_DS:12; [DONNEES_INTERS:158]Heure_DS:13)
		Envoyer_Date_Heure($refDoc; [DONNEES_INTERS:158]Date_Decl:14; [DONNEES_INTERS:158]Heure_Decl:15)
		Envoyer_Date_Heure($refDoc; [DONNEES_INTERS:158]Date_Acquit:60; [DONNEES_INTERS:158]Heure_Acquit:61)
		Envoyer_Date_Heure($refDoc; [DONNEES_INTERS:158]Date_1er_Dep:16; [DONNEES_INTERS:158]Heure_1er_Dep:17)
		Envoyer_Date_Heure($refDoc; [DONNEES_INTERS:158]Date_1er_SLL:18; [DONNEES_INTERS:158]Heure_1er_SLL:19)
		Envoyer_Date_Heure($refDoc; [DONNEES_INTERS:158]Date_Fin_Inter:20; [DONNEES_INTERS:158]Heure_Fin_Inter:21)
		
		
		SEND PACKET:C103($refDoc; [DONNEES_INTERS:158]Code_Motif:22+"|")
		SEND PACKET:C103($refDoc; [DONNEES_INTERS:158]Motif:23+"|")
		SEND PACKET:C103($refDoc; [DONNEES_INTERS:158]Niveau_General:62+"|")
		SEND PACKET:C103($refDoc; [DONNEES_INTERS:158]Precision_Lieu:63+"|")
		SEND PACKET:C103($refDoc; [DONNEES_INTERS:158]Facteur_Responsable:64+"|")
		SEND PACKET:C103($refDoc; [DONNEES_INTERS:158]Element_Origine:65+"|")
		SEND PACKET:C103($refDoc; [DONNEES_INTERS:158]Agent_Propagation:66+"|")
		SEND PACKET:C103($refDoc; [DONNEES_INTERS:158]Materiau_Propagation:67+"|")
		SEND PACKET:C103($refDoc; String:C10([DONNEES_INTERS:158]Nombre_Actions:68)+"|")
		While (Not:C34(End selection:C36([ACTIONS_MENEES])))
			SEND PACKET:C103($refDoc; String:C10([ACTIONS_MENEES]Code_Action)+"|")
			//ENVOYER PAQUET($refDoc;Chaine([ACTIONS_MENEES]Code_Action;"000")+"|")
			SEND PACKET:C103($refDoc; [ACTIONS_MENEES]Libelle+"|")
			NEXT RECORD:C51([ACTIONS_MENEES])
		End while 
		SEND PACKET:C103($refDoc; String:C10([DONNEES_INTERS:158]Nombre_Elements_Impliques:69)+"|")
		While (Not:C34(End selection:C36([ELEMENTS_IMPLIQUES])))
			SEND PACKET:C103($refDoc; String:C10([ELEMENTS_IMPLIQUES]Code_Element)+"|")
			//ENVOYER PAQUET($refDoc;Chaine([ELEMENTS_IMPLIQUES]Code_Element;"000")+"|")
			SEND PACKET:C103($refDoc; [ELEMENTS_IMPLIQUES]Libelle+"|")
			NEXT RECORD:C51([ELEMENTS_IMPLIQUES])
		End while 
		
		SEND PACKET:C103($refDoc; [DONNEES_INTERS:158]Nombre_Decedes:70+"|")
		SEND PACKET:C103($refDoc; [DONNEES_INTERS:158]Nombre_Graves:71+"|")
		SEND PACKET:C103($refDoc; [DONNEES_INTERS:158]Nombre_Legers:72+"|")
		SEND PACKET:C103($refDoc; [DONNEES_INTERS:158]Nombre_Indemnes:73+"|")
		SEND PACKET:C103($refDoc; [DONNEES_INTERS:158]Enquete:74+"|")
		SEND PACKET:C103($refDoc; String:C10([DONNEES_INTERS:158]Nb_Victimes:24)+"|")
		//ENVOYER PAQUET($refDoc;Chaine([DONNEES_INTERS]Nb_Victimes;"00")+"|")
		While (Not:C34(End selection:C36([VICTIMES])))
			SEND PACKET:C103($refDoc; [VICTIMES]Nom+"|")
			SEND PACKET:C103($refDoc; [VICTIMES]Prenom+"|")
			SEND PACKET:C103($refDoc; [VICTIMES]Numero_Rue+"|")
			SEND PACKET:C103($refDoc; [VICTIMES]Type_Lieu+"|")
			SEND PACKET:C103($refDoc; [VICTIMES]Nom_Lieu+"|")
			SEND PACKET:C103($refDoc; [VICTIMES]Commune+"|")
			SEND PACKET:C103($refDoc; [VICTIMES]Departement+"|")
			SEND PACKET:C103($refDoc; [VICTIMES]A+"|")
			SEND PACKET:C103($refDoc; [VICTIMES]B+"|")
			SEND PACKET:C103($refDoc; [VICTIMES]C+"|")
			SEND PACKET:C103($refDoc; [VICTIMES]D+"|")
			SEND PACKET:C103($refDoc; [VICTIMES]E+"|")
			SEND PACKET:C103($refDoc; [VICTIMES]F+"|")
			SEND PACKET:C103($refDoc; [VICTIMES]G+"|")
			SEND PACKET:C103($refDoc; [VICTIMES]H+"|")
			SEND PACKET:C103($refDoc; [VICTIMES]I+"|")
			SEND PACKET:C103($refDoc; [VICTIMES]J+"|")
			SEND PACKET:C103($refDoc; [VICTIMES]K+"|")
			SEND PACKET:C103($refDoc; [VICTIMES]L+"|")
			SEND PACKET:C103($refDoc; [VICTIMES]M+"|")
			SEND PACKET:C103($refDoc; [VICTIMES]N+"|")
			SEND PACKET:C103($refDoc; [VICTIMES]Etat_General+"|")
			SEND PACKET:C103($refDoc; [VICTIMES]Hopital+"|")
			NEXT RECORD:C51([VICTIMES])
		End while 
		
		SEND PACKET:C103($refDoc; [DONNEES_INTERS:158]Moyen_Appel:75+"|")
		SEND PACKET:C103($refDoc; [DONNEES_INTERS:158]Provenant_de:76+"|")
		SEND PACKET:C103($refDoc; [DONNEES_INTERS:158]Date_Der_Visite:77+"|")
		SEND PACKET:C103($refDoc; [DONNEES_INTERS:158]Reglementation:78+"|")
		SEND PACKET:C103($refDoc; [DONNEES_INTERS:158]Moyen_Prot_1:79+"|")
		SEND PACKET:C103($refDoc; [DONNEES_INTERS:158]Moyen_Prot_2:80+"|")
		SEND PACKET:C103($refDoc; [DONNEES_INTERS:158]Moyen_Prot_3:81+"|")
		SEND PACKET:C103($refDoc; [DONNEES_INTERS:158]Moyen_Prot_4:82+"|")
		SEND PACKET:C103($refDoc; [DONNEES_INTERS:158]Efficacite:83+"|")
		SEND PACKET:C103($refDoc; String:C10([DONNEES_INTERS:158]Nb_Lignes_Enquete:84)+"|")
		//ENVOYER PAQUET($refDoc;Chaine([DONNEES_INTERS]Nb_Lignes_Enquete;"00")+"|")
		While (Not:C34(End selection:C36([ENQUETE])))
			SEND PACKET:C103($refDoc; [ENQUETE]Code_Ligne+"|")
			SEND PACKET:C103($refDoc; [ENQUETE]Texte_Ligne+"|")
			NEXT RECORD:C51([ENQUETE])
		End while 
		SEND PACKET:C103($refDoc; [DONNEES_INTERS:158]Hommes_Heures:107+"|")
		
		
		SEND PACKET:C103($refDoc; String:C10([DONNEES_INTERS:158]Nombre_Engins:25)+"|")
		//ENVOYER PAQUET($refDoc;Chaine([DONNEES_INTERS]Nombre_Engins;"00")+"|")
		While (Not:C34(End selection:C36([ENGINS_CRSS])))
			SEND PACKET:C103($refDoc; [ENGINS_CRSS]Nom_Engin+"|")
			SEND PACKET:C103($refDoc; [ENGINS_CRSS]Numero_Depart+"|")
			SEND PACKET:C103($refDoc; [ENGINS_CRSS]Code_Utilisation+"|")
			SEND PACKET:C103($refDoc; [ENGINS_CRSS]Duree_Utilisation+"|")
			SEND PACKET:C103($refDoc; [ENGINS_CRSS]Kilometrage+"|")
			Envoyer_Date_Heure($refDoc; [ENGINS_CRSS]Date_Depart; [ENGINS_CRSS]Heure_Depart)
			Envoyer_Date_Heure($refDoc; [ENGINS_CRSS]Date_Retour; [ENGINS_CRSS]Heure_Retour)
			NEXT RECORD:C51([ENGINS_CRSS])
		End while 
		
		SEND PACKET:C103($refDoc; String:C10([DONNEES_INTERS:158]Nombre _Personnels:26)+"|")
		//ENVOYER PAQUET($refDoc;Chaine([DONNEES_INTERS]Nombre _Personnels;"00")+"|")
		While (Not:C34(End selection:C36([PERSONNELS_CRSS])))
			SEND PACKET:C103($refDoc; String:C10([PERSONNELS_CRSS]Matricule)+"|")
			//ENVOYER PAQUET($refDoc;Chaine([PERSONNELS_CRSS]Matricule;"0000000")+"|")
			SEND PACKET:C103($refDoc; [PERSONNELS_CRSS]Nom+"|")
			SEND PACKET:C103($refDoc; [PERSONNELS_CRSS]Prenom+"|")
			SEND PACKET:C103($refDoc; [PERSONNELS_CRSS]Categorie+"|")
			SEND PACKET:C103($refDoc; [PERSONNELS_CRSS]Grade+"|")
			SEND PACKET:C103($refDoc; [PERSONNELS_CRSS]Nom_Vehicule+"|")
			SEND PACKET:C103($refDoc; [PERSONNELS_CRSS]Numero _Depart_Engin+"|")
			SEND PACKET:C103($refDoc; "0"+"|")  // [PERSONNELS_CRSS]RS+"|") on force RS à 0 car traitement à part par Antibia pour RS
			SEND PACKET:C103($refDoc; "1"+"|")  // [PERSONNELS_CRSS]PI+"|")  on force PI à 1
			SEND PACKET:C103($refDoc; [PERSONNELS_CRSS]Releves+"|")
			SEND PACKET:C103($refDoc; [PERSONNELS_CRSS]Renfort+"|")
			SEND PACKET:C103($refDoc; [PERSONNELS_CRSS]SD+"|")
			SEND PACKET:C103($refDoc; [PERSONNELS_CRSS]Info1+"|")
			SEND PACKET:C103($refDoc; [PERSONNELS_CRSS]Info2+"|")
			SEND PACKET:C103($refDoc; [PERSONNELS_CRSS]Info3+"|")
			SEND PACKET:C103($refDoc; [PERSONNELS_CRSS]Info4+"|")
			NEXT RECORD:C51([PERSONNELS_CRSS])
		End while 
		
		SEND PACKET:C103($refDoc; String:C10([DONNEES_INTERS:158]Nombre_Releves:85)+"|")
		QUERY:C277([RELEVES]; [RELEVES]ID_Inter=[DONNEES_INTERS:158]ID:1)
		ORDER BY:C49([RELEVES]; [RELEVES]Numero_Releve; >)
		FIRST RECORD:C50([RELEVES])
		While (Not:C34(End selection:C36([RELEVES])))
			SEND PACKET:C103($refDoc; String:C10([RELEVES]Numero_Releve)+"|")
			Envoyer_Date_Heure($refDoc; [RELEVES]Date_Debut_Releve; [RELEVES]Heure_Debut_Releve)
			Envoyer_Date_Heure($refDoc; [RELEVES]Date_Fin_Releve; [RELEVES]Heure_Fin_Releve)
			NEXT RECORD:C51([RELEVES])
		End while 
		
		Envoyer_Date_Heure($refDoc; [DONNEES_INTERS:158]Date_Debut_Renfort:86; [DONNEES_INTERS:158]Heure_Debut_Renfort:87)
		Envoyer_Date_Heure($refDoc; [DONNEES_INTERS:158]Date_Fin_Renfort:88; [DONNEES_INTERS:158]Heure_Fin_Renfort:89)
		Envoyer_Date_Heure($refDoc; [DONNEES_INTERS:158]Date_Debut_SD:90; [DONNEES_INTERS:158]Heure_Debut_SD:91)
		Envoyer_Date_Heure($refDoc; [DONNEES_INTERS:158]Date_Fin_SD:92; [DONNEES_INTERS:158]Heure_Fin_SD:93)
		
		SEND PACKET:C103($refDoc; String:C10([DONNEES_INTERS:158]Nombre_Sinistres:94)+"|")
		While (Not:C34(End selection:C36([SINISTRES])))
			SEND PACKET:C103($refDoc; [SINISTRES]Nom+"|")
			SEND PACKET:C103($refDoc; [SINISTRES]Prenom+"|")
			SEND PACKET:C103($refDoc; [SINISTRES]Numero_Rue+"|")
			SEND PACKET:C103($refDoc; [SINISTRES]Type_Lieu+"|")
			SEND PACKET:C103($refDoc; [SINISTRES]Nom_Lieu+"|")
			SEND PACKET:C103($refDoc; [SINISTRES]Commune+"|")
			SEND PACKET:C103($refDoc; [SINISTRES]Departement+"|")
			NEXT RECORD:C51([SINISTRES])
		End while 
		
		SEND PACKET:C103($refDoc; [DONNEES_INTERS:158]Nom_Proprietaire:95+"|")
		SEND PACKET:C103($refDoc; [DONNEES_INTERS:158]Prenom_Proprietaire:96+"|")
		SEND PACKET:C103($refDoc; [DONNEES_INTERS:158]Numero_Rue_Proprietaire:97+"|")
		SEND PACKET:C103($refDoc; [DONNEES_INTERS:158]Type_Lieu_Proprietaire:98+"|")
		SEND PACKET:C103($refDoc; [DONNEES_INTERS:158]Nom_Lieu_Proprietaire:99+"|")
		SEND PACKET:C103($refDoc; [DONNEES_INTERS:158]Commune_Proprietaire:100+"|")
		SEND PACKET:C103($refDoc; [DONNEES_INTERS:158]Departement_Proprietaire:101+"|")
		
		SEND PACKET:C103($refDoc; String:C10([DONNEES_INTERS:158]Nombre_Personnalites:102)+"|")
		//ENVOYER PAQUET($refDoc;Chaine([DONNEES_INTERS]Nombre_Personnalites;"00")+"|")
		While (Not:C34(End selection:C36([PERSONNALITES])))
			SEND PACKET:C103($refDoc; [PERSONNALITES]Nom+"|")
			NEXT RECORD:C51([PERSONNALITES])
		End while 
		
		SEND PACKET:C103($refDoc; String:C10([DONNEES_INTERS:158]Nb_Lignes_CR:103)+"|")
		//ENVOYER PAQUET($refDoc;Chaine([DONNEES_INTERS]Nb_Lignes_CR;"00")+"|")
		While (Not:C34(End selection:C36([CR])))
			SEND PACKET:C103($refDoc; [CR]Ligne+"|")
			NEXT RECORD:C51([CR])
		End while 
		
		SEND PACKET:C103($refDoc; [DONNEES_INTERS:158]Matricule_Redacteur:104+"|")
		SEND PACKET:C103($refDoc; [DONNEES_INTERS:158]Nom_Redacteur:105+"|")
		SEND PACKET:C103($refDoc; [DONNEES_INTERS:158]Prenom_Redacteur:106+Char:C90(Retour chariot:K15:38)+Char:C90(Retour à la ligne:K15:40))
		
		NEXT RECORD:C51([DONNEES_INTERS:158])
	End while 
	CLOSE DOCUMENT:C267($refDoc)
	USE CHARACTER SET:C205(*; 0)
End if 
$0:=$erreur