//%attributes = {}
QUERY:C277([fdg_service_fait:124]; [fdg_service_fait:124]annee:42=2024; *)
QUERY:C277([fdg_service_fait:124]; [fdg_service_fait:124]mois:43=1; *)
QUERY:C277([fdg_service_fait:124]; [fdg_service_fait:124]date_archivage:18#""; *)
QUERY:C277([fdg_service_fait:124]; [fdg_service_fait:124]code_statut_rh:9="SPV"; *)
QUERY:C277([fdg_service_fait:124]; [fdg_service_fait:124]code_position_administrative:36#""; *)
QUERY:C277([fdg_service_fait:124]; [fdg_service_fait:124]code_position_administrative:36#"A"; *)
QUERY:C277([fdg_service_fait:124]; [fdg_service_fait:124]code_position_administrative:36#"CDT"; *)
QUERY:C277([fdg_service_fait:124]; [fdg_service_fait:124]code_position_administrative:36#"EX"; *)
QUERY:C277([fdg_service_fait:124]; [fdg_service_fait:124]code_position_administrative:36#"nan"; *)
QUERY:C277([fdg_service_fait:124]; [fdg_service_fait:124]code_position_administrative:36#"None"; *)
QUERY:C277([fdg_service_fait:124]; [fdg_service_fait:124]code_position_administrative:36#"SHR")

SELECTION TO ARRAY:C260([fdg_service_fait:124]id:1; $TIDFDG)

For ($i; 1; Size of array:C274($TIDFDG))
	QUERY:C277([fdg_service_fait:124]; [fdg_service_fait:124]id:1=$TIDFDG{$i})
	$idAgent:=[fdg_service_fait:124]id_agent:6
	$statut:=[fdg_service_fait:124]code_statut_rh:9
	$codeUF:=[fdg_service_fait:124]code_unite_fonctionnelle:10
	$dateDebut:=[fdg_service_fait:124]date_debut:12
	$dateFin:=[fdg_service_fait:124]date_fin:13
	$posAdmin:=[fdg_service_fait:124]code_position_administrative:36
	QUERY:C277([fdg_service_fait:124]; [fdg_service_fait:124]id_agent:6=$idAgent; *)
	QUERY:C277([fdg_service_fait:124]; [fdg_service_fait:124]code_statut_rh:9=$statut; *)
	QUERY:C277([fdg_service_fait:124]; [fdg_service_fait:124]code_unite_fonctionnelle:10=$codeUF; *)
	QUERY:C277([fdg_service_fait:124]; [fdg_service_fait:124]date_debut:12>=$dateDebut; *)
	QUERY:C277([fdg_service_fait:124]; [fdg_service_fait:124]date_fin:13<=$dateFin)
	$nb:=Records in selection:C76([fdg_service_fait:124])
	APPLY TO SELECTION:C70([fdg_service_fait:124]; [fdg_service_fait:124]nombre:46:=$nb)
	
End for 
