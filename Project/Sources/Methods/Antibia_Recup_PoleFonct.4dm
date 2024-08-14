//%attributes = {}
ARRAY TEXT:C222($DIRCle; 0)
ARRAY TEXT:C222($DIRNom; 0)
ARRAY TEXT:C222($DIRclePole; 0)
ARRAY TEXT:C222($DIRCode; 0)
ARRAY DATE:C224($DIRdebut; 0)
ARRAY DATE:C224($DIRfin; 0)



ALL RECORDS:C47([IMPORT_POLE:34])
DELETE SELECTION:C66([IMPORT_POLE:34])


ConnexionSQL

If (OK=1)
	
	SQL EXECUTE:C820("SELECT CLE_DIRECTION, DIRECTION, CLE_POLE, CODE, DEBUT, FIN FROM PompDirection"; $DIRCle; $DIRNom; $DIRclePole; $DIRCode; $DIRdebut; $DIRfin)
	SQL LOAD RECORD:C822(SQL tous les enregistrements:K49:10)
	For ($i; 1; Size of array:C274($DIRCle))
		CREATE RECORD:C68([IMPORT_POLE:34])
		[IMPORT_POLE:34]cle_Pole:2:=$DIRCle{$i}
		[IMPORT_POLE:34]libelle:3:=$DIRNom{$i}
		[IMPORT_POLE:34]cle_Direction:6:=$DIRclePole{$i}
		[IMPORT_POLE:34]trigramme:7:=$DIRCode{$i}
		[IMPORT_POLE:34]Debut:4:=String:C10($DIRdebut{$i})
		[IMPORT_POLE:34]fin:5:=String:C10($DIRfin{$i})
		SAVE RECORD:C53([IMPORT_POLE:34])
	End for 
	SQL LOGOUT:C872
	
	// supprimer ceux qui n'existent plus
	QUERY:C277([IMPORT_POLE:34]; [IMPORT_POLE:34]fin:5#"00/00/00")
	DELETE SELECTION:C66([IMPORT_POLE:34])
	
End if 

