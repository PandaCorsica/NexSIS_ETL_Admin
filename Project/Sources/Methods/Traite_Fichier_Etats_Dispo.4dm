//%attributes = {}
$cheminDossier:=$1
$date:=String:C10(Current date:C33; Interne date court:K1:7)
$heure:=String:C10(Current time:C178; h mn s:K7:1)
$YYMMDD:=Substring:C12($date; 9)+Substring:C12($date; 4; 2)+Substring:C12($date; 1; 2)
$HHMMSS:=Replace string:C233($heure; ":"; "")
$doc:=Create document:C266($cheminDossier+"ETATS_DISPO.CSV"; ".csv")
If (OK=1)
	SEND PACKET:C103($doc; "id_uf"+";")
	SEND PACKET:C103($doc; "libelle_long"+";")
	SEND PACKET:C103($doc; "libelle_court"+";")
	SEND PACKET:C103($doc; "disponible"+";")
	SEND PACKET:C103($doc; "delai"+Char:C90(Retour à la ligne:K15:40))
	
	
	ALL RECORDS:C47([ETATS_DISPO:10])
	While (Not:C34(End selection:C36([ETATS_DISPO:10])))
		SEND PACKET:C103($doc; [ETATS_DISPO:10]id_uf:2+";")
		SEND PACKET:C103($doc; [ETATS_DISPO:10]libelle_long:3+";")
		SEND PACKET:C103($doc; [ETATS_DISPO:10]libelle_court:4+";")
		SEND PACKET:C103($doc; [ETATS_DISPO:10]disponible:5+";")
		SEND PACKET:C103($doc; [ETATS_DISPO:10]delai:6+Char:C90(Retour à la ligne:K15:40))
		
		
		NEXT RECORD:C51([ETATS_DISPO:10])
	End while 
	CLOSE DOCUMENT:C267($doc)
End if 
