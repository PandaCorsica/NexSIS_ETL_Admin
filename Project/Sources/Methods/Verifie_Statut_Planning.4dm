//%attributes = {}
$statut:=$1
$TSDebut:=$2
$TSFin:=$3
$matricule:=$4

QUERY:C277([PLANNINGS:156]; [PLANNINGS:156]Matricule:5=$matricule)
QUERY SELECTION BY FORMULA:C207([PLANNINGS:156]; Not:C34(([PLANNINGS:156]TSDebut:17>$TSFin) & ([PLANNINGS:156]TSFin:18<$TSDebut)))
If (Records in selection:C76([PLANNINGS:156])#0)
	$newStatut:=[PLANNINGS:156]Categorie:2
Else 
	$newStatut:=$statut
End if 
$0:=$newStatut
