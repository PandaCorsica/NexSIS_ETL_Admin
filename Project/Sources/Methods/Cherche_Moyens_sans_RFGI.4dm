//%attributes = {}
QUERY:C277([IMPORT_MOYENS:43]; [IMPORT_MOYENS:43]id_uf_ope:8#"archivage"; *)
QUERY:C277([IMPORT_MOYENS:43]; [IMPORT_MOYENS:43]type_vesteur:14="vecteur")
ARRAY TEXT:C222($TMoyens; 0)
While (Not:C34(End selection:C36([IMPORT_MOYENS:43])))
	QUERY:C277([RADIOS:47]; [RADIOS:47]id_moyen:4=[IMPORT_MOYENS:43]id_Moyen:2)
	If (Records in selection:C76([RADIOS:47])=0)
		APPEND TO ARRAY:C911($TMoyens; [IMPORT_MOYENS:43]id_Moyen:2)
		CREATE RECORD:C68([RADIOS:47])
		[RADIOS:47]id_rfgi:2:="2012"
		[RADIOS:47]frequence:3:="380"
		[RADIOS:47]id_moyen:4:=[IMPORT_MOYENS:43]id_Moyen:2
		[RADIOS:47]isNew:10:=True:C214
		SAVE RECORD:C53([RADIOS:47])
	End if 
	NEXT RECORD:C51([IMPORT_MOYENS:43])
End while 
