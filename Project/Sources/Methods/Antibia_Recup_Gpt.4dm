//%attributes = {}
ARRAY TEXT:C222($GPTcle; 0)
ARRAY TEXT:C222($GPTNom; 0)
ARRAY TEXT:C222($GPTCode; 0)
ARRAY TEXT:C222($GPTTercle; 0)
ARRAY TEXT:C222($GPTNomTer; 0)

ALL RECORDS:C47([IMPORT_GPT:22])
DELETE SELECTION:C66([IMPORT_GPT:22])

ConnexionSQL

If (OK=1)
	
	SQL EXECUTE:C820("SELECT CLEGPT, GPT, CODE FROM Pompgpt"; $GPTcle; $GPTNom; $GPTCode)
	SQL LOAD RECORD:C822(SQL tous les enregistrements:K49:10)
	For ($i; 1; Size of array:C274($GPTcle))
		CREATE RECORD:C68([IMPORT_GPT:22])
		[IMPORT_GPT:22]cle_gpt:2:=$GPTcle{$i}
		[IMPORT_GPT:22]libelle:3:=$GPTNom{$i}
		[IMPORT_GPT:22]code:4:=$GPTCode{$i}
		SAVE RECORD:C53([IMPORT_GPT:22])
	End for 
	SQL LOGOUT:C872
	
	// on supprime les groupements qui n'ont pas de code car ce sont les ancient (Groupement correspond à Pole)
	QUERY:C277([IMPORT_GPT:22]; [IMPORT_GPT:22]code:4=" ")
	//SUPPRIMER SÉLECTION([IMPORT_GPT])
	ALL RECORDS:C47([IMPORT_GPT:22])
	
End if 

