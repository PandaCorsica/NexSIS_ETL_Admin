//%attributes = {}

ALL RECORDS:C47([RFGI:46])
While (Not:C34(End selection:C36([RFGI:46])))
	CREATE RECORD:C68([RADIOS:47])
	[RADIOS:47]id_rfgi:2:=[RFGI:46]RFGI:3
	[RADIOS:47]frequence:3:="380"
	[RADIOS:47]id_moyen:4:=[RFGI:46]Idmoyen:2
	[RADIOS:47]code_poste:5:=""
	[RADIOS:47]index_poste:6:=""
	[RADIOS:47]id_uf:7:=""
	[RADIOS:47]id_agent:8:=""
	SAVE RECORD:C53([RADIOS:47])
	NEXT RECORD:C51([RFGI:46])
End while 


ALL RECORDS:C47([IMPORT_MOYENS:43])
While (Not:C34(End selection:C36([IMPORT_MOYENS:43])))
	QUERY:C277([RFGI:46]; [RFGI:46]Idmoyen:2=[IMPORT_MOYENS:43]id_Moyen:2)
	If (Records in selection:C76([RFGI:46])=0)
		CREATE RECORD:C68([RFGI:46])
		[RFGI:46]Idmoyen:2:=[IMPORT_MOYENS:43]id_Moyen:2
		[RFGI:46]RFGI:3:=""
		SAVE RECORD:C53([RFGI:46])
	End if 
	NEXT RECORD:C51([IMPORT_MOYENS:43])
End while 


ALL RECORDS:C47([RADIOS:47])
DELETE SELECTION:C66([RADIOS:47])
ALL RECORDS:C47([IMPORT_RFGI:48])
While (Not:C34(End selection:C36([IMPORT_RFGI:48])))
	CREATE RECORD:C68([RADIOS:47])
	[RADIOS:47]id_rfgi:2:=[IMPORT_RFGI:48]rfgi:2
	[RADIOS:47]frequence:3:="380"
	Case of 
		: ([IMPORT_RFGI:48]affectation:4#"") & ([IMPORT_RFGI:48]centre:5#"")  // il s'agit d'un moyen
			[RADIOS:47]id_moyen:4:=[IMPORT_RFGI:48]affectation:4
			[RADIOS:47]code_poste:5:=""
			[RADIOS:47]index_poste:6:=""
			[RADIOS:47]id_uf:7:=""
			[RADIOS:47]id_agent:8:=""
		: ([IMPORT_RFGI:48]affectation:4="") & ([IMPORT_RFGI:48]centre:5#"")  // il s'agit d'une UF
			[RADIOS:47]id_moyen:4:=""
			[RADIOS:47]code_poste:5:=""
			[RADIOS:47]index_poste:6:=""
			[RADIOS:47]id_uf:7:=[IMPORT_RFGI:48]centre:5
			[RADIOS:47]id_agent:8:=""
		: ([IMPORT_RFGI:48]affectation:4#"") & ([IMPORT_RFGI:48]centre:5="")
			[RADIOS:47]id_moyen:4:=""
			[RADIOS:47]code_poste:5:=""
			[RADIOS:47]index_poste:6:=""
			[RADIOS:47]id_uf:7:=""
			[RADIOS:47]id_agent:8:=[IMPORT_RFGI:48]affectation:4
		Else 
			[RADIOS:47]id_moyen:4:=""
			[RADIOS:47]code_poste:5:=""
			[RADIOS:47]index_poste:6:=""
			[RADIOS:47]id_uf:7:=""
			[RADIOS:47]id_agent:8:=""
			
	End case 
	SAVE RECORD:C53([RADIOS:47])
	NEXT RECORD:C51([IMPORT_RFGI:48])
End while 

