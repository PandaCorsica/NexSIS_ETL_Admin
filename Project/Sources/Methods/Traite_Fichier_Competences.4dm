//%attributes = {}
$erreur:=False:C215
$cheminDossier:=$1

$date:=String:C10(Current date:C33; Interne date court:K1:7)
$heure:=String:C10(Current time:C178; h mn s:K7:1)
$YYMMDD:=Substring:C12($date; 9)+Substring:C12($date; 4; 2)+Substring:C12($date; 1; 2)
$HHMMSS:=Replace string:C233($heure; ":"; "")

$doc3:=Create document:C266($cheminDossier+"COMPETENCES.CSV"; ".csv")

If (OK=1)
	
	SEND PACKET:C103($doc3; "id_affectation"+";")
	SEND PACKET:C103($doc3; "id_competence"+Char:C90(Retour à la ligne:K15:40))
	
	ALL RECORDS:C47([COMPETENCES:4])
	While (Not:C34(End selection:C36([COMPETENCES:4])))
		SEND PACKET:C103($doc3; [COMPETENCES:4]id_affectation:2+";")
		SEND PACKET:C103($doc3; [COMPETENCES:4]competence:3+Char:C90(Retour à la ligne:K15:40))
		
		NEXT RECORD:C51([COMPETENCES:4])
	End while 
	CLOSE DOCUMENT:C267($doc3)
	
End if 

$0:=$erreur
