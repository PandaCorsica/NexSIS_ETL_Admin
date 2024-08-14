//%attributes = {}
$cheminDossier:=$1
$date:=String:C10(Current date:C33; Interne date court:K1:7)
$heure:=String:C10(Current time:C178; h mn s:K7:1)
$YYMMDD:=Substring:C12($date; 9)+Substring:C12($date; 4; 2)+Substring:C12($date; 1; 2)
$HHMMSS:=Replace string:C233($heure; ":"; "")
$doc:=Create document:C266($cheminDossier+"EMETTEURS.CSV"; ".csv")
If (OK=1)
	SEND PACKET:C103($doc; "id_emetteur"+";")
	SEND PACKET:C103($doc; "adresse_ip"+";")
	SEND PACKET:C103($doc; "id_uf"+";")
	SEND PACKET:C103($doc; "type_emission"+";")
	SEND PACKET:C103($doc; "ni_type"+Char:C90(Retour à la ligne:K15:40))
	ALL RECORDS:C47([EMETTEURS:12])
	While (Not:C34(End selection:C36([EMETTEURS:12])))
		SEND PACKET:C103($doc; [EMETTEURS:12]id_emetteur:2+";")
		SEND PACKET:C103($doc; [EMETTEURS:12]adresse_ip:3+";")
		SEND PACKET:C103($doc; [EMETTEURS:12]id_uf:4+";")
		SEND PACKET:C103($doc; [EMETTEURS:12]type_emission:5+";")
		SEND PACKET:C103($doc; [EMETTEURS:12]ni_type:6+Char:C90(Retour à la ligne:K15:40))
		NEXT RECORD:C51([EMETTEURS:12])
	End while 
	
	CLOSE DOCUMENT:C267($doc)
End if 

$doc:=Create document:C266($cheminDossier+"DEPENDANCES_EMETTEURS.CSV"; ".csv")
If (OK=1)
	SEND PACKET:C103($doc; "id_emetteur_pere"+";")
	SEND PACKET:C103($doc; "id_emetteur_fils"+Char:C90(Retour à la ligne:K15:40))
	CLOSE DOCUMENT:C267($doc)
End if 

$doc:=Create document:C266($cheminDossier+"PAGERS.CSV"; ".csv")
If (OK=1)
	SEND PACKET:C103($doc; "id_pager"+";")
	SEND PACKET:C103($doc; "acquittement"+";")
	SEND PACKET:C103($doc; "id_appartenance_pager"+";")
	SEND PACKET:C103($doc; "frequence"+";")
	SEND PACKET:C103($doc; "bitrate"+";")
	SEND PACKET:C103($doc; "e_message"+Char:C90(Retour à la ligne:K15:40))
	ALL RECORDS:C47([PAGERS:14])
	While (Not:C34(End selection:C36([PAGERS:14])))
		SEND PACKET:C103($doc; [PAGERS:14]id_pager:2+";")
		SEND PACKET:C103($doc; [PAGERS:14]acquittement:3+";")
		SEND PACKET:C103($doc; [PAGERS:14]id_appartenance_pager:4+";")
		SEND PACKET:C103($doc; [PAGERS:14]frequence:5+";")
		SEND PACKET:C103($doc; [PAGERS:14]bitrate:6+";")
		SEND PACKET:C103($doc; [PAGERS:14]e_message:7+Char:C90(Retour à la ligne:K15:40))
		NEXT RECORD:C51([PAGERS:14])
	End while 
	CLOSE DOCUMENT:C267($doc)
End if 


$doc:=Create document:C266($cheminDossier+"DEPENDANCES_PAGERS_EMETTEURS.CSV"; ".csv")
If (OK=1)
	SEND PACKET:C103($doc; "id_emetteur"+";")
	SEND PACKET:C103($doc; "id_pager"+Char:C90(Retour à la ligne:K15:40))
	ALL RECORDS:C47([DEPENDANCES_PAGERS_EMETTEURS:15])
	While (Not:C34(End selection:C36([DEPENDANCES_PAGERS_EMETTEURS:15])))
		SEND PACKET:C103($doc; [DEPENDANCES_PAGERS_EMETTEURS:15]id_emetteur:2+";")
		SEND PACKET:C103($doc; [DEPENDANCES_PAGERS_EMETTEURS:15]id_pager:3+Char:C90(Retour à la ligne:K15:40))
		NEXT RECORD:C51([DEPENDANCES_PAGERS_EMETTEURS:15])
	End while 
	CLOSE DOCUMENT:C267($doc)
End if 
