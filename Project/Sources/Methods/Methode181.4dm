//%attributes = {}
ALL RECORDS:C47([fdg_service_fait:124])
CREATE SET:C116([fdg_service_fait:124]; "tout")
QUERY SELECTION BY FORMULA:C207([fdg_service_fait:124]; Substring:C12([fdg_service_fait:124]code_position_administrative:36; 1; 2)="")
//CHERCHER([fdg_service_fait]; [fdg_service_fait]code_position_administrative#"G"; *)
//CHERCHER([fdg_service_fait]; [fdg_service_fait]code_position_administrative#"A"; *)
//CHERCHER([fdg_service_fait]; [fdg_service_fait]code_position_administrative#"CDT"; *)
QUERY SELECTION:C341([fdg_service_fait:124]; [fdg_service_fait:124]code_statut_rh:9="SPV"; *)
QUERY SELECTION:C341([fdg_service_fait:124]; [fdg_service_fait:124]disponibilite_temporelle:14="DISPONIBLE_0")
QUERY SELECTION BY FORMULA:C207([fdg_service_fait:124]; Substring:C12([fdg_service_fait:124]date_archivage:18; 1; 2)="")
CREATE SET:C116([fdg_service_fait:124]; "apayer")
DIFFERENCE:C122("tout"; "apayer"; "tout")
USE SET:C118("tout")
DELETE SELECTION:C66([fdg_service_fait:124])
USE SET:C118("apayer")
CLEAR SET:C117("tout")
CLEAR SET:C117("apayer")
$compte:=0
While (Not:C34(End selection:C36([fdg_service_fait:124])))
	If (Substring:C12([fdg_service_fait:124]date_archivage:18; 1; 2)="")
		
	Else 
		
	End if 
	
	NEXT RECORD:C51([fdg_service_fait:124])
End while 
