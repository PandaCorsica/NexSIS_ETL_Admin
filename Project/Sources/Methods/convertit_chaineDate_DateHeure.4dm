//%attributes = {"publishedWeb":true}
$chaineDate:=$1
$myDate:=Date:C102($chaineDate)

$myHeure:=Time:C179($chaineDate)

If ($myDate#!00-00-00!)
	$0:=String:C10($myDate; Interne date abrégé:K1:6)+" "+String:C10($myHeure; h mn s:K7:1)
Else 
	$0:=""
End if 