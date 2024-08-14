//%attributes = {}
// cette méthode récupère les donnees froides
ALL RECORDS:C47([STRUCTURE_DATA_DESCENDANTES:53])
ARRAY TEXT:C222($TablesNexsis; 0)
DISTINCT VALUES:C339([STRUCTURE_DATA_DESCENDANTES:53]NomTable:2; $TablesNexsis)
$dateDebut:=Current date:C33(*)
$dateATester:=$dateDebut


// on vérifie d'abord si certaines dates n'ont pas été récupérées
Repeat 
	$dateATester:=Add to date:C393($dateATester; 0; 0; -1)
	$dateSuivanteATester:=Add to date:C393($dateATester; 0; 0; 1)
	
	QUERY:C277([Dates_Recuperation:159]; [Dates_Recuperation:159]DateOK:2=$dateATester)
	If (Records in selection:C76([Dates_Recuperation:159])=0)  // si les donnees de cette date n'ont pas encore été chargés
		$dateTexte:=String:C10(Year of:C25($dateATester); "0000")+"-"+String:C10(Month of:C24($dateATester); "00")+"-"+String:C10(Day of:C23($dateATester); "00")
		$dateSuivanteTexte:=String:C10(Year of:C25($dateSuivanteATester); "0000")+"-"+String:C10(Month of:C24($dateSuivanteATester); "00")+"-"+String:C10(Day of:C23($dateSuivanteATester); "00")
		
		For ($i; 1; Size of array:C274($TablesNexsis))
			$tableNexSIS:=$TablesNexsis{$i}
			
			Case of 
				: ($tableNexSIS="crss_agent")
					$critere:="createdAt"
				: ($tableNexSIS="crss_engin")
					$critere:="createdAt"
				: ($tableNexSIS="crss_operation")
					$critere:="createdAt"
				: ($tableNexSIS="crss_sinistre")
					$critere:="createdAt"
				: ($tableNexSIS="crss_thematique")
					$critere:="createdAt"
				: ($tableNexSIS="crss_questionnaire_ca")
					$critere:="date_alimentation"
				: ($tableNexSIS="crss_questionnaire_cos")
					$critere:="date_alimentation"
				: ($tableNexSIS="crss@")
					$critere:="created_at"
				: ($tableNexSIS="nexsis@")
					$critere:="date_alimentation"
				: ($tableNexSIS="sga_create_affaire")
					$critere:="date_creation_alerte"
				: ($tableNexSIS="sga@")
					$critere:="date_creation"
				: ($tableNexSIS="fdg@")
					$critere:="updatedAt"
				: ($tableNexSIS="bi_tracabilite_statuts_agents")
					$critere:="updatedat"
				: ($tableNexSIS="bi@")
					$critere:="date_alimentation"
				: ($tableNexSIS="sgo@")
					$critere:="date_reception"
				Else 
					
			End case 
			
			QUERY:C277([STRUCTURE_DATA_DESCENDANTES:53]; [STRUCTURE_DATA_DESCENDANTES:53]NomTable:2=$tableNexSIS; *)
			QUERY:C277([STRUCTURE_DATA_DESCENDANTES:53]; [STRUCTURE_DATA_DESCENDANTES:53]NomChamp:3#"#@")
			DISTINCT VALUES:C339([STRUCTURE_DATA_DESCENDANTES:53]NomChamp:3; $TChamps)
			
			$nomReelTable:=[STRUCTURE_DATA_DESCENDANTES:53]NomOriginal_Table:5
			$numeroTable:=[STRUCTURE_DATA_DESCENDANTES:53]Numero_table:8
			
			C_TEXT:C284($url)
			$url:="https://vm-donnees-froides.ansc.nexsis18-112.fr:443/api/2a/"+$nomReelTable+"?and=("+$critere+".gte."+$dateTexte+","+$critere+".lt."+$dateSuivanteTexte+")&code_sis=eq.02a-sis&source=eq.prod"
			
			C_BLOB:C604($Text_t)
			C_COLLECTION:C1488($myResult; $myResultFiltered)
			
			//TOUT SÉLECTIONNER(Table($numeroTable)->)
			//SUPPRIMER SÉLECTION(Table($numeroTable)->)
			
			ARRAY TEXT:C222($HeaderNames_at; 1)
			ARRAY TEXT:C222($HeaderValues_at; 1)
			$HeaderNames_at{1}:="Authorization"
			$HeaderValues_at{1}:="Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoic2lzMDJhIn0.Bxie55h7NJSDj3jxXAJJVgcLJaflf1h4leq0i0gWuhg"
			
			//$URLText_t:="https://data.nexsis18-112.fr:443/api/2a/"+$nomReelTable
			
			//$httpResponse:=HTTP Request(HTTP méthode GET; URLText_t; ""; Text_t; HeaderNames_at; HeaderValues_at)
			ON ERR CALL:C155("TRAP ERREUR HTTP")
			$httpResponse:=HTTP Get:C1157($url; $Text_t; $HeaderNames_at; $HeaderValues_at)
			If ($httpResponse=200)
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
					SAVE RECORD:C53($ptrTable->)
				End for 
			Else 
				
			End if 
			ON ERR CALL:C155("")
			
		End for 
		CREATE RECORD:C68([Dates_Recuperation:159])
		[Dates_Recuperation:159]DateOK:2:=$dateATester
		SAVE RECORD:C53([Dates_Recuperation:159])
	Else 
		// date déjà chargée
		// on ne fait rien
	End if 
Until (Year of:C25($dateATester)=2023)
