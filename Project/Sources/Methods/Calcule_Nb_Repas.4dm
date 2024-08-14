//%attributes = {}
C_TEXT:C284($1; $typeGarde)
$typeGarde:=$1

C_TEXT:C284($2; $nomCentre)
$nomCentre:=$2

C_LONGINT:C283($3; $TS_Debut)
$TS_Debut:=$3

C_LONGINT:C283($4; $TS_FinTheorique)
$TS_FinTheorique:=$4


C_LONGINT:C283($0; $nbRepas)


$nbRepas:=0

Case of 
	: ($typeGarde="SHR") | ($typeGarde="HR") | ($typeGarde="nan") | ($typeGarde="None") | ($typeGarde="EX") | ($typeGarde="CDT") | ($typeGarde="AC") | ($typeGarde="GS") | ($typeGarde="RG") | ($typeGarde="DPS") | ($typeGarde="A")
		//  aucun repas payé sur ces types d'activité
	: ($nomCentre="AJA")
		// aucun repas payé
	: ($nomCentre="HBE")
		// aucun repas payé
	: ($nomCentre="POV") & ($typeGarde#"FDF")
		//repas uniquement payé sur les gardes FDF
	: ($typeGarde="SPP")
		// SPP donc aucun repas payé
	: ($typeGarde#"FDF") & ($typeGarde#"GR") & ($typeGarde#"G") & ($typeGarde#"GC") & ($typeGarde#"GCO")
		// aucun repas payé
		
	Else 
		//calcul des TimeStamp des heures de repas
		Repeat 
			$TS_Fin:=$TS_Debut+(12*3600)
			If ($TS_Fin>$TS_FinTheorique)
				$TS_Fin:=$TS_FinTheorique
			End if 
			$TS_Midi:=4DStmp_Write(TS_Vers_Date($TS_Debut); ?12:00:00?)
			$TS_13h:=4DStmp_Write(TS_Vers_Date($TS_Debut); ?13:00:00?)
			
			$TS_20h:=4DStmp_Write(TS_Vers_Date($TS_Debut); ?20:00:00?)
			$TS_21h:=4DStmp_Write(TS_Vers_Date($TS_Debut); ?21:00:00?)
			
			If ($TS_Debut<=$TS_Midi) & ($TS_Fin>=$TS_13h)
				$nbRepas:=$nbRepas+1
			End if 
			
			If ($TS_Debut<=$TS_20h) & ($TS_Fin>=$TS_21h)
				$nbRepas:=$nbRepas+1
			End if 
			$TS_Debut:=$TS_Debut+(12*3600)
		Until ($TS_Debut>=$TS_FinTheorique)
End case 
$0:=$nbRepas
