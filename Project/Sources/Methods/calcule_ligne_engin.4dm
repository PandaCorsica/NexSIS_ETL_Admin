//%attributes = {}

$nbtrouves:=Records in selection:C76([PARTICIPATION_ENGIN:164])

$ligneEngin:=String:C10($nbtrouves)+"|"
While (Not:C34(End selection:C36([PARTICIPATION_ENGIN:164])))
	$ligneEngin:=$ligneEngin+[PARTICIPATION_ENGIN:164]Nom_Vehicule:2+"|1|0|0|0|"
	$ligneEngin:=$ligneEngin+Convertit_DateHeure_ISO_vers_DD([PARTICIPATION_ENGIN:164]Debut:3)+"|"
	$ligneEngin:=$ligneEngin+Convertit_DateHeure_ISO_vers_DD([PARTICIPATION_ENGIN:164]Fin:4)+"|"
	[PARTICIPATION_ENGIN:164]Paye:16:=True:C214
	SAVE RECORD:C53([PARTICIPATION_ENGIN:164])
	NEXT RECORD:C51([PARTICIPATION_ENGIN:164])
End while 

If ($nbtrouves#0)
	$0:=$ligneEngin
Else 
	$0:=""
End if 