//%attributes = {}
// cette méthode récupère les détails des opérations créées dans le sgo
// elle les stocke dans la table "sgo_operation"
$tableNexSIS:="sgo_operation"

// on vérifie d'abord si certaines dates n'ont pas été récupérées
$dateDebut:=Current date:C33(*)
$dateATester:=$dateDebut
Repeat 
	$dateATester:=Add to date:C393($dateATester; 0; 0; -1)
	$dateSuivanteATester:=Add to date:C393($dateATester; 0; 0; 1)
	
	QUERY:C277([Dates_ops_ok]; [Dates_ops_ok]DateOps=$dateATester)
	If (Records in selection:C76([Dates_ops_ok])=0)  // si les operations de cette date n'ont pas encore été chargés
		$dateTexte:=String:C10(Year of:C25($dateATester); "0000")+"-"+String:C10(Month of:C24($dateATester); "00")+"-"+String:C10(Day of:C23($dateATester); "00")
		$dateSuivanteTexte:=String:C10(Year of:C25($dateSuivanteATester); "0000")+"-"+String:C10(Month of:C24($dateSuivanteATester); "00")+"-"+String:C10(Day of:C23($dateSuivanteATester); "00")
		
		
		
		C_TEXT:C284($url)
		$url:="https://vm-donnees-froides.ansc.nexsis18-112.fr:443/api/2a/"+$tableNexSIS+"?and=(date_creation.gte."+$dateTexte+",date_creation.lt."+$dateSuivanteTexte+")&code_sis=eq.02a-sis&source=eq.prod"
		
		C_BLOB:C604($Text_t)
		C_COLLECTION:C1488($myResult; $myResultFiltered)
		
		
		QUERY:C277([STRUCTURE_DATA_DESCENDANTES:53]; [STRUCTURE_DATA_DESCENDANTES:53]NomTable:2=$tableNexSIS; *)
		QUERY:C277([STRUCTURE_DATA_DESCENDANTES:53]; [STRUCTURE_DATA_DESCENDANTES:53]NomChamp:3#"#@")
		DISTINCT VALUES:C339([STRUCTURE_DATA_DESCENDANTES:53]NomChamp:3; $TChamps)
		
		$nomReelTable:=[STRUCTURE_DATA_DESCENDANTES:53]NomOriginal_Table:5
		$numeroTable:=[STRUCTURE_DATA_DESCENDANTES:53]Numero_table:8
		
		//TOUT SÉLECTIONNER(Table($numeroTable)->)
		//SUPPRIMER SÉLECTION(Table($numeroTable)->)
		
		ARRAY TEXT:C222($HeaderNames_at; 1)
		ARRAY TEXT:C222($HeaderValues_at; 1)
		$HeaderNames_at{1}:="Authorization"
		$HeaderValues_at{1}:="Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoic2lzMDJhIn0.Bxie55h7NJSDj3jxXAJJVgcLJaflf1h4leq0i0gWuhg"
		
		//$URLText_t:="https://data.nexsis18-112.fr:443/api/2a/"+$nomReelTable
		
		//$httpResponse:=HTTP Request(HTTP méthode GET; URLText_t; ""; Text_t; HeaderNames_at; HeaderValues_at)
		$httpResponse:=HTTP Get:C1157($url; $Text_t; $HeaderNames_at; $HeaderValues_at)
		$return_Text:=BLOB to text:C555($Text_t; UTF8 chaîne en C:K22:15)
		$myResult:=JSON Parse:C1218($return_Text)
		//TABLEAU OBJET($TValeurs; $myResult.length)
		//COLLECTION VERS TABLEAU($myResult; $TValeurs)
		For ($j; 0; $myResult.length-1)
			$ptrTable:=Table:C252($numeroTable)
			CREATE RECORD:C68($ptrTable->)
			For ($k; 1; Size of array:C274($TChamps))
				QUERY:C277([STRUCTURE_DATA_DESCENDANTES:53]; [STRUCTURE_DATA_DESCENDANTES:53]NomTable:2=$tableNexSIS; *)
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
			[sgo_operation:110]crss_charges:18:=False:C215
			SAVE RECORD:C53($ptrTable->)
		End for 
		CREATE RECORD:C68([Dates_ops_ok])
		[Dates_ops_ok]DateOps:=$dateATester
		SAVE RECORD:C53([Dates_ops_ok])
	Else 
		// date déjà chargée
		// on ne fait rien
	End if 
Until (Year of:C25($dateATester)=2023)

