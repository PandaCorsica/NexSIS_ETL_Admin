//%attributes = {}
ARRAY TEXT:C222($VILLEcp; 0)
ARRAY TEXT:C222($VILLElibelle; 0)
ARRAY TEXT:C222($VILLEcodedep; 0)
ARRAY TEXT:C222($VILLEcodepays; 0)


ALL RECORDS:C47([VILLES:29])
DELETE SELECTION:C66([VILLES:29])


ConnexionSQL

If (OK=1)
	SQL EXECUTE:C820("SELECT Cp, Ville, Code_dept, Code_Pays  FROM Cp"; $VILLEcp; $VILLElibelle; $VILLEcodedep; $VILLEcodepays)
	SQL LOAD RECORD:C822(SQL tous les enregistrements:K49:10)
	For ($i; 1; Size of array:C274($VILLEcp))
		CREATE RECORD:C68([VILLES:29])
		[VILLES:29]cp:2:=$VILLEcp{$i}
		[VILLES:29]libelle:3:=$VILLElibelle{$i}
		[VILLES:29]code_Dept:4:=$VILLEcodedep{$i}
		[VILLES:29]Code_Pays:5:=$VILLEcodepays{$i}
		SAVE RECORD:C53([VILLES:29])
	End for 
	SQL LOGOUT:C872
	
	
End if 
