//%attributes = {}
ALL RECORDS:C47([INDIVIDUS:1])
DELETE SELECTION:C66([INDIVIDUS:1])
$error:=False:C215

// creation du fichier d'erreurs
$doc:=$1
//$doc:=Créer document(Dossier 4D(Dossier base)+"erreursRHIndividus.txt"; ".txt")
If (OK=1)
	SEND PACKET:C103($doc; "Nom"+Char:C90(Tabulation:K15:37))
	SEND PACKET:C103($doc; "Prenom"+Char:C90(Tabulation:K15:37))
	SEND PACKET:C103($doc; "Secu"+Char:C90(Tabulation:K15:37))
	SEND PACKET:C103($doc; "Naissance"+Char:C90(Tabulation:K15:37))
	SEND PACKET:C103($doc; "pays"+Char:C90(Tabulation:K15:37))
	SEND PACKET:C103($doc; "lieu naissance"+Char:C90(Tabulation:K15:37))
	SEND PACKET:C103($doc; "erreur"+Char:C90(Retour à la ligne:K15:40))
	
	ARRAY TEXT:C222($TMat; 0)
	ARRAY TEXT:C222($TCode; 0)
	ALL RECORDS:C47([IMPORT_INDIVIDUS:17])
	While (Not:C34(End selection:C36([IMPORT_INDIVIDUS:17])))
		CREATE RECORD:C68([INDIVIDUS:1])
		// on regarde déjà si le numero SS correcpond bien à la personne
		$numsecuOK:=True:C214
		// partie sexe
		If (Substring:C12([IMPORT_INDIVIDUS:17]num_secu:17; 1; 1)="1") & ([IMPORT_INDIVIDUS:17]Sexe:11#"M")
			$numsecuOK:=False:C215
		End if 
		If (Substring:C12([IMPORT_INDIVIDUS:17]num_secu:17; 1; 1)="2") & ([IMPORT_INDIVIDUS:17]Sexe:11#"F")
			$numsecuOK:=False:C215
		End if 
		// partie annee-mois
		$anneenais:=Substring:C12(String:C10(Year of:C25(Date:C102([IMPORT_INDIVIDUS:17]Date_naissance:6))); 3; 2)
		$moisnais:=String:C10(Month of:C24(Date:C102([IMPORT_INDIVIDUS:17]Date_naissance:6)); "00")
		If (Substring:C12([IMPORT_INDIVIDUS:17]num_secu:17; 2; 4)#($anneenais+$moisnais))
			$numsecuOK:=False:C215
		End if 
		// partie departement
		If ([IMPORT_INDIVIDUS:17]CP_naissance:10#"")
			$deptnais:=Substring:C12([IMPORT_INDIVIDUS:17]CP_naissance:10; 1; 2)
			If ([IMPORT_INDIVIDUS:17]CP_naissance:10="98000")  // cas de la naissance à monaco
				$deptnais:="99"
			End if 
			If ($deptnais="20")
				If (Num:C11(Substring:C12([IMPORT_INDIVIDUS:17]CP_naissance:10; 3))<200)
					//  corse du sud
					$deptnais:="2A"
				Else 
					$deptnais:="2B"
				End if 
			End if 
		Else 
			$deptnais:=Substring:C12([IMPORT_INDIVIDUS:17]num_secu:17; 6; 2)
		End if 
		
		If (Substring:C12([IMPORT_INDIVIDUS:17]num_secu:17; 6; 2)#$deptnais)
			If (Substring:C12([IMPORT_INDIVIDUS:17]num_secu:17; 6; 2)="2A") | (Substring:C12([IMPORT_INDIVIDUS:17]num_secu:17; 6; 2)="2B") | ($deptnais="2A") | ($deptnais="2B")
				// c'est normal
			Else 
				
			End if 
		Else 
			If ((Substring:C12([IMPORT_INDIVIDUS:17]num_secu:17; 6; 2)="20") & (($deptnais="2A") | ($deptnais="2B")))
				$numsecuOK:=False:C215
			End if 
		End if 
		$inseeCommune:=Substring:C12([IMPORT_INDIVIDUS:17]num_secu:17; 8; 3)
		
		$erreur:=Not:C34($numsecuOK)
		
		If ($numsecuOK)
			If ($deptnais="99")
				// naissance à l'étranger
				If ($inseeCommune="353") | ($inseeCommune="354") | ($inseeCommune="355")
					$inseeCommune:="352"
				End if 
				// le code INSEE commune correspond au code INSEE du pays
				QUERY:C277([PAYS:19]; [PAYS:19]insee:7=$inseeCommune)
				If (Records in selection:C76([PAYS:19])=1)
					[INDIVIDUS:1]pays_naissance:7:=[PAYS:19]code_iso2:5
					QUERY:C277([VILLES_ETRANGER:30]; [VILLES_ETRANGER:30]CodePays:2=[PAYS:19]code_iso2:5; *)
					QUERY:C277([VILLES_ETRANGER:30]; [VILLES_ETRANGER:30]Nom:3=[IMPORT_INDIVIDUS:17]Lieu _naissance:9)
					If (Records in selection:C76([VILLES_ETRANGER:30])=0)
						QUERY:C277([VILLES_ETRANGER:30]; [VILLES_ETRANGER:30]CodePays:2=[PAYS:19]code_iso2:5; *)
						QUERY:C277([VILLES_ETRANGER:30]; [VILLES_ETRANGER:30]Capitale:5=True:C214)
						If (Records in selection:C76([VILLES_ETRANGER:30])=0)
							//TRACE
						End if 
						$stringCommuneEtranger:=[VILLES_ETRANGER:30]CodeVille:4
					Else 
						$stringCommuneEtranger:=[VILLES_ETRANGER:30]CodeVille:4
					End if 
					[INDIVIDUS:1]commune_naissance:8:=[PAYS:19]code_iso2:5+" "+$stringCommuneEtranger
				Else 
					//ALERTE("pays non trouvé : "+[IMPORT_INDIVIDUS]Nom+" "+[IMPORT_INDIVIDUS]Prenom)
					SEND PACKET:C103($doc; [IMPORT_INDIVIDUS:17]Nom:3+Char:C90(Tabulation:K15:37))
					SEND PACKET:C103($doc; [IMPORT_INDIVIDUS:17]Prenom:5+Char:C90(Tabulation:K15:37))
					SEND PACKET:C103($doc; [IMPORT_INDIVIDUS:17]num_secu:17+Char:C90(Tabulation:K15:37))
					SEND PACKET:C103($doc; [IMPORT_INDIVIDUS:17]Date_naissance:6+Char:C90(Tabulation:K15:37))
					SEND PACKET:C103($doc; $inseeCommune+Char:C90(Tabulation:K15:37))
					SEND PACKET:C103($doc; [IMPORT_INDIVIDUS:17]Lieu _naissance:9+Char:C90(Tabulation:K15:37))
					SEND PACKET:C103($doc; "pays non trouvé"+Char:C90(Retour à la ligne:K15:40))
					$error:=True:C214
					[INDIVIDUS:1]commune_naissance:8:=""
					[INDIVIDUS:1]pays_naissance:7:=""
				End if 
			Else 
				
				If ($deptnais="75") & (Num:C11($inseeCommune)>=101) & (Num:C11($inseeCommune)<=120)  // naissance à Paris
					$inseeCommune:="056"
				End if 
				If ($deptnais="69") & (Num:C11($inseeCommune)>=381) & (Num:C11($inseeCommune)<=389)  // naissance à Lyon
					$inseeCommune:="123"
				End if 
				If ($deptnais="13") & (Num:C11($inseeCommune)=155)  // naissance à Marseille
					$inseeCommune:="055"
				End if 
				If ($deptnais="13") & (Num:C11($inseeCommune)>=201) & (Num:C11($inseeCommune)<=2016)  // naissance à Marseile (arrondissements)
					$inseeCommune:="055"
				End if 
				// naissance en france
				QUERY:C277([COMMUNES_INSEE:18]; [COMMUNES_INSEE:18]Code_Insee:3=$deptnais+$inseeCommune)
				If (Records in selection:C76([COMMUNES_INSEE:18])>0)
					[INDIVIDUS:1]commune_naissance:8:=[COMMUNES_INSEE:18]Code_Insee:3
				Else 
					$erreur:=True:C214
					SEND PACKET:C103($doc; [IMPORT_INDIVIDUS:17]Nom:3+Char:C90(Tabulation:K15:37))
					SEND PACKET:C103($doc; [IMPORT_INDIVIDUS:17]Prenom:5+Char:C90(Tabulation:K15:37))
					SEND PACKET:C103($doc; [IMPORT_INDIVIDUS:17]num_secu:17+Char:C90(Tabulation:K15:37))
					SEND PACKET:C103($doc; [IMPORT_INDIVIDUS:17]Date_naissance:6+Char:C90(Tabulation:K15:37))
					SEND PACKET:C103($doc; $inseeCommune+Char:C90(Tabulation:K15:37))
					SEND PACKET:C103($doc; [IMPORT_INDIVIDUS:17]Lieu _naissance:9+Char:C90(Tabulation:K15:37))
					SEND PACKET:C103($doc; "commune insee non trouvée"+Char:C90(Retour à la ligne:K15:40))
					$error:=True:C214
					FORM SET INPUT:C55([IMPORT_INDIVIDUS:17]; "dept_commune")
					//MODIFIER ENREGISTREMENT([IMPORT_INDIVIDUS])
					If (False:C215)
						//Si (OK=1)
						$inseeCommune:=vINSEECommune
						$deptnais:=vNumDept
						[INDIVIDUS:1]commune_naissance:8:=vINSEECommune
						[INDIVIDUS:1]pays_naissance:7:="FR"
					End if 
					[INDIVIDUS:1]commune_naissance:8:=$deptnais+$inseeCommune
					
				End if 
				[INDIVIDUS:1]pays_naissance:7:="FR"
				
			End if 
			
			// on va maintenant chercher le pays de naissance
			
		Else 
			//ALERTE("Erreur numero secu : "+[IMPORT_INDIVIDUS]Nom+" "+[IMPORT_INDIVIDUS]Prenom)
			SEND PACKET:C103($doc; [IMPORT_INDIVIDUS:17]Nom:3+Char:C90(Tabulation:K15:37))
			SEND PACKET:C103($doc; [IMPORT_INDIVIDUS:17]Prenom:5+Char:C90(Tabulation:K15:37))
			SEND PACKET:C103($doc; [IMPORT_INDIVIDUS:17]num_secu:17+Char:C90(Tabulation:K15:37))
			SEND PACKET:C103($doc; [IMPORT_INDIVIDUS:17]Date_naissance:6+Char:C90(Tabulation:K15:37))
			SEND PACKET:C103($doc; ""+Char:C90(Tabulation:K15:37))
			SEND PACKET:C103($doc; ""+Char:C90(Tabulation:K15:37))
			SEND PACKET:C103($doc; "Erreur numero secu "+Char:C90(Retour à la ligne:K15:40))
			$error:=True:C214
			FORM SET INPUT:C55([IMPORT_INDIVIDUS:17]; "dept_commune")
			//MODIFIER ENREGISTREMENT([IMPORT_INDIVIDUS])
			OK:=0
			If (OK=1)
				$inseeCommune:=vINSEECommune
				$deptnais:=vNumDept
				[INDIVIDUS:1]commune_naissance:8:=vINSEECommune
				[INDIVIDUS:1]pays_naissance:7:="FR"
				
			End if 
		End if 
		
		
		[INDIVIDUS:1]date_naissance:6:=[IMPORT_INDIVIDUS:17]Date_naissance:6
		If ([IMPORT_INDIVIDUS:17]Sexe:11="F")
			[INDIVIDUS:1]genre:9:="Femme"
		Else 
			[INDIVIDUS:1]genre:9:="Homme"
		End if 
		[INDIVIDUS:1]nom_usuel:3:=[IMPORT_INDIVIDUS:17]Nom:3
		If ([IMPORT_INDIVIDUS:17]Nom_jeune_fille:4="")
			[INDIVIDUS:1]nom_patronymique:4:=[IMPORT_INDIVIDUS:17]Nom:3
		Else 
			[INDIVIDUS:1]nom_patronymique:4:=[IMPORT_INDIVIDUS:17]Nom_jeune_fille:4
		End if 
		[INDIVIDUS:1]prenom:5:=[IMPORT_INDIVIDUS:17]Prenom:5
		[INDIVIDUS:1]Matricule:10:=[IMPORT_INDIVIDUS:17]Matricule:2
		Codage_ID
		$pos:=Find in array:C230($TCode; [INDIVIDUS:1]id_individu:2)
		If ($pos<0)  // cet agent n'a pas été traité
			APPEND TO ARRAY:C911($TMat; [IMPORT_INDIVIDUS:17]Matricule:2)
			APPEND TO ARRAY:C911($TCode; [INDIVIDUS:1]id_individu:2)
			QUERY:C277([MOTS_PASSE:139]; [MOTS_PASSE:139]matricule:2=[INDIVIDUS:1]Matricule:10)
			If (Records in selection:C76([MOTS_PASSE:139])=0)
				[INDIVIDUS:1]password:11:=genere_PWD
				CREATE RECORD:C68([MOTS_PASSE:139])
				[MOTS_PASSE:139]id_connexion:4:=""
				[MOTS_PASSE:139]matricule:2:=[INDIVIDUS:1]Matricule:10
				[MOTS_PASSE:139]pass:3:=[INDIVIDUS:1]password:11
				SAVE RECORD:C53([MOTS_PASSE:139])
			Else 
				[INDIVIDUS:1]password:11:=[MOTS_PASSE:139]pass:3
			End if 
			SAVE RECORD:C53([INDIVIDUS:1])
		Else   // il s'agit d'un doublon
			If ([IMPORT_INDIVIDUS:17]Matricule:2#$TMat{$pos})
				SEND PACKET:C103($doc; [IMPORT_INDIVIDUS:17]Nom:3+Char:C90(Tabulation:K15:37))
				SEND PACKET:C103($doc; [IMPORT_INDIVIDUS:17]Prenom:5+Char:C90(Tabulation:K15:37))
				SEND PACKET:C103($doc; ""+Char:C90(Tabulation:K15:37))
				SEND PACKET:C103($doc; ""+Char:C90(Tabulation:K15:37))
				SEND PACKET:C103($doc; ""+Char:C90(Tabulation:K15:37))
				SEND PACKET:C103($doc; ""+Char:C90(Tabulation:K15:37))
				SEND PACKET:C103($doc; "Agent en doublon "+String:C10([IMPORT_INDIVIDUS:17]Matricule:2)+" / "+$TMat{$pos}+Char:C90(Retour à la ligne:K15:40))
				$error:=True:C214
			End if 
		End if 
		NEXT RECORD:C51([IMPORT_INDIVIDUS:17])
	End while 
	
	//FERMER DOCUMENT($doc)
End if 

$0:=$error