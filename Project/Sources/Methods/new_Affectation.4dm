//%attributes = {}
$idAgent:=$1
$idAffectation:=$1+"_"+$2
$idUF:=$2
$type:=$3


QUERY:C277([AFFECTATIONS:3]; [AFFECTATIONS:3]id_agent:3=$idAgent; *)
QUERY:C277([AFFECTATIONS:3]; [AFFECTATIONS:3]id_affectation:2=$idAffectation; *)
QUERY:C277([AFFECTATIONS:3]; [AFFECTATIONS:3]id_uf:4=$idUF; *)
QUERY:C277([AFFECTATIONS:3]; [AFFECTATIONS:3]type:5=$type)
If (Records in selection:C76([AFFECTATIONS:3])=0)
	CREATE RECORD:C68([AFFECTATIONS:3])
	[AFFECTATIONS:3]date_debut:6:="2023-11-10T00:00:00+01:00"
	[AFFECTATIONS:3]date_fin:7:=""
	[AFFECTATIONS:3]id_affectation:2:=$idAffectation
	[AFFECTATIONS:3]id_agent:3:=$idAgent
	[AFFECTATIONS:3]id_uf:4:=$idUF
	[AFFECTATIONS:3]type:5:=$type
	SAVE RECORD:C53([AFFECTATIONS:3])
End if 
