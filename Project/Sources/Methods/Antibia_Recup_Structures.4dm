//%attributes = {}
ARRAY TEXT:C222($CORCle; 0)
ARRAY TEXT:C222($CORNom; 0)
ARRAY TEXT:C222($CORCode; 0)
ARRAY LONGINT:C221($CORType; 0)
ARRAY TEXT:C222($CORCodeComp; 0)
ARRAY TEXT:C222($CORCodeGpt; 0)
ARRAY TEXT:C222($CORAbrege; 0)

ALL RECORDS:C47([IMPORT_CIS:20])
DELETE SELECTION:C66([IMPORT_CIS:20])


ConnexionSQL

If (OK=1)
	
	SQL EXECUTE:C820("SELECT CLECOR, CORP, CODE, CO2, CO23, CO7, CO9 FROM Pompcor WHERE (CO7 !='' AND CODE !='')"; $CORCle; $CORNom; $CORCode; $CORType; $CORCodeComp; $CORCodeGpt; $CORAbrege)
	SQL LOAD RECORD:C822(SQL tous les enregistrements:K49:10)
	For ($i; 1; Size of array:C274($CORCle))
		If (Substring:C12($CORNom{$i}; 1; 2)#"zz")
			CREATE RECORD:C68([IMPORT_CIS:20])
			[IMPORT_CIS:20]Cle_Corps:2:=$CORCle{$i}
			[IMPORT_CIS:20]Non_Corps:3:=$CORNom{$i}
			[IMPORT_CIS:20]Code_Corps:4:=$CORCode{$i}
			//Au cas ou 
			//: ($CORType{$i}=6) | ($CORType{$i}=7) | ($CORType{$i}=9) | ($CORType{$i}=10)
			//[IMPORT_CIS]Type_Centre:="6"
			//Sinon 
			[IMPORT_CIS:20]Type_Centre:5:=String:C10($CORType{$i})
			//Fin de cas 
			[IMPORT_CIS:20]Code_Compagnie:6:=$CORCodeComp{$i}
			[IMPORT_CIS:20]Code_Gpt:7:=$CORCodeGpt{$i}
			[IMPORT_CIS:20]Abrege:8:=$CORAbrege{$i}
			[IMPORT_CIS:20]toDelete:9:=False:C215
			SAVE RECORD:C53([IMPORT_CIS:20])
		End if 
	End for 
	SQL LOGOUT:C872
	
	
End if 

