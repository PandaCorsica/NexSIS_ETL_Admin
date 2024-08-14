//%attributes = {}
// on teste d'abord s'il y a plusieurs engins du même nom sur le rapport
$message:=""
$nbtotal:=Records in selection:C76([PARTICIPATION_ENGIN:164])
DISTINCT VALUES:C339([PARTICIPATION_ENGIN:164]Nom_Vehicule:2; $TVehicules)
If (Size of array:C274($TVehicules)#$nbtotal)
	// au moins un vehicule est en double
	// on va regarder pour chaque vehicule si les horaires se chevauchent
	CREATE SET:C116([PARTICIPATION_ENGIN:164]; "engins")
	For ($i; 1; Size of array:C274($TVehicules))
		USE SET:C118("engins")
		QUERY SELECTION:C341([PARTICIPATION_ENGIN:164]; [PARTICIPATION_ENGIN:164]Nom_Vehicule:2=$TVehicules{$i})
		ORDER BY:C49([PARTICIPATION_ENGIN:164]; [PARTICIPATION_ENGIN:164]TSDebut:10; >)
		$tsFinPrecedent:=0
		While (Not:C34(End selection:C36([PARTICIPATION_ENGIN:164])))
			If ([PARTICIPATION_ENGIN:164]TSDebut:10<$tsFinPrecedent) & ([PARTICIPATION_ENGIN:164]TSFin:11>$tsFinPrecedent)
				// si il y a un chevauchement
				$message:=$message+[PARTICIPATION_ENGIN:164]Nom_Vehicule:2+" : recouvrement d'horaires-"
			End if 
			$tsFinPrecedent:=[PARTICIPATION_ENGIN:164]TSFin:11
			NEXT RECORD:C51([PARTICIPATION_ENGIN:164])
		End while 
		
	End for 
	CLEAR SET:C117("engins")
Else 
	// pas de pb sur les vehicules
End if 
