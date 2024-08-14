//%attributes = {}
$cheminDossier:=$1
$doc2:=Create document:C266($cheminDossier+"erreursGeoUF.txt"; ".txt")
$erreur:=False:C215
$date:=String:C10(Current date:C33; Interne date court:K1:7)
$heure:=String:C10(Current time:C178; h mn s:K7:1)
$YYMMDD:=Substring:C12($date; 9)+Substring:C12($date; 4; 2)+Substring:C12($date; 1; 2)
$HHMMSS:=Replace string:C233($heure; ":"; "")
$doc:=Create document:C266($cheminDossier+"GEOUF.geojson"; ".geojson")
If (OK=1)
	$geojson:="{\"type\" : \"FeatureCollection\", \"features\" : ["
	
	ALL RECORDS:C47([UF:5])
	While (Not:C34(End selection:C36([UF:5])))
		If ([UF:5]geo_point:9="") | ([UF:5]geo_surface:10="")
			SEND PACKET:C103($doc2; "GeoUF non rempli : "+[UF:5]id_uf:5+Char:C90(Retour à la ligne:K15:40))
			$erreur:=True:C214
		End if 
		$geojson:=$geojson+"{\"type\": \"Feature\","+[UF:5]geo_point:9
		$geojson:=$geojson+", \"properties\" : {\"id_uf\": \""+[UF:5]id_uf:5+"\"}},"
		$geojson:=$geojson+"{\"type\": \"Feature\","+[UF:5]geo_surface:10
		$geojson:=$geojson+", \"properties\" : {\"id_uf\": \""+[UF:5]id_uf:5+"\"}},"
		
		NEXT RECORD:C51([UF:5])
	End while 
	$long:=Length:C16($geojson)
	$geojson:=Substring:C12($geojson; 1; $long-1)  // on en leve la derniere virgulr
	$geojson:=$geojson+"]}"
	SEND PACKET:C103($doc; $geojson)
	CLOSE DOCUMENT:C267($doc)
End if 
CLOSE DOCUMENT:C267($doc2)

$0:=$erreur