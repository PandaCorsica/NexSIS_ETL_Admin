//%attributes = {}
// Cette méthode écrit sur NexSIS les CRSS qu'on vient de récupérer comme passés en compta pour qu'ils ne soient plus modifiés

While (Not:C34(End selection:C36([crss_validation:154])))
	// on écrit que ce CRSS est traité en compta
	NEXT RECORD:C51([crss_validation:154])
End while 
