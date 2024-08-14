$evt:=Form event code:C388

Case of 
	: ($evt=Sur double clic:K2:5)
		CREATE SET:C116([UF:5]; "select")
		If (Records in set:C195("$UFChoisis")#0)
			USE SET:C118("$UFChoisis")
			USE SET:C118("$GeoUFRef")
			APPLY TO SELECTION:C70([UF:5]; [UF:5]geo_point:9:=[GEOUF:6]geo_point:3)
			APPLY TO SELECTION:C70([UF:5]; [UF:5]geo_surface:10:=[GEOUF:6]geo_surface:4)
			ALL RECORDS:C47([GEOUF:6])
			ORDER BY:C49([GEOUF:6]; [GEOUF:6]NomClair:5; >)
			ALL RECORDS:C47([UF:5])
			ORDER BY:C49([UF:5]; [UF:5]libelle:2; >)
		Else 
			ALERT:C41("Vous devez choisir une geoUF à modifier")
		End if 
End case 