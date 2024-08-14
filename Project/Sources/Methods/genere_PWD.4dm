//%attributes = {}
C_TEXT:C284($0)

$caractersList:="0123456789abcdefghjkmnopqrstuvwxyzABCDEFGHJKLMNOPQRSTUVWXYZ-_*?+!"

$passwd:=""

For ($i; 1; 8)
	If ($i=1)
		$indice:=(Random:C100%59)+1
	Else 
		$indice:=(Random:C100%65)+1
	End if 
	$passwd:=$passwd+$caractersList[[$indice]]
End for 

$0:=$passwd