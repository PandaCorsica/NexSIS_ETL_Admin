//%attributes = {}
C_TEXT:C284(URLText_t)
C_BLOB:C604(Text_t)
//C_OBJET($api)

URLText_t:="https://vm-donnees-froides.ansc.nexsis18-112.fr/api/2a/"
ARRAY TEXT:C222(HeaderNames_at; 1)
ARRAY TEXT:C222(HeaderValues_at; 1)
HeaderNames_at{1}:="Authorization"
HeaderValues_at{1}:="Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoic2lzMDJhIn0.Bxie55h7NJSDj3jxXAJJVgcLJaflf1h4leq0i0gWuhg"
//$httpResponse:=HTTP Request(HTTP méthode GET; URLText_t; ""; Text_t; HeaderNames_at; HeaderValues_at)
ON ERR CALL:C155("TRAP ERREUR HTTP")
$httpResponse:=HTTP Get:C1157(URLText_t; Text_t; HeaderNames_at; HeaderValues_at)
If ($httpResponse=200)
	//$return_Text:="{\"sw"+BLOB vers texte(Text_t; UTF8 chaîne en C)
	$return_Text:=BLOB to text:C555(Text_t; UTF8 chaîne en C:K22:15)
	$api:=JSON Parse:C1218($return_Text; Est un objet:K8:27)
	$tables:=OB Get:C1224($api; "paths")
	
	OB GET PROPERTY NAMES:C1232($tables; $tabProps)
	
	ARRAY TEXT:C222(TTables; 0)
	// liste des tables de la base -> tableau $tabTables
	ARRAY TEXT:C222($tabTables; Get last table number:C254)
	ARRAY LONGINT:C221($tabNumTables; Get last table number:C254)
	If (Get last table number:C254>0)  //S’il y a bien des tables
		For ($vlTables; Size of array:C274($tabTables); 1; -1)
			If (Is table number valid:C999($vlTables))
				$tabTables{$vlTables}:=Table name:C256($vlTables)
				$tabNumTables{$vlTables}:=$vlTables
			Else 
				DELETE FROM ARRAY:C228($tabTables; $vlTables)
				DELETE FROM ARRAY:C228($tabNumTables; $vlTables)
			End if 
		End for 
	End if 
	
	ARRAY TEXT:C222(TModifications; 0)
	$compteur:=0
	For ($i; 1; Size of array:C274($tabProps))
		$propName:=$tabProps{$i}
		If ($propName#"/")
			//$params:=$api.paths[$i].get.parameters
			$internal:=OB Get:C1224($api.paths; $tabProps{$i})
			//$params:=$tables[tabProps[$i]].get.parameters
			//$parameters:=OB Lire($get; "parameters")
			$tagOrig:=$internal.get.tags[0]
			$tag:=Substring:C12($tagOrig; 1; 31)  // on limite le nom à 31 caracteres
			ARRAY TEXT:C222(TFields; 0)
			// creation dynamique de la table
			$nouvelleTable:=False:C215
			$pos:=Find in array:C230($tabTables; $tag)
			If ($pos=-1)  // table non existante
				APPEND TO ARRAY:C911(TModifications; "Nouvelle table : "+$tagOrig)
				// et on l'ajoute au tableau des tables
				APPEND TO ARRAY:C911($tabTables; $tag)
				APPEND TO ARRAY:C911($tabNumTables; Get last table number:C254+$compteur)
				$compteur:=$compteur+1
				$nouvelleTable:=True:C214
				//$numeroTableCourante:=Lire numéro dernière table
			Else 
				$numeroTableCourante:=$tabNumTables{$pos}
			End if 
			
			// liste des champs de la table -> tableau $tabChamps si c'est une ancienne table
			If ($nouvelleTable=False:C215)
				CLEAR VARIABLE:C89($tabChamps)
				ARRAY TEXT:C222($tabChamps; Get last field number:C255($numeroTableCourante))
				If (Get last field number:C255($numeroTableCourante)>0)  //S’il y a bien des champs
					For ($vlChamps; Size of array:C274($tabChamps); 1; -1)
						$tabChamps{$vlChamps}:=Field name:C257($numeroTableCourante; $vlChamps)
					End for 
				End if 
			End if 
			
			For ($j; 0; $internal.get.parameters.length-1)
				$pos:=Position:C15($tag; $internal.get.parameters[$j].$ref)
				$pos2:=Position:C15("."; $internal.get.parameters[$j].$ref; $pos+1)
				$nomChamp:=Substring:C12($internal.get.parameters[$j].$ref; $pos2+1)
				
				If ($nomChamp="date") | ($nomChamp="timestamp") | ($nomChamp="age") | ($nomChamp="id")
					$nomChamp:=$nomChamp+"_"
				End if 
				$nomChamp:=Substring:C12($nomChamp; 1; 31)
				// on regarde si ce champ existe
				$numeroChampCourant:=Find in array:C230($tabChamps; $nomChamp)
				If (($numeroChampCourant=-1) & (Substring:C12($internal.get.parameters[$j].$ref; 1; 1)#"#")) | (($nouvelleTable) & (Substring:C12($nomChamp; 1; 1)#"#"))  // champ non existant et ne commencant pas par # 
					APPEND TO ARRAY:C911(TModifications; "Nouveau champ dans la table "+$tagOrig+" : "+$nomChamp)
					// et on l'ajoute au tableau des champs
					APPEND TO ARRAY:C911($tabChamps; $nomChamp)
				End if 
				//AJOUTER À TABLEAU(TTables; $tag)
				//AJOUTER À TABLEAU(TFields; Sous chaîne($internal.get.parameters[$j].$ref; $pos2+1))
			End for 
		End if 
	End for 
	
	If (Size of array:C274(TModifications)>0)
		ALERT:C41("Il y a des modifications dans la structure")
	Else 
		ALERT:C41("Pas de modification de structure")
	End if 
End if 
ON ERR CALL:C155("")
