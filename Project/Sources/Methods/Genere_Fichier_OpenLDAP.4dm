//%attributes = {}
$date:=String:C10(Current date:C33; Interne date court:K1:7)
$heure:=String:C10(Current time:C178; h mn s:K7:1)
$YYMMDD:=Substring:C12($date; 9)+Substring:C12($date; 4; 2)+Substring:C12($date; 1; 2)
$HHMMSS:=Replace string:C233($heure; ":"; "")


$doc2:=Create document:C266(Get 4D folder:C485(Dossier base:K5:14)+"SIS2A_"+$YYMMDD+"-"+$HHMMSS+"_"+"ANNUAIRE.CSV"; ".csv")
If (OK=1)
	SEND PACKET:C103($doc2; "sn"+";")
	SEND PACKET:C103($doc2; "givenName"+";")
	//ENVOYER PAQUET($doc2; "centre"+";")
	SEND PACKET:C103($doc2; "uid"+";")
	SEND PACKET:C103($doc2; "cn"+";")
	SEND PACKET:C103($doc2; "idIndividu"+";")
	SEND PACKET:C103($doc2; "userPassword"+Char:C90(Retour à la ligne:K15:40))
	
	ALL RECORDS:C47([INDIVIDUS:1])
	$total:=Records in selection:C76([INDIVIDUS:1])
	$compt:=0
	While (Not:C34(End selection:C36([INDIVIDUS:1])))
		$compt:=$compt+1
		SEND PACKET:C103($doc2; Capitalize_First_Only([INDIVIDUS:1]nom_patronymique:4)+";")
		SEND PACKET:C103($doc2; Capitalize_First_Only([INDIVIDUS:1]prenom:5)+";")
		QUERY:C277([AGENTS:2]; [AGENTS:2]matricule:5=[INDIVIDUS:1]Matricule:10)
		//CHERCHER([AFFECTATIONS]; [AFFECTATIONS]type="AFFECTATION_ADMINISTRATIVE"; *)
		//CHERCHER([AFFECTATIONS]; [AFFECTATIONS]id_agent=[AGENTS]id_agent)
		//ENVOYER PAQUET($doc2; [AFFECTATIONS]id_uf+";")
		SEND PACKET:C103($doc2; [AGENTS:2]id_connexion:4+";")
		SEND PACKET:C103($doc2; Capitalize_First_Only([INDIVIDUS:1]prenom:5)+" "+Capitalize_First_Only([INDIVIDUS:1]nom_patronymique:4)+";")
		SEND PACKET:C103($doc2; [INDIVIDUS:1]id_individu:2+";")
		SEND PACKET:C103($doc2; [INDIVIDUS:1]password:11)
		If ($compt<$total)
			SEND PACKET:C103($doc2; Char:C90(Retour à la ligne:K15:40))
		End if 
		NEXT RECORD:C51([INDIVIDUS:1])
	End while 
	CLOSE DOCUMENT:C267($doc2)
End if 
