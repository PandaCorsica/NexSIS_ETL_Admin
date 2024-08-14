//%attributes = {}
$nom:="TECHNIQUE2A"
$prenom:="Paul"
login:="paul.technique2a@sis2a.corsica"
$Naissance:="09012019"
$lieu:="75115"

$source:=$nom+"|"+$prenom+"|"+$Naissance+"|"+$lieu
CONVERT FROM TEXT:C1011($source; "utf-8"; $sourceData)
$codage:=SHA256($sourceData; Crypto HEX)

