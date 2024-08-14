//%attributes = {}
// calcule si l'année de la date fourne est bisextile
$date:=$1

$annee:=Year of:C25($date)
$bisextile:=False:C215

Case of 
	: ($annee/4)#($annee\4)
		// annee non divisible par 4 : non bisextile
	: ($annee/400)=($annee\400)
		// annee  divisible par 400 : bisextile
		$bisextile:=True:C214
	: ($annee/100)=($annee\100)
		// annee divisible par 100 : non bisextile
	Else 
		// annee divisible par 4 mais pas par 100 : bisextile
		$bisextile:=True:C214
End case 

$0:=$bisextile