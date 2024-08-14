//%attributes = {}
DM_Traitement_Automatise

Repeat 
	$heureCourante:=Current time:C178(*)
	If (Num:C11(Substring:C12(String:C10($heureCourante; h mn:K7:2); 1; 2))=2)  // déclenchement à 1h du matin
		DM_Traitement_Automatise
	End if 
	// on endort le process pendant 1h
	DELAY PROCESS:C323(Current process:C322; 3600*60)
Until (False:C215)