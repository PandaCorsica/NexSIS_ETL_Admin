//%attributes = {}
// Cette métode récupère les données froides de la table passée en paramètre $1 en utilisant le champ discriminant $2 pour la date de début de recherche
// les parametres $4 et éventuellement $5 permettent de vérifier l'existence préalable

C_TEXT:C284($1; $tableNexSIS)
C_TEXT:C284($2; $champDiscri)
C_TEXT:C284($3; $codeSIS)
C_TEXT:C284($4; $champUnicite)
$tableNexSIS:=$1
$champDiscri:=$2
$codeSIS:=$3
$champUnicite:=$4
If (Count parameters:C259>4)
	C_TEXT:C284($5; $champUnicite2)
	$champUnicite2:=$5
Else 
	$champUnicite2:=""
End if 


ALL RECORDS:C47([DATES_MAJ_TABLES:161])
If (Records in selection:C76([DATES_MAJ_TABLES:161])=0)
	ALL RECORDS:C47([STRUCTURE_DATA_DESCENDANTES:53])
	DISTINCT VALUES:C339([STRUCTURE_DATA_DESCENDANTES:53]NomTable:2; $tabTables)
	CREATE RECORD:C68([DATES_MAJ_TABLES:161])
	For ($i; 1; Size of array:C274($tabTables))
		OB SET:C1220([DATES_MAJ_TABLES:161]DatesParTable:2; $tabTables{$i}; "2024-01-01")
	End for 
	SAVE RECORD:C53([DATES_MAJ_TABLES:161])
End if 

C_BLOB:C604($Text_t)
C_COLLECTION:C1488($myResult; $myResultFiltered)


QUERY:C277([STRUCTURE_DATA_DESCENDANTES:53]; [STRUCTURE_DATA_DESCENDANTES:53]NomTable:2=$tableNexSIS; *)
QUERY:C277([STRUCTURE_DATA_DESCENDANTES:53]; [STRUCTURE_DATA_DESCENDANTES:53]NomChamp:3#"#@")
DISTINCT VALUES:C339([STRUCTURE_DATA_DESCENDANTES:53]NomChamp:3; $TChamps)

$nomReelTable:=[STRUCTURE_DATA_DESCENDANTES:53]NomOriginal_Table:5
$numeroTable:=[STRUCTURE_DATA_DESCENDANTES:53]Numero_table:8

//TOUT SÉLECTIONNER(Table($numeroTable)->)
//SUPPRIMER SÉLECTION(Table($numeroTable)->)
ALL RECORDS:C47([PARAMETRES:27])
If (Records in selection:C76([PARAMETRES:27])=0)
	CREATE RECORD:C68([PARAMETRES:27])
	[PARAMETRES:27]BearerDF:6:="Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoic2lzMDJhIn0.Bxie55h7NJSDj3jxXAJJVgcLJaflf1h4leq0i0gWuhg"
	SAVE RECORD:C53([PARAMETRES:27])
End if 
If ([PARAMETRES:27]BearerDF:6="")
	[PARAMETRES:27]BearerDF:6:="Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoic2lzMDJhIn0.Bxie55h7NJSDj3jxXAJJVgcLJaflf1h4leq0i0gWuhg"
	SAVE RECORD:C53([PARAMETRES:27])
End if 

$dateDeb:=OB Get:C1224([DATES_MAJ_TABLES:161]DatesParTable:2; $tableNexSIS)  // dabns ce champ, on a la dernière date non lue
If ($dateDeb=Null:C1517)
	OB SET:C1220([DATES_MAJ_TABLES:161]DatesParTable:2; $tableNexSIS; "2024-01-01")
	$dateDeb:="2024-01-01"
End if 
If (Type:C295($dateDeb)=Est une date:K8:7)
	$annee:=String:C10(Year of:C25($dateDeb); "0000")
	$mois:=String:C10(Month of:C24($dateDeb); "00")
	$jour:=String:C10(Day of:C23($dateDeb); "00")
	$dateJour:=$dateDeb
Else 
	$annee:=Substring:C12($dateDeb; 1; 4)
	$mois:=Substring:C12($dateDeb; 6; 2)
	$jour:=Substring:C12($dateDeb; 9; 2)
	$dateJour:=Date:C102($jour+"/"+$mois+"/"+$annee)
End if 
If ($dateJour#Current date:C33)
	
	Repeat 
		$dateDeb:=OB Get:C1224([DATES_MAJ_TABLES:161]DatesParTable:2; $tableNexSIS)  // dabns ce champ, on a la dernière date non lue
		
		If (Type:C295($dateDeb)=Est une date:K8:7)
			$annee:=String:C10(Year of:C25($dateDeb); "0000")
			$mois:=String:C10(Month of:C24($dateDeb); "00")
			$jour:=String:C10(Day of:C23($dateDeb); "00")
			$dateJour:=$dateDeb
		Else 
			$annee:=Substring:C12($dateDeb; 1; 4)
			$mois:=Substring:C12($dateDeb; 6; 2)
			$jour:=Substring:C12($dateDeb; 9; 2)
			$dateJour:=Date:C102($jour+"/"+$mois+"/"+$annee)
		End if 
		
		$dateApres:=Add to date:C393($dateJour; 0; 0; 1)
		$anneeApres:=String:C10(Year of:C25($dateApres); "0000")
		$moisApres:=String:C10(Month of:C24($dateApres); "00")
		$jourApres:=String:C10(Day of:C23($dateApres); "00")
		$dateApresTexte:=$anneeApres+"-"+$moisApres+"-"+$jourApres
		$dateDebut:=$annee+"-"+$mois+"-"+$jour+"T00%3A00%3A00%2B00%3A00"  // formet Annee-mois-jourTheure:minutes:secondes+heuredecallage:minutesDecallage
		$dateFin:=$anneeApres+"-"+$moisApres+"-"+$jourApres+"T00%3A00%3A00%2B00%3A00"  // formet Annee-mois-jourTheure:minutes:secondes+heuredecallage:minutesDecallage
		
		C_TEXT:C284($url)
		If ($codeSIS="*")
			$url:="https://vm-donnees-froides.ansc.nexsis18-112.fr:443/api/2a/"+$tableNexSIS+"?"+$champDiscri+"=gte."+$dateDebut+"&"+$champDiscri+"=lt."+$dateFin+"&source=eq.prod"
		Else 
			$url:="https://vm-donnees-froides.ansc.nexsis18-112.fr:443/api/2a/"+$tableNexSIS+"?"+$champDiscri+"=gte."+$dateDebut+"&"+$champDiscri+"=lt."+$dateFin+"&source=eq.prod&code_sis=eq."+$codeSIS
		End if 
		
		ARRAY TEXT:C222($HeaderNames_at; 1)
		ARRAY TEXT:C222($HeaderValues_at; 1)
		$HeaderNames_at{1}:="Authorization"
		$HeaderValues_at{1}:=[PARAMETRES:27]BearerDF:6
		
		ON ERR CALL:C155("TRAP ERREUR HTTP")
		$httpResponse:=HTTP Get:C1157($url; $Text_t; $HeaderNames_at; $HeaderValues_at)
		If ($httpResponse=200)
			$return_Text:=BLOB to text:C555($Text_t; UTF8 chaîne en C:K22:15)
			$myResult:=JSON Parse:C1218($return_Text)
			//TABLEAU OBJET($TValeurs; $myResult.length)
			//COLLECTION VERS TABLEAU($myResult; $TValeurs)
			For ($j; 0; $myResult.length-1)
				$ptrTable:=Table:C252($numeroTable)
				QUERY:C277([STRUCTURE_DATA_DESCENDANTES:53]; [STRUCTURE_DATA_DESCENDANTES:53]NomTable:2=$tableNexSIS; *)
				QUERY:C277([STRUCTURE_DATA_DESCENDANTES:53]; [STRUCTURE_DATA_DESCENDANTES:53]NomChamp:3=$champUnicite)
				$ptrChampUnicite:=Field:C253($numeroTable; [STRUCTURE_DATA_DESCENDANTES:53]Numero_Champ:9)
				If ($champUnicite2="")
					QUERY:C277($ptrTable->; $ptrChampUnicite->=OB Get:C1224($myResult[$j]; $champUnicite))
				Else 
					QUERY:C277([STRUCTURE_DATA_DESCENDANTES:53]; [STRUCTURE_DATA_DESCENDANTES:53]NomTable:2=$tableNexSIS; *)
					QUERY:C277([STRUCTURE_DATA_DESCENDANTES:53]; [STRUCTURE_DATA_DESCENDANTES:53]NomChamp:3=$champUnicite2)
					$ptrChampUnicite2:=Field:C253($numeroTable; [STRUCTURE_DATA_DESCENDANTES:53]Numero_Champ:9)
					QUERY:C277($ptrTable->; $ptrChampUnicite->=OB Get:C1224($myResult[$j]; $champUnicite); *)
					QUERY:C277($ptrTable->; $ptrChampUnicite2->=OB Get:C1224($myResult[$j]; $champUnicite2))
				End if 
				If (Records in selection:C76($ptrTable->)=0)
					CREATE RECORD:C68($ptrTable->)
				End if 
				For ($k; 1; Size of array:C274($TChamps))
					QUERY:C277([STRUCTURE_DATA_DESCENDANTES:53]; [STRUCTURE_DATA_DESCENDANTES:53]NomTable:2=$tableNexSIS; *)
					QUERY:C277([STRUCTURE_DATA_DESCENDANTES:53]; [STRUCTURE_DATA_DESCENDANTES:53]NomChamp:3=$TChamps{$k})
					If ([STRUCTURE_DATA_DESCENDANTES:53]NomChamp:3#"id")
						$nomReelChamp:=[STRUCTURE_DATA_DESCENDANTES:53]NomOriginal_Champ:4
						$numeroChamp:=[STRUCTURE_DATA_DESCENDANTES:53]Numero_Champ:9
						$ptrChamp:=Field:C253($numeroTable; $numeroChamp)
						If (OB Get:C1224($myResult[$j]; $nomReelChamp)#Null:C1517)
							$valeur:=OB Get:C1224($myResult[$j]; $nomReelChamp)
							If ($nomReelChamp="numero_operation") | (($nomReelChamp="numero") & ($tableNexSIS="sgo_operation"))
								If (Substring:C12($valeur; 1; 15)="SIS2A_20240129_")
									$valeur:=Substring:C12($valeur; 7; 9)+String:C10(Num:C11(Substring:C12($valeur; 16))+25; "00000")
								End if 
							End if 
							If (Type:C295($valeur)=Est une collection:K8:32)
								$ptrChamp->:=JSON Stringify array:C1228($valeur)
							Else 
								$ptrChamp->:=$valeur
							End if 
						End if 
					End if 
				End for 
				//[crss_validation]Annee:=$annee
				//[crss_validation]Mois:=$mois
				//[crss_validation]Traite:=Faux
				SAVE RECORD:C53($ptrTable->)
			End for 
			OB SET:C1220([DATES_MAJ_TABLES:161]DatesParTable:2; $tableNexSIS; $dateApresTexte)
			SAVE RECORD:C53([DATES_MAJ_TABLES:161])
		Else 
			$dateApres:=Current date:C33
		End if 
		ON ERR CALL:C155("T")
	Until ($dateApres=Current date:C33)
	UNLOAD RECORD:C212([DATES_MAJ_TABLES:161])
End if 
