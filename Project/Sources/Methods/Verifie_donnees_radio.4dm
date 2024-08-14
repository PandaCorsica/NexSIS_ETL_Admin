//%attributes = {}
ALL RECORDS:C47([RADIOS:47])
APPLY TO SELECTION:C70([RADIOS:47]; [RADIOS:47]delete:9:=False:C215)

// verification du format de l'ID_affectation dans competences
QUERY:C277([RADIOS:47]; [RADIOS:47]id_moyen:4#"")
While (Not:C34(End selection:C36([RADIOS:47])))
	QUERY:C277([IMPORT_MOYENS:43]; [IMPORT_MOYENS:43]id_Moyen:2=[RADIOS:47]id_moyen:4)
	If (Records in selection:C76([IMPORT_MOYENS:43])=0) & ([RADIOS:47]id_moyen:4#"")
		[RADIOS:47]delete:9:=True:C214
		SAVE RECORD:C53([RADIOS:47])
	End if 
	NEXT RECORD:C51([RADIOS:47])
End while 
QUERY:C277([RADIOS:47]; [RADIOS:47]delete:9=True:C214)
DELETE SELECTION:C66([RADIOS:47])
