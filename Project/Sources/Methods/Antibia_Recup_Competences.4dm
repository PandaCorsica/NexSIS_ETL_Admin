//%attributes = {}
ARRAY TEXT:C222($COMPETCle; 0)
ARRAY TEXT:C222($COMPETCode; 0)
ARRAY TEXT:C222($COMPETlibelle; 0)


ALL RECORDS:C47([IMPORT_COMPETENCES:39])
DELETE SELECTION:C66([IMPORT_COMPETENCES:39])


ConnexionSQL_Form

If (OK=1)
	SQL EXECUTE:C820("SELECT CLE, CODE, LIBELLE  FROM ForP_Competence"; $COMPETCle; $COMPETCode; $COMPETlibelle)
	SQL LOAD RECORD:C822(SQL tous les enregistrements:K49:10)
	For ($i; 1; Size of array:C274($COMPETCle))
		CREATE RECORD:C68([IMPORT_COMPETENCES:39])
		[IMPORT_COMPETENCES:39]cle_competence:2:=$COMPETCle{$i}
		[IMPORT_COMPETENCES:39]code:3:=$COMPETCode{$i}
		[IMPORT_COMPETENCES:39]libelle:4:=$COMPETlibelle{$i}
		SAVE RECORD:C53([IMPORT_COMPETENCES:39])
	End for 
	SQL LOGOUT:C872
	
	
End if 
