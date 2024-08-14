//%attributes = {}
QUERY:C277([sga_traitement:120]; [sga_traitement:120]nature_de_fait_2_label:18="@ascenseur@")
$nombre:=0
While (Not:C34(End selection:C36([sga_traitement:120])))
	QUERY:C277([sga_localisation_appel:128]; [sga_localisation_appel:128]numero_alerte:2=[sga_traitement:120]numero_alerte:11)
	If ([sga_localisation_appel:128]code_insee_appel:5="2A247")
		$nombre:=$nombre+1
	End if 
	NEXT RECORD:C51([sga_traitement:120])
End while 
