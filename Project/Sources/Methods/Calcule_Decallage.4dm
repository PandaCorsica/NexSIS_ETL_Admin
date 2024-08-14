//%attributes = {}
C_LONGINT:C283($TS; $1)
$TS:=$1

$date:=TS_Vers_Date($TS)
$annee:=Year of:C25($date)

$dernierSamediMars:=Date:C102("31/03/"+String:C10($annee))

While (Day number:C114($dernierSamediMars)#7)
	$dernierSamediMars:=Add to date:C393($dernierSamediMars; 0; 0; -1)
End while 
$dernierSamediMars:=Add to date:C393($dernierSamediMars; 0; 0; 1)  // en fait le changement a lieu le dimanche

$TS_DernierSamediMars:=4DStmp_Write($dernierSamediMars; ?02:00:00?)

$dernierSamediOctobre:=Date:C102("31/10/"+String:C10($annee))

While (Day number:C114($dernierSamediOctobre)#7)
	$dernierSamediOctobre:=Add to date:C393($dernierSamediOctobre; 0; 0; -1)
End while 
$dernierSamediOctobre:=Add to date:C393($dernierSamediOctobre; 0; 0; 1)  // en fait le changement a lieu le dimanche

$TS_DernierSamediOctobre:=4DStmp_Write($dernierSamediOctobre; ?02:00:00?)


If ($TS>$TS_DernierSamediMars) & ($TS<$TS_DernierSamediOctobre)
	$decallage:=2  // heure d'été
Else 
	$decallage:=1  // heure d'hiver
End if 


$0:=$decallage