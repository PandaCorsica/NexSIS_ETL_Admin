//%attributes = {}
// cette méthode récupère les engins des opérations dont les CRSS ont été chargés mais pas encore traités
// elle les stocke dans la table "crss_engin"
$annee:=$1
$mois:=$2
$tableNexSIS:="crss_engin"
$dateDebut:=String:C10($annee)+"-"+String:C10($mois; "00")+"-01T00%3A00%3A00%2B00%3A00"  // formet Annee-mois-jourTheure:minutes:secondes+heuredecallage:minutesDecallage
//$dateFin:=Chaîne($annee)+"-"+Chaîne($mois+1; "00")+"-01T00%3A00%3A00%2B00%3A00"


// recupération des opérations dont le CRSS est validé
QUERY:C277([crss_validation:154]; [crss_validation:154]Traite:19=False:C215)
While (Not:C34(End selection:C36([crss_validation:154])))
	
	
	C_TEXT:C284($url)
	$url:="https://vm-donnees-froides.ansc.nexsis18-112.fr:443/api/2a/"+$tableNexSIS+"?id_operation=eq."+[crss_validation:154]id_operation:2+"&code_sis=eq.02a-sis&source=eq.prod"
	
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
		//[crss_validation]Annee:=$annee
		//[crss_validation]Mois:=$mois
		//[crss_validation]Traite:=Faux
		SAVE RECORD:C53($ptrTable->)
	End for 
	
	NEXT RECORD:C51([crss_validation:154])
End while 

