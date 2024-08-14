//%attributes = {}
$mot:=$1

$mot:=Lowercase:C14($mot)
$maj:=Uppercase:C13(Substring:C12($mot; 1; 1))
$mot[[1]]:=$maj

$pos:=Position:C15("-"; $mot)
If ($pos>0)
	$maj:=Uppercase:C13(Substring:C12($mot; $pos+1; 1))
	$mot[[$pos+1]]:=$maj
End if 

$pos:=Position:C15(" "; $mot)
If ($pos>0)
	$maj:=Uppercase:C13(Substring:C12($mot; $pos+1; 1))
	$mot[[$pos+1]]:=$maj
End if 


$0:=$mot