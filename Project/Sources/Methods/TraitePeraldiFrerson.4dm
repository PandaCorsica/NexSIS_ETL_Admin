//%attributes = {}
C_TEXT:C284($1; $2; $mat; $clegrade)
$mat:=$1
$clegrade:=$2
C_TEXT:C284($0; $newCleGrade)

Case of 
	: ($mat="680")
		$newCleGrade:="510"  // colonel hors classe
	: ($mat="4978")
		$newCleGrade:="180"  // colonel
	Else 
		$newCleGrade:=$clegrade
End case 

$0:=$newCleGrade
