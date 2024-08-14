If (FORM Event:C1606.code=Sur chargement:K2:1)
	$url:="https://nexsis.prod.nexsis18-112.fr/portail"
	//$url:="https://nexsis.prod.nexsis18-112.fr/sgo/uf/02a-cgo/operations/1fd808a9-54d8-4309-a7c2-b17c6b39d0e1/suivi-operation/main-courante?statut=A_TRAITER,EN_COURS&tri-operation=par-defaut"
	WA OPEN URL:C1020(*; "WebArea"; $url)
	
End if 