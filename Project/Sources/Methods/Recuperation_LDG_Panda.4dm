//%attributes = {}
//$nomfichier:="LISTE_GARDE.csv"


C_TEXT:C284(URLText_t)
C_BLOB:C604(Blob_t)
URLText_t:="www.operations2a.fr/listeGardeNexsis"
ARRAY TEXT:C222(HeaderNames_at; 0)
ARRAY TEXT:C222(HeaderValues_at; 0)
ON ERR CALL:C155("TRAP ERREUR HTTP")
$httpResponse:=HTTP Get:C1157(URLText_t; Blob_t; HeaderNames_at; HeaderValues_at)
If ($httpResponse=200)
	$texte:=BLOB to text:C555(Blob_t; UTF8 chaîne en C:K22:15)
	
	$cheminDossier:=Get 4D folder:C485(Dossier racine HTML:K5:20)+"Envoi_temp"
	If (Test path name:C476($cheminDossier)#Est un dossier:K24:2)
		CREATE FOLDER:C475($cheminDossier; *)
	End if 
	ARRAY TEXT:C222($TDocs; 0)
	DOCUMENT LIST:C474($cheminDossier; $TDocs)
	//on vide tous les docs
	For ($i; 1; Size of array:C274($TDocs))
		DELETE DOCUMENT:C159($cheminDossier+Séparateur dossier:K24:12+$TDocs{$i})
	End for 
	
	// on crée le fichier et on remplit avec les listes de garde recues
	$nomDoc:=$cheminDossier+Séparateur dossier:K24:12+"LISTE_GARDE.csv"
	$docref:=Create document:C266($nomDoc; ".csv")
	SEND PACKET:C103($docref; $texte)
	CLOSE DOCUMENT:C267($docref)
	
	//on va importer dans la table liste_garde
	ALL RECORDS:C47([LISTE_GARDE:44])
	DELETE SELECTION:C66([LISTE_GARDE:44])
	//  cas normal
	$refSchemaImport:=DOM Parse XML source:C719(Get 4D folder:C485(Dossier base:K5:14)+"schemaImport.xml")
	IMPORT DATA:C665($nomDoc; $refSchemaImport)
	DOM CLOSE XML:C722($refSchemaImport)
	// cas de création de fichier d'import
	//$projet:=""
	//IMPORTER DONNÉES($nomDoc; $projet; *)
	//$docref2:=Créer document(Dossier 4D(Dossier base)+"schemaImport.xml"; ".xml")
	//ENVOYER PAQUET($docref2; $projet)
	//FERMER DOCUMENT($docref2)
End if 
ON ERR CALL:C155("")


