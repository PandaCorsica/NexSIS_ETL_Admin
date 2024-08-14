//%attributes = {}
// calcule ne numéro du jour de l'annee d'une date fournie en parametre
$date:=$1

$annee:=Year of:C25($date)
$mois:=Month of:C24($date)
$jour:=Day of:C23($date)

$aAjouter:=Num:C11(Est_bisextile($date))

$numero:=$jour

Case of 
	: ($mois=1)
		// rien à ajouter
	: ($mois=2)
		$numero:=$numero+31
	: ($mois=3)
		$numero:=$numero+31+28+$aAjouter
	: ($mois=4)
		$numero:=$numero+31+28+$aAjouter+31
	: ($mois=5)
		$numero:=$numero+31+28+$aAjouter+31+30
	: ($mois=6)
		$numero:=$numero+31+28+$aAjouter+31+30+31
	: ($mois=7)
		$numero:=$numero+31+28+$aAjouter+31+30+31+30
	: ($mois=8)
		$numero:=$numero+31+28+$aAjouter+31+30+31+30+31
	: ($mois=9)
		$numero:=$numero+31+28+$aAjouter+31+30+31+30+31+31
	: ($mois=10)
		$numero:=$numero+31+28+$aAjouter+31+30+31+30+31+31+30
	: ($mois=11)
		$numero:=$numero+31+28+$aAjouter+31+30+31+30+31+31+30+31
	: ($mois=12)
		$numero:=$numero+31+28+$aAjouter+31+30+31+30+31+31+30+31+30
End case 

$0:=$numero