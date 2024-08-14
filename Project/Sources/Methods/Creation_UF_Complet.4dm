//%attributes = {}
$idUFSis:="SIS2A"
// Création du SIS2A
QUERY:C277([UF:5]; [UF:5]id_uf:5=$idUFSis)
If (Records in selection:C76([UF:5])=0)
	CREATE RECORD:C68([UF:5])
	[UF:5]id_uf:5:=$idUFSis
	[UF:5]id_uf_pere:6:=""
	[UF:5]libelle:2:="SIS 2A"
	[UF:5]type_dept:4:="SIS"
	[UF:5]type_reglementaire:3:="SDIS"
	[UF:5]type_UF:8:="O"  //affectations ops
	SAVE RECORD:C53([UF:5])
End if 

