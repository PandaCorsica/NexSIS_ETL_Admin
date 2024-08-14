//%attributes = {}
ALL RECORDS:C47([AGENTS:2])
While (Not:C34(End selection:C36([AGENTS:2])))
	QUERY:C277([AFFECTATIONS:3]; [AFFECTATIONS:3]id_agent:3=[AGENTS:2]id_agent:3; *)
	QUERY:C277([AFFECTATIONS:3]; [AFFECTATIONS:3]type:5="AFFECTATION_OPERATIONNELLE")
	While (Not:C34(End selection:C36([AFFECTATIONS:3])))
		QUERY:C277([COMPETENCES:4]; [COMPETENCES:4]competence:3="COND VL"; *)
		QUERY:C277([COMPETENCES:4]; [COMPETENCES:4]id_affectation:2=[AFFECTATIONS:3]id_affectation:2; *)
		QUERY:C277([COMPETENCES:4]; [COMPETENCES:4]Matricule:4=[AGENTS:2]matricule:5)
		If (Records in selection:C76([COMPETENCES:4])=0)
			CREATE RECORD:C68([COMPETENCES:4])
			[COMPETENCES:4]competence:3:="COND VL"
			[COMPETENCES:4]id_affectation:2:=[AFFECTATIONS:3]id_affectation:2
			[COMPETENCES:4]Matricule:4:=[AGENTS:2]matricule:5
			[COMPETENCES:4]id_agent:5:=[AGENTS:2]id_agent:3
			SAVE RECORD:C53([COMPETENCES:4])
		End if 
		NEXT RECORD:C51([AFFECTATIONS:3])
	End while 
	NEXT RECORD:C51([AGENTS:2])
	
End while 
