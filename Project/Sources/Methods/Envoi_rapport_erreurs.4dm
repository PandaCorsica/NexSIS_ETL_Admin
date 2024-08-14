//%attributes = {}
ALL RECORDS:C47([ENVOI_RAPPORTS:181])
CRSS_Pre_Traitement
While (Not:C34(End selection:C36([ENVOI_RAPPORTS:181])))
	$valTest:=(Teste_Jour_Envoi | (Day of:C23(Current date:C33(*))=1))
	If ($valTest)
		$fichier:=CRSS_Cree_Rapport_Erreurs([ENVOI_RAPPORTS:181]codeCentre:2)
		$result:=Envoi_mail([ENVOI_RAPPORTS:181]mail:3; $fichier+".xlsx")
		If ($result)  // s'il n'y a pas eu d'erreur d'envoi
			//SUPPRIMER DOCUMENT($fichier+".xlsx")
		End if 
	End if 
	NEXT RECORD:C51([ENVOI_RAPPORTS:181])
End while 
