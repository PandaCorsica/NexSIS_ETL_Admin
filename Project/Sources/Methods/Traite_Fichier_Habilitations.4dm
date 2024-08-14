//%attributes = {}
$cheminDossier:=$1
$date:=String:C10(Current date:C33; Interne date court:K1:7)
$heure:=String:C10(Current time:C178; h mn s:K7:1)
$YYMMDD:=Substring:C12($date; 9)+Substring:C12($date; 4; 2)+Substring:C12($date; 1; 2)
$HHMMSS:=Replace string:C233($heure; ":"; "")
$doc:=Create document:C266($cheminDossier+"HABILITATIONS.CSV"; ".csv")
If (OK=1)
	SEND PACKET:C103($doc; "id_affectation"+";")
	SEND PACKET:C103($doc; "id_habilitation"+Char:C90(Retour à la ligne:K15:40))
	
	QUERY BY FORMULA:C48([HABILITATIONS:52]; Length:C16([HABILITATIONS:52]id_habilitation:3)<1)
	DELETE SELECTION:C66([HABILITATIONS:52])
	QUERY BY FORMULA:C48([HABILITATIONS:52]; Substring:C12([HABILITATIONS:52]id_affectation:2; 1; 1)="_")
	DELETE SELECTION:C66([HABILITATIONS:52])
	
	ALL RECORDS:C47([HABILITATIONS:52])
	While (Not:C34(End selection:C36([HABILITATIONS:52])))
		SEND PACKET:C103($doc; [HABILITATIONS:52]id_affectation:2+";")
		SEND PACKET:C103($doc; [HABILITATIONS:52]id_habilitation:3+Char:C90(Retour à la ligne:K15:40))
		
		
		NEXT RECORD:C51([HABILITATIONS:52])
	End while 
	CLOSE DOCUMENT:C267($doc)
End if 
