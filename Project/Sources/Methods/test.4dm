//%attributes = {}
ALL RECORDS:C47([IMPORT_INDIVIDUS:17])
While (Not:C34(End selection:C36([IMPORT_INDIVIDUS:17])))
	QUERY:C277([IMPORT_UF:20]; [IMPORT_UF:20]Cle_Corps:2=[IMPORT_INDIVIDUS:17]Cle_Corps:13)
	If (Records in selection:C76([IMPORT_UF:20])=0)
		TRACE:C157
	End if 
	NEXT RECORD:C51([IMPORT_INDIVIDUS:17])
End while 
