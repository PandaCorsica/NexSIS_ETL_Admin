//%attributes = {}
$CodeNF:=Substring:C12($1; 1; 3)
$retour:=""
Case of 
	: ($CodeNF="C01")
		$retour:="901"
	: ($CodeNF="C02")
		$retour:="902"
	: ($CodeNF="C03")
		$retour:="903"
	: ($CodeNF="C04")
		$retour:="904"
	: ($CodeNF="C05")
		$retour:="905"
	: ($CodeNF="C06")
		$retour:="906"
	: ($CodeNF="C07")
		$retour:="907"
	: ($CodeNF="C08")
		$retour:="908"
	: ($CodeNF="C09")
		$retour:="909"
	: ($CodeNF="C10")
		$retour:="910"
	: ($CodeNF="C11")
		$retour:="911"
	Else 
		$retour:="911"  // cas où les NF n'ont pas pu être récupérées
End case 
$0:=$retour