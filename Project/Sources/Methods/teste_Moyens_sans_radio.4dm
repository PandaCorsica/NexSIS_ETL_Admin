//%attributes = {}
ARRAY TEXT:C222($TMoyens; 0)
ALL RECORDS:C47([IMPORT_MOYENS:43])
While (Not:C34(End selection:C36([IMPORT_MOYENS:43])))
	QUERY:C277([RADIOS:47]; [RADIOS:47]id_moyen:4=[IMPORT_MOYENS:43]id_Moyen:2)
	If (Records in selection:C76([RADIOS:47])=0)
		APPEND TO ARRAY:C911($TMoyens; [IMPORT_MOYENS:43]id_Moyen:2)
	End if 
	NEXT RECORD:C51([IMPORT_MOYENS:43])
End while 


ALL RECORDS:C47([IMPORT_RFGI:48])
While (Not:C34(End selection:C36([IMPORT_RFGI:48])))
	[IMPORT_RFGI:48]affectation:4:=Replace string:C233([IMPORT_RFGI:48]affectation:4; " "; "-")
	SAVE RECORD:C53([IMPORT_RFGI:48])
	NEXT RECORD:C51([IMPORT_RFGI:48])
End while 




