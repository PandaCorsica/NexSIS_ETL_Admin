//%attributes = {}


// cette méthode récupère les plannings des données descendantes pour le mois en cours afin d'envoyer les infos de validation manquantes
// elle les stocke dans la table "fdg_service_fait"
// si la date est le 1er du mois, ce sont les plannings du mois precedent qui sont récupérés

$codeUF:=$1
$jourReference:=Current date:C33
$annee:=Year of:C25($jourReference)
$mois:=Month of:C24($jourReference)
$jour:=Day of:C23($jourReference)
If ($jour<=5)  // on est avant le 5 du mois, on récupère tout le mois précédent également
	$jourCorrige:=Add to date:C393($jourReference; 0; -1; 0)
	$anneeCorrigee:=Year of:C25($jourCorrige)
	$moisCorrige:=Month of:C24($jourCorrige)
	//$jour:=Jour de(Ajouter à date($jourReference; 0; 0; -1))
	$dateDebut:=String:C10($anneeCorrigee)+"-"+String:C10($moisCorrige; "00")+"-01T00%3A00%3A00%2B00%3A00"  // formet Annee-mois-jourTheure:minutes:secondes+heuredecallage:minutesDecallage
	$dateFin:=String:C10($annee)+"-"+String:C10($mois; "00")+"-"+String:C10($jour; "00")+"T08%3A00%3A00%2B00%3A00"  // on prend jusqu'à 8h pour récupérer les infos de la derniere nuit du mois
Else 
	$dateDebut:=String:C10($annee)+"-"+String:C10($mois; "00")+"-01T00%3A00%3A00%2B00%3A00"  // formet Annee-mois-jourTheure:minutes:secondes+heuredecallage:minutesDecallage
	$dateFin:=String:C10($annee)+"-"+String:C10($mois; "00")+"-"+String:C10($jour; "00")+"T08%3A00%3A00%2B00%3A00"  // on prend jusqu'à 8h pour récupérer les infos de la derniere nuit du mois
End if 
$tableNexSIS:="fdg_service_fait"

//on efface les liste de garde déjà chargées
QUERY:C277([fdg_service_fait:124]; [fdg_service_fait:124]annee:42=$annee; *)
QUERY:C277([fdg_service_fait:124]; [fdg_service_fait:124]mois:43=$mois)
DELETE SELECTION:C66([fdg_service_fait:124])


C_TEXT:C284($url)
$url:="https://vm-donnees-froides.ansc.nexsis18-112.fr:443/api/2a/"+$tableNexSIS+"?code_unite_fonctionnelle=eq."+$codeUF+"&date_debut=gte."+$dateDebut+"&date_fin=lte."+$dateFin+"&code_sis=eq.02a-sis&source=eq.prod"
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




QUERY:C277([fdg_service_fait:124]; [fdg_service_fait:124]disponibilite_temporelle:14="INDISPONIBLE@")
DELETE SELECTION:C66([fdg_service_fait:124])
QUERY:C277([fdg_service_fait:124]; [fdg_service_fait:124]date_archivage:18#Null:C1517; *)
QUERY:C277([fdg_service_fait:124]; [fdg_service_fait:124]date_archivage:18#"")
DELETE SELECTION:C66([fdg_service_fait:124])


