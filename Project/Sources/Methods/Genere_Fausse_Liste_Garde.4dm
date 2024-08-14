//%attributes = {}
$dateDeb:=!2023-10-01!
$dateFin:=!2023-11-07!
$date:=$dateDeb

ALL RECORDS:C47([LISTE_GARDE:44])
DELETE SELECTION:C66([LISTE_GARDE:44])

While ($date<=$dateFin)
	ALL RECORDS:C47([UF:5])
	While (Not:C34(End selection:C36([UF:5])))
		QUERY:C277([AFFECTATIONS:3]; [AFFECTATIONS:3]id_uf:4=[UF:5]id_uf:5; *)
		QUERY:C277([AFFECTATIONS:3]; [AFFECTATIONS:3]type:5="AFFECTATION_OPERATIONNELLE"; *)
		QUERY:C277([AFFECTATIONS:3]; [AFFECTATIONS:3]id_agent:3#"@-2")  // on ne veut pas les PATS
		FIRST RECORD:C50([AFFECTATIONS:3])
		ORDER BY:C49([AFFECTATIONS:3]; [AFFECTATIONS:3]id_agent:3; >)
		$nbEnre:=(Records in selection:C76([AFFECTATIONS:3])\2)-1
		For ($i; 1; $nbEnre)
			$pos:=Position:C15("-"; [AFFECTATIONS:3]id_agent:3)
			CREATE RECORD:C68([LISTE_GARDE:44])
			[LISTE_GARDE:44]date_debut:4:="2023-"+String:C10(Month of:C24($date); "00")+"-"+String:C10(Day of:C23($date); "00")+"T05:00+02:00"
			$jourApres:=Add to date:C393($date; 0; 0; 1)
			[LISTE_GARDE:44]date_fin:5:="2023-"+String:C10(Month of:C24($jourApres); "00")+"-"+String:C10(Day of:C23($jourApres); "00")+"T05:00+02:00"
			[LISTE_GARDE:44]delete:7:=False:C215
			[LISTE_GARDE:44]etat_disponibilite:3:="D0"
			[LISTE_GARDE:44]etat_situation:8:="PRET"
			[LISTE_GARDE:44]id_uf:6:=[UF:5]id_uf:5
			[LISTE_GARDE:44]matricule:2:=Substring:C12([AFFECTATIONS:3]id_agent:3; 1; $pos-1)
			If (Substring:C12([AFFECTATIONS:3]id_agent:3; $pos+1)="0")
				[LISTE_GARDE:44]statut:9:="SPV"
			Else 
				[LISTE_GARDE:44]statut:9:="SPP"
			End if 
			SAVE RECORD:C53([LISTE_GARDE:44])
			NEXT RECORD:C51([AFFECTATIONS:3])
			NEXT RECORD:C51([AFFECTATIONS:3])  // on fait 2 fois pour éviter les SPP en double statut
		End for 
		NEXT RECORD:C51([UF:5])
	End while 
	
	
	$date:=Add to date:C393($date; 0; 0; 1)
End while 
