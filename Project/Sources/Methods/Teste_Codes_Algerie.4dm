//%attributes = {}
ALL RECORDS:C47([ALGERIE:31])
While (Not:C34(End selection:C36([ALGERIE:31])))
	QUERY:C277([COMMUNES_INSEE:18]; [COMMUNES_INSEE:18]Code_Insee:3=[ALGERIE:31]insee:2)
	If (Records in selection:C76([COMMUNES_INSEE:18])>0)
		
	End if 
	NEXT RECORD:C51([ALGERIE:31])
End while 
