//%attributes = {}
// cette méthode récupère les plannings de garde de Nexsis sur la journée
// elle crée aussi des TS pour chaque planning afin de pouvoir faire des recherches rapides par la suite
C_TEXT:C284($tableNexSIS)
$tableNexSIS:="fdg_donnees_poj"

$requete:="?source=eq.prod&code_position_administrative=isdistinct.null"

C_BLOB:C604($Text_t)
C_COLLECTION:C1488($myResult; $myResultFiltered)


QUERY:C277([STRUCTURE_DATA_DESCENDANTES:53]; [STRUCTURE_DATA_DESCENDANTES:53]NomTable:2=$tableNexSIS; *)
QUERY:C277([STRUCTURE_DATA_DESCENDANTES:53]; [STRUCTURE_DATA_DESCENDANTES:53]NomChamp:3#"#@")
DISTINCT VALUES:C339([STRUCTURE_DATA_DESCENDANTES:53]NomChamp:3; $TChamps)

$nomReelTable:=[STRUCTURE_DATA_DESCENDANTES:53]NomOriginal_Table:5
$numeroTable:=[STRUCTURE_DATA_DESCENDANTES:53]Numero_table:8


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


C_TEXT:C284($url)
$url:="https://vm-donnees-froides.ansc.nexsis18-112.fr:443/api/2a/"+$tableNexSIS+$requete

ARRAY TEXT:C222($HeaderNames_at; 1)
ARRAY TEXT:C222($HeaderValues_at; 1)
$HeaderNames_at{1}:="Authorization"
$HeaderValues_at{1}:=[PARAMETRES:27]BearerDF:6

ON ERR CALL:C155("TRAP ERREUR HTTP")
$httpResponse:=HTTP Get:C1157($url; $Text_t; $HeaderNames_at; $HeaderValues_at)
If ($httpResponse=200)
	ALL RECORDS:C47(Table:C252($numeroTable)->)
	DELETE SELECTION:C66(Table:C252($numeroTable)->)
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
					
					If (Value type:C1509(OB Get:C1224($myResult[$j]; $nomReelChamp))=Est une collection:K8:32)
						$ptrChamp->:=JSON Stringify:C1217(OB Get:C1224($myResult[$j]; $nomReelChamp))
					Else 
						$ptrChamp->:=OB Get:C1224($myResult[$j]; $nomReelChamp)
					End if 
				End if 
			End if 
		End for 
		If ([fdg_donnees_poj:184]code_position_administrative:9#"")
			// calcul des TS pour les recherches futures
			C_OBJECT:C1216($datedeb; $datefin)
			$datedeb:=Correctif_changement_heure([fdg_donnees_poj:184]date_debut:5)
			$datefin:=Correctif_changement_heure([fdg_donnees_poj:184]date_fin:6)
			[fdg_donnees_poj:184]TS_Debut:14:=4DStmp_Write($datedeb.date; $datedeb.heure)
			[fdg_donnees_poj:184]TS_Fin:15:=4DStmp_Write($datefin.date; $datefin.heure)
			SAVE RECORD:C53($ptrTable->)
		End if 
	End for 
End if 
ON ERR CALL:C155("")