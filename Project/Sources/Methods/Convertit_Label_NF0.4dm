//%attributes = {}
$CodeNF:=Substring:C12($1; 1; 3)
$retour:=""
Case of 
	: ($CodeNF="C01")
		$retour:="Accident de circulation"
	: ($CodeNF="C02")
		$retour:="Atteintes aux personnes"
	: ($CodeNF="C03")
		$retour:="Atteinte aux biens ou animaux"
	: ($CodeNF="C04")
		$retour:="Incendie"
	: ($CodeNF="C05")
		$retour:="Explosion"
	: ($CodeNF="C06")
		$retour:="Ordre public"
	: ($CodeNF="C07")
		$retour:="Ordre public"
	: ($CodeNF="C08")
		$retour:="Aléa naturel"
	: ($CodeNF="C09")
		$retour:="Aléa technologique"
	: ($CodeNF="C10")
		$retour:="Disparitions et découvertes"
	: ($CodeNF="C11")
		$retour:="Natures de fait diverses"
	Else 
		$retour:="Natures de fait diverses"  // cas où les NF n'ont pas pu être récupérées
End case 
$0:=$retour