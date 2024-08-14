//%attributes = {}
$cheminDossier:=$1
$date:=String:C10(Current date:C33; Interne date court:K1:7)
$heure:=String:C10(Current time:C178; h mn s:K7:1)
$YYMMDD:=Substring:C12($date; 9)+Substring:C12($date; 4; 2)+Substring:C12($date; 1; 2)
$HHMMSS:=Replace string:C233($heure; ":"; "")
$doc:=Create document:C266($cheminDossier+"UF.CSV"; ".csv")
If (OK=1)
	SEND PACKET:C103($doc; "libelle"+";")
	SEND PACKET:C103($doc; "type_reglementaire"+";")
	SEND PACKET:C103($doc; "type_dept"+";")
	SEND PACKET:C103($doc; "id_uf"+";")
	SEND PACKET:C103($doc; "id_uf_pere"+";")
	SEND PACKET:C103($doc; "mobilisable"+";")
	SEND PACKET:C103($doc; "raz"+Char:C90(Retour à la ligne:K15:40))
	
	
	ALL RECORDS:C47([UF:5])
	While (Not:C34(End selection:C36([UF:5])))
		SEND PACKET:C103($doc; [UF:5]libelle:2+";")
		SEND PACKET:C103($doc; [UF:5]type_reglementaire:3+";")
		SEND PACKET:C103($doc; [UF:5]type_dept:4+";")
		SEND PACKET:C103($doc; [UF:5]id_uf:5+";")
		SEND PACKET:C103($doc; [UF:5]id_uf_pere:6+";")
		SEND PACKET:C103($doc; [UF:5]Mobilisable:11+";")
		SEND PACKET:C103($doc; String:C10([UF:5]raz:12; h mn s:K7:1)+Char:C90(Retour à la ligne:K15:40))
		
		
		NEXT RECORD:C51([UF:5])
	End while 
	CLOSE DOCUMENT:C267($doc)
End if 
