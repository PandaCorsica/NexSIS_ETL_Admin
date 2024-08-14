//%attributes = {}
ARRAY TEXT:C222($tabTables; Get last table number:C254)
ARRAY LONGINT:C221($tabNumTables; Get last table number:C254)
If (Get last table number:C254>0)  //S’il y a bien des tables
	For ($vlTables; Size of array:C274($tabTables); 1; -1)
		If (Is table number valid:C999($vlTables))
			QUERY:C277([STRUCTURE_DATA_DESCENDANTES:53]; [STRUCTURE_DATA_DESCENDANTES:53]NomTable:2=Table name:C256($vlTables))
			If (Records in selection:C76([STRUCTURE_DATA_DESCENDANTES:53])#0)
				APPLY TO SELECTION:C70([STRUCTURE_DATA_DESCENDANTES:53]; [STRUCTURE_DATA_DESCENDANTES:53]Numero_table:8:=$vlTables)
				CREATE SET:C116([STRUCTURE_DATA_DESCENDANTES:53]; "champs")
				ARRAY TEXT:C222($tabChamps; Get last field number:C255($vlTables))
				If (Get last field number:C255($vlTables)>0)  //S’il y a bien des champs
					For ($vlChamps; Size of array:C274($tabChamps); 1; -1)
						USE SET:C118("champs")
						QUERY SELECTION:C341([STRUCTURE_DATA_DESCENDANTES:53]; [STRUCTURE_DATA_DESCENDANTES:53]NomChamp:3=Field name:C257($vlTables; $vlChamps))
						If (Records in selection:C76([STRUCTURE_DATA_DESCENDANTES:53])#0)
							[STRUCTURE_DATA_DESCENDANTES:53]Numero_Champ:9:=$vlChamps
							SAVE RECORD:C53([STRUCTURE_DATA_DESCENDANTES:53])
						End if 
					End for 
				End if 
				CLEAR SET:C117("champs")
			End if 
		End if 
	End for 
End if 

