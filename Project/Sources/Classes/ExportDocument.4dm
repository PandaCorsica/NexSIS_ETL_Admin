// Manage the document export.
//  The object created with this class can be passed in parameter to VP EXPORT DOCUMENT
Class constructor
	C_TEXT:C284($1)
	C_OBJECT:C1216($2)
	C_TEXT:C284($3)
	C_TEXT:C284($4)
	C_OBJECT:C1216($this)
	
	This:C1470.area:=$1  // le nom de la zone
	This:C1470.selectedDoc:=$2  // le document à envoyer
	This:C1470.folder:=$3  // le dossier d'export
	This:C1470.format:=vk MS Excel format:K89:2
	This:C1470.docName:=$4  // le nom du fichier
	
	
	// Export the first document selected
Function start
	This:C1470.exportDocument(This:C1470.selectedDoc)
	
	
	// Method to export current document
Function exportDocument
	C_OBJECT:C1216($1; $doc)
	C_OBJECT:C1216($vp)
	C_OBJECT:C1216($path; $param)
	C_OBJECT:C1216($printInfo)
	
	$doc:=$1
	
	// search document in the database
	$vp:=$doc
	
	// Import the document in the 4D View Pro offscreen area
	VP IMPORT FROM OBJECT(This:C1470.area; $vp)
	
	// Create the print info object to specify print options
	$printInfo:=New object:C1471
	$printInfo.orientation:=vk print page orientation portrait:K89:90
	//$printInfo.fitPagesTall:=1
	//$printInfo.fitPagesWide:=1
	VP SET PRINT INFO(This:C1470.area; $printInfo)
	
	// Document Export
	$path:=New object:C1471
	$path.parentFolder:=This:C1470.folder
	$path.name:=This:C1470.docName
	This:C1470.valuesOnly:=True:C214
	VP EXPORT DOCUMENT(This:C1470.area; Object to path:C1548($path); This:C1470)
	