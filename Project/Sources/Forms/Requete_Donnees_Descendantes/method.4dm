$evt:=Form event code:C388
Case of 
	: ($evt=Sur chargement:K2:1)
		ARRAY TEXT:C222(TTables; 0)
		ARRAY TEXT:C222(TChamps; 0)
		ARRAY LONGINT:C221(TNumTables; 0)
		C_TEXT:C284(vValeur)
		vValeur:=""
		ALL RECORDS:C47([STRUCTURE_DATA_DESCENDANTES:53])
		DISTINCT VALUES:C339([STRUCTURE_DATA_DESCENDANTES:53]NomTable:2; TTables)
		For ($i; 1; Size of array:C274(TTables))
			QUERY:C277([STRUCTURE_DATA_DESCENDANTES:53]; [STRUCTURE_DATA_DESCENDANTES:53]NomTable:2=TTables{$i})
			APPEND TO ARRAY:C911(TNumTables; [STRUCTURE_DATA_DESCENDANTES:53]Numero_table:8)
		End for 
		vPra:=1
		vForm:=0
		vMad:=0
End case 