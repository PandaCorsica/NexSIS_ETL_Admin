//%attributes = {}
QUERY:C277([fdg_service_fait:124]; [fdg_service_fait:124]nom_agent_valideur_1:20=Null:C1517; *)
QUERY:C277([fdg_service_fait:124]; [fdg_service_fait:124]nom_agent_valideur_2:26=Null:C1517; *)
QUERY:C277([fdg_service_fait:124]; [fdg_service_fait:124]date_archivage:18=Null:C1517; *)
QUERY:C277([fdg_service_fait:124]; [fdg_service_fait:124]code_unite_fonctionnelle:10="02a-LEV")
QUERY SELECTION BY FORMULA:C207([fdg_service_fait:124]; Date:C102([fdg_service_fait:124]date_debut:12)>=!2024-04-01!)
