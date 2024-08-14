//%attributes = {}
$cheminDossier:=$1
$date:=String:C10(Current date:C33; Interne date court:K1:7)
$heure:=String:C10(Current time:C178; h mn s:K7:1)
$YYMMDD:=Substring:C12($date; 9)+Substring:C12($date; 4; 2)+Substring:C12($date; 1; 2)
$HHMMSS:=Replace string:C233($heure; ":"; "")
$doc:=Create document:C266($cheminDossier+"PIQUETS.CSV"; ".csv")
If (OK=1)
	SEND PACKET:C103($doc; "id_sis"+";")
	SEND PACKET:C103($doc; "type_moyen_dept"+";")
	SEND PACKET:C103($doc; "ordre_affichage"+";")
	SEND PACKET:C103($doc; "code_poste"+Char:C90(Retour à la ligne:K15:40))
	
	
	ALL RECORDS:C47([PIQUETS:9])
	While (Not:C34(End selection:C36([PIQUETS:9])))
		SEND PACKET:C103($doc; [PIQUETS:9]id_sis:2+";")
		SEND PACKET:C103($doc; [PIQUETS:9]type_moyen_dept:3+";")
		SEND PACKET:C103($doc; [PIQUETS:9]ordre_affichage:4+";")
		SEND PACKET:C103($doc; [PIQUETS:9]code_poste:5+Char:C90(Retour à la ligne:K15:40))
		
		
		NEXT RECORD:C51([PIQUETS:9])
	End while 
	CLOSE DOCUMENT:C267($doc)
End if 
