//%attributes = {}
ALL RECORDS:C47([AGENTS:2])
DELETE SELECTION:C66([AGENTS:2])
ALL RECORDS:C47([AFFECTATIONS:3])
DELETE SELECTION:C66([AFFECTATIONS:3])
ALL RECORDS:C47([COMPETENCES:4])
DELETE SELECTION:C66([COMPETENCES:4])

$erreur:=False:C215

$docAgent:=$1
//$docAgent:=Créer document(Dossier 4D(Dossier base)+"ErreursRHAgents.txt"; ".txt")

ALL RECORDS:C47([IMPORT_INDIVIDUS:17])
While (Not:C34(End selection:C36([IMPORT_INDIVIDUS:17])))
	CREATE RECORD:C68([AGENTS:2])
	QUERY:C277([INDIVIDUS:1]; [INDIVIDUS:1]Matricule:10=[IMPORT_INDIVIDUS:17]Matricule:2)
	[AGENTS:2]id_individu:2:=[INDIVIDUS:1]id_individu:2
	Case of 
		: ([IMPORT_INDIVIDUS:17]Cle_Categorie:14=0)
			$idAgent:=[IMPORT_INDIVIDUS:17]Matricule:2+"-0"
		: ([IMPORT_INDIVIDUS:17]Cle_Categorie:14=2)
			$idAgent:=[IMPORT_INDIVIDUS:17]Matricule:2+"-1"
		Else 
			$idAgent:=[IMPORT_INDIVIDUS:17]Matricule:2+"-2"
	End case 
	[AGENTS:2]id_agent:3:=$idAgent
	
	$nom:=Lowercase:C14([IMPORT_INDIVIDUS:17]Nom:3)
	$nom:=Replace string:C233($nom; " "; "")
	//$nom:=Remplacer chaîne([IMPORT_INDIVIDUS]Nom; " "; "-")
	$nom:=Replace string:C233($nom; "'"; "")
	
	$prenom:=Lowercase:C14([IMPORT_INDIVIDUS:17]Prenom:5)
	$prenom:=Replace string:C233($prenom; " "; "")
	//$prenom:=Remplacer chaîne([IMPORT_INDIVIDUS]Prenom; " "; "-")
	$prenom:=Replace string:C233($prenom; "'"; "")
	
	
	$codeGptOps:="OPS"
	
	
	If ([IMPORT_INDIVIDUS:17]numOrdre:18=0)
		[AGENTS:2]id_connexion:4:=$prenom+"."+$nom+Char:C90(Arobase:K15:46)+"sis2a.corsica"
	Else 
		[AGENTS:2]id_connexion:4:=$prenom+"."+$nom+String:C10([IMPORT_INDIVIDUS:17]numOrdre:18)+Char:C90(Arobase:K15:46)+"sis2a.corsica"
	End if 
	[AGENTS:2]matricule:5:=[IMPORT_INDIVIDUS:17]Matricule:2
	QUERY:C277([IMPORT_CATEGORIE:24]; [IMPORT_CATEGORIE:24]Cle:2=[IMPORT_INDIVIDUS:17]Cle_Categorie:14)
	[AGENTS:2]statut:6:=[IMPORT_CATEGORIE:24]code_Ref:4
	QUERY:C277([IMPORT_GRADE:25]; [IMPORT_GRADE:25]cle:2=[IMPORT_INDIVIDUS:17]Cle_Grade:12)
	If (Records in selection:C76([IMPORT_GRADE:25])=0)  // erreur sur le grade
		SEND PACKET:C103($docAgent; "Erreur sur le grade - Mat : "+[IMPORT_INDIVIDUS:17]Matricule:2+"(Fixé à PATS)"+Char:C90(Retour à la ligne:K15:40))
		$erreur:=True:C214
		[AGENTS:2]grade:7:="SIS-CSP-SP-PATS"  // on fixe à PATS pour les sans grade
	Else 
		[AGENTS:2]grade:7:=[IMPORT_GRADE:25]code_Ref:5
	End if 
	SAVE RECORD:C53([AGENTS:2])
	
	
	QUERY:C277([UF:5]; [UF:5]code_Antibia:7=[IMPORT_INDIVIDUS:17]Cle_Corps:13)
	If (Records in selection:C76([UF:5])#0)
		If ([IMPORT_INDIVIDUS:17]Cle_Categorie:14=0) | ([IMPORT_INDIVIDUS:17]Cle_Categorie:14=2)  // si c'est un pompier
			// on envoie une afffectation operationnelle 
			CREATE RECORD:C68([AFFECTATIONS:3])
			[AFFECTATIONS:3]id_affectation:2:=$idAgent+"_"+[UF:5]id_uf:5
			[AFFECTATIONS:3]id_agent:3:=$idAgent
			[AFFECTATIONS:3]id_uf:4:=[UF:5]id_uf:5
			[AFFECTATIONS:3]type:5:="AFFECTATION_OPERATIONNELLE"
			[AFFECTATIONS:3]date_debut:6:=[IMPORT_INDIVIDUS:17]Debut_CIS:25
			[AFFECTATIONS:3]date_fin:7:=""
			SAVE RECORD:C53([AFFECTATIONS:3])
			// et une affectation administrative
			CREATE RECORD:C68([AFFECTATIONS:3])
			[AFFECTATIONS:3]id_affectation:2:=$idAgent+"_"+[UF:5]id_uf:5
			[AFFECTATIONS:3]id_agent:3:=$idAgent
			[AFFECTATIONS:3]id_uf:4:=[UF:5]id_uf:5
			[AFFECTATIONS:3]type:5:="AFFECTATION_ADMINISTRATIVE"
			[AFFECTATIONS:3]date_debut:6:=[IMPORT_INDIVIDUS:17]Debut_CIS:25
			[AFFECTATIONS:3]date_fin:7:=""
			SAVE RECORD:C53([AFFECTATIONS:3])
			// et une affectation applicative 
			CREATE RECORD:C68([AFFECTATIONS:3])
			[AFFECTATIONS:3]id_affectation:2:=$idAgent+"_"+[UF:5]id_uf:5
			[AFFECTATIONS:3]id_agent:3:=$idAgent
			[AFFECTATIONS:3]id_uf:4:=[UF:5]id_uf:5
			[AFFECTATIONS:3]type:5:="AFFECTATION_APPLICATIVE"
			[AFFECTATIONS:3]date_debut:6:=[IMPORT_INDIVIDUS:17]Debut_CIS:25
			[AFFECTATIONS:3]date_fin:7:=""
			SAVE RECORD:C53([AFFECTATIONS:3])
			If ([IMPORT_INDIVIDUS:17]cadre:19=True:C214) & ([UF:5]id_uf:5#$codeGptOps)
				// on envoie une afffectation operationnelle au Gpt OPS s'il n'y en a pas déjà une
				CREATE RECORD:C68([AFFECTATIONS:3])
				[AFFECTATIONS:3]id_affectation:2:=$idAgent+"_"+$codeGptOps
				[AFFECTATIONS:3]id_agent:3:=$idAgent
				[AFFECTATIONS:3]id_uf:4:=$codeGptOps
				[AFFECTATIONS:3]type:5:="AFFECTATION_OPERATIONNELLE"
				[AFFECTATIONS:3]date_debut:6:=[IMPORT_INDIVIDUS:17]Debut_CIS:25
				[AFFECTATIONS:3]date_fin:7:=""
				SAVE RECORD:C53([AFFECTATIONS:3])
			End if 
			
		Else   // PATS
			// on envoie qu'une affectation administrative et une affectation opérationnelle au SIS
			CREATE RECORD:C68([AFFECTATIONS:3])
			[AFFECTATIONS:3]id_affectation:2:=$idAgent+"_"+[UF:5]id_uf:5
			[AFFECTATIONS:3]id_agent:3:=$idAgent
			[AFFECTATIONS:3]id_uf:4:=[UF:5]id_uf:5
			[AFFECTATIONS:3]type:5:="AFFECTATION_ADMINISTRATIVE"
			[AFFECTATIONS:3]date_debut:6:=[IMPORT_INDIVIDUS:17]Debut_CIS:25
			[AFFECTATIONS:3]date_fin:7:=""
			SAVE RECORD:C53([AFFECTATIONS:3])
			CREATE RECORD:C68([AFFECTATIONS:3])
			[AFFECTATIONS:3]id_affectation:2:=$idAgent+"_"+"sis"
			[AFFECTATIONS:3]id_agent:3:=$idAgent
			[AFFECTATIONS:3]id_uf:4:="sis"
			[AFFECTATIONS:3]type:5:="AFFECTATION_OPERATIONNELLE"
			[AFFECTATIONS:3]date_debut:6:=[IMPORT_INDIVIDUS:17]Debut_CIS:25
			[AFFECTATIONS:3]date_fin:7:=""
			SAVE RECORD:C53([AFFECTATIONS:3])
			// et une affectation applicative 
			CREATE RECORD:C68([AFFECTATIONS:3])
			[AFFECTATIONS:3]id_affectation:2:=$idAgent+"_"+"sis"
			[AFFECTATIONS:3]id_agent:3:=$idAgent
			[AFFECTATIONS:3]id_uf:4:="sis"
			[AFFECTATIONS:3]type:5:="AFFECTATION_APPLICATIVE"
			[AFFECTATIONS:3]date_debut:6:=[IMPORT_INDIVIDUS:17]Debut_CIS:25
			[AFFECTATIONS:3]date_fin:7:=""
			SAVE RECORD:C53([AFFECTATIONS:3])
			
		End if 
	Else 
		SEND PACKET:C103($docAgent; "Erreur sur l'affectation - Mat : "+[IMPORT_INDIVIDUS:17]Matricule:2+" - Cle corps :"+[IMPORT_INDIVIDUS:17]Cle_Corps:13+Char:C90(Retour à la ligne:K15:40))
		$erreur:=True:C214
	End if 
	
	// creation des competences
	QUERY:C277([IMPORT_AGENT_COMPET:40]; [IMPORT_AGENT_COMPET:40]cle_pers:3=[IMPORT_INDIVIDUS:17]Cle_Pers:15)
	While (Not:C34(End selection:C36([IMPORT_AGENT_COMPET:40])))
		QUERY:C277([CORRESPONDANCE_COMPETENCES:41]; [CORRESPONDANCE_COMPETENCES:41]CodeCompet_Antibia:3=[IMPORT_AGENT_COMPET:40]cle_comp:2)
		If (Records in selection:C76([CORRESPONDANCE_COMPETENCES:41])#0)
			While (Not:C34(End selection:C36([CORRESPONDANCE_COMPETENCES:41])))
				CREATE RECORD:C68([COMPETENCES:4])
				[COMPETENCES:4]id_affectation:2:=$idAgent+"_"+[UF:5]id_uf:5
				[COMPETENCES:4]competence:3:=[CORRESPONDANCE_COMPETENCES:41]CompetenceNexsis:2
				[COMPETENCES:4]id_agent:5:=$idAgent
				[COMPETENCES:4]Matricule:4:=[IMPORT_INDIVIDUS:17]Matricule:2
				SAVE RECORD:C53([COMPETENCES:4])
				NEXT RECORD:C51([CORRESPONDANCE_COMPETENCES:41])
			End while 
			
		End if 
		NEXT RECORD:C51([IMPORT_AGENT_COMPET:40])
	End while 
	
	// on va aussi générer les compétences dues à un diplome (basé sur le grade)
	Case of 
		: ([AGENTS:2]grade:7="SIS-SSM-SP-INF") | ([AGENTS:2]grade:7="SIS-SSM-SP-IP")
			CREATE RECORD:C68([COMPETENCES:4])
			[COMPETENCES:4]id_affectation:2:=$idAgent+"_"+[UF:5]id_uf:5
			[COMPETENCES:4]competence:3:="INF SSO"
			[COMPETENCES:4]id_agent:5:=$idAgent
			[COMPETENCES:4]Matricule:4:=[IMPORT_INDIVIDUS:17]Matricule:2
			SAVE RECORD:C53([COMPETENCES:4])
		: ([AGENTS:2]grade:7="SIS-SSM-SP-VCD") | ([AGENTS:2]grade:7="SIS-SSM-SP-VCN") | ([AGENTS:2]grade:7="SIS-SSM-SP-VLC")
			CREATE RECORD:C68([COMPETENCES:4])
			[COMPETENCES:4]id_affectation:2:=$idAgent+"_"+[UF:5]id_uf:5
			[COMPETENCES:4]competence:3:="VET"
			[COMPETENCES:4]id_agent:5:=$idAgent
			[COMPETENCES:4]Matricule:4:=[IMPORT_INDIVIDUS:17]Matricule:2
			SAVE RECORD:C53([COMPETENCES:4])
		: ([AGENTS:2]grade:7="SIS-SSM-SP-MCN") | ([AGENTS:2]grade:7="SIS-SSM-SP-MCL") | ([AGENTS:2]grade:7="SIS-SSM-SP-MCD") | ([AGENTS:2]grade:7="SIS-SSM-SP-MLC")
			CREATE RECORD:C68([COMPETENCES:4])
			[COMPETENCES:4]id_affectation:2:=$idAgent+"_"+[UF:5]id_uf:5
			[COMPETENCES:4]competence:3:="MED"
			[COMPETENCES:4]id_agent:5:=$idAgent
			[COMPETENCES:4]Matricule:4:=[IMPORT_INDIVIDUS:17]Matricule:2
			SAVE RECORD:C53([COMPETENCES:4])
			CREATE RECORD:C68([COMPETENCES:4])
			[COMPETENCES:4]id_affectation:2:=$idAgent+"_"+[UF:5]id_uf:5
			[COMPETENCES:4]competence:3:="MED SSO"
			[COMPETENCES:4]id_agent:5:=$idAgent
			[COMPETENCES:4]Matricule:4:=[IMPORT_INDIVIDUS:17]Matricule:2
			SAVE RECORD:C53([COMPETENCES:4])
		: ([AGENTS:2]grade:7="SIS-CSP-SP-COLHC") | ([AGENTS:2]grade:7="SIS-CSP-SP-CGL")
			CREATE RECORD:C68([COMPETENCES:4])
			[COMPETENCES:4]id_affectation:2:=$idAgent+"_"+[UF:5]id_uf:5
			[COMPETENCES:4]competence:3:="DDSIS"
			[COMPETENCES:4]id_agent:5:=$idAgent
			[COMPETENCES:4]Matricule:4:=[IMPORT_INDIVIDUS:17]Matricule:2
			SAVE RECORD:C53([COMPETENCES:4])
			
	End case 
	
	
	NEXT RECORD:C51([IMPORT_INDIVIDUS:17])
End while 





//FERMER DOCUMENT($docAgent)

$0:=$erreur
