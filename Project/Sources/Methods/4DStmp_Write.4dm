//%attributes = {}
// ----------------------------------------------------
// Nom utilisateur (OS) : Olivier DESCHANELS
// ----------------------------------------------------
// Méthode : 4DStmp_Write
// Description
// Crée un stampcode à paretir d'une heure et d'une date
//
// Paramètres
// ----------------------------------------------------
C_DATE:C307($1)  //Date
C_TIME:C306($2)  //heure
C_LONGINT:C283($0)  //Stampcode

C_LONGINT:C283($heure_en_seconde; $seconde; $minute_en_seconde; $jours_en_seconde)
C_TEXT:C284($chaine_temps)

Case of 
	: (Count parameters:C259=0)
		$date_ref:=Current date:C33
		$heure_ref:=Current time:C178
	: (Count parameters:C259=1)
		$date_ref:=$1
		$heure_ref:=Current time:C178
	: (Count parameters:C259=2)
		$date_ref:=$1
		$heure_ref:=$2
End case 



$date_reference:=Add to date:C393(!00-00-00!; 1970; 1; 1)

$heure_en_seconde:=$heure_ref+0

$jours_en_seconde:=($date_ref-$date_reference)*86400


$0:=$jours_en_seconde+$heure_en_seconde
