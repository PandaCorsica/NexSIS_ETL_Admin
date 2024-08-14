//%attributes = {}
// on va traiter les crss qui doivent passer en paie

QUERY:C277([DONNEES_INTERS:158]; [DONNEES_INTERS:158]ligne:2#""; *)
QUERY:C277([DONNEES_INTERS:158]; [DONNEES_INTERS:158]numeroRenfort:7=10; *)
QUERY:C277([DONNEES_INTERS:158]; [DONNEES_INTERS:158]traite:5=False:C215)

If (Records in selection:C76([DONNEES_INTERS:158])#0)
	
	$date:=String:C10(Current date:C33; Interne date court:K1:7)
	$heure:=String:C10(Current time:C178; h mn s:K7:1)
	$YYMMDD:=Substring:C12($date; 9)+Substring:C12($date; 4; 2)+Substring:C12($date; 1; 2)
	$HHMMSS:=Replace string:C233($heure; ":"; "")
	
	$nomDossier:="CRSS_SIS2A_"+$YYMMDD+"-"+$HHMMSS
	$cheminDossier:=Get 4D folder:C485(Dossier Resources courant:K5:16)+$nomDossier+Séparateur dossier:K24:12
	//$cheminDossier:=Dossier 4D(Dossier données)+$nomDossier
	//CRÉER DOSSIER($cheminDossier; *)
	$result:=Folder:C1567("/RESOURCES/"+$nomDossier).create()
	$doc:=Create document:C266($cheminDossier+"CRSS"+"_"+$YYMMDD+"-"+$HHMMSS+".txt"; ".txt")
	USE CHARACTER SET:C205("iso-8859-1"; 0)
	
	ORDER BY:C49([DONNEES_INTERS:158]; [DONNEES_INTERS:158]numInter:4; >; [DONNEES_INTERS:158]codeUF:3; >)
	$totalData:=Records in selection:C76([DONNEES_INTERS:158])
	$compteur:=0
	While (Not:C34(End selection:C36([DONNEES_INTERS:158])))
		$compteur:=$compteur+1
		SEND PACKET:C103($doc; [DONNEES_INTERS:158]ligne:2)
		If ($compteur#$totalData)
			SEND PACKET:C103($doc; Char:C90(Retour chariot:K15:38)+Char:C90(Retour à la ligne:K15:40))
		End if 
		NEXT RECORD:C51([DONNEES_INTERS:158])
	End while 
	CLOSE DOCUMENT:C267($doc)
	USE CHARACTER SET:C205(*; 0)
	APPLY TO SELECTION:C70([DONNEES_INTERS:158]; [DONNEES_INTERS:158]traite:5:=True:C214)
	
End if 
