//%attributes = {}
ALL RECORDS:C47([VILLES_ETRANGER:30])
While (Not:C34(End selection:C36([VILLES_ETRANGER:30])))
	QUERY:C277([PAYS:19]; [PAYS:19]code_iso2:5=[VILLES_ETRANGER:30]CodePays:2)
	[VILLES_ETRANGER:30]Code3:6:=[PAYS:19]libelle_INSEE:6
	SAVE RECORD:C53([VILLES_ETRANGER:30])
	NEXT RECORD:C51([VILLES_ETRANGER:30])
End while 