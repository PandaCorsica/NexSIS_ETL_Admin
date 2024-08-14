//%attributes = {}
ARRAY TEXT:C222($TEngins; 0)
ALL RECORDS:C47([IMPORT_MOYENS:43])
While (Not:C34(End selection:C36([IMPORT_MOYENS:43])))
	QUERY:C277([RADIOS:47]; [RADIOS:47]id_moyen:4=[IMPORT_MOYENS:43]id_Moyen:2)
	If (Records in selection:C76([RADIOS:47])=0)
		APPEND TO ARRAY:C911($TEngins; [IMPORT_MOYENS:43]id_Moyen:2)
		CREATE RECORD:C68([RADIOS:47])
		[RADIOS:47]code_poste:5:=""
		[RADIOS:47]id_moyen:4:=[IMPORT_MOYENS:43]id_Moyen:2
		[RADIOS:47]isNew:10:=True:C214
		SAVE RECORD:C53([RADIOS:47])
	End if 
	NEXT RECORD:C51([IMPORT_MOYENS:43])
End while 

