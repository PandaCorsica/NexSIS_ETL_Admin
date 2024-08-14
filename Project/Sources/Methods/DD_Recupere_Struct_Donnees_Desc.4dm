//%attributes = {}
// cette méthode charge la structure des données NexSIS et met à jour la table STRUCTURE_DATA_DESCENDANTES
// Elle crée éventuellement une table si elle n'existait pas

C_TEXT:C284(URLText_t)
C_BLOB:C604(Text_t)
//C_OBJET($api)

//TOUT SÉLECTIONNER([STRUCTURE_DATA_DESCENDANTES])
//SUPPRIMER SÉLECTION([STRUCTURE_DATA_DESCENDANTES])

ALL RECORDS:C47([PARAMETRES:27])
URLText_t:="https://vm-donnees-froides.ansc.nexsis18-112.fr/api/2a/"
ARRAY TEXT:C222(HeaderNames_at; 1)
ARRAY TEXT:C222(HeaderValues_at; 1)
HeaderNames_at{1}:="Authorization"
HeaderValues_at{1}:=[PARAMETRES:27]BearerDF:6  //"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoic2lzMDJhIn0.Bxie55h7NJSDj3jxXAJJVgcLJaflf1h4leq0i0gWuhg"
//$httpResponse:=HTTP Request(HTTP méthode GET; URLText_t; ""; Text_t; HeaderNames_at; HeaderValues_at)
ON ERR CALL:C155("TRAP ERREUR HTTP")
$httpResponse:=HTTP Get:C1157(URLText_t; Text_t; HeaderNames_at; HeaderValues_at)
If ($httpResponse=200)
	//$return_Text:="{\"sw"+BLOB vers texte(Text_t; UTF8 chaîne en C)
	$return_Text:=BLOB to text:C555(Text_t; UTF8 chaîne en C:K22:15)
	$api:=JSON Parse:C1218($return_Text; Est un objet:K8:27)
	$tables:=OB Get:C1224($api; "paths")  // liste des tables
	$definitions:=OB Get:C1224($api; "definitions")  // liste des champs dans chaque table (attribut properties)
	
	OB GET PROPERTY NAMES:C1232($tables; $tabProps)
	OB GET PROPERTY NAMES:C1232($definitions; $tabDefs)
	
	$creationFichier:=False:C215  // variable qui teste si on cree un fichier avec les champs ou sil on travaille sur les données uniquement
	// creation fichier texte
	doc2:=Create document:C266(Get 4D folder:C485(Dossier base:K5:14)+"logErreurs.txt"; ".txt")
	
	$doc:=Create document:C266(""; ".txt")
	If (OK=1)
		$creationFichier:=True:C214
	End if 
	ON ERR CALL:C155("erreur_SQL")
	ARRAY TEXT:C222(TTables; 0)
	// liste des tables de la base et de leur numéro-> tableau $tabTables et $tabNumTables
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
			If ($creationFichier)
				SEND PACKET:C103($doc; "TABLE "+$tag+Char:C90(Retour à la ligne:K15:40))
			End if 
			// creation dynamique de la table
			$numeroTableCourante:=Find in array:C230($tabTables; $tag)
			vTable:=$tag
			If ($numeroTableCourante=-1)  // table non existante
				// on la crée
				SQL LOGIN:C817(SQL_INTERNAL:K49:11; ""; "")
				$command:="CREATE TABLE "+$tag+" (id INT PRIMARY KEY NOT NULL)"
				SQL EXECUTE:C820($command)
				SQL LOGOUT:C872
				// et on l'ajoute au tableau des tables
				APPEND TO ARRAY:C911($tabTables; $tag)
				APPEND TO ARRAY:C911($tabNumTables; Get last table number:C254)
				$numeroTableCourante:=Get last table number:C254
			End if 
			
			// liste des champs de la table -> tableau $tabChamps
			ARRAY TEXT:C222($tabChamps; Get last field number:C255($numeroTableCourante))
			If (Get last field number:C255($numeroTableCourante)>0)  //S’il y a bien des champs
				For ($vlChamps; Size of array:C274($tabChamps); 1; -1)
					If (Is field number valid:C1000($numeroTableCourante; $vlChamps))
						$tabChamps{$vlChamps}:=Field name:C257($numeroTableCourante; $vlChamps)
					Else 
						DELETE FROM ARRAY:C228($tabChamps; $vlChamps)
					End if 
				End for 
			End if 
			
			For ($j; 0; $internal.get.parameters.length-1)
				$pos:=Position:C15($tag; $internal.get.parameters[$j].$ref)
				$pos2:=Position:C15("."; $internal.get.parameters[$j].$ref; $pos+1)
				$nomChamp:=Substring:C12($internal.get.parameters[$j].$ref; $pos2+1)
				C_OBJECT:C1216($temp1)
				$temp1:=OB Get:C1224($api.definitions; $tagOrig)
				C_OBJECT:C1216($temp2)
				$temp2:=OB Get:C1224($temp1; "properties")
				C_OBJECT:C1216($temp3)
				$temp3:=OB Get:C1224($temp2; $nomChamp)
				$formatChamp:=OB Get:C1224($temp3; "format")
				$typeChamp:=OB Get:C1224($temp3; "type")
				
				If ($nomChamp="date") | ($nomChamp="timestamp") | ($nomChamp="age") | ($nomChamp="id")
					$nomChamp:=$nomChamp+"_"
				End if 
				$nomChamp:=Substring:C12($nomChamp; 1; 31)
				If ($creationFichier)
					SEND PACKET:C103($doc; $nomChamp+Char:C90(Tabulation:K15:37))
					SEND PACKET:C103($doc; $formatChamp+Char:C90(Tabulation:K15:37))
					SEND PACKET:C103($doc; $typeChamp+Char:C90(Retour à la ligne:K15:40))
				End if 
				// on regarde si ce champ existe
				$numeroChampCourant:=Find in array:C230($tabChamps; $nomChamp)
				If ($numeroChampCourant=-1) & (Substring:C12($nomChamp; 1; 1)#"#")  // champ non existant et ne commencant pas par # on le crée
					// on commence d'abord par trouver son type
					Case of 
						: ($formatChamp="character varying") & ($typeChamp="string")  // c'est du texte
							$formatSQL:="VARCHAR(255)"
						: ($formatChamp="timestamp without time zone") & ($typeChamp="string")  // c'est une date heure
							$formatSQL:="VARCHAR(255)"
						: ($formatChamp="integer")  // c'est un entier 
							$formatSQL:="INT"
						: ($formatChamp="double precision") & ($typeChamp="number")  // c'est un entier long
							$formatSQL:="REAL"
						: ($formatChamp="interval") & ($typeChamp="string")  // c'est une duree
							$formatSQL:="VARCHAR(255)"
						: ($formatChamp="boolean") & ($typeChamp="boolean")  // c'est un booleen
							$formatSQL:="BOOLEAN"
						: ($formatChamp="text") & ($typeChamp="string")  // c'est un booleen
							$formatSQL:="TEXT"
						: ($formatChamp="public.geometry") & ($typeChamp="string")  // c'est un objet
							$formatSQL:="OBJECT"
						Else 
							$formatSQL:="TEXT"
					End case 
					// puis on le cree
					SQL LOGIN:C817(SQL_INTERNAL:K49:11; ""; "")
					vChamp:=$nomChamp
					vFormat:=$formatSQL
					$command:="ALTER TABLE "+$tag+" ADD "+$nomChamp+" "+$formatSQL
					SQL EXECUTE:C820($command)
					SQL LOGOUT:C872
					// et on l'ajoute au tableau des champs
					APPEND TO ARRAY:C911($tabChamps; $nomChamp)
				End if 
				CREATE RECORD:C68([STRUCTURE_DATA_DESCENDANTES:53])
				[STRUCTURE_DATA_DESCENDANTES:53]NomTable:2:=$tag
				[STRUCTURE_DATA_DESCENDANTES:53]NomOriginal_Champ:4:=Substring:C12($internal.get.parameters[$j].$ref; $pos2+1)
				[STRUCTURE_DATA_DESCENDANTES:53]NomChamp:3:=$nomChamp
				[STRUCTURE_DATA_DESCENDANTES:53]NomOriginal_Table:5:=$tagOrig
				[STRUCTURE_DATA_DESCENDANTES:53]Format:7:=$formatChamp
				[STRUCTURE_DATA_DESCENDANTES:53]Type:6:=$typeChamp
				SAVE RECORD:C53([STRUCTURE_DATA_DESCENDANTES:53])
				//AJOUTER À TABLEAU(TTables; $tag)
				//AJOUTER À TABLEAU(TFields; Sous chaîne($internal.get.parameters[$j].$ref; $pos2+1))
			End for 
			If ($creationFichier)
				SEND PACKET:C103($doc; Char:C90(Retour à la ligne:K15:40))
			End if 
		End if 
	End for 
	CLOSE DOCUMENT:C267(doc2)
	ON ERR CALL:C155("")
	If ($creationFichier)
		CLOSE DOCUMENT:C267($doc)
	End if 
	
	//mise à jour des numeros de champ et numéro de table
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
	
	For ($i; 1; Size of array:C274($tabTables))
		QUERY:C277([STRUCTURE_DATA_DESCENDANTES:53]; [STRUCTURE_DATA_DESCENDANTES:53]NomTable:2=$tabTables{$i})
		If (Records in selection:C76([STRUCTURE_DATA_DESCENDANTES:53])#0)
			CREATE SET:C116([STRUCTURE_DATA_DESCENDANTES:53]; "data")
			CLEAR VARIABLE:C89($tabChamps)
			CLEAR VARIABLE:C89($tabNumChamps)
			ARRAY TEXT:C222($tabChamps; Get last field number:C255($tabNumTables{$i}))
			ARRAY LONGINT:C221($tabNumChamps; Get last field number:C255($tabNumTables{$i}))
			If (Get last field number:C255($tabNumTables{$i})>0)  //S’il y a bien des champs
				For ($vlChamps; Size of array:C274($tabChamps); 1; -1)
					If (Is field number valid:C1000($tabNumTables{$i}; $vlChamps))
						$tabChamps{$vlChamps}:=Field name:C257($tabNumTables{$i}; $vlChamps)
						$tabNumChamps{$vlChamps}:=$vlChamps
					Else 
						DELETE FROM ARRAY:C228($tabChamps; $vlChamps)
						DELETE FROM ARRAY:C228($tabNumChamps; $vlChamps)
					End if 
				End for 
			End if 
			
			If (Get last field number:C255($tabNumTables{$i})>0)  //S’il y a bien des champs
				For ($vlChamps; Size of array:C274($tabChamps); 1; -1)
					$tabChamps{$vlChamps}:=Field name:C257($tabNumTables{$i}; $vlChamps)
					$tabNumChamps{$vlChamps}:=$vlChamps
					USE SET:C118("data")
					QUERY SELECTION:C341([STRUCTURE_DATA_DESCENDANTES:53]; [STRUCTURE_DATA_DESCENDANTES:53]NomTable:2=$tabTables{$i}; *)
					QUERY SELECTION:C341([STRUCTURE_DATA_DESCENDANTES:53]; [STRUCTURE_DATA_DESCENDANTES:53]NomChamp:3=$tabChamps{$vlChamps})
					[STRUCTURE_DATA_DESCENDANTES:53]Numero_table:8:=$tabNumTables{$i}
					[STRUCTURE_DATA_DESCENDANTES:53]Numero_Champ:9:=$tabNumChamps{$vlChamps}
					SAVE RECORD:C53([STRUCTURE_DATA_DESCENDANTES:53])
				End for 
			End if 
			CLEAR SET:C117("data")
		End if 
		
	End for 
End if 
ON ERR CALL:C155("")
