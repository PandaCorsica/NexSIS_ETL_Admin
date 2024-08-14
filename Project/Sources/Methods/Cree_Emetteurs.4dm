//%attributes = {}
ALL RECORDS:C47([EMETTEURS:12])
DELETE SELECTION:C66([EMETTEURS:12])

ARRAY TEXT:C222($TNoms; 21)
ARRAY TEXT:C222($TTrigramme; 21)
ARRAY TEXT:C222($TAdresseIP; 21)

$TNoms{1}:="Ajaccio"
$TNoms{2}:="Pietrosella"
//$TNoms{3}:="Pianottoli"
$TNoms{4}:="Piana"
$TNoms{5}:="Evisa"
//$TNoms{6}:="Vico"
//$TNoms{7}:="Casaglione"
//$TNoms{8}:="Pastricciola"
//$TNoms{9}:="Bocognano"
//$TNoms{10}:="Vero"
$TNoms{11}:="Ocana"
$TNoms{12}:="Bastelica"
//$TNoms{13}:="Petreto"
//$TNoms{14}:="Cozzano"
$TNoms{15}:="Rizzanese"
//$TNoms{16}:="Bonifacio"
//$TNoms{17}:="Levie"
$TNoms{18}:="Zonza"
$TNoms{19}:="Porto-Vecchio"
//$TNoms{20}:="Sainte-Lucie"
//$TNoms{21}:="Sari"

$TTrigramme{1}:="AJA"
$TTrigramme{2}:="PIE"
//$TTrigramme{3}:="PTL"
$TTrigramme{4}:="PIA"
$TTrigramme{5}:="EVI"
//$TTrigramme{6}:="VIC"
//$TTrigramme{7}:="CAS"
//$TTrigramme{8}:="PAS"
//$TTrigramme{9}:="BOC"
//$TTrigramme{10}:="VER"
$TTrigramme{11}:="OCA"
$TTrigramme{12}:="BAS"
//$TTrigramme{13}:="PTO"
//$TTrigramme{14}:="COZ"
$TTrigramme{15}:="RIZ"
//$TTrigramme{16}:="BON"
//$TTrigramme{17}:="LEV"
$TTrigramme{18}:="ZZA"
$TTrigramme{19}:="POV"
//$TTrigramme{20}:="SLP"
//$TTrigramme{21}:="SZA"

$TAdresseIP{1}:="10.220.21.110"
$TAdresseIP{2}:="10.220.41.110"
$TAdresseIP{3}:="10.220.33.110"
$TAdresseIP{4}:="10.220.32.110"
$TAdresseIP{5}:="10.220.27.110"
$TAdresseIP{6}:="10.220.39.110"
$TAdresseIP{7}:="10.220.25.110"
$TAdresseIP{8}:="10.220.30.110"
$TAdresseIP{9}:="10.220.23.110"
$TAdresseIP{10}:="10.220.38.110"
$TAdresseIP{11}:="10.220.29.110"
$TAdresseIP{12}:="10.220.22.110"
$TAdresseIP{13}:="10.220.31.110"
$TAdresseIP{14}:="10.220.26.110"
$TAdresseIP{15}:="10.220.35.110"
$TAdresseIP{16}:="10.220.24.110"
$TAdresseIP{17}:="10.220.28.110"
$TAdresseIP{18}:="10.220.40.110"
$TAdresseIP{19}:="10.220.34.110"
$TAdresseIP{20}:="10.220.36.110"
$TAdresseIP{21}:="10.220.37.110"


For ($i; 1; Size of array:C274($TNoms))
	If ($TTrigramme{$i}#"")
		CREATE RECORD:C68([EMETTEURS:12])
		[EMETTEURS:12]adresse_ip:3:=$TAdresseIP{$i}
		[EMETTEURS:12]id_emetteur:2:=$TTrigramme{$i}+"_1"
		[EMETTEURS:12]id_uf:4:=$TTrigramme{$i}
		[EMETTEURS:12]ni_type:6:="N"
		[EMETTEURS:12]type_emission:5:="numerique"
		SAVE RECORD:C53([EMETTEURS:12])
	End if 
End for 