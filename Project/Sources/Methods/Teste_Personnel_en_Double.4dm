//%attributes = {}
// on teste d'abord s'il y a plusieurs engins du même nom sur le rapport
$nbtotal:=Records in selection:C76([PARTICIPATION_AGENT:163])
DISTINCT VALUES:C339([PARTICIPATION_AGENT:163]Matricule:3; $TMatricules)
If (Size of array:C274($TMatricules)#$nbtotal)
	// au moins un agent est en double
	// on va regarder pour chaque agent si les horaires se chevauchent sur cette inter
	CREATE SET:C116([PARTICIPATION_AGENT:163]; "agents")
	For ($i; 1; Size of array:C274($TMatricules))
		USE SET:C118("agents")
		QUERY SELECTION:C341([PARTICIPATION_AGENT:163]; [PARTICIPATION_AGENT:163]Matricule:3=$TMatricules{$i})
		ORDER BY:C49([PARTICIPATION_AGENT:163]; [PARTICIPATION_AGENT:163]TSDebut:14; >)
		$tsFinPrecedent:=0
		While (Not:C34(End selection:C36([PARTICIPATION_AGENT:163])))
			If ([PARTICIPATION_AGENT:163]TSDebut:14<=$tsFinPrecedent) & ([PARTICIPATION_AGENT:163]TSFin:15>=$tsFinPrecedent)
				// si il y a un chevauchement
				[PARTICIPATION_AGENT:163]TSDebut:14:=$tsFinPrecedent  //
				If ([PARTICIPATION_AGENT:163]TSDebut:14>=[PARTICIPATION_AGENT:163]TSFin:15)
					[PARTICIPATION_AGENT:163]toDelete:18:=True:C214
				End if 
				SAVE RECORD:C53([PARTICIPATION_AGENT:163])
			End if 
			$tsFinPrecedent:=[PARTICIPATION_AGENT:163]TSFin:15
			NEXT RECORD:C51([PARTICIPATION_AGENT:163])
		End while 
		
	End for 
	CLEAR SET:C117("agents")
Else 
	// pas de pb sur les agents
End if 
