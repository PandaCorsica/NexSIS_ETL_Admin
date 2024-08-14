//%attributes = {}
$erreur:=False:C215
$cheminDossier:=$1

$date:=String:C10(Current date:C33; Interne date court:K1:7)
$heure:=String:C10(Current time:C178; h mn s:K7:1)
$YYMMDD:=Substring:C12($date; 9)+Substring:C12($date; 4; 2)+Substring:C12($date; 1; 2)
$HHMMSS:=Replace string:C233($heure; ":"; "")

$doc2:=Create document:C266($cheminDossier+"AFFECTATIONS.CSV"; ".csv")
If (OK=1)
	SEND PACKET:C103($doc2; "id_affectation"+";")
	SEND PACKET:C103($doc2; "id_agent"+";")
	SEND PACKET:C103($doc2; "id_uf"+";")
	SEND PACKET:C103($doc2; "type"+";")
	SEND PACKET:C103($doc2; "date_debut"+";")
	SEND PACKET:C103($doc2; "date_fin"+Char:C90(Retour à la ligne:K15:40))
	
	QUERY BY FORMULA:C48([AFFECTATIONS:3]; Length:C16([AFFECTATIONS:3]id_agent:3)<1)
	DELETE SELECTION:C66([AFFECTATIONS:3])
	QUERY BY FORMULA:C48([AFFECTATIONS:3]; Substring:C12([AFFECTATIONS:3]id_affectation:2; 1; 1)="_")
	DELETE SELECTION:C66([AFFECTATIONS:3])
	
	ALL RECORDS:C47([AFFECTATIONS:3])
	While (Not:C34(End selection:C36([AFFECTATIONS:3])))
		If ([AFFECTATIONS:3]id_uf:4="") | ([AFFECTATIONS:3]id_agent:3="0@")
			//TRACE
		Else 
			SEND PACKET:C103($doc2; [AFFECTATIONS:3]id_affectation:2+";")
			SEND PACKET:C103($doc2; [AFFECTATIONS:3]id_agent:3+";")
			SEND PACKET:C103($doc2; [AFFECTATIONS:3]id_uf:4+";")
			SEND PACKET:C103($doc2; [AFFECTATIONS:3]type:5+";")
			SEND PACKET:C103($doc2; [AFFECTATIONS:3]date_debut:6+";")
			SEND PACKET:C103($doc2; [AFFECTATIONS:3]date_fin:7+Char:C90(Retour à la ligne:K15:40))
		End if 
		NEXT RECORD:C51([AFFECTATIONS:3])
	End while 
	CLOSE DOCUMENT:C267($doc2)
	
	
	
End if 

$0:=$erreur

