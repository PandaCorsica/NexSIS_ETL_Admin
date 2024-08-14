//%attributes = {}
ALL RECORDS:C47([COMPETENCES:4])
$nb1:=Records in selection:C76([COMPETENCES:4])
ALL RECORDS:C47([AFFECTATIONS:3])
DISTINCT VALUES:C339([AFFECTATIONS:3]id_agent:3; $TIDAgent)  //les differents agents en tenant compte du statut
For ($i; 1; Size of array:C274($TIDAgent))
	QUERY:C277([AFFECTATIONS:3]; [AFFECTATIONS:3]id_agent:3=$TIDAgent{$i}; *)
	QUERY:C277([AFFECTATIONS:3]; [AFFECTATIONS:3]type:5="AFFECTATION_OPERATIONNELLE")
	DISTINCT VALUES:C339([AFFECTATIONS:3]id_uf:4; $TUF)  // les differentes UF d'affectation opérationnelle de cet agent
	QUERY:C277([COMPETENCES:4]; [COMPETENCES:4]id_agent:5=$TIDAgent{$i})  // on cherche les competences de cet agent toutes UF confondues dans ce statut
	CREATE SET:C116([COMPETENCES:4]; "competences")
	DISTINCT VALUES:C339([COMPETENCES:4]competence:3; $TCompetences)  //les différentes valeurs de competences de cet agent dans son statut
	ARRAY TEXT:C222($TAjoutCompetence; 0)
	ARRAY TEXT:C222($TAjoutUF; 0)
	For ($j; 1; Size of array:C274($TCompetences))  // on va regarder chaque competence
		USE SET:C118("competences")
		For ($k; 1; Size of array:C274($TUF))  // on va faire le test pour chaque UF de l'agent
			// on recherche si cette competence existe pour cet agent dans cette UF
			QUERY SELECTION:C341([COMPETENCES:4]; [COMPETENCES:4]competence:3=$TCompetences{$j}; *)
			QUERY SELECTION:C341([COMPETENCES:4]; [COMPETENCES:4]id_agent:5=$TIDAgent{$i}; *)
			QUERY SELECTION:C341([COMPETENCES:4]; [COMPETENCES:4]id_affectation:2=$TIDAgent{$i}+"_"+$TUF{$k})
			If (Records in selection:C76([COMPETENCES:4])=0)
				APPEND TO ARRAY:C911($TAjoutCompetence; $TCompetences{$j})
				APPEND TO ARRAY:C911($TAjoutUF; $TUF{$k})
			End if 
		End for 
	End for 
	CLEAR SET:C117("competences")
	For ($indice; 1; Size of array:C274($TAjoutCompetence))
		CREATE RECORD:C68([COMPETENCES:4])
		[COMPETENCES:4]competence:3:=$TAjoutCompetence{$indice}
		[COMPETENCES:4]id_affectation:2:=$TIDAgent{$i}+"_"+$TAjoutUF{$indice}
		[COMPETENCES:4]id_agent:5:=$TIDAgent{$i}
		$pos:=Position:C15("-"; $TIDAgent{$i})
		[COMPETENCES:4]Matricule:4:=Substring:C12($TIDAgent{$i}; 1; $pos-1)
		SAVE RECORD:C53([COMPETENCES:4])
	End for 
End for 

ALL RECORDS:C47([COMPETENCES:4])
$nb2:=Records in selection:C76([COMPETENCES:4])
$0:=String:C10($nb2-$nb1)