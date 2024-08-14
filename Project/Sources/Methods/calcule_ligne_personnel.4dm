//%attributes = {}
$nbtrouves:=Records in selection:C76([PARTICIPATION_AGENT:163])

$lignePersonnel:=String:C10($nbtrouves)+"|"
While (Not:C34(End selection:C36([PARTICIPATION_AGENT:163])))
	$lignePersonnel:=$lignePersonnel+[PARTICIPATION_AGENT:163]Matricule:3+"|"+[PARTICIPATION_AGENT:163]Nom:4+"|"+[PARTICIPATION_AGENT:163]Prenom:5+"|"+[PARTICIPATION_AGENT:163]statut:19+"|"+" "+[PARTICIPATION_AGENT:163]Grade:6+"|"+[PARTICIPATION_AGENT:163]Vehicule:7+"|"+"01|0|1|0000000000|0|0|"
	$lignePersonnel:=$lignePersonnel+Convertit_DateHeure_ISO_vers_DD([PARTICIPATION_AGENT:163]Debut:8)+"|"
	$lignePersonnel:=$lignePersonnel+Convertit_DateHeure_ISO_vers_DD([PARTICIPATION_AGENT:163]Fin:9)+"|"
	$lignePersonnel:=$lignePersonnel+"|"
	$lignePersonnel:=$lignePersonnel+"|"
	[PARTICIPATION_AGENT:163]Paye:21:=True:C214
	SAVE RECORD:C53([PARTICIPATION_AGENT:163])
	NEXT RECORD:C51([PARTICIPATION_AGENT:163])
End while 

If ($nbtrouves#0)
	$0:=$lignePersonnel
Else 
	$0:=""
End if 