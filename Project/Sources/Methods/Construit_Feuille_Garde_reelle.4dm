//%attributes = {}
// cette méthode recherche les plannings qui sont actifs actuellement
// 1) récupération des POJ
DDF_Recupere_POJ
// 2) traitement de ces données récupérées
$TSActuel:=4DStmp_Write
QUERY:C277([fdg_donnees_poj:184]; [fdg_donnees_poj:184]TS_Debut:14<$TSActuel; *)
QUERY:C277([fdg_donnees_poj:184]; [fdg_donnees_poj:184]TS_Fin:15>$TSActuel)
//TRIER([fdg_donnees_poj]; [fdg_donnees_poj]code_unite_fonctionnelle; >; [fdg_donnees_poj]code_position_administrative; >)
DISTINCT VALUES:C339([fdg_donnees_poj:184]code_unite_fonctionnelle:4; $TUF)
//VISUALISER SÉLECTION([fdg_donnees_poj])
CREATE SET:C116([fdg_donnees_poj:184]; "actuelles")
DISTINCT VALUES:C339([fdg_donnees_poj:184]code_position_administrative:9; $Tpositions)
C_COLLECTION:C1488($plannings)
$plannings:=New collection:C1472
For ($i; 1; Size of array:C274($TUF))
	USE SET:C118("actuelles")
	QUERY SELECTION:C341([fdg_donnees_poj:184]; [fdg_donnees_poj:184]code_unite_fonctionnelle:4=$TUF{$i})
	CREATE SET:C116([fdg_donnees_poj:184]; "centre")
	C_OBJECT:C1216($valcentre)
	C_COLLECTION:C1488($positions)
	$valcentre:=New object:C1471
	$valcentre.nom:=Substring:C12($TUF{$i}; 5)
	$positions:=New collection:C1472
	For ($j; 1; Size of array:C274($Tpositions))
		USE SET:C118("centre")
		QUERY SELECTION:C341([fdg_donnees_poj:184]; [fdg_donnees_poj:184]code_position_administrative:9=$Tpositions{$j})
		C_OBJECT:C1216($nbpositions)
		$nbpositions:=New object:C1471
		$nbpositions.type:=$Tpositions{$j}
		$nbpositions.nombre:=Records in selection:C76([fdg_donnees_poj:184])
		$positions[$j-1]:=$nbpositions
		CLEAR VARIABLE:C89($nbpositions)
	End for 
	$valcentre.positions:=$positions
	$plannings[$i-1]:=$valcentre
	CLEAR VARIABLE:C89($positions)
	CLEAR SET:C117("centre")
	CLEAR VARIABLE:C89($valcentre)
End for 
CLEAR SET:C117("actuelles")

// 3) Phase de visualisation des résultats
var $oRange; $oNewRange : Object
var $wpTable; $wpRow : Object
var $header; $footer; $info; $section; $subSection : Object
wpDoc:=WP New:C1317
var $colHeader : Collection
$colHeader:=New collection:C1472(""; "Centre"; "Garde prévu"; "Astreinte prévu"; "FDF prévu"; "Total prévu"; "Garde réel"; "Astreinte réel"; "FDF réel"; "Total réel")
$oRange:=WP Text range:C1341(wpDoc; wk end text:K81:164; wk end text:K81:164)

WP INSERT BREAK:C1413($oRange; wk section break:K81:187; wk append:K81:179; wk exclude from range:K81:181)

// Retrieve the current section
$section:=WP Get section:C1581($oRange)

// Format the current section
WP SET ATTRIBUTES:C1342($section; wk page margin top:K81:268; "3cm"; wk page margin left:K81:266; "1.5cm"; wk page margin right:K81:267; "1.5cm")
// Create the left sub section
$subSection:=WP New subsection:C1583($section; wk left page:K81:204)

// Insert header
$header:=WP New header:C1586($subSection)
$oNewRange:=WP Text range:C1341($header; wk start text:K81:165; wk end text:K81:164)
WP SET TEXT:C1574($oNewRange; "POJ"; wk replace:K81:177; wk include in range:K81:180)
WP SET ATTRIBUTES:C1342($oNewRange; wk style sheet:K81:63; "Title_Right")
WP SET ATTRIBUTES:C1342($header; wk margin left:K81:11; "2.5cm"; wk margin right:K81:12; "2.5cm")

// Insert Lodging table
$wpTable:=WP Insert table:C1473($oRange; wk append:K81:179; wk include in range:K81:180)
$wpRow:=WP Table append row:C1474($wpTable; $colHeader[1]; $colHeader[2]; $colHeader[3]; $colHeader[4]; $colHeader[5]; $colHeader[6]; $colHeader[7]; $colHeader[8]; $colHeader[9]; $colHeader[10])

$info:=WP Get position:C1577($wpRow)
$firstpage:=$info.page

$oRange:=WP Table get columns:C1476($wpTable; 1; 10)
WP SET ATTRIBUTES:C1342($oRange; wk width:K81:45; "50pt"; \
wk font size:K81:66; "10pt"; \
wk border color:K81:34; "#42cad7")

$oRange:=WP Table get columns:C1476($wpTable; 2; 3)
WP SET ATTRIBUTES:C1342($oRange; wk width:K81:45; "60pt")

$oRange:=WP Table get columns:C1476($wpTable; 1; 1)
WP SET ATTRIBUTES:C1342($oRange; wk width:K81:45; "90pt")

