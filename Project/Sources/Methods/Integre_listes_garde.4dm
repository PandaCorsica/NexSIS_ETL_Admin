//%attributes = {}
ALL RECORDS:C47([LISTE_GARDE:44])
DELETE SELECTION:C66([LISTE_GARDE:44])

$chemin:=Select document:C905(""; ""; "Selectionnez le fichier de liste de garde à importer "; 0; $TSel)
//$projet:=""

$projet:=DOM Parse XML source:C719(Get 4D folder:C485(Dossier base:K5:14)+"format_import_listes_garde.4si")
IMPORT DATA:C665($TSel{1}; $projet)

ALL RECORDS:C47([LISTE_GARDE:44])
While (Not:C34(End selection:C36([LISTE_GARDE:44])))
	QUERY:C277([AFFECTATIONS:3]; [AFFECTATIONS:3]id_affectation:2=[LISTE_GARDE:44]matricule:2)
	If (Records in selection:C76([AFFECTATIONS:3])=0)  // soit aucune affectation existante soit mauvais statut
		$pos1:=Position:C15("-"; [LISTE_GARDE:44]matricule:2)
		$pos2:=Position:C15("_"; [LISTE_GARDE:44]matricule:2)
		$statutActuel:=Substring:C12([LISTE_GARDE:44]matricule:2; $pos1+1; $pos2-$pos1-1)
		
		$prefixe:=Substring:C12([LISTE_GARDE:44]matricule:2; 1; $pos1-1)
		$suffixe:=Substring:C12([LISTE_GARDE:44]matricule:2; $pos2+1)
		Case of 
			: ($statutActuel="1")
				[LISTE_GARDE:44]matricule:2:=$prefixe+"-0_"+$suffixe
				SAVE RECORD:C53([LISTE_GARDE:44])
			: ($statutActuel="0")
				[LISTE_GARDE:44]matricule:2:=$prefixe+"-1_"+$suffixe
				SAVE RECORD:C53([LISTE_GARDE:44])
			Else 
				
		End case 
		QUERY:C277([AFFECTATIONS:3]; [AFFECTATIONS:3]id_affectation:2=[LISTE_GARDE:44]matricule:2)
		If (Records in selection:C76([AFFECTATIONS:3])=0)  //  aucune affectation existante donc il s'agit d'une affectation OPS non céée dans un autre centre
			CREATE RECORD:C68([AFFECTATIONS:3])
			[AFFECTATIONS:3]id_affectation:2:=[LISTE_GARDE:44]matricule:2
			[AFFECTATIONS:3]id_agent:3:=$prefixe+"-"+$statutActuel
			[AFFECTATIONS:3]id_uf:4:=$suffixe
			[AFFECTATIONS:3]type:5:="AFFECTATION_OPERATIONNELLE"
			SAVE RECORD:C53([AFFECTATIONS:3])
			//  on crée les compétences correspondant à cette nouvelle affectation
			QUERY:C277([COMPETENCES:4]; [COMPETENCES:4]id_affectation:2=[AFFECTATIONS:3]id_agent:3+"@")
			DISTINCT VALUES:C339([COMPETENCES:4]competence:3; $Tcompet)
			For ($i; 1; Size of array:C274($Tcompet))
				CREATE RECORD:C68([COMPETENCES:4])
				[COMPETENCES:4]id_affectation:2:=[LISTE_GARDE:44]matricule:2
				[COMPETENCES:4]competence:3:=$Tcompet{$i}
				[COMPETENCES:4]id_agent:5:=[AFFECTATIONS:3]id_agent:3
				[COMPETENCES:4]Matricule:4:=[LISTE_GARDE:44]matricule:2
				SAVE RECORD:C53([COMPETENCES:4])
			End for 
			
		End if 
	End if 
	NEXT RECORD:C51([LISTE_GARDE:44])
End while 
