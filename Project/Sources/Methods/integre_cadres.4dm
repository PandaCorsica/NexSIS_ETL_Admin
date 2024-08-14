//%attributes = {}
ALL RECORDS:C47([IMPORT_INDIVIDUS:17])
//SUPPRIMER SÉLECTION([IMPORT_INDIVIDUS])

$chemin:=Select document:C905(""; ""; "Selectionnez le fichier de cadres à importer "; 0; $TSel)
$projet:=""

IMPORT DATA:C665($TSel{1}; $projet; *)


ALL RECORDS:C47([IMPORT_INDIVIDUS:17])
While (Not:C34(End selection:C36([IMPORT_INDIVIDUS:17])))
	QUERY:C277([CADRES:45]; [CADRES:45]matricule:2=[IMPORT_INDIVIDUS:17]Matricule:2)
	If (Records in selection:C76([CADRES:45])#0)
		[IMPORT_INDIVIDUS:17]cadre:19:=True:C214
	Else 
		[IMPORT_INDIVIDUS:17]cadre:19:=False:C215
	End if 
	SAVE RECORD:C53([IMPORT_INDIVIDUS:17])
	NEXT RECORD:C51([IMPORT_INDIVIDUS:17])
End while 
