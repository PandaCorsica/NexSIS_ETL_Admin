//%attributes = {}
$idAffectation:=$1
$idHabilitation:=$2

QUERY:C277([HABILITATIONS:52]; [HABILITATIONS:52]id_affectation:2=$idAffectation; *)
QUERY:C277([HABILITATIONS:52]; [HABILITATIONS:52]id_habilitation:3=$idHabilitation)
If (Records in selection:C76([HABILITATIONS:52])=0)
	CREATE RECORD:C68([HABILITATIONS:52])
	[HABILITATIONS:52]id_affectation:2:=$idAffectation
	[HABILITATIONS:52]id_habilitation:3:=$idHabilitation
	SAVE RECORD:C53([HABILITATIONS:52])
End if 