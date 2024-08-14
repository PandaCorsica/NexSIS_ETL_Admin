//%attributes = {}
$heureATester:=$1
$retour:=False:C215
If (String:C10(Current time:C178(*); h mn:K7:2)=$heureATester)
	$retour:=True:C214
End if 
$0:=$retour