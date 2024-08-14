//%attributes = {}
$error:=False:C215

$doc:=$1
//$doc:=Créer document(Dossier 4D(Dossier base)+"erreursIndividus.txt"; ".txt")


QUERY:C277([INDIVIDUS:1]; [INDIVIDUS:1]nom_usuel:3="")
If (Records in selection:C76([INDIVIDUS:1])>0)
	SEND PACKET:C103($doc; "Des agents n'ont pas de nom usuel"+Char:C90(Retour à la ligne:K15:40))
	$error:=True:C214
	DELETE SELECTION:C66([INDIVIDUS:1])
End if 

QUERY:C277([INDIVIDUS:1]; [INDIVIDUS:1]nom_patronymique:4="")
If (Records in selection:C76([INDIVIDUS:1])>0)
	SEND PACKET:C103($doc; "Des agents n'ont pas de nom patronymique"+Char:C90(Retour à la ligne:K15:40))
	$error:=True:C214
	DELETE SELECTION:C66([INDIVIDUS:1])
End if 

QUERY:C277([INDIVIDUS:1]; [INDIVIDUS:1]prenom:5="")
If (Records in selection:C76([INDIVIDUS:1])>0)
	SEND PACKET:C103($doc; "Des agents n'ont pas de prenom"+Char:C90(Retour à la ligne:K15:40))
	$error:=True:C214
	DELETE SELECTION:C66([INDIVIDUS:1])
End if 

QUERY:C277([INDIVIDUS:1]; [INDIVIDUS:1]date_naissance:6=""; *)
QUERY:C277([INDIVIDUS:1];  | ; [INDIVIDUS:1]date_naissance:6="00/00/0000")
If (Records in selection:C76([INDIVIDUS:1])>0)
	SEND PACKET:C103($doc; "Des agents n'ont pas de date de naissance"+Char:C90(Retour à la ligne:K15:40))
	$error:=True:C214
	DELETE SELECTION:C66([INDIVIDUS:1])
End if 

QUERY:C277([INDIVIDUS:1]; [INDIVIDUS:1]pays_naissance:7=""; *)
QUERY:C277([INDIVIDUS:1];  | ; [INDIVIDUS:1]pays_naissance:7=Null:C1517)
If (Records in selection:C76([INDIVIDUS:1])>0)
	//TRACE
	SEND PACKET:C103($doc; "Des agents n'ont pas de pays de naissance"+Char:C90(Retour à la ligne:K15:40))
	$error:=True:C214
	DELETE SELECTION:C66([INDIVIDUS:1])
End if 

QUERY:C277([INDIVIDUS:1]; [INDIVIDUS:1]commune_naissance:8=""; *)
QUERY:C277([INDIVIDUS:1];  | ; [INDIVIDUS:1]commune_naissance:8=Null:C1517)
If (Records in selection:C76([INDIVIDUS:1])>0)
	SEND PACKET:C103($doc; "Des agents n'ont pas de commune de naissance"+Char:C90(Retour à la ligne:K15:40))
	$error:=True:C214
	DELETE SELECTION:C66([INDIVIDUS:1])
End if 

QUERY:C277([INDIVIDUS:1]; [INDIVIDUS:1]genre:9="")
If (Records in selection:C76([INDIVIDUS:1])>0)
	SEND PACKET:C103($doc; "Des agents n'ont pas de genre"+Char:C90(Retour à la ligne:K15:40))
	$error:=True:C214
End if 

QUERY:C277([INDIVIDUS:1]; [INDIVIDUS:1]id_individu:2="")
If (Records in selection:C76([INDIVIDUS:1])>0)
	SEND PACKET:C103($doc; "Des agents n'ont pas d'id"+Char:C90(Retour à la ligne:K15:40))
	$error:=True:C214
	DELETE SELECTION:C66([INDIVIDUS:1])
End if 

// verification d'unicité individus
ALL RECORDS:C47([INDIVIDUS:1])
DISTINCT VALUES:C339([INDIVIDUS:1]id_individu:2; $TID)
For ($i; 1; Size of array:C274($TID))
	QUERY:C277([INDIVIDUS:1]; [INDIVIDUS:1]id_individu:2=$TID{$i})
	If (Records in selection:C76([INDIVIDUS:1])>1)
		SEND PACKET:C103($doc; "individu en doublon Nom "+[INDIVIDUS:1]nom_usuel:3+Char:C90(Retour à la ligne:K15:40))
		$error:=True:C214
	End if 
End for 


//FERMER DOCUMENT($doc)

$0:=$error

