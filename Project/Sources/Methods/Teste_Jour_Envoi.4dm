//%attributes = {}
$jourSemaine:=Day number:C114(Current date:C33(*))-1
If ($jourSemaine=0)
	$jourSemaine:=7
End if 
$0:=([ENVOI_RAPPORTS:181]Periodicite:4[[$jourSemaine]]="1")