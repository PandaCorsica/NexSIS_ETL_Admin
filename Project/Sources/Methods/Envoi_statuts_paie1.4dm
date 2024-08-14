//%attributes = {}
$statut:=$1
//$commentaire:=$2
$etatFinal:=$2

// on vérifie qu'il y a bien un dossier de transfert existant sur le sftp
// sinon on le crée
$date:=String:C10(Current date:C33; Interne date court:K1:7)
$heure:=String:C10(Current time:C178; h mn s:K7:1)
$YYMMDD:=Substring:C12($date; 9)+Substring:C12($date; 4; 2)+Substring:C12($date; 1; 2)
$HHMMSS:=Replace string:C233($heure; ":"; "")

$dossier_paie:="Statut_paie"
If (Not:C34(Test path name:C476(Get 4D folder:C485(Dossier Resources courant:K5:16)+"ANO")=Est un dossier:K24:2))
	$result:=Folder:C1567("C:\\SFTP\\ADM2OPS\"+$dossier_paie).create()"
End if 
// creation des fichiers à transférer
$nom_Generique:=$YYMMDD+"_"+$HHMMSS+"_"
$ordre:=0

// partie envoi par tranche de 100
ARRAY OBJECT:C1221($TBody; 0)
C_OBJECT:C1216($reponse)
REDUCE SELECTION:C351([crss_validation:154]; 1)
START TRANSACTION:C239
While (Not:C34(End selection:C36([crss_validation:154])))
	$ordre:=$ordre+1
	$nom_Fichier:=$nom_Generique+String:C10($ordre; "00")+".txt"
	C_OBJECT:C1216($element)
	OB SET:C1220($element; "idOperation"; [crss_validation:154]id_operation:2)
	OB SET:C1220($element; "statut"; $statut)
	OB SET:C1220($element; "uniteFonctionnelle"; [crss_validation:154]unite_fonctionnelle:8)
	If ($statut="PAS VALIDE")
		ARRAY TEXT:C222($Tcommentaires; 1)
		$Tcommentaires{1}:=[crss_validation:154]message:14
		OB SET ARRAY:C1227($element; "commentaires"; $Tcommentaires)
	End if 
	APPEND TO ARRAY:C911($TBody; $element)
	[crss_validation:154]etat_validation:4:=$etatFinal
	SAVE RECORD:C53([crss_validation:154])
	If (Size of array:C274($TBody)=100)
		//$doc_paie:=Créer document("C:\\SFTP\\ADM2OPS"+Séparateur dossier+$dossier_paie+Séparateur dossier+$nom_Fichier)
		$body:=JSON Stringify array:C1228($TBody)
		TEXT TO DOCUMENT:C1237("C:\\SFTP\\ADM2OPS"+Séparateur dossier:K24:12+$dossier_paie+Séparateur dossier:K24:12+$nom_Fichier; $body)
		
		
		// on fait l'envoi
		ARRAY TEXT:C222(HeaderNames_at; 2)
		ARRAY TEXT:C222(HeaderValues_at; 2)
		HeaderNames_at{1}:="Content-Type"
		HeaderValues_at{1}:="application/json"
		HeaderNames_at{2}:="Authorization"
		HeaderValues_at{2}:="Bearer "+$token
		$body:=JSON Stringify array:C1228($TBody)
		$httpResult:=HTTP Request:C1158(HTTP méthode POST:K71:2; $urlPaie; $body; $reponse; HeaderNames_at; HeaderValues_at; *)
		If ($httpResult=200)
			// si la transmission s'est bien passée, on remet les comptes à 0
			ARRAY OBJECT:C1221($TBody; 0)
			VALIDATE TRANSACTION:C240
			START TRANSACTION:C239
		Else 
			CANCEL TRANSACTION:C241
		End if 
	End if 
	NEXT RECORD:C51([crss_validation:154])
End while 
// on fait un envoi final
ARRAY TEXT:C222(HeaderNames_at; 2)
ARRAY TEXT:C222(HeaderValues_at; 2)
HeaderNames_at{1}:="Content-Type"
HeaderValues_at{1}:="application/json"
HeaderNames_at{2}:="Authorization"
HeaderValues_at{2}:="Bearer "+$token
$body:=JSON Stringify array:C1228($TBody)
$httpResult:=HTTP Request:C1158(HTTP méthode POST:K71:2; $urlPaie; $body; $reponse; HeaderNames_at; HeaderValues_at; *)
If ($httpResult=200)
	// si la transmission s'est bien passée, on remet les comptes à 0
	ARRAY OBJECT:C1221($TBody; 0)
	VALIDATE TRANSACTION:C240
Else 
	CANCEL TRANSACTION:C241
End if 