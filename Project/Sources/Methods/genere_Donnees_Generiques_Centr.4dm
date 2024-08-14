//%attributes = {}
ARRAY TEXT:C222($TNoms; 21)
ARRAY TEXT:C222($TMatricules; 21)
ARRAY TEXT:C222($TInsee; 21)
ARRAY TEXT:C222($TTypes; 21)
ARRAY TEXT:C222($TTrigramme; 21)
ARRAY TEXT:C222($TPass; 21)

$TNoms{1}:="Ajaccio"
$TNoms{2}:="Pietrosella"
$TNoms{3}:="Pianottoli"
$TNoms{4}:="Piana"
$TNoms{5}:="Evisa"
$TNoms{6}:="Vico"
$TNoms{7}:="Casaglione"
$TNoms{8}:="Pastricciola"
$TNoms{9}:="Bocognano"
$TNoms{10}:="Vero"
$TNoms{11}:="Ocana"
$TNoms{12}:="Bastelica"
$TNoms{13}:="Petreto"
$TNoms{14}:="Cozzano"
$TNoms{15}:="Rizzanese"
$TNoms{16}:="Bonifacio"
$TNoms{17}:="Levie"
$TNoms{18}:="Zonza"
$TNoms{19}:="Porto-Vecchio"
$TNoms{20}:="Sainte-Lucie"
$TNoms{21}:="Sari"

$TPass{1}:="ajaccio"
$TPass{2}:="pietrosella"
$TPass{3}:="pianottoli"
$TPass{4}:="piana"
$TPass{5}:="evisa"
$TPass{6}:="vico"
$TPass{7}:="casaglione"
$TPass{8}:="pastricciola"
$TPass{9}:="bocognano"
$TPass{10}:="vero"
$TPass{11}:="ocana"
$TPass{12}:="bastelica"
$TPass{13}:="petreto"
$TPass{14}:="cozzano"
$TPass{15}:="rizzanese"
$TPass{16}:="bonifacio"
$TPass{17}:="levie"
$TPass{18}:="zonza"
$TPass{19}:="Povo"
$TPass{20}:="stelucie"
$TPass{21}:="sari"

For ($i; 1; 21)
	$TMatricules{$i}:="99"+String:C10($i-1; "00")
End for 

For ($i; 1; 21)
	$TTypes{$i}:="cis"
End for 
$TTypes{1}:="csp"
$TTypes{15}:="cs"
$TTypes{19}:="cs"


$TInsee{1}:="004"
$TInsee{2}:="228"
$TInsee{3}:="215"
$TInsee{4}:="212"
$TInsee{5}:="108"
$TInsee{6}:="348"
$TInsee{7}:="070"
$TInsee{8}:="204"
$TInsee{9}:="040"
$TInsee{10}:="345"
$TInsee{11}:="181"
$TInsee{12}:="031"
$TInsee{13}:="211"
$TInsee{14}:="099"
$TInsee{15}:="272"
$TInsee{16}:="041"
$TInsee{17}:="142"
$TInsee{18}:="362"
$TInsee{19}:="247"
$TInsee{20}:="362"
$TInsee{21}:="269"

$TTrigramme{1}:="AJA"
$TTrigramme{2}:="PIE"
$TTrigramme{3}:="PTL"
$TTrigramme{4}:="PIA"
$TTrigramme{5}:="EVI"
$TTrigramme{6}:="VIC"
$TTrigramme{7}:="CAS"
$TTrigramme{8}:="PAS"
$TTrigramme{9}:="BOC"
$TTrigramme{10}:="VER"
$TTrigramme{11}:="OCA"
$TTrigramme{12}:="BAS"
$TTrigramme{13}:="PTO"
$TTrigramme{14}:="COZ"
$TTrigramme{15}:="RIZ"
$TTrigramme{16}:="BON"
$TTrigramme{17}:="LEV"
$TTrigramme{18}:="ZZA"
$TTrigramme{19}:="POV"
$TTrigramme{20}:="SLP"
$TTrigramme{21}:="SZA"

For ($i; 1; 21)
	$insee:=$TInsee{$i}
	$matricule:=$TMatricules{$i}
	$nom:=$TNoms{$i}
	$typeCI:=$TTypes{$i}
	$idUF:=$TTrigramme{$i}
	$pass:=$TPass{$i}
	CREATE RECORD:C68([INDIVIDUS:1])
	[INDIVIDUS:1]commune_naissance:8:=$insee
	[INDIVIDUS:1]date_naissance:6:="01/01/2023"
	[INDIVIDUS:1]genre:9:="Homme"
	[INDIVIDUS:1]Matricule:10:=$matricule
	[INDIVIDUS:1]nom_patronymique:4:=$nom
	[INDIVIDUS:1]nom_usuel:3:=$nom
	[INDIVIDUS:1]pays_naissance:7:="FR"
	[INDIVIDUS:1]prenom:5:="CIS"
	[INDIVIDUS:1]password:11:=$pass
	Codage_ID
	SAVE RECORD:C53([INDIVIDUS:1])
	CREATE RECORD:C68([AGENTS:2])
	[AGENTS:2]grade:7:="SIS-CSP-SP-SAP"
	[AGENTS:2]id_agent:3:=$matricule+"-3"
	[AGENTS:2]id_connexion:4:=$typeCI+"."+Lowercase:C14($nom)+"@sis2a.corsica"
	[AGENTS:2]id_individu:2:=[INDIVIDUS:1]id_individu:2
	[AGENTS:2]matricule:5:=$matricule
	[AGENTS:2]statut:6:="SPV"
	SAVE RECORD:C53([AGENTS:2])
	CREATE RECORD:C68([AFFECTATIONS:3])
	[AFFECTATIONS:3]date_debut:6:="2023-01-01T00:00:00+01:00"
	[AFFECTATIONS:3]date_fin:7:=""
	[AFFECTATIONS:3]id_affectation:2:=$matricule+"-3_sis"
	[AFFECTATIONS:3]id_agent:3:=$matricule+"-3"
	[AFFECTATIONS:3]id_uf:4:="sis"
	[AFFECTATIONS:3]type:5:="AFFECTATION_ADMINISTRATIVE"
	SAVE RECORD:C53([AFFECTATIONS:3])
	CREATE RECORD:C68([AFFECTATIONS:3])
	[AFFECTATIONS:3]date_debut:6:="2023-01-01T00:00:00+01:00"
	[AFFECTATIONS:3]date_fin:7:=""
	[AFFECTATIONS:3]id_affectation:2:=$matricule+"-3_sis"
	[AFFECTATIONS:3]id_agent:3:=$matricule+"-3"
	[AFFECTATIONS:3]id_uf:4:="sis"
	[AFFECTATIONS:3]type:5:="AFFECTATION_OPERATIONNELLE"
	SAVE RECORD:C53([AFFECTATIONS:3])
	CREATE RECORD:C68([AFFECTATIONS:3])
	[AFFECTATIONS:3]date_debut:6:="2023-01-01T00:00:00+01:00"
	[AFFECTATIONS:3]date_fin:7:=""
	[AFFECTATIONS:3]id_affectation:2:=$matricule+"-3_"+$idUF
	[AFFECTATIONS:3]id_agent:3:=$matricule+"-3"
	[AFFECTATIONS:3]id_uf:4:=$idUF
	[AFFECTATIONS:3]type:5:="AFFECTATION_APPLICATIVE"
	SAVE RECORD:C53([AFFECTATIONS:3])
End for 
