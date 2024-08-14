//%attributes = {}
ALL RECORDS:C47([HABILITATIONS:52])
DELETE SELECTION:C66([HABILITATIONS:52])


QUERY BY FORMULA:C48([AGENTS_PROFILS:138]; Substring:C12([AGENTS_PROFILS:138]Affectation:3; 1; 1)#"_")
While (Not:C34(End selection:C36([AGENTS_PROFILS:138])))
	If ([AGENTS_PROFILS:138]id_Agent:4="4403-0@")
		//TRACE
	End if 
	QUERY:C277([PROFILS:122]; [PROFILS:122]Nom_Profil:3=[AGENTS_PROFILS:138]Nom_Profil:2)
	RELATE ONE SELECTION:C349([PROFILS:122]; [REF_HABILITATIONS:51])
	While (Not:C34(End selection:C36([REF_HABILITATIONS:51])))  // toutes les habilitations que doit avoir l'agent
		Case of 
			: (([REF_HABILITATIONS:51]Code:2="SUIVRE_CONDUITE_OPS") | ([REF_HABILITATIONS:51]Code:2="LECTEUR_FDGPUB")) & (([AGENTS_PROFILS:138]Nom_Profil:2="Sous-Officier") | ([AGENTS_PROFILS:138]Nom_Profil:2="Chef de centre"))
				//on vérifie si l'habilitation applicative sis existe sinon on la crée
				new_habilitation([AGENTS_PROFILS:138]id_Agent:4+"_"+"sis"; [REF_HABILITATIONS:51]Code:2)
				new_Affectation([AGENTS_PROFILS:138]id_Agent:4; "sis"; "AFFECTATION_APPLICATIVE")
			: ([REF_HABILITATIONS:51]Portee:7="cga") & ([AGENTS_PROFILS:138]portee:5#"uf")
				//on vérifie si l'habilitation applicative CGA existe sinon on la crée
				new_habilitation([AGENTS_PROFILS:138]id_Agent:4+"_"+"cga"; [REF_HABILITATIONS:51]Code:2)
				new_Affectation([AGENTS_PROFILS:138]id_Agent:4; "cga"; "AFFECTATION_APPLICATIVE")
			: ([REF_HABILITATIONS:51]Portee:7="cgo") & ([AGENTS_PROFILS:138]portee:5#"uf")
				//on vérifie si l'habilitation et l'affectation applicative CGO existent sinon on les crée
				new_habilitation([AGENTS_PROFILS:138]id_Agent:4+"_"+"cgo"; [REF_HABILITATIONS:51]Code:2)
				new_Affectation([AGENTS_PROFILS:138]id_Agent:4; "cgo"; "AFFECTATION_APPLICATIVE")
			: ([REF_HABILITATIONS:51]Portee:7="cga_cta") & ([AGENTS_PROFILS:138]portee:5#"uf")
				//on vérifie si l'habilitation applicative CGA existe sinon on la crée
				new_habilitation([AGENTS_PROFILS:138]id_Agent:4+"_"+"cga_cta"; [REF_HABILITATIONS:51]Code:2)
				new_Affectation([AGENTS_PROFILS:138]id_Agent:4; "cga_cta"; "AFFECTATION_APPLICATIVE")
			: ([REF_HABILITATIONS:51]Portee:7="cga_cta_po") & ([AGENTS_PROFILS:138]portee:5#"uf")
				//on vérifie si l'habilitation applicative CGA existe sinon on la crée
				new_habilitation([AGENTS_PROFILS:138]id_Agent:4+"_"+"cga_cta_po"; [REF_HABILITATIONS:51]Code:2)
				new_Affectation([AGENTS_PROFILS:138]id_Agent:4; "cga_cta_po"; "AFFECTATION_APPLICATIVE")
			: ([REF_HABILITATIONS:51]Portee:7="CGA_national-CTA_orphelins") & ([AGENTS_PROFILS:138]portee:5#"uf")
				//on vérifie si l'habilitation applicative CGA existe sinon on la crée
				new_habilitation([AGENTS_PROFILS:138]id_Agent:4+"_"+"CGA_national-CTA_orphelins"; [REF_HABILITATIONS:51]Code:2)
				new_Affectation([AGENTS_PROFILS:138]id_Agent:4; "CGA_national-CTA_orphelins"; "AFFECTATION_APPLICATIVE")
			: (([REF_HABILITATIONS:51]Portee:7="sis") & ([AGENTS_PROFILS:138]portee:5#"uf"))
				//on vérifie si l'habilitation applicative CGA existe sinon on la crée
				new_habilitation([AGENTS_PROFILS:138]id_Agent:4+"_"+"sis"; [REF_HABILITATIONS:51]Code:2)
				new_Affectation([AGENTS_PROFILS:138]id_Agent:4; "sis"; "AFFECTATION_APPLICATIVE")
			: ([REF_HABILITATIONS:51]Portee:7="uf")
				//plusieurs cas : UF ou profil CODIS
				$pos:=Position:C15("_"; [AGENTS_PROFILS:138]Affectation:3)
				$iduf:=Substring:C12([AGENTS_PROFILS:138]Affectation:3; $pos+1)
				Case of 
					: (([AGENTS_PROFILS:138]Nom_Profil:2="Operateur CODIS") | ([AGENTS_PROFILS:138]Nom_Profil:2="Chef de salle")) & ($iduf="CCS")
						// on affecte les habilitations et les affectations applicatives sur toutes les UF (sis)
						//TOUT SÉLECTIONNER([UF])
						//Tant que (Non(Fin de sélection([UF])))
						new_habilitation([AGENTS_PROFILS:138]id_Agent:4+"_"+"sis"; [REF_HABILITATIONS:51]Code:2)
						new_Affectation([AGENTS_PROFILS:138]id_Agent:4; "sis"; "AFFECTATION_APPLICATIVE")
						//ENREGISTREMENT SUIVANT([UF])
						//Fin tant que 
					: ([AGENTS_PROFILS:138]Nom_Profil:2="Gestionnaire CODIS") | ([AGENTS_PROFILS:138]Nom_Profil:2="Parametrage")
						// on affecte les habilitations et les affectations applicatives sur toutes les UF (sis)
						//TOUT SÉLECTIONNER([UF])
						//Tant que (Non(Fin de sélection([UF])))
						new_habilitation([AGENTS_PROFILS:138]id_Agent:4+"_"+"sis"; [REF_HABILITATIONS:51]Code:2)
						new_Affectation([AGENTS_PROFILS:138]id_Agent:4; "sis"; "AFFECTATION_APPLICATIVE")
						//ENREGISTREMENT SUIVANT([UF])
						//Fin tant que 
					Else 
						// cas de l'appartanance à une UF : on ne met les droits que sur l'UF
						//$pos:=Position("_"; [AGENTS_PROFILS]Affectation)
						//$iduf:=Sous chaîne([AGENTS_PROFILS]Affectation; $pos+1)
						If ([AGENTS_PROFILS:138]id_Agent:4="99@-3")
							QUERY:C277([AFFECTATIONS:3]; [AFFECTATIONS:3]type:5="AFFECTATION_APPLICATIVE"; *)
							QUERY:C277([AFFECTATIONS:3]; [AFFECTATIONS:3]id_agent:3=[AGENTS_PROFILS:138]id_Agent:4)
							$iduf:=[AFFECTATIONS:3]id_uf:4
						End if 
						new_habilitation([AGENTS_PROFILS:138]id_Agent:4+"_"+$iduf; [REF_HABILITATIONS:51]Code:2)
						new_Affectation([AGENTS_PROFILS:138]id_Agent:4; $iduf; "AFFECTATION_APPLICATIVE")
				End case 
			Else 
				
		End case 
		
		
		
		
		NEXT RECORD:C51([REF_HABILITATIONS:51])
	End while 
	
	NEXT RECORD:C51([AGENTS_PROFILS:138])
End while 
