//%attributes = {}

ALL RECORDS:C47([STRUCTURE_DATA_DESCENDANTES:53])
DISTINCT VALUES:C339([STRUCTURE_DATA_DESCENDANTES:53]NomTable:2; $TTables)

For ($i; 1; Size of array:C274($TTables))
	C_TEXT:C284($URLText_t)
	C_BLOB:C604($Text_t)
	C_COLLECTION:C1488($myResult; $myResultFiltered)
	
	QUERY:C277([STRUCTURE_DATA_DESCENDANTES:53]; [STRUCTURE_DATA_DESCENDANTES:53]NomTable:2=$TTables{$i}; *)
	QUERY:C277([STRUCTURE_DATA_DESCENDANTES:53]; [STRUCTURE_DATA_DESCENDANTES:53]NomChamp:3#"#@")
	DISTINCT VALUES:C339([STRUCTURE_DATA_DESCENDANTES:53]NomChamp:3; $TChamps)
	
	$nomReelTable:=[STRUCTURE_DATA_DESCENDANTES:53]NomOriginal_Table:5
	$numeroTable:=[STRUCTURE_DATA_DESCENDANTES:53]Numero_table:8
	
	ALL RECORDS:C47(Table:C252($numeroTable)->)
	DELETE SELECTION:C66(Table:C252($numeroTable)->)
	
	ARRAY TEXT:C222($HeaderNames_at; 1)
	ARRAY TEXT:C222($HeaderValues_at; 1)
	$HeaderNames_at{1}:="Authorization"
	$HeaderValues_at{1}:="Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoic2lzMDJhIn0.Bxie55h7NJSDj3jxXAJJVgcLJaflf1h4leq0i0gWuhg"
	
	$URLText_t:="https://vm-donnees-froides.ansc.nexsis18-112.fr:443/api/2a/"+$nomReelTable
	
	//$httpResponse:=HTTP Request(HTTP méthode GET; URLText_t; ""; Text_t; HeaderNames_at; HeaderValues_at)
	ON ERR CALL:C155("TRAP ERREUR HTTP")
	$httpResponse:=HTTP Get:C1157($URLText_t; $Text_t; $HeaderNames_at; $HeaderValues_at)
	
	If ($httpResponse=200)
		$return_Text:=BLOB to text:C555($Text_t; UTF8 chaîne en C:K22:15)
		$myResult:=JSON Parse:C1218($return_Text)
		//TABLEAU OBJET($TValeurs; $myResult.length)
		//COLLECTION VERS TABLEAU($myResult; $TValeurs)
		For ($j; 0; $myResult.length-1)
			$ptrTable:=Table:C252($numeroTable)
			CREATE RECORD:C68($ptrTable->)
			For ($k; 1; Size of array:C274($TChamps))
				QUERY:C277([STRUCTURE_DATA_DESCENDANTES:53]; [STRUCTURE_DATA_DESCENDANTES:53]NomTable:2=$TTables{$i}; *)
				QUERY:C277([STRUCTURE_DATA_DESCENDANTES:53]; [STRUCTURE_DATA_DESCENDANTES:53]NomChamp:3=$TChamps{$k})
				If ([STRUCTURE_DATA_DESCENDANTES:53]NomChamp:3#"id")
					$nomReelChamp:=[STRUCTURE_DATA_DESCENDANTES:53]NomOriginal_Champ:4
					$numeroChamp:=[STRUCTURE_DATA_DESCENDANTES:53]Numero_Champ:9
					$ptrChamp:=Field:C253($numeroTable; $numeroChamp)
					If (OB Get:C1224($myResult[$j]; $nomReelChamp)#Null:C1517)
						$ptrChamp->:=OB Get:C1224($myResult[$j]; $nomReelChamp)
					End if 
				End if 
			End for 
			SAVE RECORD:C53($ptrTable->)
		End for 
	End if 
	ON ERR CALL:C155("")
	
	
	
End for 
