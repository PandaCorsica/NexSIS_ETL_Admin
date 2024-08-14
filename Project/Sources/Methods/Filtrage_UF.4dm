//%attributes = {}
ALL RECORDS:C47([IMPORT_CIS:20])
DISTINCT VALUES:C339([IMPORT_CIS:20]Cle_Corps:2; $Tclecorps)
$lignes:=Size of array:C274($Tclecorps)
ARRAY TEXT:C222($TNomCorps; $lignes)
ARRAY LONGINT:C221($TNombre; $lignes)
For ($i; 1; $lignes)
	QUERY:C277([IMPORT_CIS:20]; [IMPORT_CIS:20]Cle_Corps:2=$Tclecorps{$i})
	$TNomCorps{$i}:=[IMPORT_CIS:20]Non_Corps:3
	$TNombre{$i}:=0
End for 

$doc:=Create document:C266(Get 4D folder:C485(Dossier base:K5:14)+"UF inexistantes.txt"; ".txt")
ALL RECORDS:C47([IMPORT_INDIVIDUS:17])

While (Not:C34(End selection:C36([IMPORT_INDIVIDUS:17])))
	
	$trouve:=Find in array:C230($Tclecorps; [IMPORT_INDIVIDUS:17]Cle_Corps:13)
	If ($trouve>0)
		$TNombre{$trouve}:=$TNombre{$trouve}+1
	Else 
		SEND PACKET:C103($doc; "IMPORT_CIS d'un agent non existant - cle corps : "+[IMPORT_INDIVIDUS:17]Cle_Corps:13+Char:C90(Retour à la ligne:K15:40))
		//TRACE
	End if 
	
	
	NEXT RECORD:C51([IMPORT_INDIVIDUS:17])
End while 

ARRAY TEXT:C222($Tnonnuls; 0)
For ($i; 1; Size of array:C274($TNomCorps))
	If ($TNombre{$i}=0)
		QUERY:C277([IMPORT_CIS:20]; [IMPORT_CIS:20]Cle_Corps:2=$Tclecorps{$i})
		[IMPORT_CIS:20]toDelete:9:=True:C214
		SAVE RECORD:C53([IMPORT_CIS:20])
		SEND PACKET:C103($doc; "IMPORT_CIS sans personne affecté -> suppression : "+[IMPORT_CIS:20]Cle_Corps:2+Char:C90(Retour à la ligne:K15:40))
	End if 
End for 
QUERY:C277([IMPORT_CIS:20]; [IMPORT_CIS:20]toDelete:9=True:C214)
DELETE SELECTION:C66([IMPORT_CIS:20])

CLOSE DOCUMENT:C267($doc)
