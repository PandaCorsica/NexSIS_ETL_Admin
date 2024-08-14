//%attributes = {}
C_OBJECT:C1216($1)
C_TEXT:C284($2; $3)
If ($1.value.$2=$3)
	$1.result:=True:C214
Else 
	$1.result:=False:C215
End if 