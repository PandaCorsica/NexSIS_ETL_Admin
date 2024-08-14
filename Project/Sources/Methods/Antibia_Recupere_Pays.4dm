//%attributes = {}
ARRAY LONGINT:C221($PAYSnum; 0)
ARRAY TEXT:C222($PAYSlibelle; 0)
ARRAY TEXT:C222($PAYSiso3; 0)
ARRAY TEXT:C222($PAYSiso2; 0)
ARRAY TEXT:C222($PAYSlibInsee; 0)
ARRAY TEXT:C222($PAYSinsee; 0)


ALL RECORDS:C47([PAYS:19])
DELETE SELECTION:C66([PAYS:19])


ConnexionSQL

If (OK=1)
	SQL EXECUTE:C820("SELECT NUM, LIBISO, CODE1, CODE2, LIBINSEE, INSEEMIN  FROM TABPAYSANOR"; $PAYSnum; $PAYSlibelle; $PAYSiso3; $PAYSiso2; $PAYSlibInsee; $PAYSinsee)
	SQL LOAD RECORD:C822(SQL tous les enregistrements:K49:10)
	For ($i; 1; Size of array:C274($PAYSnum))
		CREATE RECORD:C68([PAYS:19])
		[PAYS:19]numero:2:=String:C10($PAYSnum{$i})
		[PAYS:19]libelle_INSEE:6:=$PAYSlibInsee{$i}
		[PAYS:19]code_iso2:5:=$PAYSiso2{$i}
		[PAYS:19]code_iso3:4:=$PAYSiso3{$i}
		[PAYS:19]insee:7:=$PAYSinsee{$i}
		[PAYS:19]libelle:3:=$PAYSlibelle{$i}
		SAVE RECORD:C53([PAYS:19])
	End for 
	SQL LOGOUT:C872
	
	
End if 
