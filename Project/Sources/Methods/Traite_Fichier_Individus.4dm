//%attributes = {}
$error:=False:C215

$cheminDossier:=$1

$date:=String:C10(Current date:C33; Interne date court:K1:7)
$heure:=String:C10(Current time:C178; h mn s:K7:1)
$YYMMDD:=Substring:C12($date; 9)+Substring:C12($date; 4; 2)+Substring:C12($date; 1; 2)
$HHMMSS:=Replace string:C233($heure; ":"; "")
$doc:=Create document:C266($cheminDossier+"INDIVIDUS.CSV"; ".csv")
If (OK=1)
	SEND PACKET:C103($doc; "id_individu"+";")
	SEND PACKET:C103($doc; "nom_usuel"+";")
	SEND PACKET:C103($doc; "nom_patronymique"+";")
	SEND PACKET:C103($doc; "prenom"+";")
	SEND PACKET:C103($doc; "date_naissance"+";")
	SEND PACKET:C103($doc; "pays_naissance"+";")
	SEND PACKET:C103($doc; "commune_naissance"+";")
	SEND PACKET:C103($doc; "genre"+Char:C90(Retour à la ligne:K15:40))
	
	QUERY BY FORMULA:C48([INDIVIDUS:1]; Length:C16([INDIVIDUS:1]pays_naissance:7)<2)
	DELETE SELECTION:C66([INDIVIDUS:1])
	QUERY BY FORMULA:C48([INDIVIDUS:1]; Length:C16([INDIVIDUS:1]commune_naissance:8)<2)
	DELETE SELECTION:C66([INDIVIDUS:1])
	ALL RECORDS:C47([INDIVIDUS:1])
	While (Not:C34(End selection:C36([INDIVIDUS:1])))
		If ([INDIVIDUS:1]nom_usuel:3="DOUDOUCH") & ([INDIVIDUS:1]prenom:5="KILLIAN")  // cas par ticuliuer car il y avait une erreur sur le nom lors de la 1ere integration
			SEND PACKET:C103($doc; "b1c9026254d6d7721b08084e2c8543f955705ded0f8643646f96b8c6bc71af66"+";")  // on envoi l'idIndividu initialement déclaré
		Else 
			SEND PACKET:C103($doc; [INDIVIDUS:1]id_individu:2+";")
		End if 
		SEND PACKET:C103($doc; [INDIVIDUS:1]nom_usuel:3+";")
		SEND PACKET:C103($doc; [INDIVIDUS:1]nom_patronymique:4+";")
		SEND PACKET:C103($doc; [INDIVIDUS:1]prenom:5+";")
		SEND PACKET:C103($doc; [INDIVIDUS:1]date_naissance:6+";")
		SEND PACKET:C103($doc; [INDIVIDUS:1]pays_naissance:7+";")
		SEND PACKET:C103($doc; [INDIVIDUS:1]commune_naissance:8+";")
		SEND PACKET:C103($doc; [INDIVIDUS:1]genre:9+Char:C90(Retour à la ligne:K15:40))
		
		NEXT RECORD:C51([INDIVIDUS:1])
	End while 
	CLOSE DOCUMENT:C267($doc)
	
Else 
	$error:=True:C214
End if 

$0:=$error