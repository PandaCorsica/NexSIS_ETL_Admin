//%attributes = {}
ALL RECORDS:C47([HABILITATIONS:52])
DELETE SELECTION:C66([HABILITATIONS:52])


QUERY BY FORMULA:C48([AGENTS_PROFILS:138]; Substring:C12([AGENTS_PROFILS:138]Affectation:3; 1; 1)#"_")
While (Not:C34(End selection:C36([AGENTS_PROFILS:138])))
	//on charge les elements du profil
	QUERY:C277([PROFILS:122]; [PROFILS:122]Nom_Profil:3=[AGENTS_PROFILS:138]Nom_Profil:2)
	RELATE ONE SELECTION:C349([PROFILS:122]; [REF_HABILITATIONS:51])
	While (Not:C34(End selection:C36([REF_HABILITATIONS:51])))  // toutes les habilitations que doit avoir l'agent
		// on cherche si l'affectation existe
		Case of 
			: ([REF_HABILITATIONS:51]Portee:7="cgo")
			: ([REF_HABILITATIONS:51]Portee:7="cga")
			: ([REF_HABILITATIONS:51]Portee:7="cga_cta")
			: ([REF_HABILITATIONS:51]Portee:7="cga_cta_po")
			: ([REF_HABILITATIONS:51]Portee:7="CGA_national-CTA_orphelins")
			: ([REF_HABILITATIONS:51]Portee:7="sis")
			: ([REF_HABILITATIONS:51]Portee:7="uf")
				
		End case 
		QUERY:C277([AFFECTATIONS:3]; [AFFECTATIONS:3]id_affectation:2=[AGENTS:2]
		NEXT RECORD:C51([REF_HABILITATIONS:51])
	End while 
	
	NEXT RECORD:C51([AGENTS_PROFILS:138])
End while 













//old
ALL RECORDS:C47([AGENTS_PROFILS:138])
QUERY BY FORMULA:C48([AGENTS_PROFILS:138]; Substring:C12([AGENTS_PROFILS:138]Affectation:3; 1; 1)#"_")
DISTINCT VALUES:C339([AGENTS_PROFILS:138]Affectation:3; $TAffectations)

For ($i; 1; Size of array:C274($TAffectations))
	QUERY:C277([AGENTS_PROFILS:138]; [AGENTS_PROFILS:138]Affectation:3=$TAffectations{$i})
	RELATE ONE SELECTION:C349([AGENTS_PROFILS:138]; [PROFILS:122])
	RELATE ONE SELECTION:C349([PROFILS:122]; [REF_HABILITATIONS:51])
	While (Not:C34(End selection:C36([REF_HABILITATIONS:51])))
		QUERY:C277([AFFECTATIONS:3]; [AFFECTATIONS:3]id_affectation:2=$TAffectations{$i})
		$pos:=Position:C15("_"; $TAffectations{$i})
		If ((Substring:C12($TAffectations{$i}; $pos+1)=[REF_HABILITATIONS:51]Portee:7) | ([REF_HABILITATIONS:51]Portee:7="uf"))
			CREATE RECORD:C68([HABILITATIONS:52])
			[HABILITATIONS:52]id_affectation:2:=$TAffectations{$i}
			[HABILITATIONS:52]id_habilitation:3:=[REF_HABILITATIONS:51]Code:2
			SAVE RECORD:C53([HABILITATIONS:52])
		End if 
		NEXT RECORD:C51([REF_HABILITATIONS:51])
	End while 
	
	
End for 

//corrections_Habilitations_Speci
