//%attributes = {}
// cette méthode convertit une chaine date/heure au format ISO en format JJ/MM/AAAA hh:mm:ss
$date:=Date:C102($1)
$heure:=Time:C179($1)

$0:=String:C10($date; Interne date court:K1:7)+" "+String:C10($heure; h mn s:K7:1)