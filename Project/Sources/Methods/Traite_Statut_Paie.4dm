//%attributes = {}



// on récupère d'abord le token
C_OBJECT:C1216($reponse)

ALL RECORDS:C47([PARAMETRES:27])
$urlToken:="https://nexsis.prod.nexsis18-112.fr/auth/realms/nexsis-public/protocol/openid-connect/token"

ARRAY TEXT:C222(HeaderNames_at; 1)
ARRAY TEXT:C222(HeaderValues_at; 1)
HeaderNames_at{1}:="Content-Type"
HeaderValues_at{1}:="application/x-www-form-urlencoded"

$body:="grant_type=client_credentials&client_id="+[PARAMETRES:27]ClientID_DC:7+"&client_secret="+[PARAMETRES:27]ClientSecret_DC:8

//$httpResult:=HTTP Request(HTTP méthode POST; $urlToken; $body; $reponse; HeaderNames_at; HeaderValues_at; *)

If (True:C214)  //($httpResult=200)
	//$token:=$reponse.access_token
	$token:="eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJsV1NDZHZ4alcwS3BFV21PYmdnX2RJSVVxR3E3UTdQTmhqdk91UzVFTExBIn0.eyJleHAiOjE3MTMxMDM1MTUsImlhdCI6MTcxMzA5MjcxNSwianRpIjoiNzQ3MDQ4OWQtNjdiNi00MmU0LTg3ZjEtNWQwZDg0MDRmNDBlIiwiaXNzIjoiaHR0cHM6Ly9uZXhzaXMucHJ"+"vZC5uZXhzaXMxOC0xMTIuZnIvYXV0aC9yZWFsbXMvbmV4c2lzLXB1YmxpYyIsImF1ZCI6WyJuZXhzaXMtZG9ubmVlcy1jaGF1ZGVzLWFwaSIsImFjY291bnQiXSwic3ViIjoiNDI2YzU2OWEtODkyOS00ODgzLTk4ZWMtMmJmM2UyZTFkMmQ3IiwidHlwIjoiQmVhcmVyIiwiYXpwIjoic2RpczJhLXB1YmxpYy1hcGktY2xpZW50Iiwicm"+"VhbG1fYWNjZXNzIjp7InJvbGVzIjpbImRlZmF1bHQtcm9sZXMtbmV4c2lzLXB1YmxpYyIsIm9mZmxpbmVfYWNjZXNzIiwidW1hX2F1dGhvcml6YXRpb24iXX0sInJlc291cmNlX2FjY2VzcyI6eyJhY2NvdW50Ijp7InJvbGVzIjpbIm1hbmFnZS1hY2NvdW50IiwibWFuYWdlLWFjY291bnQtbGlua3MiLCJ2aWV3LXByb2ZpbGUiXX19L"+"CJzY29wZSI6InByb2ZpbGUgbmV4c2lzLWRvbm5lZXMtY2hhdWRlcy1hcGkiLCJjbGllbnRIb3N0IjoiMTAuMTg5LjI1NS4yNTMiLCJjbGllbnRJZCI6InNkaXMyYS1wdWJsaWMtYXBpLWNsaWVudCIsImNvZGVfc2lzIjoiMDJhLXNpcyIsInByZWZlcnJlZF91c2VybmFtZSI6InNlcnZpY2UtYWNjb3VudC1zZGlzMmEtcHVibGljLWFw"+"aS1jbGllbnQiLCJjbGllbnRBZGRyZXNzIjoiMTAuMTg5LjI1NS4yNTMifQ.it2vPhjZUWyf6k2-dN57jbyDLYYPpKxCr-FvCU6lYbDYLsi-rQEVJ2lj2Jik2D6EMgNdo_oM-FD1XfR1EzopQyy5-jFN10WdU7m545cKffJrjtF4nUMZaH9RAyg2pEB7K05nut76ro_4S2q7cOzo5VbZP8C46SQ2RFpBoUOibxSGD6KSGQwpYEJ99ol12z0Z"+"y6eqsd1o2xWsvXwUeszVKSPjQbVxrHINWJozJFIQFQXH5moEtwM6rqHEytSTmKk-2Hftslc5O3PfWXEjynnYC-DLNXMOrSk1zb8dsUYpkiARHH73I5cAWloRr3dByrEbWxbU7UN-wx9l3NDJb7L_Wg"
	
	// On va maintenant mettre à jour le statut de paye
	$urlPaie:="https://nexsis.prod.nexsis18-112.fr/internet/api/crss/statut-de-paie"
	
	
	// temporaire pour le rattrapage des crss déjà payé en janvier février
	QUERY:C277([crss_validation:154]; [crss_validation:154]etat_validation:4="PAYE")
	Envoi_statuts_paie("VALIDE"; "PAYE"; $token; $urlPaie)
	
	// on va d'abord indiquer à NexSIS les crss qui sont passés en paiement
	QUERY:C277([crss_validation:154]; [crss_validation:154]etat_validation:4="A PAYER")
	// partie envoi par tranche de 100
	Envoi_statuts_paie("VALIDE"; "PAYE"; $token; $urlPaie)
	
	
	// on met les états validation à PAYE
	//APPLIQUER À SÉLECTION([crss_validation]etat_validation:="PAYE")
	
	
	// puis on va indiquer les CRSS refusés
	QUERY:C277([crss_validation:154]; [crss_validation:154]etat_validation:4="A REFUSER")
	// partie envoi
	Envoi_statuts_paie("PAS VALIDE"; "REFUSE"; $token; $urlPaie)
	
	// on met les états validation à REFUSE
	//APPLIQUER À SÉLECTION([crss_validation]etat_validation:="REFUSE")
	
	
End if 


