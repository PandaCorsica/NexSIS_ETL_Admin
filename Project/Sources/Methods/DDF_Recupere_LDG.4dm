//%attributes = {}
// cette méthode récupère les plannings des données descendantes pour les mois et année désignés
// elle les stocke dans la table "fdg_service_fait"
$annee:=$1
$mois:=$2
$tableNexSIS:="fdg_service_fait"
$dateDebut:=String:C10($annee)+"-"+String:C10($mois; "00")+"-01T00%3A00%3A00%2B00%3A00"  // formet Annee-mois-jourTheure:minutes:secondes+heuredecallage:minutesDecallage
$dateFin:=String:C10($annee)+"-"+String:C10($mois+1; "00")+"-01T08%3A00%3A00%2B00%3A00"  // on prend husqu'à 8h pour récupérer les infos de la derniere nuit du mois

//on efface les liste de garde déjà chargées
QUERY:C277([fdg_service_fait:124]; [fdg_service_fait:124]annee:42=$annee; *)
QUERY:C277([fdg_service_fait:124]; [fdg_service_fait:124]mois:43=$mois)
DELETE SELECTION:C66([fdg_service_fait:124])

ALL RECORDS:C47([UF:5])
SELECTION TO ARRAY:C260([UF:5]id_uf:5; $TCodesUF)

For ($i; 1; Size of array:C274($TCodesUF))
	C_TEXT:C284($url)
	$url:="https://vm-donnees-froides.ansc.nexsis18-112.fr:443/api/2a/"+$tableNexSIS+"?code_unite_fonctionnelle=eq.02a-"+$TCodesUF{$i}+"&date_debut=gte."+$dateDebut+"&date_fin=lte."+$dateFin+"&code_sis=eq.02a-sis&source=eq.prod"
	//$url:="https://data.nexsis18-112.fr:443/api/2a/"+$tableNexSIS+"?code_unite_fonctionnelle=eq.02a-"+$TCodesUF{$i}+"&code_position_administrative=eq.G&date_debut=gte.2024-01-01T00%3A00%3A00%2B00%3A00&date_fin=lte.2024-02-01T00%3A00%3A00%2B00%3A00&code_sis=eq.02a-sis&source=eq.prod"
	
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
			[fdg_service_fait:124]annee:42:=$annee
			[fdg_service_fait:124]mois:43:=$mois
			[fdg_service_fait:124]traite:44:=False:C215
			[fdg_service_fait:124]a_Filtrer:45:=False:C215
			SAVE RECORD:C53($ptrTable->)
		End for 
	End if 
	ON ERR CALL:C155("")
	
	
	
End for 

// correctif des erreurs de saisie ou il a été écrit GC au lieu de G
QUERY:C277([fdg_service_fait:124]; [fdg_service_fait:124]code_position_administrative:36="GC")
APPLY TO SELECTION:C70([fdg_service_fait:124]; [fdg_service_fait:124]code_position_administrative:36:="G")


// choix des types de planning à récupérer
QUERY:C277([fdg_service_fait:124]; [fdg_service_fait:124]code_position_administrative:36#"G"; *)
QUERY:C277([fdg_service_fait:124]; [fdg_service_fait:124]code_position_administrative:36#"GR"; *)
QUERY:C277([fdg_service_fait:124]; [fdg_service_fait:124]code_position_administrative:36#"RG"; *)
QUERY:C277([fdg_service_fait:124]; [fdg_service_fait:124]code_position_administrative:36#"STAT"; *)
QUERY:C277([fdg_service_fait:124]; [fdg_service_fait:124]code_position_administrative:36#"FDF"; *)
QUERY:C277([fdg_service_fait:124]; [fdg_service_fait:124]code_position_administrative:36#"GIFF"; *)
QUERY:C277([fdg_service_fait:124]; [fdg_service_fait:124]code_position_administrative:36#"HBE"; *)
QUERY:C277([fdg_service_fait:124]; [fdg_service_fait:124]code_position_administrative:36#"PEL"; *)
QUERY:C277([fdg_service_fait:124]; [fdg_service_fait:124]code_position_administrative:36#"CDO"; *)
QUERY:C277([fdg_service_fait:124]; [fdg_service_fait:124]code_position_administrative:36#"SMO"; *)
QUERY:C277([fdg_service_fait:124]; [fdg_service_fait:124]code_position_administrative:36#"PLG"; *)
QUERY:C277([fdg_service_fait:124]; [fdg_service_fait:124]code_position_administrative:36#"FDF"; *)
QUERY:C277([fdg_service_fait:124]; [fdg_service_fait:124]code_position_administrative:36#"GCO"; *)
QUERY:C277([fdg_service_fait:124]; [fdg_service_fait:124]code_position_administrative:36#"A")
APPLY TO SELECTION:C70([fdg_service_fait:124]; [fdg_service_fait:124]a_Filtrer:45:=True:C214)

QUERY:C277([fdg_service_fait:124]; [fdg_service_fait:124]date_archivage:18#""; *)
QUERY:C277([fdg_service_fait:124]; [fdg_service_fait:124]date_archivage:18#Null:C1517)
APPLY TO SELECTION:C70([fdg_service_fait:124]; [fdg_service_fait:124]a_Filtrer:45:=True:C214)

QUERY:C277([fdg_service_fait:124]; [fdg_service_fait:124]disponibilite_temporelle:14="INDISPONIBLE@")
APPLY TO SELECTION:C70([fdg_service_fait:124]; [fdg_service_fait:124]a_Filtrer:45:=True:C214)

// on va filtrer les listes de garde qui sont déjà récupérées de Panda
QUERY:C277([fdg_service_fait:124]; [fdg_service_fait:124]code_unite_fonctionnelle:10="02a-CDO"; *)
QUERY:C277([fdg_service_fait:124];  | ; [fdg_service_fait:124]code_unite_fonctionnelle:10="02a-PAJA"; *)
QUERY:C277([fdg_service_fait:124];  | ; [fdg_service_fait:124]code_unite_fonctionnelle:10="02a-PFIG"; *)
QUERY:C277([fdg_service_fait:124];  | ; [fdg_service_fait:124]code_unite_fonctionnelle:10="02a-HBE")
APPLY TO SELECTION:C70([fdg_service_fait:124]; [fdg_service_fait:124]a_Filtrer:45:=True:C214)



