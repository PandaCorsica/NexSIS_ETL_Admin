//%attributes = {}
$dateDebut:=!2024-05-01!
$dateFin:=!2024-05-13!
QUERY BY FORMULA:C48([sgo_operation:110]; Date:C102([sgo_operation:110]date_reception:15)>=$dateDebut; *)
QUERY BY FORMULA:C48([sgo_operation:110]; Date:C102([sgo_operation:110]date_reception:15)<=$dateFin)
C_COLLECTION:C1488($liste)
$liste:=New collection:C1472
$compteur:=0
While (Not:C34(End selection:C36([sgo_operation:110])))
	//numinter->numerode l’intervention
	//date_inter->datede l’intervention
	//heure_inter-heure de l’intervention
	//commune->communede l’intervention
	//adresse->adressede l’intervention
	//motif->motifde l’intervention
	//centre-centre qui a fait l’intervention
	//url_page -> url à ouvrir sur clic
	QUERY:C277([sgo_localisation:95]; [sgo_localisation:95]id_operation:10=[sgo_operation:110]id_operation:2)
	QUERY:C277([sga_create_affaire:134]; [sga_create_affaire:134]numero_affaire:2=[sgo_operation:110]id_affaire:10)
	QUERY:C277([sga_traitement:120]; [sga_traitement:120]numero_alerte:11=[sga_create_affaire:134]id_alerte_initiale:9)
	$myObj:=New object:C1471("numinter"; [sgo_operation:110]numero:3; "date_inter"; String:C10(Date:C102([sgo_operation:110]date_reception:15); Interne date court:K1:7); "heure_inter"; String:C10(Time:C179([sgo_operation:110]date_reception:15); h mn:K7:2); "commune"; [sgo_localisation:95]commune:7; "adresse"; [sgo_localisation:95]denomination_voie:9; "motif"; [sga_traitement:120]nature_de_fait_0_label:14+"-"+[sga_traitement:120]nature_de_fait_1_label:16; "url_page"; [sgo_operation:110]url_sgo_operation:17)
	$liste[$compteur]:=$myObj
	CLEAR VARIABLE:C89($myObj)
	$compteur:=$compteur+1
	NEXT RECORD:C51([sgo_operation:110])
End while 
$reponse:=JSON Stringify array:C1228($liste)
