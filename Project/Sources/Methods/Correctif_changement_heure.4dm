//%attributes = {}
// cette méthode convertit une chaine date=heure en un objet contenant la date et l'heure au format réel prenant ne compte l'heure d'été
C_OBJECT:C1216($heureATransmettre; $0)
$chaineHeure:=$1
//$chaineHeure:="2024-03-04T06:00:00+00:00"

$date:=Date:C102($chaineHeure)
$heure:=Time:C179($chaineHeure)
$TSoriginal:=4DStmp_Write($date; $heure)
$chaineHeureCalculee:=String:C10($date; ISO date:K1:8; $heure)

// on vérifie si la date est en heure d'été
$dateJour:=Date:C102($chaineHeureCalculee)
$heureJour:=Time:C179($chaineHeureCalculee)
$TSActuel:=4DStmp_Write

$annee:=Year of:C25($date)

// calcul de la date du passage à l'heure d'été
$dernierSamediMars:=Date:C102("31/03/"+String:C10($annee))

While (Day number:C114($dernierSamediMars)#7)
	$dernierSamediMars:=Add to date:C393($dernierSamediMars; 0; 0; -1)
End while 
$dernierSamediMars:=Add to date:C393($dernierSamediMars; 0; 0; 1)  // en fait le changement a lieu le dimanche

$TS_DernierSamediMars:=4DStmp_Write($dernierSamediMars; ?02:00:00?)

// calcul de la date du passage à l'heure d'hiver
$dernierSamediOctobre:=Date:C102("31/10/"+String:C10($annee))

While (Day number:C114($dernierSamediOctobre)#7)
	$dernierSamediOctobre:=Add to date:C393($dernierSamediOctobre; 0; 0; -1)
End while 
$dernierSamediOctobre:=Add to date:C393($dernierSamediOctobre; 0; 0; 1)  // en fait le changement a lieu le dimanche

$TS_DernierSamediOctobre:=4DStmp_Write($dernierSamediOctobre; ?02:00:00?)


If ($TSoriginal>$TS_DernierSamediMars) & ($TSoriginal<$TS_DernierSamediOctobre)
	$decallage:=2  // heure d'été
Else 
	$decallage:=1  // heure d'hiver
End if 

If ($TSActuel>$TS_DernierSamediMars) & ($TSActuel<$TS_DernierSamediOctobre)
	$decallageActuel:=2  // heure d'été
Else 
	$decallageActuel:=1  // heure d'hiver
End if 
C_TIME:C306($newHeure)
$heureATransmettre:=New object:C1471
Case of 
	: ($decallage=$decallageActuel)  // la période à tester a le même décallage qu'actuellement
		// on n'applique aucun changement sur les date/heures indiqués
		OB SET:C1220($heureATransmettre; "date"; $date)
		OB SET:C1220($heureATransmettre; "heure"; $heure)
	: ($decallageActuel=2)  // on est en heure d'été mais la période concernée était en heure d'hiver
		// il faut rajouter 1h à l'heure de pa période concernée
		OB SET:C1220($heureATransmettre; "date"; $date)
		$newHeure:=Time:C179(TS_vers_Heure_XML($TSoriginal-3600))
		OB SET:C1220($heureATransmettre; "heure"; $newHeure)
	Else   // on est en heure d'hiver mais la période concernée était en heure d'été
		// il faut enlever 1h à l'heure de la période concernée
		OB SET:C1220($heureATransmettre; "date"; $date)
		$newHeure:=Time:C179(TS_vers_Heure_XML($TSoriginal+3600))
		OB SET:C1220($heureATransmettre; "heure"; $newHeure)
End case 

$0:=$heureATransmettre
