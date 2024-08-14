//%attributes = {}
$nom:=Replace string:C233([INDIVIDUS:1]nom_patronymique:4; " "; "")
$nom:=Replace string:C233([INDIVIDUS:1]nom_patronymique:4; "-"; "")
$nom:=Lowercase:C14($nom)

$prenom:=Replace string:C233([INDIVIDUS:1]prenom:5; " "; "")
$prenom:=Replace string:C233([INDIVIDUS:1]prenom:5; "-"; "")
$prenom:=Lowercase:C14($prenom)

$source:=$nom+"|"+$prenom+"|"+Replace string:C233(String:C10([INDIVIDUS:1]date_naissance:6; Interne date long:K1:5); "/"; "")+"|"+[INDIVIDUS:1]commune_naissance:8
CONVERT FROM TEXT:C1011($source; "utf-8"; $sourceData)
[INDIVIDUS:1]id_individu:2:=SHA256($sourceData; Crypto HEX)

//traitement des ID qui étaient en base et qui doivent être conservés
Case of 
	: ([INDIVIDUS:1]Matricule:10="5743")
		[INDIVIDUS:1]id_individu:2:="b1c9026254d6d7721b08084e2c8543f955705ded0f8643646f96b8c6bc71af66"
	: ([INDIVIDUS:1]Matricule:10="5558")
		[INDIVIDUS:1]id_individu:2:="150ee34052e10668defc470b72471f6e32363356f8c0644f4b0d3ab67fccb55c"
	: ([INDIVIDUS:1]Matricule:10="5120")
		[INDIVIDUS:1]id_individu:2:="f63063ea2f92b25c27c830249227407e91197c1f48c87558f16f253d7ceb8f91"
	: ([INDIVIDUS:1]Matricule:10="4921")
		[INDIVIDUS:1]id_individu:2:="12aaee4b5fc8212368a2a94c6f5917760739955d62cb1c561e835a6b834aae20"
	: ([INDIVIDUS:1]Matricule:10="5575")
		[INDIVIDUS:1]id_individu:2:="ff6d1aa7dab248c886bc6fe11eb10e1be609dfb3d9d0a3d84c113d5e94f04f8c"
	: ([INDIVIDUS:1]Matricule:10="5359")
		[INDIVIDUS:1]id_individu:2:="93489803a3522dc1b7e320dd3945c3e805c1e931f435191878bad31a7b42ccf8"
	: ([INDIVIDUS:1]Matricule:10="4944")
		[INDIVIDUS:1]id_individu:2:="e78383159b8921bd37db09d1eb69d637a79232c62d071afb407f2e9bbb04d488"
	: ([INDIVIDUS:1]Matricule:10="763")
		[INDIVIDUS:1]id_individu:2:="7e730fa86561b7dba1b687ec6102a60a54f9b943ae9ea0e8713b0e3f725f09d7"
	: ([INDIVIDUS:1]Matricule:10="5478")
		[INDIVIDUS:1]id_individu:2:="c23bf834de7ef950cd476880cdf4a8add4e11896837d9c9b90f98dc0dfadec71"
	Else   // cas normal
End case 
