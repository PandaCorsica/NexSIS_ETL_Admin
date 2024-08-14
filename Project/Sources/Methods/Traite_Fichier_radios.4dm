//%attributes = {}
$cheminDossier:=$1
$date:=String:C10(Current date:C33; Interne date court:K1:7)
$heure:=String:C10(Current time:C178; h mn s:K7:1)
$YYMMDD:=Substring:C12($date; 9)+Substring:C12($date; 4; 2)+Substring:C12($date; 1; 2)
$HHMMSS:=Replace string:C233($heure; ":"; "")
$doc:=Create document:C266($cheminDossier+"RADIOS.CSV"; ".csv")
If (OK=1)
	SEND PACKET:C103($doc; "id_rfgi"+";")
	SEND PACKET:C103($doc; "frequence"+";")
	SEND PACKET:C103($doc; "id_moyen"+";")
	SEND PACKET:C103($doc; "code_poste"+";")
	SEND PACKET:C103($doc; "index_poste"+";")
	SEND PACKET:C103($doc; "id_uf"+";")
	SEND PACKET:C103($doc; "id_agent"+Char:C90(Retour à la ligne:K15:40))
	
	
	ALL RECORDS:C47([RADIOS:47])
	While (Not:C34(End selection:C36([RADIOS:47])))
		SEND PACKET:C103($doc; [RADIOS:47]id_rfgi:2+";")
		SEND PACKET:C103($doc; [RADIOS:47]frequence:3+";")
		SEND PACKET:C103($doc; [RADIOS:47]id_moyen:4+";")
		SEND PACKET:C103($doc; [RADIOS:47]code_poste:5+";")
		SEND PACKET:C103($doc; [RADIOS:47]index_poste:6+";")
		SEND PACKET:C103($doc; [RADIOS:47]id_uf:7+";")
		SEND PACKET:C103($doc; [RADIOS:47]id_agent:8+Char:C90(Retour à la ligne:K15:40))
		
		
		
		NEXT RECORD:C51([RADIOS:47])
	End while 
	CLOSE DOCUMENT:C267($doc)
End if 

