//%attributes = {}
$date:=!2024-01-01!

Repeat 
	Recupere_Donnees_Chaudes($date)
	$date:=Add to date:C393($date; 0; 0; 1)
Until ($date>Current date:C33)
