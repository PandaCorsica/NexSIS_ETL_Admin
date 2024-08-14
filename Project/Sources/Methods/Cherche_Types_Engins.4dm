//%attributes = {}
ALL RECORDS:C47([IMPORT_MOYENS:43])
DISTINCT VALUES:C339([IMPORT_MOYENS:43]vecteur:3; $TVecteurs)

$doc:=Create document:C266(""; ".txt")
For ($i; 1; Size of array:C274($TVecteurs))
	SEND PACKET:C103($doc; $TVecteurs{$i}+Char:C90(Retour à la ligne:K15:40))
End for 
CLOSE DOCUMENT:C267($doc)
