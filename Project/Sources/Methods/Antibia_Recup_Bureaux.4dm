//%attributes = {}
ARRAY TEXT:C222($BURCle; 0)
ARRAY TEXT:C222($BURNom; 0)
ARRAY TEXT:C222($BURcleServ; 0)
ARRAY TEXT:C222($BURCode; 0)
ARRAY DATE:C224($BURdebut; 0)
ARRAY DATE:C224($BURfin; 0)

ALL RECORDS:C47([IMPORT_BUREAU:38])
DELETE SELECTION:C66([IMPORT_BUREAU:38])


ConnexionSQL

If (OK=1)
	
	SQL EXECUTE:C820("SELECT CLEBUR, BUREAU, CLESERV, DEBUT, FIN FROM Pompbure"; $BURCle; $BURNom; $BURcleServ; $BURdebut; $BURfin)
	SQL LOAD RECORD:C822(SQL tous les enregistrements:K49:10)
	For ($i; 1; Size of array:C274($BURCle))
		CREATE RECORD:C68([IMPORT_BUREAU:38])
		[IMPORT_BUREAU:38]cleBur:2:=$BURCle{$i}
		[IMPORT_BUREAU:38]libelle:3:=$BURNom{$i}
		[IMPORT_BUREAU:38]cleServ:4:=$BURcleServ{$i}
		//[IMPORT_BUREAU]trigramme:=$BURCode{$i}
		[IMPORT_BUREAU:38]debut:6:=String:C10($BURdebut{$i})
		[IMPORT_BUREAU:38]fin:7:=String:C10($BURfin{$i})
		SAVE RECORD:C53([IMPORT_BUREAU:38])
	End for 
	SQL LOGOUT:C872
	
	QUERY:C277([IMPORT_BUREAU:38]; [IMPORT_BUREAU:38]fin:7#"00/00/00")
	DELETE SELECTION:C66([IMPORT_BUREAU:38])
End if 

