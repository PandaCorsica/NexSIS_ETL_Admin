//%attributes = {}
$derniereTable:=Get last table number:C254
READ WRITE:C146([STRUCTURE_DATA_DESCENDANTES:53])
For ($i; 1; $derniereTable)
	If (Is table number valid:C999($i))
		QUERY:C277([STRUCTURE_DATA_DESCENDANTES:53]; [STRUCTURE_DATA_DESCENDANTES:53]NomTable:2=Table name:C256($i))
		If (Records in selection:C76([STRUCTURE_DATA_DESCENDANTES:53])#0)
			APPLY TO SELECTION:C70([STRUCTURE_DATA_DESCENDANTES:53]; [STRUCTURE_DATA_DESCENDANTES:53]Numero_table:8:=$i)
			$dernierChamp:=Get last field number:C255($i)
			For ($j; 1; $dernierChamp)
				If (Is field number valid:C1000($i; $j))
					QUERY:C277([STRUCTURE_DATA_DESCENDANTES:53]; [STRUCTURE_DATA_DESCENDANTES:53]Numero_table:8=$i; *)
					QUERY:C277([STRUCTURE_DATA_DESCENDANTES:53]; [STRUCTURE_DATA_DESCENDANTES:53]NomChamp:3=Field name:C257($i; $j))
					[STRUCTURE_DATA_DESCENDANTES:53]Numero_Champ:9:=$j
					SAVE RECORD:C53([STRUCTURE_DATA_DESCENDANTES:53])
				End if 
			End for 
		End if 
	End if 
End for 
